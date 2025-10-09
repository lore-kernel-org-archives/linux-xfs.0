Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45472D1907
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 12:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760011796; cv=none; b=D/BMrD31M2tpTlr2AoqBhBu+iH9aAvXOLmk5m0gER2Vqn/CmlnjNqX55ey1ony+DCcDL24HlFoDN15S0hVjbRVvGM57XTwiLs2WCiGgBqhBi40/NZv5MWA/dODJ40Q2/C8MBhmL5SsgEXEIraArS0Jfp16QZBkdeDnMsKpepE9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760011796; c=relaxed/simple;
	bh=xinyit8iiUX2UA7wR57rZBhcuiG3nfB/9W2kqhS6FxM=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RNtWO+tWR7iQo1zUR5hGGpvpJWFieenWa0DoPet8z2mb43G7oOXYA1gbt1cprEYMH4mkhNGQB/WMMCitozgOKmZdr3XDyW1kBHujU8SiTEc192qp3CIxNQkBoTSQsg2Y8sXHUIGtOVOxCTcZL/ACbwSXeIQiddHBMCvDWUyVbYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XDr8vM5t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XDr8vM5t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760011793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5LgUSqQv8hkZPNIjpVZaLHq1Z1JEWZmH/A0P06BZuB4=;
	b=XDr8vM5tGNoFXkC6iFxtHMgsBcneBdizUT0GL5J6cz9yMZYTZeEcmOoGzXW7Mfw2mKhO5A
	l/UixFTnMn6a2s9Ywly7RyiZrIwemcRnS9KHcMmvmtM6ayDgz/S02R5j58B2rEd3zFpnxW
	/taQhzOl38KZEU26ncTXqhotAYdLlM0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-ZhCh5pipPKCGcxaIuOJfNw-1; Thu, 09 Oct 2025 08:09:52 -0400
X-MC-Unique: ZhCh5pipPKCGcxaIuOJfNw-1
X-Mimecast-MFC-AGG-ID: ZhCh5pipPKCGcxaIuOJfNw_1760011791
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e38957979so4126945e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 05:09:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760011791; x=1760616591;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5LgUSqQv8hkZPNIjpVZaLHq1Z1JEWZmH/A0P06BZuB4=;
        b=drvjDUq0rAKFuWJqxYGDC93XrEP6PZUOCq+uE3RdF68TPuPf3vJH155OWwx3Z9zr3z
         MXtD1bQoSgDt4AQhqQ0VPNZRoQR+OkUzD/hJRRLA8yats2eaetS2L68tMVgKYTDVrbS3
         ra7wFJc6+UTkxDGb9URnGrdUvRnGRRAK4avkoF2oG2nHLlZ1A+brCMd/DQYwgMyAdC/C
         Ps7M3BvdZ9L+O8MrNxjIbnREpWLI/azVCG2+iOFdogls6oFBQgMpy15sIPlW7a0gs2iq
         PsjWR+wNReEn0Z1UtcC/uWS7XXVGnMgTVFeEDfLGBaCS2N6yxHMEFqU07I4UGhQX0IC5
         1U7Q==
X-Gm-Message-State: AOJu0YzPw6AoT0pYHMFm0dmn3m/0/RjuZAHTjnPd8St8ySkN5lHkoOJG
	w9JnEW78N98q30x2wQUVLDN6NtX8UHBLxJLFQ+54QBY4b/Qwdqjf5EU4ySFflhwp/6ATJAokZgm
	DShxOBwQ8XK+MQdN1GrsNVpHbCXynZ4Wbm8yDp6pFpn2NiRL+eOYE8w1k+kRw6g6YfqxN/K/1bQ
	PRhXpL0+1wwfLKCyQF0pz8sKBmlOkv7/dTOfnJ8rqU2nY1
X-Gm-Gg: ASbGncuuULyafyjosBITO1rF5DAKNBwV0WvoJ1/dNBYKllwWZMo9hhkudmibBYKmZMD
	1CR3L8YlLS+f1V6FGVJHo0jvKPbVGuzjTcmIbDVOEbmYGn7JVeVFe/34X2PWvwTZzyo3jBOBDmg
	r6B+hMo1wQKBaNDKvLvtGFnJhvRedT7Zw7oBy5YpEzAwfCcTANXoGAieHCgakuXuQE4dBzd4aHi
	/EtMPSBNMlTVS+/WNgYh+oixX2akUDw4HhOo9eqVOFIMO4aKdNWetZzxeWFaYdWpvFlN19QXVKa
	GJRx372rCTvFgX7VU8TcafUJx5f1CHM//mbFnh/VV3/H/oP3Zy9tvw==
