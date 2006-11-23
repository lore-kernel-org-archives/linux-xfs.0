Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Nov 2006 08:41:40 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [66.45.37.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kANGfQaG011769
	for <xfs@oss.sgi.com>; Thu, 23 Nov 2006 08:41:28 -0800
Date: Thu, 23 Nov 2006 11:40:38 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS CORRUPTION 2.6.17.13?
In-Reply-To: <1164231716.19915.68.camel@xenon.msp.redhat.com>
Message-ID: <Pine.LNX.4.64.0611231139040.32343@p34.internal.lan>
References: <Pine.LNX.4.64.0611201459420.17165@p34.internal.lan>
 <1164231716.19915.68.camel@xenon.msp.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com

Here is the info:

Script started on Thu Nov 23 09:55:38 2006
1;36mroot@1[~]#0;39m xfs_repair -n /dev/hda2
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
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
data fork in regular inode 939526080 claims used block 114661
bad data fork in inode 939526080
would have cleared inode 939526080
data fork in regular inode 939526081 claims used block 114662
bad data fork in inode 939526081
would have cleared inode 939526081
data fork in regular inode 939526082 claims used block 114663
bad data fork in inode 939526082
would have cleared inode 939526082
data fork in regular inode 939526083 claims used block 114664
bad data fork in inode 939526083
would have cleared inode 939526083
data fork in regular inode 939526084 claims used block 114665
bad data fork in inode 939526084
would have cleared inode 939526084
data fork in regular inode 939526085 claims used block 114666
bad data fork in inode 939526085
would have cleared inode 939526085
data fork in regular inode 939526086 claims used block 114667
bad data fork in inode 939526086
would have cleared inode 939526086
data fork in regular inode 939526087 claims used block 114668
bad data fork in inode 939526087
would have cleared inode 939526087
data fork in regular inode 939526088 claims used block 114669
bad data fork in inode 939526088
would have cleared inode 939526088
data fork in regular inode 939526089 claims used block 114670
bad data fork in inode 939526089
would have cleared inode 939526089
data fork in regular inode 939526090 claims used block 114671
bad data fork in inode 939526090
would have cleared inode 939526090
data fork in regular inode 939526091 claims used block 114672
bad data fork in inode 939526091
would have cleared inode 939526091
data fork in regular inode 939526092 claims used block 114673
bad data fork in inode 939526092
would have cleared inode 939526092
data fork in regular inode 939526093 claims used block 114674
bad data fork in inode 939526093
would have cleared inode 939526093
data fork in regular inode 939526094 claims used block 114675
bad data fork in inode 939526094
would have cleared inode 939526094
data fork in regular inode 939526095 claims used block 114676
bad data fork in inode 939526095
would have cleared inode 939526095
data fork in regular inode 939526096 claims used block 114677
bad data fork in inode 939526096
would have cleared inode 939526096
data fork in regular inode 939526097 claims used block 114678
bad data fork in inode 939526097
would have cleared inode 939526097
data fork in regular inode 939526098 claims used block 114679
bad data fork in inode 939526098
would have cleared inode 939526098
data fork in regular inode 939526099 claims used block 114680
bad data fork in inode 939526099
would have cleared inode 939526099
data fork in regular inode 939526100 claims used block 114681
bad data fork in inode 939526100
would have cleared inode 939526100
data fork in regular inode 939526101 claims used block 114682
bad data fork in inode 939526101
would have cleared inode 939526101
data fork in regular inode 939526102 claims used block 114683
bad data fork in inode 939526102
would have cleared inode 939526102
data fork in regular inode 939526103 claims used block 114684
bad data fork in inode 939526103
would have cleared inode 939526103
data fork in regular inode 939526104 claims used block 114685
bad data fork in inode 939526104
would have cleared inode 939526104
data fork in regular inode 939526105 claims used block 114686
bad data fork in inode 939526105
would have cleared inode 939526105
data fork in regular inode 939526106 claims used block 114687
bad data fork in inode 939526106
would have cleared inode 939526106
data fork in regular inode 939526107 claims used block 114688
bad data fork in inode 939526107
would have cleared inode 939526107
data fork in regular inode 939526108 claims used block 114689
bad data fork in inode 939526108
would have cleared inode 939526108
data fork in regular inode 939526109 claims used block 114690
bad data fork in inode 939526109
would have cleared inode 939526109
data fork in regular inode 939526110 claims used block 114691
bad data fork in inode 939526110
would have cleared inode 939526110
data fork in regular inode 939526111 claims used block 114692
bad data fork in inode 939526111
would have cleared inode 939526111
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
data fork in ino 1814911 claims dup extent, off - 0, start - 114111, cnt 4161
bad data fork in inode 1814911
would have cleared inode 1814911
        - agno = 1
entry "parts" at block 0 offset 96 in directory inode 134219629 references free inode 939526093
        would clear inode number in entry at offset 96...
entry "violations.ignore.d" in shortform directory 134219645 references free inode 939526109
would have junked entry "violations.ignore.d" in directory inode 134219645
        - agno = 2
        - agno = 3
entry "dirmngr" at block 0 offset 456 in directory inode 402655041 references free inode 939526087
        would clear inode number in entry at offset 456...
entry "alsa" at block 0 offset 520 in directory inode 402655041 references free inode 939526088
        would clear inode number in entry at offset 520...
entry "ipv6-down.d" at block 0 offset 112 in directory inode 402655063 references free inode 939526103
        would clear inode number in entry at offset 112...
        - agno = 4
entry "cookie" in shortform directory 536872873 references free inode 939526089
would have junked entry "cookie" in directory inode 536872873
entry "4.2" in shortform directory 536872894 references free inode 939526110
would have junked entry "4.2" in directory inode 536872894
        - agno = 5
entry "menus" in shortform directory 671090530 references free inode 939526082
would have junked entry "menus" in directory inode 671090530
entry "defaults" in shortform directory 671090531 references free inode 939526083
would have junked entry "defaults" in directory inode 671090531
        - agno = 6
entry "cat2" at block 0 offset 232 in directory inode 805308319 references free inode 939526080
        would clear inode number in entry at offset 232...
entry "python2.4" in shortform directory 805308321 references free inode 939526081
would have junked entry "python2.4" in directory inode 805308321
entry "components" in shortform directory 805308326 references free inode 939526086
would have junked entry "components" in directory inode 805308326
entry "cache" at block 0 offset 48 in directory inode 805308330 references free inode 939526090
        would clear inode number in entry at offset 48...
entry "aspell" in shortform directory 805308332 references free inode 939526092
would have junked entry "aspell" in directory inode 805308332
entry "update-libc.d" in shortform directory 805308335 references free inode 939526095
would have junked entry "update-libc.d" in directory inode 805308335
entry "private" in shortform directory 805308336 references free inode 939526096
would have junked entry "private" in directory inode 805308336
entry "en_US" in shortform directory 805308339 references free inode 939526099
would have junked entry "en_US" in directory inode 805308339
entry "1" in shortform directory 805308340 references free inode 939526100
would have junked entry "1" in directory inode 805308340
entry "kde-applications-merged" at block 0 offset 48 in directory inode 805308341 references free inode 939526101
        would clear inode number in entry at offset 48...
entry "events" in shortform directory 805308351 references free inode 939526111
would have junked entry "events" in directory inode 805308351
        - agno = 7
imap claims in-use inode 939526080 is free, would correct imap
imap claims in-use inode 939526081 is free, would correct imap
imap claims in-use inode 939526082 is free, would correct imap
imap claims in-use inode 939526083 is free, would correct imap
imap claims in-use inode 939526084 is free, would correct imap
imap claims in-use inode 939526085 is free, would correct imap
imap claims in-use inode 939526086 is free, would correct imap
imap claims in-use inode 939526087 is free, would correct imap
imap claims in-use inode 939526088 is free, would correct imap
imap claims in-use inode 939526089 is free, would correct imap
imap claims in-use inode 939526090 is free, would correct imap
imap claims in-use inode 939526091 is free, would correct imap
imap claims in-use inode 939526092 is free, would correct imap
imap claims in-use inode 939526093 is free, would correct imap
imap claims in-use inode 939526094 is free, would correct imap
imap claims in-use inode 939526095 is free, would correct imap
imap claims in-use inode 939526096 is free, would correct imap
imap claims in-use inode 939526097 is free, would correct imap
imap claims in-use inode 939526098 is free, would correct imap
imap claims in-use inode 939526099 is free, would correct imap
imap claims in-use inode 939526100 is free, would correct imap
imap claims in-use inode 939526101 is free, would correct imap
imap claims in-use inode 939526102 is free, would correct imap
imap claims in-use inode 939526103 is free, would correct imap
imap claims in-use inode 939526104 is free, would correct imap
imap claims in-use inode 939526105 is free, would correct imap
imap claims in-use inode 939526106 is free, would correct imap
imap claims in-use inode 939526107 is free, would correct imap
imap claims in-use inode 939526108 is free, would correct imap
imap claims in-use inode 939526109 is free, would correct imap
imap claims in-use inode 939526110 is free, would correct imap
imap claims in-use inode 939526111 is free, would correct imap
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem starting at / ...
entry "6C1095804A88D" in shortform directory inode 18848 points to free inode 1814911
would junk entry "6C1095804A88D"
        - traversal finished ...
        - traversing all unattached subtrees ...
        - traversals finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 939525281, would move to lost+found
disconnected inode 939525296, would move to lost+found
disconnected inode 939525297, would move to lost+found
disconnected inode 939525298, would move to lost+found
disconnected inode 939525299, would move to lost+found
disconnected inode 939525300, would move to lost+found
disconnected inode 939525301, would move to lost+found
disconnected inode 939525302, would move to lost+found
disconnected inode 939525425, would move to lost+found
disconnected inode 939525426, would move to lost+found
disconnected inode 939526091, would move to lost+found
disconnected inode 939526164, would move to lost+found
disconnected inode 939526200, would move to lost+found
disconnected inode 939526263, would move to lost+found
disconnected inode 939526266, would move to lost+found
disconnected inode 939526268, would move to lost+found
disconnected inode 939526270, would move to lost+found
disconnected inode 939526271, would move to lost+found
disconnected inode 939526280, would move to lost+found
disconnected inode 939526281, would move to lost+found
disconnected inode 939526282, would move to lost+found
disconnected inode 939526283, would move to lost+found
disconnected inode 939526284, would move to lost+found
disconnected inode 939526286, would move to lost+found
disconnected inode 939526287, would move to lost+found
disconnected inode 939526288, would move to lost+found
disconnected inode 939526300, would move to lost+found
disconnected inode 939526301, would move to lost+found
disconnected inode 939526302, would move to lost+found
disconnected inode 939526303, would move to lost+found
disconnected inode 939526304, would move to lost+found
disconnected inode 939526305, would move to lost+found
disconnected inode 939526307, would move to lost+found
disconnected inode 939526308, would move to lost+found
disconnected inode 939526309, would move to lost+found
disconnected inode 939526314, would move to lost+found
disconnected inode 939526315, would move to lost+found
disconnected inode 939526316, would move to lost+found
disconnected inode 939526317, would move to lost+found
disconnected inode 939526318, would move to lost+found
disconnected inode 939526328, would move to lost+found
disconnected inode 939526329, would move to lost+found
disconnected inode 939526330, would move to lost+found
disconnected inode 939526331, would move to lost+found
disconnected inode 939526332, would move to lost+found
disconnected inode 939526333, would move to lost+found
disconnected inode 939526334, would move to lost+found
disconnected inode 939526335, would move to lost+found
disconnected inode 939526934, would move to lost+found
disconnected inode 939526937, would move to lost+found
disconnected inode 939626830, would move to lost+found
disconnected inode 939626837, would move to lost+found
disconnected inode 939629683, would move to lost+found
disconnected inode 939629684, would move to lost+found
disconnected inode 939629685, would move to lost+found
disconnected inode 939629686, would move to lost+found
disconnected inode 939629687, would move to lost+found
disconnected inode 939629690, would move to lost+found
disconnected inode 939629691, would move to lost+found
disconnected inode 939633842, would move to lost+found
disconnected inode 939633843, would move to lost+found
disconnected inode 939633881, would move to lost+found
disconnected inode 939633897, would move to lost+found
disconnected inode 939633898, would move to lost+found
disconnected inode 939633899, would move to lost+found
disconnected inode 939633900, would move to lost+found
disconnected inode 939633901, would move to lost+found
disconnected inode 939633902, would move to lost+found
disconnected inode 939633903, would move to lost+found
disconnected inode 939633909, would move to lost+found
disconnected inode 939633910, would move to lost+found
disconnected inode 939634022, would move to lost+found
disconnected inode 939634023, would move to lost+found
disconnected inode 939634024, would move to lost+found
disconnected inode 939634025, would move to lost+found
disconnected inode 939707628, would move to lost+found
disconnected inode 939707629, would move to lost+found
disconnected inode 939707630, would move to lost+found
disconnected inode 939707633, would move to lost+found
disconnected inode 939707636, would move to lost+found
disconnected inode 939707639, would move to lost+found
disconnected inode 939707641, would move to lost+found
disconnected inode 939707643, would move to lost+found
disconnected inode 939707645, would move to lost+found
disconnected inode 939707712, would move to lost+found
disconnected inode 939734343, would move to lost+found
disconnected inode 939783610, would move to lost+found
disconnected inode 939783612, would move to lost+found
disconnected inode 939783613, would move to lost+found
disconnected inode 939783614, would move to lost+found
disconnected inode 939783616, would move to lost+found
disconnected inode 939783623, would move to lost+found
disconnected inode 939783635, would move to lost+found
disconnected inode 939783663, would move to lost+found
disconnected inode 939783672, would move to lost+found
disconnected inode 939804193, would move to lost+found
disconnected inode 939804194, would move to lost+found
disconnected inode 939804195, would move to lost+found
disconnected inode 939804196, would move to lost+found
disconnected inode 939804197, would move to lost+found
disconnected inode 939804198, would move to lost+found
disconnected inode 939804199, would move to lost+found
disconnected inode 939804200, would move to lost+found
disconnected inode 939804201, would move to lost+found
disconnected inode 939804203, would move to lost+found
disconnected inode 939804205, would move to lost+found
disconnected inode 939804206, would move to lost+found
disconnected inode 939804242, would move to lost+found
disconnected inode 939808074, would move to lost+found
disconnected inode 939808075, would move to lost+found
disconnected inode 939808076, would move to lost+found
disconnected inode 939808077, would move to lost+found
disconnected inode 939819891, would move to lost+found
disconnected inode 939820963, would move to lost+found
disconnected inode 939820964, would move to lost+found
disconnected inode 939820965, would move to lost+found
disconnected inode 939820966, would move to lost+found
disconnected inode 939820968, would move to lost+found
disconnected inode 939820969, would move to lost+found
disconnected inode 939820970, would move to lost+found
disconnected inode 939820971, would move to lost+found
disconnected inode 939820972, would move to lost+found
disconnected inode 939820973, would move to lost+found
disconnected inode 939820974, would move to lost+found
disconnected inode 939841107, would move to lost+found
disconnected inode 939843487, would move to lost+found
disconnected inode 939872184, would move to lost+found
disconnected inode 939872208, would move to lost+found
disconnected inode 940744021, would move to lost+found
disconnected inode 940744022, would move to lost+found
disconnected inode 940923246, would move to lost+found
disconnected inode 940923247, would move to lost+found
disconnected inode 940936619, would move to lost+found
disconnected inode 941261016, would move to lost+found
disconnected inode 941261017, would move to lost+found
disconnected inode 941261018, would move to lost+found
disconnected inode 941266732, would move to lost+found
disconnected inode 941266764, would move to lost+found
disconnected inode 941266765, would move to lost+found
disconnected inode 941274207, would move to lost+found
disconnected inode 941446125, would move to lost+found
disconnected inode 941458243, would move to lost+found
disconnected inode 941460430, would move to lost+found
disconnected inode 941460434, would move to lost+found
disconnected inode 941460443, would move to lost+found
disconnected inode 941460445, would move to lost+found
disconnected inode 941460452, would move to lost+found
disconnected inode 941460454, would move to lost+found
disconnected inode 941460455, would move to lost+found
disconnected inode 941460457, would move to lost+found
disconnected inode 941510370, would move to lost+found
disconnected inode 941510371, would move to lost+found
disconnected inode 941514067, would move to lost+found
disconnected inode 941514074, would move to lost+found
disconnected inode 941514114, would move to lost+found
disconnected inode 941514115, would move to lost+found
disconnected inode 941907501, would move to lost+found
disconnected inode 941907502, would move to lost+found
disconnected inode 941933094, would move to lost+found
disconnected inode 941933223, would move to lost+found
disconnected inode 941933225, would move to lost+found
disconnected inode 941933226, would move to lost+found
disconnected inode 941942463, would move to lost+found
disconnected inode 942080921, would move to lost+found
disconnected inode 942090075, would move to lost+found
disconnected inode 942090451, would move to lost+found
disconnected inode 942092049, would move to lost+found
disconnected inode 942092304, would move to lost+found
disconnected inode 942092305, would move to lost+found
disconnected inode 942092306, would move to lost+found
disconnected inode 942260373, would move to lost+found
disconnected dir inode 1074268001, would move to lost+found
disconnected dir inode 1074268007, would move to lost+found
disconnected dir inode 1074268009, would move to lost+found
disconnected dir inode 1074268014, would move to lost+found
disconnected dir inode 1074268017, would move to lost+found
disconnected dir inode 1074268019, would move to lost+found
disconnected dir inode 1074268022, would move to lost+found
disconnected dir inode 1074268024, would move to lost+found
disconnected dir inode 1207961425, would move to lost+found
disconnected dir inode 1342179089, would move to lost+found
Phase 7 - verify link counts...
would have reset inode 134219629 nlinks from 7 to 6
would have reset inode 134219645 nlinks from 8 to 7
would have reset inode 402655041 nlinks from 50 to 48
would have reset inode 402655063 nlinks from 8 to 7
would have reset inode 536872873 nlinks from 7 to 6
would have reset inode 536872894 nlinks from 8 to 7
would have reset inode 671090530 nlinks from 6 to 5
would have reset inode 671090531 nlinks from 4 to 3
would have reset inode 805308319 nlinks from 16 to 15
would have reset inode 805308321 nlinks from 4 to 3
would have reset inode 805308326 nlinks from 5 to 4
would have reset inode 805308330 nlinks from 3 to 2
would have reset inode 805308332 nlinks from 5 to 4
would have reset inode 805308335 nlinks from 3 to 2
would have reset inode 805308336 nlinks from 4 to 3
would have reset inode 805308339 nlinks from 4 to 3
would have reset inode 805308340 nlinks from 7 to 6
would have reset inode 805308341 nlinks from 4 to 3
would have reset inode 805308351 nlinks from 3 to 2
would have reset inode 1342179075 nlinks from 43 to 41
would have reset inode 1610614679 nlinks from 21 to 20
would have reset inode 1744832408 nlinks from 8 to 7
would have reset inode 1744832409 nlinks from 10 to 9
would have reset inode 1879050093 nlinks from 132 to 127
would have reset inode 2013268025 nlinks from 12 to 11
No modify flag set, skipping filesystem flush and exiting.
1;36mroot@1[~]#0;39m Kxfs_repair 1@1@-1@v2da2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
zero_log: head block 23951 tail block 23951
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
data fork in regular inode 939526080 claims used block 114661
bad data fork in inode 939526080
cleared inode 939526080
data fork in regular inode 939526081 claims used block 114662
bad data fork in inode 939526081
cleared inode 939526081
data fork in regular inode 939526082 claims used block 114663
bad data fork in inode 939526082
cleared inode 939526082
data fork in regular inode 939526083 claims used block 114664
bad data fork in inode 939526083
cleared inode 939526083
data fork in regular inode 939526084 claims used block 114665
bad data fork in inode 939526084
cleared inode 939526084
data fork in regular inode 939526085 claims used block 114666
bad data fork in inode 939526085
cleared inode 939526085
data fork in regular inode 939526086 claims used block 114667
bad data fork in inode 939526086
cleared inode 939526086
data fork in regular inode 939526087 claims used block 114668
bad data fork in inode 939526087
cleared inode 939526087
data fork in regular inode 939526088 claims used block 114669
bad data fork in inode 939526088
cleared inode 939526088
data fork in regular inode 939526089 claims used block 114670
bad data fork in inode 939526089
cleared inode 939526089
data fork in regular inode 939526090 claims used block 114671
bad data fork in inode 939526090
cleared inode 939526090
data fork in regular inode 939526091 claims used block 114672
bad data fork in inode 939526091
cleared inode 939526091
data fork in regular inode 939526092 claims used block 114673
bad data fork in inode 939526092
cleared inode 939526092
data fork in regular inode 939526093 claims used block 114674
bad data fork in inode 939526093
cleared inode 939526093
data fork in regular inode 939526094 claims used block 114675
bad data fork in inode 939526094
cleared inode 939526094
data fork in regular inode 939526095 claims used block 114676
bad data fork in inode 939526095
cleared inode 939526095
data fork in regular inode 939526096 claims used block 114677
bad data fork in inode 939526096
cleared inode 939526096
data fork in regular inode 939526097 claims used block 114678
bad data fork in inode 939526097
cleared inode 939526097
data fork in regular inode 939526098 claims used block 114679
bad data fork in inode 939526098
cleared inode 939526098
data fork in regular inode 939526099 claims used block 114680
bad data fork in inode 939526099
cleared inode 939526099
data fork in regular inode 939526100 claims used block 114681
bad data fork in inode 939526100
cleared inode 939526100
data fork in regular inode 939526101 claims used block 114682
bad data fork in inode 939526101
cleared inode 939526101
data fork in regular inode 939526102 claims used block 114683
bad data fork in inode 939526102
cleared inode 939526102
data fork in regular inode 939526103 claims used block 114684
bad data fork in inode 939526103
cleared inode 939526103
data fork in regular inode 939526104 claims used block 114685
bad data fork in inode 939526104
cleared inode 939526104
data fork in regular inode 939526105 claims used block 114686
bad data fork in inode 939526105
cleared inode 939526105
data fork in regular inode 939526106 claims used block 114687
bad data fork in inode 939526106
cleared inode 939526106
data fork in regular inode 939526107 claims used block 114688
bad data fork in inode 939526107
cleared inode 939526107
data fork in regular inode 939526108 claims used block 114689
bad data fork in inode 939526108
cleared inode 939526108
data fork in regular inode 939526109 claims used block 114690
bad data fork in inode 939526109
cleared inode 939526109
data fork in regular inode 939526110 claims used block 114691
bad data fork in inode 939526110
cleared inode 939526110
data fork in regular inode 939526111 claims used block 114692
bad data fork in inode 939526111
cleared inode 939526111
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - clear lost+found (if it exists) ...
        - clearing existing "lost+found" inode
        - marking entry "lost+found" to be deleted
        - check for inodes claiming duplicate blocks...
        - agno = 0
data fork in ino 1814911 claims dup extent, off - 0, start - 114111, cnt 4161
bad data fork in inode 1814911
cleared inode 1814911
        - agno = 1
entry "parts" at block 0 offset 96 in directory inode 134219629 references free inode 939526093
        clearing inode number in entry at offset 96...
entry "violations.ignore.d" in shortform directory 134219645 references free inode 939526109
junking entry "violations.ignore.d" in directory inode 134219645
        - agno = 2
        - agno = 3
entry "dirmngr" at block 0 offset 456 in directory inode 402655041 references free inode 939526087
        clearing inode number in entry at offset 456...
entry "alsa" at block 0 offset 520 in directory inode 402655041 references free inode 939526088
        clearing inode number in entry at offset 520...
entry "ipv6-down.d" at block 0 offset 112 in directory inode 402655063 references free inode 939526103
        clearing inode number in entry at offset 112...
        - agno = 4
entry "cookie" in shortform directory 536872873 references free inode 939526089
junking entry "cookie" in directory inode 536872873
entry "4.2" in shortform directory 536872894 references free inode 939526110
junking entry "4.2" in directory inode 536872894
        - agno = 5
entry "menus" in shortform directory 671090530 references free inode 939526082
junking entry "menus" in directory inode 671090530
entry "defaults" in shortform directory 671090531 references free inode 939526083
junking entry "defaults" in directory inode 671090531
        - agno = 6
entry "cat2" at block 0 offset 232 in directory inode 805308319 references free inode 939526080
        clearing inode number in entry at offset 232...
entry "python2.4" in shortform directory 805308321 references free inode 939526081
junking entry "python2.4" in directory inode 805308321
entry "components" in shortform directory 805308326 references free inode 939526086
junking entry "components" in directory inode 805308326
entry "cache" at block 0 offset 48 in directory inode 805308330 references free inode 939526090
        clearing inode number in entry at offset 48...
entry "aspell" in shortform directory 805308332 references free inode 939526092
junking entry "aspell" in directory inode 805308332
entry "update-libc.d" in shortform directory 805308335 references free inode 939526095
junking entry "update-libc.d" in directory inode 805308335
entry "private" in shortform directory 805308336 references free inode 939526096
junking entry "private" in directory inode 805308336
entry "en_US" in shortform directory 805308339 references free inode 939526099
junking entry "en_US" in directory inode 805308339
entry "1" in shortform directory 805308340 references free inode 939526100
junking entry "1" in directory inode 805308340
entry "kde-applications-merged" at block 0 offset 48 in directory inode 805308341 references free inode 939526101
        clearing inode number in entry at offset 48...
entry "events" in shortform directory 805308351 references free inode 939526111
junking entry "events" in directory inode 805308351
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
entry "vi" at block 0 offset 240 in directory inode 1342179075 references free inode 939526084
        clearing inode number in entry at offset 240...
entry "it" at block 0 offset 504 in directory inode 1342179075 references free inode 939526085
        clearing inode number in entry at offset 504...
        - agno = 11
        - agno = 12
entry "ro" at block 0 offset 144 in directory inode 1610614679 references free inode 939526104
        clearing inode number in entry at offset 144...
        - agno = 13
entry "misc" in shortform directory 1744832408 references free inode 939526105
junking entry "misc" in directory inode 1744832408
entry "compat" at block 0 offset 200 in directory inode 1744832409 references free inode 939526107
        clearing inode number in entry at offset 200...
        - agno = 14
entry "dirmngr" at block 0 offset 200 in directory inode 1879050093 references free inode 939526094
        clearing inode number in entry at offset 200...
entry "pure-ftpd" at block 0 offset 768 in directory inode 1879050093 references free inode 939526097
        clearing inode number in entry at offset 768...
entry "ld.so.conf.d" at block 0 offset 992 in directory inode 1879050093 references free inode 939526098
        clearing inode number in entry at offset 992...
entry "hotplug.d" at block 0 offset 1536 in directory inode 1879050093 references free inode 939526102
        clearing inode number in entry at offset 1536...
entry "console-tools" at block 0 offset 1840 in directory inode 1879050093 references free inode 939526108
        clearing inode number in entry at offset 1840...
        - agno = 15
entry "hp" at block 0 offset 176 in directory inode 2013268025 references free inode 939526106
        clearing inode number in entry at offset 176...
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ...
rebuilding directory inode 128
rebuilding directory inode 1879050093
rebuilding directory inode 1610614679
rebuilding directory inode 1744832409
rebuilding directory inode 2013268025
rebuilding directory inode 402655063
rebuilding directory inode 805308341
rebuilding directory inode 402655041
rebuilding directory inode 134219629
rebuilding directory inode 805308330
rebuilding directory inode 1342179075
rebuilding directory inode 805308319
entry "6C1095804A88D" in shortform directory inode 18848 points to free inode 1814911
junking entry "6C1095804A88D" in directory inode 1814911
        - traversal finished ...
        - traversing all unattached subtrees ...
        - traversals finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 939525281, moving to lost+found
disconnected inode 939525296, moving to lost+found
disconnected inode 939525297, moving to lost+found
disconnected inode 939525298, moving to lost+found
disconnected inode 939525299, moving to lost+found
disconnected inode 939525300, moving to lost+found
disconnected inode 939525301, moving to lost+found
disconnected inode 939525302, moving to lost+found
disconnected inode 939525425, moving to lost+found
disconnected inode 939525426, moving to lost+found
disconnected inode 939526164, moving to lost+found
disconnected inode 939526200, moving to lost+found
disconnected inode 939526263, moving to lost+found
disconnected inode 939526266, moving to lost+found
disconnected inode 939526268, moving to lost+found
disconnected inode 939526270, moving to lost+found
disconnected inode 939526271, moving to lost+found
disconnected inode 939526280, moving to lost+found
disconnected inode 939526281, moving to lost+found
disconnected inode 939526282, moving to lost+found
disconnected inode 939526283, moving to lost+found
disconnected inode 939526284, moving to lost+found
disconnected inode 939526286, moving to lost+found
disconnected inode 939526287, moving to lost+found
disconnected inode 939526288, moving to lost+found
disconnected inode 939526300, moving to lost+found
disconnected inode 939526301, moving to lost+found
disconnected inode 939526302, moving to lost+found
disconnected inode 939526303, moving to lost+found
disconnected inode 939526304, moving to lost+found
disconnected inode 939526305, moving to lost+found
disconnected inode 939526307, moving to lost+found
disconnected inode 939526308, moving to lost+found
disconnected inode 939526309, moving to lost+found
disconnected inode 939526314, moving to lost+found
disconnected inode 939526315, moving to lost+found
disconnected inode 939526316, moving to lost+found
disconnected inode 939526317, moving to lost+found
disconnected inode 939526318, moving to lost+found
disconnected inode 939526328, moving to lost+found
disconnected inode 939526329, moving to lost+found
disconnected inode 939526330, moving to lost+found
disconnected inode 939526331, moving to lost+found
disconnected inode 939526332, moving to lost+found
disconnected inode 939526333, moving to lost+found
disconnected inode 939526334, moving to lost+found
disconnected inode 939526335, moving to lost+found
disconnected inode 939526934, moving to lost+found
disconnected inode 939526937, moving to lost+found
disconnected inode 939626830, moving to lost+found
disconnected inode 939626837, moving to lost+found
disconnected inode 939629683, moving to lost+found
disconnected inode 939629684, moving to lost+found
disconnected inode 939629685, moving to lost+found
disconnected inode 939629686, moving to lost+found
disconnected inode 939629687, moving to lost+found
disconnected inode 939629690, moving to lost+found
disconnected inode 939629691, moving to lost+found
disconnected inode 939633842, moving to lost+found
disconnected inode 939633843, moving to lost+found
disconnected inode 939633881, moving to lost+found
disconnected inode 939633897, moving to lost+found
disconnected inode 939633898, moving to lost+found
disconnected inode 939633899, moving to lost+found
disconnected inode 939633900, moving to lost+found
disconnected inode 939633901, moving to lost+found
disconnected inode 939633902, moving to lost+found
disconnected inode 939633903, moving to lost+found
disconnected inode 939633909, moving to lost+found
disconnected inode 939633910, moving to lost+found
disconnected inode 939634022, moving to lost+found
disconnected inode 939634023, moving to lost+found
disconnected inode 939634024, moving to lost+found
disconnected inode 939634025, moving to lost+found
disconnected inode 939707628, moving to lost+found
disconnected inode 939707629, moving to lost+found
disconnected inode 939707630, moving to lost+found
disconnected inode 939707633, moving to lost+found
disconnected inode 939707636, moving to lost+found
disconnected inode 939707639, moving to lost+found
disconnected inode 939707641, moving to lost+found
disconnected inode 939707643, moving to lost+found
disconnected inode 939707645, moving to lost+found
disconnected inode 939707712, moving to lost+found
disconnected inode 939734343, moving to lost+found
disconnected inode 939783610, moving to lost+found
disconnected inode 939783612, moving to lost+found
disconnected inode 939783613, moving to lost+found
disconnected inode 939783614, moving to lost+found
disconnected inode 939783616, moving to lost+found
disconnected inode 939783623, moving to lost+found
disconnected inode 939783635, moving to lost+found
disconnected inode 939783663, moving to lost+found
disconnected inode 939783672, moving to lost+found
disconnected inode 939804193, moving to lost+found
disconnected inode 939804194, moving to lost+found
disconnected inode 939804195, moving to lost+found
disconnected inode 939804196, moving to lost+found
disconnected inode 939804197, moving to lost+found
disconnected inode 939804198, moving to lost+found
disconnected inode 939804199, moving to lost+found
disconnected inode 939804200, moving to lost+found
disconnected inode 939804201, moving to lost+found
disconnected inode 939804203, moving to lost+found
disconnected inode 939804205, moving to lost+found
disconnected inode 939804206, moving to lost+found
disconnected inode 939804242, moving to lost+found
disconnected inode 939808074, moving to lost+found
disconnected inode 939808075, moving to lost+found
disconnected inode 939808076, moving to lost+found
disconnected inode 939808077, moving to lost+found
disconnected inode 939819891, moving to lost+found
disconnected inode 939820963, moving to lost+found
disconnected inode 939820964, moving to lost+found
disconnected inode 939820965, moving to lost+found
disconnected inode 939820966, moving to lost+found
disconnected inode 939820968, moving to lost+found
disconnected inode 939820969, moving to lost+found
disconnected inode 939820970, moving to lost+found
disconnected inode 939820971, moving to lost+found
disconnected inode 939820972, moving to lost+found
disconnected inode 939820973, moving to lost+found
disconnected inode 939820974, moving to lost+found
disconnected inode 939841107, moving to lost+found
disconnected inode 939843487, moving to lost+found
disconnected inode 939872184, moving to lost+found
disconnected inode 939872208, moving to lost+found
disconnected inode 940744021, moving to lost+found
disconnected inode 940744022, moving to lost+found
disconnected inode 940923246, moving to lost+found
disconnected inode 940923247, moving to lost+found
disconnected inode 940936619, moving to lost+found
disconnected inode 941261016, moving to lost+found
disconnected inode 941261017, moving to lost+found
disconnected inode 941261018, moving to lost+found
disconnected inode 941266732, moving to lost+found
disconnected inode 941266764, moving to lost+found
disconnected inode 941266765, moving to lost+found
disconnected inode 941274207, moving to lost+found
disconnected inode 941446125, moving to lost+found
disconnected inode 941458243, moving to lost+found
disconnected inode 941460430, moving to lost+found
disconnected inode 941460434, moving to lost+found
disconnected inode 941460443, moving to lost+found
disconnected inode 941460445, moving to lost+found
disconnected inode 941460452, moving to lost+found
disconnected inode 941460454, moving to lost+found
disconnected inode 941460455, moving to lost+found
disconnected inode 941460457, moving to lost+found
disconnected inode 941510370, moving to lost+found
disconnected inode 941510371, moving to lost+found
disconnected inode 941514067, moving to lost+found
disconnected inode 941514074, moving to lost+found
disconnected inode 941514114, moving to lost+found
disconnected inode 941514115, moving to lost+found
disconnected inode 941907501, moving to lost+found
disconnected inode 941907502, moving to lost+found
disconnected inode 941933094, moving to lost+found
disconnected inode 941933223, moving to lost+found
disconnected inode 941933225, moving to lost+found
disconnected inode 941933226, moving to lost+found
disconnected inode 941942463, moving to lost+found
disconnected inode 942080921, moving to lost+found
disconnected inode 942090075, moving to lost+found
disconnected inode 942090451, moving to lost+found
disconnected inode 942092049, moving to lost+found
disconnected inode 942092304, moving to lost+found
disconnected inode 942092305, moving to lost+found
disconnected inode 942092306, moving to lost+found
disconnected inode 942260373, moving to lost+found
disconnected dir inode 1074268001, moving to lost+found
disconnected dir inode 1074268007, moving to lost+found
disconnected dir inode 1074268009, moving to lost+found
disconnected dir inode 1074268014, moving to lost+found
disconnected dir inode 1074268017, moving to lost+found
disconnected dir inode 1074268019, moving to lost+found
disconnected dir inode 1074268022, moving to lost+found
disconnected dir inode 1074268024, moving to lost+found
disconnected dir inode 1207961425, moving to lost+found
disconnected dir inode 1342179089, moving to lost+found
Phase 7 - verify and correct link counts...
resetting inode 134219629 nlinks from 7 to 6
resetting inode 134219645 nlinks from 8 to 7
resetting inode 402655041 nlinks from 50 to 48
resetting inode 402655063 nlinks from 8 to 7
resetting inode 536872873 nlinks from 7 to 6
resetting inode 536872894 nlinks from 8 to 7
resetting inode 671090530 nlinks from 6 to 5
resetting inode 671090531 nlinks from 4 to 3
resetting inode 805308319 nlinks from 16 to 15
resetting inode 805308321 nlinks from 4 to 3
resetting inode 805308326 nlinks from 5 to 4
resetting inode 805308330 nlinks from 3 to 2
resetting inode 805308332 nlinks from 5 to 4
resetting inode 805308335 nlinks from 3 to 2
resetting inode 805308336 nlinks from 4 to 3
resetting inode 805308339 nlinks from 4 to 3
resetting inode 805308340 nlinks from 7 to 6
resetting inode 805308341 nlinks from 4 to 3
resetting inode 805308351 nlinks from 3 to 2
resetting inode 1342179075 nlinks from 43 to 41
resetting inode 1610614679 nlinks from 21 to 20
resetting inode 1744832408 nlinks from 8 to 7
resetting inode 1744832409 nlinks from 10 to 9
resetting inode 1879050093 nlinks from 132 to 127
resetting inode 2013268025 nlinks from 12 to 11
done
1;36mroot@1[~]#0;39m Kxfs_repair -v /dev/hda2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
zero_log: head block 2 tail block 2
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
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ...
rebuilding directory inode 128
        - traversal finished ...
        - traversing all unattached subtrees ...
        - traversals finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 939525281, moving to lost+found
disconnected inode 939525296, moving to lost+found
disconnected inode 939525297, moving to lost+found
disconnected inode 939525298, moving to lost+found
disconnected inode 939525299, moving to lost+found
disconnected inode 939525300, moving to lost+found
disconnected inode 939525301, moving to lost+found
disconnected inode 939525302, moving to lost+found
disconnected inode 939525425, moving to lost+found
disconnected inode 939525426, moving to lost+found
disconnected inode 939526164, moving to lost+found
disconnected inode 939526200, moving to lost+found
disconnected inode 939526263, moving to lost+found
disconnected inode 939526266, moving to lost+found
disconnected inode 939526268, moving to lost+found
disconnected inode 939526270, moving to lost+found
disconnected inode 939526271, moving to lost+found
disconnected inode 939526280, moving to lost+found
disconnected inode 939526281, moving to lost+found
disconnected inode 939526282, moving to lost+found
disconnected inode 939526283, moving to lost+found
disconnected inode 939526284, moving to lost+found
disconnected inode 939526286, moving to lost+found
disconnected inode 939526287, moving to lost+found
disconnected inode 939526288, moving to lost+found
disconnected inode 939526300, moving to lost+found
disconnected inode 939526301, moving to lost+found
disconnected inode 939526302, moving to lost+found
disconnected inode 939526303, moving to lost+found
disconnected inode 939526304, moving to lost+found
disconnected inode 939526305, moving to lost+found
disconnected inode 939526307, moving to lost+found
disconnected inode 939526308, moving to lost+found
disconnected inode 939526309, moving to lost+found
disconnected inode 939526314, moving to lost+found
disconnected inode 939526315, moving to lost+found
disconnected inode 939526316, moving to lost+found
disconnected inode 939526317, moving to lost+found
disconnected inode 939526318, moving to lost+found
disconnected inode 939526328, moving to lost+found
disconnected inode 939526329, moving to lost+found
disconnected inode 939526330, moving to lost+found
disconnected inode 939526331, moving to lost+found
disconnected inode 939526332, moving to lost+found
disconnected inode 939526333, moving to lost+found
disconnected inode 939526334, moving to lost+found
disconnected inode 939526335, moving to lost+found
disconnected inode 939526934, moving to lost+found
disconnected inode 939526937, moving to lost+found
disconnected inode 939626830, moving to lost+found
disconnected inode 939626837, moving to lost+found
disconnected inode 939629683, moving to lost+found
disconnected inode 939629684, moving to lost+found
disconnected inode 939629685, moving to lost+found
disconnected inode 939629686, moving to lost+found
disconnected inode 939629687, moving to lost+found
disconnected inode 939629690, moving to lost+found
disconnected inode 939629691, moving to lost+found
disconnected inode 939633842, moving to lost+found
disconnected inode 939633843, moving to lost+found
disconnected inode 939633881, moving to lost+found
disconnected inode 939633897, moving to lost+found
disconnected inode 939633898, moving to lost+found
disconnected inode 939633899, moving to lost+found
disconnected inode 939633900, moving to lost+found
disconnected inode 939633901, moving to lost+found
disconnected inode 939633902, moving to lost+found
disconnected inode 939633903, moving to lost+found
disconnected inode 939633909, moving to lost+found
disconnected inode 939633910, moving to lost+found
disconnected inode 939634022, moving to lost+found
disconnected inode 939634023, moving to lost+found
disconnected inode 939634024, moving to lost+found
disconnected inode 939634025, moving to lost+found
disconnected inode 939707628, moving to lost+found
disconnected inode 939707629, moving to lost+found
disconnected inode 939707630, moving to lost+found
disconnected inode 939707633, moving to lost+found
disconnected inode 939707636, moving to lost+found
disconnected inode 939707639, moving to lost+found
disconnected inode 939707641, moving to lost+found
disconnected inode 939707643, moving to lost+found
disconnected inode 939707645, moving to lost+found
disconnected inode 939707712, moving to lost+found
disconnected inode 939734343, moving to lost+found
disconnected inode 939783610, moving to lost+found
disconnected inode 939783612, moving to lost+found
disconnected inode 939783613, moving to lost+found
disconnected inode 939783614, moving to lost+found
disconnected inode 939783616, moving to lost+found
disconnected inode 939783623, moving to lost+found
disconnected inode 939783635, moving to lost+found
disconnected inode 939783663, moving to lost+found
disconnected inode 939783672, moving to lost+found
disconnected inode 939804193, moving to lost+found
disconnected inode 939804194, moving to lost+found
disconnected inode 939804195, moving to lost+found
disconnected inode 939804196, moving to lost+found
disconnected inode 939804197, moving to lost+found
disconnected inode 939804198, moving to lost+found
disconnected inode 939804199, moving to lost+found
disconnected inode 939804200, moving to lost+found
disconnected inode 939804201, moving to lost+found
disconnected inode 939804203, moving to lost+found
disconnected inode 939804205, moving to lost+found
disconnected inode 939804206, moving to lost+found
disconnected inode 939804242, moving to lost+found
disconnected inode 939808074, moving to lost+found
disconnected inode 939808075, moving to lost+found
disconnected inode 939808076, moving to lost+found
disconnected inode 939808077, moving to lost+found
disconnected inode 939819891, moving to lost+found
disconnected inode 939820963, moving to lost+found
disconnected inode 939820964, moving to lost+found
disconnected inode 939820965, moving to lost+found
disconnected inode 939820966, moving to lost+found
disconnected inode 939820968, moving to lost+found
disconnected inode 939820969, moving to lost+found
disconnected inode 939820970, moving to lost+found
disconnected inode 939820971, moving to lost+found
disconnected inode 939820972, moving to lost+found
disconnected inode 939820973, moving to lost+found
disconnected inode 939820974, moving to lost+found
disconnected inode 939841107, moving to lost+found
disconnected inode 939843487, moving to lost+found
disconnected inode 939872184, moving to lost+found
disconnected inode 939872208, moving to lost+found
disconnected inode 940744021, moving to lost+found
disconnected inode 940744022, moving to lost+found
disconnected inode 940923246, moving to lost+found
disconnected inode 940923247, moving to lost+found
disconnected inode 940936619, moving to lost+found
disconnected inode 941261016, moving to lost+found
disconnected inode 941261017, moving to lost+found
disconnected inode 941261018, moving to lost+found
disconnected inode 941266732, moving to lost+found
disconnected inode 941266764, moving to lost+found
disconnected inode 941266765, moving to lost+found
disconnected inode 941274207, moving to lost+found
disconnected inode 941446125, moving to lost+found
disconnected inode 941458243, moving to lost+found
disconnected inode 941460430, moving to lost+found
disconnected inode 941460434, moving to lost+found
disconnected inode 941460443, moving to lost+found
disconnected inode 941460445, moving to lost+found
disconnected inode 941460452, moving to lost+found
disconnected inode 941460454, moving to lost+found
disconnected inode 941460455, moving to lost+found
disconnected inode 941460457, moving to lost+found
disconnected inode 941510370, moving to lost+found
disconnected inode 941510371, moving to lost+found
disconnected inode 941514067, moving to lost+found
disconnected inode 941514074, moving to lost+found
disconnected inode 941514114, moving to lost+found
disconnected inode 941514115, moving to lost+found
disconnected inode 941907501, moving to lost+found
disconnected inode 941907502, moving to lost+found
disconnected inode 941933094, moving to lost+found
disconnected inode 941933223, moving to lost+found
disconnected inode 941933225, moving to lost+found
disconnected inode 941933226, moving to lost+found
disconnected inode 941942463, moving to lost+found
disconnected inode 942080921, moving to lost+found
disconnected inode 942090075, moving to lost+found
disconnected inode 942090451, moving to lost+found
disconnected inode 942092049, moving to lost+found
disconnected inode 942092304, moving to lost+found
disconnected inode 942092305, moving to lost+found
disconnected inode 942092306, moving to lost+found
disconnected inode 942260373, moving to lost+found
disconnected dir inode 1074268001, moving to lost+found
disconnected dir inode 1074268007, moving to lost+found
disconnected dir inode 1074268009, moving to lost+found
disconnected dir inode 1074268014, moving to lost+found
disconnected dir inode 1074268017, moving to lost+found
disconnected dir inode 1074268019, moving to lost+found
disconnected dir inode 1074268022, moving to lost+found
disconnected dir inode 1074268024, moving to lost+found
disconnected dir inode 1207961425, moving to lost+found
disconnected dir inode 1342179089, moving to lost+found
Phase 7 - verify and correct link counts...
done
1;36mroot@1[~]#0;39m Kxfs_repair -v /dev/hd1Pd1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
zero_log: head block 111878 tail block 111878
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
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - clear lost+found (if it exists) ...
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
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ...
        - traversal finished ...
        - traversing all unattached subtrees ...
        - traversals finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
1;36mroot@1[~]#0;39m Kxfs_repair -v /dev/hd1Pg1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
zero_log: head block 73 tail block 73
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
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - clear lost+found (if it exists) ...
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
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ...
        - traversal finished ...
        - traversing all unattached subtrees ...
        - traversals finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
1;36mroot@1[~]#0;39m Kmkdir /tmp/hda1
1;36mroot@1[~]#0;39m KKKmkdird/tmp/hda2tmp/hd
1;36mroot@1[~]#0;39m Kmount /dev/hda2 /tmp/hda2
1;36mroot@1[~]#0;39m Kcd /tmp/hda2
1;36mroot@1[hda2]#0;39m ls
0m01;34ma0m     01;34mbin0m   01;34md20m   01;34mhome0m        01;34mlib0m         01;34mmnt0m   01;34msbin0m  01;34musr0m   01;36mvmlinuz0m
01;36mapp0m   01;34mboot0m  01;34mdev0m  01;34minitrd0m      01;34mlost+found0m  01;34mproc0m  01;34msys0m   01;36mvapp0m  01;34mx0m
01;36mappc0m  01;34md10m    01;34metc0m  01;36minitrd.img0m  01;34mmedia0m       01;34mroot0m  01;34mtmp0m   01;34mvar0m
m1;36mroot@1[hda2]#0;39m cd lost*
1;36mroot@1[lost+found]#0;39m ls
0m01;34m10742680010m  0m9395262710m  0m9395263310m  0m9396339090m  0m9398041930m  0m9398209720m  0m9414604540m
01;34m10742680070m  0m9395262800m  0m9395263320m  0m9396339100m  0m9398041940m  0m9398209730m  0m9414604550m
01;34m10742680090m  0m9395262810m  0m9395263330m  0m9396340220m  0m9398041950m  0m9398209740m  0m9414604570m
01;34m10742680140m  0m9395262820m  0m9395263340m  0m9396340230m  0m9398041960m  0m9398411070m  0m9415103700m
01;34m10742680170m  0m9395262830m  0m9395263350m  0m9396340240m  0m9398041970m  0m9398434870m  0m9415103710m
01;34m10742680190m  0m9395262840m  0m9395269340m  0m9396340250m  0m9398041980m  0m9398721840m  0m9415140670m
01;34m10742680220m  0m9395262860m  0m9395269370m  0m9397076280m  0m9398041990m  0m9398722080m  0m9415140740m
01;34m10742680240m  0m9395262870m  0m9396268300m  0m9397076290m  0m9398042000m  01;32m9407440210m  0m9415141140m
01;34m12079614250m  0m9395262880m  0m9396268370m  0m9397076300m  0m9398042010m  01;32m9407440220m  0m9415141150m
01;34m13421790890m  0m9395263000m  0m9396296830m  0m9397076330m  0m9398042030m  0m9409232460m  0m9419075010m
0m9395252810m   0m9395263010m  0m9396296840m  0m9397076360m  0m9398042050m  0m9409232470m  0m9419075020m
0m9395252960m   0m9395263020m  0m9396296850m  0m9397076390m  0m9398042060m  0m9409366190m  01;32m9419330940m
0m9395252970m   0m9395263030m  0m9396296860m  0m9397076410m  0m9398042420m  01;36m9412610160m  0m9419332230m
0m9395252980m   0m9395263040m  0m9396296870m  0m9397076430m  0m9398080740m  0m9412610170m  0m9419332250m
0m9395252990m   0m9395263050m  0m9396296900m  0m9397076450m  0m9398080750m  0m9412610180m  0m9419332260m
0m9395253000m   0m9395263070m  0m9396296910m  0m9397077120m  0m9398080760m  01;36m9412667320m  0m9419424630m
0m9395253010m   0m9395263080m  0m9396338420m  0m9397343430m  0m9398080770m  01;36m9412667640m  0m9420809210m
0m9395253020m   0m9395263090m  0m9396338430m  0m9397836100m  0m9398198910m  0m9412667650m  0m9420900750m
0m9395254250m   0m9395263140m  0m9396338810m  0m9397836120m  0m9398209630m  0m9412742070m  0m9420904510m
0m9395254260m   0m9395263150m  0m9396338970m  0m9397836130m  0m9398209640m  0m9414461250m  0m9420920490m
0m9395261640m   0m9395263160m  0m9396338980m  0m9397836140m  0m9398209650m  0m9414582430m  0m9420923040m
0m9395262000m   0m9395263170m  0m9396338990m  0m9397836160m  0m9398209660m  0m9414604300m  0m9420923050m
0m9395262630m   0m9395263180m  0m9396339000m  0m9397836230m  0m9398209680m  0m9414604340m  0m9420923060m
0m9395262660m   0m9395263280m  0m9396339010m  0m9397836350m  0m9398209690m  0m9414604430m  0m9422603730m
0m9395262680m   0m9395263290m  0m9396339020m  0m9397836630m  0m9398209700m  0m9414604450m
0m9395262700m   0m9395263300m  0m9396339030m  0m9397836720m  0m9398209710m  0m9414604520m
m1;36mroot@1[lost+found]#0;39m ls -al
0mtotal 15540
drwxr-xr-x  12 root root      8192 Nov 23 10:01 01;34m.0m
drwxr-xr-x  23 root root      4096 Oct 28 06:32 01;34m..0m
drwxr-xr-x   3 root root       118 Oct  7 07:33 01;34m10742680010m
drwxr-xr-x   2 root root         6 Apr 19  2005 01;34m10742680070m
drwxr-xr-x   2 root root        25 Jun 18 10:00 01;34m10742680090m
drwxr-xr-x   2 root root         6 Apr 19  2005 01;34m10742680140m
drwxr-xr-x   2 root root        31 Oct 21 06:22 01;34m10742680170m
drwxr-xr-x   3 root root        23 Jan 28  2005 01;34m10742680190m
drwxr-xr-x   2 root root        28 Sep  2 07:13 01;34m10742680220m
drwxr-xr-x   2 root root        19 Sep  2 07:15 01;34m10742680240m
drwxr-xr-x   2 root root         6 Sep 28  2004 01;34m12079614250m
drwxr-xr-x   2 root root       112 Oct 21 06:28 01;34m13421790890m
-rw-r--r--   1 root root    137463 Nov 18 06:36 0m9395252810m
-rw-r--r--   1 root root      5030 Nov 18 06:36 0m9395252960m
-rw-r--r--   1 root root    214150 Nov 18 06:36 0m9395252970m
-rw-r--r--   1 root root     45628 Nov 18 06:35 0m9395252980m
-rw-r--r--   1 root root    201991 Nov 18 06:36 0m9395252990m
-rw-r--r--   1 root root    256393 Nov 18 06:36 0m9395253000m
-rw-r--r--   1 root root    277659 Nov 18 06:36 0m9395253010m
-rw-r--r--   1 root root     40770 Nov 18 06:16 0m9395253020m
-rw-r--r--   1 root root      7925 Nov 18 06:16 0m9395254250m
-rw-r--r--   1 root root    154710 Nov 18 06:36 0m9395254260m
-rw-r--r--   1 root root     24027 Nov 18 06:35 0m9395261640m
-rw-r--r--   1 root root    261048 Nov 18 06:36 0m9395262000m
-rw-r--r--   1 root root     86527 Nov 18 06:36 0m9395262630m
-rw-r--r--   1 root root    198932 Nov 18 06:36 0m9395262660m
-rw-r--r--   1 root root    222726 Nov 18 06:36 0m9395262680m
-rw-r--r--   1 root root     61110 Nov 18 06:36 0m9395262700m
-rw-r--r--   1 root root    137263 Nov 18 06:36 0m9395262710m
-rw-r--r--   1 root root    173481 Nov 18 06:35 0m9395262800m
-rw-r--r--   1 root root    110993 Nov 18 06:36 0m9395262810m
-rw-r--r--   1 root root    220421 Nov 18 06:36 0m9395262820m
-rw-r--r--   1 root root    104893 Nov 18 06:16 0m9395262830m
-rw-r--r--   1 root root    235904 Nov 18 06:36 0m9395262840m
-rw-r--r--   1 root root     18070 Nov 18 06:16 0m9395262860m
-rw-r--r--   1 root root      5543 Nov 18 06:16 0m9395262870m
-rw-r--r--   1 root root    238969 Nov 18 06:36 0m9395262880m
-rw-r--r--   1 root root     77329 Nov 18 06:36 0m9395263000m
-rw-r--r--   1 root root    159049 Nov 18 06:36 0m9395263010m
-rw-r--r--   1 root root    224866 Nov 18 06:36 0m9395263020m
-rw-r--r--   1 root root    228463 Nov 18 06:36 0m9395263030m
-rw-r--r--   1 root root    155675 Nov 18 06:36 0m9395263040m
-rw-r--r--   1 root root    176774 Nov 18 06:36 0m9395263050m
-rw-r--r--   1 root root    227041 Nov 18 06:36 0m9395263070m
-rw-r--r--   1 root root    274659 Nov 18 06:36 0m9395263080m
-rw-r--r--   1 root root    261357 Nov 18 06:36 0m9395263090m
-rw-r--r--   1 root root      3415 Nov 18 06:16 0m9395263140m
-rw-r--r--   1 root root    102324 Nov 18 06:36 0m9395263150m
-rw-r--r--   1 root root    192552 Nov 18 06:35 0m9395263160m
-rw-r--r--   1 root root    242376 Nov 18 06:36 0m9395263170m
-rw-r--r--   1 root root    147585 Nov 18 06:36 0m9395263180m
-rw-r--r--   1 root root    168016 Nov 18 06:35 0m9395263280m
-rw-r--r--   1 root root    229258 Nov 18 06:36 0m9395263290m
-rw-r--r--   1 root root    227503 Nov 18 06:36 0m9395263300m
-rw-r--r--   1 root root    240842 Nov 18 06:36 0m9395263310m
-rw-r--r--   1 root root    207746 Nov 18 06:36 0m9395263320m
-rw-r--r--   1 root root    190586 Nov 18 06:36 0m9395263330m
-rw-r--r--   1 root root    169669 Nov 18 06:36 0m9395263340m
-rw-r--r--   1 root root     79349 Nov 18 06:16 0m9395263350m
-rw-r--r--   1 root root    233336 Nov 18 06:36 0m9395269340m
-rw-r--r--   1 root root    254633 Nov 18 06:36 0m9395269370m
-rw-r--r--   1 root root    151098 Nov 18 06:36 0m9396268300m
-rw-r--r--   1 root root     56929 Nov 18 06:36 0m9396268370m
-rw-r--r--   1 root root     44455 Nov 18 06:35 0m9396296830m
-rw-r--r--   1 root root    253932 Nov 18 06:36 0m9396296840m
-rw-r--r--   1 root root    266353 Nov 18 06:36 0m9396296850m
-rw-r--r--   1 root root    272961 Nov 18 06:36 0m9396296860m
-rw-r--r--   1 root root     42935 Nov 18 06:35 0m9396296870m
-rw-r--r--   1 root root    250118 Nov 18 06:36 0m9396296900m
-rw-r--r--   1 root root     25575 Nov 18 06:36 0m9396296910m
-rw-r--r--   1 root root    138874 Nov 18 06:36 0m9396338420m
-rw-r--r--   1 root root    164779 Nov 18 06:36 0m9396338430m
-rw-r--r--   1 root root      6270 Sep 30 17:15 0m9396338810m
-rw-r--r--   1 root root    138223 Nov 18 06:36 0m9396338970m
-rw-r--r--   1 root root    264691 Nov 18 06:36 0m9396338980m
-rw-r--r--   1 root root    237897 Nov 18 06:36 0m9396338990m
-rw-r--r--   1 root root    258196 Nov 18 06:36 0m9396339000m
-rw-r--r--   1 root root    210051 Nov 18 06:36 0m9396339010m
-rw-r--r--   1 root root    261781 Nov 18 06:36 0m9396339020m
-rw-r--r--   1 root root     32682 Nov 18 06:16 0m9396339030m
-rw-r--r--   1 root root    197097 Nov 18 06:36 0m9396339090m
-rw-r--r--   1 root root      5035 Nov 18 06:16 0m9396339100m
-rw-r--r--   1 root root    174043 Nov 18 06:36 0m9396340220m
-rw-r--r--   1 root root    243884 Nov 18 06:36 0m9396340230m
-rw-r--r--   1 root root    244551 Nov 18 06:36 0m9396340240m
-rw-r--r--   1 root root    187625 Nov 18 06:36 0m9396340250m
-rw-r--r--   1 root root    146903 Nov 18 06:36 0m9397076280m
-rw-r--r--   1 root root    217365 Nov 18 06:36 0m9397076290m
-rw-r--r--   1 root root    172851 Nov 18 06:36 0m9397076300m
-rw-r--r--   1 root root    252126 Nov 18 06:36 0m9397076330m
-rw-r--r--   1 root root    258958 Nov 18 06:36 0m9397076360m
-rw-r--r--   1 root root      5908 Nov 18 06:36 0m9397076390m
-rw-r--r--   1 root root    189787 Nov 18 06:36 0m9397076410m
-rw-r--r--   1 root root    119942 Nov 18 06:36 0m9397076430m
-rw-r--r--   1 root root   1206126 Nov 18 06:36 0m9397076450m
-rw-r--r--   1 root root      2931 Sep 24 04:09 0m9397077120m
-rw-r-----   1 root bacula     887 May 29 10:46 0m9397343430m
-rw-r--r--   1 root root      1626 Aug 31  2005 0m9397836100m
-rw-r--r--   1 root root       675 Aug 31  2005 0m9397836120m
-rw-r--r--   1 root root      1877 Aug 31  2005 0m9397836130m
-rw-r--r--   1 root root       436 Aug 31  2005 0m9397836140m
-rw-r--r--   1 root root      1379 Aug 31  2005 0m9397836160m
-rw-r--r--   1 root root      1194 Jan 14  2006 0m9397836230m
-rw-r-----   1 root root        82 Oct 23  2005 0m9397836350m
-rw-r-----   1 root bacula     312 Apr 30  2006 0m9397836630m
-rw-r-----   1 root bacula     668 Feb 19  2006 0m9397836720m
-rw-r--r--   1 root root      1184 Dec 15  2004 0m9398041930m
-rw-r--r--   1 root root       237 Dec 15  2004 0m9398041940m
-rw-r--r--   1 root root       255 Dec 15  2004 0m9398041950m
-rw-r--r--   1 root root       672 Dec 15  2004 0m9398041960m
-rw-r--r--   1 root root      1482 Dec 15  2004 0m9398041970m
-rw-r--r--   1 root root      4104 Dec 15  2004 0m9398041980m
-rw-r--r--   1 root root       257 Dec 15  2004 0m9398041990m
-rw-r--r--   1 root root       396 Dec 15  2004 0m9398042000m
-rw-r--r--   1 root root      1530 Dec 15  2004 0m9398042010m
-rw-r-----   1 root root       126 Jul 18 01:29 0m9398042030m
-rw-r-----   1 root root       725 Jul 18 01:29 0m9398042050m
-rw-r--r--   1 root root      1720 Aug 31  2005 0m9398042060m
-rw-r-----   1 root bacula     273 Jul 18 01:29 0m9398042420m
-rw-r--r--   1 root root       503 Jan 14  2006 0m9398080740m
-rw-r--r--   1 root root       501 Jan 14  2006 0m9398080750m
-rw-r--r--   1 root root       520 Jan 14  2006 0m9398080760m
-rw-r--r--   1 root root      2558 Jan 14  2006 0m9398080770m
-rw-r--r--   1 root root    195404 Nov 18 06:36 0m9398198910m
-rw-r-----   1 root bacula      84 Aug 22  2005 0m9398209630m
-rw-r-----   1 root bacula     248 Aug 22  2005 0m9398209640m
-rw-r-----   1 root bacula     184 Aug 22  2005 0m9398209650m
-rw-r-----   1 root bacula    1545 Aug 22  2005 0m9398209660m
-rw-r-----   1 root bacula     831 Aug 22  2005 0m9398209680m
-rw-r-----   1 root bacula     555 Aug 22  2005 0m9398209690m
-rw-r-----   1 root bacula     101 Aug 22  2005 0m9398209700m
-rw-r-----   1 root bacula     614 Aug 22  2005 0m9398209710m
-rw-r-----   1 root bacula     251 Aug 22  2005 0m9398209720m
-rw-r-----   1 root bacula      93 Aug 22  2005 0m9398209730m
-rw-r-----   1 root bacula     138 Aug 22  2005 0m9398209740m
-rw-r--r--   1 root root       840 Apr  7  2005 0m9398411070m
-rw-r--r--   1 root root      3393 Dec 15  2004 0m9398434870m
-rw-r--r--   1 root root      9232 Nov 20 18:08 0m9398721840m
-rw-r--r--   1 root root         0 Jan 28  2005 0m9398722080m
-rwxr-xr-x   1 root root       211 Feb 28  2005 01;32m9407440210m
-rwxr-xr-x   1 root root       162 Dec 19  2004 01;32m9407440220m
-rw-r--r--   1 root root     22291 Oct 19 05:33 0m9409232460m
-rw-r--r--   1 root root     14612 Oct 19 05:33 0m9409232470m
-rw-r--r--   1 root root       402 Sep 30 14:31 0m9409366190m
lrwxrwxrwx   1 root root        57 Oct  9 18:37 01;36m9412610160m -> 0m/usr/share/python-support/python-feedparser/feedparser.py0m
-rw-r--r--   1 root root        84 Oct 28 07:54 0m9412610170m
-rw-r--r--   1 root root     94122 Sep  2 07:11 0m9412610180m
lrwxrwxrwx   1 root root        47 Oct  9 18:37 01;36m9412667320m -> 0m/usr/share/python-support/python-gtk2/pygtk.pth0m
lrwxrwxrwx   1 root root        46 Oct  9 18:37 01;36m9412667640m -> 0m/usr/share/python-support/python-gtk2/pygtk.py0m
-rw-r--r--   1 root root      1604 Oct  7 07:33 0m9412667650m
-rw-r-----   1 root bacula    7235 Nov  2 17:58 0m9412742070m
-rw-r--r--   1 root root       813 May 23  2005 0m9414461250m
-rw-r--r--   1 root root       408 May 23  2005 0m9414582430m
-rw-r-----   1 root bacula     273 Oct 21 04:41 0m9414604300m
-rw-r-----   1 root root       141 Oct 21 04:41 0m9414604340m
-rw-r-----   1 root root        79 Oct 21 04:41 0m9414604430m
-rw-r-----   1 root bacula     118 Oct 21 04:41 0m9414604450m
-rw-r-----   1 root root       377 Oct 21 04:41 0m9414604520m
-rw-r-----   1 root root      1300 Oct 21 04:41 0m9414604540m
-rw-r-----   1 root bacula     747 Oct 21 04:41 0m9414604550m
-rw-r-----   1 root bacula    1394 Oct 21 04:41 0m9414604570m
-rw-r--r--   1 root root        30 Apr 19  2005 0m9415103700m
-rw-r--r--   1 root root        42 Apr 19  2005 0m9415103710m
-rw-r--r--   1 root root     27091 Nov 11 06:28 0m9415140670m
-rw-r--r--   1 root root     28928 Nov 11 06:28 0m9415140740m
-rw-r--r--   1 root root     27044 Sep  1 03:50 0m9415141140m
-rw-r--r--   1 root root     27044 Sep  1 03:50 0m9415141150m
-rw-r--r--   1 root root     95494 Jun  3 14:05 0m9419075010m
-rw-r--r--   1 root root    144186 Jun  3 14:05 0m9419075020m
-rwxr-xr-x   1 root root        64 Aug 24 16:20 01;32m9419330940m
-rw-r--r--   1 root root      3055 Jan 27  2005 0m9419332230m
-rw-r--r--   1 root root       170 May 23  2004 0m9419332250m
-rw-r--r--   1 root root      2855 Feb  5  2005 0m9419332260m
-rw-r--r--   1 root root       230 Sep 28  2004 0m9419424630m
-rw-r--r--   1 root root      1564 Sep  2 07:12 0m9420809210m
-rw-r--r--   1 root root     82729 Oct 14 10:01 0m9420900750m
-rw-r--r--   1 root root      1565 Jul 17  2002 0m9420904510m
-rw-r--r--   1 root root       321 Jul  1 11:53 0m9420920490m
-rw-r--r--   1 root root       145 Jul  1 10:57 0m9420923040m
-rw-r--r--   1 root root       850 Jul  1 10:57 0m9420923050m
-rw-r--r--   1 root root       546 Sep  2 07:14 0m9420923060m
-rw-------   1 root root     24399 Nov  4 06:21 0m9422603730m
m1;36mroot@1[lost+found]#0;39m file *
1074268001: directory
1074268007: directory
1074268009: directory
1074268014: directory
1074268017: directory
1074268019: directory
1074268022: directory
1074268024: directory
1207961425: directory
1342179089: directory
939525281:  XML document text
939525296:  XML document text
939525297:  XML document text
939525298:  XML document text
939525299:  XML document text
939525300:  XML document text
939525301:  XML document text
939525302:  XML document text
939525425:  XML document text
939525426:  XML document text
939526164:  XML document text
939526200:  XML document text
939526263:  XML document text
939526266:  XML document text
939526268:  XML document text
939526270:  XML document text
939526271:  XML document text
939526280:  XML document text
939526281:  XML document text
939526282:  XML document text
939526283:  XML document text
939526284:  XML document text
939526286:  XML document text
939526287:  XML document text
939526288:  XML document text
939526300:  XML document text
939526301:  XML document text
939526302:  XML document text
939526303:  XML document text
939526304:  XML document text
939526305:  XML document text
939526307:  XML document text
939526308:  XML document text
939526309:  XML document text
939526314:  XML document text
939526315:  XML document text
939526316:  XML document text
939526317:  XML document text
939526318:  XML document text
939526328:  XML document text
939526329:  XML document text
939526330:  XML document text
939526331:  XML document text
939526332:  XML document text
939526333:  XML document text
939526334:  XML document text
939526335:  XML document text
939526934:  XML document text
939526937:  XML document text
939626830:  XML document text
939626837:  XML document text
939629683:  XML document text
939629684:  XML document text
939629685:  XML document text
939629686:  XML document text
939629687:  XML document text
939629690:  XML document text
939629691:  XML document text
939633842:  XML document text
939633843:  XML document text
939633881:  Assembler source
939633897:  XML document text
939633898:  XML document text
939633899:  XML document text
939633900:  XML document text
939633901:  XML document text
939633902:  XML document text
939633903:  XML document text
939633909:  XML document text
939633910:  XML document text
939634022:  XML document text
939634023:  XML document text
939634024:  XML document text
939634025:  XML document text
939707628:  XML document text
939707629:  XML document text
939707630:  XML document text
939707633:  XML document text
939707636:  XML document text
939707639:  XML document text
939707641:  XML document text
939707643:  XML document text
939707645:  XML document text
939707712:  UTF-8 Unicode text
939734343:  ASCII text
939783610:  ASCII C++ program text
939783612:  ASCII C++ program text
939783613:  ASCII C++ program text
939783614:  ASCII C++ program text
939783616:  ASCII C++ program text
939783623:  ASCII C++ program text
939783635:  ASCII text
939783663:  ASCII text
939783672:  ASCII text
939804193:  ASCII C++ program text
939804194:  ASCII C++ program text
939804195:  ASCII C++ program text
939804196:  ASCII C++ program text
939804197:  ASCII C++ program text
939804198:  ASCII C++ program text
939804199:  ASCII C++ program text
939804200:  ASCII C++ program text
939804201:  ASCII C++ program text
939804203:  ASCII text
939804205:  ASCII text
939804206:  ASCII English text
939804242:  ASCII text
939808074:  ASCII C++ program text
939808075:  ASCII C++ program text
939808076:  ASCII C++ program text
939808077:  ASCII C++ program text
939819891:  XML document text
939820963:  ASCII text
939820964:  ASCII text
939820965:  ASCII text
939820966:  ASCII text, with very long lines
939820968:  ASCII text
939820969:  ASCII text
939820970:  ASCII text
939820971:  ASCII text, with very long lines
939820972:  ASCII text
939820973:  ASCII text
939820974:  ASCII text
939841107:  ASCII English text
939843487:  ASCII C++ program text
939872184:  ASCII text, with very long lines
939872208:  empty
940744021:  Bourne shell script text executable
940744022:  Bourne shell script text executable
940923246:  UTF-8 Unicode text
940923247:  UTF-8 Unicode text
940936619:  ASCII text
941261016:  broken symbolic link to `/usr/share/python-support/python-feedparser/feedparser.py'
941261017:  ASCII text
941261018:  data
941266732:  broken symbolic link to `/usr/share/python-support/python-gtk2/pygtk.pth'
941266764:  broken symbolic link to `/usr/share/python-support/python-gtk2/pygtk.py'
941266765:  data
941274207:  ASCII English text, with very long lines
941446125:  ASCII English text
941458243:  ASCII text
941460430:  ASCII text
941460434:  ASCII text
941460443:  ASCII text
941460445:  ASCII text
941460452:  ASCII English text
941460454:  ASCII English text
941460455:  ASCII text
941460457:  ASCII English text
941510370:  ASCII text
941510371:  ASCII text
941514067:  XML document text
941514074:  XML document text
941514114:  XML document text
941514115:  XML document text
941907501:  ASCII text
941907502:  ASCII text, with very long lines
941933094:  ASCII text
941933223:  ASCII English text
941933225:  ASCII English text
941933226:  ASCII English text
941942463:  ASCII text
942080921:  ASCII English text
942090075:  ASCII English text
942090451:  exported SGML document text
942092049:  ASCII English text
942092304:  ASCII text
942092305:  ASCII English text
942092306:  ASCII English text
942260373:  ASCII English text
1;36mroot@1[lost+found]#0;39m more *

*** 1074268001: directory ***


*** 1074268007: directory ***


*** 1074268009: directory ***


*** 1074268014: directory ***


*** 1074268017: directory ***


*** 1074268019: directory ***


*** 1074268022: directory ***


*** 1074268024: directory ***


*** 1207961425: directory ***


*** 1342179089: directory ***

1;36mroot@1[/]#0;39m !1
xfs_repair -n /dev/hda2
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
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
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
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem starting at / ...
        - traversal finished ...
        - traversing all unattached subtrees ...
        - traversals finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.
1;36mroot@1[/]#0;39m
Script done on Thu Nov 23 10:06:36 2006


On Wed, 22 Nov 2006, Russell Cattelan wrote:

> On Mon, 2006-11-20 at 15:00 -0500, Justin Piszcz wrote:
> > Anyone know what could cause this?
> > Is the last good kernel to use 2.6.17.6 w/XFS bugfix patch?
> > 
> > Was a new bug introduced from 2.6.16.6 -> 2.6.17.13?
> 
> you must have missed the "new bugs introduced in this release" :-)
> 
> There is no info here to go on.
> 
> run xfs_repair -n 
> if it looks like an existing bug add to it
> if not open a new bug and attach repair output to it.
> 
> > Nov 20 13:16:58 box [4299533.469000] 0x0: 00 00 00 00 00 00 00 00 00 00 00 
> > 00 00
> > 00 00 00
> > Nov 20 13:16:58 box [4299533.469000] Filesystem "hda2": XFS internal error
> > xfs_da_do_buf(2) at line 2212 of file fs/xfs/xfs_da_btree.c.  Caller 
> > 0xc01ffcad
> > Nov 20 13:16:58 box [4299533.469000]  <c02126fd>
> > Nov 20 13:16:58 box xfs_corruption_error+0xf2/0x11a
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box  <c01ffcad>
> > Nov 20 13:16:58 box xfs_da_read_buf+0x3b/0x3f
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box [4299533.469000]  <c0241320>
> > Nov 20 13:16:58 box kmem_zone_alloc+0x60/0xdd
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box  <c01ff227>
> > Nov 20 13:16:58 box xfs_da_buf_make+0xf7/0x14c
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box [4299533.469000]  <c01ffbb1>
> > Nov 20 13:16:58 box xfs_da_do_buf+0x935/0x98d
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box  <c01ffcad>
> > Nov 20 13:16:58 box xfs_da_read_buf+0x3b/0x3f
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box [4299533.469000]  <c013dd54>
> > Nov 20 13:16:58 box __alloc_pages+0x53/0x2d6
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box  <c01ffcad>
> > Nov 20 13:16:58 box xfs_da_read_buf+0x3b/0x3f
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box [4299533.469000]  <c0202a79>
> > Nov 20 13:16:58 box xfs_da_node_lookup_int+0xd0/0x399
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box  <c0202a79>
> > Nov 20 13:16:58 box xfs_da_node_lookup_int+0xd0/0x399
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box [4299533.469000]  <c020a921>
> > Nov 20 13:16:58 box xfs_dir2_node_lookup+0x3f/0xb9
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box  <c020549a>
> > Nov 20 13:16:58 box xfs_dir2_lookup+0x137/0x139
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box [4299533.470000]  <c013dd54>
> > Nov 20 13:16:58 box __alloc_pages+0x53/0x2d6
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box  <c0236080>
> > Nov 20 13:16:58 box xfs_dir_lookup_int+0x40/0x125
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box [4299533.470000]  <c023a72f>
> > Nov 20 13:16:58 box xfs_lookup+0x5f/0x88
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box  <c0248d0f>
> > Nov 20 13:16:58 box xfs_vn_lookup+0x4f/0x93
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box [4299533.470000]  <c0164009>
> > Nov 20 13:16:58 box do_lookup+0x12d/0x15f
> > Nov 20 13:16:58 box
> > Nov 20 13:16:58 box  <c0165387>
> > 
> -- 
> Russell Cattelan <cattelan@thebarn.com>
> 
