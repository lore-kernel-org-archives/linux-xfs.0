Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp-out16.tpgi.com.au ([220.244.226.126]:43286 "EHLO
        mail16.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727237AbeHIKDi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Aug 2018 06:03:38 -0400
Received: from [192.168.1.102] (203-219-171-14.tpgi.com.au [203.219.171.14])
        (authenticated bits=0)
        by mail16.tpgi.com.au (envelope-from jncw@tpg.com.au) (8.14.3/8.14.3) with ESMTP id w797OMld026677
        for <linux-xfs@vger.kernel.org>; Thu, 9 Aug 2018 17:24:24 +1000
From: Jason <jncw@tpg.com.au>
Subject: fatal error -- couldn't map inode 4324730417, err = 117 (Big Noob at
 this please help)
Message-ID: <5290c36d-ade4-c74d-c763-9c2fb0dcb126@tpg.com.au>
Date: Thu, 9 Aug 2018 17:24:21 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Gday all

   Having a problem with an XFS formatted drive and hope someone can 
help. On unraid, got a format error, ran xfs_repair with the -L prefix 
(4.15 i think that whats built in),got the fatal error above and the 
unraid people sent me over here. If somebody could help that would be 
great thanks . here is the output


Phase 1 - find and verify superblock...
         - block cache size set to 738560 entries
Phase 2 - using internal log
         - zero log...
zero_log: head block 2 tail block 2
         - scan filesystem freespace and inode maps...
sb_ifree 189, counted 179
         - found root inode chunk
Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
data fork in regular inode 3096406 claims used block 387077
correcting nextents for inode 3096406
bad data fork in inode 3096406
cleared inode 3096406
data fork in ino 4161576 claims free block 520104
         - agno = 1
data fork in regular inode 2147645085 claims used block 268455457
correcting nextents for inode 2147645085
bad data fork in inode 2147645085
cleared inode 2147645085
data fork in regular inode 2147645087 claims used block 268455452
correcting nextents for inode 2147645087
bad data fork in inode 2147645087
cleared inode 2147645087
data fork in regular inode 2147645434 claims used block 268456588
correcting nextents for inode 2147645434
bad data fork in inode 2147645434
cleared inode 2147645434
data fork in regular inode 2147652829 claims used block 268456589
correcting nextents for inode 2147652829
bad data fork in inode 2147652829
cleared inode 2147652829
data fork in regular inode 2155916791 claims used block 268855162
correcting nextents for inode 2155916791
bad data fork in inode 2155916791
cleared inode 2155916791
         - agno = 2
imap claims a free inode 4305027976 is in use, correcting imap and clearing inode
cleared inode 4305027976
imap claims a free inode 4324730418 is in use, correcting imap and clearing inode
cleared inode 4324730418
         - agno = 3
imap claims a free inode 6442454053 is in use, correcting imap and clearing inode
cleared inode 6442454053
imap claims a free inode 6442454055 is in use, correcting imap and clearing inode
cleared inode 6442454055
imap claims a free inode 6442454057 is in use, correcting imap and clearing inode
cleared inode 6442454057
imap claims a free inode 6442454059 is in use, correcting imap and clearing inode
cleared inode 6442454059
imap claims a free inode 6442454061 is in use, correcting imap and clearing inode
cleared inode 6442454061
imap claims a free inode 6442454063 is in use, correcting imap and clearing inode
cleared inode 6442454063
imap claims a free inode 6442454065 is in use, correcting imap and clearing inode
cleared inode 6442454065
imap claims a free inode 6442454068 is in use, correcting imap and clearing inode
cleared inode 6442454068
imap claims a free inode 6442454070 is in use, correcting imap and clearing inode
cleared inode 6442454070
imap claims a free inode 6442454072 is in use, correcting imap and clearing inode
cleared inode 6442454072
data fork in regular inode 6444136432 claims used block 805517049
correcting nextents for inode 6444136432
bad data fork in inode 6444136432
cleared inode 6444136432
data fork in regular inode 6452936978 claims used block 806617117
correcting nextents for inode 6452936978
bad data fork in inode 6452936978
cleared inode 6452936978
         - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - check for inodes claiming duplicate blocks...
         - agno = 0
         - agno = 3
         - agno = 1
         - agno = 2
entry "Lethal Weapon 02x04 Flight Risk.nfo" at block 0 offset 1096 in directory inode 119 references free inode 3096406
	clearing inode number in entry at offset 1096...
entry "The Flash (2014) 03x11 Dead or Alive.nfo" at block 0 offset 96 in directory inode 2147484037 references free inode 2147645085
	clearing inode number in entry at offset 96...
entry "The Flash (2014) 03x15 The Wrath of Savitar.nfo" at block 0 offset 216 in directory inode 2147484037 references free inode 2147645087
	clearing inode number in entry at offset 216...
entry "The Flash (2014) 03x16 Into the Speed Force.nfo" at block 0 offset 480 in directory inode 2147484037 references free inode 2147645434
	clearing inode number in entry at offset 480...
entry "The Flash (2014) 03x19 The Once and Future Flash.nfo" at block 0 offset 1064 in directory inode 2147484037 references free inode 2155916791
	clearing inode number in entry at offset 1064...
