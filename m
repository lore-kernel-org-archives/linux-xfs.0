Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Nov 2007 10:53:24 -0800 (PST)
Received: from mxmail.synplicity.com (synvpn.synplicity.com [209.157.48.1])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lADIrGGc019768
	for <xfs@oss.sgi.com>; Tue, 13 Nov 2007 10:53:20 -0800
Received: from [63.110.200.37] (localhost [127.0.0.1])
	by synplcty.synplicity.com (8.13.1/8.12.11) with ESMTP id lADIrJZM007085
	for <xfs@oss.sgi.com>; Tue, 13 Nov 2007 10:53:21 -0800 (PST)
Message-ID: <4739F2CD.2020800@synplicity.com>
Date: Tue, 13 Nov 2007 10:54:05 -0800
From: Chris Eddington <chrise@synplicity.com>
MIME-Version: 1.0
Subject: xfs_repair - what's the damage?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,

Can someone point me to instructions on how to understand the scope of
damage to this filesystem based on the output from xfs_repair below?
What is it repairing, and what data is lost?  I'm not sure how to interpret
these messages or where to go to find out.

I'm using xfs_repair v2.8.18 on Ubuntu Linux.

Thks,
Chris


-----------------
xfs_repair -n /dev/md0
      - creating 4 worker thread(s)
Phase 1 - find and verify superblock...
      - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
      - scan filesystem freespace and inode maps...
bad on-disk superblock 2 - inconsistent filesystem geometry in realtime 
filesystem component
primary/secondary superblock 2 conflict - AG superblock geometry info 
conflicts with filesystem geometry
would reset bad sb for ag 2
bad uncorrected agheader 2, skipping ag...
bad on-disk superblock 24 - bad magic number
primary/secondary superblock 24 conflict - AG superblock geometry info 
conflicts with filesystem geometry
bad flags field in superblock 24
bad shared version number in superblock 24
bad inode alignment field in superblock 24
bad stripe unit/width fields in superblock 24
bad log/data device sector size fields in superblock 24
bad magic # 0xc486a1e7 for agi 24
bad version # 127171049 for agi 24
bad sequence # 606867126 for agi 24
bad length # -48052605 for agi 24, should be 11446496
would reset bad sb for ag 24
would reset bad agi for ag 24
bad uncorrected agheader 24, skipping ag...
      - 10:49:34: scanning filesystem freespace - 30 of 32 allocation 
groups done
      - found root inode chunk
