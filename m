Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB08BC636D3
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjBIW0y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjBIW0x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:26:53 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6FD6EBE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:26:50 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id gj9-20020a17090b108900b0023114156d36so7378313pjb.4
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PryoBQDSjPZI8pHTR3t1lBzNBiwygBETJqjReptnBWU=;
        b=6PKqhi1OrpEQnyv7CZ6GpjMSvCX545nkbJNdJm8oKuGXOdK784GXMsGuY5qr6vd76a
         S9u6D/CNinXmxI+SWjQkYNHoOiA0KNW6hV0ITd54fX/HsUONdDE/zdGZij4AE0e0VyLX
         8MdpkvJqiR0Rzt/hDZ/mgNDVX6IacaDDXyl6XnD+rFUG6UtO9aC5fX3qVozl6s1njVCW
         zvHF6xzxYLNurlLz0vgJamzwhfUauYc29W7gyKx9x24grwRjKsjs0Ps5JUUHSAgtsEoR
         G+xRFwPffSEtwTDnt7huEoWjDc48FfcKMPl668km7VfjNU5fx53DjSmtMtPry92TFBvX
         hNbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PryoBQDSjPZI8pHTR3t1lBzNBiwygBETJqjReptnBWU=;
        b=39hAC0NR3lR37zduEi4EDGFCrsUeKAjwyQZ1LxArHNi99kjOZY6h8qkxQqta6pMTw/
         PIzuGn/cpZsSh7AuMAQQlin+CRVbe9ZTLM3yITh2Ep7anPdE/zc878XqmnfeGZdyBoVn
         UZELTj26MC7FkBM8UXMEUBABb79yowbTRdO0FIZVzheXcX4lTUMBOjVFLXMRWtMbCKzC
         4RvcNIx6lPNvdOie51e12p+20lXRruBbbnHwXyjKHfkEYMb5DBs2JcQaI5L+dQ/ZdhWV
         OosdFUxDy3yz4oCQ0mjM3is7+dhj32rZvXcrQiuGN7eLCXaatS6EkjPuYtl8Y95A4YBC
         84dA==
X-Gm-Message-State: AO0yUKXU6Q/ibK54MK8iY5YR0gKWCt6TB7oMj7DncRYoc+zrieNouHUY
        N4sfzJ5/ymUGQav6kGWw4ISnGhQRxyxWE4WM
X-Google-Smtp-Source: AK7set8tC5H6Zo3QIqOSFmJPkhluPLGS2G/qteH5oSw3CTuu38IuHSRJjD/0Pln685HlzMVm0Ert7w==
X-Received: by 2002:a05:6a20:1d62:b0:bc:b98c:a8b3 with SMTP id cs34-20020a056a201d6200b000bcb98ca8b3mr9475235pzb.32.1675981609671;
        Thu, 09 Feb 2023 14:26:49 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id k23-20020aa792d7000000b005931a44a239sm1931162pfa.112.2023.02.09.14.26.49
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:26:49 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOWP-Sl
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcOt-2q
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 37/42] xfs: factor out MRU hit case in xfs_filestream_select_ag
Date:   Fri, 10 Feb 2023 09:18:20 +1100
Message-Id: <20230209221825.3722244-38-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because it now stands out like a sore thumb. Factoring out this case
starts the process of simplifying xfs_filestream_select_ag() again.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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
+	error = xfs_filestream_select_ag_mru(ap, args, pip, &agno, blen);
+	if (error || *blen >= args->maxlen)
+		goto out_rele;
 
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
-
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

