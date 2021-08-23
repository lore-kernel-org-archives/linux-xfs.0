Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85AABC4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 03:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6315161040
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 03:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhHWDJO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Aug 2021 23:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232362AbhHWDJN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 22 Aug 2021 23:09:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5F99461360
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 03:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629688111;
        bh=ArKLyqeiE46yTPfxU7kV0kUpIH/mhYf0TAM+Q+ydYbs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GeTuHFoKIxLtMcQQxqBmbMAjWBHxXE/QlfmPSMwE/jKyzzVxjs4xhm2N4SWF1dwKA
         9wzk0bCxLG7JtQlRawY5qs4+zIcT6UA5wpqE8i/qBQuLmlrRwrfa3aqlR2YJxF99ww
         90uxYFyBT3Z0dGdxuLqyAIFEwSAaFAe448/JCsJs3bVE8Dx8+pjrPAC+O4kQP5Q/vL
         ZHbKo4MEggP6ehbz7Q7ZSRej9/3Kp3/Gsk5zAlE6p0pQDFW3gmRWpmiMVvKprLUtYz
         6/En79yuuyLUe+6Dks+Kzajr5Wl04Pwu0GRtwuJXWLte7sE7ozT6KHdb3pR6MDy50J
         xWiMQs1MqzrLQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214077] [xfstests xfs/168] xfs_repair failed with shrinking
 776672
Date:   Mon, 23 Aug 2021 03:08:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214077-201763-kUqD14EDeh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214077-201763@https.bugzilla.kernel.org/>
References: <bug-214077-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214077

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
It's not only on ppc64le, I hit it on x86_64 with 1k blocksize xfs:


meta-data=3D/dev/sda4              isize=3D512    agcount=3D2, agsize=3D517=
120 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D1
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D1024   blocks=3D777569, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D1024   blocks=3D6011, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ALERT: The filesystem has valuable metadata changes in a log which is being
ignored because the -n option was used.  Expect spurious inconsistencies
which may be resolved by first mounting the filesystem to replay the log.
        - scan filesystem freespace and inode maps...
block (1,34732-34741) multiply claimed by cnt space tree, state - 2
block (1,13515-13531) multiply claimed by cnt space tree, state - 2
block (1,24562-24578) multiply claimed by cnt space tree, state - 2
block (1,40696-40712) multiply claimed by cnt space tree, state - 2
block (1,61159-61175) multiply claimed by cnt space tree, state - 2
block (1,103867-103883) multiply claimed by cnt space tree, state - 2
block (0,411364-411366) multiply claimed by cnt space tree, state - 2
block (0,264601-264605) multiply claimed by cnt space tree, state - 2
block (0,323760-323778) multiply claimed by cnt space tree, state - 2
block (0,296448-296452) multiply claimed by cnt space tree, state - 2
block (0,329426-329439) multiply claimed by cnt space tree, state - 2
block (0,387875-387879) multiply claimed by cnt space tree, state - 2
block (0,300749-300755) multiply claimed by cnt space tree, state - 2
block (0,371814-371820) multiply claimed by cnt space tree, state - 2
block (0,409514-409533) multiply claimed by cnt space tree, state - 2
block (0,363353-363363) multiply claimed by cnt space tree, state - 2
block (0,365339-365350) multiply claimed by cnt space tree, state - 2
block (0,406170-406184) multiply claimed by cnt space tree, state - 2
block (0,366667-366681) multiply claimed by cnt space tree, state - 2
block (0,410945-410955) multiply claimed by cnt space tree, state - 2
block (0,364395-364403) multiply claimed by cnt space tree, state - 2
block (0,374209-374211) multiply claimed by cnt space tree, state - 2
block (0,374452-374457) multiply claimed by cnt space tree, state - 2
block (0,362639-362644) multiply claimed by cnt space tree, state - 2
block (0,363071-363091) multiply claimed by cnt space tree, state - 2
block (0,418627-418639) multiply claimed by cnt space tree, state - 2
block (0,418857-418875) multiply claimed by cnt space tree, state - 2
block (0,420484-420499) multiply claimed by cnt space tree, state - 2
block (0,421474-421495) multiply claimed by cnt space tree, state - 2
block (0,424507-424519) multiply claimed by cnt space tree, state - 2
block (0,427415-427438) multiply claimed by cnt space tree, state - 2
rmap rmap btree block claimed (state 2), agno 0, bno 138214, suspect 0
agf_freeblks 22372, counted 20706 in ag 1
record 37 greater than high key of block (0/255742) in rmap tree
record 32 greater than high key of block (0/158153) in rmap tree
record 33 greater than high key of block (0/158153) in rmap tree
record 34 greater than high key of block (0/158153) in rmap tree
record 35 greater than high key of block (0/158153) in rmap tree
record 36 greater than high key of block (0/158153) in rmap tree
record 37 greater than high key of block (0/158153) in rmap tree
record 38 greater than high key of block (0/158153) in rmap tree
bad rmapbt block count 117, saw 116
agf_freeblks 114622, counted 114729 in ag 0
agf_btreeblks 130, counted 131 in ag 0
inode chunk claims used block, inobt block - agno 0, bno 296416, inopb 2
inode chunk claims used block, finobt block - agno 0, bno 296416, inopb 2
agi unlinked bucket 51 is 577843 in ag 0 (inode=3D577843)
agi unlinked bucket 53 is 577845 in ag 0 (inode=3D577845)
sb_icount 2816, counted 2880
sb_ifree 56, counted 64
sb_fdblocks 137256, counted 135698
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
found inodes not in the inode allocation tree
        - process known inodes and perform inode discovery...
        - agno =3D 0
