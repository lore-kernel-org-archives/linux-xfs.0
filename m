Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2141487F6
	for <linux-xfs@vger.kernel.org>; Sun,  6 Apr 2025 17:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743960148; cv=none; b=FE++K/+ewIK5hpELvYe7r1oQWAyFz+QS33hzl+sMJWQleNIYjGd1E3Y/4fPMNOFm4q3kx2F+nC+JlmtQxfAxlXTREpWkIl6bpSOt/VATtmSi/M2STyBgVXG1yDomuRQNln0dWIF6AjWF9mo2vzvSCFEmWzNnEqO3q4CuzOAZuYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743960148; c=relaxed/simple;
	bh=sefol+cQTsMxf/tF4YSBaDIukatsE9FZUFEpOrZ9ZsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZVXPYmvlncJrbQwOUOD91qPKDTTDZtKMsrkHwciIOEr78tU25hw3PWqn96vmuJM9pWe+YeUO+oJTFomcMsw4QaVi/bOpDzVZARS2qxqJ/hgcTq1gvGyMIthEyj65VNokJ4/zxOSzW+w0qgLLS+KNalBCJukzX6hoi+weSxsLwCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=krfvX9vb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="krfvX9vb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F57C4CEE3;
	Sun,  6 Apr 2025 17:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743960147;
	bh=sefol+cQTsMxf/tF4YSBaDIukatsE9FZUFEpOrZ9ZsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=krfvX9vb+Y5HNutOCGYEMj/zjyqcH9rx6SXdLfGGLvVcrzZEgkuD0CF9KXaMuyV5c
	 B4YddLh2vkGvd3Uky2BwSjzkL1lAdj5qF4WVGFCLk4mDdNZlq0caHTkaw+/h2MA3fe
	 gL5tFymrEafIKgLH0RUAOZ3gWVF2jtoNX5041piFNlNfB6Xi/1/d8t5+OfLqAa7n0u
	 o8hVUHm2kCwMWmeDScwPUKT6QCQwSL2zn3ktVy/MMqJ38nETRep8vZwjCJw0CaLLYL
	 6TD3ACThPN/3SfmUflbDiSdGD9Rxv865+pMdsriy+gjyFmJ58UbwCWLAF0CRB4qerT
	 Ek51EjPXkHZyA==
Date: Sun, 6 Apr 2025 10:22:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: compute the maximum repair reaping defer intent
 chain length
Message-ID: <20250406172227.GC6307@frogsfrogsfrogs>
References: <20250403191244.GB6283@frogsfrogsfrogs>
 <ce1887ca-3b05-4a90-bb20-456f9fb3c4f5@oracle.com>
 <20250404160930.GC6283@frogsfrogsfrogs>
 <011efc18-0024-402f-b79b-a8ea366fdadf@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <011efc18-0024-402f-b79b-a8ea366fdadf@oracle.com>

On Fri, Apr 04, 2025 at 05:36:54PM +0100, John Garry wrote:
> On 04/04/2025 17:09, Darrick J. Wong wrote:
> > > and xfs_cui_item_overhead() - are not referenced in this patch, but only in
> > The refcount intent items aren't needed for online fsck because xreap_*
> > doesn't mess with file data.  They're provided entirely for the sake of
> > cow fallback of multi-fsblock untorn writes.  IOWs, it's to reduce churn
> > between our patchsets (really, this patch and your patchset) assuming
> > that part of untorn writes actually goes into 6.16.
> 
> Can you please advise on how you would like to proceed this patch and my
> dependent work?

Cut out whatever pieces you need from this patch below.

My guess is that you'll need to compute tr_logres as:

tr_logres = max(logres to do one step of a bui +
                logres to do one step of a cui +
                logres to do one step of a efi +
                logres to do one step of a rui) +
            max(logres to log one bui and bud +
                logres to log one cui and cud +
                logres to log one efi and efd +
                logres to log one rui and rud) * untorn_write_unit_max;

(or transform this formula to compute untorn_write_unit_max from
tr_logres)

--D

From: Darrick J. Wong <djwong@kernel.org>
Subject: [PATCH] xfs: add helpers to compute log item overhead

