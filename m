Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27119C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 07:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237958AbiAEHKz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 02:10:55 -0500
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:47342 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237956AbiAEHKz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 02:10:55 -0500
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 34EB16C0CB3
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 07:10:54 +0000 (UTC)
Received: from pdx1-sub0-mail-a305.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id E379E6C0DB8
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 07:10:53 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from pdx1-sub0-mail-a305.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.118.248.123 (trex/6.4.3);
        Wed, 05 Jan 2022 07:10:54 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Bubble-Continue: 62aab9e418d2d7e2_1641366654057_1191135143
X-MC-Loop-Signature: 1641366654057:3272490498
X-MC-Ingress-Time: 1641366654056
Received: from kmjvbox (c-98-207-114-56.hsd1.ca.comcast.net [98.207.114.56])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kjlx@templeofstupid.com)
        by pdx1-sub0-mail-a305.dreamhost.com (Postfix) with ESMTPSA id 4JTLHK3H7xz1PW
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 23:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=templeofstupid.com;
        s=templeofstupid.com; t=1641366653; bh=m1aneMTGvJWMtkR2bSFRpVXXx5s=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=Ss/4lvkNJ+884z3Shvm2qGcR+pgOoqatr9ddZppH/fxarjCBhKU2HUI1Nj331YNVo
         YRFuMqyFtQEIy2k4JqY6gtjPwhQ9PtAooarOT7Cbzn+LXUX71Y3GoqG4SINrvTCDSG
         gOyz04YMEXVoJO6rKaCA0bH9Siy4SvqI0+KIATG4=
Received: from johansen (uid 1000)
        (envelope-from kjlx@templeofstupid.com)
        id e0121
        by kmjvbox (DragonFly Mail Agent v0.9);
        Tue, 04 Jan 2022 23:10:52 -0800
Date:   Tue, 4 Jan 2022 23:10:52 -0800
From:   Krister Johansen <kjlx@templeofstupid.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>
Subject: xfs_bmap_extents_to_btree allocation warnings
Message-ID: <20220105071052.GD20464@templeofstupid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,
I've been running into occasional WARNs related to allocating a block to
hold the new btree that XFS is attempting to create when calling this
function.  The problem is sporadic -- once every 10-40 days and a
different system each time.

The process that's triggering the problem is dd punching a hole into
file via direct I/O.  It's doing this as part of a watchdog process to
ensure that the system remains able to issue read and write requests.
The direct I/O is an attempt to avoid reading/writing cached data from
this process.

I'm hardly an expert; however, after some digging it appears that the
direct I/O path for this particular workload is more susceptible to the
problem because its tp->t_firstblock is always set to a block in an
existing AG, while the rest of the I/O on this filesystem goes through
the page cache and uses the delayed allocation mechanism by default.
(IOW, t_firstblock is NULLFSBLOCK most of the time.)

Looking at the version history and mailing list archives for this
particular bit of code seem to indicate that this particular function
hasn't had a ton of churn.  The XFS_ALLOCTYPE_START_BNO vs
XFS_ALLOCTYPE_NEAR_BNO bits seem not to have changed much since they
were authored in the 90s.

I haven't yet been able to get a kdump to look into this WARN in more
detail, but I was curious if the rationale for using
XFS_ALLOCTYPE_NEAR_BNO still held true for modern linux based XFS?

It seemed like one reason for keeping the bmap and the inode in the same
AG might be that with 32-bit block pointers in an inode there wouldn't
be space to store the AG and the block if the btree were allocated in a
different AG.  It also seemed like there were lock order concerns when
iterating over multiple AGs.  However, linux is using 64-bit block
pointers in the inode now and the XFS_ALLOCTYPE_START_BNO case in
xfs_alloc_vextent() seems to try to ensure that it never considers an AG
that's less than the agno for the fsbno passed in via args.

Would something like this:

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4dccd4d90622..5d949ac1ecae 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -664,6 +664,13 @@ xfs_bmap_extents_to_btree(
 	if (error)
 		goto out_root_realloc;
 
+	if (args.fsbno == NULLFSBLOCK && args.type == XFS_ALLOCTYPE_NEAR_BNO) {
+		args.type = XFS_ALLOCTYPE_START_BNO;
+		error = xfs_alloc_vextent(&args);
+		if (error)
+			goto out_root_realloc;
+	}
+
 	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
 		error = -ENOSPC;
 		goto out_root_realloc;

Or this:

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4dccd4d90622..94e4ecb75561 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -647,14 +647,10 @@ xfs_bmap_extents_to_btree(
 	args.tp = tp;
 	args.mp = mp;
 	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
+	args.type = XFS_ALLOCTYPE_START_BNO;
 	if (tp->t_firstblock == NULLFSBLOCK) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
-	} else if (tp->t_flags & XFS_TRANS_LOWMODE) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		args.fsbno = tp->t_firstblock;
 	} else {
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.fsbno = tp->t_firstblock;
 	}
 	args.minlen = args.maxlen = args.prod = 1;

be a reasonable way to address the WARN?  Or does this open a box of
problems that obvious to the experienced, but just subtle enough to
elude the unfamiliar?

I ask because these filesystems are pretty busy on a day to day basis
and the path where t_firstblock is NULLFSBLOCK is never hitting this
problem.  The overall workload is a btree based database.  Lots of
random reads and writes to many files that all live in the same
directory.

