Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7D68429DFC
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:24:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5FE5D304032
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:24:51 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 3CPGBHEr8btjz7Yt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:24:49 -0800 (PST)
Subject: [PATCH 18/21] xfsdocs: document the sparse inodes feature
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:24:28 -0800
Message-ID: <20151111192428.14235.3249.stgit@birch.djwong.org>
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

Document the new sparse inodes feature and how it affects the inobt records.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |  157 ++++++++++++++++++++
 design/XFS_Filesystem_Structure/docinfo.xml        |    1 
 2 files changed, 155 insertions(+), 3 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 845b359..ca3210c 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -388,6 +388,18 @@ Directory file type.  Each directory entry tracks the type of the inode to
 which the entry points.  This is a performance optimization to remove the need
 to load every inode into memory to iterate a directory.
 
+| +XFS_SB_FEAT_INCOMPAT_SPINODES+ |
+Sparse inodes.  This feature relaxes the requirement to allocate inodes in
+chunks of 64.  When the free space is heavily fragmented, there might exist
+plenty of free space but not enough contiguous free space to allocate a new
+inode chunk.  With this feature, the user can continue to create files until
+all free space is exhausted.
+
+Unused space in the inode B+tree records are used to track which parts of the
+inode chunk are not inodes.
+
+See the chapter on xref:Sparse_Inodes[Sparse Inodes] for more information.
+
 | +XFS_SB_FEAT_INCOMPAT_META_UUID+ |
 Metadata UUID.  The UUID stamped into each metadata block must match the value
 in +sb_meta_uuid+.  This enables the administrator to change +sb_uuid+ at will
@@ -977,9 +989,9 @@ Specifies the number of levels in the free inode B+tree.
 [[Inode_Btrees]]
 == Inode B+trees
 
-Inodes are allocated in chunks of 64, and a B+tree is used to track these chunks
-of inodes as they are allocated and freed. The block containing root of the
-B+tree is defined by the AGI's +agi_root+ value.  If the
+Inodes are traditionally allocated in chunks of 64, and a B+tree is used to
+track these chunks of inodes as they are allocated and freed. The block
+containing root of the B+tree is defined by the AGI's +agi_root+ value.  If the
 +XFS_SB_FEAT_RO_COMPAT_FINOBT+ feature is enabled, a second B+tree is used to
 track the chunks containing free inodes; this is an optimization to speed up
 inode allocation.
@@ -1111,6 +1123,145 @@ recs[1] = [startino,freecount,free] 1:[5792,9,0xff80000000000000]
 Observe also that the AGI's +agi_newino+ points to this chunk, which has never
 been fully allocated.
 
