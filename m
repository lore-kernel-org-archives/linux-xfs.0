Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7878EC6379F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjARWs2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjARWsQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:48:16 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3262D4CE40
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:48:16 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id i65so157190pfc.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4MxGyrhzueH+GZD55kMB+bnwd+X72Zf+Opr0UX/i4ng=;
        b=tJJ033buIiOhGy1JV2jMGWJosWvvr+1hh5LXnjtRUqgT1X27+MNjMCwqpJEPrqQcmY
         9ozf2TaARw5h6GDPOxrHthRCQmxlNZpI1zjm76gpUqrryCHwWUAgrAIUNiEjCq7B4oWU
         Ldgvc5SrKItUZjNC4izBtIEA9lRv2wrx8QTmAksu+oKPWP09DwGK5EVTccH+Tif4YKf2
         HGozP4MeWIy/oj9N5Sg0UGfuXvZYVlxfX9eIeOYBeA2X44s10aVyRNd+xifu/1Y3gE8m
         oo2uODwHWPaqOMVohXXmkHVxPCz964rKKpQI7/iLSIRhXVOfr6yRYCgGlZ1iQ3NvpWt2
         OqPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4MxGyrhzueH+GZD55kMB+bnwd+X72Zf+Opr0UX/i4ng=;
        b=1QrQs9KLijv+g/5CkgNha3glJKw8SJhtSz5LwvKEugSksJ9l4lfS/XhTMetWIzhbvr
         vFZutTBzaAUk3nW3IODiasrRWr1Y5n6lDRVSQ5kJ4IldXAbneWr20FLD4WJO3F2iISY3
         HBcOTa6/OKnphcAhC8VdH58cyaEOR8be3U9DcJMMAdfs2eBhqw2Bhhz2BzjMkkG//pWD
         o1KGEbvXUGhAxOd+OPQJ2NCU+p+X7G+7mNWWCX/0p+E6Sk7VNGKX5n/WOAlqVYZHWOLM
         W6c8/f6qbUcGohyNg64y2zW4PjP6BCx1Bj2Y/Wj3Lcrnq5B7Cw/YAgoEUSYpdxnhKogS
         NEzQ==
X-Gm-Message-State: AFqh2koyzRz6+9g12xGS6a2fO2WeoYY37u76NzVDt0E77STPcbibdKsA
        PA1ynqsje6r8bRWlMjp2rz90S0SwjXlVZWXP
