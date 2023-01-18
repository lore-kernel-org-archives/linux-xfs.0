Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91607C32793
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjARWpf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjARWpT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:19 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C2461D4A
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:18 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso53659pjo.3
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hyb8kFqnYO+7TbGRi2aAzXLcH3t+q4Rx2pDf7LxCmw8=;
        b=as7scDEOGEym7EiyON7KXQ+uo6zlFI2VXRtoEnSgPNxpCkwESICoXgBgaTnRx0MWw1
         hKwvOKjK717+B/ErOeyspCxG7ZfC8k6hz40Yl2LctKubY9UdFDmntfACNvqxdShMUlKm
         oCrGFf2ntpTX4kQYcgFEtq3YTqGK10u+eb6cFCNWG7OaLVkA/rn57rkLHGlhl7goPW0s
         nzPvpuA5NjvK1Cs6bnY4C+ut5mLHiPuqhBZnn1bycQSrxt0aHV3pvP8eI+3sRz5Zt3KV
         h1E0BTdh2yUztZcsZD7AF6MPBOT6tuAGCg8AXazEJOKRIcX25I0sigDc1NHW+8HKw2fT
         0M2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hyb8kFqnYO+7TbGRi2aAzXLcH3t+q4Rx2pDf7LxCmw8=;
        b=eoSu1nY6teli/JxQPpqUWogvp6bS2hLmQCDiIrWRcW+V56pkcXTlyXifXrj2Kx1CFf
         z9nk7Vrzi6izqpvStoLXBhGl3qImutFYJxsqv2cV/zaiInfJEThx4E1T+OslNVXNLPye
         C6MIf7SH2P+f1c8sImMKBdwsO3fEhHtvPGO20GEhMvEH3z3lYP8pU2Tz7MNC6a89xH2M
         3kw7N/J2uBHgfTkYFFHWjsZ/8HG+nerw+aXDXk72stAP9/RcNWSZoITMfcR5vX4X6XH/
         0rqT5LKSDswWfQMSzT7MEC3rRRuWRlJUHmCDFVGUIwrmrHIEw8CTKYV9M2sEzBFlzLt5
         P1dg==
X-Gm-Message-State: AFqh2kqG6bDdUiXKCPKer2La7c//os0mQE7Q3XwnX37PixGViMOYRHmd
        PFrhzNRgZFKSPJ+kYFQxhkuPc4d/r9sbiu7/
X-Google-Smtp-Source: AMrXdXvKiiEsP6vv8HBDsmxTBUTjy6HSMAx1JFk+or7sxROrSzjnMvdx37RY4nTibQzKGSlJfsLuJg==
X-Received: by 2002:a05:6a20:441:b0:b8:9f05:5216 with SMTP id b1-20020a056a20044100b000b89f055216mr7891065pzb.57.1674081918291;
        Wed, 18 Jan 2023 14:45:18 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id g15-20020a63200f000000b004d1d89ec63fsm48396pgg.6.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:16 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iYH-PX
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FFK-2Y
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 35/42] xfs: merge new filestream AG selection into xfs_filestream_select_ag()
Date:   Thu, 19 Jan 2023 09:44:58 +1100
Message-Id: <20230118224505.1964941-36-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This is largely a wrapper around xfs_filestream_pick_ag() that
repeats a lot of the lookups that we just merged back into
xfs_filestream_select_ag() from the lookup code. Merge the
xfs_filestream_new_ag() code back into _select_ag() to get rid
of all the unnecessary logic.

Indeed, this makes it obvious that if we have no parent inode,
the filestreams allocator always selects AG 0 regardless of whether
it is fit for purpose or not.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_filestream.c | 112 ++++++++++++++--------------------------
 1 file changed, 40 insertions(+), 72 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 23044dab2001..713766729dcf 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -98,16 +98,18 @@ xfs_fstrm_free_func(
 static int
 xfs_filestream_pick_ag(
 	struct xfs_inode	*ip,
-	xfs_agnumber_t		startag,
 	xfs_agnumber_t		*agp,
 	int			flags,
-	xfs_extlen_t		minlen)
+	xfs_extlen_t		*longest)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_fstrm_item	*item;
 	struct xfs_perag	*pag;
-	xfs_extlen_t		longest, free = 0, minfree, maxfree = 0;
-	xfs_agnumber_t		ag, max_ag = NULLAGNUMBER;
+	xfs_extlen_t		minlen = *longest;
+	xfs_extlen_t		free = 0, minfree, maxfree = 0;
+	xfs_agnumber_t		startag = *agp;
+	xfs_agnumber_t		ag = startag;
+	xfs_agnumber_t		max_ag = NULLAGNUMBER;
 	int			err, trylock, nscan;
 
 	ASSERT(S_ISDIR(VFS_I(ip)->i_mode));
