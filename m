Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B01925D1E6
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 04:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760415058; cv=none; b=ErDapTGP2Rx0ihpmOi+C2RdywbI8sU1t4H0fH4pm/hnN89yBViElSl9yJIERhdpRvjYSuIHK3j6De6H/W5jPuIK2iXIji3mB2E9opkYPJO0DFDHu1PA2gfW79vU48/jTefI/N4/PXlUkMFoO5F4DINpbuqn4bl5e3OT1RghrRjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760415058; c=relaxed/simple;
	bh=DuEw9oiF5KF1ciq0EAKz4bThfjrYwB1EXSM/t8ZE9n0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=niVuUc/ufHPFxgSOkfd5FH+GCjs/t2bqQtivKFwTw/A7uwwyRnnUCyIZ9Di57Z+KccqlB1bJPFt8llmcjr9+JuRd2Lw2ztZW0woUimnuHdRbsb/3zXNSfMbtnXzhR1mOAjxwTW7PTI7FnIeBUxe5wbvmbeWDdsH3EXZaYpJGqsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XfMmR/zb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XfMmR/zb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6398C4CEE7;
	Tue, 14 Oct 2025 04:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760415057;
	bh=DuEw9oiF5KF1ciq0EAKz4bThfjrYwB1EXSM/t8ZE9n0=;
	h=From:To:Cc:Subject:Date:From;
	b=XfMmR/zbDuxxMtxQBWXaKQyXawvakkPNDQGYn1X2A4jaQoANYnoOmsLDicefCQ7Cq
	 uGhKEXo25ZszqT5Jjg8bn8L3s34cLHpmDWVmjM264lGADPJSe2GMnPPZqsKvDQcYpe
	 mN5Y3850JfFXmwjLLi1XhkOFu+8l4762wHcd2ZcbhJSi1JxgBuO53K63hgUOf37Ra5
	 xD9gtPiUohAmz/AOQUj2e2uhAVo40nmPMM525ucjqv9fhnNSbvGaGWixXWDZinbY41
	 mY2CN9yIFz1IKrhgWIyTe47G+exoYjJzNVMC4B/v23DrspQIKX5Fqep4Wo9AKk+ltJ
	 GshKHl4IojZXg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH v3] xfs: do not tightly pack-write large files
Date: Tue, 14 Oct 2025 13:07:29 +0900
Message-ID: <20251014040729.759700-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When using a zoned realtime device, tightly packing of data blocks
belonging to multiple closed files into the same realtime group (RTG)
is very efficient at improving write performance. This is especially
true with SMR HDDs as this can reduce, and even suppress, disk head
seeks.

However, such tight packing does not make sense for large files that
require at least a full RTG. If tight packing placement is applied for
such files, the VM writeback thread switching between inodes result in
the large files to be fragmented, thus increasing the garbage collection
penalty later when the RTG needs to be reclaimed.

This problem can be avoided with a simple heuristic: if the size of the
inode being written back is at least equal to the RTG size, do not use
tight-packing. Modify xfs_zoned_pack_tight() to always return false in
this case.

With this change, a multi-writer workload writing files of 256 MB on a
file system backed by an SMR HDD with 256 MB zone size as a realtime
device sees all files occupying exactly one RTG (i.e. one device zone),
thus completely removing the heavy fragmentation observed without this
change.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
Changes from v1:
 - Improved commit message
 - Improved code comments
Changes from v2:
 - Fixed typos in the commit message

 fs/xfs/xfs_zone_alloc.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 1147bacb2da8..8b938d5a3b92 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -614,14 +614,25 @@ static inline enum rw_hint xfs_inode_write_hint(struct xfs_inode *ip)
 }
 
 /*
- * Try to pack inodes that are written back after they were closed tight instead
- * of trying to open new zones for them or spread them to the least recently
- * used zone.  This optimizes the data layout for workloads that untar or copy
- * a lot of small files.  Right now this does not separate multiple such
+ * Try to tightly pack small files that are written back after they were closed
+ * instead of trying to open new zones for them or spread them to the least
+ * recently used zone. This optimizes the data layout for workloads that untar
+ * or copy a lot of small files. Right now this does not separate multiple such
  * streams.
  */
 static inline bool xfs_zoned_pack_tight(struct xfs_inode *ip)
 {
+	struct xfs_mount *mp = ip->i_mount;
+	size_t zone_capacity =
+		XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_RTG].blocks);
+
+	/*
+	 * Do not pack write files that are already using a full group (zone)
+	 * to avoid fragmentation.
+	 */
+	if (i_size_read(VFS_I(ip)) >= zone_capacity)
+		return false;
+
 	return !inode_is_open_for_write(VFS_I(ip)) &&
 		!(ip->i_diflags & XFS_DIFLAG_APPEND);
 }
-- 
2.51.0

