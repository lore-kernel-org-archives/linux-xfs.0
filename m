Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C160B7F37
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 16:29:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A19BC304032
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 14:29:45 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	OfpyntTlQiJzwzdE for <xfs@oss.sgi.com>;
	Sat, 13 Jul 2013 14:29:40 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 157A91F004AC
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 17:29:40 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id CXIbQchim-CH for <xfs@oss.sgi.com>;
	Sat, 13 Jul 2013 17:29:35 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id 9427E1F004B6
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 17:29:35 -0400 (EDT)
Date: Sat, 13 Jul 2013 17:29:35 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <10640767.1356.1373750975524.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <18642856.1344.1373749779825.JavaMail.root@benjamin.baylink.com>
Subject: XFS filesystem triggering assert in _repair 3.1.11
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

My sister's DVR runs MythTV (presently 0.23-fixes [26835]) on openSuSE
11.4:

Linux plaintain 2.6.37.6-24-desktop #1 SMP PREEMPT 2012-10-18 22:36:08 +0200 i686 athlon i386 GNU/Linux

It has had a number of XFS filesystems over the years for media storage,
and except for one major flameout a few years ago when I had a PATA 
interface lose a cable wire -- which Dave politely helped me dig out from
under -- it's been quite reliable.

About halfway through June, a surge apparently put a hurtin on our 7 year
old Antec power supply, and it slowly failed over the next couple weeks.

In the process, its 12V rail apparently went first; this is my perceived
cause for a 2TB deathstar giving me a SMART failure for Spin Retry Count.

But the week before that, the 1TB deathstar started actually dropping
sectors, and I copied all its data onto a freshly bought Seagate 3TB.

4 days later, when I noticed that SMART had tripped on the 2TB, I copied
all its data to the same new 3TB, which didn't quite fill, and that drive
has been well behaved.

The *earlier* 3TB, though, hs been giving me trouble; it's filesystem has 
had some deeply buried problem that neither mounting nor running xfs_repair 
has been able to fix -- and it's probably been exacerbated by the fact 
that if I inadvertantly boot the box with that filesystem in fstab, and
it tried to mount it while broken, a) it locks up that disk channel and 
b) the machine won't reboot, forcing me to hit the big orange switch.

That's where I am right now: the drive was throwing a kernel oops if I 
mounted it, and xfs_repair would just lock up.  I had to do a -L on
it, after which it would mount and unmount cleanly, and xfs_repair runs 
and finds problems, but then fails an assert at the end and dies.

Here's that entire repair run:

