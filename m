Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 09BC87F58
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 07:49:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DE312304043
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 05:49:47 -0700 (PDT)
Received: from cluster-a.mailcontrol.com (cluster-a.mailcontrol.com
	[85.115.52.190]) by cuda.sgi.com with ESMTP id 6yMRGLsze6o82mcP
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Jun 2015 05:49:41 -0700 (PDT)
From: Johannes Weydt <Johannes.Weydt@EMEA.NEC.COM>
Subject: xfs_metadump
Date: Fri, 12 Jun 2015 12:49:24 +0000
Message-ID: <51AEB2C95D121A4D983B13981120AC65853860@EX10MBX01.EU.NEC.COM>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1437196066420844279=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: "'dwdos@hpce.nec.com'" <dwdos@hpce.nec.com>, Reiter Manuel <manuel.reiter@dwd.de>, =?iso-8859-1?Q?Fr=FChauf_Andreas?= <Andreas.Fruehauf@dwd.de>

--===============1437196066420844279==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_51AEB2C95D121A4D983B13981120AC65853860EX10MBX01EUNECCOM_"

--_000_51AEB2C95D121A4D983B13981120AC65853860EX10MBX01EUNECCOM_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello SGI,

We experienced a I/O error on one of our XFS filesystems, xfs_repair -n adv=
ised to
"Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com<mailto:xfs@oss.sgi.com>."
before it ended with a Segmentation fault.

The metadata is almost 3GB big, how do you recommend to transfer the file?
Do you have an open FTP for us?

Also attached are some console outputs of first investigation attempts.

Log of xfs_repair -n (1st run)
root@daw1:~ # xfs_repair -n /dev/mapper/bindata_roma2-bindata_roma2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
block (93,180061223-180061223) multiply claimed by bno space tree, state - =
1
block (93,180062247-180062247) multiply claimed by bno space tree, state - =
1
block (93,180067744-180067744) multiply claimed by bno space tree, state - =
1
block (93,180068775-180068775) multiply claimed by bno space tree, state - =
1
block (93,180072871-180072871) multiply claimed by bno space tree, state - =
1
block (93,180074983-180074983) multiply claimed by bno space tree, state - =
1
block (93,180075936-180075936) multiply claimed by bno space tree, state - =
1
block (93,180092864-180092864) multiply claimed by bno space tree, state - =
1
block (93,180146905-180146905) multiply claimed by bno space tree, state - =
1
block (93,180256625-180256625) multiply claimed by bno space tree, state - =
1
block (93,131740544-131740544) multiply claimed by cnt space tree, state - =
2
block (93,131740722-131740722) multiply claimed by cnt space tree, state - =
2
block (93,156891590-156891590) multiply claimed by cnt space tree, state - =
2
agf_freeblks 20604555, counted 20607360 in ag 93
sb_icount 858240, counted 856960
sb_ifree 17344, counted 17717
sb_fdblocks 5921605452, counted 5920660936
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 8
        - agno =3D 9
        - agno =3D 10
        - agno =3D 11
        - agno =3D 12
        - agno =3D 13
        - agno =3D 14
        - agno =3D 15
        - agno =3D 16
        - agno =3D 17
        - agno =3D 18
        - agno =3D 19
        - agno =3D 20
        - agno =3D 21
        - agno =3D 22
        - agno =3D 23
imap claims a free inode 99087474454 is in use, would correct imap and clea=
r inode
        - agno =3D 24
        - agno =3D 25
        - agno =3D 26
        - agno =3D 27
        - agno =3D 28
        - agno =3D 29
        - agno =3D 30
        - agno =3D 31
        - agno =3D 32
        - agno =3D 33
        - agno =3D 34
        - agno =3D 35
        - agno =3D 36
        - agno =3D 37
        - agno =3D 38
        - agno =3D 39
        - agno =3D 40
        - agno =3D 41
        - agno =3D 42
        - agno =3D 43
        - agno =3D 44
        - agno =3D 45
        - agno =3D 46
        - agno =3D 47
        - agno =3D 48
        - agno =3D 49
        - agno =3D 50
        - agno =3D 51
        - agno =3D 52
        - agno =3D 53
        - agno =3D 54
        - agno =3D 55
        - agno =3D 56
        - agno =3D 57
        - agno =3D 58
        - agno =3D 59
        - agno =3D 60
        - agno =3D 61
        - agno =3D 62
        - agno =3D 63
        - agno =3D 64
        - agno =3D 65
        - agno =3D 66
        - agno =3D 67
        - agno =3D 68
        - agno =3D 69
        - agno =3D 70
        - agno =3D 71
        - agno =3D 72
        - agno =3D 73
        - agno =3D 74
        - agno =3D 75
        - agno =3D 76
        - agno =3D 77
        - agno =3D 78
        - agno =3D 79
        - agno =3D 80
        - agno =3D 81
        - agno =3D 82
        - agno =3D 83
        - agno =3D 84
        - agno =3D 85
        - agno =3D 86
        - agno =3D 87
        - agno =3D 88
        - agno =3D 89
        - agno =3D 90
        - agno =3D 91
        - agno =3D 92
