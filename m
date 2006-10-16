Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 02:34:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9G9YfaG007449
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 02:34:41 -0700
Received: from home.jason.bur.st (ppp77-57.lns1.mel3.internode.on.net [59.167.77.57])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44F344AC5A8
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 01:26:47 -0700 (PDT)
Date: Mon, 16 Oct 2006 18:25:32 +1000
From: Jason White <jasonjgw@internode.on.net>
Subject: FS corruption and repair problem
Message-ID: <20061016082532.GA5574@jdc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is my desktop system, running kernel 2.6.17.11. Kernel 2.6.17 was
previously installed, but I upgraded several weeks ago after I found out about
the corruption bug in 2.6.17, which may or may not be related to the
following.

The file system was shut down during a Debian package upgrade while trying to
access apt-related files. I booted into an old 2.4 kernel on a separate
partition and ran an old version of xfs_repair. The output is attached.
Xfs_repair terminated abnormally (see the end of the output).

I can copy a newer version of xfs_repair to the backup partition if that would
help, though I'm not sure which libraries to copy along with it.

Also, if there is any indication of what might have caused this I would be
interested, as this hasn't happened before and I'de especially like to find
out whether it is a hardware problem, or related to the current kernel, or
indeed a manifestation of the 2.6.17 bug. I've successfully mounted the
corrupted file system and a lot of it is still relatively intact - plenty of
files in lost+found, especially from the /usr/share/man3 directory for obvious
reasons.

It's a straightforward desktop machine with an IDE drive. I haven't updated
Debian packages on here for a while, so it isn't clear when the corruption
happened.


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=repair

jw:/home/jason# xfs_repair /dev/hda5
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
corrupt block 0 in directory inode 75501223
	will junk block
no . entry for directory 75501223
no .. entry for directory 75501223
bad magic number 0x1362 on inode 75528256
bad version number 0x33 on inode 75528256
bad inode format in inode 75528256
bad magic number 0x1362 on inode 75528256, resetting magic number
bad version number 0x33 on inode 75528256, resetting version number
bad inode format in inode 75528256
cleared inode 75528256
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
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - clear lost+found (if it exists) ...
        - clearing existing "lost+found" inode
        - marking entry "lost+found" to be deleted
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
corrupt block 0 in directory inode 75501223
	will junk block
no . entry for directory 75501223
no .. entry for directory 75501223
entry "cabinfo" in shortform directory 75528250 references free inode 75528256
junking entry "cabinfo" in directory inode 75528250
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
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ... 
rebuilding directory inode 128
free block 16777216 for directory inode 75555671 bad nused
rebuilding directory inode 75555671
free block 16777216 for directory inode 46172285 bad nused
rebuilding directory inode 46172285
free block 16777216 for directory inode 29690737 bad nused
rebuilding directory inode 29690737
free block 16777216 for directory inode 96485213 bad nused
rebuilding directory inode 96485213
free block 16777216 for directory inode 50930667 bad nused
rebuilding directory inode 50930667
free block 16777216 for directory inode 67109183 bad nused
rebuilding directory inode 67109183
free block 16777216 for directory inode 46458573 bad nused
rebuilding directory inode 46458573
entry "man3" in directory inode 62936853 not consistent with .. value (18446744073709551615) in ino 75501223,
	will clear entry "man3"
rebuilding directory inode 62936853
free block 16777216 for directory inode 71308695 bad nused
rebuilding directory inode 71308695
free block 16777216 for directory inode 67134600 bad nused
rebuilding directory inode 67134600
free block 16777216 for directory inode 113257373 bad nused
rebuilding directory inode 113257373
free block 16777216 for directory inode 34419700 bad nused
rebuilding directory inode 34419700
free block 16777216 for directory inode 96469270 bad nused
rebuilding directory inode 96469270
free block 16777216 for directory inode 83886208 bad nused
rebuilding directory inode 83886208
        - traversal finished ... 
        - traversing all unattached subtrees ... 
corrupt block 0 in directory inode 75501223: junking block
rebuilding directory inode 75501223
creating missing "." entry in dir ino 75501223
        - traversals finished ... 
        - moving disconnected inodes to lost+found ... 
