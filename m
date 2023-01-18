Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5239CC54EBE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjARWpg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjARWpU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:20 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DAC63E1F
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:19 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id b17so561156pld.7
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jtQZpfvSmD/zQfrDfzr1/CpU1KRAS48UBEUHRo0ebaU=;
        b=VuYj/7vQk8iflTI0v7wZAxJfc+3vWz1BBX08Ldph2JlSAEnbbqZko0SoMCZybh+WJB
         AbF9Wv1qtZmP+6cR4OO2twTsTYaftHInhpb8HoRieW1uqB/9FR7N0HJFQ4Ay4phRKhnw
         TKmN/qTdUpz1gfIkF4ljqS2oIXoOFrkqdrKOGj0wwNtXrxeb2VEzkVgeiZfP17ZVX8VZ
         FCgD7BKlPtEdA1vUGkaPdZQ0spRd+jVHw7eH9QyI1pCT3GIQHWVuYPp0s+BR0pNS7HoU
         ePrBphdp9yottQJ58zHTbc6Ga+PR3rJ/3x1nCivDO9yPxsHZ7bF7a7XMvcx+1vrURseR
         poZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jtQZpfvSmD/zQfrDfzr1/CpU1KRAS48UBEUHRo0ebaU=;
        b=RvyK08cBTrFszmZGu8m6bg1u9mmsVXg+xCVCES7Mb3Adzkj8/x9yfPyBVALjYJd/EV
         u0QpP8pm2rKyp+d05OEM81bnSHRLQz1g1wx4DgPRZiiuuXH+VXAnu16Esysqc1436POV
         yhTL/X1RAboY2VjNQMuM5cl1rQ1fa9uerB/JICJliuy+v3aicJ3GKcPdLboSbb9KZSSP
         VEBH9sqNIhxUdr4Pti+Q2ePcJvYyefvocoPqr5Sfus/7LwdkmoHuF+T/HyFTSEYdaHVG
         B6YDbvGhatzcHKOy8+2RxyhB88/9NYNNvxMNsRmFfIr5UNd8LvfsQi+XZDuSPWMFx9FB
         fXLQ==
X-Gm-Message-State: AFqh2kqgbJtC8CCzPymLuyXC2hMdPqj2oiadfDgpaxqdj63S9C45qifq
        m7mFx7DUr225dVaM3hFbsW1jDKFUcmUGfyRE
X-Google-Smtp-Source: AMrXdXtJWumIRJRp8olnrI+OY8Kf2nMC9KaCeQNJ5ZKYGHwerqzNeZbQ/QIxu05Ra+L7QqIXm/RN0g==
X-Received: by 2002:a17:90a:3e46:b0:229:180a:a18c with SMTP id t6-20020a17090a3e4600b00229180aa18cmr8822966pjm.38.1674081918925;
        Wed, 18 Jan 2023 14:45:18 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id x11-20020a17090aa38b00b00226eadf094dsm1828559pjp.30.2023.01.18.14.45.14
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:16 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iYO-RN
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FFU-2k
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 37/42] xfs: factor out MRU hit case in xfs_filestream_select_ag
Date:   Thu, 19 Jan 2023 09:45:00 +1100
Message-Id: <20230118224505.1964941-38-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because it now stands out like a sore thumb. Factoring out this case
starts the process of simplifying xfs_filestream_select_ag() again.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_filestream.c | 133 +++++++++++++++++++++++++---------------
 1 file changed, 83 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 95e28aae35ab..147296a1079e 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -259,10 +259,85 @@ xfs_filestream_get_parent(
 	return dir ? XFS_I(dir) : NULL;
 }
 
