Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146DF644
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 01:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mmK1eXUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28F2C433C7;
	Mon,  1 Jan 2024 01:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071305;
	bh=s2R0ZsChjS8/dZ0VyhmFovh8/AZPWQsnGwlUGuWLpaQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mmK1eXUkvw+Z6rjgip7bCfESz6B5kPZIWNpz7BASPJoCzsAJgQs6SoXwIoLTAm4b2
	 /RHOVomL0NBoRYRmRIaVoqJjAzsDw1zQLn4yQmpV3R7hbWZYLawI6Pf4F9TJ6H+jBq
	 SqxpMtRi+2yjq0Cp7MRGQskWW8UN7ZR9hqeI/8ZVJJ2JRcRoohB08nSYqGLnQJG7NY
	 q1WymW/B8KaT/JTaJxpSrUnhct4l1clR3ijebIzoVNe/h/tYIMCbr8peUrpXN9hJEM
	 aDqWJpO/FPp/JIvjtHx3XzuXYBKipRA8BPu9xLQ/0xwySDPFIF5FhyWUhwLjfm7/Jr
	 /xIb8S+IZN22Q==
Date: Sun, 31 Dec 2023 17:08:25 +9900
Subject: [PATCH 1/2] design: move discussion of realtime volumes to a separate
 section
From: "Darrick J. Wong" <djwong@kernel.org>
To: darrick.wong@oracle.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405037299.1829872.1512515761534075128.stgit@frogsfrogsfrogs>
In-Reply-To: <170405037287.1829872.4170922148688875113.stgit@frogsfrogsfrogs>
References: <170405037287.1829872.4170922148688875113.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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
---
 .../allocation_groups.asciidoc                     |   20 --------
 .../internal_inodes.asciidoc                       |   36 +-------------
 design/XFS_Filesystem_Structure/realtime.asciidoc  |   50 ++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              |    2 +
 4 files changed, 54 insertions(+), 54 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/realtime.asciidoc


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index bd825207..08151c7c 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -1330,23 +1330,3 @@ core.magic = 0x494e
 
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
index 42020a5f..e07b5f19 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -316,41 +316,9 @@ Log sequence number of the last DQ block write.
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
index 00000000..11426e8f
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
index a95a5806..04cc8e13 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -84,6 +84,8 @@ include::journaling_log.asciidoc[]
 
 include::internal_inodes.asciidoc[]
 
+include::realtime.asciidoc[]
+
 :leveloffset: 0
 
 Dynamically Allocated Structures

