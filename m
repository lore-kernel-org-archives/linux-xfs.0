Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465727;
	b=z+7hxHAGyxkQu15HYCiv8rRJkKC5op0BHuwyjBy9Gb4METJGSlQkKVbuXYEyKH2tij2f
	 aRWwQFMLTCYBq7qhmL3VtXvc3x5kQujjsbb79kRE2QVT054y+5JUDfC4oWGp5svAc7r45
	 RNye26OEjHQF8Sg2RftPWn7/suYdmAL5q/+MJHNLkAOz7OqUZN360RbZkdV5yM8AVfq8K
	 vLZswCDON+iZafH+y8G58VgU1DcAunmrac1iyFmuXkY7N0Orhls0+UY9WeOWHQELk6cVg
	 2wXCHPRdIBt5L0E0+o57JrB3+Jj9fZ1gR0gpzCWxCuHdrAKWlykibEpwKy/vzxww0dQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465727;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=xTAaZm8z237tbVsE73/vOrMvUznMWOKNs1DvgC/tVG0=;
	b=vI78uFth/LJ4JoaWfxU5vVZq62zOQb0r/EWjXWnRo4NxEX9s2XuujmFPkq8OQgIlsXyL
	 Q0Phn1MZK9WmhU+nMG1xYF3qs6XI39qrRbUrwc/ka/BQ97byBtSlIqPBIcdatZbLTdreo
	 CfNNzFgHilE6MVoozPm8bfUO/SMb0YtJEC07vV2t/A52dawhnnT09ZZPtPDU5zMRwVxHV
	 Awq0iaVPuz+qhiPx/U4desFJnsosYG6D04fHaZawcoWivwLqsdsDbwaJkZlSJdqI5uytj
	 AKoAIM+HkYuUmZcqg0S70J/nGz/cSQM9jcPcrecgLSsS5bSzryc0OCYwE5Secny19FA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="lvyq4R1/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD00D606A319;
	Tue, 20 Oct 2026 03:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lvyq4R1/
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465726;
	b=ppby/bNwph2PzzUIywEOFah2bRppfYId0sG0shMOzwTo9SZyrs5uyIsFdk06NiJrup8Q
	 kB2jvNBiRqdsgGLnlNcV/70LOOgtEpQz+FoG/p+TEDTUt+jAx0MGPrg+jTrNvZs2h7pNP
	 sQw499NpboUwv+NYZvFGbTi/Me/Q3nDq9m8jFnDU/dIlDMbVsZzjX63OM+f0z0PxevfrP
	 NEcH/9buoL2CpWARlS71tPOYS8GmZ2Hv8PSGnftG+jGQ7KhIik2vws0t/5QSmJmeDtf22
	 ecZ61wktzKNh+n2S9iqsoR9Pd56N7HmxbQdbIgPrpvHs/agBsMrx2EEYG9qylpiKBYg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465726;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=xTAaZm8z237tbVsE73/vOrMvUznMWOKNs1DvgC/tVG0=;
	b=NIDwghuw7fiBhcTzqkajtdHojuZJrOJ44g8U27M4rHdgvDoQDr6RBz9ga6W1PdOWBQG+
	 VSqRcOtvdqKlQxOfp6U2+audRxBtBs2RRbqYmOhfyM0hsSiUrVdY3r1GgzldEwaNu5SLT
	 GZg4qUK8fU6xuioJYwu4iuO7ptkc/f0VahAZFpUrBHSaC/RlI4TV5VDW+Yg+3alzqpyEE
	 0UuUdNaRK+7jETFzJoBz3Ub/d3IGTNSaOyb76Sesl6WwkNl6mSNiUhxTLT9ASwCG5OF23
	 3vo0Em+9bbjaXBDiGcb7o15deC/qgDaF5Nr0JdMGEw2/hjuA3lNBya5FybBhO+xQctA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7E60D1F000C5;
	Tue, 20 Oct 2026 03:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465726;
	bh=xTAaZm8z237tbVsE73/vOrMvUznMWOKNs1DvgC/tVG0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=lvyq4R1/uADh3u/2pcOiqxeguraKX3vzK6U9pEy6OYJFqWjqsqmvgU/NZtiCtoHbI
	 +3JbdIloiUzblHt8cTk9jqPvCUv056p2tvv/xnLGXyG96l8lMP/EFqmbqitDCp80Jv
	 1j2zVDMvf2ntjqhHwPjUHidiI2jAEd46NcONauz7kImkkKTx2YLcRzzKeaokFufPCL
	 CEu3AAL7AgrsH5HNKxAkBV8msQNGelSKGgKVDlaLdWP1RDLTM/RlgXkkmHAShWK7Ns
	 7nNsWUvXMNnkqA9J3Jrxd1DqH1l3WTdQJv03w63g8n9G6nBa8Ag0Xr+LHW32i3RCp7
	 erxsv3+E4/BZw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D8D0F40724;
	Tue, 20 Oct 2026 03:08:44 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 20 Oct 2026 12:08:44 +0900
