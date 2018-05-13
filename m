Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44946 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751787AbeEMRBB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 May 2018 13:01:01 -0400
Subject: [PATCH 4/4] design: merge both metadata integrity chapters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 13 May 2018 10:00:49 -0700
Message-ID: <152623084927.10242.11550787265390407416.stgit@magnolia>
In-Reply-To: <152623082465.10242.9458731018482450171.stgit@magnolia>
References: <152623082465.10242.9458731018482450171.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, azarus@posteo.net

From: Darrick J. Wong <darrick.wong@oracle.com>

We don't need to have two chapters on metadata integrity, so merge them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../metadata_integrity.asciidoc                    |   36 --------------------
 .../self_describing_metadata.asciidoc              |   27 ++++++++++++++-
 .../xfs_filesystem_structure.asciidoc              |    2 -
 3 files changed, 26 insertions(+), 39 deletions(-)
 delete mode 100644 design/XFS_Filesystem_Structure/metadata_integrity.asciidoc


diff --git a/design/XFS_Filesystem_Structure/metadata_integrity.asciidoc b/design/XFS_Filesystem_Structure/metadata_integrity.asciidoc
deleted file mode 100644
index f948d5e..0000000
--- a/design/XFS_Filesystem_Structure/metadata_integrity.asciidoc
+++ /dev/null
@@ -1,36 +0,0 @@
-= Metadata Integrity
-
-Prior to version 5, most XFS metadata blocks contained a magic number that
-could provide a minimal sanity check that a block read off the disk contained
-the same type of data that the code thought it was reading off the disk.
-However, this was insufficient -- given a correct type code, it was still
-impossible to tell if the block was from a previous filesystem, or happened to
-be owned by something else, or had been written to the wrong location on disk.
-Furthermore, not all metadata blocks had magic numbers -- remote extended
-attributes and extent symbolic links had no protection at all.
-
-Therefore, the version 5 disk format introduced larger headers for all metadata
-types, which enable the filesystem to check information being read from the
-disk more rigorously.  Metadata integrity fields now include:
-
-* *Magic* numbers, to classify all types of metadata.  This is unchanged from v4.
-* A copy of the filesystem *UUID*, to confirm that a given disk block is connected to the superblock.
-* The *owner*, to avoid accessing a piece of metadata which belongs to some other part of the filesystem.
-* The filesystem *block number*, to detect misplaced writes.
-* The *log serial number* of the last write to this block, to avoid replaying obsolete log entries.
-* A CRC32c *checksum* of the entire block, to detect minor corruption.
-
-Metadata integrity coverage has been extended to all metadata blocks in the
-filesystem, with the following notes:
-
-* Inodes can have multiple ``owners'' in the directory tree; therefore the record contains the inode number instead of an owner or a block number.
-* Superblocks have no owners.
-* The disk quota file has no owner or block numbers.
-* Metadata owned by files list the inode number as the owner.
-* Per-AG data and B+tree blocks list the AG number as the owner.
-* Per-AG header sectors don't list owners or block numbers, since they have fixed locations.
-* Remote attribute blocks are not logged and therefore the LSN must be -1.
-
-This functionality enables XFS to decide that a block contents are so
-unexpected that it should stop immediately.  Unfortunately checksums do not
-allow for automatic correction.  Please keep regular backups, as always.
diff --git a/design/XFS_Filesystem_Structure/self_describing_metadata.asciidoc b/design/XFS_Filesystem_Structure/self_describing_metadata.asciidoc
index c3038b9..c79e865 100644
--- a/design/XFS_Filesystem_Structure/self_describing_metadata.asciidoc
+++ b/design/XFS_Filesystem_Structure/self_describing_metadata.asciidoc
@@ -1,4 +1,4 @@
-= XFS Self Describing Metadata
+= Metadata Integrity
 
 == Introduction
 
@@ -30,6 +30,31 @@ up, the more likely that the cause will be lost in the noise.  Hence the primary
 concern for supporting PB scale filesystems is minimising the time and effort
 required for basic forensic analysis of the filesystem structure.
 
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
 
 == Self Describing Metadata
 
diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index 15ab185..5c1642c 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -46,8 +46,6 @@ log items which are formatted in host order.
 
 include::overview.asciidoc[]
 
-include::metadata_integrity.asciidoc[]
-
 include::self_describing_metadata.asciidoc[]
 
 include::delayed_logging.asciidoc[]