@@ -115,7 +117,6 @@ xfs_filestream_pick_ag(
 	/* 2% of an AG's blocks must be free for it to be chosen. */
 	minfree = mp->m_sb.sb_agblocks / 50;
 
-	ag = startag;
 	*agp = NULLAGNUMBER;
 
 	/* For the first pass, don't sleep trying to init the per-AG. */
@@ -125,8 +126,8 @@ xfs_filestream_pick_ag(
 		trace_xfs_filestream_scan(mp, ip->i_ino, ag);
 
 		pag = xfs_perag_get(mp, ag);
-		longest = 0;
-		err = xfs_bmap_longest_free_extent(pag, NULL, &longest);
+		*longest = 0;
+		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
 		if (err) {
 			xfs_perag_put(pag);
 			if (err != -EAGAIN)
@@ -152,7 +153,7 @@ xfs_filestream_pick_ag(
 			goto next_ag;
 		}
 
-		if (((minlen && longest >= minlen) ||
+		if (((minlen && *longest >= minlen) ||
 		     (!minlen && pag->pagf_freeblks >= minfree)) &&
 		    (!xfs_perag_prefers_metadata(pag) ||
 		     !(flags & XFS_PICK_USERDATA) ||
@@ -258,58 +259,6 @@ xfs_filestream_get_parent(
 	return dir ? XFS_I(dir) : NULL;
 }
 
-/*
- * Pick a new allocation group for the current file and its file stream.
- *
- * This is called when the allocator can't find a suitable extent in the
- * current AG, and we have to move the stream into a new AG with more space.
- */
-static int
-xfs_filestream_new_ag(
-	struct xfs_bmalloca	*ap,
-	xfs_agnumber_t		*agp)
-{
-	struct xfs_inode	*ip = ap->ip, *pip;
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_extlen_t		minlen = ap->length;
-	xfs_agnumber_t		startag = 0;
-	int			flags = 0;
-	int			err = 0;
-	struct xfs_mru_cache_elem *mru;
-
-	*agp = NULLAGNUMBER;
-
-	pip = xfs_filestream_get_parent(ip);
-	if (!pip)
-		goto exit;
-
-	mru = xfs_mru_cache_remove(mp->m_filestream, pip->i_ino);
-	if (mru) {
-		struct xfs_fstrm_item *item =
-			container_of(mru, struct xfs_fstrm_item, mru);
-		startag = (item->ag + 1) % mp->m_sb.sb_agcount;
-	}
-
-	if (ap->datatype & XFS_ALLOC_USERDATA)
-		flags |= XFS_PICK_USERDATA;
-	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
-		flags |= XFS_PICK_LOWSPACE;
-
-	err = xfs_filestream_pick_ag(pip, startag, agp, flags, minlen);
-
-	/*
-	 * Only free the item here so we skip over the old AG earlier.
-	 */
-	if (mru)
-		xfs_fstrm_free_func(mp, mru);
-
-	xfs_irele(pip);
-exit:
-	if (*agp == NULLAGNUMBER)
-		*agp = 0;
-	return err;
-}
-
 /*
  * Search for an allocation group with a single extent large enough for
  * the request.  If one isn't found, then the largest available free extent is
@@ -326,6 +275,7 @@ xfs_filestream_select_ag(
 	struct xfs_inode	*pip = NULL;
 	xfs_agnumber_t		agno = NULLAGNUMBER;
 	struct xfs_mru_cache_elem *mru;
+	int			flags = 0;
 	int			error;
 
 	args->total = ap->total;
@@ -334,13 +284,14 @@ xfs_filestream_select_ag(
 	pip = xfs_filestream_get_parent(ap->ip);
 	if (!pip) {
 		agno = 0;
-		goto new_ag;
+		goto out_select;
 	}
 
 	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
 	if (mru) {
 		agno = container_of(mru, struct xfs_fstrm_item, mru)->ag;
 		xfs_mru_cache_done(mp->m_filestream);
+		mru = NULL;
 
 		trace_xfs_filestream_lookup(mp, ap->ip->i_ino, agno);
 		xfs_irele(pip);
@@ -354,7 +305,7 @@ xfs_filestream_select_ag(
 			xfs_perag_rele(pag);
 			if (error) {
 				if (error != -EAGAIN)
-					return error;
+					goto out_error;
 				*blen = 0;
 			}
 		}
@@ -366,13 +317,18 @@ xfs_filestream_select_ag(
 				mp->m_sb.sb_agcount;
 		mp->m_agfrotor = (mp->m_agfrotor + 1) %
 				 (mp->m_sb.sb_agcount * rotorstep);
-		xfs_irele(pip);
 	} else {
 		agno = XFS_INO_TO_AGNO(mp, pip->i_ino);
-		xfs_irele(pip);
 	}
 
-new_ag:
+	/* Changing parent AG association now, so remove the existing one. */
+	mru = xfs_mru_cache_remove(mp->m_filestream, pip->i_ino);
+	if (mru) {
+		struct xfs_fstrm_item *item =
+			container_of(mru, struct xfs_fstrm_item, mru);
+		agno = (item->ag + 1) % mp->m_sb.sb_agcount;
+		xfs_fstrm_free_func(mp, mru);
+	}
 	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
 	xfs_bmap_adjacent(ap);
 
@@ -382,33 +338,45 @@ xfs_filestream_select_ag(
 	 * larger free space available so we don't even try.
 	 */
 	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
-		return 0;
+		goto out_select;
+
+	if (ap->datatype & XFS_ALLOC_USERDATA)
+		flags |= XFS_PICK_USERDATA;
+	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
+		flags |= XFS_PICK_LOWSPACE;
 
-	error = xfs_filestream_new_ag(ap, &agno);
+	*blen = ap->length;
+	error = xfs_filestream_pick_ag(pip, &agno, flags, blen);
 	if (error)
-		return error;
+		goto out_error;
 	if (agno == NULLAGNUMBER) {
 		agno = 0;
-		goto out_select;
+		goto out_irele;
 	}
 
 	pag = xfs_perag_grab(mp, agno);
 	if (!pag)
-		goto out_select;
+		goto out_irele;
 
 	error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
 	xfs_perag_rele(pag);
 	if (error) {
 		if (error != -EAGAIN)
-			return error;
+			goto out_error;
 		*blen = 0;
 	}
 
+out_irele:
+	xfs_irele(pip);
 out_select:
 	ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
 	return 0;
-}
 
+out_error:
+	xfs_irele(pip);
+	return error;
+
+}
 
 void
 xfs_filestream_deassociate(
-- 
2.39.0

