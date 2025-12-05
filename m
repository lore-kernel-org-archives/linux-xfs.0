Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF563242D4
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946921; cv=none; b=uSsHAS9TJzgoQhyiJsR+jdj2RrzvUHo+VVdidiKi33UNTgwTPRzh4uMbODXbn+WU28K7UWN2/bvXKlq67g6PKZ6ri2mLsZfXzUqWj+z5dt6n7lMegTVwo1hn6DvNlBTzFmaCXovQtVRQ3EgD3Iis6FRcWtd+p+/I9Dp66fLfpfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946921; c=relaxed/simple;
	bh=CoSeJzpu/cjs8H3WgA/DtNed8P7XQ/vuXK5yTcFjzbY=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qjBpxtL1xV/4MrkcuHNBgeCNnsWkOvGAKb9ssmzaaB3z4FGkmk84fhNGKS3MUzWL8huavf/puLuqmjnJwYZi5q/cijFQHpbbZy3ecmPCA29EqN3Dx6SpLUMFHKXMB/2t7y/djm5GbrYfiRe/4+cR2GxpYT1wimE/Bh8kc2US8tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ISUx+srq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LEzAmtiL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ISUx+srq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LEzAmtiL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mmhs6dlR/8De5ziSffJI7ycR4b8pRoK97kyNKJv8+Vk=;
	b=ISUx+srqlDzrsk1/1CqaZEoZgmY2+j97/mHMPLTFnGwlqbHH+X5iDroFeRgI75sBSVMLPf
	wgKh+wGjozZk19ir650oVlX4wRPMGAhT9kPe8VnzNfUI7Bg3iNfeg/3AZzrMu1GV1jfdLg
	FMZf1qQLP7F02XFB9suF1XYYeowqwl4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-MXCqyTDHP1SKgZzWeEokAw-1; Fri, 05 Dec 2025 10:01:34 -0500
X-MC-Unique: MXCqyTDHP1SKgZzWeEokAw-1
X-Mimecast-MFC-AGG-ID: MXCqyTDHP1SKgZzWeEokAw_1764946893
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477c49f273fso21682335e9.3
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946892; x=1765551692; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mmhs6dlR/8De5ziSffJI7ycR4b8pRoK97kyNKJv8+Vk=;
        b=LEzAmtiLlEgfTrWKdS9T2JpDWV26aG1cyredrUr1IPy+AEQcw0Zz8Q9bI8hY2BZjBe
         Jhsg7gVyiJDFXVKRztaIYilk9nqjV0w7uoEf/uFWwEO/+OCPddbfWK8Qb1CxVSHmWoNo
         gcjc8tNvfyzVltwG1v582hQPKUlAyOhWmF4aX4zIxGtNBg3O7caYMwBs7BFSf1J/vPnx
         KSe5UgrK13h03j+7quMJE7EN5jG/OlZeaPRm7pANL25Btwle+z02tT2t2+jKHmlN9tKn
         n1DeB+qcj/20jnJgecJTLn71UivNJAP2MKTpfB7uxfDlmQpEZnGbSUadOTQxznz/KuPv
         eIvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946892; x=1765551692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mmhs6dlR/8De5ziSffJI7ycR4b8pRoK97kyNKJv8+Vk=;
        b=KVSg/86ClPaqRk/z9nMdejiYkJrZO0otDWoJXnK68asNzFVojNALTKprCQQXnp5E8Q
         72Vf79Zz7t/Id00EMus0YQ2iLcTYbIqBTOJfAwmJHKg7oEo4m5fKefKTpZSXL4KyUGte
         VrbqpoEEtgqlhcfLYbADQmipW5Inr4xSCY45X/gFV6ggqbT/D4o8086aNK24Nkr7VxHD
         I194UCmc9w/JsamDR6X3lAeGEbBUE42uAXLbexmFNdkvpMLVw7j2OroNMLhzajlutGqT
         JyQaXy7+G8fCgwsqTvO/KR34yML2qlKrT/WDR9GY3KV/BZCtOuN2rbVEK4EV5FakGHWv
         6rtQ==
X-Gm-Message-State: AOJu0YwMdFG8xT2gjLDTliPD3NfrVCNzs3gLWFAuP+XcwjPOPhF019Ra
	28bVbjCzwETQ2fm2cWiC/+3VIwakzoIRfFDTmHKwP890nyMMpLLpF7WHn4c05xVn2MOjLj0JCmH
	FLQmgjxq2Nrkm8bQjAezTuXmrCWodyTihY+S4RGlO40X9nwg9MKZf8qEjgrgf1Dr5Zz/pDbc4uc
	cVcwI7tHHqdNKevXXqVB+duW9vfpW9mRBAqHbdwCZ0u2tM