data fork in ino 452278 claims free block 362118
data fork in ino 452278 claims free block 362239
data fork in ino 452278 claims free block 362320
data fork in ino 452278 claims free block 362645
data fork in ino 452278 claims free block 363032
data fork in ino 452278 claims free block 300709
data fork in ino 452278 claims free block 362672
data fork in ino 511501 claims free block 338472
data fork in ino 511501 claims free block 363542
data fork in ino 511501 claims free block 363731
data fork in ino 511501 claims free block 363738
data fork in ino 511501 claims free block 365243
data fork in ino 511501 claims free block 363264
data fork in ino 511501 claims free block 363320
data fork in ino 511501 claims free block 371749
data fork in ino 511501 claims free block 362020
data fork in ino 511501 claims free block 416620
data fork in ino 511501 claims free block 416928
data fork in ino 511501 claims free block 417095
data fork in ino 511501 claims free block 418780
data fork in ino 511501 claims free block 418503
data fork in ino 511501 claims free block 418612
data fork in ino 511519 claims free block 406073
data fork in ino 511519 claims free block 406636
data fork in ino 511519 claims free block 421717
data fork in ino 511519 claims free block 421833
data fork in ino 532936 claims free block 338802
data fork in ino 532936 claims free block 362329
data fork in ino 577842 claims free block 410576
data fork in ino 577842 claims free block 410944
data fork in ino 577842 claims free block 370544
data fork in ino 577842 claims free block 397385
data fork in ino 577842 claims free block 397426
data fork in ino 577853 claims free block 410639
data fork in ino 577853 claims free block 427837
data fork in ino 577853 claims free block 382745
data fork in ino 577854 claims free block 424520
data fork in ino 577854 claims free block 419085
data fork in ino 577854 claims free block 360032
data fork in ino 577854 claims free block 360135
data fork in ino 577854 claims free block 424953
data fork in ino 577854 claims free block 426599
data fork in ino 577854 claims free block 427090
data fork in ino 577854 claims free block 427642
data fork in ino 577854 claims free block 427687
data fork in ino 577855 claims free block 349669
data fork in ino 577855 claims free block 425731
data fork in ino 577855 claims free block 425198
data fork in ino 577855 claims free block 366557
data fork in ino 577855 claims free block 425363
data fork in ino 577855 claims free block 427355
data fork in ino 589415 claims free block 362861
data fork in ino 589415 claims free block 362974
data fork in ino 589415 claims free block 421840
data fork in ino 589415 claims free block 421371
        - agno =3D 1