bad nblocks 6601 for inode 395205468183, would reset to 6602
bad nextents 5825 for inode 395205468183, would reset to 5826
bad back pointer in block 8389120 for directory inode 395205468183
        - agno =3D 93
        - agno =3D 94
        - agno =3D 95
        - agno =3D 96
        - agno =3D 97
        - agno =3D 98
        - agno =3D 99
        - agno =3D 100
        - agno =3D 101
        - agno =3D 102
        - agno =3D 103
        - agno =3D 104
        - agno =3D 105
        - agno =3D 106
        - agno =3D 107
        - agno =3D 108
        - agno =3D 109
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 21
        - agno =3D 36
        - agno =3D 39
        - agno =3D 11
        - agno =3D 48
        - agno =3D 42
        - agno =3D 9
        - agno =3D 45
        - agno =3D 31
        - agno =3D 52
        - agno =3D 65
        - agno =3D 54
        - agno =3D 74
        - agno =3D 43
        - agno =3D 51
        - agno =3D 38
        - agno =3D 63
        - agno =3D 64
        - agno =3D 67
        - agno =3D 50
        - agno =3D 69
        - agno =3D 71
        - agno =3D 46
        - agno =3D 86
        - agno =3D 97
        - agno =3D 57
        - agno =3D 59
        - agno =3D 14
        - agno =3D 60
        - agno =3D 44
        - agno =3D 70
        - agno =3D 10
        - agno =3D 49
        - agno =3D 72
        - agno =3D 12
        - agno =3D 25
        - agno =3D 27
        - agno =3D 13
        - agno =3D 76
        - agno =3D 75
        - agno =3D 77
        - agno =3D 79
        - agno =3D 29
        - agno =3D 83
        - agno =3D 84
        - agno =3D 93
        - agno =3D 87
        - agno =3D 92
        - agno =3D 88
        - agno =3D 90
        - agno =3D 91
        - agno =3D 89
        - agno =3D 56
        - agno =3D 47
        - agno =3D 96
        - agno =3D 95
        - agno =3D 99
        - agno =3D 58
        - agno =3D 104
        - agno =3D 105
        - agno =3D 101
        - agno =3D 107
        - agno =3D 61
        - agno =3D 15
        - agno =3D 62
        - agno =3D 108
        - agno =3D 66
        - agno =3D 68
        - agno =3D 33
        - agno =3D 24
        - agno =3D 26
        - agno =3D 73
        - agno =3D 80
        - agno =3D 100
        - agno =3D 30
        - agno =3D 32
        - agno =3D 17
        - agno =3D 20
        - agno =3D 40
        - agno =3D 23
        - agno =3D 22
        - agno =3D 94
        - agno =3D 28
        - agno =3D 8
        - agno =3D 103
        - agno =3D 16
        - agno =3D 81
        - agno =3D 102
        - agno =3D 85
        - agno =3D 41
        - agno =3D 98
        - agno =3D 82
        - agno =3D 35
        - agno =3D 78
        - agno =3D 106
        - agno =3D 109
        - agno =3D 34
        - agno =3D 53
        - agno =3D 37
        - agno =3D 19
        - agno =3D 55
        - agno =3D 18
bad nblocks 6601 for inode 395205468183, would reset to 6602
bad nextents 5825 for inode 395205468183, would reset to 5826
entry "C3E_MAIN_FC_ROUT_25374.14582" at block 698 offset 1056 in directory =
inode 395205468183 references free inode 395272675342
        would clear inode number in entry at offset 1056...
entry "C3E_MAIN_FC_ROUT_25374.14583" at block 698 offset 1096 in directory =
inode 395205468183 references free inode 395272675343
        would clear inode number in entry at offset 1096...
entry "C3E_MAIN_FC_ROUT_25374.14584" at block 698 offset 1136 in directory =
inode 395205468183 references free inode 395272675344
        would clear inode number in entry at offset 1136...
entry "C3E_MAIN_FC_ROUT_25374.14585" at block 698 offset 1176 in directory =
inode 395205468183 references free inode 395272675345
        would clear inode number in entry at offset 1176...
entry "C3E_MAIN_FC_ROUT_25374.14586" at block 698 offset 1216 in directory =
inode 395205468183 references free inode 395272675346
        would clear inode number in entry at offset 1216...
entry "C3E_MAIN_FC_ROUT_25374.14587" at block 698 offset 1256 in directory =
inode 395205468183 references free inode 395272675347
        would clear inode number in entry at offset 1256...