X-Gm-Gg: ASbGncuRCaK6V2SrhNAJzZm/g6vB3MTzDpfZ6KoFUdCDBNr6aTowUX7xwsx3skOIUbY
	ZB9HCt1iZyvqRlHNAsY/CHAEa7mxRfIcdu4SVvmhhq9QTRtdjCzd830wUhqfK9/PWgwD1/KKAiO
	A+34eradiO0X3KvEP53iOMCN1eB071kj0lZBUZ8xvzbduMbLwq53Pzwrfa6ck6NXltR2rAgiOPJ
	Kdx+gAjp9eaC49yJ/2GrmCYqZZ5uJRRx4XqZqq7/7Ha0ZYI7gDmcUn32FX4NcNqnCyd1GV9sTx6
	85gp78jXqNNFbaBjK1xCTT49UElz3ZBokahLfU1rw2wyznxHkzAcdkerqH4BQHdUzuejcG+Yuz0
	=
X-Received: by 2002:a05:600c:4f90:b0:477:5af7:6fa with SMTP id 5b1f17b1804b1-4792af43aa3mr97331775e9.32.1764946892403;
        Fri, 05 Dec 2025 07:01:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEsAUyy1txeo4bEVjuVQxIceWV+SU1Xl928lAeSIsv9rlvcHM8GhgU/Q8dZIQu00IYc5xCaUA==
X-Received: by 2002:a05:600c:4f90:b0:477:5af7:6fa with SMTP id 5b1f17b1804b1-4792af43aa3mr97331265e9.32.1764946891786;
        Fri, 05 Dec 2025 07:01:31 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479310b8e70sm87671735e9.5.2025.12.05.07.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:01:31 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:01:30 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 1/33] xfs: remove deprecated mount options
Message-ID: <pwizqjwj3k4xfzelw3ghdvqkxufiivlzyw7iooetyokwp5ltsn@adxus3izf4ze>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: b9a176e54162f890aaf50ac8a467d725ed2f00df

These four mount options were scheduled for removal in September 2025,
so remove them now.

Cc: preichl@redhat.com
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_attr_leaf.c | 23 +++++------------------
 libxfs/xfs_bmap.c      | 14 +++-----------
 libxfs/xfs_ialloc.c    |  4 ++--
 libxfs/xfs_sb.c        |  9 +++------
 4 files changed, 13 insertions(+), 37 deletions(-)

diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 01a87b45a6..cfb8d40e51 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -664,12 +664,8 @@
 
 	/*
 	 * For attr2 we can try to move the forkoff if there is space in the
-	 * literal area, but for the old format we are done if there is no
-	 * space in the fixed attribute fork.
+	 * literal area
 	 */
