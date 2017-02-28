Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:60031 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751470AbdB1Cht (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Feb 2017 21:37:49 -0500
Received: from justpickone.org ([74.208.250.170]) by mrelay.perfora.net
 (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id 0MdMM1-1d0tb31JGV-00IXdm
 for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2017 03:37:26 +0100
Date: Mon, 27 Feb 2017 21:37:24 -0500
From: David T-G <davidtg@justpickone.org>
Subject: xfs_growfs 3.2.1 on Knoppix-ADRIANE from Debian 7 does not grow
Message-ID: <20170228023724.GJ23709@justpickone.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi, all --

I finally settled on xfs as the filesystem for my raid5 volume on my
home computer even though I've been a longtime reiserfs lover :-)  But,
hey, let's try something new.

I recently added another device to my md raid5 set and expanded the
device from 8T to 12T, and now I want to grow the filesystem.  I remade
the partition and we oughta be good to go:

  diskfarm:root:10:~> parted /dev/md0 print | egrep 'TB|Table|Sector'
  Disk /dev/md0: 12.0TB
  Sector size (logical/physical): 512B/4096B
  Partition Table: gpt
   1      1049kB  12.0TB  12.0TB  xfs          Linux filesystem

When I try xfs_growfs, however, nothing changes:

  diskfarm:root:10:~> df -kh /mnt/4Traid5md/
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/md0p1      7.3T  6.5T  863G  89% /mnt/4Traid5md
  diskfarm:root:10:~> xfs_growfs -d /mnt/4Traid5md/
  meta-data=/dev/md0p1             isize=256    agcount=32, agsize=61043072 blks
           =                       sectsz=4096  attr=2, projid32bit=1
           =                       crc=0        finobt=0
  data     =                       bsize=4096   blocks=1953377275, imaxpct=5
           =                       sunit=128    swidth=256 blks
  naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
  log      =internal               bsize=4096   blocks=521728, version=2
           =                       sectsz=4096  sunit=1 blks, lazy-count=1
  realtime =none                   extsz=4096   blocks=0, rtextents=0
  data size unchanged, skipping
  diskfarm:root:10:~> df -kh /mnt/4Traid5md/
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/md0p1      7.3T  6.5T  863G  89% /mnt/4Traid5md

I've searched high and low and haven't found any indication of why I
shouldn't be able to grow as long as the partition is large enough, so
now it's time to dive into the mailing list :-)

Please bcc: me on your replies since I am not subscribed.  I promise to
follow up with my ongoing results :-)


TIA & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

