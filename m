Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 226E37CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 18:07:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DA8758F8049
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 16:07:40 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Ci47wWi6caibUpVE for <xfs@oss.sgi.com>;
	Wed, 11 May 2016 16:07:37 -0700 (PDT)
Date: Thu, 12 May 2016 09:07:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 4.6-rc7 xfs circular locking dependency
Message-ID: <20160511230734.GY18496@dastard>
References: <57337140.3020905@sandisk.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <57337140.3020905@sandisk.com>
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
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: xfs@oss.sgi.com

On Wed, May 11, 2016 at 10:52:00AM -0700, Bart Van Assche wrote:
> Hi Dave,
> 
> While retesting the SRP initiator with xfstests on top of an XFS filesystem I
> hit the below call trace once. I do not expect that this is related to the SRP
> initiator changes I made. Please let me know if you need more information.

YALFP.(*)

It's a "problem" with the filesystem freeze protection when
interacting with emergency ENOSPC paths in the filesystem.
sb_start_intwrite() can block when a freeze is being progressed, and
hence on the surface this looks like a trivial ABBA deadlock
condition.

However, this *cannot deadlock* because the trigger for
sb_start_intwrite() to block is a change of state to
SB_FREEZE_COMPLETE, and that happens under a
down_write(sb->s_umount) context. i.e.:

int freeze_super(struct super_block *sb)
{
        int ret;

        atomic_inc(&sb->s_active);
        down_write(&sb->s_umount)
	.....

The XFS code that takes s_sync_lock here:

> nc_lock){+.+...}:
>        [<ffffffff810a4e70>] lock_acquire+0x60/0x80
>        [<ffffffff81582d2f>] mutex_lock_nested+0x5f/0x360
>        [<ffffffff811bba2d>] sync_inodes_sb+0xbd/0x1d0
>        [<ffffffffa0616963>] xfs_flush_inodes+0x23/0x30 [xfs]

Does:

        if (down_read_trylock(&sb->s_umount)) {
                sync_inodes_sb(sb);
                up_read(&sb->s_umount);
        }

So any attempt to freeze the filesystem is prevented /before/ XFS
tries to flush data in this ENOSPC path. And if a freeze is
alreadybeing processed, XFS will skip this path, thereby avoiding
the possibility of a ABBA deadlock between freeze and s_sync_lock.

>        [<ffffffffa060ea9f>] xfs_create+0x46f/0x5f0 [xfs]
>        [<ffffffffa0609f39>] xfs_generic_create+0x1b9/0x290 [xfs]
>        [<ffffffffa060a03f>] xfs_vn_mknod+0xf/0x20 [xfs]
>        [<ffffffffa060a07e>] xfs_vn_create+0xe/0x10 [xfs]
>        [<ffffffff8119af96>] vfs_create+0x76/0xd0
>        [<ffffffff8119f13e>] path_openat+0xc1e/0x10d0
>        [<ffffffff811a04d9>] do_filp_open+0x79/0xd0
>        [<ffffffff8118f636>] do_sys_open+0x116/0x1f0
>        [<ffffffff8118f769>] SyS_creat+0x19/0x20
>        [<ffffffff81585fe5>] entry_SYSCALL_64_fastpath+0x18/0xa8
> 
> nal#2){++++.+}:
>        [<ffffffff810a461f>] __lock_acquire+0x1b0f/0x1b20
>        [<ffffffff810a4e70>] lock_acquire+0x60/0x80
>        [<ffffffff8109edd5>] percpu_down_read+0x45/0x90
>        [<ffffffff81193172>] __sb_start_write+0xb2/0xf0
>        [<ffffffffa061838f>] xfs_trans_alloc+0x1f/0x40 [xfs]
>        [<ffffffffa060f4d0>] xfs_inactive_truncate+0x20/0x130 [xfs]
>        [<ffffffffa060fc9e>] xfs_inactive+0x1ae/0x1e0 [xfs]
>        [<ffffffffa0614e88>] xfs_fs_evict_inode+0xb8/0xc0 [xfs]
>        [<ffffffff811acc83>] evict+0xb3/0x180
>        [<ffffffff811acefc>] iput+0x14c/0x1e0
>        [<ffffffff811bbab5>] sync_inodes_sb+0x145/0x1d0
>        [<ffffffff811c23e0>] sync_inodes_one_sb+0x10/0x20
>        [<ffffffff81193bda>] iterate_supers+0xaa/0x100

And iterate_supers() does the same thing:

                down_read(&sb->s_umount);
                if (sb->s_root && (sb->s_flags & MS_BORN))
                        f(sb, arg);
                up_read(&sb->s_umount);

IOWs, freeze_super() cannot start/progress freeze state to the point
that it would cause a deadlock in this code path because we hold the
lock that freeze_super() requires to change the freeze state.

Cheers,

Dave.

(*) YALFP: Yet Another Lockdep False Positive
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