data fork in ino 3096400 claims dup extent, off - 0, start - 387077, cnt 1
correcting nextents for inode 3096400
bad data fork in inode 3096400
cleared inode 3096400
entry "The Graham Norton Show 14x16 Episode 16.nfo" at block 0 offset 1208 in directory inode 2147498733 references free inode 2147652829
	clearing inode number in entry at offset 1208...
data fork in ino 2147634033 claims dup extent, off - 0, start - 268455452, cnt 1
correcting nextents for inode 2147634033
bad data fork in inode 2147634033
cleared inode 2147634033
data fork in ino 2147634035 claims dup extent, off - 0, start - 268455457, cnt 1
correcting nextents for inode 2147634035
bad data fork in inode 2147634035
cleared inode 2147634035
data fork in ino 2147638969 claims dup extent, off - 0, start - 268456588, cnt 1
correcting nextents for inode 2147638969
bad data fork in inode 2147638969
cleared inode 2147638969
data fork in ino 2147645440 claims dup extent, off - 0, start - 268456589, cnt 1
correcting nextents for inode 2147645440
bad data fork in inode 2147645440
cleared inode 2147645440
data fork in ino 6444136424 claims dup extent, off - 0, start - 805517049, cnt 1
correcting nextents for inode 6444136424
bad data fork in inode 6444136424
cleared inode 6444136424
entry "Lip Sync Battle 03x02 America Ferrera vs. Amber Tamblyn.nfo" at block 0 offset 368 in directory inode 6444136427 references free inode 6444136432
	clearing inode number in entry at offset 368...
data fork in ino 6452936960 claims dup extent, off - 0, start - 806617117, cnt 1
correcting nextents for inode 6452936960
bad data fork in inode 6452936960
cleared inode 6452936960
entry "Humans 03x02 Episode 2.nfo" at block 0 offset 136 in directory inode 6452936976 references free inode 6452936978
	clearing inode number in entry at offset 136...
entry "The Americans (2013) 05x04 What's the Matter with Kansas.nfo" at block 0 offset 672 in directory inode 4305076930 references free inode 4305027976
	clearing inode number in entry at offset 672...
entry "Who Framed Roger Rabbit 1988 Bluray-1080p.mkv" in shortform directory 4324730417 references free inode 4324730418
junking entry "Who Framed Roger Rabbit 1988 Bluray-1080p.mkv" in directory inode 4324730417
corrected i8 count in directory 4324730417, was 1, now 0
corrected directory 4324730417 size, was 10, now 6
bogus .. inode number (0) in directory inode 4324730417, clearing inode number
data fork in ino 2155903079 claims dup extent, off - 0, start - 268855162, cnt 1
correcting nextents for inode 2155903079
bad data fork in inode 2155903079
cleared inode 2155903079
Phase 5 - rebuild AG headers and trees...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
         - reset superblock...
Phase 6 - check inode connectivity...
         - resetting contents of realtime bitmap and summary inodes
         - traversing filesystem ...
         - agno = 0
entry "The Flash (2014) 04x07 Therefore I Am.nfo" in directory inode 102 points to free inode 3096400, marking entry to be junked
bad hash table for directory inode 102 (no data entry): rebuilding
rebuilding directory inode 102
bad hash table for directory inode 119 (no data entry): rebuilding
rebuilding directory inode 119
entry "Who Framed Roger Rabbit (1988)" in dir ino 3202844 doesn't have a .. entry, will set it in ino 4324730417.
fixing ftype mismatch (1/2) in directory/child inode 4183793/3129202
entry "The Americans (2013) 03x06 Born Again-thumb.jpg" in dir 4183793 points to an already connected directory inode 3129202
	will clear entry "The Americans (2013) 03x06 Born Again-thumb.jpg"
entry "The Americans (2013) 03x06 Born Again.mkv" (ino 3129178) in dir 4183793 is a duplicate name, marking entry to be junked
entry "The Americans (2013) 03x06 Born Again.nfo" (ino 3129179) in dir 4183793 is a duplicate name, marking entry to be junked
rebuilding directory inode 4183793
         - agno = 1
entry "The Flash (2014) 03x17 Duet (2).nfo" in directory inode 2147484037 points to free inode 2147645440, marking entry to be junked
bad hash table for directory inode 2147484037 (no data entry): rebuilding
rebuilding directory inode 2147484037
bad hash table for directory inode 2147498733 (no data entry): rebuilding
rebuilding directory inode 2147498733
entry "Fortitude 02x06 Episode 6.nfo" in directory inode 2147634016 points to free inode 2147634033, marking entry to be junked
entry "Fortitude 02x07 Episode 7.nfo" in directory inode 2147634016 points to free inode 2147634035, marking entry to be junked
entry "Fortitude 02x10 Episode 10.nfo" in directory inode 2147634016 points to free inode 2147638969, marking entry to be junked
bad hash table for directory inode 2147634016 (no data entry): rebuilding
rebuilding directory inode 2147634016
entry "dreamworks.dragons.s06e12.720p.web.x264-strife.nfo" in directory inode 2155903078 points to free inode 2155903079, marking entry to be junked
bad hash table for directory inode 2155903078 (no data entry): rebuilding
rebuilding directory inode 2155903078
         - agno = 2
bad hash table for directory inode 4305076930 (no data entry): rebuilding
rebuilding directory inode 4305076930
Invalid inode number 0x0
xfs_dir_ino_validate: XFS_ERROR_REPORT

fatal error -- couldn't map inode 4324730417, err = 117﻿