+[[Sparse_Inodes]]
+== Sparse Inodes
+
+As mentioned in the previous section, XFS allocates inodes in chunks of 64.  If
+there are no free extents large enough to hold a full chunk of 64 inodes, the
+inode allocation fails and XFS claims to have run out of space.  On a
+filesystem with highly fragmented free space, this can lead to out of space
+errors long before the filesystem runs out of free blocks.
+
+The sparse inode feature tracks inode chunks in the inode B+tree as if they
+were full chunks but uses some previously unused bits in the freecount field to
+track which parts of the inode chunk are not allocated for use as inodes.  This
+allows XFS to allocate inodes one block at a time if absolutely necessary.
+
+The inode and free inode B+trees operate in the same manner as they do without
+the sparse inode feature; the B+tree header for the nodes and leaves use the
++xfs_btree_sblock+ structure which is the same as the header used in the
+xref:AG_Free_Space_Btrees[AGF B+trees].
+
+Leaves contain an array of the following structure:
+
+[source,c]
+----
+struct xfs_inobt_rec {
+     __be32                    ir_startino;
+     __be16                    ir_holemask;
+     __u8                      ir_count;
+     __u8                      ir_freecount;
+     __be64                    ir_free;
+};
+----
+
+*ir_startino*::
+The lowest-numbered inode in this chunk, rounded down to the nearest multiple
+of 64, even if the start of this chunk is sparse.
+
+*ir_holemask*::
+A 16 element bitmap showing which parts of the chunk are not allocated to
+inodes.  Each bit represents four inodes; if a bit is marked here, the
+corresponding bits in ir_free must also be marked.
+
+*ir_count*::
+Number of inodes allocated to this chunk.
+
+*ir_freecount*::
+Number of free inodes in this chunk.
+
+*ir_free*::
+A 64 element bitmap showing which inodes in this chunk are not available for
+allocation.
+
+==== xfs_db Sparse Inode AGI Example
+
+This example derives from an AG that has been deliberately fragmented.  The
+inode B+tree:
+
+----
+xfs_db> agi 0
+xfs_db> p
+magicnum = 0x58414749
+versionnum = 1
+seqno = 0
+length = 6400
+count = 10432
+root = 2381
+level = 2
+freecount = 0
+newino = 14912
+dirino = null
+unlinked[0-63] =
+uuid = b9b4623b-f678-4d48-8ce7-ce08950e3cd6
+lsn = 0x600000ac4
+crc = 0xef550dbc (correct)
+free_root = 4
+free_level = 1
+----
+
+This AGI was formatted on a v5 filesystem; notice the extra v5 fields.  So far
+everything else looks much the same as always.
+
+----
+xfs_db> addr root
+magic = 0x49414233
+level = 1
+numrecs = 2
+leftsib = null
+rightsib = null
+bno = 19048
+lsn = 0x50000192b
+uuid = b9b4623b-f678-4d48-8ce7-ce08950e3cd6
+owner = 0
+crc = 0xd98cd2ca (correct)
+keys[1-2] = [startino] 1:[128] 2:[35136]
+ptrs[1-2] = 1:3 2:2380
+xfs_db> addr ptrs[1]
+xfs_db> p
+magic = 0x49414233
+level = 0
+numrecs = 159
+leftsib = null
+rightsib = 2380
+bno = 24
+lsn = 0x600000ac4
+uuid = b9b4623b-f678-4d48-8ce7-ce08950e3cd6
+owner = 0
+crc = 0x836768a6 (correct)
+recs[1-159] = [startino,holemask,count,freecount,free]
+        1:[128,0,64,0,0]
+        2:[14912,0xff,32,0,0xffffffff]
+        3:[15040,0,64,0,0]
+        4:[15168,0xff00,32,0,0xffffffff00000000]
+        5:[15296,0,64,0,0]
+        6:[15424,0xff,32,0,0xffffffff]
+        7:[15552,0,64,0,0]
+        8:[15680,0xff00,32,0,0xffffffff00000000]
+        9:[15808,0,64,0,0]
+        10:[15936,0xff,32,0,0xffffffff]
+----
+
+Here we see the difference in the inode B+tree records.  For example, in record
+2, we see that the holemask has a value of 0xff.  This means that the first
+sixteen inodes in this chunk record do not actually map to inode blocks; the
+first inode in this chunk is actually inode 14944:
+
+----
+xfs_db> inode 14912
+Metadata corruption detected at block 0x3a40/0x2000
+...
+Metadata CRC error detected for ino 14912
+xfs_db> p core.magic
+core.magic = 0
+xfs_db> inode 14944
+xfs_db> p core.magic
+core.magic = 0x494e
+----
+
+The chunk record also indicates that this chunk has 32 inodes, and that the
+missing inodes are also ``free''.
+
 [[Real-time_Devices]]
 == Real-time Devices
 
diff --git a/design/XFS_Filesystem_Structure/docinfo.xml b/design/XFS_Filesystem_Structure/docinfo.xml
index 6189fd6..ba97809 100644
--- a/design/XFS_Filesystem_Structure/docinfo.xml
+++ b/design/XFS_Filesystem_Structure/docinfo.xml
@@ -104,6 +104,7 @@
 				<member>Discuss metadata integrity.</member>
 				<member>Document the free inode B+tree.</member>
 				<member>Create an index of magic numbers.</member>
+				<member>Document sparse inodes.</member>
 			</simplelist>
 		</revdescription>
 	</revision>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
