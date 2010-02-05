Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o152v5SY106759 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 20:57:06 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13992137DFB5
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 18:58:14 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	pU4cs6qm0Hs1YGUo for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2010 18:58:14 -0800 (PST)
Date: Fri, 5 Feb 2010 13:58:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH for-2.6.33] xfs: flush all log buffers in xlog_dealloc_log
Message-ID: <20100205025811.GB11483@discord.disaster>
References: <20100201220813.GA3519@infradead.org>
	<20100203105545.GA1047@infradead.org>
	<20100204081422.GF5332@discord.disaster>
	<20100204161050.GB11206@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100204161050.GB11206@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Feb 04, 2010 at 11:10:50AM -0500, Christoph Hellwig wrote:
> On Thu, Feb 04, 2010 at 07:14:22PM +1100, Dave Chinner wrote:
> > On Wed, Feb 03, 2010 at 05:55:45AM -0500, Christoph Hellwig wrote:
> > > Actually I'll take this one back - the log buffers aren't delwri
> > > so xfs_flush_buftarg probably only helped by timing or the
> > > xfs_buf_runall_queues on xfslogd_workqueue.  Need to think about
> > > this a bit more.
> > 
> > Can you point me at the bug report? IIRC I've seen this in the
> > past where we freed the log before we've done all the correct
> > shutdown processing and they got fixed by correcting the
> > order of shutdown to ensure the log is idle before freeing
> > it...
> 
> Yes, that I was going to look into next.  The recent report
> is http://bugzilla.kernel.org/show_bug.cgi?id=15150

That was from 2.6.27. I didn't think that we finished the
mount/unmount path cleanup that fixed all those problems until
2.6.28 or .29...

> and there's
> also a very similar one from Ed Cashin <ecashin@coraid.com> in
> mail archives from November.

Yeah, that's clearly IO completion after the call to
xfs_unmountfs_wait(). That does a xfs_wait_buftarg() call
which waits for all hashed buffers on the buftarg except for
those that are XBF_FS_MANAGED - the superblock.

Looking at xfs_fs_put_super(), the superblock buffer is freed after
xfs_unmountfs() frees the log, so if the superblock was logged
and is undergoing IO then xfs_unmountfs_wait() would not have
blocked on it and it could leak past the "no more IO should
bein progress" barrier that xfs_unmountfs_wait() is supposed to
provide.

Does this look like a plausible cause of the problem?

Is so, given that the superblock is the only buffer that is marked
XBF_FS_MANAGED now and it seems to me that xfs_wait_buftarg()
should be waiting on it, maybe the fix needed is to
xfs_wait_buftarg()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