imap claims in-use inode 1108439 is free, would correct imap
imap claims in-use inode 1324608 is free, would correct imap
imap claims in-use inode 1324660 is free, would correct imap
data fork in ino 1343808 claims free block 300003
data fork in ino 1343808 claims free block 300704
data fork in ino 1343808 claims free block 300713
data fork in ino 1343808 claims free block 300731
data fork in ino 1343808 claims free block 327915
data fork in ino 1343808 claims free block 329394
data fork in ino 1343808 claims free block 323741
imap claims in-use inode 1343808 is free, would correct imap
imap claims in-use inode 1343818 is free, would correct imap
data fork in ino 1408785 claims free block 363797
data fork in ino 1408785 claims free block 365162
imap claims in-use inode 1408785 is free, would correct imap
imap claims in-use inode 1408786 is free, would correct imap
imap claims in-use inode 1408787 is free, would correct imap
data fork in ino 1408788 claims free block 409146
data fork in ino 1408788 claims free block 410237
data fork in ino 1408788 claims free block 410492
data fork in ino 1408788 claims free block 410291
data fork in ino 1408788 claims free block 410339
data fork in ino 1408788 claims free block 423318
data fork in ino 1408788 claims free block 411074
imap claims in-use inode 1408788 is free, would correct imap
imap claims in-use inode 1408789 is free, would correct imap
imap claims in-use inode 1408790 is free, would correct imap
imap claims in-use inode 1408791 is free, would correct imap
imap claims in-use inode 1408792 is free, would correct imap
imap claims in-use inode 1408793 is free, would correct imap
data fork in ino 1408794 claims free block 422637
data fork in ino 1408794 claims free block 423237
data fork in ino 1408794 claims free block 423272
data fork in ino 1408794 claims free block 425964
data fork in ino 1408794 claims free block 426006
imap claims in-use inode 1408794 is free, would correct imap
imap claims in-use inode 1408795 is free, would correct imap
data fork in ino 1408796 claims free block 418641
data fork in ino 1408796 claims free block 418876
data fork in ino 1408796 claims free block 419004
data fork in ino 1408796 claims free block 428177
data fork in ino 1408796 claims free block 428433
data fork in ino 1408796 claims free block 428551
imap claims in-use inode 1408796 is free, would correct imap
data fork in ino 1408797 claims free block 364273
data fork in ino 1408797 claims free block 417392
imap claims in-use inode 1408797 is free, would correct imap
data fork in ino 1408798 claims free block 429094
data fork in ino 1408798 claims free block 429211
imap claims in-use inode 1408798 is free, would correct imap
data fork in ino 1408799 claims free block 412330
data fork in ino 1408799 claims free block 414298
data fork in ino 1408799 claims free block 419296
imap claims in-use inode 1408799 is free, would correct imap
data fork in ino 1472974 claims free block 410739
data fork in ino 1472974 claims free block 411339
imap claims in-use inode 1472974 is free, would correct imap
imap claims in-use inode 1472977 is free, would correct imap
imap claims in-use inode 1472983 is free, would correct imap
data fork in ino 1472987 claims free block 374337
imap claims in-use inode 1472987 is free, would correct imap
imap claims in-use inode 1472992 is free, would correct imap
data fork in ino 1472999 claims free block 362517
data fork in ino 1472999 claims free block 428975
imap claims in-use inode 1472999 is free, would correct imap
data fork in ino 1473006 claims free block 374049
data fork in ino 1473006 claims free block 428899
data fork in ino 1473006 claims free block 428969
imap claims in-use inode 1473006 is free, would correct imap
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
free space (0,177100-177133) only seen by one free space btree
unknown block state, ag 0, blocks 225303-225326
free space (0,228796-228822) only seen by one free space btree
free space (0,264568-264600) only seen by one free space btree
unknown block state, ag 0, blocks 291063-291103
unknown block state, ag 0, blocks 291717-291737
free space (0,296411-296447) only seen by one free space btree
unknown block state, ag 0, blocks 304309-304328
unknown block state, ag 0, blocks 304956-304991
unknown block state, ag 0, blocks 306075-306091
unknown block state, ag 0, blocks 307617-307624
unknown block state, ag 0, blocks 308233-308235
unknown block state, ag 0, blocks 308239-308239
unknown block state, ag 0, blocks 308240-308255
unknown block state, ag 0, blocks 310608-310608
unknown block state, ag 0, blocks 314442-314513
unknown block state, ag 0, blocks 319007-319121
unknown block state, ag 0, blocks 319482-319570
unknown block state, ag 0, blocks 322294-322387
unknown block state, ag 0, blocks 326324-326341
unknown block state, ag 0, blocks 326354-326788
unknown block state, ag 0, blocks 332833-332903
unknown block state, ag 0, blocks 334095-334185
free space (0,338993-338997) only seen by one free space btree
unknown block state, ag 0, blocks 339255-339501
unknown block state, ag 0, blocks 341326-341410
unknown block state, ag 0, blocks 342037-342103
unknown block state, ag 0, blocks 342153-342261
unknown block state, ag 0, blocks 342312-342344
unknown block state, ag 0, blocks 344923-345038
unknown block state, ag 0, blocks 354074-354190
unknown block state, ag 0, blocks 357233-357340
unknown block state, ag 0, blocks 357994-358067
unknown block state, ag 0, blocks 358262-358520
unknown block state, ag 0, blocks 358526-358626
unknown block state, ag 0, blocks 358847-358919
unknown block state, ag 0, blocks 359008-359019
unknown block state, ag 0, blocks 361142-361253
unknown block state, ag 0, blocks 361388-361444
free space (0,363495-363495) only seen by one free space btree
unknown block state, ag 0, blocks 363503-363541
unknown block state, ag 0, blocks 364404-364927
unknown block state, ag 0, blocks 365004-365043
unknown block state, ag 0, blocks 365128-365161
unknown block state, ag 0, blocks 365223-365242
unknown block state, ag 0, blocks 365351-365578
unknown block state, ag 0, blocks 365687-365924
unknown block state, ag 0, blocks 365927-366222
unknown block state, ag 0, blocks 366225-366556
free space (0,366682-366760) only seen by one free space btree
unknown block state, ag 0, blocks 366919-367150
unknown block state, ag 0, blocks 367159-367227
unknown block state, ag 0, blocks 377907-377933
unknown block state, ag 0, blocks 382663-382744
unknown block state, ag 0, blocks 382786-382875
unknown block state, ag 0, blocks 384386-384467
unknown block state, ag 0, blocks 390512-390593
unknown block state, ag 0, blocks 391588-391877
unknown block state, ag 0, blocks 391926-392154
unknown block state, ag 0, blocks 395706-395785
unknown block state, ag 0, blocks 399776-399863
free space (0,400713-400737) only seen by one free space btree
unknown block state, ag 0, blocks 403540-403657
unknown block state, ag 1, blocks 29919-29919
unknown block state, ag 1, blocks 96138-96166
unknown block state, ag 1, blocks 96613-96620
free space (1,96621-96635) only seen by one free space btree
unknown block state, ag 1, blocks 111075-111075
unknown block state, ag 1, blocks 111080-111080
unknown block state, ag 1, blocks 113268-113308
unknown block state, ag 1, blocks 114785-114824
unknown block state, ag 1, blocks 127635-127659
unknown block state, ag 1, blocks 138015-138015
free space (1,203840-203851) only seen by one free space btree
unknown block state, ag 1, blocks 206663-206733
unknown block state, ag 1, blocks 216935-216980
unknown block state, ag 1, blocks 217387-217402
free space (1,217403-217418) only seen by one free space btree
unknown block state, ag 1, blocks 217908-217908
free space (1,217909-217918) only seen by one free space btree
unknown block state, ag 1, blocks 217919-217919
unknown block state, ag 1, blocks 217920-217951
free space (1,228747-228759) only seen by one free space btree
unknown block state, ag 1, blocks 229381-229456
unknown block state, ag 1, blocks 230208-230449
unknown block state, ag 1, blocks 230509-230534
unknown block state, ag 1, blocks 231028-231076
free space (1,231077-231087) only seen by one free space btree
unknown block state, ag 1, blocks 231088-231135
unknown block state, ag 1, blocks 232343-232390
unknown block state, ag 1, blocks 232715-232806
unknown block state, ag 1, blocks 234485-234574
unknown block state, ag 1, blocks 234700-234776
unknown block state, ag 1, blocks 234897-235021
unknown block state, ag 1, blocks 235024-235137
unknown block state, ag 1, blocks 235223-235279
unknown block state, ag 1, blocks 237701-238253
unknown block state, ag 1, blocks 238322-238541
unknown block state, ag 1, blocks 239248-239279
unknown block state, ag 1, blocks 240441-240519
unknown block state, ag 1, blocks 241027-241142
unknown block state, ag 1, blocks 247224-247232
unknown block state, ag 1, blocks 247373-247381
        - check for inodes claiming duplicate blocks...
        - agno =3D 1
        - agno =3D 0
