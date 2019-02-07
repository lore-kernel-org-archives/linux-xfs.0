Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:57151 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727127AbfBGNai (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 08:30:38 -0500
Received: from justpickone.org ([74.208.250.170]) by mrelay.perfora.net
 (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id 0M71s3-1h4Ikf1T5p-00wpqo
 for <linux-xfs@vger.kernel.org>; Thu, 07 Feb 2019 14:25:36 +0100
Date: Thu, 7 Feb 2019 08:25:34 -0500
From: David T-G <davidtg@justpickone.org>
Subject: is it safe to xfs_repair this volume? do i have a different first
 step?
Message-ID: <20190207132534.GA2185@justpickone.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-XFS list <linux-xfs@vger.kernel.org>

Good morning!

I have a four-disk RAID5 volume with an ~11T filesystem that suddenly
won't mount 

  diskfarm:root:4:~> mount -v /mnt/4Traid5md/
  mount: mount /dev/md0p1 on /mnt/4Traid5md failed: Bad message

after a power outage :-(  Because of the GPT errors I see

  diskfarm:root:4:~> fdisk -l /dev/md0
  The backup GPT table is corrupt, but the primary appears OK, so that will be used.
  Disk /dev/md0: 10.9 TiB, 12001551581184 bytes, 23440530432 sectors
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 4096 bytes
  I/O size (minimum/optimal): 524288 bytes / 1572864 bytes
  Disklabel type: gpt
  Disk identifier: 8D29E2FB-1A26-4C46-B284-99FA7163B89D

  Device     Start         End     Sectors  Size Type
  /dev/md0p1  2048 23440530398 23440528351 10.9T Linux filesystem

  diskfarm:root:4:~> parted /dev/md0 print
  Error: end of file while reading /dev/md0
  Retry/Ignore/Cancel? ignore
  Error: The backup GPT table is corrupt, but the primary appears OK, so that will be used.
  OK/Cancel? ok
  Model: Linux Software RAID Array (md)
  Disk /dev/md0: 12.0TB
  Sector size (logical/physical): 512B/4096B
  Partition Table: gpt
  Disk Flags:

  Number  Start   End     Size    File system  Name              Flags
   1      1049kB  12.0TB  12.0TB  xfs          Linux filesystem

when poking, I at first thought that this was a RAID issue, but all of
the md reports look good and apparently the GPT table issue is common, so
I'll leave all of that out unless someone asks for it.

dmesg reports some XFS problems

  diskfarm:root:5:~> dmesg | egrep 'md[:/0]'
  [  117.999012] md/raid:md127: device sdg2 operational as raid disk 1
  [  117.999014] md/raid:md127: device sdh2 operational as raid disk 2
  [  117.999015] md/raid:md127: device sdd2 operational as raid disk 0
  [  117.999246] md/raid:md127: raid level 5 active with 3 out of 3 devices, algorithm 2
  [  120.820661] md/raid:md0: not clean -- starting background reconstruction
  [  120.821279] md/raid:md0: device sdf1 operational as raid disk 2
  [  120.821282] md/raid:md0: device sda1 operational as raid disk 3
  [  120.821283] md/raid:md0: device sdb1 operational as raid disk 0
  [  120.821284] md/raid:md0: device sde1 operational as raid disk 1
  [  120.822028] md/raid:md0: raid level 5 active with 4 out of 4 devices, algorithm 2
  [  120.822063] md0: detected capacity change from 0 to 12001551581184
  [  120.888841]  md0: p1
  [  202.230961] XFS (md0p1): Mounting V4 Filesystem
  [  203.182567] XFS (md0p1): Torn write (CRC failure) detected at log block 0x3397e8. Truncating head block from 0x3399e8.
  [  203.367581] XFS (md0p1): failed to locate log tail
  [  203.367587] XFS (md0p1): log mount/recovery failed: error -74
  [  203.367712] XFS (md0p1): log mount failed
  [  285.893728] XFS (md0p1): Mounting V4 Filesystem
  [  286.057829] XFS (md0p1): Torn write (CRC failure) detected at log block 0x3397e8. Truncating head block from 0x3399e8.
  [  286.203436] XFS (md0p1): failed to locate log tail
  [  286.203440] XFS (md0p1): log mount/recovery failed: error -74
  [  286.203497] XFS (md0p1): log mount failed

but doesn't tell me a whole lot -- or at least not a whole lot that makes
enough sense to me :-)  I tried an xfs_repair dry run and here

  diskfarm:root:4:~> xfs_repair -n /dev/disk/by-label/4Traid5md 2>&1 | egrep -v 'agno = '
  Phase 1 - find and verify superblock...
          - reporting progress in intervals of 15 minutes
  Phase 2 - using internal log
          - zero log...
          - scan filesystem freespace and inode maps...
  sb_fdblocks 471930978, counted 471939170
          - 09:18:47: scanning filesystem freespace - 48 of 48 allocation groups done
          - found root inode chunk
  Phase 3 - for each AG...
          - scan (but don't clear) agi unlinked lists...
          - 09:18:47: scanning agi unlinked lists - 48 of 48 allocation groups done
          - process known inodes and perform inode discovery...
          - 09:24:17: process known inodes and inode discovery - 4466560 of 4466560 inodes done
          - process newly discovered inodes...
          - 09:24:17: process newly discovered inodes - 48 of 48 allocation groups done
  Phase 4 - check for duplicate blocks...
          - setting up duplicate extent list...
          - 09:24:17: setting up duplicate extent list - 48 of 48 allocation groups done
          - check for inodes claiming duplicate blocks...
          - 09:29:44: check for inodes claiming duplicate blocks - 4466560 of 4466560 inodes done
  No modify flag set, skipping phase 5
  Phase 6 - check inode connectivity...
          - traversing filesystem ...
          - traversal finished ...
          - moving disconnected inodes to lost+found ...
  Phase 7 - verify link counts...
          - 09:34:02: verify and correct link counts - 48 of 48 allocation groups done
  No modify flag set, skipping filesystem flush and exiting.

is the trimmed output that can fit on one screen.  Since I don't have a
second copy of all of this data, I'm a bit nervous about pulling the
trigger to write changes and want to make sure that I take the right
steps!  How should I proceed?

I'm not subscribed to this list, so please do cc/bcc me on your replies.
I didn't see any other lists and did see some discussion here, so I hope
that I'm in the right place, but please feel free also to point me in
another direction if that's better.


TIA & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt
