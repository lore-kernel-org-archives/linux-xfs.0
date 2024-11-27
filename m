Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2B1C8CE
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 00:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732666777; cv=none; b=j1FJd5x89hLufuu57g5CGehRv2PU/t+TpWtr2ik4Af9gXlyKLf456lV1kbwlld4X9YdL5kodTk1SzFTB4OUj8uHde9EovXI3+uj+fKu+I+gtUWbQGYKjiU33ljwZB/xGj9fgNAExg1K6HFWRAw1x/1LJcRZxZrOlF3yQ9Z1FV0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732666777; c=relaxed/simple;
	bh=IhHD8XpoV3kzwDjfIC15/3ygPjs3+1t+wmvv/TBXTxw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WRrF63HrRXLdmhdA/wwsAJSfp9bO4rXHXF4XC0M1RQgXd1IR4P6ye5+phtOZI70DBxtCjJyq3o9ijGX9qyAyT6yiEel7zSrri2OksCdJX1cPCgwjueSUNM55EwSAEc6nWuS5RGJQ4Pd9ISOQj3B4hbCkVEvvXdNCMrTBjnqzTHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PdRBDDeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PdRBDDeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6689C4CECF;
	Wed, 27 Nov 2024 00:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732666776;
	bh=IhHD8XpoV3kzwDjfIC15/3ygPjs3+1t+wmvv/TBXTxw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PdRBDDeLLJ6e9qwhm9ivU91ijJUzEfGron363t7TZ0IHWXaRs3SgYd4eF36xSALpa
	 NBnYSpoohOFUZCkw/riVf92n38tDQm0MHEQgCrS8Y/FjiEIDjR7HB7IY1oDCpcDBUW
	 nSyE6GlLCtUdSEVHMTkjai6QyEyVWH+ZZw9+2GbM9JMyd0ZNEIcW8RYk1H5cjOzD0K
	 K/C957DuC1Lein+EKncITlG57elnGQIWj4Kvof9mC75dxAHsgm6flr9XM2zkVp8MBG
	 6aDupIjU39ciIj76BaBPSpI4w2KNZqpqYyPmSrtW9hdT3V8gh+mC2rurMSStEQY/fl
	 WQzh10cIp6KHA==
Date: Tue, 26 Nov 2024 16:19:35 -0800
Subject: [PATCH 06/10] design: move discussion of realtime volumes to a
 separate section
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173266662299.996198.2514381239709867329.stgit@frogsfrogsfrogs>
In-Reply-To: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
References: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

In preparation for documenting the realtime modernization project, move
the discussions of the realtime-realted ondisk metadata to a separate
file.  Since realtime reverse mapping btrees haven't been added to the
filesystem yet, stop including them in the final output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 .../allocation_groups.asciidoc                     |   20 --------
 .../internal_inodes.asciidoc                       |   36 +-------------
 design/XFS_Filesystem_Structure/realtime.asciidoc  |   50 ++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              |    2 +
 4 files changed, 54 insertions(+), 54 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/realtime.asciidoc


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index e2cdaab5e03d3f..c746a92ca47dd6 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -772,23 +772,3 @@ core.magic = 0x494e
 
 The chunk record also indicates that this chunk has 32 inodes, and that the
 missing inodes are also ``free''.
-
-[[Real-time_Devices]]
-== Real-time Devices
-
-The performance of the standard XFS allocator varies depending on the internal
-state of the various metadata indices enabled on the filesystem.  For
-applications which need to minimize the jitter of allocation latency, XFS
-supports the notion of a ``real-time device''.  This is a special device
-separate from the regular filesystem where extent allocations are tracked with
-a bitmap and free space is indexed with a two-dimensional array.  If an inode
-is flagged with +XFS_DIFLAG_REALTIME+, its data will live on the real time
-device.  The metadata for real time devices is discussed in the section about
-xref:Real-time_Inodes[real time inodes].
-
-By placing the real time device (and the journal) on separate high-performance
-storage devices, it is possible to reduce most of the unpredictability in I/O
-response times that come from metadata operations.
-
-None of the XFS per-AG B+trees are involved with real time files.  It is not
-possible for real time files to share data blocks.
diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
index eaa0a50aa848f3..68c86d30ff8206 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -287,41 +287,9 @@ Log sequence number of the last DQ block write.
 *dd_crc*::
 Checksum of the DQ block.
 
-
 [[Real-time_Inodes]]
 == Real-time Inodes
 
 There are two inodes allocated to managing the real-time device's space, the
-Bitmap Inode and the Summary Inode.
-
-[[Real-Time_Bitmap_Inode]]
-=== Real-Time Bitmap Inode
-
-The real time bitmap inode, +sb_rbmino+, tracks the used/free space in the
-real-time device using an old-style bitmap. One bit is allocated per real-time
-extent. The size of an extent is specified by the superblock's +sb_rextsize+
-value.
-
-The number of blocks used by the bitmap inode is equal to the number of
-real-time extents (+sb_rextents+) divided by the block size (+sb_blocksize+)
-and bits per byte. This value is stored in +sb_rbmblocks+. The nblocks and
-extent array for the inode should match this.  Each real time block gets its
-own bit in the bitmap.
-
-[[Real-Time_Summary_Inode]]
-=== Real-Time Summary Inode
-
-The real time summary inode, +sb_rsumino+, tracks the used and free space
-accounting information for the real-time device.  This file indexes the
-approximate location of each free extent on the real-time device first by
-log2(extent size) and then by the real-time bitmap block number.  The size of
-the summary inode file is equal to +sb_rbmblocks+ × log2(realtime device size)
-× sizeof(+xfs_suminfo_t+).  The entry for a given log2(extent size) and
-rtbitmap block number is 0 if there is no free extents of that size at that
-rtbitmap location, and positive if there are any.
-
-This data structure is not particularly space efficient, however it is a very
-fast way to provide the same data as the two free space B+trees for regular
-files since the space is preallocated and metadata maintenance is minimal.
-
-include::rtrmapbt.asciidoc[]
+xref:Real-Time_Bitmap_Inode[Bitmap Inode] and the
+xref:Real-Time_Summary_Inode[Summary Inode].
diff --git a/design/XFS_Filesystem_Structure/realtime.asciidoc b/design/XFS_Filesystem_Structure/realtime.asciidoc
new file mode 100644
index 00000000000000..11426e8fdb632d
--- /dev/null
+++ b/design/XFS_Filesystem_Structure/realtime.asciidoc
@@ -0,0 +1,50 @@
+[[Real-time_Devices]]
+= Real-time Devices
+
+The performance of the standard XFS allocator varies depending on the internal
+state of the various metadata indices enabled on the filesystem.  For
+applications which need to minimize the jitter of allocation latency, XFS
+supports the notion of a ``real-time device''.  This is a special device
+separate from the regular filesystem where extent allocations are tracked with
+a bitmap and free space is indexed with a two-dimensional array.  If an inode
+is flagged with +XFS_DIFLAG_REALTIME+, its data will live on the real time
+device.
+
+By placing the real time device (and the journal) on separate high-performance
+storage devices, it is possible to reduce most of the unpredictability in I/O
+response times that come from metadata operations.
+
+None of the XFS per-AG B+trees are involved with real time files.  It is not
+possible for real time files to share data blocks.
+
+[[Real-Time_Bitmap_Inode]]
+== Free Space Bitmap Inode
+
+The real time bitmap inode, +sb_rbmino+, tracks the used/free space in the
+real-time device using an old-style bitmap. One bit is allocated per real-time
+extent. The size of an extent is specified by the superblock's +sb_rextsize+
+value.
+
+The number of blocks used by the bitmap inode is equal to the number of
+real-time extents (+sb_rextents+) divided by the block size (+sb_blocksize+)
+and bits per byte. This value is stored in +sb_rbmblocks+. The nblocks and
+extent array for the inode should match this.  Each real time block gets its
+own bit in the bitmap.
+
+[[Real-Time_Summary_Inode]]
+== Free Space Summary Inode
+
+The real time summary inode, +sb_rsumino+, tracks the used and free space
+accounting information for the real-time device.  This file indexes the
+approximate location of each free extent on the real-time device first by
+log2(extent size) and then by the real-time bitmap block number.  The size of
+the summary inode file is equal to +sb_rbmblocks+ × log2(realtime device size)
+× sizeof(+xfs_suminfo_t+).  The entry for a given log2(extent size) and
+rtbitmap block number is 0 if there is no free extents of that size at that
+rtbitmap location, and positive if there are any.
+
+This data structure is not particularly space efficient, however it is a very
+fast way to provide the same data as the two free space B+trees for regular
+files since the space is preallocated and metadata maintenance is minimal.
+
+include::rtrmapbt.asciidoc[]
diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index 689e2a874c13e9..a643d18add6094 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -84,6 +84,8 @@ include::journaling_log.asciidoc[]
 
 include::internal_inodes.asciidoc[]
 
+include::realtime.asciidoc[]
+
 include::fs_properties.asciidoc[]
 
 :leveloffset: 0

