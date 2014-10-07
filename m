Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 023B17F3F
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2014 02:35:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5B3C304048
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2014 00:35:25 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id v0oMUTVXjKrf7GXq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Oct 2014 00:35:23 -0700 (PDT)
Received: from galadriel.home (unknown [82.235.234.79])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 51316D48056
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2014 09:34:27 +0200 (CEST)
Date: Tue, 7 Oct 2014 09:35:33 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Corrupted filesystem: thoughts?
Message-ID: <20141007093533.66ba8c7b@galadriel.home>
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


Here we go again: Adaptec RAID adapters don't play well with HGST 3TB
drives for some reason. When a drive fails, the filesystem is almost
always corrupted. This one looks pretty bad according to the output of
the latest "xfs_repair -n" of the 15 TB filesystem. Here is a sample 
of the 2MB log:


Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
out-of-order bno btree record 83 (332943 42) block 27/4681
out-of-order bno btree record 90 (322762 76) block 27/4681
out-of-order bno btree record 91 (331903 125) block 27/4681
out-of-order bno btree record 92 (334898 70) block 27/4681
out-of-order bno btree record 93 (335608 54) block 27/4681
out-of-order bno btree record 94 (335614 24) block 27/4681
out-of-order bno btree record 97 (338496 41) block 27/4681
out-of-order bno btree record 99 (339013 43) block 27/4681
out-of-order bno btree record 100 (339275 96) block 27/4681
out-of-order bno btree record 101 (339932 51) block 27/4681
out-of-order bno btree record 102 (339636 91) block 27/4681
out-of-order bno btree record 103 (338350 19) block 27/4681
out-of-order bno btree record 104 (339613 74) block 27/4681
block (27,339636-339636) multiply claimed by bno space tree, state - 1
out-of-order bno btree record 105 (339958 23) block 27/4681
out-of-order bno btree record 106 (340787 57) block 27/4681
out-of-order bno btree record 107 (340200 33) block 27/4681
out-of-order bno btree record 108 (340800 5) block 27/4681
invalid length 0 in record 109 of bno btree block 27/4681
out-of-order bno btree record 110 (340786 1) block 27/4681
out-of-order bno btree record 113 (345999 108) block 27/4681
out-of-order bno btree record 118 (347908 84) block 27/4681
block (27,347974-347974) multiply claimed by bno space tree, state - 1
<snip : it goes on and on>
block (27,154684-154684) multiply claimed by cnt space tree, state - 2
block (27,154824-154824) multiply claimed by cnt space tree, state - 2
block (27,164229-164229) multiply claimed by cnt space tree, state - 2
block (27,173600-173600) multiply claimed by cnt space tree, state - 2
block (27,169939-169939) multiply claimed by cnt space tree, state - 2
block (27,176207-176207) multiply claimed by cnt space tree, state - 2
block (27,9208427-9208427) multiply claimed by cnt space tree, state - 2
out-of-order cnt btree record 84 (100281231 51) block 27/201066
block (27,426944-426944) multiply claimed by cnt space tree, state - 2
block (27,605574-605574) multiply claimed by cnt space tree, state - 2
block (27,696437-696437) multiply claimed by cnt space tree, state - 2
block (27,696442-696442) multiply claimed by cnt space tree, state - 2
block (27,696452-696452) multiply claimed by cnt space tree, state - 2
<snip : it goes on and on>
data fork in ino 150375755252 claims free block 9398476839
data fork in ino 150375767332 claims free block 9398512515
data fork in ino 150375767340 claims free block 9398456218
data fork in ino 150375767362 claims free block 9401286695
data fork in ino 150375845358 claims free block 9407567857
data fork in ino 150375845377 claims free block 9398435669
data fork in ino 150376025165 claims free block 9404202405
data fork in ino 150376040962 claims free block 9401232272
data fork in ino 150376303186 claims free block 9398404549
data fork in ino 150376303188 claims free block 9398389564
data fork in ino 150376303189 claims free block 9398381926
data fork in ino 150376303194 claims free block 9398715665
data fork in ino 150376812226 claims free block 9398750726
data fork in ino 150376812272 claims free block 9398292419
data fork in ino 150376886626 claims free block 9401406274
data fork in ino 150376886648 claims free block 9401395026
data fork in ino 150377104159 claims free block 9401459056
data fork in ino 150377104269 claims free block 9401566594
data fork in ino 150377104269 claims free block 9401568444
data fork in ino 150377104296 claims free block 9401586022
<snip : it goes on and on>
        - 09:14:00: process known inodes and inode discovery - 6496192 of 12523904 inodes done
        - process newly discovered inodes...
        - 09:14:00: process newly discovered inodes - 72 of 36 allocation groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 09:14:01: setting up duplicate extent list - 36 of 36 allocation groups done
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 4
        - agno = 7
        - agno = 6
        - agno = 3
        - agno = 5