X-Google-Smtp-Source: AMrXdXtUPCWolxe+ilb5jtRRqGRHaWimlCOai+ya3ZqS6XwpK/TsiXvZaWm6r0FZDPZDH8SrE/EQ0A==
X-Received: by 2002:a05:6a00:278d:b0:56b:f51d:820a with SMTP id bd13-20020a056a00278d00b0056bf51d820amr9141422pfb.7.1674082095652;
        Wed, 18 Jan 2023 14:48:15 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id w67-20020a628246000000b005892ea4f092sm18465643pfd.95.2023.01.18.14.48.15
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:48:15 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iYQ-SF
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FFZ-2p
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 38/42] xfs: track an active perag reference in filestreams
Date:   Thu, 19 Jan 2023 09:45:01 +1100
Message-Id: <20230118224505.1964941-39-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Rather than just track the agno of the reference, track a referenced
perag pointer instead. This will allow active filestreams to prevent
AGs from going away until the filestreams have been torn down.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_filestream.c | 100 +++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 147296a1079e..c92429272ff7 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -23,7 +23,7 @@
 
 struct xfs_fstrm_item {
 	struct xfs_mru_cache_elem	mru;
-	xfs_agnumber_t			ag; /* AG in use for this directory */
+	struct xfs_perag		*pag; /* AG in use for this directory */
 };
 
 enum xfs_fstrm_alloc {
@@ -50,43 +50,18 @@ xfs_filestream_peek_ag(
 	return ret;
 }
 
-static int
-xfs_filestream_get_ag(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	agno)
-{
-	struct xfs_perag *pag;
-	int		ret;
-
-	pag = xfs_perag_get(mp, agno);
-	ret = atomic_inc_return(&pag->pagf_fstrms);
-	xfs_perag_put(pag);
-	return ret;
-}
-
-static void
-xfs_filestream_put_ag(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	agno)
-{
-	struct xfs_perag *pag;
-
-	pag = xfs_perag_get(mp, agno);
-	atomic_dec(&pag->pagf_fstrms);
-	xfs_perag_put(pag);
-}
-
 static void
 xfs_fstrm_free_func(
 	void			*data,
 	struct xfs_mru_cache_elem *mru)
 {
-	struct xfs_mount	*mp = data;
 	struct xfs_fstrm_item	*item =
 		container_of(mru, struct xfs_fstrm_item, mru);
+	struct xfs_perag	*pag = item->pag;
 
-	xfs_filestream_put_ag(mp, item->ag);
-	trace_xfs_filestream_free(mp, mru->key, item->ag);
+	trace_xfs_filestream_free(pag->pag_mount, mru->key, pag->pag_agno);
+	atomic_dec(&pag->pagf_fstrms);
+	xfs_perag_rele(pag);
 
 	kmem_free(item);
 }
@@ -105,11 +80,11 @@ xfs_filestream_pick_ag(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_fstrm_item	*item;
 	struct xfs_perag	*pag;
+	struct xfs_perag	*max_pag = NULL;
 	xfs_extlen_t		minlen = *longest;
 	xfs_extlen_t		free = 0, minfree, maxfree = 0;
 	xfs_agnumber_t		startag = *agp;
 	xfs_agnumber_t		ag = startag;
-	xfs_agnumber_t		max_ag = NULLAGNUMBER;
 	int			err, trylock, nscan;
 
 	ASSERT(S_ISDIR(VFS_I(ip)->i_mode));
@@ -125,13 +100,16 @@ xfs_filestream_pick_ag(
 	for (nscan = 0; 1; nscan++) {
 		trace_xfs_filestream_scan(mp, ip->i_ino, ag);
 
-		pag = xfs_perag_get(mp, ag);
+		err = 0;
+		pag = xfs_perag_grab(mp, ag);
+		if (!pag)
+			goto next_ag;
 		*longest = 0;
 		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
 		if (err) {
-			xfs_perag_put(pag);
+			xfs_perag_rele(pag);
 			if (err != -EAGAIN)
-				return err;
+				break;
 			/* Couldn't lock the AGF, skip this AG. */
 			goto next_ag;
 		}
@@ -139,7 +117,10 @@ xfs_filestream_pick_ag(
 		/* Keep track of the AG with the most free blocks. */
 		if (pag->pagf_freeblks > maxfree) {
 			maxfree = pag->pagf_freeblks;
-			max_ag = ag;
+			if (max_pag)
+				xfs_perag_rele(max_pag);
+			atomic_inc(&pag->pag_active_ref);
+			max_pag = pag;
 		}
 
 		/*
@@ -148,8 +129,9 @@ xfs_filestream_pick_ag(
 		 * loop, and it guards against two filestreams being established
 		 * in the same AG as each other.
 		 */
-		if (xfs_filestream_get_ag(mp, ag) > 1) {
-			xfs_filestream_put_ag(mp, ag);
+		if (atomic_inc_return(&pag->pagf_fstrms) > 1) {
+			atomic_dec(&pag->pagf_fstrms);
+			xfs_perag_rele(pag);
 			goto next_ag;
 		}
 
@@ -161,15 +143,12 @@ xfs_filestream_pick_ag(
 
 			/* Break out, retaining the reference on the AG. */
 			free = pag->pagf_freeblks;
-			xfs_perag_put(pag);
-			*agp = ag;
 			break;
 		}
 
 		/* Drop the reference on this AG, it's not usable. */
-		xfs_filestream_put_ag(mp, ag);
+		atomic_dec(&pag->pagf_fstrms);
 next_ag:
-		xfs_perag_put(pag);
 		/* Move to the next AG, wrapping to AG 0 if necessary. */
 		if (++ag >= mp->m_sb.sb_agcount)
 			ag = 0;
@@ -194,10 +173,10 @@ xfs_filestream_pick_ag(
 		 * Take the AG with the most free space, regardless of whether
 		 * it's already in use by another filestream.
 		 */
-		if (max_ag != NULLAGNUMBER) {
-			xfs_filestream_get_ag(mp, max_ag);
+		if (max_pag) {
+			pag = max_pag;
+			atomic_inc(&pag->pagf_fstrms);
 			free = maxfree;
-			*agp = max_ag;
 			break;
 		}
 
@@ -207,17 +186,26 @@ xfs_filestream_pick_ag(
 		return 0;
 	}
 
-	trace_xfs_filestream_pick(ip, *agp, free, nscan);
+	trace_xfs_filestream_pick(ip, pag ? pag->pag_agno : NULLAGNUMBER,
+			free, nscan);
 
-	if (*agp == NULLAGNUMBER)
+	if (max_pag)
+		xfs_perag_rele(max_pag);
+
+	if (err)
+		return err;
+
+	if (!pag) {
+		*agp = NULLAGNUMBER;
 		return 0;
+	}
 
 	err = -ENOMEM;
 	item = kmem_alloc(sizeof(*item), KM_MAYFAIL);
 	if (!item)
 		goto out_put_ag;
 
-	item->ag = *agp;
+	item->pag = pag;
 
 	err = xfs_mru_cache_insert(mp->m_filestream, ip->i_ino, &item->mru);
 	if (err) {
@@ -226,12 +214,14 @@ xfs_filestream_pick_ag(
 		goto out_free_item;
 	}
 
+	*agp = pag->pag_agno;
 	return 0;
 
 out_free_item:
 	kmem_free(item);
 out_put_ag:
-	xfs_filestream_put_ag(mp, *agp);
+	atomic_dec(&pag->pagf_fstrms);
+	xfs_perag_rele(pag);
 	return err;
 }
 
@@ -284,20 +274,15 @@ xfs_filestream_select_ag_mru(
 	if (!mru)
 		goto out_default_agno;
 
-	*agno = container_of(mru, struct xfs_fstrm_item, mru)->ag;
+	pag = container_of(mru, struct xfs_fstrm_item, mru)->pag;
 	xfs_mru_cache_done(mp->m_filestream);
 
-	trace_xfs_filestream_lookup(mp, ap->ip->i_ino, *agno);
+	trace_xfs_filestream_lookup(mp, ap->ip->i_ino, pag->pag_agno);
 
-	ap->blkno = XFS_AGB_TO_FSB(args->mp, *agno, 0);
+	ap->blkno = XFS_AGB_TO_FSB(args->mp, pag->pag_agno, 0);
 	xfs_bmap_adjacent(ap);
 
-	pag = xfs_perag_grab(mp, *agno);
-	if (!pag)
-		goto out_default_agno;
-
 	error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-	xfs_perag_rele(pag);
 	if (error) {
 		if (error != -EAGAIN)
 			return error;
@@ -307,6 +292,7 @@ xfs_filestream_select_ag_mru(
 	/*
 	 * We are done if there's still enough contiguous free space to succeed.
 	 */
+	*agno = pag->pag_agno;
 	if (*blen >= args->maxlen)
 		return 0;
 
@@ -315,7 +301,7 @@ xfs_filestream_select_ag_mru(
 	if (mru) {
 		struct xfs_fstrm_item *item =
 			container_of(mru, struct xfs_fstrm_item, mru);
-		*agno = (item->ag + 1) % mp->m_sb.sb_agcount;
+		*agno = (item->pag->pag_agno + 1) % mp->m_sb.sb_agcount;
 		xfs_fstrm_free_func(mp, mru);
 		return 0;
 	}
-- 
2.39.0

