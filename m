Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 83A427F3F
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2013 18:58:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 70525304039
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2013 16:58:22 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	DnBZWXGBwjphI5Mv for <xfs@oss.sgi.com>;
	Wed, 06 Feb 2013 16:58:13 -0800 (PST)
Date: Thu, 7 Feb 2013 11:57:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/2] xfs: conditionally force log on trylock failure
	of pinned/stale buf
Message-ID: <20130207005725.GW2667@dastard>
References: <1360154681-28246-1-git-send-email-bfoster@redhat.com>
	<1360154681-28246-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1360154681-28246-2-git-send-email-bfoster@redhat.com>
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

On Wed, Feb 06, 2013 at 07:44:40AM -0500, Brian Foster wrote:
> xfs_force_log() is not safe from all contexts. Add a flag parameter
> to xfs_buf_trylock() to specify when the force is appropriate and
> create a macro to preserve current behavior.

Static inline functions are preferred over macros because they
provide type checking.....

However, here's what happens when I actually have time to think
about the problem at hand - I suggest a completely different fix.

Sorry, Brain, I'm not doing this intentionally to make your life
harder than it needs to be... :/

My logic (goes back to the history of changes that lead to the log
force being in xfs_buf_trylock()) is as follows:

	1. xfs_buf_lock() had the log force added originally because
	   _xfs_buf_find was getting stuck on locked, pinned stale
	   buffers. This was a result of the rework of the busy
	   extent handling to avoid synchronous transactions and/or
	   log forces when reusing recently freed blocks. Somewhere
	   a log force was needed to get the freeing transaction on
	   disk before reuse occurred, and that was done on demand
	   in xfs_buf_lock() when such a stale buffer was being
	   used after a subsequent allocation.

	2a. xfs_inode_item_push() used to flush inodes to the
	   the underlying buffer and would skip the flush if the
	   underlying buffer was locked. Hence pinned inodes could
	   not be flushed if the underlying buffer was locked (i.e.
	   when pinned and stale).

	2b. xfs_buf_item_push() would fail to lock the buffer if it
	   raced with pinning and do nothing.

	3. this resulted in neither xfs_inode_item_push() or
	   xfs_buf_item_push() telling the xfsaild to issue a log
	   force, the AIL would stop doing work as finished it's
	   traverse, and hence tranaction reservations stalled until
	   something else issued a log force and unpinned the tail
	   of the log.

	4. the simple and obvious fix at the time was to have
	   xfs_buf_trylock() do the same as xfs_buf_lock() and force
	   the log when a buffer in the state that caused the stall
	   was detected.

	<time passes>

	5a. delayed write buffers were reworked, completely changing
	   how inode flushing and hence xfs_inode_item_push()
	   worked.

	5b. delayed write buffers were reworked, changing how
	   xfs_buf_item_push() worked.

	6. several bugs in pinned/stale item handling were fixed,
	   and now both xfs_inode_item_push() and
	   xfs_buf_item_push() detect pinned inodes and buffers and
	   tell the xfsaild to force the log appropriately.  This
	   means xfs_buf_trylock() no longer needs to force the log
	   to provide a get-out-of-xfsaild-stall-free mechanism.

	7. This log force while holding the ail lock bug is discovered.

So what I'm thinking is that as a result of 5+6, we have no need for
the log force in the xfs_buf_trylock code any more. The only place
we actually care about locking latency any more is in
_xfs_buf_find(), and when the trylock fails there we immediately run
xfs_buf_lock() (unless XBF_TRYLOCK was set) and it will do the log
force for us.

IOWs, I think the log force code in xfs_buf_trylock() is simply
redundant and we should just remove it. With the second patch in
this series, racing on the buffer being pinned will now do the right
thing (i.e. trigger a log force via the xfsaild) and so we end up
both simplifying the code and fixing the bug....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