entry "d3" in shortform directory 1060672 references non-existent inode 616=
491
would have junked entry "d3" in directory inode 1060672
entry "c6" in shortform directory 1060672 references non-existent inode 592=
844
would have junked entry "c6" in directory inode 1060672
entry "cc" in shortform directory 1060672 references non-existent inode 148=
4440
would have junked entry "cc" in directory inode 1060672
entry "ff" in shortform directory 1060672 references free inode 1324611
would have junked entry "ff" in directory inode 1060672
entry "c14" in shortform directory 1060673 references non-existent inode
1484443
would have junked entry "c14" in directory inode 1060673
entry "f12" in shortform directory 1060673 references non-existent inode
1484418
would have junked entry "f12" in directory inode 1060673
entry "f69" in shortform directory 1108416 references non-existent inode 61=
6510
would have junked entry "f69" in directory inode 1108416
entry "d1d" in shortform directory 1108418 references non-existent inode 61=
6497
would have junked entry "d1d" in directory inode 1108418
entry "f5f" in shortform directory 1108418 references non-existent inode 61=
6493
would have junked entry "f5f" in directory inode 1108418
entry "d54" at block 0 offset 512 in directory inode 1108425 references
non-existent inode 616503
        would clear inode number in entry at offset 512...
entry "d6d" at block 0 offset 640 in directory inode 1108425 references
non-existent inode 616499
        would clear inode number in entry at offset 640...
