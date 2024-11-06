Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2936420BB28
	for <linux-xfs@vger.kernel.org>; Wed,  6 Nov 2024 19:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920735; cv=none; b=SqoGJEkIxFpTz0/eYncWnC/7ILLqTgYRoYPYYEsNfbkWjKa9Z+cbSBrAEadKkbObyCxoD4Uq2OjMo4N/KY4QqNfTsuBiX6GpanHFYM3nK9s7h3u3fvPN9P6gw5gBGoY0eb4gvWq2BijMX0Ke7SoIeX31hZowqWuoIINcoKgTeCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920735; c=relaxed/simple;
	bh=GI3FqCoYL7I94EIiQlSQ0syfkomGo3A60TH+sCeygk8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H8UE8ukQKk6zumWvyAp6xnJmwCsAcY8MrLD1vIX8bOXkwjMsRFgT2fxfx0YaWNkrmxLYTA4WSPTFfe6VKE3TjoMc8wHT9sKPoCJGLfTdd0ZJaE3Ba/by8AKXS/VaK6UOz3uFGlXKbzixw6MTFxGaVJstp5FAdr3l/wW1qrN8itQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IBPgzYjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IBPgzYjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A018DC4CEC6;
	Wed,  6 Nov 2024 19:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730920734;
	bh=GI3FqCoYL7I94EIiQlSQ0syfkomGo3A60TH+sCeygk8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IBPgzYjL81ZCfQjQ7ro1ua9lPjzTX3YiGchI60I2i0WaIXS4zr2qXKNA7ZDHEa6VE
	 Nf6KHcyW9VMTUe6Xxus2dY87xBhvOlU4mTcOmJQxCDjH0C9MaJQPjoXnUbkaM3iR2H
	 izV8d27Q6c/Y5hAYlxH/jr+dHsJy9P8i2RDmRSuCW94NwH/ZY+a5SexOhZh+7Cw8a2
	 oov3IWGzHjCVmRvQX/bRVkxV3MLLATc+VjBumE+5QkMigCyDAx/PJ79eT5iXa5OMLP
	 XQZLYLtg9/DcoT3963yPHuDj4ohZY78L/hnuxFZBBtkj2jY0WE1FZxKp5gnjdCHJy7
	 wU/oi9LwZM1Ww==
Date: Wed, 06 Nov 2024 11:18:54 -0800
Subject: [PATCH 1/4] design: move discussion of realtime volumes to a separate
 section
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173092059714.2883258.9567907120205476743.stgit@frogsfrogsfrogs>
In-Reply-To: <173092059696.2883258.7093773656482973762.stgit@frogsfrogsfrogs>
References: <173092059696.2883258.7093773656482973762.stgit@frogsfrogsfrogs>
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
index ec59519dc2ffc1..5d560073d146ff 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -1322,23 +1322,3 @@ core.magic = 0x494e
 
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

