Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 12 Sep 2008 02:45:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8C9iWjt013089
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 02:44:33 -0700
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 0035C127AF2F
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 02:46:02 -0700 (PDT)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com with SMTP id Wny7aXED5AFhiBds for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 02:46:02 -0700 (PDT)
Date: Fri, 12 Sep 2008 11:45:59 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Locking Question
Message-ID: <20080912094559.GB17721@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

hi,

I have seen a lockdep warning about freeing a held lock in XFS when mounting a corrupted xfs image:

[ 3107.196539] XFS mounting filesystem loop0
[ 3107.213927] 
[ 3107.213936] =========================
[ 3107.214027] [ BUG: held lock freed! ]
[ 3107.214027] -------------------------
[ 3107.214027] mount/18967 is freeing memory cf724000-cf7241e7, with a lock still held there!
[ 3107.214027]  (&(&ip->i_lock)->mr_lock){----}, at: [<c039b4c5>] xfs_ilock+0x4f/0x67
[ 3107.214027] 2 locks held by mount/18967:
[ 3107.214027]  #0:  (&type->s_umount_key#21){----}, at: [<c0183201>] sget+0x1fe/0x336
[ 3107.214027]  #1:  (&(&ip->i_lock)->mr_lock){----}, at: [<c039b4c5>] xfs_ilock+0x4f/0x67
[ 3107.214027] 
[ 3107.214027] stack backtrace:
[ 3107.214027] Pid: 18967, comm: mount Not tainted 2.6.27-rc5-00361-g82a28c7 #86
[ 3107.214027]  [<c013dfbb>] debug_check_no_locks_freed+0xd6/0x115
[ 3107.214027]  [<c017ec0b>] kmem_cache_free+0x4a/0xbd
[ 3107.214027]  [<c039d42d>] ? xfs_idestroy+0x92/0x98
[ 3107.214027]  [<c039d42d>] xfs_idestroy+0x92/0x98
[ 3107.214027]  [<c039ba9c>] xfs_iget_core+0x2eb/0x48e
[ 3107.214027]  [<c039bca7>] xfs_iget+0x68/0xe1
[ 3107.214027]  [<c03ac73f>] xfs_mountfs+0x3e0/0x5d1
[ 3107.214027]  [<c013dee3>] ? trace_hardirqs_on+0xb/0xd
[ 3107.214027]  [<c013bae2>] ? lockdep_init_map+0x74/0x34a
[ 3107.214027]  [<c013bae2>] ? lockdep_init_map+0x74/0x34a
[ 3107.214027]  [<c01296dd>] ? init_timer+0x17/0x1a
[ 3107.214027]  [<c03c03c4>] xfs_fs_fill_super+0x1f3/0x393
[ 3107.214027]  [<c0183bc4>] get_sb_bdev+0xcd/0x10b
[ 3107.214027]  [<c016afe6>] ? kstrdup+0x2a/0x4c
[ 3107.214027]  [<c03be4ef>] xfs_fs_get_sb+0x13/0x15
[ 3107.214027]  [<c03c01d1>] ? xfs_fs_fill_super+0x0/0x393
[ 3107.214027]  [<c01837e7>] vfs_kern_mount+0x3b/0x76
[ 3107.214027]  [<c0183866>] do_kern_mount+0x32/0xba
[ 3107.214027]  [<c0196350>] do_new_mount+0x46/0x74
[ 3107.214027]  [<c01964f3>] do_mount+0x175/0x193
[ 3107.214027]  [<c013de9d>] ? trace_hardirqs_on_caller+0xf4/0x12f
[ 3107.214027]  [<c0166606>] ? __get_free_pages+0x1e/0x24
[ 3107.214027]  [<c07295d3>] ? lock_kernel+0x19/0x8c
[ 3107.214027]  [<c0196562>] ? sys_mount+0x51/0x9b
[ 3107.214027]  [<c0196575>] sys_mount+0x64/0x9b
[ 3107.214027]  [<c01038bd>] sysenter_do_call+0x12/0x31
[ 3107.214027]  =======================
[ 3107.220438] XFS: failed to read root inode

As far as I can see xfs_iget.c:xfs_iget_core() has several places
that seem problematic.

After line 228:

    228         if (lock_flags)
    229                 xfs_ilock(ip, lock_flags);
    230 
    231         if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
    232                 xfs_idestroy(ip);
    233                 xfs_put_perag(mp, pag);
    234                 return ENOENT;
    235         }

we might take the lock for ip and then call xfs_idestroy() which frees the lock,
as far as I can tell there should be an additional 

if (lock_flags)
	xfs_iunlock(ip, lock_flags)

inside the if to release the lock before we free the memory.

Some lines later we have a similar issue:

    243         if (radix_tree_preload(GFP_KERNEL)) {
    244                 xfs_idestroy(ip);
    245                 delay(1);
    246                 goto again;
    247         }

The lock is still taken and we call xfs_idestroy().

Some lines later, usually the BUG_ON triggers first, but there is a config option somewhere to remove
them to save some space, so we should also unlock ip as far as I can tell.

    255         if (unlikely(error)) {
    256                 BUG_ON(error != -EEXIST);
    257                 write_unlock(&pag->pag_ici_lock);
    258                 radix_tree_preload_end();
    259                 xfs_idestroy(ip);
    260                 XFS_STATS_INC(xs_ig_dup);
    261                 goto again;
    262         }


Since I am not familar with the XFS code at all it would be nice if someone can
confirm that this is correct or tell me to take another look at this :-)

Thanks, Eric
