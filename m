Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FF72BE656;
	Thu,  8 Oct 2026 01:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791423571; cv=none; b=G8vhhhsZtHvJsJ1YyXTut5dK4OqylYv+6cdYb1eNFjFkK1aMJD6pz0oZQv0btSoTZa3GOY/r/ngBRpxJHfyyDB4BU+wWvRXSf+uIR9UghdhVWGaPKcpaGTJRm52Gxc/UkaL8m+hrFGRy03QwlyASkS1TBGI9BJeTY/+HFDJgbBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791423571; c=relaxed/simple;
	bh=gRpRwfr6IRPlcJPSvZheJ5frz8gp229SmqlOC8DQx+E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hl6quP1Kfd02Af0OPqxvCPRTNlpWYNX6YcV0tCY95N3tx2RlgUMPc6+j/kGoA20JQt9IZSM4Fche2oHfynQPRK/CBNZM4eSRmnclKTe3nny7BGaeK2agrOEkoM+S57G0sEZjLkABwH6IGftC+OBi/sCClTDvh/NuWPoeqGeD8iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rp/fe6Bg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rp/fe6Bg"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5012AC2BD00;
	Thu,  8 Oct 2026 01:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791423571;
	bh=gRpRwfr6IRPlcJPSvZheJ5frz8gp229SmqlOC8DQx+E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Rp/fe6BgOfXuSSqqJHd5L4S4uP4KrDCR9YDGqm2IBtobY1YoJR1gz3aizcnPqR0cr
	 L9hNMijKEYQrQv7jb4HWQMan7uqtsmrwoqnjaDIw3+3HuDAPaDR3+o61X8aneFZkYi
	 ukIDOYBLXOxmblhlRF4s/LqIuXiayz0LJRccdWPoRmhD3iu9fgsypuHKbHZM60KE3K
	 sR/iOQzVBpL8t/qJDVBNnvnmjdYqXkIxvaEflTQVNnoSc91nN8THEQGgeJFqKauhXq
	 ADqvE6bjWi4MpNtEg50CpdiDF/fyz99IAfJQmvWK6NxFWV0zIAhzr8BJwVqOzo2lBi
	 EMUs+EN+H64OQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD55CA6002;
	Thu,  8 Oct 2026 01:39:31 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 08 Oct 2026 10:39:33 +0900
Subject: [PATCH 4/8] exportfs: let ->map_blocks return more than one
 mapping
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-xfs-nfsd-map-blocks-v1-4-560026cdccb6@samsung.com>
References: <20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
In-Reply-To: <20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
To: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>, 
 Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Christian Brauner <brauner@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791423569; l=4360;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=yfEeM0fY6TrrzCqX9WsIEdqNGlJA7KCjilbR9ng1fjM=;
 b=IqbGK8tsz4w6qRNJuJo2CQXSRLh8yXS7EPv95ssdolp+VxRsrtI9l9b5qntTPSiRE8PIIF8bH
 +CfyMI2I20SCFb0UuSanFxyp9xP/GWaqgxiPxg8UDKQw5jCoZEaSoc+
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com

From: Daejun Park <daejun7.park@samsung.com>

Since commit cc6c40e09d7b ("NFSD/blocklayout: Support multiple extents
per LAYOUTGET"), nfsd calls ->map_blocks once per extent of a block
layout, each time for the range left after the extent before. In XFS,
each call locks the inode, flushes and invalidates its page cache, maps
one extent and unlocks the inode again, and the mapping of the file can
change between the calls. When XFS still mapped whole extents, that
gave layouts whose extents overlapped, see commit 36ca6f11424a ("xfs:
fix overlapping extents returned for pNFS LAYOUTGET"), and nfsd now
trims the start of each extent after the first ("nfsd: do not return
overlapping extents in a block layout").

Let ->map_blocks fill an array of mappings, so that a filesystem can map
the whole range of a layout in one go, under one lock, and make the
mappings fit together: the first one contains the offset asked for, and
each further one starts where the one before it ends. Document as well
that the offset and the length come from the client unchecked, and what
the array holds on error. Only the interface changes here: XFS fills one
mapping, and nfsd asks for one at a time.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Suggested-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20260519145949.GH9555@frogsfrogsfrogs
Link: https://lore.kernel.org/r/20261007131133.GB30647@lst.de
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/nfsd/blocklayout.c          |  4 +++-
 fs/xfs/xfs_pnfs.c              |  6 ++++--
 include/linux/exportfs_block.h | 14 ++++++++++----
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index 1aabae0033..cedaf0e15d 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -30,11 +30,13 @@ nfsd4_block_map_extent(struct inode *inode, const struct svc_fh *fhp,
 {
 	struct super_block *sb = inode->i_sb;
 	struct iomap iomap;
+	unsigned int nr_iomaps = 1;
 	u32 device_generation = 0;
 	int error;
 
 	error = sb->s_export_op->block_ops->map_blocks(inode, offset, length,
-			&iomap, iomode != IOMODE_READ, &device_generation);
+			&iomap, &nr_iomaps, iomode != IOMODE_READ,
+			&device_generation);
 	if (error) {
 		if (error == -ENXIO)
 			return nfserr_layoutunavailable;
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 88d9c3c043..055e6fb299 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -121,7 +121,8 @@ xfs_fs_map_blocks(
 	struct inode		*inode,
 	loff_t			offset,
 	u64			length,
-	struct iomap		*iomap,
+	struct iomap		*iomaps,
+	unsigned int		*nr_iomaps,
 	bool			write,
 	u32			*device_generation)
 {
@@ -238,7 +239,8 @@ xfs_fs_map_blocks(
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
-	error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0, 0, seq);
+	error = xfs_bmbt_to_iomap(ip, iomaps, &imap, 0, 0, seq);
+	*nr_iomaps = 1;
 	*device_generation = mp->m_generation;
 	return error;
 out_unlock:
diff --git a/include/linux/exportfs_block.h b/include/linux/exportfs_block.h
index 21e61fc012..1d0b0abbd3 100644
--- a/include/linux/exportfs_block.h
+++ b/include/linux/exportfs_block.h
@@ -44,12 +44,18 @@ struct exportfs_block_ops {
 	/*
 	 * Map blocks for direct block access.
 	 * If @write is %true, also allocate the blocks for the range if needed.
-	 * The mapping returned must contain @offset. It may start before
-	 * @offset and may end before or after @offset + @len.
+	 * @offset and @len come from the client: @offset may be negative or at
+	 * or past the maximum file size, and @offset + @len may overflow.
+	 * Fill in at most *@nr_iomaps mappings, which is at least one, and on
+	 * success set *@nr_iomaps to the number filled in, at least one. On
+	 * error, the mappings and *@nr_iomaps are undefined. The first mapping
+	 * must contain @offset and may start before it. Each further mapping
+	 * must start where the one before it ends. The last one may end before
+	 * or after @offset + @len.
 	 */
 	int (*map_blocks)(struct inode *inode, loff_t offset, u64 len,
-			struct iomap *iomap, bool write,
-			u32 *device_generation);
+			struct iomap *iomaps, unsigned int *nr_iomaps,
+			bool write, u32 *device_generation);
 
 	/*
 	 * Commit blocks previously handed out by ->map_blocks and written to by

-- 
2.43.0