entry "fa0" at block 0 offset 416 in directory inode 1108443 references
non-existent inode 616500
        would clear inode number in entry at offset 416...
entry "d24" in shortform directory 1108446 references non-existent inode 61=
6505
would have junked entry "d24" in directory inode 1108446
entry "ff1" in shortform directory 1108446 references non-existent inode 61=
6494
would have junked entry "ff1" in directory inode 1108446
entry "cb7" in shortform directory 452260 references non-existent inode 616=
501
would have junked entry "cb7" in directory inode 452260
entry "f72" in shortform directory 452271 references non-existent inode 616=
496
would have junked entry "f72" in directory inode 452271
entry "c6d" in shortform directory 454650 references non-existent inode 616=
482
would have junked entry "c6d" in directory inode 454650
entry "fc3" in shortform directory 504835 references non-existent inode 616=
486
would have junked entry "fc3" in directory inode 504835
entry "fc1" in shortform directory 504851 references non-existent inode 616=
484
would have junked entry "fc1" in directory inode 504851
entry "dd9" in shortform directory 504873 references non-existent inode 616=
481
would have junked entry "dd9" in directory inode 504873
entry "cc6" in shortform directory 510789 references non-existent inode 616=
488
would have junked entry "cc6" in directory inode 510789
entry "c60" in shortform directory 511491 references non-existent inode 616=
507
would have junked entry "c60" in directory inode 511491
entry "cc5" in shortform directory 543205 references non-existent inode 616=
487
would have junked entry "cc5" in directory inode 543205
entry "fcd" in shortform directory 543205 references non-existent inode 616=
489
would have junked entry "fcd" in directory inode 543205
entry "dce" in shortform directory 1331001 references non-existent inode 61=
6490
would have junked entry "dce" in directory inode 1331001
entry "fc2" in shortform directory 566123 references non-existent inode 616=
485
would have junked entry "fc2" in directory inode 566123
entry "c88" in shortform directory 566134 references non-existent inode 616=
480
would have junked entry "c88" in directory inode 566134
entry "fe0" in shortform directory 566134 references non-existent inode 616=
483
entry "fde" in shortform directory 1343817 references non-existent inode 61=
6504
would have junked entry "fde" in directory inode 1343817
would have junked entry "fe0" in directory inode 566134
entry "c51" in shortform directory 1343820 references non-existent inode 61=
6498
would have junked entry "c51" in directory inode 1343820
entry "ced" in shortform directory 1343820 references non-existent inode 61=
6498
would have junked entry "ced" in directory inode 1343820
entry "d12" in shortform directory 577806 references non-existent inode 148=
4417
would have junked entry "d12" in directory inode 577806
entry "ca6" in shortform directory 1343824 references non-existent inode 61=
6502
would have junked entry "ca6" in directory inode 1343824
entry "c16" in shortform directory 577841 references non-existent inode 148=
4437
would have junked entry "c16" in directory inode 577841
entry "c28" in shortform directory 577841 references non-existent inode 592=
838
would have junked entry "c28" in directory inode 577841
entry "d29" in shortform directory 577841 references non-existent inode 148=
4431
would have junked entry "d29" in directory inode 577841
entry "ca6" in shortform directory 1392120 references non-existent inode 61=
6492
would have junked entry "ca6" in directory inode 1392120
entry "d2f" in shortform directory 577841 references non-existent inode 148=
4435
would have junked entry "d2f" in directory inode 577841
entry "f34" in shortform directory 577847 references non-existent inode 592=
854
would have junked entry "f34" in directory inode 577847
entry "d23" in shortform directory 577848 references non-existent inode 616=
509
would have junked entry "d23" in directory inode 577848
entry "c3b" in shortform directory 577848 references non-existent inode 592=
857
would have junked entry "c3b" in directory inode 577848
entry "f21" in shortform directory 577849 references non-existent inode 592=
832
would have junked entry "f21" in directory inode 577849
entry "f23" in shortform directory 577849 references non-existent inode 592=
833
would have junked entry "f23" in directory inode 577849
entry "c2e" in shortform directory 577849 references non-existent inode 592=
856
would have junked entry "c2e" in directory inode 577849
entry "c32" in shortform directory 577849 references non-existent inode 592=
859
would have junked entry "c32" in directory inode 577849
entry "c16" in shortform directory 1408792 references non-existent inode
1484421
would have junked entry "c16" in directory inode 1408792
entry "c18" in shortform directory 1408792 references non-existent inode 59=
2837
would have junked entry "c18" in directory inode 1408792
entry "c1b" in shortform directory 1408792 references non-existent inode 59=
2843
would have junked entry "c1b" in directory inode 1408792
entry "c31" in shortform directory 1408792 references non-existent inode
1484429
would have junked entry "c31" in directory inode 1408792
entry "d22" in shortform directory 577852 references non-existent inode 148=
4427
would have junked entry "d22" in directory inode 577852
entry "d39" in shortform directory 577852 references non-existent inode 148=
4441
would have junked entry "d39" in directory inode 577852
entry "c3c" in shortform directory 577852 references non-existent inode 592=
847
would have junked entry "c3c" in directory inode 577852
entry "f1b" in shortform directory 1472977 references non-existent inode
1484416
would have junked entry "f1b" in directory inode 1472977
entry "f1f" in shortform directory 1472977 references non-existent inode
1484420
would have junked entry "f1f" in directory inode 1472977
entry "ca9" in shortform directory 589403 references non-existent inode 616=
511
would have junked entry "ca9" in directory inode 589403
entry "f20" in shortform directory 1472977 references non-existent inode
1484426
would have junked entry "f20" in directory inode 1472977
entry "f24" in shortform directory 1472977 references non-existent inode
1484428
would have junked entry "f24" in directory inode 1472977
entry "d32" in shortform directory 1472977 references non-existent inode 59=
2853
would have junked entry "d32" in directory inode 1472977
entry "c38" in shortform directory 1472977 references non-existent inode 59=
2858
would have junked entry "c38" in directory inode 1472977
entry "ce4" in shortform directory 1472991 references non-existent inode 61=
6492
would have junked entry "ce4" in directory inode 1472991
entry "c1f" in shortform directory 1472992 references non-existent inode
1484419
would have junked entry "c1f" in directory inode 1472992
entry "d28" in shortform directory 1472992 references non-existent inode 59=
2845
would have junked entry "d28" in directory inode 1472992
entry "f29" in shortform directory 1472992 references non-existent inode
1484432
would have junked entry "f29" in directory inode 1472992
entry "l2c" in shortform directory 1472992 references non-existent inode
1484438
would have junked entry "l2c" in directory inode 1472992
entry "f2d" in shortform directory 1472992 references non-existent inode
1484442
would have junked entry "f2d" in directory inode 1472992
entry "f31" in shortform directory 1472992 references non-existent inode
1484444
would have junked entry "f31" in directory inode 1472992
entry "f33" in shortform directory 1472992 references non-existent inode
1484445
would have junked entry "f33" in directory inode 1472992
entry "c8f" in shortform directory 1472996 references non-existent inode 61=
6508
would have junked entry "c8f" in directory inode 1472996
Missing reverse-mapping record for (0/303267) unwritten len 30 owner 423514=
 off