=============================================================
plaintain:/var/log/mythtv # xfs_repair /dev/sdc2
Phase 1 - find and verify superblock...
Not enough RAM available for repair to enable prefetching.
This will be _slow_.
You need at least 491MB RAM to run with prefetching enabled.
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
ir_freecount/free mismatch, inode chunk 1/2592, freecount 48 nfree 47
block (26,6078453-6078453) multiply claimed by cnt space tree, state - 2
block (26,6080485-6080485) multiply claimed by cnt space tree, state - 2
block (26,6086085-6086085) multiply claimed by cnt space tree, state - 2
block (26,6088021-6088021) multiply claimed by cnt space tree, state - 2
block (26,6090742-6090742) multiply claimed by cnt space tree, state - 2
block (26,6598495-6598495) multiply claimed by cnt space tree, state - 2
block (26,6675283-6675283) multiply claimed by cnt space tree, state - 2
block (26,6675571-6675571) multiply claimed by cnt space tree, state - 2
block (26,6677075-6677075) multiply claimed by cnt space tree, state - 2
block (26,6678323-6678323) multiply claimed by cnt space tree, state - 2
block (26,6691619-6691619) multiply claimed by cnt space tree, state - 2
block (26,7978069-7978069) multiply claimed by cnt space tree, state - 2
block (26,7978373-7978373) multiply claimed by cnt space tree, state - 2
block (26,8044104-8044104) multiply claimed by cnt space tree, state - 2
block (26,8046200-8046200) multiply claimed by cnt space tree, state - 2
block (26,8046456-8046456) multiply claimed by cnt space tree, state - 2
block (26,8048872-8048872) multiply claimed by cnt space tree, state - 2
block (26,8052216-8052216) multiply claimed by cnt space tree, state - 2
block (26,8054840-8054840) multiply claimed by cnt space tree, state - 2
block (26,8055128-8055128) multiply claimed by cnt space tree, state - 2
block (26,8058712-8058712) multiply claimed by cnt space tree, state - 2
block (26,8060904-8060904) multiply claimed by cnt space tree, state - 2
block (26,8062664-8062664) multiply claimed by cnt space tree, state - 2
block (26,8063976-8063976) multiply claimed by cnt space tree, state - 2
block (26,8064504-8064504) multiply claimed by cnt space tree, state - 2
block (26,8069192-8069192) multiply claimed by cnt space tree, state - 2
block (26,8069480-8069480) multiply claimed by cnt space tree, state - 2
block (26,8081096-8081096) multiply claimed by cnt space tree, state - 2
block (26,8083192-8083192) multiply claimed by cnt space tree, state - 2
block (26,8084824-8084824) multiply claimed by cnt space tree, state - 2
block (26,8086856-8086856) multiply claimed by cnt space tree, state - 2
block (26,8099096-8099096) multiply claimed by cnt space tree, state - 2
block (26,8102008-8102008) multiply claimed by cnt space tree, state - 2
block (26,8103048-8103048) multiply claimed by cnt space tree, state - 2
block (26,8105688-8105688) multiply claimed by cnt space tree, state - 2
block (26,8106744-8106744) multiply claimed by cnt space tree, state - 2
agf_freeblks 6334546, counted 6340626 in ag 26
sb_ifree 1118, counted 1201
sb_fdblocks 177570233, counted 188434072
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
imap claims a free inode 536873565 is in use, correcting imap and clearing inode
cleared inode 536873565
        - agno = 2
entry "/008_20130328203000.mpg" at block 10 offset 296 in directory inode 1073789184 references invalid inode 18374686479671623679
        clearing inode number in entry at offset 296...
entry at block 10 offset 296 in directory inode 1073789184 has illegal name "/008_20130328203000.mpg": entry "/011_20130622233500.mpg" at block 10 offset 1656 in directory inode 1073789184 references invalid inode 18374686479671623679
        clearing inode number in entry at offset 1656...
entry at block 10 offset 1656 in directory inode 1073789184 has illegal name "/011_20130622233500.mpg": entry "/011_20130624003500.mpg.png" at block 13 offset 656 in directory inode 1073789184 references invalid inode 18374686479671623679
        clearing inode number in entry at offset 656...
entry at block 13 offset 656 in directory inode 1073789184 has illegal name "/011_20130624003500.mpg.png": entry "/013_20130429100000.mpg" at block 13 offset 816 in directory inode 1073789184 references invalid inode 18374686479671623679
        clearing inode number in entry at offset 816...
entry at block 13 offset 816 in directory inode 1073789184 has illegal name "/013_20130429100000.mpg": entry "/011_20130429183100.mpg" at block 13 offset 976 in directory inode 1073789184 references invalid inode 18374686479671623679
        clearing inode number in entry at offset 976...
entry at block 13 offset 976 in directory inode 1073789184 has illegal name "/011_20130429183100.mpg": entry "/011_20130430183100.mpg" at block 13 offset 1216 in directory inode 1073789184 references invalid inode 18374686479671623679
        clearing inode number in entry at offset 1216...
entry at block 13 offset 1216 in directory inode 1073789184 has illegal name "/011_20130430183100.mpg": entry "/025_20130509010100.mpg" at block 13 offset 3736 in directory inode 1073789184 references invalid inode 18374686479671623679
        clearing inode number in entry at offset 3736...
entry at block 13 offset 3736 in directory inode 1073789184 has illegal name "/025_20130509010100.mpg": entry "/011_20130509110000.mpg" at block 13 offset 3816 in directory inode 1073789184 references invalid inode 18374686479671623679
        clearing inode number in entry at offset 3816...
