Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871102;
	b=ucdMdtwEZlhNNSCmBxRuAjrRNBPP07uOkMWs8yVUxywFReX1tKiyKL0IQSikEN+jV+//
	 Eoi8jw7fboRNgd4oJbuqQl0zZ7OhFZkzzw9TIcYy9bwHlL+n9fm5ncb4Ok57va9loeRqx
	 3Z5yOgO8xj+4sw0pJkHAzFXv3i0njf+SJdI4Hpq1GfK7RLRwqOMyXqqeJKhiMbGElaWkW
	 p36flPCUkqDvL0e7t4785r3F8iMk7YnX0TPP0EX2hZ9JkQLeTv6dcDZv0R9PA9JUthLqf
	 XDoOT0qIZabUzz/Hi+tfKTPtUjI4AJIDvdc+glI6yvH4ORYvP9NRIWuxFrHz7pavX2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=aLetgLf/rm2N6n9fxojPTgeCuMADGu1H4pjlxclHpLI=;
	b=sx/bSdWF1m+LJQpkcrsVG3jJ/kTcF8uWQ6UB6Jov0lcImPAP2DVAqqzZthIw9QpGXStg
	 itbwj3kW7E5kPibZt8GVLhOjQ3+2pNvWh9drst3UcE7VfVt+nkzSrTMuKLL0E5bHomm3I
	 tsnwLnrAw1k44CBt0Fhb2JcQCkf02Vofcvc4JllMywBn2dkl6Z12TfVE6lLZL11lLWqNe
	 B+uTMudlzIvKMHqx0DETkKOVbO41WP/uQOLLqZeJrFD4+ymPt9WeZvKjg6sIe9jk8EQyq
	 MeMlPz40CjrmSTW8SOG8oQZVFzlg0pBEMGzX1WFCaS93NmFqYI68urcYNz1AG/k285g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=deMdjyPc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA2E606A330
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=deMdjyPc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C680F1F000D1;
	Mon, 16 Nov 2026 23:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871102;
	bh=aLetgLf/rm2N6n9fxojPTgeCuMADGu1H4pjlxclHpLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=deMdjyPcQcWY1uI8H5yPpCHfDLk2AoTEMG+AdrFYR8H/eua8HeyuUanVfJGFDjNm4
	 hEXzKOrW88NSdSzVoswxFc3ArAQBkZcTwfjSoLbpShHOFmLWD78bVDSNZV1CONJmd8
	 r7GCzZbgda535gkyQApdAm/4lhtEDhEcDCmfBlYzbSjvS7sQtHFZshs9P8CwGX/n7h
	 O1NAJym0KVFu3MckvoUN4j2Nt5fpLSx/REIdek8a4BYbPGzRLVtbYmbBPf9lHCeAp8
	 KS7a4Qy1DbfP+LyKjyhcPamKuOGCq7WsFh4V6ftP+/BO8z2PlzKba+WeHZMI8b0XEP
	 5oR1jJ1a6izzw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 53/59] xfs: check logged btree fork roots fit in the inode fork during recovery
Date: Tue, 17 Nov 2026 10:15:10 +1100
Message-ID: <20261116231707.3625263-54-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A btree format fork is logged as the expanded in-core btree root. Replay
converts it to the compact on-disk root as it copies it into the inode. The
conversion lays the root out using the capacity of the on-disk fork, then copies
as many keys and pointers as the logged root says it holds. Nothing bounds that
record count by what the fork can hold. A logged root that is otherwise
consistent but holds too many records is copied past the end of the fork, into
the rest of the inode cluster buffer.

Reject a logged btree root whose compact on-disk form does not fit within the
inode fork. This uses the same check as the runtime root loaders apply when they
read a root from disk.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_inode_item_recover.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index efb142efa0ef..6920aab9263a 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -478,8 +478,8 @@ xlog_dinode_verify_extents(
  * length is fixed by the record count, so the region size fixes how many
  * records the root can hold.
  *
- * The region size has already been bounds checked against the inode fork size,
- * so it is known to fit within the fork and does not need rechecking here.
+ * The logged root is converted to the compact on-disk root when it is replayed
+ * into the inode, so it is the compact form that must fit within the fork.
  */
 static xfs_failaddr_t
 xlog_dinode_verify_bmbt_root(
@@ -515,6 +515,10 @@ xlog_dinode_verify_bmbt_root(
 	if (numrecs == 0 || size != xfs_bmap_broot_space_calc(mp, numrecs))
 		return __this_address;
 
+	if (xfs_bmdr_space_calc(numrecs) >
+	    __xfs_inode_fork_size(mp, ldip->di_forkoff, whichfork))
+		return __this_address;
+
 	for (i = 1; i <= numrecs; i++) {
 		struct xfs_bmbt_key	*key = xfs_bmbt_key_addr(mp, block, i);
 		xfs_bmbt_ptr_t		*ptr = xfs_bmap_broot_ptr_addr(mp, block,
@@ -578,6 +582,11 @@ xlog_dinode_verify_rtrmap_root(
 	if (size != xfs_rtrmap_broot_space_calc(level, numrecs))
 		return __this_address;
 
+	/* The compact on-disk form of the root must fit within the fork. */
+	if (xfs_rtrmap_droot_space_calc(level, numrecs) >
+	    __xfs_inode_fork_size(mp, ldip->di_forkoff, XFS_DATA_FORK))
+		return __this_address;
+
 	/*
 	 * A leaf root holds records whose bounds are relative to a realtime
 	 * group. The realtime groups are not set up until long after log
@@ -646,6 +655,11 @@ xlog_dinode_verify_rtrefcount_root(
 	if (size != xfs_rtrefcount_broot_space_calc(level, numrecs))
 		return __this_address;
 
+	/* The compact on-disk form of the root must fit within the fork. */
+	if (xfs_rtrefcount_droot_space_calc(level, numrecs) >
+	    __xfs_inode_fork_size(mp, ldip->di_forkoff, XFS_DATA_FORK))
+		return __this_address;
+
 	/*
 	 * A leaf root holds records whose bounds are relative to a realtime
 	 * group. The realtime groups are not set up until long after log
-- 
2.55.0

