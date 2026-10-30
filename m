Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=71.18.227.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793365054;
	b=U8Uk38QwND7TcZKD3K3aiOKOrpZmkUWuE5HMbn4abf7jlQyJx4Y2X/PfhIxywXmH/kNC
	 YZCM6RPW/bepyFRfjUQaCJrTSdQ9QVDd+JA6U7ZP7YtcCFWWeBKn/UF8upEepdsbroVyw
	 KKshWW3KGNqSBvFuY2MUEklpDm8R4/bHJocCw4a0oX1fybzS+KBAUN+TBW5xKRkB+vqGO
	 /0GafPDuOC3O5r0UmSFJfzI9OFm8SvPhn9V/0EnTtAdczToeV87jfsWygMCbuaDuMk2mQ
	 aRhYNWsrcqQ2053mjmIaDBmJ3i5nSHQT63gbWXIGtw1yMyp2TCpWyK6JTlk1H8JkIyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793365054;
	h=DMARC-Filter:DKIM-Signature:X-Lms-Return-Path:X-Change-Id:Message-Id:
	 Mime-Version:X-Original-From:Content-Type:Content-Transfer-Encoding:
	 X-Mailer:To:Date:Received:X-B4-Tracking:Cc:From:Subject;
	bh=pt1EE/0NvKcVIqhZlnu4zuvBTQKHqlHI1QUxk7PDmpo=;
	b=Z+TDj8vBVLRmEAiVwJQmw2CYNITw9whOxe3VkPA0JujWqxtFGTeNtvPurHXZPBhx6Bwf
	 m4Ku8HwmGh992YJjBanIPoaEgtetxyDQzsigJ/OUF3i2DQ4KgJXuHmd6vLdFuCjCyEDWv
	 i4/ahtlyJge7Ve/rcblI3BVTmG2E1sc/0No/DKZxYvXqEHAK4eN69jJbPeMYjsfbdErUW
	 vRTj05T9R8Mp3+sClwFElk0UF+CKV76Sj8IMR+nk+TIUTxWy8nUL9e3kQG2mF6zq5VBRF
	 uKlMl/9pUWuekBVZNEEYffovUXmKEa539WJJ5+xsRkI2itRdPxC7OdoQkAkgHbHMtxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cherr.cc;
	spf=pass smtp.mailfrom=cherr.cc;
	dkim=pass header.d=cherr.cc header.i=@cherr.cc header.a=rsa-sha256 header.s=feishu2604220257 header.b=2AIDHfVD;
	arc=none smtp.remote-ip=71.18.227.2
