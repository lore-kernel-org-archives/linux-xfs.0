Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572B72848AA
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 06:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760338121; cv=none; b=T3WgEx26+uh4nB4vaER5V4g9qxvas03M3gk7RLGXmFEEVCMD/CkRvHzhJ7IpqBZIClJ6/GkBOPyzIxcLI97kGfCZ/ldHiLdDW1epsGxrkeHx3Nc4IjGdUz7iijJFmrP+u8qeT/nHUcztn7R+Lcq0ZedWR8B4k8tyH6cfLgmuhOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760338121; c=relaxed/simple;
	bh=f46r95CykPvHOj5Z/xQ1YZzkZM2uliPEet9tHzqz7oI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mNuwd2RQDgOHO/zga+p2verjjrsIJr2omruEimjwSSgB4rsoqS6Swskmfey7p9rPHF2iq3B/T1P0sZx6e1dICAbeVhlU/E2pIpxaR/qWdY2Ht/8jetRIZoX4Ze+ABDrqGtC3BXGakt16Zpfx/bzVCJzngEMnb/S/ZBvm2NqzKJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eIhK3JQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eIhK3JQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305ABC4CEE7;
	Mon, 13 Oct 2025 06:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760338120;
	bh=f46r95CykPvHOj5Z/xQ1YZzkZM2uliPEet9tHzqz7oI=;
	h=From:To:Cc:Subject:Date:From;
	b=eIhK3JQVZIc3FxyPXXD8vZ8KVPNqjJrhosGzASwT7G+CjxtOHhLpVmR6iSHRjvkKR
	 R/ukP28GA33Ejs6v1992bzWTs11aciac2vDvUP36cMEPMUNk/bPwUarMQ5fA8IVgZJ
	 +HF/QrqYzpX2aU/QRj7eXaEteKocr0ngzEUkkSkP/N1IJLDdWupJgeTe7YX57IFzKt
	 IQJjMS0B1DwY+OrdNWl07zPB+zd+f35VnJ+RC3eABrckLTbRHsZ7n8RtrdF/fx7+uc
	 owJj+r98lKBiRuo9slOM+6qrD4OPq7LPt4UlrMt+6Wq0Pfsv8gDIeB9/Ucqybc99UP
	 Hds8Vbjcsp4xQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH] xfs: do not tight-pack write large files
Date: Mon, 13 Oct 2025 15:45:12 +0900
Message-ID: <20251013064512.752089-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The tick-packing data block allocation which writes blocks of closed
files in the same zone is very efficient at improving write performance
on HDDs by reducing, and even suppressing, disk head seeks. However,
such tight packing does not make sense for large files that require at
least a full realtime block group (i.e. a zone). If tight-packing
placement is applied for such files, the VM writeback thread switching
between inodes result in the large file to be fragmented, thus
increasing the garbage collection penalty later when the used realtime
block group/zone needs to be reclaimed.

This problem can be avoided with a simple heuristic: if the size of the
inode being written back is at least equal to the realtime block group
size, do not use tight-packing. Modify xfs_zoned_pack_tight() to always
return false in this case.

With this change, a multi-writer workload writing files of 256 MB on a
file system backed by an SMR HDD with 256 MB zone size sees all files
occupying exactly one zone, thus completely removing the heavy
fragmentation observed without this change.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/xfs_zone_alloc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 1147bacb2da8..c51788550c7c 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -622,6 +622,17 @@ static inline enum rw_hint xfs_inode_write_hint(struct xfs_inode *ip)
  */
 static inline bool xfs_zoned_pack_tight(struct xfs_inode *ip)
 {
+	struct xfs_mount *mp = ip->i_mount;
+	size_t zone_capacity =
+		XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_RTG].blocks);
+
+	/*
+	 * Do not pack tight large files that are already using a full group
+	 * (zone) to avoid fragmentation.
+	 */
+	if (i_size_read(VFS_I(ip)) >= zone_capacity)
+		return false;
+
 	return !inode_is_open_for_write(VFS_I(ip)) &&
 		!(ip->i_diflags & XFS_DIFLAG_APPEND);
 }
-- 
2.51.0

