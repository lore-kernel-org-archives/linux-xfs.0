Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 62DA27F50
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 15:06:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E36CDAC002
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 13:06:21 -0800 (PST)
Received: from na01-bn1-obe.outbound.protection.outlook.com
	(mail-bn1blp0190.outbound.protection.outlook.com
	[207.46.163.190]) by cuda.sgi.com with ESMTP id
	We3ZXozGF3njPheZ (version=TLSv1 cipher=AES128-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Mar 2014 13:06:17 -0800 (PST)
Message-ID: <5314EE97.3020004@uga.edu>
Date: Mon, 3 Mar 2014 16:05:27 -0500
From: Paul Brunk <pbrunk@uga.edu>
MIME-Version: 1.0
Subject: rebuilt HW RAID60 array; XFS filesystem looks bad now
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi:

Short version: XFS filesystem on HW RAID60 array.  Array has been
multiply rebuilt due to drive insertions.  XFS filesystem damaged and
trying to salvage what I can, and I want to make sure I have no option
other than "xfs_repair -L".  Details follow.

# uname -a
Linux rccstor7.local 2.6.32-431.5.1.el6.x86_64 #1 SMP Wed Feb 12 
00:41:43 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

xfs_repair version 3.1.1.  The box has one 4-core Opteron CPU and 8
GB of RAM.

I have a 32TB HW RAID60 volume (Areca 1680 HW RAID) made of two RAID6
raid sets.

This volume is a PV in Linux LVM, with a single LV defined in it.  The
LV had an XFS filesystem created on it (no external log).

I can't do xfs_info on it because I can't mount the filesystem.

I had multiple drive removals and insertions (due to timeout error
with non-TLER drives in the RAID array, an unfortunate setup I
inherited), which triggered multiple HW RAID rebuilds.  This caused
the RAID volume to end up defined twice in the controller, with each
of the two constituent RAID sets being defined twice.  At Areca's
direction, I did a "raid set rescue" in the Areca controller.  That
succeeded in reducing the number of volumes from two to one, and the
RAID volume is now "normal" in the RAID controller instead of
"failed".

The logical volume is visible to the OS now, unlike when the RAID
status was "failed".

   # lvdisplay
   --- Logical volume ---
   LV Path                /dev/vg0/lv0
   LV Name                lv0
   VG Name                vg0
   LV UUID                YMlFWe-PTGe-5kHx-V3uo-31Vp-grXR-9ZBt3R
   LV Write Access        read/write
   LV Creation host, time ,
   LV Status              available
   # open                 0
   LV Size                32.74 TiB
   Current LE             8582595
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     256
   Block device           253:2

That's good, but now I think the XFS filesystem is in bad shape.

  # grep /media/shares /etc/fstab
  UUID="9cba4e90-1d8f-4a98-8701-df10a28556da" /media/shares xfs pquota 0 0

That UUID entry in /dev/disk/by-uuid is a link to /dev/dm-2.

"dm-2" is the RAID volume.  Here it is in /proc/partitions:
  major minor  #blocks     name
   253     2   35154309120 dm-2

When I try to mount the XFS filesystem:

  # mount /media/shares
  mount: wrong fs type, bad option, bad superblock on /dev/mapper/vg0-lv0,
         missing codepage or helper program, or other error
         In some cases useful info is found in syslog - try
         dmesg | tail  or so

  # dmesg|tail
  XFS (dm-2): Mounting Filesystem
  XFS (dm-2): Log inconsistent or not a log (last==0, first!=1)
  XFS (dm-2): empty log check failed
  XFS (dm-2): log mount/recovery failed: error 22
  XFS (dm-2): log mount failed

  # xfs_check /dev/dm-2
  xfs_check: cannot init perag data (117)
  XFS: Log inconsistent or not a log (last==0, first!=1)
  XFS: empty log check failed

  # xfs_repair -n /dev/dm-2
  produced at least 7863 lines of output.   It begins

  Phase 1 - find and verify superblock...
  Phase 2 - using internal log
          - scan filesystem freespace and inode maps...
  bad magic # 0xa04850d in btbno block 0/108
  expected level 0 got 10510 in btbno block 0/108
  bad btree nrecs (144, min=255, max=510) in btbno block 0/108
  block (0,80-80) multiply claimed by bno space tree, state - 2
  block (0,108-108) multiply claimed by bno space tree, state - 7

  # egrep -c "invalid start block" xfsrepair.out
  2061
  # egrep -c "multiply claimed by bno" xfsrepair.out
  4753

  Included in the output are 381 occurrences of this pair of messages:

  bad starting inode # (0 (0x0 0x0)) in ino rec, skipping rec
  badly aligned inode rec (starting inode = 0)

Is there anything I should try prior to xfs_repair -L?

I'm just trying to salvage whatever I can from this FS.  I'm aware it
could be all gone.  Thanks.

-- 
Paul Brunk, system administrator
Georgia Advanced Computing Resource Center (GACRC)
Enterprise IT Svcs, the University of Georgia

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