While I don't have a full RCA, the circumstantial evidence seems to
suggest that letting the allocation be satisfied by more than one AG
will result in many fewer failures in xfs_bmap_extents_to_btree.
Assuming of course, that it's actually a safe and sane thing to do.

Many thanks,

-K





Including additional diagnostic output that was requested by the FAQ in
case it's helpful:

Kernel version: various 5.4 LTS versions
xfsprogs version: 5.3.0
number of CPUs: 48

Storage layout: 4x 7TB NVMe drives in a 28T LVM stripe with 16k width

xfs-info:

meta-data=/dev/mapper/db-vol     isize=512    agcount=32, agsize=228849020 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=7323168640, imaxpct=5
         =                       sunit=4      swidth=16 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=4 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

An example warning:

------------[ cut here ]------------
WARNING: CPU: 4 PID: 115756 at fs/xfs/libxfs/xfs_bmap.c:716 xfs_bmap_extents_to_btree+0x3dc/0x610 [xfs]
Modules linked in: btrfs xor zstd_compress raid6_pq ufs msdos softdog binfmt_misc udp_diag tcp_diag inet_diag xfs libcrc32c dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua p

CPU: 4 PID: 115756 Comm: dd Not tainted 5.4.139 #2
Hardware name: Amazon EC2 i3en.12xlarge/, BIOS 1.0 10/16/2017
RIP: 0010:xfs_bmap_extents_to_btree+0x3dc/0x610 [xfs]
Code: 00 00 8b 85 00 ff ff ff 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 c7 45 9c 10 00 00 00 48 89 95 60 ff ff ff e9 5a fd ff ff <0f> 0b c7 85 00 ff ff ff e4 ff ff ff 8b 9d

RSP: 0018:ffffa948115fb740 EFLAGS: 00010246
RAX: ffffffffffffffff RBX: ffff8ffec2274048 RCX: 00000000001858ab
RDX: 000000000017e467 RSI: 0000000000000000 RDI: ffff904ea1726000
RBP: ffffa948115fb870 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 000000000017e467 R12: ffff8ff22bcdd6a8
R13: ffff904ea9f85000 R14: ffff8ffec2274000 R15: ffff904e476a4380
FS:  00007f5625e89580(0000) GS:ffff904ebb300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bd5952c000 CR3: 000000011d6f0004 CR4: 00000000007606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 ? xfs_alloc_update_counters.isra.0+0x3d/0x50 [xfs]
 ? xfs_trans_log_buf+0x30/0x80 [xfs]
 ? xfs_alloc_log_agf+0x73/0x100 [xfs]
 xfs_bmap_add_extent_hole_real+0x7d9/0x8f0 [xfs]
 xfs_bmapi_allocate+0x2a8/0x2d0 [xfs]
 ? kmem_zone_alloc+0x85/0x140 [xfs]
 xfs_bmapi_write+0x3a9/0x5f0 [xfs]
 xfs_iomap_write_direct+0x293/0x3c0 [xfs]
 xfs_file_iomap_begin+0x4d2/0x5c0 [xfs]
 iomap_apply+0x68/0x160
 ? iomap_dio_bio_actor+0x3d0/0x3d0
 iomap_dio_rw+0x2c1/0x450
 ? iomap_dio_bio_actor+0x3d0/0x3d0
 xfs_file_dio_aio_write+0x103/0x2e0 [xfs]
 ? xfs_file_dio_aio_write+0x103/0x2e0 [xfs]
 xfs_file_write_iter+0x99/0xe0 [xfs]
 new_sync_write+0x125/0x1c0
 __vfs_write+0x29/0x40
 vfs_write+0xb9/0x1a0
 ksys_write+0x67/0xe0
 __x64_sys_write+0x1a/0x20
 do_syscall_64+0x57/0x190
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f5625da71e7
Code: 64 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48

RSP: 002b:00007ffd3916c2a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000004000 RCX: 00007f5625da71e7
RDX: 0000000000004000 RSI: 000055bd59529000 RDI: 0000000000000001
RBP: 000055bd59529000 R08: 000055bd595280f0 R09: 000000000000007c
R10: 000055bd59529000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000004000 R15: 000055bd59529000
---[ end trace b26426a6b66a298e ]---
XFS (dm-1): Internal error xfs_trans_cancel at line 1053 of file fs/xfs/xfs_trans.c.  Caller xfs_iomap_write_direct+0x1fb/0x3c0 [xfs]

The xfs_db freesp report after the problem occurred.  (N.B. it was a few
hours before I was able to get to this machine to investigate)

xfs_db -r -c 'freesp -a 47 -s' /dev/mapper/db-vol
   from      to extents  blocks    pct
      1       1      48      48   0.00
      2       3     119     303   0.02
      4       7      46     250   0.01
      8      15      22     255   0.01
     16      31      17     374   0.02
     32      63      16     728   0.04
     64     127       9     997   0.05
    128     255     149   34271   1.83
    256     511       7    2241   0.12
    512    1023       4    2284   0.12
   1024    2047       1    1280   0.07
   2048    4095       1    3452   0.18
1048576 2097151       1 1825182  97.52
total free extents 440
total free blocks 1871665
average free extent size 4253.78
