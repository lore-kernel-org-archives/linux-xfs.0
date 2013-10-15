Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D62877F3F
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 08:45:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51D3DAC006
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 06:45:37 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 15 Oct 2013 21:45:27 +0800
Message-ID: <CAMg3XqqJgxnc2+ZkuMaK9RC1_Basfh9AzcqCpNdvmPpCXgNHZg@mail.gmail.com>
Subject: xfs corruption - structure need cleaning
From: Roy Zhang <royzhangzzl@gmail.com>
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
To: xfs-masters <xfs-masters@oss.sgi.com>, xfs <xfs@oss.sgi.com>

Hi,
I met a problem that cannot mount xfs, log as below.
I got know xfs_repair -L will fix this situation, I want to know how
and why cause it, it's a bug in xfs or hdd? Is there any patch to fix
it?

Thanks
Roy

Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.232985] XFS
(dm-3): Mounting Filesystem
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.327773] XFS
(dm-3): Internal error xlog_clear_stale_blocks(2) at line 1353 of file
fs/xfs/xfs_log_recover.c.  Caller 0xffffffffa01f894d
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.327776]
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400435] Pid:
20055, comm: mount Not tainted 2.6.32-902.279.9.1.letv.el6.x86_64 #1
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400437] Call Trace:
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400477]
[<ffffffffa01e0f1f>] ? xfs_error_report+0x3f/0x50 [xfs]
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400503]
[<ffffffffa01f894d>] ? xlog_find_tail+0x38d/0x3c0 [xfs]
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400526]
[<ffffffffa01f5266>] ? xlog_clear_stale_blocks+0x156/0x190 [xfs]
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400549]
[<ffffffffa01f894d>] ? xlog_find_tail+0x38d/0x3c0 [xfs]
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400570]
[<ffffffffa01f899e>] ? xlog_recover+0x1e/0x90 [xfs]
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400592]
[<ffffffffa01f04dc>] ? xfs_log_mount+0xac/0x190 [xfs]
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400615]
[<ffffffffa01fbb8b>] ? xfs_mountfs+0x36b/0x680 [xfs]
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400640]
[<ffffffffa02137b4>] ? xfs_fs_fill_super+0x234/0x360 [xfs]
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400647]
[<ffffffff811ed4ca>] ? disk_name+0xba/0xc0
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400653]
[<ffffffff8117e54e>] ? get_sb_bdev+0x18e/0x1d0
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400675]
[<ffffffffa0213580>] ? xfs_fs_fill_super+0x0/0x360 [xfs]
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400698]
[<ffffffffa02113a8>] ? xfs_fs_get_sb+0x18/0x20 [xfs]
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400703]
[<ffffffff8117dfdb>] ? vfs_kern_mount+0x7b/0x1b0
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400707]
[<ffffffff8117e182>] ? do_kern_mount+0x52/0x130
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400713]
[<ffffffff8119c852>] ? do_mount+0x2d2/0x8d0
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400719]
[<ffffffff81136014>] ? strndup_user+0x64/0xc0
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400723]
[<ffffffff8119cee0>] ? sys_mount+0x90/0xe0
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400730]
[<ffffffff8100b0f2>] ? system_call_fastpath+0x16/0x1b
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400734] XFS
(dm-3): failed to locate log tail
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400737] XFS
(dm-3): log mount/recovery failed: error 117
Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400816] XFS
(dm-3): log mount failed

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
