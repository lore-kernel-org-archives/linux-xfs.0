Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F050D3655EE
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589648; cv=none; b=dcUHsEJvjoYdAZHH08df0uueRXGFvtIS/8mg9xUWJiKk5OyRKpSJKcSWh1ujU6iGYnE+cJTaqKsgPuqahQwvnLqYAe2dw6YYhUDy29LRU5t/oFn5stxrJ56De/Uf40Sevl2DojCSrkyntsNgl0zO78veDoEyL4OPMVR7ns2rBZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589648; c=relaxed/simple;
	bh=CrYF9SO/MgzVZXuN6rMcHksDMXljzkSjhz5agizkC6k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R2Jk06TQcOiIjalxLDmloM0bQ5EuH9VkCtirubzFOjkvkYTuoBQWnIDY3KK2RigzevFWqYxfWaQTDpUgQAElvEdQWUhUgzNHFdIHV7sdnUsS3NG6IV89KMdSnsstFf2CsyKfzPaaWJnpCsRNuHOiIlEAk2WKTds3uLPvFtdX/T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H0UCrMeQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H0UCrMeQ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C7D2D1F000FF;
	Fri,  9 Oct 2026 23:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589647;
	bh=n3O0VwV6sEbRhIFvSyTEBu4Uq5y5YXp1f1zLjr0LJvA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=H0UCrMeQeE6RJPrYuffovWqgzLiefb4Ogd3SpDyBc8iClUkFX7E7zt4h6pIw0xJjD
	 +e+pFD7XBLkSTMGtaXYDUHF6bqEYctC3XVmBxKJ+so+PbBfNV1Cq8btzZrJDkmvW1K
	 hpg+Va4anGQiYyvMCetMHJnpGE3zdsKLoHQ6D5MYC68rU02Rl++XnD710pCvOdq2yA
	 8BIJFATNCNs4fACXKZ5+1Sj5Seuf6H29zI03a/cIwRJouAsTRoXC1RZmybZGpzamcr
	 Lso2HSqTQiMmhtBwW/Taz7yqcz6rdL7LPm3mj+x9bgXKoYpjECstQpsGznAs4I4LRy
	 NdhNTD1a3i1UA==
Date: Fri, 09 Oct 2026 16:47:27 -0700
Subject: [PATCH 07/26] xfs: hide b_flags manipulation from code outside of
 xfs_buf.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179158947495.3719791.6891995032675051951.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 9f224de410d7efafc44ce1880aabd0101aa8688f

Add helpers for the remaining buffer flags manipulation not done in the
core buffer cache code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_platform.h      |    5 +++++
 libxfs/xfs_btree_staging.c |    7 +++----
 libxfs/xfs_ialloc.c        |    2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index d09fb0aae00f53..f2d786b763b8da 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -349,6 +349,11 @@ xfs_buf_incore(
 void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
 
+static inline void xfs_buf_set_uptodate(struct xfs_buf *bp)
+{
+	bp->b_flags |= LIBXFS_B_UPTODATE;
+}
+
 /* mount stuff */
 #define xfs_trans_set_sync(tp)		((void) 0)
 #define xfs_trans_buf_set_type(tp, bp, t)	({	\
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index c3c7ea54895a60..7314dab4bcfbc6 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -248,11 +248,10 @@ xfs_btree_bload_drop_buf(
 		return 0;
 
 	/*
-	 * Mark this buffer XBF_DONE (i.e. uptodate) so that a subsequent
-	 * xfs_buf_read will not pointlessly reread the contents from the disk.
+	 * Mark this buffer uptodate so that a subsequent xfs_buf_read will
+	 * not pointlessly reread the contents from the disk.
 	 */
-	bp->b_flags |= XBF_DONE;
-
+	xfs_buf_set_uptodate(bp);
 	xfs_buf_delwri_queue_here(bp, buffers_list);
 	xfs_buf_relse(bp);
 	*bpp = NULL;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index aa895c0decbc5a..c60e2a5ed56bdc 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -409,7 +409,7 @@ xfs_ialloc_inode_init(
 				xfs_trans_ordered_buf(tp, fbuf);
 			}
 		} else {
-			fbuf->b_flags |= XBF_DONE;
+			xfs_buf_set_uptodate(fbuf);
 			xfs_buf_delwri_queue(fbuf, buffer_list);
 			xfs_buf_relse(fbuf);
 		}

