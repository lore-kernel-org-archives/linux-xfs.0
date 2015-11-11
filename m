Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DFF9F7F8B
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:23:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47BB3AC001
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:23:19 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id mWHzVD2w8puBaAs6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:23:16 -0800 (PST)
Subject: [PATCH 05/21] xfsdocs: convert images to text
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:22:51 -0800
Message-ID: <20151111192250.14235.57607.stgit@birch.djwong.org>
In-Reply-To: <20151111192218.14235.13928.stgit@birch.djwong.org>
References: <20151111192218.14235.13928.stgit@birch.djwong.org>
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
To: hch@infradead.org, david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Convert images that are purely screenshots of xfs_db sessions to text,
to reduce the document size and format better.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../XFS_Filesystem_Structure/data_extents.asciidoc |   37 ++++-
 .../XFS_Filesystem_Structure/directories.asciidoc  |   65 +++++++-
 .../extended_attributes.asciidoc                   |  161 ++++++++++++++++++--
 .../symbolic_links.asciidoc                        |   15 ++
 4 files changed, 251 insertions(+), 27 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/data_extents.asciidoc b/design/XFS_Filesystem_Structure/data_extents.asciidoc
index d7f51e4..b71bc52 100644
--- a/design/XFS_Filesystem_Structure/data_extents.asciidoc
+++ b/design/XFS_Filesystem_Structure/data_extents.asciidoc
@@ -132,14 +132,43 @@ u.bmx[0-2] = [startoff,startblock,blockcount,extentflag]
 Raw disk version of the inode with the third extent highlighted (+di_u+ always
 starts at offset 0x64):
 
-.Raw inode contents with extents
-image::images/code/33a.png[]
+[subs="quotes"]
+----
+xfs_db> type text
+xfs_db> p
+00: 49 4e 81 a4 01 02 00 01 00 00 00 00 00 00 00 00 IN..............
+10: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 01 ................
+20: 44 b6 88 dd 2f 8a ed d0 44 b6 88 f7 10 8c 5b de D.......D.......
+30: 44 b6 88 f7 10 8c 5b d0 00 00 00 00 01 7b b0 00 D...............
+40: 00 00 00 00 00 00 17 bb 00 00 00 00 00 00 00 03 ................
+50: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 ................
+60: ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 0d ................
+70: 5e a0 07 e9 00 00 00 00 00 0f d2 00 00 00 00 0f ................
+80: 58 e0 07 e9 *00 00 00 00 00 1f a4 00 00 00 00 11 X...............
+90: 53 20 07 e9* 00 00 00 00 00 00 00 00 00 00 00 00 S...............
+a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+be: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+co: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+do: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+fo: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+----
 
 We can expand the highlighted section into the following bit array from MSB to
 LSB with the file offset and the block count highlighted:
 