1634
Missing reverse-mapping record for (0/303297) len 44 owner 379054 off 4150
Missing reverse-mapping record for (0/303341) len 49 owner 379054 off 3415
Missing reverse-mapping record for (0/303390) len 33 owner 1229027 off 1252
Missing reverse-mapping record for (0/303423) len 90 owner 393918 off 6276
Missing reverse-mapping record for (0/303513) unwritten len 34 owner 393918=
 off
6366
Missing reverse-mapping record for (0/303547) unwritten len 141 owner 12290=
06
off 3264
Missing reverse-mapping record for (0/303688) len 621 owner 1096605 off 1567
Missing reverse-mapping record for (0/304333) len 200 owner 1096605 off 2212
Missing reverse-mapping record for (0/304533) len 27 owner 393918 off 6921
Missing reverse-mapping record for (0/304560) unwritten len 28 owner 393918=
 off
6948
Missing reverse-mapping record for (0/304588) len 125 owner 1290366 off 1577
Missing reverse-mapping record for (0/304713) len 16 owner 1096605 off 3326
Missing reverse-mapping record for (0/304729) len 50 owner 543214 off 385
Missing reverse-mapping record for (0/304779) len 63 owner 379018 off 1409
Missing reverse-mapping record for (0/304842) unwritten len 26 owner 454645=
 off
