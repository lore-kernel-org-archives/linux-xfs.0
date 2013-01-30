Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4D00D7F4E
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 00:06:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3C9978F8052
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 22:05:57 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	KXfgaN2ajUVIZuwO for <xfs@oss.sgi.com>;
	Tue, 29 Jan 2013 22:05:54 -0800 (PST)
Date: Wed, 30 Jan 2013 17:05:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC 0/2] fix spinlock recursion on xa_lock in
	xfs_buf_item_push
Message-ID: <20130130060551.GG7255@disturbed.disaster>
References: <1359492157-30521-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1359492157-30521-1-git-send-email-bfoster@redhat.com>
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

On Tue, Jan 29, 2013 at 03:42:35PM -0500, Brian Foster wrote:
> Hi all,
> 
> This patchset fixes a spinlock recursion we've reproduced initially on RHEL
> kernels[1]. The problem is that we issue an xfs_log_force() via
> xfs_buf_trylock() with the xa_lock held and ultimately drive down into
> xlog_assign_tail_lsn(), which attempts to reacquire xa_lock[2].
> 
> Note that this lockup was difficult to reproduce and I was not able to
> reproduce on an upstream kernel without a hack to comment out the pinned buf
> check in xfs_buf_item_push() (presumably because the log force itself only
> happens when the buf is pinned, so the window here is tight).
> 
> This patchset is what I'm testing to avoid the lockup, but I'm posting this RFC
> to get some early thoughts:
> 
> - Patch 1 - Creates a flag to conditionally force the log in xfs_buf_trylock().
>   The alternative I considered is to pull out the check and log force and
>   sprinkle that code amongst the trylock callers.
> - Patch 2 - Utilizes the flag created in patch 1 and duplicates the log force
>   in xfs_buf_item_push() after dropping xa_lock.
> 
> The change in patch 2 makes me wonder how important the immediate flush is in
> the context of xfsaild_push(), where we already pend up a flush if the item is
> pinned. IOWs, I wonder if replacing what I have now with something like the
> following would be acceptable and cleaner:
> 
> 	if (!__xfs_buf_trylock(bp, false)) {
> 		if (xfs_buf_ispinned(bp)
> 			return XFS_ITEM_PINNED;
> 		return XFS_ITEM_LOCKED;
> 	}
> 
> Thoughts appreciated.

I haven't had time to really think about this, but I'll say up front
that I don't really like the fix. The log force in xfs_buf_trylock()
was added here:

commit 90810b9e82a36c3c57c1aeb8b2918b242a130b26
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Nov 30 15:16:16 2010 +1100

    xfs: push stale, pinned buffers on trylock failures
    
    As reported by Nick Piggin, XFS is suffering from long pauses under
    highly concurrent workloads when hosted on ramdisks. The problem is
    that an inode buffer is stuck in the pinned state in memory and as a
    result either the inode buffer or one of the inodes within the
    buffer is stopping the tail of the log from being moved forward.
    
    The system remains in this state until a periodic log force issued
    by xfssyncd causes the buffer to be unpinned. The main problem is
    that these are stale buffers, and are hence held locked until the
    transaction/checkpoint that marked them state has been committed to
    disk. When the filesystem gets into this state, only the xfssyncd
    can cause the async transactions to be committed to disk and hence
    unpin the inode buffer.
    
    This problem was encountered when scaling the busy extent list, but
    only the blocking lock interface was fixed to solve the problem.
    Extend the same fix to the buffer trylock operations - if we fail to
    lock a pinned, stale buffer, then force the log immediately so that
    when the next attempt to lock it comes around, it will have been
    unpinned.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>

And the initial commit that introduced this dependency was this:

commit ed3b4d6cdc81e8feefdbfa3c584614be301b6d39
Author: Dave Chinner <david@fromorbit.com>
Date:   Fri May 21 12:07:08 2010 +1000

    xfs: Improve scalability of busy extent tracking
....
    The only problem with this approach is that when a metadata buffer is
    marked stale (e.g. a directory block is removed), then buffer remains
    pinned and locked until the log goes to disk. The issue here is that
    if that stale buffer is reallocated in a subsequent transaction, the
    attempt to lock that buffer in the transaction will hang waiting
    the log to go to disk to unlock and unpin the buffer. Hence if
    someone tries to lock a pinned, stale, locked buffer we need to
    push on the log to get it unlocked ASAP. Effectively we are trading
    off a guaranteed log force for a much less common trigger for log
    force to occur.
....

So essentially what is happening here is that we are trying to lock
a stale buffer in the AIL to flush it. Well, we can't flush it from
the AIL, and indeed the next line of code is this:

	if (!xfs_buf_trylock(bp))
		return XFS_ITEM_LOCKED;

>>>>>	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));

The only reason this ASSERT is not firing is that we are failing to
lock stale buffers. Hence we are relying on the failed lock to force
the log, instead of detecting that we need to force the log after we
drop the AIL lock and letting the caller handle it.

So, wouldn't a better solution be to do something like simply like:

+	if (bp->b_flags & XBF_STALE)
+		return XFS_ITEM_PINNED;
+
	if (!xfs_buf_trylock(bp))
		return XFS_ITEM_LOCKED;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
