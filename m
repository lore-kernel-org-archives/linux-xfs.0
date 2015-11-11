Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7440C29E08
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:24:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 67AA28F8035
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:24:41 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id MJPrWARNadZLwmkT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:24:40 -0800 (PST)
Subject: [PATCH 16/21] xfsdocs: add a chapter discussing v5 disk format
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:24:14 -0800
Message-ID: <20151111192414.14235.39676.stgit@birch.djwong.org>
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

Add a chapter to give an overview of the enhanced metadata integrity
fields present on a v5 filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../metadata_integrity.asciidoc                    |   36 ++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              |    2 +
 2 files changed, 38 insertions(+)
 create mode 100644 design/XFS_Filesystem_Structure/metadata_integrity.asciidoc


diff --git a/design/XFS_Filesystem_Structure/metadata_integrity.asciidoc b/design/XFS_Filesystem_Structure/metadata_integrity.asciidoc
new file mode 100644
index 0000000..f948d5e
--- /dev/null
+++ b/design/XFS_Filesystem_Structure/metadata_integrity.asciidoc
@@ -0,0 +1,36 @@
+= Metadata Integrity
+
+Prior to version 5, most XFS metadata blocks contained a magic number that
+could provide a minimal sanity check that a block read off the disk contained
+the same type of data that the code thought it was reading off the disk.
+However, this was insufficient -- given a correct type code, it was still
+impossible to tell if the block was from a previous filesystem, or happened to
+be owned by something else, or had been written to the wrong location on disk.
+Furthermore, not all metadata blocks had magic numbers -- remote extended
+attributes and extent symbolic links had no protection at all.
+
+Therefore, the version 5 disk format introduced larger headers for all metadata
+types, which enable the filesystem to check information being read from the
+disk more rigorously.  Metadata integrity fields now include:
+
+* *Magic* numbers, to classify all types of metadata.  This is unchanged from v4.
+* A copy of the filesystem *UUID*, to confirm that a given disk block is connected to the superblock.
+* The *owner*, to avoid accessing a piece of metadata which belongs to some other part of the filesystem.
+* The filesystem *block number*, to detect misplaced writes.
+* The *log serial number* of the last write to this block, to avoid replaying obsolete log entries.
+* A CRC32c *checksum* of the entire block, to detect minor corruption.
+
+Metadata integrity coverage has been extended to all metadata blocks in the
+filesystem, with the following notes:
+
+* Inodes can have multiple ``owners'' in the directory tree; therefore the record contains the inode number instead of an owner or a block number.
+* Superblocks have no owners.
+* The disk quota file has no owner or block numbers.
+* Metadata owned by files list the inode number as the owner.
+* Per-AG data and B+tree blocks list the AG number as the owner.
+* Per-AG header sectors don't list owners or block numbers, since they have fixed locations.
+* Remote attribute blocks are not logged and therefore the LSN must be -1.
+
+This functionality enables XFS to decide that a block contents are so
+unexpected that it should stop immediately.  Unfortunately checksums do not
+allow for automatic correction.  Please keep regular backups, as always.
diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index 9f4c096..8aacbb7 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -46,6 +46,8 @@ log items which are formatted in host order.
 
 include::overview.asciidoc[]
 
+include::metadata_integrity.asciidoc[]
+
 include::common_types.asciidoc[]
 
 // return titles to normal

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
