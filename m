Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBVETKeb006882 for <xfs@oss.sgi.com>; Wed, 31 Dec 2008 08:29:21 -0600
Received: from isp.becroft.co.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DAFD55723
	for <xfs@oss.sgi.com>; Wed, 31 Dec 2008 06:29:19 -0800 (PST)
Received: from isp.becroft.co.nz (isp.becroft.co.nz [202.89.33.33]) by
	cuda.sgi.com with ESMTP id OAGpnPrF6ZgV70Co for
	<xfs@oss.sgi.com>; Wed, 31 Dec 2008 06:29:19 -0800 (PST)
Received: from server.ak.quickcircuit.co.nz (gateway.quickcircuit.co.nz
	[210.55.214.217])
	by isp.becroft.co.nz (8.12.11.20060308/8.12.9) with ESMTP id
	mBVE987w009973 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 03:09:09 +1300
Subject: XFS internal error when NFS client accesses nonexistent inode
From: Mario Becroft <mb@gem.win.co.nz>
Date: Thu, 01 Jan 2009 03:09:08 +1300
Message-ID: <87zlicfncr.fsf@server.ak.quickcircuit.co.nz>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs@oss.sgi.com

I hit a seemingly strange problem today when I xfsdump/restored some
filesystems from one volume onto another. When I exported the new
volumes, errors like the following started to occur:

Dec 31 09:12:46 nfs1 kernel: nfsd: non-standard errno: -117

Bumping up the XFS debug level revealed the following (full details at
the end):

Dec 31 09:12:46 nfs1 kernel: Filesystem "dm-17": XFS internal error xfs_imap_to_bp at line 186 of file fs/xfs/xfs_inode.c.  Caller 0xffffffff80374c48

xfs_check reported no error in the filesystem.

After wasting quite a lot of time, I finally realised that this was
probably caused by NFS clients accessing nonexistent file handles that
they had open from when the filesystem was previously exported, prior to
the dump/restore.

Is my analysis correct? Is an internal error the expected behaviour in
this case? And can this cause any harm?

While I am writing, two things I wish XFS could do, and two more that
would be jolly nice to have:

1. shrink filesystems
2. dump/restore preserving inode numbers
3. high-performance dump with multi-threaded reading to fully utilise
disk throughput
4. on-line xfs_check/repair

I wonder if anyone is working on those?

Full log output follows:

