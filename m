Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6KKxDWi152676 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 15:59:13 -0500
Received: from ppsw-50.csi.cam.ac.uk (ppsw-50.csi.cam.ac.uk [131.111.8.150])
	by cuda.sgi.com with ESMTP id MFLFUlpUryuH7Leu for
	<xfs@oss.sgi.com>; Fri, 20 Jul 2012 13:59:11 -0700 (PDT)
Received: from smtp.damtp.cam.ac.uk ([131.111.18.84]:38795
	helo=septal.damtp.cam.ac.uk)
	by ppsw-50.csi.cam.ac.uk (ppsw.cam.ac.uk [131.111.8.137]:25)
	with esmtp id 1SsKI3-0003R3-q4 (Exim 4.72) for xfs@oss.sgi.com
	(return-path <J.S.Peatfield@damtp.cam.ac.uk>);
	Fri, 20 Jul 2012 21:59:11 +0100
Date: Fri, 20 Jul 2012 21:59:11 +0100 (BST)
From: Jon Peatfield <J.S.Peatfield@damtp.cam.ac.uk>
Subject: Assert in xfs_repair (Phase 7) and other xfs_restore problems
Message-ID: <alpine.LRH.2.02.1207202022300.7993@floggle-toggle.damtp.cam.ac.uk>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jon Peatfield <J.S.Peatfield@damtp.cam.ac.uk>

I have been trying and failing to repair an xfs filesystem.  Originally I 
was using the Scientific-Linux (like RHEL) provided xfs_repair (2.9.4) but 
when that failed I built the latest tarball (3.1.8)...

The fs is about 3TB (of which about 2.7TB was used) and is stored in an 
LVM volume on an external RAID-6 device.  The RAID unit seems to still be 
working fine and all the other LVs are still working fine.  The filesystem 
contained a number of trees of mostly hardlinked files (they were 
snapshots generated using rsync with --link-dest so many of the files will 
be hardlinked in a number of different trees depending on when they 
changed).

The original problem appeared after a power problem (UPS powering the 
server didn't last as long as a power cut) and the server just lost power. 
Perhaps it was in the middle of trying to sync data to the disk when it 
lost power...  Sadly I have no logs...

After the power outage the fs could still be mounted but attempts to write 
to some areas cased a kernel error and it would mark the fs as read-only.

So I tried xfs_repair and after reporting various problems it was fixing 
it got part way through Phase 6 and said it couldn't allocate enough 
memory:

# xfs_repair -v /dev/mapper/FornixRaid02-damtp--home
Phase 1 - find and verify superblock...
         - block cache size set to 1076208 entries
Phase 2 - using internal log
         - zero log...
zero_log: head block 44160 tail block 44160
         - scan filesystem freespace and inode maps...
         - found root inode chunk
Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - process known inodes and perform inode discovery...
  ...
Phase 6 - check inode connectivity...
         - resetting contents of realtime bitmap and summary inodes
         - traversing filesystem ...
         - agno = 0
bad hash table for directory inode 11062547 (no data entry): rebuilding
rebuilding directory inode 11062547
bad hash table for directory inode 11325503 (no data entry): rebuilding
rebuilding directory inode 11325503
...

         - agno = 6

corrupt inode 3232556081 (bad size 1199484739711432270 for local inode). 
This is a bug.
Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com.
cache_node_purge: refcount was 1, not zero (node=0x2bd3f34e10)

fatal error -- couldn't map inode 3232556081, err = 117

I cleared inode 3232556081, and tried again and this time it ended:

...
Phase 6 - check inode connectivity...
         - resetting contents of realtime bitmap and summary inodes
         - traversing filesystem ...
         - agno = 0
...
rebuilding directory inode 2160683526
entry "MainMenu.nib" in shortform directory inode 2163312939 points to 
free inode 3236719664junking entry
         - agno = 5
bad hash table for directory inode 2699911474 (no data entry): rebuilding
rebuilding directory inode 2699911474
         - agno = 6

fatal error -- malloc failed in longform_dir2_entry_check (3913471144 
bytes)

Now the original machine only has 12G ram so I figured it might not be 
enough for repairing this filesystem.

After some messing I moved the raid box over to a newer/faster machine 
with more memory (64G ram), tried again and got similar results):

# xfs_repair -vv /dev/mapper/FornixRaid02-damtp--home
Phase 1 - find and verify superblock...
         - icount = 59993728, imem = 234350, dblock = 789028352, dmem = 385267
         - block cache size set to 6109288 entries
Phase 2 - using internal log
         - zero log...
zero_log: head block 128 tail block 128
         - scan filesystem freespace and inode maps...
         - found root inode chunk
...

Phase 6 - check inode connectivity...
         - resetting contents of realtime bitmap and summary inodes
         - traversing filesystem ...
         - agno = 0
bad hash table for directory inode 12795415 (no data entry): rebuilding
rebuilding directory inode 12795415
         - agno = 1
         - agno = 2
bad hash table for directory inode 1084921399 (no data entry): rebuilding
rebuilding directory inode 1084921399
         - agno = 3
         - agno = 4
         - agno = 5
entry "config" in shortform directory inode 2697554725 points to free 
inode 3234425125junking entry
         - agno = 6

fatal error -- malloc failed in longform_dir2_entry_check (1090519072 
bytes)

