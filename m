Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8E5B646
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 19:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723058050; cv=none; b=oN+0wI/76M8pQ1ZlhTDBdTAdMlHweKRoxZQcAaHAGHluPmWRlfCeAqSdtntby5XwHEjtI9c/39rH+8mTE0igwPRlLIpJU3/X2dpHuYGqiDxaXDhIae/aBXRLB22RjghBURCxBqu2iqj0FfWj5ihZG6lCoj5m70L+LZIHlVXqoMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723058050; c=relaxed/simple;
	bh=w+gWr/s1kxwhyQONgmut6VRZibjd4xDWnpSme9HDZKs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ol3l2/vhtxklikG+g+DAQTSCPdk9cMsKsw6/dJOQMviyRLpKCxs1oD9lVGAfQAD42pVwLtbm1oGBwed7pT4AZKTk/QT/YVQEQ3QCRQnfkWB3Ly6I7GyXA7lcqwcfpQqpWOI9TLFu+I97ZNwgn2sqxQwIi2UwZBOGSKoBuKU6HL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fmTjnNRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fmTjnNRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF92BC32781;
	Wed,  7 Aug 2024 19:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723058049;
	bh=w+gWr/s1kxwhyQONgmut6VRZibjd4xDWnpSme9HDZKs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fmTjnNRAGiZlxH+mw/CW/IJ4JXnawVeDCRMcCssI2czCG0TxW9sR5f5PC0YaIpX4n
	 ljz2YOy/F7qZFqTwgmmgCTjDmwOrACsTqG6tg4KmtpzmtiZ5ZlefcRtB0LZsKSfv16
	 B5BBnhOUfuhlJEQsh69aZdv0KPybjlefLBz8bkucDeIJIrCC6s6CM+gAjHgRW8S8dJ
	 +Ya469f8ltehlq4RleELn6SKb8N6dp6BejcAm9uG2btL1Aa7VlE+kQO0JotmlEXwzd
	 Xz10U/u3t0u/nFrlqPa6zhe2fkEnZD4y0D1c8GkOwSKOdjYIVAAwsrn0bsRVrU0c1/
	 p2thNN4awNKXQ==
Date: Wed, 07 Aug 2024 12:14:09 -0700
Subject: [PATCH 1/5] design: document atomic file mapping exchange log intent
 structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172305794103.969463.851368852347319574.stgit@frogsfrogsfrogs>
In-Reply-To: <172305794084.969463.781862996787293755.stgit@frogsfrogsfrogs>
References: <172305794084.969463.781862996787293755.stgit@frogsfrogsfrogs>
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

Document the log intent item formats for the mapping exchange feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../allocation_groups.asciidoc                     |   10 ++
 .../journaling_log.asciidoc                        |  123 ++++++++++++++++++++
 design/XFS_Filesystem_Structure/magic.asciidoc     |    2 
 3 files changed, 135 insertions(+)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index c0ba16a8..e22c7344 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -458,6 +458,16 @@ xfs_repair before it can be mounted.
 Large file fork extent counts.  This greatly expands the maximum number of
 space mappings allowed in data and extended attribute file forks.
 
+| +XFS_SB_FEAT_INCOMPAT_EXCHRANGE+ |
+Atomic file mapping exchanges.  The filesystem is capable of exchanging a range
+of mappings between two arbitrary ranges of a file's fork by using log intent
+items to track the progress of the high level exchange operation.  In other
+words, the exchange operation can be restarted if the system goes down, which
+is necessary for userspace to commit of new file contents atomically.  This
+flag has user-visible impacts, which is why it is a permanent incompat flag.
+See the section about xref:XMI_Log_Item[mapping exchange log intents] for more
+information.
+
 |=====
 
 *sb_features_log_incompat*::
diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
index 8ff437fe..9d9fa836 100644
--- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
+++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
@@ -217,6 +217,8 @@ magic number to distinguish themselves.  Buffer data items only appear after
 | +XFS_LI_BUD+			| 0x1245        | xref:BUD_Log_Item[File Block Mapping Update Done]
 | +XFS_LI_ATTRI+		| 0x1246        | xref:ATTRI_Log_Item[Extended Attribute Update Intent]
 | +XFS_LI_ATTRD+		| 0x1247        | xref:ATTRD_Log_Item[Extended Attribute Update Done]
+| +XFS_LI_XMI+			| 0x1248        | xref:XMI_Log_Item[File Mapping Exchange Intent]
+| +XFS_LI_XMD+			| 0x1249        | xref:XMD_Log_Item[File Mapping Exchange Done]
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
@@ -821,6 +825,125 @@ These regions contain the name and value components of the extended attribute
 being updated, as needed.  There are no magic numbers; each region contains the
 data and nothing else.
 
