Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E755342520
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764947068; cv=none; b=HgDuf8NbJQpJq3k7NERHIfsZRetLhYXihj2wzlDoOveQw6B7ygt58wHUiTDOVyoJS3i/wmzsYaI+9li6PWORdKBf+G+sCxzIWJ7l7wW7wOQ+GhcyHypRwulIxc3nmTLnBHQgOOwYehMnvDo2RcCT9sXXLVMwZRgRsczwLdkncIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764947068; c=relaxed/simple;
	bh=ymDy9m+kwEYYCAqRP5SzIglGuq+vZf2vx9tFtXnc+Do=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H8ys60reBvYtc6eRMaJXcVZd7aZrnZqovqRfSk+E/ExCegeBxppKxxpUsDGxoYoDswMNVUeT1wyQl7+kUJAMQ26BPWZw1/J72CiebKJ1VbB38S4VOiDRHcjTOdpwkUhzibq17MdEqIQ4A2i0NX+W0xDrK/9dMnAqlS1a/GBpv0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X2am0pGD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XZYauhqt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X2am0pGD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XZYauhqt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764947063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5XayV+TwPtAwjkGKScyChM7vb1Zg9Ubk1YS3CSnknos=;
	b=X2am0pGDeKhM6wlUmMU2qOjF1C7ZsBCg3ujEPZaZCh12enmvN98eFbcT/ZQ7JEaH0cJGlZ
	kRs8AheilEK/k0I4nBEyw6dhLgwr+oWlAdhV4ejUDvzYM3NhE7IBCtzqn0KEtSuGgW8aCt
	KyZS5+fziZ/HoN7sEabHzQ+UIML54gE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-zpKViO8mMi2emEpzDqgvLg-1; Fri, 05 Dec 2025 10:04:22 -0500
X-MC-Unique: zpKViO8mMi2emEpzDqgvLg-1
X-Mimecast-MFC-AGG-ID: zpKViO8mMi2emEpzDqgvLg_1764947061
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b771bfe9802so293335766b.1
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764947060; x=1765551860; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5XayV+TwPtAwjkGKScyChM7vb1Zg9Ubk1YS3CSnknos=;
        b=XZYauhqtekqduAJ3kUGRuT0DeK/fgnVR/5ZcfvgYTi0F5h5l2w1dfEEdtJ9nVlPRNN
         yAMGFc2ADJAQktGZUM+Ct8NgUb5BW4dp2uvD4SGe7bif59Gtj8ZlgDUDSBrf7CVgtsxm
         Yb1PrYLaz6pEmzGsFp7jtD2UXXe9CwVCBGAJkK1vshzqI7TaqMTePEOEU1gEtaS6gjvL
         xp83/yd2qDMbTx+LIbM2ewoqyoYVKIEW9MUGucXIq2Jo/c94DUmvNRiZbOIwQrhIMcIp
         E9zoAtmH7N1F/bcBWGyezl5bEbOdUScjiry1vpNXjttylqsJP34T7wcCSsu6h2+xQkpe
         1EHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764947060; x=1765551860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5XayV+TwPtAwjkGKScyChM7vb1Zg9Ubk1YS3CSnknos=;
        b=Xv+p+WUKmTNxafKJg7LrTCWjahje5W+Qi0amErcQr8CEGXQmiG56UrAuUps1/DGAx6
         ho9XNqhOYaaIiJOu9vTsT3xvp1/o1c6gLgdbQRlmLQdM/8e13uY5XnML2pAQv9mk8uL3
         aNxAGr6cwN07NNTKqXHz4c7xyDiNlzQSTa4ybcXkkmCKv/HLGt48eWNPaSslQx/vpWJ7
         UZZeBRtX1UYdR5GZCVYmw5Ac8cQesrH7h8HU1r/grN8djvWCBvjBaMMwSQ8apGeC7A4j
         0UYNX8Ob66i1bk31oEZQLTDAQp6CUrfZ+gAHkmagiF4WEabQ4FLdhuvOF9Cq07XUjoT1
         OyBQ==
X-Gm-Message-State: AOJu0YwP+HlHC2qMIC/2j2w2J6fyo1HMNgfs0VT1bh3FyroSlP5QStu5
	hW0kiO/84A60GiJNbR4SVrllzUbqKvej7CChjTwCqVrGK89A8FoSP4tyqX8Hv9MbeEq+GRPdlHM
	sUqRM0EJcCb6cCjzzsLFy/yGKuKAXXNbvrVzc3Skq0JJimuDTs8ZEhPXCAYK6gL4EjbrqORFfry
	/NrLrTdDZR3/MiUsN3XPratY33hZV5U3eb3yaNwYXbmFyA
