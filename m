Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:64060 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751060AbdB1OPf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Feb 2017 09:15:35 -0500
Date: Tue, 28 Feb 2017 09:01:25 -0500
From: David T-G <davidtg@justpickone.org>
Subject: SOLVED xfs_growfs 3.2.1 on Knoppix-ADRIANE from Debian 7 does not
 grow
Message-ID: <20170228140125.GK23709@justpickone.org>
References: <20170228023724.GJ23709@justpickone.org>
 <20170228025248.GC5297@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228025248.GC5297@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Darrick, et al --

...and then Darrick J. Wong said...
% 
% On Mon, Feb 27, 2017 at 09:37:24PM -0500, David T-G wrote:
% > 
...
% >   diskfarm:root:10:~> parted /dev/md0 print | egrep 'TB|Table|Sector'
...
% >    1      1049kB  12.0TB  12.0TB  xfs          Linux filesystem
% > 
...
% >   diskfarm:root:10:~> xfs_growfs -d /mnt/4Traid5md/
% >   meta-data=/dev/md0p1             isize=256    agcount=32, agsize=61043072 blks
% 
% Did parted tell the kernel to reread the partition table?

Well, I thought that it did, since I kept seeing the new size plus saw
the larger partition, but I admit that I don't know, because ...


% 
% blockdev --getsz /dev/md0p1 will tell us the kernel's view of how big
% md0p1 is right now.
% 
% unmount, blockdev --rereadpt /dev/md0, try again(?)

  diskfarm:root:10:~> blockdev --getsz /dev/md0p1
  15627018207
  diskfarm:root:10:~> umount /mnt/4Traid5md
  diskfarm:root:10:~> blockdev --rereadpt /dev/md0
  diskfarm:root:10:~> mount /mnt/4Traid5md
  diskfarm:root:10:~> df -kh !$
  df -kh /mnt/4Traid5md
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/md0p1      7.3T  6.5T  863G  89% /mnt/4Traid5md
  diskfarm:root:10:~> xfs_growfs -d !$
  xfs_growfs -d /mnt/4Traid5md
  meta-data=/dev/md0p1             isize=256    agcount=32, agsize=61043072 blks
           =                       sectsz=4096  attr=2, projid32bit=1
           =                       crc=0        finobt=0
  data     =                       bsize=4096   blocks=1953377275, imaxpct=5
           =                       sunit=128    swidth=256 blks
  naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
  log      =internal               bsize=4096   blocks=521728, version=2
           =                       sectsz=4096  sunit=1 blks, lazy-count=1
  realtime =none                   extsz=4096   blocks=0, rtextents=0
  data blocks changed from 1953377275 to 2930066043
  diskfarm:root:10:~> !df
  df -kh /mnt/4Traid5md
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/md0p1       11T  6.5T  4.5T  59% /mnt/4Traid5md

WOO HOO!  That's awesome :-)  Thanks so much!

Now I'm off to read the blockdev man pages to figure out what magick thou
has given mee, good sirrah!


% 
% --D


Thanks again to all & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