3502
Missing reverse-mapping record for (0/304868) len 15 owner 1163034 off 713
Missing reverse-mapping record for (0/304883) len 6 owner 379011 off 3013
Missing reverse-mapping record for (0/304889) len 1 owner 379011 bmbt off 0
Missing reverse-mapping record for (0/304890) len 66 owner 566106 off 394
Missing reverse-mapping record for (0/304999) len 276 owner 1163034 off 844
Missing reverse-mapping record for (0/363542) unwritten len 189 owner 511501
off 614
Missing reverse-mapping record for (0/363731) len 7 owner 511501 off 803
Missing reverse-mapping record for (0/363738) unwritten len 59 owner 511501=
 off
810
Missing reverse-mapping record for (0/363797) len 439 owner 1408785 off 653
Missing reverse-mapping record for (0/364273) len 122 owner 1408797 off 949
Missing reverse-mapping record for (0/376193) unwritten len 80 owner 1108422
off 1644
Missing reverse-mapping record for (0/376273) len 43 owner 1108432 off 4753
Missing reverse-mapping record for (0/376333) unwritten len 714 owner 11084=
22
off 1784
Missing reverse-mapping record for (0/403920) unwritten len 6 owner 452263 =
off
5050
Missing reverse-mapping record for (0/408317) len 74 owner 1472972 off 2052
Missing reverse-mapping record for (0/408391) unwritten len 50 owner 1472972
off 2126
Missing reverse-mapping record for (0/408460) len 129 owner 1335513 off 2917
Missing reverse-mapping record for (0/408589) unwritten len 369 owner 13355=
13
off 1625
Missing reverse-mapping record for (0/408958) len 116 owner 511513 off 4240
Missing reverse-mapping record for (0/409074) unwritten len 72 owner 577820=
 off