At this point I did some searching of the mailing lists etc and found 
various references to using -P to avoid some problems (which I tried and 
it didn't make any difference) and -m to limit the memory which 2.9.4 
doesn't have so I build 3.1.8 from source and tried that...

# ./sbin/xfs_repair -vv -m 1024 /dev/FornixRaid02/damtp-home
Phase 1 - find and verify superblock...
         - max_mem = 1048576, icount = 59993664, imem = 234350, dblock = 789028352, dmem = 385267
         - block cache size set to 47368 entries
Phase 2 - using internal log
         - zero log...
zero_log: head block 128 tail block 128
         - scan filesystem freespace and inode maps...
...

(I lost the end of that because my session died when I foolishly tried to 
mount the filesystem and caused a panic and the machine to lock solid - 
but it also failed with a malloc error but at least told me the directory 
inode it was examining at the time).

Anyway having cleared that inode and a couple of others which similarly 
seemed to cause xfs_repair to fail I ran xfs_repair again and this time it 
output a huge volume of stuff about things it had never mentioned before:

Phase 1 - find and verify superblock...
         - max_mem = 49493955, icount = 44978048, imem = 175695, dblock = 789028352, dmem = 385267
         - block cache size set to 6110368 entries
Phase 2 - using internal log
         - zero log...
zero_log: head block 128 tail block 128
         - scan filesystem freespace and inode maps...
bad magic # 0x58443242 in btbno block 2/131687
expected level 0 got 736 in btbno block 2/131687
bad btree nrecs (3112, min=255, max=510) in btbno block 2/131687
invalid start block 0 in record 0 of bno btree block 2/131687
invalid length 704643088 in record 1 of bno btree block 2/131687
invalid start block 0 in record 2 of bno btree block 2/131687
invalid start block 36580992 in record 3 of bno btree block 2/131687
invalid start block 0 in record 4 of bno btree block 2/131687
invalid start block 140734317 in record 5 of bno btree block 2/131687
invalid start block 1670976796 in record 6 of bno btree block 2/131687
...
out-of-order bno btree record 261 (96779 1) block 3/408
out-of-order bno btree record 262 (96789 1) block 3/408
out-of-order bno btree record 263 (97176 1) block 3/408
out-of-order bno btree record 264 (97191 1) block 3/408
out-of-order bno btree record 265 (97206 1) block 3/408
out-of-order bno btree record 266 (97215 1) block 3/408
...
(lots and lots of both types of those messages)

Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
entry "/." at block 0 offset 32 in directory inode 268 references invalid 
inode 18374686479671623679
         clearing inode number in entry at offset 32...
entry at block 0 offset 32 in directory inode 268 has illegal name "/.": 
entry "/p377." at block 0 offset 48 in directory inode 268 references 
invalid inode 18374686479671623679
         clearing inode number in entry at offset 48...
entry at block 0 offset 48 in directory inode 268 has illegal name 
"/p377.": entry "/gii-wsp" at block 0 offset 184 in directory inode 268 
references invalid inode 18374686479671623679
         clearing inode number in entry at offset 184...
...

The output of these later runs is huge (~20G in at least one case) and I 
had to interrupt a couple of attempts because I'd been writing the output 
to the root filesystem which filled up.

Anyway all of the later runs now end with:

...
disconnected dir inode 3892327224, moving to lost+found
disconnected dir inode 3892327225, moving to lost+found
disconnected dir inode 3892327226, moving to lost+found
disconnected dir inode 3892327227, moving to lost+found
disconnected dir inode 3892327229, moving to lost+found
disconnected dir inode 3892327231, moving to lost+found
Phase 7 - verify and correct link counts...
resetting inode 256 nlinks from 8 to 5
resetting inode 261 nlinks from 2 to 13006001
xfs_repair: phase7.c:47: set_nlinks: Assertion `fs_inode_nlink' failed.


Now in phase7.c it asserts if nlinks is over 65536 which 13006001 clearly 
is:

            do_warn(_("resetting inode %" PRIu64 " nlinks from %u to %u\n"),
                    ino, dinoc->di_nlink, nrefs);

            if (dinoc->di_version == 1 && nrefs > XFS_MAXLINK_1)  {
                    ASSERT(fs_inode_nlink);
                    do_warn(
_("nlinks %u will overflow v1 ino, ino %" PRIu64 " will be converted to version 2\n"),
                            nrefs, ino);

            }
            dinoc->di_nlink = nrefs;

I'm not sure if this is the same thing mentioned in doc/CHANGES about 
nlinks overflowing 8-bits (in this case it is overflowing 16-bits), though 
I do wonder what would happen if I simply commented out that ASSERT - 
the do_warn is probably there for a reason but I can't see how it can be 
reached...

I'm guessing that attempting to move so many files into lost+found is 
failing.  Nor am I really sure what happened which caused it to lose the 
directory entries for so many inodes.

Mounting the fs now shows almost nothing, and worryingly the df output 
shows that the number of inodes in use has gone down by a lot - was ~60M 
inodes in use and now shows as 49M though that may simply be because 13M 
should be in lost+found ...

Have I completely destroyed this filesystem or is there any hope of 
getting any of the files back ? (all the error messages I have seen were 
about problems with the directories so some or all of the files and 
structures may still be present)...

If it is destroyed (it only contained backup trees so I can live with it 
being lost), what should I have done differently?  ie what was my first 
mistake ?

I'm hoping to at least learn something from what went wrong.

I ran an xfs_metadump but the result is pretty big - 12G - while running 
it seems to only think there are going to be ~23M inodes in the dump, 
maybe that number changes later.

Is there some fraction of this dump which would be of any use for any 
debugging ?

-- 
/--------------------------------------------------------------------\
| "Computers are different from telephones.  Computers do not ring." |
|       -- A. Tanenbaum, "Computer Networks", p. 32                  |
---------------------------------------------------------------------|
| Jon Peatfield, _Computer_ Officer, DAMTP,  University of Cambridge |
| Mail:  jp107@damtp.cam.ac.uk     Web:  http://www.damtp.cam.ac.uk/ |
\--------------------------------------------------------------------/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