Add selected helpers to estimate the transaction reservation required to
write various log intent and buffer items to the log.  These helpers
will be used by the online repair code for more precise estimations of
how much work can be done in a single transaction.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_resv.h |    4 ++++
 fs/xfs/xfs_bmap_item.h         |    3 +++
 fs/xfs/xfs_buf_item.h          |    3 +++
 fs/xfs/xfs_extfree_item.h      |    3 +++
 fs/xfs/xfs_log_priv.h          |   13 +++++++++++++
 fs/xfs/xfs_refcount_item.h     |    3 +++
 fs/xfs/xfs_rmap_item.h         |    3 +++
 fs/xfs/libxfs/xfs_trans_resv.c |    6 +++---
 fs/xfs/xfs_bmap_item.c         |   10 ++++++++++
 fs/xfs/xfs_buf_item.c          |   19 +++++++++++++++++++
 fs/xfs/xfs_extfree_item.c      |   10 ++++++++++
 fs/xfs/xfs_log_cil.c           |    4 +---
 fs/xfs/xfs_refcount_item.c     |   10 ++++++++++
 fs/xfs/xfs_rmap_item.c         |   10 ++++++++++
 14 files changed, 95 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 0554b9d775d269..e76052028cc9d4 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -97,6 +97,10 @@ struct xfs_trans_resv {
 
 void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
 uint xfs_allocfree_block_count(struct xfs_mount *mp, uint num_ops);
+unsigned int xfs_refcountbt_block_count(struct xfs_mount *mp,
+		unsigned int num_ops);
+uint xfs_calc_buf_res(uint nbufs, uint size);
+uint xfs_calc_inode_res(struct xfs_mount *mp, uint ninodes);
 
 unsigned int xfs_calc_itruncate_reservation_minlogsize(struct xfs_mount *mp);
 unsigned int xfs_calc_write_reservation_minlogsize(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index 6fee6a5083436b..655b30bc17361e 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -72,4 +72,7 @@ struct xfs_bmap_intent;
 
 void xfs_bmap_defer_add(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
 
+unsigned int xfs_bui_item_overhead(unsigned int nr);
+unsigned int xfs_bud_item_overhead(void);
+
 #endif	/* __XFS_BMAP_ITEM_H__ */
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 8cde85259a586d..a273f45b558da3 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -64,6 +64,9 @@ static inline void xfs_buf_dquot_iodone(struct xfs_buf *bp)
 void	xfs_buf_iodone(struct xfs_buf *);
 bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
 
+unsigned int xfs_buf_inval_item_overhead(unsigned int map_count,
+		unsigned int blocksize);
+
 extern struct kmem_cache	*xfs_buf_item_cache;
 
 #endif	/* __XFS_BUF_ITEM_H__ */
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 41b7c43060799b..ebb237a4ae87b4 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -94,4 +94,7 @@ void xfs_extent_free_defer_add(struct xfs_trans *tp,
 		struct xfs_extent_free_item *xefi,
 		struct xfs_defer_pending **dfpp);
 
+unsigned int xfs_efi_item_overhead(unsigned int nr);
+unsigned int xfs_efd_item_overhead(unsigned int nr);
+
 #endif	/* __XFS_EXTFREE_ITEM_H__ */
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index f3d78869e5e5a3..39a102cc1b43e6 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -698,4 +698,17 @@ xlog_kvmalloc(
 	return p;
 }
 
+/*
+ * Given a count of iovecs and space for a log item, compute the space we need
+ * in the log to store that data plus the log headers.
+ */
+static inline unsigned int
+xlog_item_space(
+	unsigned int	niovecs,
+	unsigned int	nbytes)
+{
+	nbytes += niovecs * (sizeof(uint64_t) + sizeof(struct xlog_op_header));
+	return round_up(nbytes, sizeof(uint64_t));
+}
+
 #endif	/* __XFS_LOG_PRIV_H__ */
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index bfee8f30c63ce9..5976cf0a04a671 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -76,4 +76,7 @@ struct xfs_refcount_intent;
 void xfs_refcount_defer_add(struct xfs_trans *tp,
 		struct xfs_refcount_intent *ri);
 
+unsigned int xfs_cui_item_overhead(unsigned int nr);
+unsigned int xfs_cud_item_overhead(void);
+
 #endif	/* __XFS_REFCOUNT_ITEM_H__ */
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 40d331555675ba..0dac2cfe456749 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -75,4 +75,7 @@ struct xfs_rmap_intent;
 
 void xfs_rmap_defer_add(struct xfs_trans *tp, struct xfs_rmap_intent *ri);
 
+unsigned int xfs_rui_item_overhead(unsigned int nr);
+unsigned int xfs_rud_item_overhead(void);
+
 #endif	/* __XFS_RMAP_ITEM_H__ */
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 13d00c7166e178..ce1393bd3561fd 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -47,7 +47,7 @@ xfs_buf_log_overhead(void)
  * will be changed in a transaction.  size is used to tell how many
  * bytes should be reserved per item.
  */
-STATIC uint
+uint
 xfs_calc_buf_res(
 	uint		nbufs,
 	uint		size)
@@ -84,7 +84,7 @@ xfs_allocfree_block_count(
  * in the same transaction as an allocation or a free, so we compute them
  * separately.
  */
-static unsigned int
+unsigned int
 xfs_refcountbt_block_count(
 	struct xfs_mount	*mp,
 	unsigned int		num_ops)
@@ -129,7 +129,7 @@ xfs_rtrefcountbt_block_count(
  *	  additional to the records and pointers that fit inside the inode
  *	  forks.
  */
-STATIC uint
+uint
 xfs_calc_inode_res(
 	struct xfs_mount	*mp,
 	uint			ninodes)
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 3d52e9d7ad571a..c62b9c1dd448b8 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -77,6 +77,11 @@ xfs_bui_item_size(
 	*nbytes += xfs_bui_log_format_sizeof(buip->bui_format.bui_nextents);
 }
 
+unsigned int xfs_bui_item_overhead(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_bui_log_format_sizeof(nr));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the
  * given bui log item. We use only 1 iovec, and we point that
@@ -168,6 +173,11 @@ xfs_bud_item_size(
 	*nbytes += sizeof(struct xfs_bud_log_format);
 }
 
+unsigned int xfs_bud_item_overhead(void)
+{
+	return xlog_item_space(1, sizeof(struct xfs_bud_log_format));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the
  * given bud log item. We use only 1 iovec, and we point that
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 47549cfa61cd82..503675053a228a 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -167,6 +167,25 @@ xfs_buf_item_size_segment(
 	}
 }
 
+/*
+ * Compute the worst case log item overhead for an invalidated buffer with the
+ * given map count and block size.
+ */
+unsigned int
+xfs_buf_inval_item_overhead(
+	unsigned int	map_count,
+	unsigned int	blocksize)
+{
+	unsigned int	chunks = DIV_ROUND_UP(blocksize, XFS_BLF_CHUNK);
+	unsigned int	bitmap_size = DIV_ROUND_UP(chunks, NBWORD);
+	unsigned int	ret =
+		offsetof(struct xfs_buf_log_format, blf_data_map) +
+			(bitmap_size * sizeof_field(struct xfs_buf_log_format,
+						    blf_data_map[0]));
+
+	return ret * map_count;
+}
+
 /*
  * Return the number of log iovecs and space needed to log the given buf log
  * item.
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a25c713ff888c7..1dd7f45359e090 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -82,6 +82,11 @@ xfs_efi_item_size(
 	*nbytes += xfs_efi_log_format_sizeof(efip->efi_format.efi_nextents);
 }
 
+unsigned int xfs_efi_item_overhead(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_efi_log_format_sizeof(nr));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the
  * given efi log item. We use only 1 iovec, and we point that
@@ -253,6 +258,11 @@ xfs_efd_item_size(
 	*nbytes += xfs_efd_log_format_sizeof(efdp->efd_format.efd_nextents);
 }
 
+unsigned int xfs_efd_item_overhead(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_efd_log_format_sizeof(nr));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the
  * given efd log item. We use only 1 iovec, and we point that
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 1ca406ec1b40b3..f66d2d430e4f37 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -309,9 +309,7 @@ xlog_cil_alloc_shadow_bufs(
 		 * Then round nbytes up to 64-bit alignment so that the initial
 		 * buffer alignment is easy to calculate and verify.
 		 */
-		nbytes += niovecs *
-			(sizeof(uint64_t) + sizeof(struct xlog_op_header));
-		nbytes = round_up(nbytes, sizeof(uint64_t));
+		nbytes = xlog_item_space(niovecs, nbytes);
 
 		/*
 		 * The data buffer needs to start 64-bit aligned, so round up
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index fe2d7aab8554fc..02defb7116419f 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -78,6 +78,11 @@ xfs_cui_item_size(
 	*nbytes += xfs_cui_log_format_sizeof(cuip->cui_format.cui_nextents);
 }
 
+unsigned int xfs_cui_item_overhead(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_cui_log_format_sizeof(nr));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the
  * given cui log item. We use only 1 iovec, and we point that
@@ -179,6 +184,11 @@ xfs_cud_item_size(
 	*nbytes += sizeof(struct xfs_cud_log_format);
 }
 
+unsigned int xfs_cud_item_overhead(void)
+{
+	return xlog_item_space(1, sizeof(struct xfs_cud_log_format));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the
  * given cud log item. We use only 1 iovec, and we point that
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 89decffe76c8b5..45230072564114 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -77,6 +77,11 @@ xfs_rui_item_size(
 	*nbytes += xfs_rui_log_format_sizeof(ruip->rui_format.rui_nextents);
 }
 
+unsigned int xfs_rui_item_overhead(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_rui_log_format_sizeof(nr));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the
  * given rui log item. We use only 1 iovec, and we point that
@@ -180,6 +185,11 @@ xfs_rud_item_size(
 	*nbytes += sizeof(struct xfs_rud_log_format);
 }
 
+unsigned int xfs_rud_item_overhead(void)
+{
+	return xlog_item_space(1, sizeof(struct xfs_rud_log_format));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the
  * given rud log item. We use only 1 iovec, and we point that