entry "C3E_MAIN_FC_ROUT_25374.14588" at block 698 offset 1296 in directory =
inode 395205468183 references free inode 395272675348
        would clear inode number in entry at offset 1296...
entry "C3E_MAIN_FC_ROUT_25374.14589" at block 698 offset 1336 in directory =
inode 395205468183 references free inode 395272675349
        would clear inode number in entry at offset 1336...
entry "C3E_MAIN_FC_ROUT_25374.14590" at block 698 offset 1376 in directory =
inode 395205468183 references free inode 395272675350
        would clear inode number in entry at offset 1376...
entry "C3E_MAIN_FC_ROUT_25374.14591" at block 698 offset 1416 in directory =
inode 395205468183 references free inode 395272675351
        would clear inode number in entry at offset 1416...
entry "C3E_MAIN_FC_ROUT_25374.14592" at block 698 offset 1456 in directory =
inode 395205468183 references free inode 395272675352
        would clear inode number in entry at offset 1456...
entry "C3E_MAIN_FC_ROUT_25374.14593" at block 698 offset 1496 in directory =
inode 395205468183 references free inode 395272675353
        would clear inode number in entry at offset 1496...
entry "C3E_MAIN_FC_ROUT_25374.14594" at block 698 offset 1536 in directory =
inode 395205468183 references free inode 395272675354
        would clear inode number in entry at offset 1536...
entry "C3E_MAIN_FC_ROUT_25374.14595" at block 698 offset 1576 in directory =
inode 395205468183 references free inode 395272675355
        would clear inode number in entry at offset 1576...
entry "C3E_MAIN_FC_ROUT_25374.14596" at block 698 offset 1616 in directory =
inode 395205468183 references free inode 395272675356
        would clear inode number in entry at offset 1616...
entry "C3E_MAIN_FC_ROUT_25374.14597" at block 698 offset 1656 in directory =
inode 395205468183 references free inode 395272675357
        would clear inode number in entry at offset 1656...
entry "C3E_MAIN_FC_ROUT_25374.14598" at block 698 offset 1696 in directory =
inode 395205468183 references free inode 395272675358
        would clear inode number in entry at offset 1696...
entry "C3E_MAIN_FC_ROUT_25374.14599" at block 698 offset 1736 in directory =
inode 395205468183 references free inode 395272675359
        would clear inode number in entry at offset 1736...
entry "C3E_MAIN_FC_ROUT_25374.14600" at block 698 offset 1776 in directory =
inode 395205468183 references free inode 395272675360
        would clear inode number in entry at offset 1776...
entry "C3E_MAIN_FC_ROUT_25374.14601" at block 698 offset 1816 in directory =
inode 395205468183 references free inode 395272675361
        would clear inode number in entry at offset 1816...
entry "C3E_MAIN_FC_ROUT_25374.14602" at block 698 offset 1856 in directory =
inode 395205468183 references free inode 395272675362
        would clear inode number in entry at offset 1856...
entry "C3E_MAIN_FC_ROUT_25374.14603" at block 698 offset 1896 in directory =
inode 395205468183 references free inode 395272675363
        would clear inode number in entry at offset 1896...
entry "C3E_MAIN_FC_ROUT_25374.14604" at block 698 offset 1936 in directory =
inode 395205468183 references free inode 395272675364
        would clear inode number in entry at offset 1936...
entry "C3E_MAIN_FC_ROUT_25374.14605" at block 698 offset 1976 in directory =
inode 395205468183 references free inode 395272675365
        would clear inode number in entry at offset 1976...
entry "C3E_MAIN_FC_ROUT_25374.14606" at block 698 offset 2016 in directory =
inode 395205468183 references free inode 395272675366
        would clear inode number in entry at offset 2016...
entry "C3E_MAIN_FC_ROUT_25374.14607" at block 698 offset 2056 in directory =
inode 395205468183 references free inode 395272675367
        would clear inode number in entry at offset 2056...
entry "C3E_MAIN_FC_ROUT_25374.14608" at block 698 offset 2096 in directory =
inode 395205468183 references free inode 395272675368
        would clear inode number in entry at offset 2096...
entry "C3E_MAIN_FC_ROUT_25374.14609" at block 698 offset 2136 in directory =
inode 395205468183 references free inode 395272675369
        would clear inode number in entry at offset 2136...
entry "C3E_MAIN_FC_ROUT_25374.14610" at block 698 offset 2176 in directory =
inode 395205468183 references free inode 395272675370
        would clear inode number in entry at offset 2176...
entry "C3E_MAIN_FC_ROUT_25374.14612" at block 698 offset 2216 in directory =
inode 395205468183 references free inode 395272675371
        would clear inode number in entry at offset 2216...
