Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840F04A03
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 01:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B3W2MIqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C1EC433C7;
	Mon,  1 Jan 2024 01:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071243;
	bh=m/7HgEyW3smd7LCUVgApY7o/jRFpvkCybcektKRiqaQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B3W2MIqaj+D+Qj88kwqOXer0vcjZUTefbOgeV3PtzuOulIw0Qhyma5myqdsYypjuE
	 jR713l41UC8opAagmRtXZukKRuPpQHtAgKOg53HSIhESgRmsx1eQkltnMttaKU6Ew2
	 rrcUq0WfzeGY6jKOfjTEcxjCsuSRB5DrXJOA3aVFSJAuxQ+EJ3ooxlEscqJtVbRRsT
	 uAoqyRLiM1VDyDYnv7pr6Izq+Wv/s8LRuioramWPf1JcjBD4FfwYQcM05ZNMafVUy5
	 jkFa1jvddGJKT54qcXrWOxre5nquzpef586AFIIWxi4YmDzH0ZL86IOO54AOOV1q1W
	 uC9lysc55ZZfA==
Date: Sun, 31 Dec 2023 17:07:22 +9900
Subject: [PATCH 1/1] design: document atomic extent swap log intent structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: darrick.wong@oracle.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405035797.1829110.9842815227503662882.stgit@frogsfrogsfrogs>
In-Reply-To: <170405035784.1829110.16772887829212783961.stgit@frogsfrogsfrogs>
References: <170405035784.1829110.16772887829212783961.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Document the log formats for the atomic extent swapping feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../allocation_groups.asciidoc                     |    7 +
 .../journaling_log.asciidoc                        |  111 ++++++++++++++++++++
 design/XFS_Filesystem_Structure/magic.asciidoc     |    2 
 3 files changed, 120 insertions(+)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index c0ba16a8..7b128838 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -470,6 +470,13 @@ the FS log if it doesn't understand the flag.
 | Flag					| Description
 | +XFS_SB_FEAT_INCOMPAT_LOG_XATTRS+	|
 Extended attribute updates have been committed to the ondisk log.
+| +XFS_SB_FEAT_INCOMPAT_LOG_ATOMIC_SWAP+ |
+Atomic file content swapping.  The filesystem is capable of swapping the
+extents mapped to two arbitrary ranges of a file's fork by using intent log
+items to track the progress of the high level operation.  In other words, a
+range swap operation can be restarted if the system goes down, which is
+necessary for userspace to commit of new file contents atomically.  See the
+section about xref:SXI_Log_Item[extent swap log intents] for more information.
 
 |=====
 
diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
index 8ff437fe..daf9b225 100644
--- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
+++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
@@ -217,6 +217,8 @@ magic number to distinguish themselves.  Buffer data items only appear after
 | +XFS_LI_BUD+			| 0x1245        | xref:BUD_Log_Item[File Block Mapping Update Done]
 | +XFS_LI_ATTRI+		| 0x1246        | xref:ATTRI_Log_Item[Extended Attribute Update Intent]
 | +XFS_LI_ATTRD+		| 0x1247        | xref:ATTRD_Log_Item[Extended Attribute Update Done]
+| +XFS_LI_SXI+			| 0x1248        | xref:SXI_Log_Item[File Extent Swap Intent]
+| +XFS_LI_SXD+			| 0x1249        | xref:SXD_Log_Item[File Extent Swap Done]
 |=====
 
 Note that all log items (except for transaction headers) MUST start with
@@ -649,6 +651,8 @@ file block mapping operation we want.  The upper three bytes are flag bits.
 | Value				| Description
 | +XFS_BMAP_EXTENT_ATTR_FORK+	| Extent is for the attribute fork.
 | +XFS_BMAP_EXTENT_UNWRITTEN+	| Extent is unwritten.
+| +XFS_BMAP_EXTENT_REALTIME+	| Mapping applies to the data fork of a
+realtime file.  This flag cannot be combined with +XFS_BMAP_EXTENT_ATTR_FORK+.
 |=====
 
 The ``file block mapping update intent'' operation comes first; it tells the
@@ -821,6 +825,113 @@ These regions contain the name and value components of the extended attribute
 being updated, as needed.  There are no magic numbers; each region contains the
 data and nothing else.
 