entry at block 13 offset 3816 in directory inode 1073789184 has illegal name "/011_20130509110000.mpg": data fork in ino 1136058713 claims free block 880392933
data fork in ino 1136058713 claims free block 880393189
data fork in ino 1136058713 claims free block 880393477
data fork in ino 1136058713 claims free block 880394262
data fork in ino 1136058713 claims free block 880394566
data fork in ino 1136058713 claims free block 880396406
data fork in ino 1136058713 claims free block 880459208
data fork in ino 1136058713 claims free block 880459976
data fork in ino 1136058713 claims free block 880461304
data fork in ino 1136058713 claims free block 880461560
data fork in ino 1136058713 claims free block 880463080
data fork in ino 1136058713 claims free block 880463704
data fork in ino 1136058713 claims free block 880463992
data fork in ino 1136058713 claims free block 880465016
data fork in ino 1136058713 claims free block 880467320
data fork in ino 1136058713 claims free block 880469960
data fork in ino 1136058713 claims free block 880470232
data fork in ino 1136058713 claims free block 880471464
data fork in ino 1136058713 claims free block 880473816
data fork in ino 1136058713 claims free block 880476008
data fork in ino 1136058713 claims free block 880476760
data fork in ino 1136058713 claims free block 880477768
data fork in ino 1136058713 claims free block 880479080
data fork in ino 1136058713 claims free block 880479336
data fork in ino 1136058713 claims free block 880479608
data fork in ino 1136058713 claims free block 880480376
data fork in ino 1136058713 claims free block 880483256
data fork in ino 1136058713 claims free block 880484008
data fork in ino 1136058713 claims free block 880484296
data fork in ino 1136058713 claims free block 880484584
data fork in ino 1136058713 claims free block 880495464
data fork in ino 1136058713 claims free block 880496216
data fork in ino 1136058713 claims free block 880497544
data fork in ino 1136058713 claims free block 880498296
data fork in ino 1136058713 claims free block 880499928
data fork in ino 1136058713 claims free block 880500680
data fork in ino 1136058713 claims free block 880501960
data fork in ino 1136058713 claims free block 880514200
data fork in ino 1136058713 claims free block 880515624
data fork in ino 1136058713 claims free block 880517112
data fork in ino 1136058713 claims free block 880517880
data fork in ino 1136058713 claims free block 880518152
data fork in ino 1136058713 claims free block 880519496
data fork in ino 1136058713 claims free block 880520808
data fork in ino 1136058713 claims free block 880521352
data fork in ino 1136058713 claims free block 880521848
data fork in ino 1136058713 claims free block 880522680
data fork in ino 1136058713 claims free block 880522681
data fork in ino 1136058713 claims free block 880522968
data fork in ino 1136058713 claims free block 880522969
data fork in ino 1136058713 claims free block 880523241
data fork in ino 1136058713 claims free block 880523242
data fork in ino 1136058713 claims free block 880523513
data fork in ino 1136058713 claims free block 880523514
data fork in ino 1136058713 claims free block 880523753
data fork in ino 1136058713 claims free block 880523754
data fork in ino 1136058713 claims free block 880524826
data fork in ino 1136058713 claims free block 880524827
data fork in ino 1136058713 claims free block 880525306
data fork in ino 1136058713 claims free block 880525307
data fork in ino 1136058713 claims free block 880526586
data fork in ino 1136058713 claims free block 880526587
data fork in ino 1136058713 claims free block 880526842
data fork in ino 1136058713 claims free block 880526843
data fork in ino 1136058713 claims free block 880527354
data fork in ino 1136058713 claims free block 880527355
data fork in ino 1136058713 claims free block 880527594
data fork in ino 1136058713 claims free block 880527595
data fork in ino 1136058713 claims free block 880527882
data fork in ino 1136058713 claims free block 880527883
data fork in ino 1136058713 claims free block 880528378
data fork in ino 1136058713 claims free block 880528379
data fork in ino 1136058713 claims free block 880528634
data fork in ino 1136058713 claims free block 880528635
data fork in ino 1136058713 claims free block 880529162
data fork in ino 1136058713 claims free block 880529163
data fork in ino 1136058713 claims free block 880529450
data fork in ino 1136058713 claims free block 880529451
data fork in ino 1136058713 claims free block 880530026
data fork in ino 1136058713 claims free block 880530027
data fork in ino 1136058713 claims free block 880530314
data fork in ino 1136058713 claims free block 880530315
data fork in ino 1136058713 claims free block 880530522
data fork in ino 1136058713 claims free block 880530523
data fork in ino 1136058713 claims free block 880530746
data fork in ino 1136058713 claims free block 880530747
data fork in ino 1136058713 claims free block 880531274
data fork in ino 1136058713 claims free block 880531275
data fork in ino 1136058713 claims free block 880531546
data fork in ino 1136058713 claims free block 880531547
data fork in ino 1136058713 claims free block 880531818
data fork in ino 1136058713 claims free block 880531819
data fork in ino 1136058713 claims free block 880532602
data fork in ino 1136058713 claims free block 880532603
data fork in ino 1136058713 claims free block 880532826
data fork in ino 1136058713 claims free block 880532827
data fork in ino 1136058713 claims free block 880533610
data fork in ino 1136058713 claims free block 880533611
data fork in ino 1136058713 claims free block 880533834
data fork in ino 1136058713 claims free block 880533835
data fork in ino 1136058713 claims free block 880534106
data fork in ino 1136058713 claims free block 880534107
data fork in ino 1136058713 claims free block 880534362
data fork in ino 1136058713 claims free block 880534363
data fork in ino 1136058713 claims free block 880534858
data fork in ino 1136058713 claims free block 880534859
data fork in ino 1136058713 claims free block 880535146
data fork in ino 1136058713 claims free block 880535147
data fork in ino 1136058713 claims free block 880535690
data fork in ino 1136058713 claims free block 880535691
data fork in ino 1136058713 claims free block 880535962
data fork in ino 1136058713 claims free block 880535963
data fork in ino 1136058713 claims free block 880536490
data fork in ino 1136058713 claims free block 880536491
data fork in ino 1136058713 claims free block 880536762
data fork in ino 1136058713 claims free block 880536763
data fork in ino 1136058713 claims free block 880537034
data fork in ino 1136058713 claims free block 880537035
data fork in ino 1136058713 claims free block 880537322
data fork in ino 1136058713 claims free block 880537323
data fork in ino 1136058713 claims free block 880537610
data fork in ino 1136058713 claims free block 880537611
data fork in ino 1136058713 claims free block 880541370
data fork in ino 1136058713 claims free block 880541371
data fork in ino 1136058713 claims free block 880541658
data fork in ino 1136058713 claims free block 880541659
data fork in ino 1136058713 claims free block 880545914
data fork in ino 1136058713 claims free block 880545915
data fork in ino 1136058713 claims free block 880546202
data fork in ino 1136058713 claims free block 880546203
data fork in ino 1136058713 claims free block 880546458
data fork in ino 1136058713 claims free block 880546459
data fork in ino 1136058713 claims free block 880546698
data fork in ino 1136058713 claims free block 880546699
data fork in ino 1136058713 claims free block 880547210
data fork in ino 1136058713 claims free block 880547211
data fork in ino 1136058713 claims free block 880547482
data fork in ino 1136058713 claims free block 880547483
data fork in ino 1136058713 claims free block 880547738
data fork in ino 1136058713 claims free block 880547739
data fork in ino 1136058713 claims free block 880548026
data fork in ino 1136058713 claims free block 880548027
data fork in ino 1136058713 claims free block 880548298
data fork in ino 1136058713 claims free block 880548299
data fork in ino 1136058713 claims free block 880549546
data fork in ino 1136058713 claims free block 880549547
data fork in ino 1136058713 claims free block 880549834
data fork in ino 1136058713 claims free block 880549835
data fork in ino 1136058713 claims free block 880550074
data fork in ino 1136058713 claims free block 880550075
data fork in ino 1136058713 claims free block 880550330
data fork in ino 1136058713 claims free block 880550331
data fork in ino 1136058713 claims free block 880550586
data fork in ino 1136058713 claims free block 880550587
data fork in ino 1136058713 claims free block 880551098
data fork in ino 1136058713 claims free block 880551099
data fork in ino 1136058713 claims free block 880551338
data fork in ino 1136058713 claims free block 880551339
data fork in ino 1136058713 claims free block 880551610
data fork in ino 1136058713 claims free block 880551611
data fork in ino 1136058713 claims free block 880552634
data fork in ino 1136058713 claims free block 880552635
data fork in ino 1136058713 claims free block 880552906
data fork in ino 1136058713 claims free block 880552907
data fork in ino 1136058713 claims free block 880557850
data fork in ino 1136058713 claims free block 880557851
data fork in ino 1136058713 claims free block 880558138
data fork in ino 1136058713 claims free block 880558139
data fork in ino 1136058713 claims free block 880564362
data fork in ino 1136058713 claims free block 880564363
data fork in ino 1136058713 claims free block 882067557
data fork in ino 1136058713 claims free block 882067558
data fork in ino 1136058713 claims free block 882067973
data fork in ino 1136058713 claims free block 882067974
data fork in ino 1136058713 claims free block 882068373
data fork in ino 1136058713 claims free block 882068374
data fork in ino 1136058713 claims free block 882068741
data fork in ino 1136058713 claims free block 882068742
data fork in ino 1136058713 claims free block 882069157
data fork in ino 1136058713 claims free block 882069158
data fork in ino 1136058713 claims free block 882069557
data fork in ino 1136058713 claims free block 882069558
data fork in ino 1136058713 claims free block 882070357
data fork in ino 1136058713 claims free block 882070358
data fork in ino 1136058713 claims free block 882070773
data fork in ino 1136058713 claims free block 882070774
data fork in ino 1136058713 claims free block 882071189
data fork in ino 1136058713 claims free block 882071190
data fork in ino 1136058713 claims free block 882072693
data fork in ino 1136058713 claims free block 882072694
data fork in ino 1136058713 claims free block 882073125
data fork in ino 1136058713 claims free block 882073126
data fork in ino 1136058713 claims free block 882074709
data fork in ino 1136058713 claims free block 882074710
data fork in ino 1136058713 claims free block 882073925
data fork in ino 1136058713 claims free block 882073926
data fork in ino 1136058713 claims free block 882077445
data fork in ino 1136058713 claims free block 882077446
data fork in ino 1136058713 claims free block 882077861
data fork in ino 1136058713 claims free block 882077862
data fork in ino 1136058713 claims free block 882078277
data fork in ino 1136058713 claims free block 882078278
data fork in ino 1136058713 claims free block 882079381
data fork in ino 1136058713 claims free block 882079382
data fork in ino 1136058713 claims free block 882081317
data fork in ino 1136058713 claims free block 882081318
data fork in ino 1136058713 claims free block 882081989
data fork in ino 1136058713 claims free block 882081990
data fork in ino 1136058713 claims free block 882082293
data fork in ino 1136058713 claims free block 882082294
data fork in ino 1136058713 claims free block 882082693
data fork in ino 1136058713 claims free block 882082694
data fork in ino 1136058713 claims free block 882083077
data fork in ino 1136058713 claims free block 882083078
data fork in ino 1136058713 claims free block 882083477
data fork in ino 1136058713 claims free block 882083478
data fork in ino 1136058713 claims free block 882084229
data fork in ino 1136058713 claims free block 882084230
data fork in ino 1136058713 claims free block 882084965
data fork in ino 1136058713 claims free block 882084966
data fork in ino 1136058713 claims free block 882085749
data fork in ino 1136058713 claims free block 882085750
data fork in ino 1136058713 claims free block 882086197
data fork in ino 1136058713 claims free block 882086198
data fork in ino 1136058713 claims free block 882086581
data fork in ino 1136058713 claims free block 882086582
data fork in ino 1136058713 claims free block 882091621
data fork in ino 1136058713 claims free block 882091622
data fork in ino 1136058713 claims free block 882093205
data fork in ino 1136058713 claims free block 882093206
data fork in ino 1136058713 claims free block 882094405
data fork in ino 1136058713 claims free block 882094406
data fork in ino 1136058713 claims free block 885391697
data fork in ino 1136058713 claims free block 885391698
data fork in ino 1136058713 claims free block 885393713
data fork in ino 1136058713 claims free block 885393714
data fork in ino 1136058713 claims free block 885394017
data fork in ino 1136058713 claims free block 885394018
data fork in ino 1136058713 claims free block 885396673
data fork in ino 1136058713 claims free block 885396674
data fork in ino 1136058713 claims free block 885397937
data fork in ino 1136058713 claims free block 885397938
data fork in ino 1136058713 claims free block 885398689
data fork in ino 1136058713 claims free block 885398690
data fork in ino 1136058713 claims free block 885399233
data fork in ino 1136058713 claims free block 885399234
data fork in ino 1136058713 claims free block 885400465
data fork in ino 1136058713 claims free block 885400466
data fork in ino 1136058713 claims free block 885400737
data fork in ino 1136058713 claims free block 885400738
data fork in ino 1136058713 claims free block 885402513
data fork in ino 1136058713 claims free block 885402514
data fork in ino 1136058713 claims free block 885402817
data fork in ino 1136058713 claims free block 885402818
data fork in ino 1136058713 claims free block 885403089
data fork in ino 1136058713 claims free block 885403090
data fork in ino 1136058713 claims free block 885403361
data fork in ino 1136058713 claims free block 885403362
data fork in ino 1136058713 claims free block 885403649
data fork in ino 1136058713 claims free block 885403650
data fork in ino 1136058713 claims free block 885403921
data fork in ino 1136058713 claims free block 885403922
data fork in ino 1136058713 claims free block 885404609
data fork in ino 1136058713 claims free block 885404610
data fork in ino 1136058713 claims free block 885410945
data fork in ino 1136058713 claims free block 885410946
bad back (left) sibling pointer (saw 16140901064495857663 should be NULL (0))
        in inode 1137017084 (data fork) bmap btree block 151485768