entry "C3E_MAIN_FC_ROUT_25374.14611" at block 698 offset 2256 in directory =
inode 395205468183 references free inode 395272675372
        would clear inode number in entry at offset 2256...
entry "C3E_MAIN_FC_ROUT_25374.14613" at block 698 offset 2296 in directory =
inode 395205468183 references free inode 395272675373
        would clear inode number in entry at offset 2296...
entry "C3E_MAIN_FC_ROUT_25374.14614" at block 698 offset 2336 in directory =
inode 395205468183 references free inode 395272675374
        would clear inode number in entry at offset 2336...
entry "C3E_MAIN_FC_ROUT_25374.14615" at block 698 offset 2376 in directory =
inode 395205468183 references free inode 395272675375
        would clear inode number in entry at offset 2376...
entry "C3E_MAIN_FC_ROUT_25374.14616" at block 698 offset 2416 in directory =
inode 395205468183 references free inode 395272675376
        would clear inode number in entry at offset 2416...
entry "C3E_MAIN_FC_ROUT_25374.14617" at block 698 offset 2456 in directory =
inode 395205468183 references free inode 395272675377
        would clear inode number in entry at offset 2456...
entry "C3E_MAIN_FC_ROUT_26054.8978" at block 2124 offset 416 in directory i=
node 98814672640 references free inode 99087474454
        would clear inode number in entry at offset 416...
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "C3E_MAIN_FC_ROUT_26054.8978" in directory inode 98814672640 points t=
o free inode 99087474454, would junk entry
corrupt dinode 395205468183, (btree extents).  This is a bug.
Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com.
corrupt dinode 395205468183, (btree extents).  This is a bug.
Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com.
corrupt dinode 395205468183, (btree extents).  This is a bug.
Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com.
Segmentation fault (core dumped)
root@daw1:~ #

Log of xfs_repair -n (2nd run)
root@daw1:~ # xfs_repair -n /dev/mapper/bindata_roma2-bindata_roma2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 8
        - agno =3D 9
        - agno =3D 10
        - agno =3D 11
        - agno =3D 12
        - agno =3D 13
        - agno =3D 14
        - agno =3D 15
        - agno =3D 16
        - agno =3D 17
        - agno =3D 18
        - agno =3D 19
        - agno =3D 20
        - agno =3D 21
        - agno =3D 22
        - agno =3D 23
        - agno =3D 24
        - agno =3D 25
        - agno =3D 26
        - agno =3D 27
        - agno =3D 28
        - agno =3D 29
        - agno =3D 30
        - agno =3D 31
        - agno =3D 32
        - agno =3D 33
        - agno =3D 34
        - agno =3D 35
        - agno =3D 36
        - agno =3D 37
        - agno =3D 38
        - agno =3D 39
        - agno =3D 40
        - agno =3D 41
        - agno =3D 42
        - agno =3D 43
        - agno =3D 44
        - agno =3D 45
        - agno =3D 46
        - agno =3D 47
        - agno =3D 48
        - agno =3D 49
        - agno =3D 50
        - agno =3D 51
        - agno =3D 52
        - agno =3D 53
        - agno =3D 54
        - agno =3D 55
        - agno =3D 56
        - agno =3D 57
        - agno =3D 58
        - agno =3D 59
        - agno =3D 60
        - agno =3D 61
        - agno =3D 62
        - agno =3D 63
        - agno =3D 64
        - agno =3D 65
        - agno =3D 66
        - agno =3D 67
        - agno =3D 68
        - agno =3D 69
        - agno =3D 70
        - agno =3D 71
        - agno =3D 72
        - agno =3D 73
        - agno =3D 74
        - agno =3D 75
        - agno =3D 76
        - agno =3D 77
        - agno =3D 78
        - agno =3D 79
        - agno =3D 80
        - agno =3D 81
        - agno =3D 82
        - agno =3D 83
        - agno =3D 84
        - agno =3D 85
        - agno =3D 86
        - agno =3D 87
        - agno =3D 88
        - agno =3D 89
        - agno =3D 90
        - agno =3D 91
        - agno =3D 92