X-Gm-Gg: ASbGncvCExHlUMM9xeikdZlmnhTHkOVFTSCm07AM14RIqE8cNzF6i2YoNK8tc6k2R1z
	NQdKFTPS7/h2vlFqeLCdC4nvw7oaBQVGgir85KIpDfd/ReJG9IWrjb42+S+fTn3SOnLlt3S0/DH
	iOJNvYIAAj/Aa4YB1vrvhU/h7T9IA/uqmqD16fwiMjfO1Xa2d9xmyquj0LC1l1DF85by/HVds6l
	tbK/5nQflCKkMfe26oOgY5Y+QLwPofqM5e7nfkyF2DbjaIQ0iQmWab6eT/CJxt5FCwglYQqgiqZ
	KCWLNriBw0NNit9kYKVJUNQafdHeq0GLUEioOFlnRORLJsY/tVAiw0QayEiDBBw1q0RK6YC0isg
	=
X-Received: by 2002:a17:907:3e93:b0:b73:5936:77fc with SMTP id a640c23a62f3a-b79ec41ff6emr761990666b.13.1764947059755;
        Fri, 05 Dec 2025 07:04:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGun7UbhWRj5u7oqFX+8bYhf5at5DTnnX5y7D8lmi/lDsb0FOG178kXAoKmA+b8IAz6kPe03A==
X-Received: by 2002:a17:907:3e93:b0:b73:5936:77fc with SMTP id a640c23a62f3a-b79ec41ff6emr761985266b.13.1764947059079;
        Fri, 05 Dec 2025 07:04:19 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79fe78c9ebsm255869166b.5.2025.12.05.07.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:04:18 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:04:17 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 31/33] xfs: remove the expr argument to XFS_TEST_ERROR
Message-ID: <g7ekfuoaowiygxmqxbo4u5n7eyqaezd4akd25pucyclv7p3yxr@ru5iem7kyumq>
References: <cover.1764946339.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764946339.patch-series@thinky>

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 807df3227d7674d7957c576551d552acf15bb96f

Don't pass expr to XFS_TEST_ERROR.  Most calls pass a constant false,
and the places that do pass an expression become cleaner by moving it
out.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[aalbersh: remove argument from a macro and fix call in defer_item.c]
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/defer_item.c     |  2 +-
 libxfs/libxfs_priv.h    |  2 +-
 libxfs/xfs_ag_resv.c    |  7 +++----
 libxfs/xfs_alloc.c      |  5 ++---
 libxfs/xfs_attr_leaf.c  |  2 +-
 libxfs/xfs_bmap.c       | 17 ++++++++---------
 libxfs/xfs_btree.c      |  2 +-
 libxfs/xfs_da_btree.c   |  2 +-
 libxfs/xfs_dir2.c       |  2 +-
 libxfs/xfs_exchmaps.c   |  4 ++--
 libxfs/xfs_ialloc.c     |  2 +-
 libxfs/xfs_inode_buf.c  |  4 ++--
 libxfs/xfs_inode_fork.c |  3 +--
 libxfs/xfs_metafile.c   |  2 +-
 libxfs/xfs_refcount.c   |  7 +++----
 libxfs/xfs_rmap.c       |  2 +-
 libxfs/xfs_rtbitmap.c   |  2 +-
 17 files changed, 31 insertions(+), 36 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 4530583dda..3dc938d514 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -754,7 +754,7 @@
 	 */
 	args->trans = tp;
 
