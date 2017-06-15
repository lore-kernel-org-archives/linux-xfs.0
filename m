Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50141 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdFOWAF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2017 18:00:05 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v5FM04bZ006833
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2017 22:00:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v5FM04Ap029517
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2017 22:00:04 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v5FM043g004094
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2017 22:00:04 GMT
Date: Thu, 15 Jun 2017 15:00:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] docs: record the metadump file format
Message-ID: <20170615220002.GB4530@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Document the metadump file format.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 design/XFS_Filesystem_Structure/docinfo.xml        |   14 +++++
 design/XFS_Filesystem_Structure/magic.asciidoc     |    1 
 design/XFS_Filesystem_Structure/metadump.asciidoc  |   62 ++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              |    9 +++
 4 files changed, 86 insertions(+)
 create mode 100644 design/XFS_Filesystem_Structure/metadump.asciidoc

diff --git a/design/XFS_Filesystem_Structure/docinfo.xml b/design/XFS_Filesystem_Structure/docinfo.xml
index 5cdcf6c..e13d705 100644
--- a/design/XFS_Filesystem_Structure/docinfo.xml
+++ b/design/XFS_Filesystem_Structure/docinfo.xml
@@ -155,4 +155,18 @@
 			</simplelist>
 		</revdescription>
 	</revision>
+	<revision>
+		<revnumber>3.14159</revnumber>
+		<date>June 2017</date>
+		<author>
+			<firstname>Darrick</firstname>
+			<surname>Wong</surname>
+			<email>darrick.wong@oracle.com</email>
+		</author>
+		<revdescription>
+			<simplelist>
+				<member>Add the metadump file format.</member>
+			</simplelist>
+		</revdescription>
+	</revision>
 </revhistory>
diff --git a/design/XFS_Filesystem_Structure/magic.asciidoc b/design/XFS_Filesystem_Structure/magic.asciidoc
index 77bed6d..7e62783 100644
--- a/design/XFS_Filesystem_Structure/magic.asciidoc
+++ b/design/XFS_Filesystem_Structure/magic.asciidoc
@@ -47,6 +47,7 @@ relevant chapters.  Magic numbers tend to have consistent locations:
 | +XFS_RMAP_CRC_MAGIC+		| 0x524d4233	| RMB3	| xref:Reverse_Mapping_Btree[Reverse Mapping B+tree], v5 only
 | +XFS_RTRMAP_CRC_MAGIC+	| 0x4d415052	| MAPR	| xref:Real_time_Reverse_Mapping_Btree[Real-Time Reverse Mapping B+tree], v5 only
 | +XFS_REFC_CRC_MAGIC+		| 0x52334643	| R3FC	| xref:Reference_Count_Btree[Reference Count B+tree], v5 only
+| +XFS_MD_MAGIC+		| 0x5846534d	| XFSM	| xref:Metadata_Dumps[Metadata Dumps]
 |=====
 
 The magic numbers for log items are at offset zero in each log item, but items
diff --git a/design/XFS_Filesystem_Structure/metadump.asciidoc b/design/XFS_Filesystem_Structure/metadump.asciidoc
new file mode 100644
index 0000000..2bddb77
--- /dev/null
+++ b/design/XFS_Filesystem_Structure/metadump.asciidoc
@@ -0,0 +1,62 @@
+[[Metadata_Dumps]]
+= Metadata Dumps
+
+The +xfs_metadump+ and +xfs_mdrestore+ tools are used to create a sparse
+snapshot of a live file system and to restore that snapshot onto a block
+device for debugging purposes.  Only the metadata are captured in the
+snapshot, and the metadata blocks may be obscured for privacy reasons.
+
+A metadump file starts with a +xfs_metablock+ that records the addresses of
+the blocks that follow.  Following that are the metadata blocks captured
+from the filesystem.  The first block following the first superblock
+must be the superblock from AG 0.  If the metadump has more blocks than
+can be pointed to by the +xfs_metablock.mb_daddr+ area, the sequence
+of +xfs_metablock+ followed by metadata blocks is repeated.
+
+.Metadata Dump Format
+
+[source, c]
+----
+struct xfs_metablock {
+	__be32		mb_magic;
+	__be16		mb_count;
+	uint8_t		mb_blocklog;
+	uint8_t		mb_reserved;
+	__be64		mb_daddr[];
+};
+----
+
+*mb_magic*::
+The magic number, ``XFSM'' (0x5846534d).
+
+*mb_count*::
+Number of blocks indexed by this record.  This value must not exceed +(1
+<< mb_blocklog) - sizeof(struct xfs_metablock)+.
+
+*mb_blocklog*::
+The log size of a metadump block.  This size of a metadump block 512
+bytes, so this value should be 9.
+
+*mb_reserved*::
+Reserved.  Should be zero.
+
+*mb_daddr*::
+An array of disk addresses.  Each of the +mb_count+ blocks (of size +(1
+<< mb_blocklog+) following the +xfs_metablock+ should be written back to
+the address pointed to by the corresponding +mb_daddr+ entry.
+
+== Dump Obfuscation
+
+Unless explicitly disabled, the +xfs_metadump+ tool obfuscates empty block
+space and naming information to avoid leaking sensitive information into
+the metadump file.  +xfs_metadump+ does not copy user data blocks.
+
+The obfuscation policy is as follows:
+
+* File and extended attribute names are both considered "names".
+* Names longer than 8 characters are totally rewritten with a name that matches the hash of the old name.
+* Names between 5 and 8 characters are partially rewritten to match the hash of the old name.
+* Names shorter than 5 characters are not obscured at all.
+* Names that cross a block boundary are not obscured at all.
+* Extended attribute values are zeroed.
+* Empty parts of metadata blocks are zeroed.
diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index 7916fbe..5540fa0 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -96,3 +96,12 @@ include::extended_attributes.asciidoc[]
 include::symbolic_links.asciidoc[]
 
 :leveloffset: 0
+
+Auxiliary Data Structures
+=========================
+
+:leveloffset: 1
+
+include::metadump.asciidoc[]
+
+:leveloffset: 0