+/*
+ * Lookup the mru cache for an existing association. If one exists and we can
+ * use it, return with the agno and blen indicating that the allocation will
+ * proceed with that association.
+ *
+ * If we have no association, or we cannot use the current one and have to
+ * destroy it, return with blen = 0 and agno pointing at the next agno to try.
+ */
+int
+xfs_filestream_select_ag_mru(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	struct xfs_inode	*pip,
+	xfs_agnumber_t		*agno,
+	xfs_extlen_t		*blen)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_perag	*pag;
+	struct xfs_mru_cache_elem *mru;
+	int			error;
+
+	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
+	if (!mru)
+		goto out_default_agno;
+
+	*agno = container_of(mru, struct xfs_fstrm_item, mru)->ag;
+	xfs_mru_cache_done(mp->m_filestream);
+
+	trace_xfs_filestream_lookup(mp, ap->ip->i_ino, *agno);
+
+	ap->blkno = XFS_AGB_TO_FSB(args->mp, *agno, 0);
+	xfs_bmap_adjacent(ap);
+
+	pag = xfs_perag_grab(mp, *agno);
+	if (!pag)
+		goto out_default_agno;
+
+	error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
+	xfs_perag_rele(pag);
+	if (error) {
+		if (error != -EAGAIN)
+			return error;
+		*blen = 0;
+	}
+
+	/*
+	 * We are done if there's still enough contiguous free space to succeed.
+	 */
+	if (*blen >= args->maxlen)
+		return 0;
+
+	/* Changing parent AG association now, so remove the existing one. */
+	mru = xfs_mru_cache_remove(mp->m_filestream, pip->i_ino);
+	if (mru) {
+		struct xfs_fstrm_item *item =
+			container_of(mru, struct xfs_fstrm_item, mru);
+		*agno = (item->ag + 1) % mp->m_sb.sb_agcount;
+		xfs_fstrm_free_func(mp, mru);
+		return 0;
+	}
+
+out_default_agno:
+	if (xfs_is_inode32(mp)) {
+		xfs_agnumber_t	 rotorstep = xfs_rotorstep;
+		*agno = (mp->m_agfrotor / rotorstep) %
+				mp->m_sb.sb_agcount;
+		mp->m_agfrotor = (mp->m_agfrotor + 1) %
+				 (mp->m_sb.sb_agcount * rotorstep);
+		return 0;
+	}
+	*agno = XFS_INO_TO_AGNO(mp, pip->i_ino);
+	return 0;
+
+}
+
 /*
  * Search for an allocation group with a single extent large enough for
- * the request.  If one isn't found, then the largest available free extent is
- * returned as the best length possible.
+ * the request.  If one isn't found, then adjust the minimum allocation
+ * size to the largest space found.
  */
 int
 xfs_filestream_select_ag(
@@ -271,12 +346,10 @@ xfs_filestream_select_ag(
 	xfs_extlen_t		*blen)
 {
 	struct xfs_mount	*mp = ap->ip->i_mount;
-	struct xfs_perag	*pag;
 	struct xfs_inode	*pip = NULL;
-	xfs_agnumber_t		agno = NULLAGNUMBER;
-	struct xfs_mru_cache_elem *mru;
+	xfs_agnumber_t		agno;
 	int			flags = 0;
-	int			error = 0;
+	int			error;
 
 	args->total = ap->total;
 	*blen = 0;
@@ -287,48 +360,10 @@ xfs_filestream_select_ag(
 		goto out_select;
 	}
 
-	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
-	if (mru) {
-		agno = container_of(mru, struct xfs_fstrm_item, mru)->ag;
-		xfs_mru_cache_done(mp->m_filestream);
-		mru = NULL;
-
-		trace_xfs_filestream_lookup(mp, ap->ip->i_ino, agno);
-		xfs_irele(pip);
-
-		ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
-		xfs_bmap_adjacent(ap);
-
-		pag = xfs_perag_grab(mp, agno);
-		if (pag) {
-			error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-			xfs_perag_rele(pag);
-			if (error) {
-				if (error != -EAGAIN)
-					goto out_error;
-				*blen = 0;
-			}
-		}
-		if (*blen >= args->maxlen)
-			goto out_select;
-	} else if (xfs_is_inode32(mp)) {
-		xfs_agnumber_t	 rotorstep = xfs_rotorstep;
-		agno = (mp->m_agfrotor / rotorstep) %
-				mp->m_sb.sb_agcount;
-		mp->m_agfrotor = (mp->m_agfrotor + 1) %
-				 (mp->m_sb.sb_agcount * rotorstep);
-	} else {
-		agno = XFS_INO_TO_AGNO(mp, pip->i_ino);
-	}
+	error = xfs_filestream_select_ag_mru(ap, args, pip, &agno, blen);
+	if (error || *blen >= args->maxlen)
+		goto out_rele;
 
-	/* Changing parent AG association now, so remove the existing one. */
-	mru = xfs_mru_cache_remove(mp->m_filestream, pip->i_ino);
-	if (mru) {
-		struct xfs_fstrm_item *item =
-			container_of(mru, struct xfs_fstrm_item, mru);
-		agno = (item->ag + 1) % mp->m_sb.sb_agcount;
-		xfs_fstrm_free_func(mp, mru);
-	}
 	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
 	xfs_bmap_adjacent(ap);
 
@@ -347,8 +382,6 @@ xfs_filestream_select_ag(
 
 	*blen = ap->length;
 	error = xfs_filestream_pick_ag(pip, &agno, flags, blen);
-	if (error)
-		goto out_error;
 	if (agno == NULLAGNUMBER) {
 		agno = 0;
 		*blen = 0;
@@ -356,7 +389,7 @@ xfs_filestream_select_ag(
 
 out_select:
 	ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
-out_error:
+out_rele:
 	xfs_irele(pip);
 	return error;
 
-- 
2.39.0