Received: from sg-2-2.ptr.blmpb.com (sg-2-2.ptr.blmpb.com [71.18.227.2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5701606A31D
	for <linux-xfs@vger.kernel.org>; Fri, 30 Oct 2026 12:57:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5701606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cherr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cherr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cherr.cc header.i=@cherr.cc header.a=rsa-sha256 header.s=feishu2604220257 header.b=2AIDHfVD
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2604220257; d=cherr.cc; t=1793365041; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=pt1EE/0NvKcVIqhZlnu4zuvBTQKHqlHI1QUxk7PDmpo=;
 b=2AIDHfVDZ+1cI14e3FsouZtQeiZOmJGF+7jR2Eh+jw6RucnCY5Z4iq6Axf/x86QWPtBCpU
 93qIsxXslOmW9+d4d6nD1yoyxZd6GpR6UFxfDsVMT9fHsgg/laJ7u6TRzKNOMKddPATjbK
 C1ljPgNiwBiqjOPEkOdWdPt1aTnZwrLzWYZfDLb0YmZ8NLFlz7AAluYYO7j1CmlYAK0/Qb
 HnruKbw5xMFYLtMXKjvn6yPIzYjHJRDY1yfuhPpOXJUjxn/uY4nI5+lpsPnxLEK3SD2IMH
 seEDji4tVC4wk/kYMxex/wPEgw6DVnxPzjsT7c2ADKpCHrOrT+4g+Rsi8YbsUg==
X-Lms-Return-Path: <lba+26ae4942f+9e6ebb+vger.kernel.org+me@cherr.cc>
X-Change-Id: 20261029-b4-xfs-dirent-leaf-validation-76c3d3792142
Message-Id: <20261030-b4-xfs-dirent-leaf-validation-v1-1-b245247b048f@cherr.cc>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Original-From: Shengzhuo Wei <me@cherr.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
To: "Carlos Maiolino" <cem@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>
Date: Fri, 30 Oct 2026 20:57:14 +0800
Received: from [127.0.1.1] ([111.42.148.156]) by smtp.feishu.cn with ESMTPS; Fri, 30 Oct 2026 20:57:18 +0800
X-B4-Tracking: v=1; b=H4sIACmU5GoC/yXMQQqDMBBA0avIrDtgRlHsVaSLmEzaKZJKJhVBv HtTXb7F/zsoJ2GFe7VD4lVUPrHA3CpwLxufjOKLgWrqTE0DTi1uQdFL4phxZhtwtbN4m0uJfec a3/QDmZagPJbEQbbzPz4u63d6s8v/KRzHD042pCaBAAAA
Cc: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<stable@vger.kernel.org>, "Shengzhuo Wei" <me@cherr.cc>
From: "Shengzhuo Wei" <me@cherr.cc>
Subject: [PATCH] xfs: fix out-of-bounds accesses through directory leaf pointers

Leaf pointers are not checked against entry boundaries in the referenced
data blocks.  Crafted pointers can cause out-of-bounds name-length reads,
name comparisons of up to 255 bytes, and one-byte file type or two-byte
free-space tag writes during replace or remove operations.

Check entry bounds, name length and trailing tags before lookup uses an
entry.  Self-consistent fake entries can still pass, so also bound the
free-space neighbors merged by xfs_dir2_data_make_free().  Clear buffer
references transferred from the lookup state to avoid double release on
errors.

Cc: stable@vger.kernel.org
Signed-off-by: Shengzhuo Wei <me@cherr.cc>
---
This bug may date back to the introduction of XFS into mainline; the
exact introducing commit has not been confirmed.  We reproduced the
out-of-bounds behavior with KASAN on both Linux 4.0 and current mainline.
---
 fs/xfs/libxfs/xfs_dir2_data.c | 41 ++++++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_dir2_leaf.c | 14 +++++++++++---
 fs/xfs/libxfs/xfs_dir2_node.c | 19 ++++++++++++++++---
 fs/xfs/libxfs/xfs_dir2_priv.h |  3 +++
 4 files changed, 66 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index aecbab61014c..5823d4bf84cd 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -892,15 +892,20 @@ xfs_dir2_data_make_free(
 	 * If this isn't the start of the block, then back up to
 	 * the previous entry and see if it's free.
 	 */
+	prevdup = NULL;
 	if (offset > args->geo->data_entry_offset) {
 		__be16			*tagp;	/* tag just before us */
 
 		tagp = (__be16 *)((char *)hdr + offset) - 1;
-		prevdup = (xfs_dir2_data_unused_t *)((char *)hdr + be16_to_cpu(*tagp));
-		if (be16_to_cpu(prevdup->freetag) != XFS_DIR2_DATA_FREE_TAG)
+		if (be16_to_cpu(*tagp) >= args->geo->data_entry_offset &&
+		    be16_to_cpu(*tagp) < offset)
+			prevdup = (xfs_dir2_data_unused_t *)
+				((char *)hdr + be16_to_cpu(*tagp));
+		if (prevdup &&
+		    (be16_to_cpu(prevdup->freetag) != XFS_DIR2_DATA_FREE_TAG ||
+		     be16_to_cpu(*tagp) + be16_to_cpu(prevdup->length) != offset))
 			prevdup = NULL;
-	} else
-		prevdup = NULL;
+	}
 	/*
 	 * If this isn't the end of the block, see if the entry after
 	 * us is free.
@@ -908,7 +913,8 @@ xfs_dir2_data_make_free(
 	if (offset + len < end) {
 		postdup =
 			(xfs_dir2_data_unused_t *)((char *)hdr + offset + len);
-		if (be16_to_cpu(postdup->freetag) != XFS_DIR2_DATA_FREE_TAG)
+		if (be16_to_cpu(postdup->freetag) != XFS_DIR2_DATA_FREE_TAG ||
+		    offset + len + be16_to_cpu(postdup->length) > end)
 			postdup = NULL;
 	} else
 		postdup = NULL;
@@ -1036,6 +1042,31 @@ xfs_dir2_data_make_free(
 	*needscanp = needscan;
 }
 
+xfs_failaddr_t
+xfs_dir2_data_check_entry(struct xfs_da_args *args, struct xfs_buf *bp,
+			  xfs_dir2_data_aoff_t off)
+{
+	struct xfs_dir2_data_entry	*dep;
+	struct xfs_da_geometry		*geo = args->geo;
+	struct xfs_mount		*mp = args->dp->i_mount;
+	struct xfs_dir2_data_hdr	*hdr = bp->b_addr;
+
+	if (!xfs_dir3_data_end_offset(geo, hdr) ||
+	    off < geo->data_entry_offset ||
+	    off > xfs_dir3_data_end_offset(geo, hdr) -
+		  xfs_dir2_data_entsize(mp, 1))
+		return __this_address;
+
+	dep = (struct xfs_dir2_data_entry *)((char *)hdr + off);
+	if (!dep->namelen ||
+	    off + xfs_dir2_data_entsize(mp, dep->namelen) >
+		  xfs_dir3_data_end_offset(geo, hdr) ||
+	    be16_to_cpu(*xfs_dir2_data_entry_tag_p(mp, dep)) != off)
+		return __this_address;
+
+	return NULL;
+}
+
 /* Check our free data for obvious signs of corruption. */
 static inline xfs_failaddr_t
 xfs_dir2_data_check_free(
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index bc909543eb74..87b94ad6d304 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1277,6 +1277,7 @@ xfs_dir2_leaf_lookup_int(
 	int			error;		/* error return code */
 	int			index;		/* index in leaf block */
 	struct xfs_buf		*lbp;		/* leaf buffer */
+	xfs_dir2_data_aoff_t	off;		/* offset of the data entry */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_mount_t		*mp;		/* filesystem mount point */
@@ -1340,9 +1341,16 @@ xfs_dir2_leaf_lookup_int(
 		/*
 		 * Point to the data entry.
 		 */
-		dep = (xfs_dir2_data_entry_t *)((char *)dbp->b_addr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(lep->address)));
+		off = xfs_dir2_dataptr_to_off(args->geo,
+					      be32_to_cpu(lep->address));
+		if (xfs_dir2_data_check_entry(args, dbp, off)) {
+			xfs_buf_mark_corrupt(lbp);
+			xfs_da_mark_sick(args);
+			xfs_trans_brelse(tp, dbp);
+			xfs_trans_brelse(tp, lbp);
+			return -EFSCORRUPTED;
+		}
+		dep = (xfs_dir2_data_entry_t *)((char *)dbp->b_addr + off);
 		/*
 		 * Compare name and if it's an exact match, return the index
 		 * and buffer. If it's the first case-insensitive match, store
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 19cb536e53ef..c3964a843024 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -796,6 +796,7 @@ xfs_dir2_leafn_lookup_for_entry(
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return value */
 	int			index;		/* leaf entry index */
+	xfs_dir2_data_aoff_t	off;		/* offset of the data entry */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_mount_t		*mp;		/* filesystem mount point */
@@ -827,6 +828,10 @@ xfs_dir2_leafn_lookup_for_entry(
 	if (state->extravalid) {
 		curbp = state->extrablk.bp;
 		curdb = state->extrablk.blkno;
+		if (args->cmpresult == XFS_CMP_DIFFERENT) {
+			state->extravalid = 0;
+			state->extrablk.bp = NULL;
+		}
 	}
 	/*
 	 * Loop over leaf entries with the right hash value.
@@ -880,9 +885,17 @@ xfs_dir2_leafn_lookup_for_entry(
 		/*
 		 * Point to the data entry.
 		 */
-		dep = (xfs_dir2_data_entry_t *)((char *)curbp->b_addr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(lep->address)));
+		off = xfs_dir2_dataptr_to_off(args->geo,
+					      be32_to_cpu(lep->address));
+		if (xfs_dir2_data_check_entry(args, curbp, off)) {
+			xfs_buf_mark_corrupt(bp);
+			xfs_da_mark_sick(args);
+			if (args->cmpresult == XFS_CMP_DIFFERENT ||
+			    curdb != state->extrablk.blkno)
+				xfs_trans_brelse(tp, curbp);
+			return -EFSCORRUPTED;
+		}
+		dep = (xfs_dir2_data_entry_t *)((char *)curbp->b_addr + off);
 		/*
 		 * Compare the entry and if it's an exact match, return
 		 * EEXIST immediately. If it's the first case-insensitive
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 10041350274a..d3c93e888a1f 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -68,6 +68,9 @@ uint8_t xfs_dir2_data_get_ftype(struct xfs_mount *mp,
 		struct xfs_dir2_data_entry *dep);
 void xfs_dir2_data_put_ftype(struct xfs_mount *mp,
 		struct xfs_dir2_data_entry *dep, uint8_t ftype);
+xfs_failaddr_t xfs_dir2_data_check_entry(struct xfs_da_args *args,
+					 struct xfs_buf *bp,
+					 xfs_dir2_data_aoff_t off);
 
 #ifdef DEBUG
 extern void xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);

---
base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
change-id: 20261029-b4-xfs-dirent-leaf-validation-76c3d3792142

Best regards,
--  
Shengzhuo Wei <me@cherr.cc>