entry count 592 too large in block 8389120 for directory inode 395205468183
        - agno =3D 93
        - agno =3D 94
        - agno =3D 95
        - agno =3D 96
        - agno =3D 97
        - agno =3D 98
        - agno =3D 99
        - agno =3D 100
        - agno =3D 101
        - agno =3D 102
        - agno =3D 103
        - agno =3D 104
        - agno =3D 105
        - agno =3D 106
        - agno =3D 107
        - agno =3D 108
        - agno =3D 109
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 30
        - agno =3D 67
        - agno =3D 72
        - agno =3D 77
        - agno =3D 84
        - agno =3D 7
        - agno =3D 75
        - agno =3D 40
        - agno =3D 17
        - agno =3D 29
        - agno =3D 78
        - agno =3D 28
        - agno =3D 55
        - agno =3D 81
        - agno =3D 57
        - agno =3D 82
        - agno =3D 80
        - agno =3D 58
        - agno =3D 83
        - agno =3D 85
        - agno =3D 16
        - agno =3D 88
        - agno =3D 100
        - agno =3D 103
        - agno =3D 102
        - agno =3D 107
        - agno =3D 108
        - agno =3D 62
        - agno =3D 10
        - agno =3D 32
        - agno =3D 34
        - agno =3D 26
        - agno =3D 71
        - agno =3D 73
        - agno =3D 50
        - agno =3D 59
        - agno =3D 38
        - agno =3D 86
        - agno =3D 8
        - agno =3D 36
        - agno =3D 60
        - agno =3D 61
        - agno =3D 45
        - agno =3D 94
        - agno =3D 49
        - agno =3D 18
        - agno =3D 39
        - agno =3D 9
        - agno =3D 22
        - agno =3D 97
        - agno =3D 98
        - agno =3D 11
        - agno =3D 90
        - agno =3D 24
        - agno =3D 99
        - agno =3D 19
        - agno =3D 12
        - agno =3D 63
        - agno =3D 64
        - agno =3D 15
        - agno =3D 65
        - agno =3D 66
        - agno =3D 68
        - agno =3D 69
        - agno =3D 51
        - agno =3D 70
        - agno =3D 74
        - agno =3D 54
        - agno =3D 87
        - agno =3D 89
        - agno =3D 42
        - agno =3D 91
        - agno =3D 43
        - agno =3D 92
        - agno =3D 93
        - agno =3D 25
        - agno =3D 20
        - agno =3D 52
        - agno =3D 13
        - agno =3D 95
        - agno =3D 53
        - agno =3D 41
        - agno =3D 96
        - agno =3D 21
        - agno =3D 101
        - agno =3D 46
        - agno =3D 56
        - agno =3D 104
        - agno =3D 31
        - agno =3D 109
        - agno =3D 76
        - agno =3D 37
        - agno =3D 44
        - agno =3D 23
        - agno =3D 105
        - agno =3D 33
        - agno =3D 106
        - agno =3D 35
        - agno =3D 14
        - agno =3D 47
        - agno =3D 27
        - agno =3D 79
        - agno =3D 48
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

Between the two xfsrepairs we mounted, checked for the files and unmounted =
the filesystem again.
The check resulted in a lot of
ls: cannot access 5/C3E_MAIN_FC_ROUT_25374.14618: Structure needs cleaning

xfsprogs is installed in version:
root@daw1:/localtmp # rpm -qa |grep xfsprogs
xfsprogs-3.1.1-10.el6.x86_64

Can you advise something?

Best regards / Mit freundlichen Gr=FC=DFen

Johannes Weydt
System Analyst, HPCE Division
Telefon: 069-8062-2376
Mobile:  01522-2851526
Fax:         069-8062-3267


NEC Deutschland GmbH, Prinzenallee 11,  D-40549 Duesseldorf, Germany
Gesch=E4ftsf=FChrer: Michael St=FCckmann     Handelsregister D=FCsseldorf H=
RB 579413



--_000_51AEB2C95D121A4D983B13981120AC65853860EX10MBX01EUNECCOM_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Consolas;
	panose-1:2 11 6 9 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hello SGI,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">We experienced a I/O error on one of our XFS filesys=
tems, xfs_repair &#8211;n advised to
<o:p></o:p></p>
<p class=3D"MsoNormal">&#8220;Please capture the filesystem metadata with x=
fs_metadump and<o:p></o:p></p>
<p class=3D"MsoNormal">report it to <a href=3D"mailto:xfs@oss.sgi.com">xfs@=
oss.sgi.com</a>.&#8221;
<o:p></o:p></p>
<p class=3D"MsoNormal">before it ended with a Segmentation fault.<o:p></o:p=
></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">The metadata is almost 3GB big, how do you recommend=
 to transfer the file?<o:p></o:p></p>