-	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_LARP)) {
+	if (XFS_TEST_ERROR(args->dp->i_mount, XFS_ERRTAG_LARP)) {
 		error = -EIO;
 		goto out;
 	}
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 48a84a1089..5474865a67 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -185,7 +185,7 @@
 #define XFS_STATS_INC(mp, count)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_ADD(mp, count, x)	do { (mp) = (mp); } while (0)
-#define XFS_TEST_ERROR(expr,a,b)	( expr )
+#define XFS_TEST_ERROR(a,b)		(false)
 
 #define __section(section)	__attribute__((__section__(section)))
 
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 83cac20331..842e797b2f 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -91,9 +91,8 @@
 	trace_xfs_ag_resv_critical(pag, type, avail);
 
 	/* Critically low if less than 10% or max btree height remains. */
-	return XFS_TEST_ERROR(avail < orig / 10 ||
-			      avail < mp->m_agbtree_maxlevels,
-			mp, XFS_ERRTAG_AG_RESV_CRITICAL);
+	return avail < orig / 10 || avail < mp->m_agbtree_maxlevels ||
+		XFS_TEST_ERROR(mp, XFS_ERRTAG_AG_RESV_CRITICAL);
 }
 
 /*
@@ -202,7 +201,7 @@
 		return -EINVAL;
 	}
 
-	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_AG_RESV_FAIL))
+	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_AG_RESV_FAIL))
 		error = -ENOSPC;
 	else
 		error = xfs_dec_fdblocks(mp, hidden_space, true);
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index a9fb29ea99..311f5342d6 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -3317,7 +3317,7 @@
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_agf_verify(bp);
-		if (XFS_TEST_ERROR(fa, mp, XFS_ERRTAG_ALLOC_READ_AGF))
+		if (fa || XFS_TEST_ERROR(mp, XFS_ERRTAG_ALLOC_READ_AGF))
 			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 	}
 }
@@ -4015,8 +4015,7 @@
 	ASSERT(len != 0);
 	ASSERT(type != XFS_AG_RESV_AGFL);
 
-	if (XFS_TEST_ERROR(false, mp,
-			XFS_ERRTAG_FREE_EXTENT))
+	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_FREE_EXTENT))
 		return -EIO;
 
 	error = xfs_free_extent_fix_freelist(tp, pag, &agbp);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index cfb8d40e51..29e9a419d0 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1209,7 +1209,7 @@
 
 	trace_xfs_attr_leaf_to_node(args);
 
-	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_ATTR_LEAF_TO_NODE)) {
+	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_ATTR_LEAF_TO_NODE)) {
 		error = -EIO;
 		goto out;
 	}
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index e6a1922abb..f2f616e521 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3648,8 +3648,7 @@
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen = min(ap->length, mp->m_ag_max_usable);
 
-	if (unlikely(XFS_TEST_ERROR(false, mp,
-			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
+	if (unlikely(XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
 		error = xfs_bmap_exact_minlen_extent_alloc(ap, &args);
 	else if ((ap->datatype & XFS_ALLOC_USERDATA) &&
 			xfs_inode_is_filestream(ap->ip))
@@ -3835,7 +3834,7 @@
 	}
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
-	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
@@ -4186,7 +4185,7 @@
 			(XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO));
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
-	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
@@ -4531,7 +4530,7 @@
 			(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC));
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
-	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
@@ -5665,7 +5664,7 @@
 	int			logflags = 0;
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
-	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
@@ -5781,7 +5780,7 @@
 	int			logflags = 0;
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
-	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
@@ -5886,7 +5885,7 @@
 	int				i = 0;
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
-	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
@@ -6051,7 +6050,7 @@
 
 	trace_xfs_bmap_deferred(bi);
 
-	if (XFS_TEST_ERROR(false, tp->t_mountp, XFS_ERRTAG_BMAP_FINISH_ONE))
+	if (XFS_TEST_ERROR(tp->t_mountp, XFS_ERRTAG_BMAP_FINISH_ONE))
 		return -EIO;
 
 	switch (bi->bi_type) {
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 8576611994..1404d86fb9 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -303,7 +303,7 @@
 
 	fa = __xfs_btree_check_block(cur, block, level, bp);
 	if (XFS_IS_CORRUPT(mp, fa != NULL) ||
-	    XFS_TEST_ERROR(false, mp, xfs_btree_block_errtag(cur))) {
+	    XFS_TEST_ERROR(mp, xfs_btree_block_errtag(cur))) {
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
 		xfs_btree_mark_sick(cur);
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index af3fcdf5e4..37be99bd54 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -561,7 +561,7 @@
 
 	trace_xfs_da_split(state->args);
 
-	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_DA_LEAF_SPLIT))
+	if (XFS_TEST_ERROR(state->mp, XFS_ERRTAG_DA_LEAF_SPLIT))
 		return -EIO;
 
 	/*
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 1285019b67..d5f2e516e5 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -222,7 +222,7 @@
 	bool		ino_ok = xfs_verify_dir_ino(mp, ino);
 
 	if (XFS_IS_CORRUPT(mp, !ino_ok) ||
-	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_DIR_INO_VALIDATE)) {
+	    XFS_TEST_ERROR(mp, XFS_ERRTAG_DIR_INO_VALIDATE)) {
 		xfs_warn(mp, "Invalid inode number 0x%Lx",
 				(unsigned long long) ino);
 		return -EFSCORRUPTED;
diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 2d75135494..8e39324d42 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -613,7 +613,7 @@
 			return error;
 	}
 
-	if (XFS_TEST_ERROR(false, tp->t_mountp, XFS_ERRTAG_EXCHMAPS_FINISH_ONE))
+	if (XFS_TEST_ERROR(tp->t_mountp, XFS_ERRTAG_EXCHMAPS_FINISH_ONE))
 		return -EIO;
 
 	/* If we still have work to do, ask for a new transaction. */
