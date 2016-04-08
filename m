Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E1EF97CA7
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 17:47:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5FF4FAC001
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 15:47:08 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tAr0jdVr5ClR9LgO for <xfs@oss.sgi.com>;
	Fri, 08 Apr 2016 15:47:05 -0700 (PDT)
Date: Sat, 9 Apr 2016 08:46:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
	after disk failure/recovery
Message-ID: <20160408224648.GD567@dastard>
References: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
	<20160322121922.GA53693@bfoster.bfoster>
	<232dd85fde11d4ef1625f070eabfd167@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <232dd85fde11d4ef1625f070eabfd167@mail.gmail.com>
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
To: Shyam Kaushik <shyam@zadarastorage.com>
Cc: Brian Foster <bfoster@redhat.com>, Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On Fri, Apr 08, 2016 at 04:21:02PM +0530, Shyam Kaushik wrote:
> Hi Dave, Brian, Carlos,
> 
> While trying to reproduce this issue I have been running into different
> issues that are similar. Underlying issue remains the same when backend to
> XFS is failed & we unmount XFS, we run into hung-task timeout (180-secs)
> with stack like
> 
> kernel: [14952.671131]  [<ffffffffc06a5f59>]
> xfs_ail_push_all_sync+0xa9/0xe0 [xfs]
> kernel: [14952.671139]  [<ffffffff810b26b0>] ?
> prepare_to_wait_event+0x110/0x110
> kernel: [14952.671181]  [<ffffffffc0690111>] xfs_unmountfs+0x61/0x1a0
> [xfs]
> 
> while running trace-events, XFS ail push keeps looping around
> 
>    xfsaild/dm-10-21143 [001] ...2 17878.555133: xfs_ilock_nowait: dev
> 253:10 ino 0x0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]

Looks like either a stale inode (which should never reach the AIL)
or it's an inode that's been reclaimed and this is a use after free
situation. Given that we are failing IOs here, I'd suggest it's more
likely to be an IO failure that's caused a writeback problem, not an
interaction with stale inodes.

So, look at xfs_iflush. If an IO fails, it is supposed to unlock the
inode by calling xfs_iflush_abort(), which will also remove it from
the AIL. This can also happen on reclaim of a dirty inode, and if so
we'll still reclaim the inode because reclaim assumes xfs_iflush()
cleans up properly.

Which, apparently, it doesn't:

        /*
         * Get the buffer containing the on-disk inode.
         */
        error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK, 0);
        if (error || !bp) {
                xfs_ifunlock(ip);
                return error;
        }

This looks like a bug - xfs_iflush hasn't aborted the inode
writeback on failure - it's just unlocked the flush lock. Hence it
has left the inode dirty in the AIL, and then the inode has probably
then been reclaimed, setting the inode number to zero.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