+[[SXI_Log_Item]]
+=== File Extent Swap Intent
+
+These two log items work together to track the exchange of mapped extents
+between the forks of two files.  Each operation requires a separate SXI/SXD
+pair.  The log intent item has the following format:
+
+[source, c]
+----
+struct xfs_sxi_log_format {
+     uint16_t                  sxi_type;
+     uint16_t                  sxi_size;
+     uint32_t                  __pad;
+     uint64_t                  sxi_id;
+     uint64_t                  sxi_inode1;
+     uint64_t                  sxi_inode2;
+     uint64_t                  sxi_startoff1;
+     uint64_t                  sxi_startoff2;
+     uint64_t                  sxi_blockcount;
+     uint64_t                  sxi_flags;
+     int64_t                   sxi_isize1;
+     int64_t                   sxi_isize2;
+};
+----
+
+*sxi_type*::
+The signature of an SXI operation, 0x1246.  This value is in host-endian order,
+not big-endian like the rest of XFS.
+
+*sxi_size*::
+Size of this log item.  Should be 1.
+
+*__pad*::
+Must be zero.
+
+*sxi_id*::
+A 64-bit number that binds the corresponding SXD log item to this SXI log item.
+
+*sxi_inode1*::
+Inode number of the first file involved in the operation.
+
+*sxi_inode2*::
+Inode number of the second file involved in the operation.
+
+*sxi_startoff1*::
+Starting point within the first file, in units of filesystem blocks.
+
+*sxi_startoff2*::
+Starting point within the second file, in units of filesystem blocks.
+
+*sxi_blockcount*::
+The length to be exchanged, in units of filesystem blocks.
+
+*sxi_flags*::
+Behavioral changes to the operation, as follows:
+
+.File Extent Swap Intent Item Flags
+[options="header"]
+|=====
+| Value				   | Description
+| +XFS_SWAP_EXTENT_ATTR_FORK+	   | Exchange extents between attribute forks.
+| +XFS_SWAP_EXTENT_SET_SIZES+	   | Exchange the file sizes of the two files
+after the operation completes.
+| +XFS_SWAP_EXTENT_INO2_SHORTFORM+ | Convert the second file fork back to
+inline format after the exchange completes.
+|=====
+
+*sxi_isize1*::
+The original size of the first file, in bytes.  This is zero if the
++XFS_SWAP_EXTENT_SET_SIZES+ flag is not set.
+
+*sxi_isize2*::
+The original size of the second file, in bytes.  This is zero if the
++XFS_SWAP_EXTENT_SET_SIZES+ flag is not set.
+
+[[SXD_Log_Item]]
+=== Completion of File Extent Swap
+
+The ``file extent swap done'' operation complements the ``file extent swap
+intent'' operation.  This second operation indicates that the update actually
+happened, so that log recovery needn't replay the update.  The SXD and the
+actual updates are typically found in a new transaction following the
+transaction in which the SXI was logged.  The completion has this format:
+
+[source, c]
+----
+struct xfs_sxd_log_format {
+     uint16_t                  sxd_type;
+     uint16_t                  sxd_size;
+     uint32_t                  __pad;
+     uint64_t                  sxd_sxi_id;
+};
+----
+
+*sxd_type*::
+The signature of an SXD operation, 0x1247.  This value is in host-endian order,
+not big-endian like the rest of XFS.
+
+*sxd_size*::
+Size of this log item.  Should be 1.
+
+*__pad*::
+Must be zero.
+
+*sxd_id*::
+A 64-bit number that binds the corresponding SXI log item to this SXD log item.
+
 [[Inode_Log_Item]]
 === Inode Updates
 
diff --git a/design/XFS_Filesystem_Structure/magic.asciidoc b/design/XFS_Filesystem_Structure/magic.asciidoc
index a343271a..613e50c0 100644
--- a/design/XFS_Filesystem_Structure/magic.asciidoc
+++ b/design/XFS_Filesystem_Structure/magic.asciidoc
@@ -73,6 +73,8 @@ are not aligned to blocks.
 | +XFS_LI_BUD+			| 0x1245        |       | xref:BUD_Log_Item[File Block Mapping Update Done]
 | +XFS_LI_ATTRI+		| 0x1246        |       | xref:ATTRI_Log_Item[Extended Attribute Update Intent]
 | +XFS_LI_ATTRD+		| 0x1247        |       | xref:ATTRD_Log_Item[Extended Attribute Update Done]
+| +XFS_LI_SXI+			| 0x1248        |       | xref:SXI_Log_Item[File Extent Swap Intent]
+| +XFS_LI_SXD+			| 0x1249        |       | xref:SXD_Log_Item[File Extent Swap Done]
 |=====
 
 = Theoretical Limits