Phase 3 - for each AG...
      - scan (but don't clear) agi unlinked lists...
error following ag 24 unlinked list
      - 10:49:34: scanning agi unlinked lists - 32 of 32 allocation 
groups done
      - process known inodes and perform inode discovery...
      - agno = 0
      - agno = 1
      - agno = 2
      - agno = 3
      - agno = 4
imap claims a free inode 268435719 is in use, would correct imap and 
clear inode
bad nblocks 23 for inode 268435723, would reset to 13
corrupt block 0 in directory inode 259
  would junk block
no . entry for directory 259
no .. entry for directory 259
      - agno = 5
      - agno = 6
      - agno = 7
      - agno = 8
attribute entry 0 in attr block 0, inode 2147610149 has bad name 
(namelen = 0)
problem with attribute contents in inode 2147610149
would clear attr fork
bad nblocks 11 for inode 2147610149, would reset to 10
bad anextents 1 for inode 2147610149, would reset to 0
attribute entry 0 in attr block 0, inode 2147610376 has bad name 
(namelen = 0)
problem with attribute contents in inode 2147610376
would clear attr fork
bad nblocks 13 for inode 2147610376, would reset to 12
bad anextents 1 for inode 2147610376, would reset to 0
      - agno = 9
      - agno = 10
      - agno = 11
imap claims in-use inode 2173744652 is free, would correct imap
data fork in ino 2423071372 claims free block 201330859
data fork in ino 2423071372 claims free block 201330860
data fork in ino 2423071372 claims free block 201330861
data fork in ino 2423071372 claims free block 201330862
data fork in ino 2423071372 claims free block 201330863
data fork in ino 2423071375 claims free block 268470033
data fork in ino 2423071375 claims free block 268470034
data fork in ino 2423071375 claims free block 268470035
data fork in ino 2423071375 claims free block 268470036
data fork in ino 2423071375 claims free block 268470037
data fork in ino 2423071375 claims free block 268470038
data fork in ino 2423071376 claims free block 301992536
data fork in ino 2423071376 claims free block 301992537
data fork in ino 2423071376 claims free block 301992538
data fork in ino 2423071376 claims free block 301992539
data fork in ino 2423071376 claims free block 301992540
data fork in ino 2423071376 claims free block 301992541
imap claims a free inode 2423071393 is in use, would correct imap and 
clear inode
imap claims a free inode 2423071394 is in use, would correct imap and 
clear inode
imap claims a free inode 2423071395 is in use, would correct imap and 
clear inode
imap claims in-use inode 2423071409 is free, would correct imap
imap claims a free inode 2423071413 is in use, would correct imap and 
clear inode
imap claims a free inode 2691467538 is in use, would correct imap and 
clear inode
imap claims in-use inode 2691467544 is free, would correct imap
data fork in ino 2691568164 claims free block 352325825
data fork in ino 2691568164 claims free block 352325826
data fork in ino 2691568164 claims free block 352325827
data fork in ino 2691568164 claims free block 352325828
data fork in ino 2691568164 claims free block 352325829
data fork in ino 2691568164 claims free block 352325830
data fork in ino 2691568164 claims free block 352325831
data fork in ino 2691568166 claims free block 385877409
data fork in ino 2691568166 claims free block 385877410
data fork in ino 2691568166 claims free block 385877411
data fork in ino 2691568166 claims free block 385877412
data fork in ino 2691568166 claims free block 385877413
data fork in ino 2691568166 claims free block 385877414
data fork in ino 2691568166 claims free block 385877415
data fork in ino 2691568170 claims free block 184554409
data fork in ino 2691568170 claims free block 184554410
data fork in ino 2691568170 claims free block 184554411
data fork in ino 2691568170 claims free block 184554412
data fork in ino 2691568170 claims free block 184554413
data fork in ino 2691568170 claims free block 184554414
imap claims in-use inode 2691568170 is free, would correct imap
data fork in ino 2691568173 claims free block 251661537
data fork in ino 2691568173 claims free block 251661538
data fork in ino 2691568173 claims free block 251661539
data fork in ino 2691568173 claims free block 251661540
data fork in ino 2691568173 claims free block 251661541
data fork in ino 2691568173 claims free block 251661542
data fork in ino 2691568174 claims free block 285214025
data fork in ino 2691568174 claims free block 285214026
data fork in ino 2691568174 claims free block 285214027
data fork in ino 2691568174 claims free block 285214028
data fork in ino 2691568174 claims free block 285214029
data fork in ino 2691568174 claims free block 285214030
data fork in ino 2691568177 claims free block 318768281
data fork in ino 2691568177 claims free block 318768282
data fork in ino 2691568177 claims free block 318768283
data fork in ino 2691568177 claims free block 318768284
data fork in ino 2691568177 claims free block 318768285
data fork in ino 2691568177 claims free block 318768286
data fork in ino 2691568177 claims free block 318768287
imap claims in-use inode 2691568177 is free, would correct imap
imap claims in-use inode 2691568178 is free, would correct imap
imap claims in-use inode 2691568180 is free, would correct imap
imap claims in-use inode 2691568181 is free, would correct imap
imap claims in-use inode 2691568183 is free, would correct imap
imap claims in-use inode 2691568184 is free, would correct imap
imap claims in-use inode 2691568185 is free, would correct imap
      - agno = 12
      - agno = 13
      - agno = 14
      - agno = 15
      - agno = 16
      - agno = 17
      - agno = 18
      - agno = 19
      - agno = 20
      - agno = 21
      - agno = 22
      - agno = 23
      - agno = 24
      - agno = 25
      - agno = 26
      - agno = 27
      - agno = 28
      - agno = 29
      - agno = 30
      - agno = 31
      - 10:53:49: process known inodes and inode discovery - 191040 of 
202304 inodes done
      - process newly discovered inodes...
      - 10:53:50: process newly discovered inodes - 64 of 32 
allocation groups done
Phase 4 - check for duplicate blocks...
      - setting up duplicate extent list...
      - 10:53:50: setting up duplicate extent list - 32 of 32 
allocation groups done
      - check for inodes claiming duplicate blocks...
      - agno = 0
corrupt block 0 in directory inode 259
  would junk block
      - agno = 1
bad nblocks 23 for inode 268435723, would reset to 13
entry "verif" at block 0 offset 480 in directory inode 268435726 
references non-existent inode 536871184
  would clear inode number in entry at offset 480...
entry "rev_1" in shortform directory 268435746 references non-existent 
inode 536871208
would have junked entry "rev_1" in directory inode 268435746
entry "vhdl" in shortform directory 268435752 references non-existent 
inode 536871227
would have junked entry "vhdl" in directory inode 268435752
entry "blackbox_impl_1" in shortform directory 268435755 references 
non-existent inode 536871231
would have junked entry "blackbox_impl_1" in directory inode 268435755
entry "vhdl" in shortform directory 268435762 references non-existent 
inode 536871459
would have junked entry "vhdl" in directory inode 268435762
entry "aqm_sr_2add_fold" in shortform directory 268435765 references 
non-existent inode 536871469
would have junked entry "aqm_sr_2add_fold" in directory inode 268435765
entry "amplify" in shortform directory 268435768 references non-existent 
inode 536871472
would have junked entry "amplify" in directory inode 268435768
entry "vhdl" in shortform directory 268435769 references non-existent 
inode 536871475
would have junked entry "vhdl" in directory inode 268435769
entry "SynDSPparallel49_sync_ret" at block 0 offset 200 in directory 
inode 268435772 references non-existent inode 536871479
  would clear inode number in entry at offset 200...
entry "resynthesis" at block 0 offset 944 in directory inode 268435972 
references non-existent inode 536871682
  would clear inode number in entry at offset 944...
entry "verif" at block 0 offset 368 in directory inode 268437003 
references non-existent inode 536871690
  would clear inode number in entry at offset 368...
      - agno = 3
entry ".." at block 0 offset 32 in directory inode 805306662 references 
non-existent inode 536871459
  would clear inode number in entry at offset 32...
no . entry for directory 259
no .. entry for directory 259
entry "syntmp" at block 0 offset 1408 in directory inode 291 references 
non-existent inode 536871482
  would clear inode number in entry at offset 1408...
entry "rev_1" at block 0 offset 208 in directory inode 268437017 
references non-existent inode 536871692
  would clear inode number in entry at offset 208...
entry "test_fsm_arbiter" in shortform directory 268437038 references 
non-existent inode 536871721
would have junked entry "test_fsm_arbiter" in directory inode 268437038
entry "src" in shortform directory 268437039 references non-existent 
inode 536871722
would have junked entry "src" in directory inode 268437039
entry "slprj" at block 0 offset 1840 in directory inode 268437040 
references non-existent inode 536871738
  would clear inode number in entry at offset 1840...
entry "src" in shortform directory 268437290 references non-existent 
inode 536871740
would have junked entry "src" in directory inode 268437290
entry ".." at block 0 offset 32 in directory inode 805307151 references 
non-existent inode 536871475
  would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 805307159 references 
non-existent inode 536871479
  would clear inode number in entry at offset 32...
      - agno = 2
      - agno = 4
entry ".." at block 0 offset 32 in directory inode 1073742080 references 
non-existent inode 536871168
  would clear inode number in entry at offset 32...
entry "object_2" in shortform directory 1073742083 references 
non-existent inode 536901176
would have junked entry "object_2" in directory inode 1073742083
entry ".." at block 0 offset 32 in directory inode 1073742098 references 
non-existent inode 536871208
  would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 805308172 references 
non-existent inode 536872499
  would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 805308201 references 
non-existent inode 536872508
  would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 805309952 references 
non-existent inode 536874804
  would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 805310005 references 
non-existent inode 536875066
  would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 805310210 references 
non-existent inode 536875070
  would clear inode number in entry at offset 32...
entry "verif" at block 0 offset 352 in directory inode 805310210 
references non-existent inode 536875267
  would clear inode number in entry at offset 352...
entry ".." at block 0 offset 32 in directory inode 1073744910 references 
non-existent inode 536873218
  would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 805310515 references 
non-existent inode 536875326
  would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 805310729 references 
non-existent inode 536875541
  would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 805310766 references 
non-existent inode 536875806
  would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 805311009 references 
non-existent inode 536876306
  would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 805311249 references 
non-existent inode 536876575
  would clear inode number in entry at offset 32...
entry "pop" at block 0 offset 512 in directory inode 805311249 
references non-existent inode 536909576
  would clear inode number in entry at offset 512...
entry "src" in shortform directory 268437291 references non-existent 
inode 536871948
would have junked entry "src" in directory inode 268437291
entry "src" in shortform directory 268437292 references non-existent 
inode 536871964
would have junked entry "src" in directory inode 268437292
entry "src" in shortform directory 268437293 references non-existent 
inode 536871980
would have junked entry "src" in directory inode 268437293
entry "rev_1" at block 0 offset 696 in directory inode 268437301 
references non-existent inode 536872195
  would clear inode number in entry at offset 696...
entry "Retiming" in shortform directory 268437516 references 
non-existent inode 536872207
would have junked entry "Retiming" in directory inode 268437516
entry "FIXED POINT ARITHMETIC" in shortform directory 268437523 
references non-existent inode 536872214
would have junked entry "FIXED POINT ARITHMETIC" in directory inode 
268437523

a long list of this stuff ....

disconnected dir inode 4130509338, would move to lost+found
disconnected inode 4136546817, would move to lost+found
disconnected inode 4136546818, would move to lost+found
disconnected inode 4136546820, would move to lost+found
disconnected inode 4136546821, would move to lost+found
disconnected inode 4136546823, would move to lost+found
disconnected inode 4136546824, would move to lost+found
disconnected inode 4136546826, would move to lost+found
disconnected inode 4136546827, would move to lost+found
disconnected dir inode 4179320356, would move to lost+found
disconnected dir inode 4179320371, would move to lost+found
disconnected dir inode 4180337155, would move to lost+found
disconnected dir inode 4180337177, would move to lost+found
disconnected dir inode 4180337199, would move to lost+found
Phase 7 - verify link counts...
would have reset inode 268435723 nlinks from 65535 to 1


another long list of these ...


would have reset inode 268435726 nlinks from 4 to 3
would have reset inode 268435746 nlinks from 3 to 2
would have reset inode 268435752 nlinks from 4 to 2
would have reset inode 268435755 nlinks from 3 to 2
would have reset inode 268435762 nlinks from 3 to 2
would have reset inode 268435765 nlinks from 4 to 2
would have reset inode 268435768 nlinks from 3 to 2
would have reset inode 268435769 nlinks from 3 to 2
would have reset inode 268435772 nlinks from 6 to 5
would have reset inode 268435972 nlinks from 4 to 3
would have reset inode 268437003 nlinks from 5 to 4
would have reset inode 268437017 nlinks from 3 to 2
would have reset inode 4136546825 nlinks from 5 to 4
would have reset inode 4168420144 nlinks from 7 to 4
      - 10:54:24: verify link counts - 191040 of 202304 inodes done
No modify flag set, skipping filesystem flush and exiting.
