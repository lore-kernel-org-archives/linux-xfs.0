Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3ED153823
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804019; cv=none; b=DYX4i+P1XmvXFhM1LM5rlTP06BrnL8sYcQgzjKl8yZ81gyZMP4V/cIz4Ihr9462pBXSpNNBbZyLXy3PriBxbmKfmymP9seyzOrNMO5aliYscenbPmTjENmh7Ek7mV0sdLyyXUnQx2BgJfe01p2YGENH71RlsbeJrwbBiEVUHuko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804019; c=relaxed/simple;
	bh=qGFsOEfgcHU4+rSFtBwbYdRJdqBPhF6/elGWXKnS0WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyD1vY2nYIHxTnaNloS/KsYJLjD6jVK6Lv6xVf+MsgaHj9hSRoV5yYdWSoa1nuFuLjLJEyWkdbY3doCa/Uk6QLltM3oL4dJ2YS3sc3ZOmt9QRA1AJp8O8QwzR/K5qD3IARtUdYRi8hDtZArGZNL/SW+dyI1CpJVGSyjTKSUc0+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2mmR2jk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2mmR2jk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5844EC113CC;
	Mon, 22 Apr 2024 16:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804019;
	bh=qGFsOEfgcHU4+rSFtBwbYdRJdqBPhF6/elGWXKnS0WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2mmR2jk5APtmd9OYca/NwrKQu96NSIyXqKQOlxfzukGD8kJiHs3/Oce970R5S5oI
	 0zCQ242mV46IyHmPK2KSfQwl0YSzT+uVUt95bjRxc5HCDyIxS8FPktWKissnxAI7fi
	 M8/UY7n1oXCw0vKSnjweVweoJlMR2kfpRSqXGvo3ZBMzeSzyZFtEtVd0WGbKFMKTlf
	 jDhxNUNVwFbXSolsrGQG8cTUle0F6mB8+zBUVv5vRHs4lXKkF+/ctGYA/UTxCRYqKF
	 cR3TbexbGcqDS1CgPcgJp0UKAwJ+nmfnpRxIY5mbxq38yBzBbV/47fBjbMyiEZnj1v
	 3KzKA3bDPl//A==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 47/67] xfs: also use xfs_bmap_btalloc_accounting for RT allocations
Date: Mon, 22 Apr 2024 18:26:09 +0200
Message-ID: <20240422163832.858420-49-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 58643460546da1dc61593fc6fd78762798b4534f

Make xfs_bmap_btalloc_accounting more generic by handling the RT quota
reservations and then also use it from xfs_bmap_rtalloc instead of
open coding the accounting logic there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/libxfs_priv.h    |  8 +++++++-
 libxfs/xfs_bmap.c       | 21 ++++++++++++++-------
 libxfs/xfs_bmap.h       |  2 ++
 libxfs/xfs_bmap_btree.c |  1 +
 4 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 30ff8dba9..3ba6b0e55 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -434,7 +434,13 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_filestream_select_ag(...)		(-ENOSYS)
 
 /* quota bits */
-#define xfs_trans_mod_dquot_byino(t,i,f,d)		((void) 0)
+
+/* Silence GCC unused variable warning on xfs_bmap.c */
+#define xfs_trans_mod_dquot_byino(t,i,f,d)	({ \
+	uint _f = (f);				   \
+	_f = _f;				   \
+})
+
 #define xfs_trans_reserve_quota_nblks(t,i,b,n,f)	(0)
 
 /* hack too silence gcc */
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index ad058bb12..4f6bd8dff 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3257,10 +3257,14 @@ xfs_bmap_btalloc_select_lengths(
 }
 
 /* Update all inode and quota accounting for the allocation we just did. */
-static void
-xfs_bmap_btalloc_accounting(
+void
+xfs_bmap_alloc_account(
 	struct xfs_bmalloca	*ap)
 {
+	bool			isrt = XFS_IS_REALTIME_INODE(ap->ip) &&
+					(ap->flags & XFS_BMAPI_ATTRFORK);
+	uint			fld;
+
 	if (ap->flags & XFS_BMAPI_COWFORK) {
 		/*
 		 * COW fork blocks are in-core only and thus are treated as
@@ -3285,7 +3289,8 @@ xfs_bmap_btalloc_accounting(
 		 * to that of a delalloc extent.
 		 */
 		ap->ip->i_delayed_blks += ap->length;
-		xfs_trans_mod_dquot_byino(ap->tp, ap->ip, XFS_TRANS_DQ_RES_BLKS,
+		xfs_trans_mod_dquot_byino(ap->tp, ap->ip, isrt ?
+				XFS_TRANS_DQ_RES_RTBLKS : XFS_TRANS_DQ_RES_BLKS,
 				-(long)ap->length);
 		return;
 	}
@@ -3296,10 +3301,12 @@ xfs_bmap_btalloc_accounting(
 	if (ap->wasdel) {
 		ap->ip->i_delayed_blks -= ap->length;
 		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
+		fld = isrt ? XFS_TRANS_DQ_DELRTBCOUNT : XFS_TRANS_DQ_DELBCOUNT;
+	} else {
+		fld = isrt ? XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
 	}
-	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
-		ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT : XFS_TRANS_DQ_BCOUNT,
-		ap->length);
+
+	xfs_trans_mod_dquot_byino(ap->tp, ap->ip, fld, ap->length);
 }
 
 static int
@@ -3373,7 +3380,7 @@ xfs_bmap_process_allocated_extent(
 		ap->offset = orig_offset;
 	else if (ap->offset + ap->length < orig_offset + orig_length)
 		ap->offset = orig_offset + orig_length - ap->length;
-	xfs_bmap_btalloc_accounting(ap);
+	xfs_bmap_alloc_account(ap);
 }
 
 #ifdef DEBUG
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 4b83f6148..f6b73f1ba 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -116,6 +116,8 @@ static inline int xfs_bmapi_whichfork(uint32_t bmapi_flags)
 	return XFS_DATA_FORK;
 }
 
+void xfs_bmap_alloc_account(struct xfs_bmalloca *ap);
+
 /*
  * Special values for xfs_bmbt_irec_t br_startblock field.
  */
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 73ba067df..887ba56f3 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -21,6 +21,7 @@
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_quota_defs.h"
 
 static struct kmem_cache	*xfs_bmbt_cur_cache;
 
-- 
2.44.0