8
Missing reverse-mapping record for (0/409146) len 95 owner 1408788 off 541
Missing reverse-mapping record for (0/414576) len 711 owner 1343834 off 2265
Missing reverse-mapping record for (0/415315) len 41 owner 1343834 off 3004
Missing reverse-mapping record for (0/415356) unwritten len 247 owner 11084=
42
off 2939
Missing reverse-mapping record for (0/415603) unwritten len 175 owner 13246=
32
off 1089
Missing reverse-mapping record for (0/415778) len 80 owner 1324632 off 1264
Missing reverse-mapping record for (0/415858) unwritten len 132 owner 13246=
32
off 1344
Missing reverse-mapping record for (0/415990) unwritten len 630 owner 13438=
22
off 455
Missing reverse-mapping record for (0/416620) unwritten len 308 owner 511501
off 2905
Missing reverse-mapping record for (0/416928) len 167 owner 511501 off 3213
Missing reverse-mapping record for (0/417095) unwritten len 297 owner 511501
off 3380
Missing reverse-mapping record for (0/417392) len 990 owner 1408797 off 1071
Missing reverse-mapping record for (0/418503) len 109 owner 511501 off 4178
Missing reverse-mapping record for (0/418612) len 15 owner 511501 off 4900
Missing reverse-mapping record for (0/418640) len 1 owner 511501 bmbt off 0
Missing reverse-mapping record for (0/418641) unwritten len 139 owner 14087=
96
off 241
Missing reverse-mapping record for (0/418780) unwritten len 77 owner 511501=
 off
3677
Missing reverse-mapping record for (0/418876) unwritten len 84 owner 1408796
off 476
Missing reverse-mapping record for (0/419004) unwritten len 81 owner 1408796
off 604
Missing reverse-mapping record for (0/419085) unwritten len 211 owner 577854
off 736
Missing reverse-mapping record for (0/419296) len 45 owner 1408799 off 1499
Missing reverse-mapping record for (0/421371) len 60 owner 589415 off 4255
Missing reverse-mapping record for (0/421717) len 116 owner 511519 off 7685
Missing reverse-mapping record for (0/421833) unwritten len 7 owner 511519 =
off
7801
Missing reverse-mapping record for (0/421840) unwritten len 189 owner 589415
off 3554
Missing reverse-mapping record for (0/422637) unwritten len 600 owner 14087=
94
off 1383
Missing reverse-mapping record for (0/423237) len 35 owner 1408794 off 1983
Missing reverse-mapping record for (0/423272) unwritten len 46 owner 1408794
off 2018
Missing reverse-mapping record for (0/423318) unwritten len 252 owner 14087=
88
off 3776
Missing reverse-mapping record for (0/424520) unwritten len 433 owner 577854
off 233
Missing reverse-mapping record for (0/424953) unwritten len 245 owner 577854
off 3110
Missing reverse-mapping record for (0/425198) unwritten len 165 owner 577855
off 827
Missing reverse-mapping record for (0/425363) unwritten len 368 owner 577855
off 1102
Missing reverse-mapping record for (0/425731) unwritten len 233 owner 577855
off 594
Missing reverse-mapping record for (0/425964) len 42 owner 1408794 off 2731
Missing reverse-mapping record for (0/426006) unwritten len 43 owner 1408794
off 2773
Missing reverse-mapping record for (0/426599) len 76 owner 577854 off 4097
Missing reverse-mapping record for (0/427090) len 212 owner 577854 off 4588
Missing reverse-mapping record for (0/427355) len 60 owner 577855 off 2360
Missing reverse-mapping record for (0/427642) len 45 owner 577854 off 5140
Missing reverse-mapping record for (0/427687) unwritten len 63 owner 577854=
 off
5185
Missing reverse-mapping record for (0/427837) len 224 owner 577853 off 174
Missing reverse-mapping record for (0/428177) len 86 owner 1408796 off 930
Missing reverse-mapping record for (0/428433) len 118 owner 1408796 off 3557

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
