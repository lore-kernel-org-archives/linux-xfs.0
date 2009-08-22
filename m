Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7MEhsTd255067 for <xfs@oss.sgi.com>; Sat, 22 Aug 2009 09:44:04 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1E8F150FD45
	for <xfs@oss.sgi.com>; Sat, 22 Aug 2009 07:44:35 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id kZpjENsCzOED7ayv for
	<xfs@oss.sgi.com>; Sat, 22 Aug 2009 07:44:35 -0700 (PDT)
Date: Sat, 22 Aug 2009 10:44:31 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.26.3 / loop-aes/xfs corruption?
Message-ID: <alpine.DEB.2.00.0908221040220.30321@p34.internal.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

On an older machine:

[2340962.903497] XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1545 of file
  fs/xfs/xfs_alloc.c.  Caller 0xc021ccd8
[2340962.903497] Pid: 24649, comm: mv Not tainted 2.6.26.3 #1
[2340962.903497]  [<c021bb94>] xfs_free_ag_extent+0x424/0x6f0
[2340962.903497]  [<c021ccd8>] xfs_free_extent+0xb8/0xe0
[2340962.903497]  [<c021ccd8>] xfs_free_extent+0xb8/0xe0
[2340962.903497]  [<c022e542>] xfs_bmap_finish+0xf2/0x170
[2340962.903497]  [<c024f345>] xfs_itruncate_finish+0x295/0x3f0
[2340962.903497]  [<c02687a8>] xfs_trans_ijoin+0x28/0x80
[2340962.903497]  [<c026d0b6>] xfs_inactive+0x476/0x510
[2340962.903497]  [<c0196ba8>] inotify_inode_is_dead+0x18/0x80
[2340962.903497]  [<c027b393>] xfs_fs_clear_inode+0x73/0xc0
[2340962.903497]  [<c018e059>] invalidate_inode_buffers+0x19/0xb0
[2340962.903497]  [<c017ef45>] clear_inode+0xa5/0x100
[2340962.903497]  [<c017fc48>] generic_delete_inode+0xb8/0xc0
[2340962.903497]  [<c017fdef>] iput+0x3f/0x50
[2340962.903497]  [<c0175f0a>] do_unlinkat+0xca/0x150
[2340962.903497]  [<c043e312>] __sched_text_start+0x1f2/0x4d0
[2340962.903497]  [<c016c071>] sys_write+0x41/0x70
[2340962.903497]  [<c0102fba>] syscall_call+0x7/0xb
[2340962.903497]  =======================
[2340962.903497] xfs_force_shutdown(loop0,0x8) called from line 4261 of file fs/
xfs/xfs_bmap.c.  Return address = 0xc022e5aa
[2340962.911473] Filesystem "loop0": Corruption of in-memory data detected.  Shu
tting down filesystem: loop0
[2340962.911473] Please umount the filesystem, and rectify the problem(s)
[2340964.670988] Filesystem "loop0": xfs_log_force: error 5 returned.
[2340969.808536] Filesystem "loop0": xfs_log_force: error 5 returned.
[2340999.869059] Filesystem "loop0": xfs_log_force: error 5 returned.
[2341029.864456] Filesystem "loop0": xfs_log_force: error 5 returned.
[2341059.857386] Filesystem "loop0": xfs_log_force: error 5 returned.
[2341089.848682] Filesystem "loop0": xfs_log_force: error 5 returned.
[2341119.840220] Filesystem "loop0": xfs_log_force: error 5 returned.

After a reboot and fsck, luckily only 2 files were moved to /lost+found, but
before with xfs_repair -n, there were hundreds of errors, had to zero out the
log as it could not mount, xfs_repair -L and then it worked/mounted.

Older kernel used: 2.6.26.3

Due to HW issues/etc, need to stay on 2.6.26.3 but has anyone seen this 
particular fail case before?

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