<p class=3D"MsoNormal">Do you have an open FTP for us?<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Also attached are some console outputs of first inve=
stigation attempts.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Log of xfs_repair &#8211;n (1<sup>st</sup> run)<o:p>=
</o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>root@daw1:~ # xfs_repair -n /dev/mapper/bindata_roma2-bindata_roma2<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>Phase 1 - find and verify superblock...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>Phase 2 - using internal log<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - scan filesystem freespace and=
 inode maps...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>block (93,180061223-180061223) multiply claimed by bno space tree, state -=
 1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>block (93,180062247-180062247) multiply claimed by bno space tree, state -=
 1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>block (93,180067744-180067744) multiply claimed by bno space tree, state -=
 1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>block (93,180068775-180068775) multiply claimed by bno space tree, state -=
 1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>block (93,180072871-180072871) multiply claimed by bno space tree, state -=
 1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>block (93,180074983-180074983) multiply claimed by bno space tree, state -=
 1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>block (93,180075936-180075936) multiply claimed by bno space tree, state -=
 1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>block (93,180092864-180092864) multiply claimed by bno space tree, state -=
 1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>block (93,180146905-180146905) multiply claimed by bno space tree, state -=
 1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>block (93,180256625-180256625) multiply claimed by bno space tree, state -=
 1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>block (93,131740544-131740544) multiply claimed by cnt space tree, state -=
 2<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>block (93,131740722-131740722) multiply claimed by cnt space tree, state -=
 2<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>block (93,156891590-156891590) multiply claimed by cnt space tree, state -=
 2<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>agf_freeblks 20604555, counted 20607360 in ag 93<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>sb_icount 858240, counted 856960<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>sb_ifree 17344, counted 17717<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>sb_fdblocks 5921605452, counted 5920660936<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - found root inode chunk<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>Phase 3 - for each AG...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - scan (but don't clear) agi un=
linked lists...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - process known inodes and perf=
orm inode discovery...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 0<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 1<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 2<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 3<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 4<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 5<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 6<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 7<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 8<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 9<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 10<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 11<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 12<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 13<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 14<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 15<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 16<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 17<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 18<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 19<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 20<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 21<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 22<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 23<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>imap claims a free inode 99087474454 is in use, would correct imap and cle=
ar inode<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 24<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 25<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 26<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 27<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 28<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 29<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 30<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 31<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 32<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 33<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 34<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 35<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 36<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 37<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 38<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 39<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 40<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 41<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 42<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 43<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 44<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 45<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 46<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 47<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 48<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 49<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 50<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 51<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 52<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 53<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 54<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 55<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 56<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 57<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 58<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 59<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 60<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 61<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 62<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 63<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 64<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 65<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 66<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 67<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 68<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 69<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 70<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 71<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 72<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 73<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 74<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 75<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 76<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 77<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 78<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 79<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 80<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 81<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 82<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 83<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 84<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 85<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 86<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 87<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 88<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 89<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 90<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 91<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 92<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>bad nblocks 6601 for inode 395205468183, would reset to 6602<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>bad nextents 5825 for inode 395205468183, would reset to 5826<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>bad back pointer in block 8389120 for directory inode 395205468183<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 93<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 94<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 95<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;- agno =3D 96<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 97<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 98<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 99<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 100<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 101<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 102<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 103<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 104<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 105<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 106<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 107<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 108<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 109<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - process newly discovered inod=
es...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>Phase 4 - check for duplicate blocks...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - setting up duplicate extent l=
ist...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - check for inodes claiming dup=
licate blocks...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 0<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 1<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 2<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 3<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 4<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 5<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 6<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 7<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 21<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 36<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 39<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 11<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 48<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 42<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 9<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- agno =3D 45<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 31<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 52<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 65<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 54<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 74<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 43<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 51<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 38<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 63<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 64<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 67<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 50<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 69<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 71<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 46<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 86<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 97<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 57<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 59<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 14<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 60<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 44<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 70<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 10<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 49<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 72<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 12<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 25<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 27<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 13<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 76<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 75<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 77<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 79<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 29<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 83<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 84<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 93<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 87<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 92<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 88<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 90<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 91<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 89<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 56<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 47<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 96<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 95<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 99<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 58<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 104<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 105<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 101<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 107<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 61<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 15<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 62<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 108<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 66<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 68<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 33<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 24<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 26<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 73<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 80<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 100<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 30<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 32<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 17<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 20<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 40<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 23<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 22<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 94<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 28<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 8<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 103<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 16<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 81<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 102<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 85<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 41<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 98<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 82<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 35<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 78<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 106<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 109<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 34<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 53<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 37<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 19<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 55<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 18<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>bad nblocks 6601 for inode 395205468183, would reset to 6602<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>bad nextents 5825 for inode 395205468183, would reset to 5826<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14582&quot; at block 698 offset 1056 in=
 directory inode 395205468183 references free inode 395272675342<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1056...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14583&quot; at block 698 offset 1096 in=
 directory inode 395205468183 references free inode 395272675343<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1096...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14584&quot; at block 698 offset 1136 in=
 directory inode 395205468183 references free inode 395272675344<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1136...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14585&quot; at block 698 offset 1176 in=
 directory inode 395205468183 references free inode 395272675345<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1176...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14586&quot; at block 698 offset 1216 in=
 directory inode 395205468183 references free inode 395272675346<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1216...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14587&quot; at block 698 offset 1256 in=
 directory inode 395205468183 references free inode 395272675347<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1256...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14588&quot; at block 698 offset 1296 in=
 directory inode 395205468183 references free inode 395272675348<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1296...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14589&quot; at block 698 offset 1336 in=
 directory inode 395205468183 references free inode 395272675349<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1336...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14590&quot; at block 698 offset 1376 in=
 directory inode 395205468183 references free inode 395272675350<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1376...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14591&quot; at block 698 offset 1416 in=
 directory inode 395205468183 references free inode 395272675351<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1416...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14592&quot; at block 698 offset 1456 in=
 directory inode 395205468183 references free inode 395272675352<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1456...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14593&quot; at block 698 offset 1496 in=
 directory inode 395205468183 references free inode 395272675353<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1496...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14594&quot; at block 698 offset 1536 in=
 directory inode 395205468183 references free inode 395272675354<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1536...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14595&quot; at block 698 offset 1576 in=
 directory inode 395205468183 references free inode 395272675355<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1576...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14596&quot; at block 698 offset 1616 in=
 directory inode 395205468183 references free inode 395272675356<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1616...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14597&quot; at block 698 offset 1656 in=
 directory inode 395205468183 references free inode 395272675357<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1656...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14598&quot; at block 698 offset 1696 in=
 directory inode 395205468183 references free inode 395272675358<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1696...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14599&quot; at block 698 offset 1736 in=
 directory inode 395205468183 references free inode 395272675359<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1736...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14600&quot; at block 698 offset 1776 in=
 directory inode 395205468183 references free inode 395272675360<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1776...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14601&quot; at block 698 offset 1816 in=
 directory inode 395205468183 references free inode 395272675361<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;would clear inode number in ent=
ry at offset 1816...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14602&quot; at block 698 offset 1856 in=
 directory inode 395205468183 references free inode 395272675362<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1856...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14603&quot; at block 698 offset 1896 in=
 directory inode 395205468183 references free inode 395272675363<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1896...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14604&quot; at block 698 offset 1936 in=
 directory inode 395205468183 references free inode 395272675364<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1936...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14605&quot; at block 698 offset 1976 in=
 directory inode 395205468183 references free inode 395272675365<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 1976...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14606&quot; at block 698 offset 2016 in=
 directory inode 395205468183 references free inode 395272675366<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 2016...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14607&quot; at block 698 offset 2056 in=
 directory inode 395205468183 references free inode 395272675367<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 2056...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14608&quot; at block 698 offset 2096 in=
 directory inode 395205468183 references free inode 395272675368<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 2096...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14609&quot; at block 698 offset 2136 in=
 directory inode 395205468183 references free inode 395272675369<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 2136...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14610&quot; at block 698 offset 2176 in=
 directory inode 395205468183 references free inode 395272675370<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 2176...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14612&quot; at block 698 offset 2216 in=
 directory inode 395205468183 references free inode 395272675371<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 2216...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14611&quot; at block 698 offset 2256 in=
 directory inode 395205468183 references free inode 395272675372<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 2256...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14613&quot; at block 698 offset 2296 in=
 directory inode 395205468183 references free inode 395272675373<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 2296...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14614&quot; at block 698 offset 2336 in=
 directory inode 395205468183 references free inode 395272675374<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 2336...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14615&quot; at block 698 offset 2376 in=
 directory inode 395205468183 references free inode 395272675375<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 2376...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14616&quot; at block 698 offset 2416 in=
 directory inode 395205468183 references free inode 395272675376<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 2416...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_25374.14617&quot; at block 698 offset 2456 in=
 directory inode 395205468183 references free inode 395272675377<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 2456...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_26054.8978&quot; at block 2124 offset 416 in =
directory inode 98814672640 references free inode 99087474454<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear inode number in ent=
ry at offset 416...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>No modify flag set, skipping phase 5<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>Phase 6 - check inode connectivity...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - traversing filesystem ...<o:p=
></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry &quot;C3E_MAIN_FC_ROUT_26054.8978&quot; in directory inode 988146726=
40 points to free inode 99087474454, would junk entry<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>corrupt dinode 395205468183, (btree extents).&nbsp; This is a bug.<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>Please capture the filesystem metadata with xfs_metadump and<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>report it to xfs@oss.sgi.com.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>corrupt dinode 395205468183, (btree extents).&nbsp; This is a bug.<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>Please capture the filesystem metadata with xfs_metadump and<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>report it to xfs@oss.sgi.com.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>corrupt dinode 395205468183, (btree extents).&nbsp; This is a bug.<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>Please capture the filesystem metadata with xfs_metadump and<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>report it to xfs@oss.sgi.com.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>Segmentation fault (core dumped)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>root@daw1:~ #</span><o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Log of xfs_repair &#8211;n (2<sup>nd</sup> run)<o:p>=
</o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>root@daw1:~ # xfs_repair -n /dev/mapper/bindata_roma2-bindata_roma2<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>Phase 1 - find and verify superblock...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>Phase 2 - using internal log<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - scan filesystem freespace and=
 inode maps...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - found root inode chunk<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>Phase 3 - for each AG...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - scan (but don't clear) agi un=
linked lists...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - process known inodes and perf=
orm inode discovery...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 0<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 1<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 2<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 3<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 4<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 5<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 6<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 7<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 8<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 9<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;- agno =3D 10<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 11<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 12<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 13<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 14<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 15<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 16<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 17<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 18<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 19<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 20<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 21<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 22<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 23<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 24<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 25<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 26<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 27<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 28<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 29<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 30<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 31<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 32<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 33<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 34<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 35<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 36<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 37<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 38<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 39<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 40<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 41<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 42<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 43<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 44<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 45<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 46<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 47<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 48<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 49<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 50<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 51<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 52<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 53<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 54<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 55<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 56<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 57<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 58<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 59<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 60<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 61<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 62<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 63<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 64<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 65<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 66<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 67<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 68<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 69<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 70<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 71<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 72<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 73<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 74<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 75<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 76<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 77<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 78<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 79<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 80<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 81<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 82<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 83<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 84<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 85<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 86<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 87<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 88<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 89<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 90<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 91<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 92<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>entry count 592 too large in block 8389120 for directory inode 39520546818=
3<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 93<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 94<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 95<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 96<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 97<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 98<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 99<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 100<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 101<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 102<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 103<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 104<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 105<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 106<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 107<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 108<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 109<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - process newly discovered inod=
es...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>Phase 4 - check for duplicate blocks...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - setting up duplicate extent l=
ist...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - check for inodes claiming dup=
licate blocks...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 0<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 1<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 2<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 3<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 4<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 5<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 6<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 30<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 67<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 72<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;- agno =3D 77<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 84<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 7<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 75<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 40<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 17<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 29<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 78<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 28<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 55<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 81<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 57<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 82<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;- agno =3D 80<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 58<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 83<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 85<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 16<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 88<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 100<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 103<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 102<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 107<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 108<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 62<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 10<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 32<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 34<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 26<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 71<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 73<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 50<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 59<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 38<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 86<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 8<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 36<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 60<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 61<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 45<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 94<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 49<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 18<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 39<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 9<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 22<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 97<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 98<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 11<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 90<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 24<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 99<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 19<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 12<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 63<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 64<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 15<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 65<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 66<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 68<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 69<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 51<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 70<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 74<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 54<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 87<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 89<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 42<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 91<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 43<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 92<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 93<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 25<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 20<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 52<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 13<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 95<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 53<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 41<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 96<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 21<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 101<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 46<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 56<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 104<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 31<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 109<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 76<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 37<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 44<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 23<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 105<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 33<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 106<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 35<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 14<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 47<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 27<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 79<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 48<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>No modify flag set, skipping phase 5<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>Phase 6 - check inode connectivity...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - traversing filesystem ...<o:p=
></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - traversal finished ...<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - moving disconnected inodes to=
 lost&#43;found ...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>Phase 7 - verify link counts...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;font-family:Consolas"=
>No modify flag set, skipping filesystem flush and exiting.<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Between the two xfsrepairs we mounted, checked for t=
he files and unmounted the filesystem again.<o:p></o:p></p>
<p class=3D"MsoNormal">The check resulted in a lot of<o:p></o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:Consolas=
">ls: cannot access 5/C3E_MAIN_FC_ROUT_25374.14618: Structure needs cleanin=
g<o:p></o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">xfsprogs is installed in version:<o:p></o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:Consolas=
">root@daw1:/localtmp # rpm -qa |grep xfsprogs<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:Consolas=
">xfsprogs-3.1.1-10.el6.x86_64<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:Consolas=
"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal">Can you advise something?<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><span lang=3D"DE">Best regards / Mit freundlichen Gr=
=FC=DFen<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"DE"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"DE">Johannes Weydt<o:p></o:p></span></=
p>
<p class=3D"MsoNormal"><span lang=3D"DE">System Analyst, HPCE Division<o:p>=
</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"DE">Telefon: 069-8062-2376<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span lang=3D"DE">Mobile:&nbsp; 01522-2851526<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"DE">Fax:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; 069-8062-3267<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"DE"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"DE"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"DE">NEC Deutschland GmbH, Prinzenallee=
 11,&nbsp; D-40549 Duesseldorf, Germany<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"DE">Gesch=E4ftsf=FChrer: Michael St=FC=
ckmann&nbsp;&nbsp;&nbsp;&nbsp; Handelsregister D=FCsseldorf HRB 579413<o:p>=
</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"DE"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"DE"><o:p>&nbsp;</o:p></span></p>
</div>
</body>
</html>

--_000_51AEB2C95D121A4D983B13981120AC65853860EX10MBX01EUNECCOM_--


--===============1437196066420844279==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1437196066420844279==--
