Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Dec 2007 03:40:06 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBCBdXC5027549
	for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 03:39:34 -0800
Received: from mail.ukfsn.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8ACAC4717C3
	for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 03:39:40 -0800 (PST)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143]) by cuda.sgi.com with ESMTP id BIxELAARiZ5ljzKi for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 03:39:40 -0800 (PST)
Message-ID: <475FC878.4000709@dgreaves.com>
Date: Wed, 12 Dec 2007 11:39:36 +0000
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_btree_check_sblock
References: <475ED66F.40800@dgreaves.com> <20071211222546.GD4612@sgi.com> <475F2008.5030702@dgreaves.com> <20071212111202.GI4612@sgi.com>
In-Reply-To: <20071212111202.GI4612@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

David Chinner wrote:
> On Tue, Dec 11, 2007 at 11:40:56PM +0000, David Greaves wrote:
>> So is there anything else I should do?
> 
> Check the filesystem before repairing it.
yeah, OK :)

Well, it happened next boot. So:

haze:~# umount /scratch
haze:~# xfs_check /dev/video_vg/video_lv
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_check.  If you are unable to mount the filesystem, then use
the xfs_repair -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.
haze:~# mount /scratch
haze:~# umount /scratch
haze:~# xfs_check /dev/video_vg/video_lv
bad format 2 for inode 1435146910 type 0
ir_freecount/free mismatch, inode chunk 42/25860704, freecount 64 nfree 63
bad format 2 for inode 1435150526 type 0
ir_freecount/free mismatch, inode chunk 42/25864320, freecount 64 nfree 63
bad format 2 for inode 1435173822 type 0
ir_freecount/free mismatch, inode chunk 42/25887616, freecount 64 nfree 63
bad format 2 for inode 1984739518 type 0
ir_freecount/free mismatch, inode chunk 59/5027968, freecount 27 nfree 26
allocated inode 1435146910 has 0 link count
allocated inode 1435173822 has 0 link count
allocated inode 1435150526 has 0 link count
allocated inode 1984739518 has 0 link count
haze:~#

Filesystem "dm-0": XFS internal error xfs_btree_check_sblock at line 334 of file
fs/xfs/xfs_btree.c.  Caller 0xc01b7bc1
 [<c010511a>] show_trace_log_lvl+0x1a/0x30
 [<c0105d72>] show_trace+0x12/0x20
 [<c0105d95>] dump_stack+0x15/0x20
 [<c01dd34f>] xfs_error_report+0x4f/0x60
 [<c01cfcb6>] xfs_btree_check_sblock+0x56/0xd0
 [<c01b7bc1>] xfs_alloc_lookup+0x181/0x390
 [<c01b7e06>] xfs_alloc_lookup_ge+0x16/0x20
 [<c01b5e12>] xfs_alloc_ag_vextent_size+0x52/0x410
 [<c01b6c57>] xfs_alloc_ag_vextent+0x107/0x110
 [<c01b6e58>] xfs_alloc_fix_freelist+0x1f8/0x450
 [<c01b713c>] xfs_free_extent+0x8c/0xd0
 [<c01c1979>] xfs_bmap_finish+0x119/0x170
 [<c01e6f5a>] xfs_itruncate_finish+0x23a/0x3a0
 [<c020328d>] xfs_free_eofblocks+0x26d/0x2b0
 [<c0207de1>] xfs_release+0x171/0x270
 [<c020f216>] xfs_file_release+0x16/0x20
 [<c016ba2b>] __fput+0x9b/0x190
 [<c016bb88>] fput+0x18/0x20
 [<c0168ec7>] filp_close+0x47/0x80
 [<c016a3b7>] sys_close+0x87/0x110
 [<c010420a>] syscall_call+0x7/0xb
 =======================
xfs_force_shutdown(dm-0,0x8) called from line 4274 of file fs/xfs/xfs_bmap.c.
Return address = 0xc0214dae
Filesystem "dm-0": Corruption of in-memory data detected.  Shutting down
filesystem: dm-0


I've not yet run a repair...

David