X-Received: by 2002:a05:600c:4713:b0:46d:9d28:fb5e with SMTP id 5b1f17b1804b1-46fa9a86d84mr47728545e9.5.1760011790783;
        Thu, 09 Oct 2025 05:09:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWhAtc7DN5WHliBIAcYWwlE6HNFOGFqdT+VBbGcADi1srM2CcKt4wf0dD1PuzaQpUUXZHM5w==
X-Received: by 2002:a05:600c:4713:b0:46d:9d28:fb5e with SMTP id 5b1f17b1804b1-46fa9a86d84mr47728185e9.5.1760011790137;
        Thu, 09 Oct 2025 05:09:50 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9d629casm81457095e9.16.2025.10.09.05.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 05:09:49 -0700 (PDT)
From: Christoph Hellwig <aalbersh@redhat.com>
X-Google-Original-From: Christoph Hellwig <hch@lst.de>
Date: Thu, 9 Oct 2025 14:09:49 +0200
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH v2 7/11] xfs: return the allocated transaction from
 xfs_trans_alloc_empty
Message-ID: <4dagukgczqpi5uibqw2jyjzgngszvw7x2qsqeee5fkp3erg4m3@22f4wq24akeg>
References: <cover.1760011614.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1760011614.patch-series@thinky>

Source kernel commit: d8e1ea43e5a314bc01ec059ce93396639dcf9112

xfs_trans_alloc_empty can't return errors, so return the allocated
transaction directly instead of an output double pointer argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/attrset.c          |  6 +-----
 db/dquot.c            |  4 +---
 db/fsmap.c            |  8 +-------
 db/info.c             |  8 +-------
 db/namei.c            |  4 +---
 db/rdump.c            |  7 +------
 include/xfs_trans.h   |  2 +-
 libxfs/inode.c        |  4 +---
 libxfs/trans.c        | 37 ++++++++++++++++++++++---------------
 libxfs/xfs_refcount.c |  4 +---
 repair/phase2.c       |  6 +-----
 repair/pptr.c         |  4 ++--
 repair/quotacheck.c   |  9 ++-------
 repair/rcbag.c        |  8 ++------
 repair/rmap.c         |  4 +---
 repair/rt.c           | 10 ++--------
 16 files changed, 41 insertions(+), 84 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index e3ffb75aa4..273c202956 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -823,11 +823,7 @@
 		return 0;
 	}
 
