Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ED8C87F54
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 17:45:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B346630405F
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 15:45:09 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	MJvlyXfGDA1q9Ecg for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2015 15:45:06 -0700 (PDT)
Date: Thu, 20 Aug 2015 08:44:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: v5 filesystem corruption due to log recovery lsn ordering
Message-ID: <20150819224453.GL3902@dastard>
References: <20150819183904.GB49174@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150819183904.GB49174@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 19, 2015 at 02:39:05PM -0400, Brian Foster wrote:
> Hi all,
> 
> Here's another issue I've run into from recent log recovery testing...
> 
> Many on-disk data structures for v5 filesystems have the LSN from the
> last modification stamped the associated header. As of the following
> commit, log recovery compares the recovery item LSN against the LSN of
> the on-disk structure to avoid restoration of stale contents:
> 
>   50d5c8d xfs: check LSN ordering for v5 superblocks during recovery
> 
> This presumably addresses some problems where recovery of the stale
> contents leads to CRC failure. The problem here is that xfs_repair
> clears the log (even when the fs is clean) and resets the current LSN on
> the next mount. This creates a situation where logging is ineffective
> for any structure that has not yet been modified since the current LSN
> was reset.

Well, that was a bit of an oversight...

....

> 
> The larger question is how to resolve this problem? I don't think this
> is something that is ultimately addressed in xfs_repair. Even if we
> stopped clearing the log, that doesn't help users who might have had to
> forcibly zero the log to recover a filesystem. Another option in theory
> might be to unconditionally reset the LSN of everything on disk, but
> that sounds like overkill just to preserve the current kernel
> workaround.

Well, it's relatively easy to detect a log that has been zeroed if
the cycle count is more than a cycle or two lower than the LSN in
important metadata, but I'm not sure we can reliably detect that.

> It sounds more to me that we have to adjust this behavior on the kernel
> side. That said, the original commit presumably addresses some log
> recovery shutdown problems that we do not want to reintroduce. I haven't
> yet wrapped my head around what that original problem was, but I wanted
> to get this reported. If the issue was early buffer I/O submission,
> perhaps we need a new mechanism to defer this I/O submission until a
> point that CRC verification is expected to pass (or otherwise generate a
> filesystem error)? Or perhaps do something similar with CRC
> verification? Any other thoughts, issues or things I might have missed
> here?

The issue that the LSN ordering fixes is that of unsynchronised
recovery of different log records that contain the same objects.
e.g. ordering of inode chunk allocation (in buffers) vs inode object
modification (in inode items). v4 filesystems have a serious problem
where inode chunk allocation can be run after the inode item
modifications, resulting in recovery "losing" file size updates that
sync flushed to the log.

i.e. create just the right number of small files, sync, crash and
recovery gives a number of zero length files in certain inode chunks
because the ordering of item recovery was wrong.

Another problem with inode logging is the flushiter field, which is
used to try to avoid replaying changes in the log that have already
been flushed to disk. This could also lead to lost inode
modifications after a sync because the flushiter is reset to zero
after each time the inode item is recovered. This was mostly avoided
by logging all inode modifications and using delayed logging, but
could still occur...

There was a long history of these sorts of problems occurring (I
first analysed the inode allocation/inode item update failure mode
back in 2006), and I found several other possible issues like this
to do with the inode flushiter at the same time. I also suspected
that there were problems with directory recovery due to the same
inode item vs buffer item ordering issues, but could never pin them
down.

So the solution was to record the LSN of the last modification in
every item as it is written to disk, thereby ensuring we knew
exactly what transaction the item was last modified in. This means
we can skip modifications in transaction recovery that are already
on disk.

----

The first thing we need to do is not zero the log in xfs_repair when
the log is clean to minimise future exposure to this issue on
existing systems.

Then, on the kernel side, we need is a reliable way to detect that
the log head/tail pointers have been reset in the kernel. This means
we can - at minimum - issue a warning during log recovery that this
has been detected.

Finally, we need to work out how to handle recovery in the situation
that the log has been zeroed and the filesystem has a mix of new and
old, stale LSNs. I think the simplest way around this is not to
handle it in log recovery at all, but to avoid it altogether.

That is, when we find the log head/tail point to a zeroed log, we
pull the current LSN from, say, the superblock (and maybe other
metadata such as AG headers) and initialise the log head/tail to the
cycle number + some offset so that every new transaction is
guaranteed to have a cycle number more recent than any other LSN in
the filesystem and ordering is preserved, even if the log has been
zeroed.

This means dirty log recovery requires no changes at all, we only
need to change xlog_recover() to detect the empty, clean log and
set:

	l_curr_cycle
	l_curr_block
	l_last_sync_lsn
	l_tail_lsn
	reserve_head
	write_head

appropriately for the new cycle number we've given the log. This is
pretty much how it is already done in xlog_find_tail() with the
initialisation information coming from the log record found at the
head of the log - we're just making it up a different source. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