@@ -879,7 +879,7 @@
 				&new_nextents))
 		return -EFBIG;
 
-	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS) &&
+	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS) &&
 	    new_nextents > 10)
 		return -EFBIG;
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 0efad4cfda..9f4ec7bbc0 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2701,7 +2701,7 @@
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_agi_verify(bp);
-		if (XFS_TEST_ERROR(fa, mp, XFS_ERRTAG_IALLOC_READ_AGI))
+		if (fa || XFS_TEST_ERROR(mp, XFS_ERRTAG_IALLOC_READ_AGI))
 			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 	}
 }
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 4eca3d6dd6..e2c87ca03c 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -58,8 +58,8 @@
 		di_ok = xfs_verify_magic16(bp, dip->di_magic) &&
 			xfs_dinode_good_version(mp, dip->di_version) &&
 			xfs_verify_agino_or_null(bp->b_pag, unlinked_ino);
-		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
-						XFS_ERRTAG_ITOBP_INOTOBP))) {
+		if (unlikely(!di_ok ||
+				XFS_TEST_ERROR(mp, XFS_ERRTAG_ITOBP_INOTOBP))) {
 			if (readahead) {
 				bp->b_flags &= ~XBF_DONE;
 				xfs_buf_ioerror(bp, -EIO);
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 52740e8e88..329d52cc52 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -754,8 +754,7 @@
 	if (nr_exts < ifp->if_nextents)
 		return -EFBIG;
 
-	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS) &&
-	    nr_exts > 10)
+	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS) && nr_exts > 10)
 		return -EFBIG;
 
 	if (nr_exts > xfs_iext_max_nextents(has_large, whichfork)) {
diff --git a/libxfs/xfs_metafile.c b/libxfs/xfs_metafile.c
index 6ded87d09a..9c3751f581 100644
--- a/libxfs/xfs_metafile.c
+++ b/libxfs/xfs_metafile.c
@@ -119,7 +119,7 @@
 			div_u64(mp->m_metafile_resv_target, 10)))
 		return true;
 
-	return XFS_TEST_ERROR(false, mp, XFS_ERRTAG_METAFILE_RESV_CRITICAL);
+	return XFS_TEST_ERROR(mp, XFS_ERRTAG_METAFILE_RESV_CRITICAL);
 }
 
 /* Allocate a block from the metadata file's reservation. */
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 4d31c3379d..f9714acd9a 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1111,8 +1111,7 @@
 	 * refcount continue update "error" has been injected.
 	 */
 	if (cur->bc_refc.nr_ops > 2 &&
-	    XFS_TEST_ERROR(false, cur->bc_mp,
-			XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE))
+	    XFS_TEST_ERROR(cur->bc_mp, XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE))
 		return false;
 
 	if (cur->bc_refc.nr_ops == 0)
@@ -1396,7 +1395,7 @@
 
 	trace_xfs_refcount_deferred(mp, ri);
 
-	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE))
+	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE))
 		return -EIO;
 
 	/*
@@ -1509,7 +1508,7 @@
 
 	trace_xfs_refcount_deferred(mp, ri);
 
-	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE))
+	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE))
 		return -EIO;
 
 	/*
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 8c0c22a349..33e856875d 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2689,7 +2689,7 @@
 
 	trace_xfs_rmap_deferred(mp, ri);
 
-	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RMAP_FINISH_ONE))
+	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_RMAP_FINISH_ONE))
 		return -EIO;
 
 	/*
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 34425a9336..354ebb8d06 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1062,7 +1062,7 @@
 	ASSERT(rbmip->i_itemp != NULL);
 	xfs_assert_ilocked(rbmip, XFS_ILOCK_EXCL);
 
-	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FREE_EXTENT))
+	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_FREE_EXTENT))
 		return -EIO;
 
 	error = xfs_rtcheck_alloc_range(&args, start, len);

-- 
- Andrey