-	error = -libxfs_trans_alloc_empty(mp, &tp);
-	if (error) {
-		dbprintf(_("failed to allocate empty transaction\n"));
-		return 0;
-	}
+	tp = libxfs_trans_alloc_empty(mp);
 
 	error = -libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip);
 	if (error) {
diff --git a/db/dquot.c b/db/dquot.c
index d2c76fd70b..c028d50e4c 100644
--- a/db/dquot.c
+++ b/db/dquot.c
@@ -92,9 +92,7 @@
 	xfs_ino_t		ret = NULLFSINO;
 	int			error;
 
-	error = -libxfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		return NULLFSINO;
+	tp = libxfs_trans_alloc_empty(mp);
 
 	if (xfs_has_metadir(mp)) {
 		error = -libxfs_dqinode_load_parent(tp, &dp);
diff --git a/db/fsmap.c b/db/fsmap.c
index ddbe4e6a3d..a59a4d1230 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -133,13 +133,7 @@
 	struct xfs_btree_cur	*bt_cur;
 	int			error;
 
-	error = -libxfs_trans_alloc_empty(mp, &tp);
-	if (error) {
-		dbprintf(
- _("Cannot alloc transaction to look up rtgroup %u rmap inode\n"),
-				rtg_rgno(rtg));
-		return error;
-	}
+	tp = libxfs_trans_alloc_empty(mp);
 
 	error = -libxfs_rtginode_load_parent(tp);
 	if (error) {
diff --git a/db/info.c b/db/info.c
index 6ad3e23832..9c233c9c0e 100644
--- a/db/info.c
+++ b/db/info.c
@@ -174,13 +174,7 @@
 	xfs_filblks_t		used = 0;
 	int			error;
 
-	error = -libxfs_trans_alloc_empty(mp, &tp);
-	if (error) {
-		dbprintf(
- _("Cannot alloc transaction to look up rtgroup %u rmap inode\n"),
-				rtg_rgno(rtg));
-		return;
-	}
+	tp = libxfs_trans_alloc_empty(mp);
 
 	error = -libxfs_rtginode_load_parent(tp);
 	if (error) {
diff --git a/db/namei.c b/db/namei.c
index 1d9581c323..0a50ec87df 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -94,9 +94,7 @@
 	unsigned int		i;
 	int			error;
 
-	error = -libxfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		return error;
+	tp = libxfs_trans_alloc_empty(mp);
 
 	error = -libxfs_iget(mp, tp, ino, 0, &dp);
 	if (error)
diff --git a/db/rdump.c b/db/rdump.c
index a50df4b8c7..599d0727e7 100644
--- a/db/rdump.c
+++ b/db/rdump.c
@@ -926,15 +926,10 @@
 		set_cur_inode(mp->m_sb.sb_rootino);
 	}
 
-	ret = -libxfs_trans_alloc_empty(mp, &tp);
-	if (ret) {
-		dbprintf(_("allocating state: %s\n"), strerror(ret));
-		goto out_pbuf;
-	}
+	tp = libxfs_trans_alloc_empty(mp);
 
 	ret = rdump_file(tp, iocur_top->ino, destdir, pbuf);
 	libxfs_trans_cancel(tp);
-out_pbuf:
 	free(pbuf);
 	return ret;
 }
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 248064019a..4f4bfff350 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -98,7 +98,7 @@
 			struct xfs_trans **tpp, int *nospace_error);
 int	libxfs_trans_alloc_rollable(struct xfs_mount *mp, uint blocks,
 				    struct xfs_trans **tpp);
-int	libxfs_trans_alloc_empty(struct xfs_mount *mp, struct xfs_trans **tpp);
+struct xfs_trans *libxfs_trans_alloc_empty(struct xfs_mount *mp);
 int	libxfs_trans_commit(struct xfs_trans *);
 void	libxfs_trans_cancel(struct xfs_trans *);
 int	libxfs_trans_reserve_more(struct xfs_trans *tp, uint blocks,
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 0598a70ff5..1ce159fcc9 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -258,9 +258,7 @@
 	struct xfs_trans	*tp;
 	int			error;
 
-	error = libxfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		return error;
+	tp = libxfs_trans_alloc_empty(mp);
 
 	error = libxfs_trans_metafile_iget(tp, ino, metafile_type, ipp);
 	libxfs_trans_cancel(tp);
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 5c896ba166..64457d1710 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -247,18 +247,12 @@
 	return error;
 }
 
-int
-libxfs_trans_alloc(
+static inline struct xfs_trans *
+__libxfs_trans_alloc(
 	struct xfs_mount	*mp,
-	struct xfs_trans_res	*resp,
-	unsigned int		blocks,
-	unsigned int		rtextents,
-	unsigned int		flags,
-	struct xfs_trans	**tpp)
-
+	uint			flags)
 {
 	struct xfs_trans	*tp;
-	int			error;
 
 	tp = kmem_cache_zalloc(xfs_trans_cache, 0);
 	tp->t_mountp = mp;
@@ -266,6 +260,22 @@
 	INIT_LIST_HEAD(&tp->t_dfops);
 	tp->t_highest_agno = NULLAGNUMBER;
 
+	return tp;
+}
+
+int
+libxfs_trans_alloc(
+	struct xfs_mount	*mp,
+	struct xfs_trans_res	*resp,
+	unsigned int		blocks,
+	unsigned int		rtextents,
+	unsigned int		flags,
+	struct xfs_trans	**tpp)
+
+{
+	struct xfs_trans	*tp = __libxfs_trans_alloc(mp, flags);
+	int			error;
+
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
 	if (error) {
 		xfs_trans_cancel(tp);
@@ -290,14 +300,11 @@
  * Note the zero-length reservation; this transaction MUST be cancelled
  * without any dirty data.
  */
-int
+struct xfs_trans *
 libxfs_trans_alloc_empty(
-	struct xfs_mount		*mp,
-	struct xfs_trans		**tpp)
+	struct xfs_mount		*mp)
 {
-	struct xfs_trans_res		resv = {0};
-
-	return xfs_trans_alloc(mp, &resv, 0, 0, XFS_TRANS_NO_WRITECOUNT, tpp);
+	return __libxfs_trans_alloc(mp, XFS_TRANS_NO_WRITECOUNT);
 }
 
 /*
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 1000bab245..4d31c3379d 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -2097,9 +2097,7 @@
 	 * recording the CoW debris we cancel the (empty) transaction
 	 * and everything goes away cleanly.
 	 */
-	error = xfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		return error;
+	tp = xfs_trans_alloc_empty(mp);
 
 	if (isrt) {
 		xfs_rtgroup_lock(to_rtg(xg), XFS_RTGLOCK_REFCOUNT);
diff --git a/repair/phase2.c b/repair/phase2.c
index e249980527..fc96f9c422 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -296,11 +296,7 @@
 		 * there while we try to make a per-AG reservation with the new
 		 * geometry.
 		 */
-		error = -libxfs_trans_alloc_empty(mp, &tp);
-		if (error)
-			do_error(
-	_("Cannot reserve resources for upgrade check, err=%d.\n"),
-					error);
+		tp = libxfs_trans_alloc_empty(mp);
 
 		error = -libxfs_ialloc_read_agi(pag, tp, 0, &agi_bp);
 		if (error)
diff --git a/repair/pptr.c b/repair/pptr.c
index ac0a9c618b..6a9e072b36 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -1217,7 +1217,7 @@
 	fscan->have_garbage = false;
 	fscan->nr_file_pptrs = 0;
 
-	libxfs_trans_alloc_empty(ip->i_mount, &tp);
+	tp = libxfs_trans_alloc_empty(ip->i_mount);
 	error = xattr_walk(tp, ip, examine_xattr, fscan);
 	if (tp)
 		libxfs_trans_cancel(tp);
@@ -1417,7 +1417,7 @@
 		do_error("init garbage pptr names failed: %s\n",
 				strerror(error));
 
-	libxfs_trans_alloc_empty(ip->i_mount, &tp);
+	tp = libxfs_trans_alloc_empty(ip->i_mount);
 	error = xattr_walk(tp, ip, erase_pptrs, &fscan);
 	if (tp)
 		libxfs_trans_cancel(tp);
diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index df6cde2d58..f4c0314177 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -437,9 +437,7 @@
 	if (!dquots || !chkd_flags)
 		return;
 
-	error = -libxfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		do_error(_("could not alloc transaction to open quota file\n"));
+	tp = libxfs_trans_alloc_empty(mp);
 
 	ino = get_quota_inode(type);
 	error = -libxfs_trans_metafile_iget(tp, ino, metafile_type, &ip);
@@ -679,9 +677,7 @@
 	struct xfs_inode	*dp = NULL;
 	int			error, err2;
 
-	error = -libxfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		goto out;
+	tp = libxfs_trans_alloc_empty(mp);
 
 	error = -libxfs_dqinode_load_parent(tp, &dp);
 	if (error)
@@ -698,7 +694,6 @@
 	libxfs_irele(dp);
 out_cancel:
 	libxfs_trans_cancel(tp);
-out:
 	if (error) {
 		switch (error) {
 		case EFSCORRUPTED:
diff --git a/repair/rcbag.c b/repair/rcbag.c
index 21732b65c6..d7addbf58e 100644
--- a/repair/rcbag.c
+++ b/repair/rcbag.c
@@ -95,9 +95,7 @@
 	int				has;
 	int				error;
 
-	error = -libxfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		do_error(_("allocating tx for refcount bag update\n"));
+	tp = libxfs_trans_alloc_empty(mp);
 
 	cur = rcbagbt_mem_cursor(mp, tp, &bag->xfbtree);
 	error = rcbagbt_lookup_eq(cur, rmap, &has);
@@ -217,9 +215,7 @@
 	int			has;
 	int			error;
 
-	error = -libxfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		do_error(_("allocating tx for refcount bag update\n"));
+	tp = libxfs_trans_alloc_empty(mp);
 
 	/* go to the right edge of the tree */
 	cur = rcbagbt_mem_cursor(mp, tp, &bag->xfbtree);
diff --git a/repair/rmap.c b/repair/rmap.c
index 97510dd875..e89bd32d63 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -323,9 +323,7 @@
 	int			error;
 
 	xfbt = &rmaps_for_group(isrt, agno)->ar_xfbtree;
-	error = -libxfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		do_error(_("allocating tx for in-memory rmap update\n"));
+	tp = libxfs_trans_alloc_empty(mp);
 
 	error = rmap_init_mem_cursor(mp, tp, isrt, agno, &rmcur);
 	if (error)
diff --git a/repair/rt.c b/repair/rt.c
index 1ac2bf6fc4..781d896844 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -301,10 +301,7 @@
 	if (rtg->rtg_inodes[type])
 		goto out_rtg;
 
-	error = -libxfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		goto out_rtg;
-
+	tp = libxfs_trans_alloc_empty(mp);
 
 	error = -libxfs_rtginode_load(rtg, type, tp);
 	if (error)
@@ -497,9 +494,7 @@
 	int			error, err2;
 	int			i;
 
-	error = -libxfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		goto out;
+	tp = libxfs_trans_alloc_empty(mp);
 	if (xfs_has_rtgroups(mp) && mp->m_sb.sb_rgcount > 0) {
 		error = -libxfs_rtginode_load_parent(tp);
 		if (error)
@@ -516,7 +511,6 @@
 
 out_cancel:
 	libxfs_trans_cancel(tp);
-out:
 	if (xfs_has_rtgroups(mp) && error) {
 		/*
 		 * Old xfs_repair didn't complain if rtbitmaps didn't load

-- 
- Andrey

