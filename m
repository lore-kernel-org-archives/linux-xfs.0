Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f44.google.com ([209.85.161.44]:40285 "EHLO
        mail-yw1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbeJEGRk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 02:17:40 -0400
Received: by mail-yw1-f44.google.com with SMTP id l79-v6so4513891ywc.7
        for <linux-xfs@vger.kernel.org>; Thu, 04 Oct 2018 16:21:53 -0700 (PDT)
MIME-Version: 1.0
From: Ed Spiridonov <edo.rus@gmail.com>
Date: Fri, 5 Oct 2018 02:21:41 +0300
Message-ID: <CACm0Nn2PU--REYPDjCE05bdyg3VCzZQpWX_dxe5vjFmXsr0UHg@mail.gmail.com>
Subject: XFS deadlock?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I've set up new server with ten 10Tb disks.
Main volume is XFS over RAID6 (created with mdadm).

For now fs is filling with data. After several hours of uptime disk IO
freezes with such messages in log:
[ 5679.900329] INFO: task tar:18235 blocked for more than 120 seconds.
[ 5679.900404] Not tainted 4.18.12 #2
...
[ 5679.904044] INFO: task kworker/u24:3:18307 blocked for more than 120 seconds.
[ 5679.904137] Not tainted 4.18.12 #2

Full log is too long, I left it here:
https://bugzilla.kernel.org/show_bug.cgi?id=201331

I'm unsure, but it seems to be XFS-related.

/proc/mdstat content:
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid1 sdf1[5] sda1[0] sdd1[3] sdg1[6] sdh1[7] sdi1[8]
sdj1[9] sde1[4] sdb1[2] sdc1[1]
      523712 blocks super 1.2 [10/10] [UUUUUUUUUU]

md3 : active raid6 sda4[0] sdj4[9] sdg4[6] sdd4[3] sdi4[8] sdf4[5]
sde4[4] sdh4[7] sdb4[2] sdc4[1]
      77555695616 blocks super 1.2 level 6, 16384k chunk, algorithm 2
[10/10] [UUUUUUUUUU]
      bitmap: 9/73 pages [36KB], 65536KB chunk

md2 : active raid10 sda3[0] sdh3[7] sdd3[3] sdj3[9] sdg3[6] sdf3[5]
sdi3[8] sde3[4] sdb3[2] sdc3[1]
      335216640 blocks super 1.2 512K chunks 2 near-copies [10/10] [UUUUUUUUUU]

md1 : active (auto-read-only) raid10 sdj2[9] sdi2[8] sda2[0] sdf2[5]
sdh2[7] sde2[4] sdg2[6] sdd2[3] sdb2[2] sdc2[1]
      20951040 blocks super 1.2 512K chunks 2 near-copies [10/10] [UUUUUUUUUU]

unused devices: <none>


xfs_info output:
meta-data=/dev/md3               isize=512    agcount=73, agsize=268431360 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=19388923904, imaxpct=1
         =                       sunit=4096   swidth=32768 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

I have made some RAID tuning:
echo 32768 >  /sys/block/md3/md/stripe_cache_size