--8<---------------cut here---------------start------------->8---
Dec 31 09:12:46 nfs1 kernel: 00000000: f5 83 23 77 26 c5 70 43 bb bd 3d 44 c9 63 e2 b1  ..#w&.pC..=D.c..
Dec 31 09:12:46 nfs1 kernel: Filesystem "dm-17": XFS internal error xfs_imap_to_bp at line 186 of file fs/xfs/xfs_inode.c.  Caller 0xffffffff80374c48
Dec 31 09:12:46 nfs1 kernel: Pid: 4969, comm: nfsd Not tainted 2.6.27.4 #3
Dec 31 09:12:46 nfs1 kernel:
Dec 31 09:12:46 nfs1 kernel: Call Trace:
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80374c48>] xfs_itobp+0xa0/0xe7
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80374b82>] xfs_imap_to_bp+0xd6/0xfc
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80374c48>] xfs_itobp+0xa0/0xe7
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff8037439f>] xfs_imap+0x6a/0x135
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80374c48>] xfs_itobp+0xa0/0xe7
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80376eec>] xfs_iread+0x79/0x1ed
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80372687>] xfs_iget_core+0x2ea/0x54d
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff803729cc>] xfs_iget+0xe2/0x18a
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80390e1d>] xfs_nfs_get_inode+0x39/0x88
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80390f80>] xfs_fs_fh_to_dentry+0x64/0x97
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa031f53c>] exportfs_decode_fh+0x30/0x1dc [exportfs]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa0341449>] nfsd_acceptable+0x0/0xc7 [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa03456a7>] exp_find_key+0x96/0xa9 [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80228c88>] place_entity+0x9e/0xc7
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff8022b04d>] enqueue_task_fair+0x17e/0x1a7
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa034571d>] exp_find+0x63/0x6f [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa0340cf9>] fh_verify+0x278/0x546 [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff802285c3>] __wake_up_common+0x41/0x74
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa0341a0e>] nfsd_access+0x29/0xff [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa03495f4>] nfsd3_proc_access+0x99/0xa6 [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa033e23c>] nfsd_dispatch+0xde/0x1c2 [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa0202371>] svc_process+0x408/0x6eb [sunrpc]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80531407>] __down_read+0x12/0x8b
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa033e874>] nfsd+0x1ae/0x27a [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa033e6c6>] nfsd+0x0/0x27a [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff802463a6>] kthread+0x47/0x75
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff8020cd59>] child_rip+0xa/0x11
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff8024635f>] kthread+0x0/0x75
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff8020cd4f>] child_rip+0x0/0x11
Dec 31 09:12:46 nfs1 kernel:
Dec 31 09:12:46 nfs1 kernel: nfsd: non-standard errno: -117
Dec 31 09:12:46 nfs1 kernel: 00000000: f5 83 23 77 26 c5 70 43 bb bd 3d 44 c9 63 e2 b1  ..#w&.pC..=D.c..
Dec 31 09:12:46 nfs1 kernel: Filesystem "dm-17": XFS internal error xfs_imap_to_bp at line 186 of file fs/xfs/xfs_inode.c.  Caller 0xffffffff80374c48
Dec 31 09:12:46 nfs1 kernel: Pid: 4969, comm: nfsd Not tainted 2.6.27.4 #3
Dec 31 09:12:46 nfs1 kernel:
Dec 31 09:12:46 nfs1 kernel: Call Trace:
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80374c48>] xfs_itobp+0xa0/0xe7
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80374b82>] xfs_imap_to_bp+0xd6/0xfc
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80374c48>] xfs_itobp+0xa0/0xe7
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff8037439f>] xfs_imap+0x6a/0x135
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80374c48>] xfs_itobp+0xa0/0xe7
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80376eec>] xfs_iread+0x79/0x1ed
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80372687>] xfs_iget_core+0x2ea/0x54d
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff803729cc>] xfs_iget+0xe2/0x18a
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80390e1d>] xfs_nfs_get_inode+0x39/0x88
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80390f80>] xfs_fs_fh_to_dentry+0x64/0x97
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa031f53c>] exportfs_decode_fh+0x30/0x1dc [exportfs]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa0341449>] nfsd_acceptable+0x0/0xc7 [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa03456a7>] exp_find_key+0x96/0xa9 [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80228c88>] place_entity+0x9e/0xc7
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff8022b04d>] enqueue_task_fair+0x17e/0x1a7
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa034571d>] exp_find+0x63/0x6f [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa0340cf9>] fh_verify+0x278/0x546 [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff802285c3>] __wake_up_common+0x41/0x74
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa0341a0e>] nfsd_access+0x29/0xff [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa03495f4>] nfsd3_proc_access+0x99/0xa6 [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa033e23c>] nfsd_dispatch+0xde/0x1c2 [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa0202371>] svc_process+0x408/0x6eb [sunrpc]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff80531407>] __down_read+0x12/0x8b
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa033e874>] nfsd+0x1ae/0x27a [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffffa033e6c6>] nfsd+0x0/0x27a [nfsd]
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff802463a6>] kthread+0x47/0x75
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff8020cd59>] child_rip+0xa/0x11
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff8024635f>] kthread+0x0/0x75
Dec 31 09:12:46 nfs1 kernel:  [<ffffffff8020cd4f>] child_rip+0x0/0x11
Dec 31 09:12:46 nfs1 kernel:
Dec 31 09:12:46 nfs1 kernel: nfsd: non-standard errno: -117
--8<---------------cut here---------------end--------------->8---

-- 
Mario Becroft <mb@gem.win.co.nz>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
