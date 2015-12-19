Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C278329EDE
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:13:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57FEEAC004
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:13:49 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id mJGw5RK55WLJCN7L (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:13:47 -0800 (PST)
Subject: [PATCH 11/22] xfsdocs: add missing xfs_db examples
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:13:25 -0800
Message-ID: <20151219091325.15558.37906.stgit@birch.djwong.org>
In-Reply-To: <20151219091208.15558.65013.stgit@birch.djwong.org>
References: <20151219091208.15558.65013.stgit@birch.djwong.org>
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

Fix some of the more egregious missing xfs_db examples so that the reader
can appreciate what the data structures look like.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |   74 ++++++++++++++++++++
 .../XFS_Filesystem_Structure/data_extents.asciidoc |   41 +++++++++++
 .../XFS_Filesystem_Structure/directories.asciidoc  |   55 +++++++++++++++
 design/XFS_Filesystem_Structure/docinfo.xml        |    1 
 4 files changed, 168 insertions(+), 3 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index e958039..7d4c11b 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -831,7 +831,79 @@ image::images/20b.png[]
 
 
 ==== xfs_db AGI Example
-TODO
+
+This is an AGI of a freshly populated filesystem:
+
+----
+xfs_db> agi 0
+xfs_db> p
+magicnum = 0x58414749
+versionnum = 1
+seqno = 0
+length = 825457
+count = 5440
+root = 3
+level = 1
+freecount = 9
+newino = 5792
+dirino = null
+unlinked[0-63] =
+uuid = 3dfa1e5c-5a5f-4ca2-829a-000e453600fe
+lsn = 0x1000032c2
+crc = 0x14cb7e5c (correct)
+free_root = 4
+free_level = 1
+----
+
+From this example, we see that the inode B+tree is rooted at AG block 3 and
+that the free inode B+tree is rooted at AG block 4.  Let's look at the
+inode B+tree:
+
+----
+xfs_db> addr root
+xfs_db> p
+magic = 0x49414233
+level = 0
+numrecs = 85
+leftsib = null
+rightsib = null
+bno = 24
+lsn = 0x1000032c2
+uuid = 3dfa1e5c-5a5f-4ca2-829a-000e453600fe
+owner = 0
+crc = 0x768f9592 (correct)
+recs[1-85] = [startino,freecount,free]
+        1:[96,0,0] 2:[160,0,0] 3:[224,0,0] 4:[288,0,0]
+        5:[352,0,0] 6:[416,0,0] 7:[480,0,0] 8:[544,0,0]
+        9:[608,0,0] 10:[672,0,0] 11:[736,0,0] 12:[800,0,0]
+        ...
+        85:[5792,9,0xff80000000000000]
+----
+
+Most of the inode chunks on this filesystem are totally full, since the +free+
+value is zero.  This means that we ought to expect inode 160 to be linked
+somewhere in the directory structure.  However, notice that 0xff80000000000000
+in record 85 -- this means that we would expect inode 5856 to be free.  Moving
+on to the free inode B+tree, we see that this is indeed the case:
+
+----
+xfs_db> addr free_root
+xfs_db> p
+magic = 0x46494233
+level = 0
+numrecs = 1
+leftsib = null
+rightsib = null
+bno = 32
+lsn = 0x1000032c2
+uuid = 3dfa1e5c-5a5f-4ca2-829a-000e453600fe
+owner = 0
+crc = 0x338af88a (correct)
+recs[1] = [startino,freecount,free] 1:[5792,9,0xff80000000000000]
+----
+
+Observe also that the AGI's +agi_newino+ points to this chunk, which has never
+been fully allocated.
 
 [[Real-time_Devices]]
 == Real-time Devices
diff --git a/design/XFS_Filesystem_Structure/data_extents.asciidoc b/design/XFS_Filesystem_Structure/data_extents.asciidoc
index d1617f1..5df6623 100644
--- a/design/XFS_Filesystem_Structure/data_extents.asciidoc
+++ b/design/XFS_Filesystem_Structure/data_extents.asciidoc
@@ -302,4 +302,43 @@ image::images/36.png[]
 
 === xfs_db bmbt Example
 
-TODO
+In this example, we dissect the data fork of a VM image that is sufficiently
+sparse and interleaved to have become a B+tree.
+
+----
+xfs_db> inode 132
+xfs_db> p
+core.magic = 0x494e
+core.mode = 0100600
+core.version = 3
+core.format = 3 (btree)
+...
+u3.bmbt.level = 1
+u3.bmbt.numrecs = 3
+u3.bmbt.keys[1-3] = [startoff] 1:[0] 2:[9072] 3:[13136]
+u3.bmbt.ptrs[1-3] = 1:8568 2:8569 3:8570
+----
+
+As you can see, the block map B+tree is rooted in the inode.  This tree has two
+levels, so let's go down a level to look at the records:
+
+----
+xfs_db> addr u3.bmbt.ptrs[1]
+xfs_db> p
+magic = 0x424d4133
+level = 0
+numrecs = 251
+leftsib = null
+rightsib = 8569
+bno = 68544
+lsn = 0x100000006
+uuid = 9579903c-333f-4673-a7d4-3254c05816ea
+owner = 132
+crc = 0xc61513dc (correct)
+recs[1-251] = [startoff,startblock,blockcount,extentflag]
+        1:[0,8520,48,0] 2:[48,4421,16,0] 3:[80,9136,16,0] 4:[96,8569,16,0]
+        5:[144,8601,32,0] 6:[192,8637,16,0] 7:[240,8680,16,0] 8:[288,9870,16,0]
+        9:[320,9920,16,0] 10:[336,9950,16,0] 11:[384,4004,32,0]
+        12:[432,6771,16,0] 13:[480,2702,16,0] 14:[528,8420,16,0]
+        ...
+----
diff --git a/design/XFS_Filesystem_Structure/directories.asciidoc b/design/XFS_Filesystem_Structure/directories.asciidoc
index 2df118e..73ede11 100644
--- a/design/XFS_Filesystem_Structure/directories.asciidoc
+++ b/design/XFS_Filesystem_Structure/directories.asciidoc
@@ -269,8 +269,61 @@ b0: 72  61 6d 65 30 30 30 30 30 33 2e 74 73 74 01 80 rame000003.tst..
 c0: 00  84 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
 ----
 
-TODO: 8-byte inode number example
+This is an example of mixed 4-byte and 8-byte inodes in a directory:
 
+----
+xfs_db> inode 1024
+xfs_db> p
+core.magic = 0x494e
+core.mode = 040755
+core.version = 3
+core.format = 1 (local)
+core.nlinkv2 = 9
+...
+core.size = 125
+core.nblocks = 0
+core.extsize = 0
+core.nextents = 0
+...
+u3.sfdir3.hdr.count = 7
+u3.sfdir3.hdr.i8count = 4
+u3.sfdir3.hdr.parent.i8 = 1024
+u3.sfdir3.list[0].namelen = 3
+u3.sfdir3.list[0].offset = 0x60
+u3.sfdir3.list[0].name = "git"
+u3.sfdir3.list[0].inumber.i8 = 1027
+u3.sfdir3.list[0].filetype = 2
+u3.sfdir3.list[1].namelen = 4
+u3.sfdir3.list[1].offset = 0x70
+u3.sfdir3.list[1].name = "home"
+u3.sfdir3.list[1].inumber.i8 = 13422826546
+u3.sfdir3.list[1].filetype = 2
+u3.sfdir3.list[2].namelen = 10
+u3.sfdir3.list[2].offset = 0x80
+u3.sfdir3.list[2].name = "mike"
+u3.sfdir3.list[2].inumber.i8 = 4299308032
+u3.sfdir3.list[2].filetype = 2
+u3.sfdir3.list[3].namelen = 3
+u3.sfdir3.list[3].offset = 0x98
+u3.sfdir3.list[3].name = "mtr"
+u3.sfdir3.list[3].inumber.i8 = 13433252916
+u3.sfdir3.list[3].filetype = 2
+u3.sfdir3.list[4].namelen = 3
+u3.sfdir3.list[4].offset = 0xa8
+u3.sfdir3.list[4].name = "vms"
+u3.sfdir3.list[4].inumber.i8 = 16647516355
+u3.sfdir3.list[4].filetype = 2
+u3.sfdir3.list[5].namelen = 5
+u3.sfdir3.list[5].offset = 0xb8
+u3.sfdir3.list[5].name = "rsync"
+u3.sfdir3.list[5].inumber.i8 = 3494912
+u3.sfdir3.list[5].filetype = 2
+u3.sfdir3.list[6].namelen = 3
+u3.sfdir3.list[6].offset = 0xd0
+u3.sfdir3.list[6].name = "tmp"
+u3.sfdir3.list[6].inumber.i8 = 1593379
+u3.sfdir3.list[6].filetype = 2
+----
 
 [[Block_Directories]]
 == Block Directories
diff --git a/design/XFS_Filesystem_Structure/docinfo.xml b/design/XFS_Filesystem_Structure/docinfo.xml
index 32a502d..85ccda5 100644
--- a/design/XFS_Filesystem_Structure/docinfo.xml
+++ b/design/XFS_Filesystem_Structure/docinfo.xml
@@ -83,6 +83,7 @@
 			<simplelist>
 				<member>Miscellaneous fixes.</member>
 				<member>Add missing field definitions.</member>
+				<member>Add some missing xfs_db examples.</member>
 			</simplelist>
 		</revdescription>
 	</revision>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
