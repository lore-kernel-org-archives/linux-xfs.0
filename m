Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A41F79C5
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295518; cv=none; b=XbgHvnQ5uWyQpOTqCsl9K42GEUvCk/1yffdTW4dcB8uvUfAFxwQ01qYm0FiVRhtHQXiKfyPcmQ+L5bUNaLPKlfZp2ic807aWqcFZuqnBSYI/+g5yEkSLKDvb27Axwoakz6HuGG2P1CG/yvLlHaMuraBZrozs54fy4JX4D0SHVKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295518; c=relaxed/simple;
	bh=KlaEV1usF/a6VUzPkA4PpxkTHRJxRJNLVNv6waIMthE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oOME3J04/yKhWhxmrMs/eJq4X43gfmOPCwHyGIAj1+LhJROqLiX/XIysxnx4/S4I6E1Gz1RVC7sZ/2KUykRxXpGr9Z9n8VsxwC5gLzEkWQClpmhlOe6tjCw+zHjF67Ne3w1cZKt6cwZK4zpWzehdPnEyorey1rX8tRvd6G2q8b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cly6091V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cly6091V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC9AC433C7;
	Wed, 13 Mar 2024 02:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295517;
	bh=KlaEV1usF/a6VUzPkA4PpxkTHRJxRJNLVNv6waIMthE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cly6091VrLR8DZgRhxRTpd6yE//Iwcm0h2t/R39Cef98UXYtYI/l+/30+tC8d+pYo
	 GLlF86JxinGHvMy7Fasb+mRN1l9VRwF40Oq+nFIXyX3u9z4Vg8B1bvwq8Fqn/sREVZ
	 pbaW0B6bmkkbtdZ/hW9HRvAJ/+1UhWz9UAaZ/VeGN9RLBksKVlKTntOG/kk/a5xbj7
	 +xHCiacp8ESZtSe1HK86ysO6nuNr9SQvrMdCajfQkVDBSpuzt3T/9GM1deCUP8WBOd
	 YBsMayvOq6+QRN1PqoZQsaFl8ZqNJ5ElQjl61jcRm2G09D7adb/4+vKu/sDoFsDorA
	 G04Syc0XICSmw==
Date: Tue, 12 Mar 2024 19:05:17 -0700
Subject: [PATCH 47/67] xfs: also use xfs_bmap_btalloc_accounting for RT
 allocations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431871.2061787.5782792122013176872.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 58643460546da1dc61593fc6fd78762798b4534f

Make xfs_bmap_btalloc_accounting more generic by handling the RT quota
reservations and then also use it from xfs_bmap_rtalloc instead of
open coding the accounting logic there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/libxfs_priv.h    |    5 ++++-
 libxfs/xfs_bmap.c       |   21 ++++++++++++++-------
 libxfs/xfs_bmap.h       |    2 ++
 libxfs/xfs_bmap_btree.c |    1 +
 4 files changed, 21 insertions(+), 8 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 30ff8dba9178..28ee192509c7 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -434,7 +434,10 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_filestream_select_ag(...)		(-ENOSYS)
 
 /* quota bits */
-#define xfs_trans_mod_dquot_byino(t,i,f,d)		((void) 0)
+#define xfs_trans_mod_dquot_byino(t,i,f,d)		({ \
+	uint _f = (f); \
+	_f = _f; /* shut up gcc */ \
+})
 #define xfs_trans_reserve_quota_nblks(t,i,b,n,f)	(0)
 
 /* hack too silence gcc */
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index ad058bb126e2..4f6bd8dff47e 100644
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
index 4b83f6148e00..f6b73f1bad5f 100644
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
index 73ba067df06e..887ba56f3b7b 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -21,6 +21,7 @@
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_quota_defs.h"
 
 static struct kmem_cache	*xfs_bmbt_cur_cache;
 