Subject: [PATCH v4 1/9] xfs: mark the inode preallocated for pNFS write
 layouts past EOF
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261020-xfs-pnfs-batch-v4-1-9230fa2ca4a4@samsung.com>
References: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
In-Reply-To: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465723; l=4923;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=it5adWS9VVvPuY0ITgRqYR086T8ESLe2HmaMPU312mg=;
 b=6/A0c+NxAsvLwkMk6jhP36UTYjdpBwysLDUm7rqRWDSOqTh5qjbCB7LGrrgDCGevd/GPefLSd
 058TR9Xc1+CBJOhKykfGapewtIMEMM7vYYvyhN5tlM7tIWKU5Z9do+j
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

xfs_fs_map_blocks() marks the inode XFS_DIFLAG_PREALLOC after it
allocates blocks for a write layout, so that xfs_free_eofblocks() does
not free blocks past EOF that a client may write to. But a write layout
for a range past EOF where blocks are already allocated, such as the
speculative preallocation of buffered writes, gets those blocks without
an allocation, and the inode is not marked. blockgc, or the release of
the file, then frees them without breaking the layout. The client still
writes to them, and they may belong to another file by then.

With pynfs as the client, a file grown to 1 MiB by two buffered writes
on the server had 960 KiB preallocated past EOF, and an RW LAYOUTGET for
that range got it as one INVALID_DATA extent, without the inode being
marked. About 300 seconds later, with the default
speculative_prealloc_lifetime, blockgc freed those blocks while the
layout was still held. When the client then wrote through the layout and
sent LAYOUTCOMMIT, xfs_fs_commit_blocks() found a hole where the
unwritten extent had been, and xfs_iomap_write_unwritten() allocated for
it with no blocks reserved:

  XFS (nvme0n1): Corruption of in-memory data (0x8) detected at
    xfs_trans_mod_sb+0x817/0x960 (fs/xfs/xfs_trans.c:351).
    Shutting down filesystem.
  ...
   xfs_trans_mod_sb+0x817/0x960
   xfs_alloc_vextent_finish+0x2e7/0x990
   xfs_alloc_vextent_start_ag+0x25d/0x720
   xfs_bmap_btalloc+0xdd2/0x1720
   xfs_bmapi_allocate+0x197/0xf90
   xfs_bmapi_write+0x4d0/0xb60
   xfs_iomap_write_unwritten+0x307/0x7e0
   xfs_fs_commit_blocks+0x1d9/0x630
   nfsd4_block_proc_layoutcommit+0x5c2/0x7d0
   nfsd4_layoutcommit+0x4b5/0xa20

The client got NFS4ERR_IO, in six runs out of six. When small files were
written on the server after blockgc, with a sync first so that the freed
extents were no longer busy, they got those blocks, and the client's
write through the layout replaced 978944 bytes of their data before the
LAYOUTCOMMIT. A LAYOUTGET and LAYOUTCOMMIT 30 seconds apart, before
blockgc runs, leave the client's data in place.

Mark the inode also when a write mapping ends past EOF and nothing was
allocated, the same way as for an allocation, before the blocks are
handed out. With this, the same test keeps the blocks past blockgc, and
the LAYOUTCOMMIT after 360 seconds succeeds with the data in place.

To share the update with the allocation case, set a local update_inode
flag in both cases, call xfs_fs_map_update_inode() in one place below
them, and move the log force into xfs_fs_map_update_inode().

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Reported-by: Chuck Lever <cel@kernel.org>
Link: https://lore.kernel.org/r/4de5356f-bc4d-4f1a-9c81-fce09b1b46fd@slotpi15m67
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_pnfs.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index ab38561700..a9f0b472f3 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -110,7 +110,15 @@ xfs_fs_map_update_inode(
 	ip->i_diflags |= XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	if (error)
+		return error;
+
+	/*
+	 * Force the log so that the blocks handed out to the client are
+	 * guaranteed to be present even after a server crash.
+	 */
+	return xfs_log_force_inode(ip);
 }
 
 /*
@@ -134,6 +142,7 @@ xfs_fs_map_blocks(
 	uint			lock_flags;
 	int			error = 0;
 	u64			seq;
+	bool			update_inode = false;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -221,20 +230,27 @@ xfs_fs_map_blocks(
 				end_fsb - offset_fsb, 0, &imap, &seq);
 		if (error)
 			goto out_unlock;
+		update_inode = true;
+	} else {
+		xfs_iunlock(ip, lock_flags);
 
 		/*
-		 * Ensure the next transaction is committed synchronously so
-		 * that the blocks allocated and handed out to the client are
-		 * guaranteed to be present even after a server crash.
+		 * Blocks past EOF that were allocated for buffered writes, such
+		 * as speculative preallocation, can be freed by
+		 * xfs_free_eofblocks() without breaking the layout unless the
+		 * inode is marked as preallocated. Mark it before handing them
+		 * out for writing, as for blocks allocated above.
 		 */
+		if (write && !(ip->i_diflags & XFS_DIFLAG_PREALLOC) &&
+		    imap.br_startoff + imap.br_blockcount >
+		    XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
+			update_inode = true;
+	}
+
+	if (update_inode) {
 		error = xfs_fs_map_update_inode(ip);
-		if (!error)
-			error = xfs_log_force_inode(ip);
 		if (error)
 			goto out_unlock;
-
-	} else {
-		xfs_iunlock(ip, lock_flags);
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 

-- 
2.43.0