disconnected inode 12589404, moving to lost+found
disconnected inode 12591780, moving to lost+found
disconnected inode 12629480, moving to lost+found
disconnected inode 12646097, moving to lost+found
disconnected inode 12654206, moving to lost+found
disconnected inode 12654359, moving to lost+found
disconnected inode 12894519, moving to lost+found
disconnected inode 12894520, moving to lost+found
disconnected inode 12895231, moving to lost+found
disconnected inode 16777353, moving to lost+found
disconnected inode 16778367, moving to lost+found
disconnected inode 33608565, moving to lost+found
disconnected inode 37761455, moving to lost+found
disconnected inode 37776070, moving to lost+found
disconnected inode 46277904, moving to lost+found
disconnected inode 75497741, moving to lost+found
disconnected dir inode 75501223, moving to lost+found
disconnected inode 75501249, moving to lost+found
disconnected inode 75501510, moving to lost+found
disconnected inode 75510902, moving to lost+found
disconnected inode 75520655, moving to lost+found
disconnected inode 75520656, moving to lost+found
disconnected inode 75521710, moving to lost+found
disconnected inode 75528257, moving to lost+found
disconnected inode 75528268, moving to lost+found
disconnected inode 75533032, moving to lost+found
disconnected inode 75533049, moving to lost+found
disconnected inode 75533053, moving to lost+found
disconnected inode 75534873, moving to lost+found
disconnected inode 75541216, moving to lost+found
disconnected inode 75549879, moving to lost+found
disconnected inode 75560335, moving to lost+found
disconnected inode 75616906, moving to lost+found
disconnected inode 75616909, moving to lost+found
disconnected inode 75616910, moving to lost+found
disconnected inode 75616911, moving to lost+found
disconnected inode 75616912, moving to lost+found
disconnected inode 75616914, moving to lost+found
disconnected inode 75616917, moving to lost+found
disconnected inode 75616918, moving to lost+found
disconnected inode 75616919, moving to lost+found
disconnected inode 75616920, moving to lost+found
disconnected inode 75616921, moving to lost+found
disconnected inode 75616922, moving to lost+found
disconnected inode 75616923, moving to lost+found
disconnected inode 75616924, moving to lost+found
disconnected inode 75616927, moving to lost+found
disconnected inode 75619840, moving to lost+found
disconnected inode 75619854, moving to lost+found
disconnected inode 75619856, moving to lost+found
disconnected inode 75619858, moving to lost+found
disconnected inode 75619860, moving to lost+found
disconnected inode 75619862, moving to lost+found
disconnected inode 75619874, moving to lost+found
disconnected inode 75619876, moving to lost+found
disconnected inode 75619880, moving to lost+found
disconnected inode 75619882, moving to lost+found
disconnected inode 75619884, moving to lost+found
disconnected inode 75619892, moving to lost+found
disconnected inode 75619896, moving to lost+found
disconnected inode 75619898, moving to lost+found
disconnected inode 75619902, moving to lost+found
disconnected inode 75620194, moving to lost+found
disconnected inode 75620206, moving to lost+found
disconnected inode 75620208, moving to lost+found
disconnected inode 75633584, moving to lost+found
disconnected inode 75633587, moving to lost+found
disconnected inode 75633597, moving to lost+found
disconnected inode 75633601, moving to lost+found
disconnected inode 75633602, moving to lost+found
disconnected inode 75633608, moving to lost+found
disconnected inode 75633616, moving to lost+found
disconnected inode 75633621, moving to lost+found
disconnected inode 75633625, moving to lost+found
disconnected inode 75633627, moving to lost+found
disconnected inode 75633629, moving to lost+found
disconnected inode 75636070, moving to lost+found
disconnected inode 75636091, moving to lost+found
disconnected inode 75636251, moving to lost+found
disconnected inode 75636253, moving to lost+found
disconnected inode 75636254, moving to lost+found
disconnected inode 75636255, moving to lost+found
disconnected inode 75637216, moving to lost+found
disconnected inode 75638721, moving to lost+found
disconnected inode 75638722, moving to lost+found
disconnected inode 75638724, moving to lost+found
disconnected inode 75638725, moving to lost+found
disconnected inode 75638726, moving to lost+found
disconnected inode 75638727, moving to lost+found
disconnected inode 75638729, moving to lost+found
disconnected inode 75638730, moving to lost+found
disconnected inode 75638777, moving to lost+found
disconnected inode 75638780, moving to lost+found
disconnected inode 75638782, moving to lost+found
disconnected inode 75638783, moving to lost+found
disconnected inode 75641638, moving to lost+found
disconnected inode 75641639, moving to lost+found
disconnected inode 75641640, moving to lost+found
disconnected inode 75641641, moving to lost+found
disconnected inode 75641646, moving to lost+found
disconnected inode 75641647, moving to lost+found
disconnected inode 75641648, moving to lost+found
disconnected inode 75641651, moving to lost+found
disconnected inode 75641652, moving to lost+found
disconnected inode 75641653, moving to lost+found
disconnected inode 75641655, moving to lost+found
disconnected inode 75641657, moving to lost+found
disconnected inode 75641659, moving to lost+found
disconnected inode 75641661, moving to lost+found
disconnected inode 75641665, moving to lost+found
disconnected inode 75641667, moving to lost+found
disconnected inode 75641681, moving to lost+found
disconnected inode 75641685, moving to lost+found
disconnected inode 75641693, moving to lost+found
disconnected inode 75647265, moving to lost+found
disconnected inode 75647283, moving to lost+found
disconnected inode 75647327, moving to lost+found
disconnected inode 75648228, moving to lost+found
disconnected inode 75648232, moving to lost+found
disconnected inode 75648233, moving to lost+found
disconnected inode 75649508, moving to lost+found
disconnected inode 75649511, moving to lost+found
disconnected inode 75649513, moving to lost+found
disconnected inode 75649515, moving to lost+found
disconnected inode 75649888, moving to lost+found
disconnected inode 75655519, moving to lost+found
disconnected inode 75658594, moving to lost+found
disconnected inode 75658595, moving to lost+found
disconnected inode 75658596, moving to lost+found
disconnected inode 75658598, moving to lost+found
disconnected inode 75658599, moving to lost+found
disconnected inode 75658608, moving to lost+found
disconnected inode 75658611, moving to lost+found
disconnected inode 75658613, moving to lost+found
disconnected inode 75658614, moving to lost+found
disconnected inode 75658620, moving to lost+found
disconnected inode 75658622, moving to lost+found
disconnected inode 75658625, moving to lost+found
disconnected inode 75658626, moving to lost+found
disconnected inode 75658629, moving to lost+found
disconnected inode 75658630, moving to lost+found
disconnected inode 75658632, moving to lost+found
disconnected inode 75658633, moving to lost+found
disconnected inode 75658634, moving to lost+found
disconnected inode 75658637, moving to lost+found
disconnected inode 75658640, moving to lost+found
disconnected inode 75658648, moving to lost+found
disconnected inode 75659115, moving to lost+found
disconnected inode 75659116, moving to lost+found
disconnected inode 75659117, moving to lost+found
disconnected inode 75659119, moving to lost+found
disconnected inode 75683988, moving to lost+found
disconnected inode 75683989, moving to lost+found
disconnected inode 75683997, moving to lost+found
disconnected inode 75684027, moving to lost+found
disconnected inode 75689664, moving to lost+found
disconnected inode 75689666, moving to lost+found
disconnected inode 75689673, moving to lost+found
disconnected inode 75689674, moving to lost+found
disconnected inode 75689675, moving to lost+found
disconnected inode 75689676, moving to lost+found
disconnected inode 75689679, moving to lost+found
disconnected inode 75689682, moving to lost+found
disconnected inode 75689695, moving to lost+found
disconnected inode 75689696, moving to lost+found
disconnected inode 75689703, moving to lost+found
disconnected inode 75689704, moving to lost+found
disconnected inode 75689711, moving to lost+found
disconnected inode 75689719, moving to lost+found
disconnected inode 75689752, moving to lost+found
disconnected inode 75689753, moving to lost+found
disconnected inode 75689758, moving to lost+found
disconnected inode 75689762, moving to lost+found
disconnected inode 75689764, moving to lost+found
disconnected inode 75689770, moving to lost+found
disconnected inode 75689773, moving to lost+found
disconnected inode 75689782, moving to lost+found
disconnected inode 75689786, moving to lost+found
disconnected inode 75689788, moving to lost+found
disconnected inode 75689874, moving to lost+found
disconnected inode 92336260, moving to lost+found
Phase 7 - verify and correct link counts...
Terminated
jw:/home/jason# echo $?
143


--9amGYk9869ThD9tj--