+[[XMI_Log_Item]]
+=== File Mapping Exchange Intent
+
+These two log items work together to track the exchange of mapped extents
+between the forks of two files.  Each operation requires a separate XMI/XMD
+pair.  The log intent item has the following format:
+
+[source, c]
+----
+struct xfs_xmi_log_format {
+     uint16_t                  xmi_type;
+     uint16_t                  xmi_size;
+     uint32_t                  __pad;
+     uint64_t                  xmi_id;
+     uint64_t                  xmi_inode1;
+     uint64_t                  xmi_inode2;
+     uint32_t                  xmi_igen1;
+     uint32_t                  xmi_igen2;
+     uint64_t                  xmi_startoff1;
+     uint64_t                  xmi_startoff2;
+     uint64_t                  xmi_blockcount;
+     uint64_t                  xmi_flags;
+     int64_t                   xmi_isize1;
+     int64_t                   xmi_isize2;
+};
+----
+
+*xmi_type*::
+The signature of an XMI operation, 0x1248.  This value is in host-endian order,
+not big-endian like the rest of XFS.
+
+*xmi_size*::
+Size of this log item.  Should be 1.
+
+*__pad*::
+Must be zero.
+
+*xmi_id*::
+A 64-bit number that binds the corresponding XMD log item to this XMI log item.
+
+*xmi_inode1*::
+Inode number of the first file involved in the operation.
+
+*xmi_inode2*::
+Inode number of the second file involved in the operation.
+
+*xmi_igen1*::
+Generation number of the first file involved in the operation.
+
+*xmi_igen2*::
+Generation number of the second file involved in the operation.
+
+*xmi_startoff1*::
+Starting point within the first file, in units of filesystem blocks.
+
+*xmi_startoff2*::
+Starting point within the second file, in units of filesystem blocks.
+
+*xmi_blockcount*::
+The length to be exchanged, in units of filesystem blocks.
+
+*xmi_flags*::
+Behavioral changes to the operation, as follows:
+
+.File Extent Swap Intent Item Flags
+[options="header"]
+|=====
+| Value				    | Description
+| +XFS_EXCHMAPS_ATTR_FORK+	    | Exchange extents between attribute forks.
+| +XFS_EXCHMAPS_SET_SIZES+	    | Exchange the file sizes of the two files
+after the operation completes.
+| +XFS_EXCHMAPS_INO1_WRITTEN+	    | Exchange the mappings of two files only
+if the file allocation units mapped to file1's range have been written.
+| +XFS_EXCHMAPS_CLEAR_INO1_REFLINK+ | Clear the reflink flag from inode1 after
+the operation.
+| +XFS_EXCHMAPS_CLEAR_INO2_REFLINK+ | Clear the reflink flag from inode2 after
+the operation.
+|=====
+
+*xmi_isize1*::
+The original size of the first file, in bytes.  This is zero if the
++XFS_EXCHMAPS_SET_SIZES+ flag is not set.
+
+*xmi_isize2*::
+The original size of the second file, in bytes.  This is zero if the
++XFS_EXCHMAPS_SET_SIZES+ flag is not set.
+
+[[XMD_Log_Item]]
+=== Completion of File Mapping Exchange
+
+The ``file mapping exchange done'' operation complements the ``file mapping
+exchange intent'' operation.  This second operation indicates that the update
+actually happened, so that log recovery needn't replay the update.  The XMD
+item and the actual updates are typically found in a new transaction following
+the transaction in which the XMI was logged.  The completion has this format:
+
+[source, c]
+----
+struct xfs_xmd_log_format {
+     uint16_t                  xmd_type;
+     uint16_t                  xmd_size;
+     uint32_t                  __pad;
+     uint64_t                  xmd_xmi_id;
+};
+----
+
+*xmd_type*::
+The signature of an XMD operation, 0x1249.  This value is in host-endian order,
+not big-endian like the rest of XFS.
+
+*xmd_size*::
+Size of this log item.  Should be 1.
+
+*__pad*::
+Must be zero.
+
+*xmd_xmi_id*::
+A 64-bit number that binds the corresponding XMI log item to this XMD log item.
+
 [[Inode_Log_Item]]
 === Inode Updates
 
diff --git a/design/XFS_Filesystem_Structure/magic.asciidoc b/design/XFS_Filesystem_Structure/magic.asciidoc
index a343271a..60952aeb 100644
--- a/design/XFS_Filesystem_Structure/magic.asciidoc
+++ b/design/XFS_Filesystem_Structure/magic.asciidoc
@@ -73,6 +73,8 @@ are not aligned to blocks.
 | +XFS_LI_BUD+			| 0x1245        |       | xref:BUD_Log_Item[File Block Mapping Update Done]
 | +XFS_LI_ATTRI+		| 0x1246        |       | xref:ATTRI_Log_Item[Extended Attribute Update Intent]
 | +XFS_LI_ATTRD+		| 0x1247        |       | xref:ATTRD_Log_Item[Extended Attribute Update Done]
+| +XFS_LI_XMI+			| 0x1248        |       | xref:XMI_Log_Item[File Mapping Exchange Intent]
+| +XFS_LI_XMD+			| 0x1249        |       | xref:XMD_Log_Item[File Mapping Exchange Done]
 |=====
 
 = Theoretical Limits