-.Encoded extent
-image::images/code/33b.png[]
+[subs="quotes"]
+----
+127-96:  0**000 0000 0000 0000  0000 0000 0000 0000**
+ 95-64:  **0000 0000 0001 1111  1010 010**0 0000 0000
+ 63-32:  0000 0000 0000 0000  0000 0000 0000 1111
+ 31-0 :  0101 1000 111**0 0000  0000 0111 1110 1001**
+
+Grouping by highlights we get:
+   file offset = 0x0fd2 (4050)
+   start block = 0x7ac7 (31431)
+   block count = 0x07e9 (2025)
+----
 
 A 4MB file with two extents and a hole in the middle, the first extent
 containing 64KB of data, the second about 4MB in containing 32KB (+write+ 64KB,
diff --git a/design/XFS_Filesystem_Structure/directories.asciidoc b/design/XFS_Filesystem_Structure/directories.asciidoc
index 76d5df7..beabe20 100644
--- a/design/XFS_Filesystem_Structure/directories.asciidoc
+++ b/design/XFS_Filesystem_Structure/directories.asciidoc
@@ -149,8 +149,24 @@ u.sfdir2.list[3].inumber.i4 = 25165956
 The raw data on disk with the first entry highlighted. The six byte header
 precedes the first entry:
 
-.Shortform Directory entry detail
-image::images/code/40.png[]
+[subs="quotes"]
+----
+xfs_db> type text
+xfs_db> p
+00: 49 4e 41 ed 01 01 00 02 00 00 00 00 00 00 00 00 INA.............
+10: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 02 ................
+20: 44 ad 3a 83 1d a9 4a d0 44 ad 3a ab 0b c7 a7 d0 D.....J.D.......
+30: 44 ad 3a ab 0b c7 a7 d0 00 00 00 00 00 00 00 5e D...............
+40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+50: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 ................
+60: ff ff ff ff 04 00 00 00 00 80 *0f 00 30 66 72 61* ............0fra
+70: *6d 65 30 30 30 30 30 30 2e 74 73 74 01 80 00 81* me000000.tst....
+80: 0f 00 50 66 72 61 6d 65 30 30 30 30 30 31 2e 74 ..Pframe000001.t
+90: 73 74 01 80 00 82 0f 00 70 66 72 61 6d 65 30 30 st......pframe00
+a0: 30 30 30 32 2e 74 73 74 01 80 00 83 0f 00 90 66 0002.tst........
+b0: 72 61 6d 65 30 30 30 30 30 33 2e 74 73 74 01 80 rame000003.tst..
+cO: 00 84 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+----
 
 Next, an entry is deleted (frame000001.tst), and any entries after the deleted
 entry are moved or compacted to "cover" the hole:
@@ -479,8 +495,21 @@ and the length of the space. The tag remains intact at the +offset+length -
 sizeof(tag)+. The address for the hash is also cleared. The affected areas are
 highlighted below:
 
-.Block directory free entry detail
-image::images/code/46.png[]
+[subs="quotes"]
+----
+090: 00 00 00 00 02 00 00 84 0f 66 72 61 6d 65 30 30 ..........frame00
+0a0: 30 30 30 33 2e 74 73 74 00 00 00 00 00 00 00 90 0003.tst.........
+0b0: *ff ff 00 20* 02 00 00 85 0f 66 72 61 6d 65 30 30 ..........frame00
+0c0: 30 30 30 34 2e 74 73 74 00 00 00 00 *00 00 00 b0* 0004.tst.........
+0d0: 00 00 00 00 02 00 00 86 0f 66 72 61 6d 65 30 30 ..........frame00
+0e0: 30 30 30 35 2e 74 73 74 00 00 00 00 00 00 00 0d 0005.tst.........
+...
+fb0: 00 00 17 2e 00 00 00 04 83 a0 40 b4 00 00 00 0e .................
+fc0: 93 a0 40 b4 00 00 00 12 a3 a0 40 b4 00 00 00 06 .................
+fd0: b3 a0 40 b4 00 00 00 0a c3 a0 40 b4 00 00 00 1e .................
+fe0: d3 a0 40 b4 00 00 00 22 e3 a0 40 b4 *00 00 00 00* .................
+ff0: f3 a0 40 b4 00 00 00 1a 00 00 00 0a *00 00 00 01* .................
+----
 
 
 
@@ -1049,8 +1078,13 @@ block's +bestfree[0].length+ value.
 The raw disk layout, old data is not cleared after the array. The fbests array
 is highlighted:
 
-.Node directory freespace detail
-image::images/code/57.png[]
+[subs="quotes"]
+----
+xfs_db> type text
+xfs_db> p
+000: 58 44 32 46 00 00 00 00 00 00 00 05 00 00 00 05 XD2F............
+010: *00 10 00 10 00 10 00 10 3f 50* 00 00 1f 01 ff ff .........P......
+----
 
 TODO: Example with a hole in the middle
 
@@ -1188,6 +1222,21 @@ The leaves at each the end of a node always point to the end leaves in adjacent
 nodes. Directory block 8388928 forward pointer is to block 8388919, and vice
 versa as highlighted in the following example:
 
-.B+tree directory pointer detail
-image::images/code/60.png[]
+[subs="quotes"]
+----
+xfs_db> dblock 8388928
+xfs_db> type dir2
+xfs_db> p
+lhdr.info.forw = *8388919*
+lhdr.info.back = 8388937
+lhdr.info.magic = 0xd2ff
+...
 
+xfs_db> dblock 8388919
+xfs_db> type dir2
+xfs_db> p
+lhdr.info.forw = 8388706
+lhdr.info.back = *8388928*
+lhdr.info.magic = 0xd2ff
+...
+----
diff --git a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
index 8b32bdf..51f7ff7 100644
--- a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
+++ b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
@@ -128,8 +128,27 @@ a.sfattr.list[1].value = "val1"
 We can determine the actual inode offset to be 220 (15 x 8 + 100) or +0xdc+.
 Examining the raw dump, the second attribute is highlighted:
 
-.Shortform Attribute detail
-image::images/code/65.png[]
+[subs="quotes"]
+----
+xfs_db> type text
+xfs_db> p
+09: 49 4e 81 a4 01 02 00 01 00 00 00 00 00 00 00 00 IN..............
+10: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 02 ................
+20: 44 be 19 be 38 d1 26 98 44 be 1a be 38 d1 26 98 D...8...D...8...
+30: 44 be 1a e1 3a 9a ea 18 00 00 00 00 00 00 00 04 D...............
+40: 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 01 ................
+50: 00 00 0f 01 00 00 00 00 00 00 00 00 00 00 00 00 ................
+60: ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 12 ................
+70: 53 a0 00 01 00 00 00 00 00 00 00 00 00 00 00 00 ................
+80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+d0: 00 00 00 00 00 00 00 00 00 00 00 00 *00 18* 02 00 ................   &lt;-- hdr.totsize = 0x18
+e0: 05 00 00 65 6d 70 74 79 *05 04 02 74 72 75 73 74* ...empty...trust
+f0: *76 61 6c 31* 00 00 00 00 00 00 00 00 00 00 00 00 val1............
+----
 
 Adding another attribute with attr1, the format is converted to extents and
 +di_forkoff+ remains unchanged (and all those zeros in the dump above remain
@@ -192,8 +211,34 @@ a.sfattr.list[1].value = "val1"
 
 Another attribute is added:
 
-.Shortform Multiple Attribute detail
-image::images/code/66.png[]
+[subs="quotes"]
+----
+xfs_db> p
+...
+core.naextents = 0
+*core.forkoff = 13*
+core.aformat = 1 (local)
+...
+a.sfattr.hdr.totsize = 52
+a.sfattr.hdr.count = 3
+a.sfattr.list[0].namelen = 10
+a.sfattr.list[0].valuelen = 0
+a.sfattr.list[0].root = 0
+a.sfattr.list[0].secure = 0
+a.sfattr.list[0].name = "empty_attr"
+a.sfattr.list[1].namelen = 7
+a.sfattr.list[1].valuelen = 4
+a.sfattr.list[1].root = 1
+a.sfattr.list[1].secure = 0
+a.sfattr.list[1].name = "trust_a"
+a.sfattr.list[1].value = "val1"
+a.sfattr.list[2].namelen = 6
+a.sfattr.list[2].valuelen = 12
+a.sfattr.list[2].root = 0
+a.sfattr.list[2].secure = 0
+a.sfattr.list[2].name = "second"
+a.sfattr.list[2].value = "second_value"
+----
 
 One more is added:
 
@@ -233,8 +278,27 @@ a.sfattr.list[3].value = "contents"
 A raw dump is shown to compare with the attr1 dump on a prior page, the header
 is highlighted:
 
-.Shortform attribute header detail
-image::images/code/67.png[]
+[subs="quotes"]
+----
+xfs_db> type text
+xfs_db> p
+00: 49 4e 81 a4 01 02 00 01 00 00 00 00 00 00 00 00 IN..............
+10: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 05 ................
+20: 44 be 24 cd 0f b0 96 18 44 be 24 cd 0f b0 96 18 D.......D.......
+30: 44 be 2d f5 01 62 7a 18 00 00 00 00 00 00 00 04 D....bz.........
+40: 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 01 ................
+50: 00 00 0a 01 00 00 00 00 00 00 00 00 00 00 00 00 ................
+60: ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 01 ................
+70: 41 c0 00 01 00 00 00 00 00 00 00 00 00 00 00 00 A...............
+80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+b0: 00 00 00 00 *00 45 04 00* 0a 00 00 65 6d 70 74 79 .....E.....empty
+c0: 5f 61 74 74 72 07 04 02 74 72 75 73 74 5f 61 76 .attr...trust.av
+d0: 61 6c 31 06 0c 00 73 65 63 6f 6e 64 73 65 63 6f all...secondseco
+e0: 6e 64 5f 76 61 6c 75 65 06 08 04 70 6f 6c 69 63 nd.value...polic
+f0: 79 63 6f 6e 74 65 6e 74 73 64 5f 76 61 6c 75 65 ycontentsd.value
+----
 
 It can be clearly seen that attr2 allows many more attributes to be stored in
 an inode before they are moved to another filesystem block.
@@ -444,9 +508,19 @@ flag set and the values are printed.
 A raw disk dump shows the attributes. The last attribute added is highlighted
 (offset 4044 or 0xfcc):
 
-.Leaf Attribute detail
-image::images/code/71.png[]
-
+[subs="quotes"]
+----
+000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 03 00 34 ...............4
+010: 0f cc 00 00 00 38 0f 94 00 00 00 00 00 00 00 00 .....8..........
+020: 1e 9d 39 34 0f cc 01 00 1e 9d 39 37 0f dc 01 00 ..94......97....
+030: fc f8 9d 4f 0f ec 00 00 00 00 00 00 00 00 00 00 ...0............
+040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00.................
+...
+fc0: 00 00 00 00 00 00 00 00 00 00 00 00 *00 06 05 61* ...............a
+fd0: *74 74 72 32 76 61 6c 75 65 32* 00 00 00 06 05 61 ttr2value2.....a
+fe0: 74 74 72 31 76 61 6c 75 65 31 00 00 00 00 00 01 ttr1value1......
+ff0: 00 00 77 e4 08 62 69 67 5f 61 74 74 72 00 00 00 ..w..big.attr...
+----
 
 [[Node_Attributes]]
 == Node Attributes
@@ -522,16 +596,77 @@ xfs_db> hash attribute_267
 In the root btree node, this falls between +0x3437922e+ and +0x3437d22a+,
 therefore leaf 11 or attribute block 5 will contain the entry.
 
-.Node Attribute lookup detail
-image::images/code/73-74.png[]
+[subs="quotes"]
+----
+xfs_db> ablock 5
+xfs_db> p
+hdr.info.forw = 4
+hdr.info.back = 3
+hdr.info.magic = 0xfbee
+hdr.count = 96
+hdr.usedbytes = 2688
+hdr.firstused = 1408
+hdr.holes = 0
+hdr.freemap[0-2] = [base,size] 0:[800,608] 1:[0,0] 2:[0,0]
+entries[0.95] = [hashval,nameidx,incomplete,root,secure,local]
+          0:[0x3437922f,4068,0,0,0,1]
+          1:[0x343792a6,4040,0,0,0,1]
+          2:[0x343792a7,4012,0,0,0,1]
+          3:[0x343792a8,3984,0,0,0,1]
+          ...
+          82:[0x3437d1a7,2892,0,0,0,1]
+          *83:[0x3437d1a8,2864,0,0,0,1]*
+          84:[0x3437d1a9,2836,0,0,0,1]
+          ...
+          95:[0x3437d22a,2528,0,0,0,1]
+nvlist[0].valuelen = 10
+nvlist[0].namelen = 13
+nvlist[0].name = "attribute_310"
+nvlist[0].value = "value_316\d"
+nvlist[1].valuelen = 16
+nvlist[1].namelen = 13
+nvlist[1].name = "attribute_309"
+nvlist[1].value = "value_309\d"
+nvlist[2].valuelen = 10
+nvlist[2].namelen = 13
+nvlist[2].name = "attribute_308"
+nvlist[2].value = "value_308\d"
+nvlist[3].valuelen = 10
+nvlist[3].namelen = 13
+nvlist[3].name = "attribute_307"
+nvlist[3].value = "value_307\d"
+...
+nvlist[82].valuelen = 10
+nvlist[82].namelen = 13
+nvlist[82].name = "attribute_268"
+nvlist[82].value = "value_268\d"
+nvlist[83].valuelen = 10
+nvlist[83].namelen = 13
+nvlist[83].name = "attribute_267"
+nvlist[83].value = "value_267\d"
+nvlist[84].valuelen = 10
+nvlist[84].namelen = 13
+nvlist[84].name = "attribute_266"
+nvlist[84].value = "value_266\d"
+...
+----
 
 Each of the hash entries has +XFS_ATTR_LOCAL+ flag set (1), which means the
 attribute's value follows immediately after the name. Raw disk of the name/value
 pair at offset 2864 (0xb30), highlighted with "value_267\d" following
 immediately after the name:
 
-.Node Attribute value detail
-image::images/code/74.png[]
+[subs="quotes"]
+----
+b00: 62 75 74 65 5f 32 36 35 76 61 6c 75 65 5f 32 36 bute.265value.26
+b10: 35 0a 00 00 00 0a 0d 61 74 74 72 69 62 75 74 65 5......attribute
+b20: 51 32 36 36 76 61 6c 75 65 5f 32 36 36 0a 00 00 .266value.266...
+b30: *00 0a 0d 61 74 74 72 69 62 75 74 65 5f 32 36 37* ...attribute.267
+b40: *76 61 6c 75 65 5f 32 36 37 0a* 00 00 00 0a 0d 61 value.267......a
+b50: 74 74 72 69 62 75 74 65 5f 32 36 38 76 61 6c 75 ttribute.268va1u
+b60: 65 5f 32 36 38 0a 00 00 00 0a 0d 61 74 74 72 69 e.268......attri
+b70: 62 75 74 65 5f 32 36 39 76 61 6c 75 65 5f 32 36 bute.269value.26
+----
 
 Each entry starts on a 32-bit (4 byte) boundary, therefore the highlighted entry
 has 2 unused bytes after it.
diff --git a/design/XFS_Filesystem_Structure/symbolic_links.asciidoc b/design/XFS_Filesystem_Structure/symbolic_links.asciidoc
index 9c9ca30..af88a1c 100644
--- a/design/XFS_Filesystem_Structure/symbolic_links.asciidoc
+++ b/design/XFS_Filesystem_Structure/symbolic_links.asciidoc
@@ -38,8 +38,19 @@ u.symlink = "small_target"
 
 Raw on-disk data with the link contents highlighted:
 
-.Shortform symbolic link format
-image::images/code/61.png[]
+[subs="quotes"]
+----
+xfs_db> type text
+xfs_db> p
+00: 49 4e a1 ff 01 01 00 01 00 00 00 00 00 00 00 00 IN..............
+10: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 01 ................
+20: 44 be e1 c7 03 c4 d4 18 44 be el c7 03 c4 d4 18 D.......D.......
+30: 44 be e1 c7 03 c4 d4 18 00 00 00 00 00 00 00 Oc D...............
+40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+50: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 ................
+60: ff ff ff ff *73 6d 61 6c 6c 5f 74 61 72 67 65 74* ....small.target
+70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
+----
 
 
 [[Extent_Symbolic_Links]]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