entry "Final" in shortform directory 12884902016 references non-existent inode 115964649847
would have junked entry "Final" in directory inode 12884902016
would have corrected i8 count in directory 12884902016 from 8 to 7
entry "3D" in shortform directory 12884902017 references non-existent inode 115964347194
would have junked entry "3D" in directory inode 12884902017
would have corrected i8 count in directory 12884902017 from 5 to 4
entry "Passes" in shortform directory 21474836610 references non-existent inode 115964347193
would have junked entry "Passes" in directory inode 21474836610
would have corrected i8 count in directory 21474836610 from 5 to 4
entry "Wood_Box" at block 0 offset 48 in directory inode 8589952196 references non-existent inode 115964347511
	would clear inode number in entry at offset 48...
entry "Joke_Box" at block 0 offset 184 in directory inode 8589952196 references non-existent inode 115964347512
	would clear inode number in entry at offset 184...
<snip : it goes on and on>
	would clear inode number in entry at offset 3224...
entry "GRFGN_SQ024_SC0046A_Depth.0274.zt" at block 2 offset 256 in directory inode 115969713211 references non-existent inode 115969746775
	would clear inode number in entry at offset 256...
entry "roll_262" at block 1 offset 16 in directory inode 124557330219 references non-existent inode 115970916485
	would clear inode number in entry at offset 16...
entry "GRFGN_SQ024_SC0046A_Depth.0275.zt" at block 2 offset 304 in directory inode 115969713211 references non-existent inode 115969746776
	would clear inode number in entry at offset 304...
entry "roll_332" at block 1 offset 880 in directory inode 124557330219 references non-existent inode 115970916486
	would clear inode number in entry at offset 880...
entry "GRFGN_SQ024_SC0046A_Depth.0276.zt" at block 2 offset 352 in directory inode 115969713211 references non-existent inode 115969746777
	would clear inode number in entry at offset 352...
entry "roll_368" at block 1 offset 1744 in directory inode 124557330219 references non-existent inode 115970916487
	would clear inode number in entry at offset 1744...
<snip : it goes on and on>
entry "3D" in shortform directory 151166290308 references non-existent inode 120262842426
would have junked entry "3D" in directory inode 151166290308
would have corrected i8 count in directory 151166290308 from 5 to 4
entry "3D" in shortform directory 151166290322 references non-existent inode 120262535040
would have junked entry "3D" in directory inode 151166290322
would have corrected i8 count in directory 151166290322 from 5 to 4
entry ".." at block 0 offset 32 in directory inode 151219024506 references non-existent inode 120262254536
	would clear inode number in entry at offset 32...
        - 09:14:02: check for inodes claiming duplicate blocks - 6496192 of 12523904 inodes done
Inode allocation btrees are too corrupted, skipping phases 6 and 7
No modify flag set, skipping filesystem flush and exiting.

xfs_info /dev/vg0/raid 
meta-data=/dev/mapper/vg0-raid   isize=256    agcount=36, agsize=268435455 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=9505273856, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Kernel is a plain vanilla 3.2.54 amd64. As a precaution I've made a list of the 
whole filesystem with inode numbers to be able to rename lost files in 
norecovery mode... Unfortunately I cannot do a metadump because of lack of room 
elsewhere.

-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
