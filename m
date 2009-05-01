Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n41KXV8p027412 for <xfs@oss.sgi.com>; Fri, 1 May 2009 15:33:32 -0500
Received: from mail-fx0-f177.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB1F51D042F8
	for <xfs@oss.sgi.com>; Fri,  1 May 2009 13:33:32 -0700 (PDT)
Received: from mail-fx0-f177.google.com (mail-fx0-f177.google.com
	[209.85.220.177]) by cuda.sgi.com with ESMTP id
	Als8ftV5hsujw3K4 for <xfs@oss.sgi.com>;
	Fri, 01 May 2009 13:33:32 -0700 (PDT)
Received: by fxm25 with SMTP id 25so2497056fxm.20
	for <xfs@oss.sgi.com>; Fri, 01 May 2009 13:33:31 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 2 May 2009 00:33:30 +0400
Message-ID: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
Subject: 2.6.30-rc4: xfs_fsr hangs
From: Alexander Beregalov <a.beregalov@gmail.com>
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
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Testers List <kernel-testers@vger.kernel.org>, xfs@oss.sgi.com

# xfs_db -r /dev/sdc1
xfs_db> frag
actual 23805, ideal 22890, fragmentation factor 3.84%
# xfs_fsr -v /dev/sdc1
/mnt/c start inode=0
ino=158
extents before:3 after:1 DONE ino=158

 then it hangs


INFO: task xfs_fsr:2403 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfs_fsr       D 00000000  4492  2403   1928
 f3cc9dec 00000046 00000001 00000000 f3cc9de8 ec976680 ec976900 f2d06a50
 ec976680 00000001 f2d06a50 f2d06a4c ffffffff f2d06a4c ec976680 f3cc9df4
 c0447892 f3cc9e20 c04498ad f3cc9e28 f2d06a50 f2d06a74 f3cc9e44 00000246
Call Trace:
 [<c0447892>] schedule+0x12/0x30
 [<c04498ad>] rwsem_down_failed_common+0x6d/0x180
 [<c04499dd>] rwsem_down_write_failed+0x1d/0x30
 [<c0449a2a>] call_rwsem_down_write_failed+0x6/0x8
 [<c026bfce>] ? xfs_ilock+0xee/0x100
 [<c013fcd6>] ? down_write_nested+0x76/0x90
 [<c026bfce>] ? xfs_ilock+0xee/0x100
 [<c026bfce>] xfs_ilock+0xee/0x100
 [<c0290fb4>] xfs_inactive+0x334/0x540
 [<c01b382b>] ? inotify_inode_is_dead+0x1b/0x80
 [<c029d4ef>] xfs_fs_clear_inode+0x1f/0x30
 [<c019b7bb>] clear_inode+0x8b/0x110
 [<c019bf06>] generic_delete_inode+0xe6/0x120
 [<c0449d86>] ? _spin_lock+0x66/0x70
 [<c019c09f>] generic_drop_inode+0x15f/0x230
 [<c02c0958>] ? _atomic_dec_and_lock+0x18/0x40
 [<c019b477>] iput+0x47/0x50
 [<c0198a4f>] dentry_iput+0x6f/0xc0
 [<c0198b74>] d_kill+0x24/0x50
 [<c019a03b>] dput+0x5b/0x120
 [<c018a892>] __fput+0x162/0x240
 [<c018a98f>] fput+0x1f/0x30
 [<c01873f7>] filp_close+0x47/0x70
 [<c018748c>] sys_close+0x6c/0xd0
 [<c0102e48>] sysenter_do_call+0x12/0x36
INFO: lockdep is turned off.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
