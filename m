Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6EB467F3F
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 04:44:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 57FB28F8066
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 02:44:31 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id N9K61Rc4O5qwKxU7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Jun 2014 02:44:29 -0700 (PDT)
Date: Wed, 18 Jun 2014 02:44:27 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: log record CRC mismatch: found 0x10a71f1d, expected 0xe012d25f
Message-ID: <alpine.DEB.2.19.4.1406180224150.4757@trent.utfs.org>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>

Hi,

this PowerBook G4 crashed (power supply failed) and now I have to wait a 
few days until the new PSU arrives. In the meantime I attached its 
external disks to an Intel Atom machine (i686) and wanted to mount the 
disks:

# mount -t xfs /dev/mapper/wdc1 /mnt/media
mount: /dev/mapper/wdc1: can't read superblock

In dmesg:

XFS (dm-3): Mounting Filesystem
XFS (dm-3): Starting recovery (logdev: internal)
XFS (dm-3): log record CRC mismatch: found 0x10a71f1d, expected 0xe012d25f.
f8808000: 00 00 00 01 00 00 00 00 69 01 00 00 76 63 5a 10  ........i...vcZ.
f8808010: 00 00 00 10 69 00 00 00 54 52 41 4e 00 00 00 2a  ....i...TRAN...*
XFS (dm-3): dirty log written in incompatible format - can't recover
XFS (dm-3): log mount/recovery failed: error 5
XFS (dm-3): log mount failed

Note: /dev/mapper/wdc1 is a dm-crypt device, not sure if this matters 
though.

Running "xfs_repair -n /dev/mapper/wdc1" came back with an exit code of 
"0" and did not report anything unusual (attached below).

Running xfs_repair (v3.2.0 from Fedora 20) *without* "-n" warns that the 
filesystem has valuable metadata changes and advises to mount it first. Or 
use "xfs_repair -L" to clear the log, but I have not done this just yet.

I *think* I have mounted the same filesystem before on this i686 system 
(some weeks ago) but then the filesystem got umounted cleanly from the 
PowerPC system, where this disk is attached to usually.

The PowerPC box is running the latest vanilla kernel (sometimes a few -rc 
versions behind) and was running 3.15.0 when the power supply failed. This 
i686 system (an IdeaPad S10 Laptop) is running a semi-current Fedora 20 
installation (with 3.14.5-200.fc20.i686 right now).

Could it be that endianess has something to do with it? The PowerPC is 
big-endian I think, and the i686 Laptop is little-endian. Even though I'm 
almost certain that I've mounted the disk before, now that the filesystem 
needs to be recovered first, maybe endianess matters now?

Ideas welcome :)

Thanks,
Christian.

# xfs_repair -n /dev/mapper/wdc1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.
# echo $?
0

# file -Ls /dev/mapper/wdc1 
/dev/mapper/wdc1: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)

# blockdev --getsize64 /dev/mapper/wdc1 
1000204323328

# cryptsetup status wdc1
/dev/mapper/wdc1 is active.
  type:    LUKS1
  cipher:  aes-cbc-essiv:sha256
  keysize: 128 bits
  device:  /dev/sdc1
  offset:  1032 sectors
  size:    1953524069 sectors
  mode:    read/write

-- 
BOFH excuse #121:

halon system went off and killed the operators.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