-	if (!xfs_has_attr2(mp))
-		return 0;
-
 	dsize = dp->i_df.if_bytes;
 
 	switch (dp->i_df.if_format) {
@@ -720,22 +716,16 @@
 }
 
 /*
- * Switch on the ATTR2 superblock bit (implies also FEATURES2) unless:
- * - noattr2 mount option is set,
- * - on-disk version bit says it is already set, or
- * - the attr2 mount option is not set to enable automatic upgrade from attr1.
+ * Switch on the ATTR2 superblock bit (implies also FEATURES2) unless
+ * on-disk version bit says it is already set
  */
 STATIC void
 xfs_sbversion_add_attr2(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp)
 {
-	if (xfs_has_noattr2(mp))
-		return;
 	if (mp->m_sb.sb_features2 & XFS_SB_VERSION2_ATTR2BIT)
 		return;
-	if (!xfs_has_attr2(mp))
-		return;
 
 	spin_lock(&mp->m_sb_lock);
 	xfs_add_attr2(mp);
@@ -886,7 +876,7 @@
 	/*
 	 * Fix up the start offset of the attribute fork
 	 */
-	if (totsize == sizeof(struct xfs_attr_sf_hdr) && xfs_has_attr2(mp) &&
+	if (totsize == sizeof(struct xfs_attr_sf_hdr) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
 	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE)) &&
 	    !xfs_has_parent(mp)) {
@@ -897,7 +887,6 @@
 		ASSERT(dp->i_forkoff);
 		ASSERT(totsize > sizeof(struct xfs_attr_sf_hdr) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
-				!xfs_has_attr2(mp) ||
 				dp->i_df.if_format == XFS_DINODE_FMT_BTREE ||
 				xfs_has_parent(mp));
 		xfs_trans_log_inode(args->trans, dp,
@@ -1037,8 +1026,7 @@
 		bytes += xfs_attr_sf_entsize_byname(name_loc->namelen,
 					be16_to_cpu(name_loc->valuelen));
 	}
-	if (xfs_has_attr2(dp->i_mount) &&
-	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
+	if ((dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
 	    (bytes == sizeof(struct xfs_attr_sf_hdr)))
 		return -1;
 	return xfs_attr_shortform_bytesfit(dp, bytes);
@@ -1158,7 +1146,6 @@
 		 * this case.
 		 */
 		if (!(args->op_flags & XFS_DA_OP_REPLACE)) {
-			ASSERT(xfs_has_attr2(dp->i_mount));
 			ASSERT(dp->i_df.if_format != XFS_DINODE_FMT_BTREE);
 			xfs_attr_fork_remove(dp, args->trans);
 		}
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 99f5e6f9d5..e6a1922abb 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -991,8 +991,7 @@
 static int
 xfs_bmap_set_attrforkoff(
 	struct xfs_inode	*ip,
-	int			size,
-	int			*version)
+	int			size)
 {
 	int			default_size = xfs_default_attroffset(ip) >> 3;
 
@@ -1006,8 +1005,6 @@
 		ip->i_forkoff = xfs_attr_shortform_bytesfit(ip, size);
 		if (!ip->i_forkoff)
 			ip->i_forkoff = default_size;
-		else if (xfs_has_attr2(ip->i_mount) && version)
-			*version = 2;
 		break;
 	default:
 		ASSERT(0);
@@ -1029,7 +1026,6 @@
 	int			rsvd)		/* xact may use reserved blks */
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	int			version = 1;	/* superblock attr version */
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
 
@@ -1039,7 +1035,7 @@
 	ASSERT(!xfs_inode_has_attr_fork(ip));
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	error = xfs_bmap_set_attrforkoff(ip, size, &version);
+	error = xfs_bmap_set_attrforkoff(ip, size);
 	if (error)
 		return error;
 
@@ -1063,16 +1059,12 @@
 		xfs_trans_log_inode(tp, ip, logflags);
 	if (error)
 		return error;
-	if (!xfs_has_attr(mp) ||
-	   (!xfs_has_attr2(mp) && version == 2)) {
+	if (!xfs_has_attr(mp)) {
 		bool log_sb = false;
 
 		spin_lock(&mp->m_sb_lock);
 		if (!xfs_has_attr(mp)) {
 			xfs_add_attr(mp);
-			log_sb = true;
-		}
-		if (!xfs_has_attr2(mp) && version == 2) {
 			xfs_add_attr2(mp);
 			log_sb = true;
 		}
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 8fd149e184..0efad4cfda 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2135,7 +2135,7 @@
 	 * remove the chunk if the block size is large enough for multiple inode
 	 * chunks (that might not be free).
 	 */
-	if (!xfs_has_ikeep(mp) && rec.ir_free == XFS_INOBT_ALL_FREE &&
+	if (rec.ir_free == XFS_INOBT_ALL_FREE &&
 	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
 		xic->deleted = true;
 		xic->first_ino = xfs_agino_to_ino(pag, rec.ir_startino);
@@ -2281,7 +2281,7 @@
 	 * enough for multiple chunks. Leave the finobt record to remain in sync
 	 * with the inobt.
 	 */
-	if (!xfs_has_ikeep(mp) && rec.ir_free == XFS_INOBT_ALL_FREE &&
+	if (rec.ir_free == XFS_INOBT_ALL_FREE &&
 	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
 		error = xfs_btree_delete(cur, &i);
 		if (error)
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 078c75febf..dd14c3ab3b 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -140,8 +140,6 @@
 	if (sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) {
 		if (sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT)
 			features |= XFS_FEAT_LAZYSBCOUNT;
-		if (sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT)
-			features |= XFS_FEAT_ATTR2;
 		if (sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT)
 			features |= XFS_FEAT_PROJID32;
 		if (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE)
@@ -153,7 +151,7 @@
 
 	/* Always on V5 features */
 	features |= XFS_FEAT_ALIGN | XFS_FEAT_LOGV2 | XFS_FEAT_EXTFLG |
-		    XFS_FEAT_LAZYSBCOUNT | XFS_FEAT_ATTR2 | XFS_FEAT_PROJID32 |
+		    XFS_FEAT_LAZYSBCOUNT | XFS_FEAT_PROJID32 |
 		    XFS_FEAT_V3INODES | XFS_FEAT_CRC | XFS_FEAT_PQUOTINO;
 
 	/* Optional V5 features */
@@ -1522,7 +1520,8 @@
 	geo->version = XFS_FSOP_GEOM_VERSION;
 	geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
 		     XFS_FSOP_GEOM_FLAGS_DIRV2 |
-		     XFS_FSOP_GEOM_FLAGS_EXTFLG;
+		     XFS_FSOP_GEOM_FLAGS_EXTFLG |
+		     XFS_FSOP_GEOM_FLAGS_ATTR2;
 	if (xfs_has_attr(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR;
 	if (xfs_has_quota(mp))
@@ -1535,8 +1534,6 @@
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_DIRV2CI;
 	if (xfs_has_lazysbcount(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_LAZYSB;
-	if (xfs_has_attr2(mp))
-		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR2;
 	if (xfs_has_projid32(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_PROJID32;
 	if (xfs_has_crc(mp))

-- 
- Andrey