bad data fork in inode 1137017084
cleared inode 1137017084
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
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
entry "1011_20130509205900.mpg" at block 13 offset 4016 in directory inode 1073789184 references free inode 1137017084
        clearing inode number in entry at offset 4016...
bad back (left) sibling pointer (saw 16140901064495857663 should be NULL (0))
        in inode 1115989006 (data fork) bmap btree block 107963248
xfs_repair: dinode.c:2136: process_inode_data_fork: Assertion `err == 0' failed.
Aborted
=============================================================

This is xfs_repair 3.1.11, from xfsprogs 3.1.11 from tarball, compiled on
the machine in question, which is a 32-bit OS with 512MB of ram (the
mobo, an old MSI KT6V, pukes if we try to put more ram on it for some
reason).  I have run memtest+ on the ram and multiple passes come
back clean as a whistle; the SATA controller is a SiI 3114, which we
had to buy to talk to the 3TB drives; boot is from the VT6420 on the
motherboard and a dedicated 40G Samsung.

I have done some work on this repair booted from a Suse 12.1 rescue disk 
with a 3.7 kernel, on the theory that the XFS drivers in the kernel
might help; I found that mounting and unmounting in between multiple
repair runs made me have to do less of them -- though I'm sure more
than two dirty runs before one sees a clean one ought to be Right Out
anyway.

I've seen suggestions on the mailing list archives and other places
that (some) assertion fails were for things fixed in earlier tools
releases, but that one's not helping me...

I have space to move this data off and remake the filesystem,
if I can get it to mount reliably and stay that way long enough.

Any assistance cheerfully appreciated.  :-)

Cheers,
-- jra
-- 
Jay R. Ashworth                  Baylink                       jra@baylink.com
Designer                     The Things I Think                       RFC 2100
Ashworth & Associates     http://baylink.pitas.com         2000 Land Rover DII
St Petersburg FL USA               #natog                      +1 727 647 1274

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
