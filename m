Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDBFC05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjBIW0I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjBIW0G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:26:06 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46A26BAB9
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:26:00 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so7858792pjq.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ILH05cYVR4uWOzvIWRTDIXWi0ZG2px5mNtHYnfaR4HU=;
        b=uIwWCrqW2FVND1F93uR4wG2EXhjZSdOWAmrmujlQZdV0C6AxIBi/ws2Oj//TwEQASE
         Q1aohfzXOmDXnKal3FkP0iyjl8gdKUXsNuLEb725If5goqOGjUFFhcYpFPe7dvU4+b7H
         VP/RUppcdG1zP2Z2y89dpAAOH/ePKWAIV+F3hXgiYad8bm7eOe+ecqr4DWnomQt9cFmQ
         4d4hJX88l8hsWaWeev91bEsjX5KNcKLIDAcSjV2/QbrnsUrfpVRpN+IINxpq67qUk8bb
         Sus3WQUaZqv6vFYEN7Bm5KNFd5jmTC6j61vl7KYrPLJvB89/lKsocjk7ZtM35eb/Lu+B
         LCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ILH05cYVR4uWOzvIWRTDIXWi0ZG2px5mNtHYnfaR4HU=;
        b=PFVyhZc+ghkK/66o+TD/Iv/xUEnuAbWpKDyA97uf2JUvrXLTvVqkMWvEj+9cL2Ogsg
         mNgvUrnEigwnGsVRPTMsuQAGV9l66bbZE/jq8ZB1AABPUOE4aSI37DJkUVR215T+XoNX
         oZPE6BJQK+5VAdKIFnh2wfCp9KkRqOGKn4n/EkhibK1XZ4XPq5FYTs+ktLuLYtzg1qkw
         3lskHx2KISnfUS1kYr5c0mDpdxC1/DY6nNKWZIJnZkJxK6dt/k1C84fBOc3g5x2ZZcbe
         ypTxUCnG5ilqpY4gHfAZZhq7o9ICOGpGtrvxDrvX1P2p9TwMkG9OW8M81uiLv8yko/cV
         +lnw==
X-Gm-Message-State: AO0yUKVg0d+pRfZlGHe/K82lqIeRyhGHkijspRcfkpyH1RIa2SCRJzk2
        1o+ufWA++x9TXpuyX0/N/LJAXdXVNGvkJn8M
X-Google-Smtp-Source: AK7set+BrmPC2mnCxBuvbdUoDSTK0OTMiKuqgFid34DGEyeOskNvF1TV9w+IMzyEHYLNfqYk5Ddm1Q==
X-Received: by 2002:a17:902:f2d2:b0:199:5135:4dfa with SMTP id h18-20020a170902f2d200b0019951354dfamr4912484plc.31.1675981560204;
        Thu, 09 Feb 2023 14:26:00 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id s15-20020a170902b18f00b00189bf5dc96dsm1989163plr.230.2023.02.09.14.25.59
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:25:59 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOWG-Pt
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcOe-2Y
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 34/42] xfs: merge filestream AG lookup into xfs_filestream_select_ag()
Date:   Fri, 10 Feb 2023 09:18:17 +1100
Message-Id: <20230209221825.3722244-35-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The lookup currently either returns the cached filestream AG or it
calls xfs_filestreams_select_lengths() to looks up a new AG. This
has verify the AG that is selected, so we end up doing "select a new
AG loop in a couple of places when only one really is needed.  Merge
the initial lookup functionality with the length selection so that
we only need to do a single pick loop on lookup or verification
failure.

This undoes a lot of the factoring that enabled the selection to be
moved over to the filestreams code. It makes
xfs_filestream_select_ag() an awful messier, but it has to be made
worse before it can get better in future patches...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_filestream.c | 196 ++++++++++++++++------------------------
 1 file changed, 76 insertions(+), 120 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index a641404aa9a6..23044dab2001 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -258,55 +258,6 @@ xfs_filestream_get_parent(
 	return dir ? XFS_I(dir) : NULL;
 }
 
-/*
- * Find the right allocation group for a file, either by finding an
- * existing file stream or creating a new one.
- *
- * Returns NULLAGNUMBER in case of an error.
- */
-static xfs_agnumber_t
-xfs_filestream_lookup_ag(
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_inode	*pip = NULL;
-	xfs_agnumber_t		startag, ag = NULLAGNUMBER;
-	struct xfs_mru_cache_elem *mru;
-
-	ASSERT(S_ISREG(VFS_I(ip)->i_mode));
-
-	pip = xfs_filestream_get_parent(ip);
-	if (!pip)
-		return NULLAGNUMBER;
-
-	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
-	if (mru) {
-		ag = container_of(mru, struct xfs_fstrm_item, mru)->ag;
-		xfs_mru_cache_done(mp->m_filestream);
-
-		trace_xfs_filestream_lookup(mp, ip->i_ino, ag);
-		goto out;
-	}
-
-	/*
-	 * Set the starting AG using the rotor for inode32, otherwise
-	 * use the directory inode's AG.
-	 */
-	if (xfs_is_inode32(mp)) {
-		xfs_agnumber_t	 rotorstep = xfs_rotorstep;
-		startag = (mp->m_agfrotor / rotorstep) % mp->m_sb.sb_agcount;
-		mp->m_agfrotor = (mp->m_agfrotor + 1) %
-		                 (mp->m_sb.sb_agcount * rotorstep);
-	} else
-		startag = XFS_INO_TO_AGNO(mp, pip->i_ino);
-
-	if (xfs_filestream_pick_ag(pip, startag, &ag, 0, 0))
-		ag = NULLAGNUMBER;
-out:
-	xfs_irele(pip);
-	return ag;
-}
-
 /*
  * Pick a new allocation group for the current file and its file stream.
  *
@@ -359,66 +310,6 @@ xfs_filestream_new_ag(
 	return err;
 }
 
-static int
-xfs_filestreams_select_lengths(
-	struct xfs_bmalloca	*ap,
-	struct xfs_alloc_arg	*args,
-	xfs_extlen_t		*blen)
-{
-	struct xfs_mount	*mp = ap->ip->i_mount;
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		start_agno;
-	int			error;
-
-	args->total = ap->total;
-
-	start_agno = XFS_FSB_TO_AGNO(mp, ap->blkno);
-	if (start_agno == NULLAGNUMBER)
-		start_agno = 0;
-
-	pag = xfs_perag_grab(mp, start_agno);
-	if (pag) {
-		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-		xfs_perag_rele(pag);
-		if (error) {
-			if (error != -EAGAIN)
-				return error;
-			*blen = 0;
-		}
-	}
-
-	if (*blen < args->maxlen) {
-		xfs_agnumber_t	agno = start_agno;
-
-		error = xfs_filestream_new_ag(ap, &agno);
-		if (error)
-			return error;
-		if (agno == NULLAGNUMBER)
-			goto out_select;
-
-		pag = xfs_perag_grab(mp, agno);
-		if (!pag)
-			goto out_select;
-
-		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-		xfs_perag_rele(pag);
-		if (error) {
-			if (error != -EAGAIN)
-				return error;
-			*blen = 0;
-		}
-		start_agno = agno;
-	}
-
-out_select:
-	/*
-	 * Set the failure fallback case to look in the selected AG as stream
-	 * may have moved.
-	 */
-	ap->blkno = args->fsbno = XFS_AGB_TO_FSB(mp, start_agno, 0);
-	return 0;
-}
-
 /*
  * Search for an allocation group with a single extent large enough for
  * the request.  If one isn't found, then the largest available free extent is
@@ -430,12 +321,59 @@ xfs_filestream_select_ag(
 	struct xfs_alloc_arg	*args,
 	xfs_extlen_t		*blen)
 {
-	xfs_agnumber_t		start_agno = xfs_filestream_lookup_ag(ap->ip);
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_perag	*pag;
+	struct xfs_inode	*pip = NULL;
+	xfs_agnumber_t		agno = NULLAGNUMBER;
+	struct xfs_mru_cache_elem *mru;
+	int			error;
 
-	/* Determine the initial block number we will target for allocation. */
-	if (start_agno == NULLAGNUMBER)
-		start_agno = 0;
-	ap->blkno = XFS_AGB_TO_FSB(args->mp, start_agno, 0);
+	args->total = ap->total;
+	*blen = 0;
+
+	pip = xfs_filestream_get_parent(ap->ip);
+	if (!pip) {
+		agno = 0;
+		goto new_ag;
+	}
+
+	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
+	if (mru) {
+		agno = container_of(mru, struct xfs_fstrm_item, mru)->ag;
+		xfs_mru_cache_done(mp->m_filestream);
+
+		trace_xfs_filestream_lookup(mp, ap->ip->i_ino, agno);
+		xfs_irele(pip);
+
+		ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
+		xfs_bmap_adjacent(ap);
+
+		pag = xfs_perag_grab(mp, agno);
+		if (pag) {
+			error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
+			xfs_perag_rele(pag);
+			if (error) {
+				if (error != -EAGAIN)
+					return error;
+				*blen = 0;
+			}
+		}
+		if (*blen >= args->maxlen)
+			goto out_select;
+	} else if (xfs_is_inode32(mp)) {
+		xfs_agnumber_t	 rotorstep = xfs_rotorstep;
+		agno = (mp->m_agfrotor / rotorstep) %
+				mp->m_sb.sb_agcount;
+		mp->m_agfrotor = (mp->m_agfrotor + 1) %
+				 (mp->m_sb.sb_agcount * rotorstep);
+		xfs_irele(pip);
+	} else {
+		agno = XFS_INO_TO_AGNO(mp, pip->i_ino);
+		xfs_irele(pip);
+	}
+
+new_ag:
+	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
 	xfs_bmap_adjacent(ap);
 
 	/*
@@ -446,14 +384,32 @@ xfs_filestream_select_ag(
 	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
 		return 0;
 
-	/*
-	 * Search for an allocation group with a single extent large enough for
-	 * the request.  If one isn't found, then adjust the minimum allocation
-	 * size to the largest space found.
-	 */
-	return xfs_filestreams_select_lengths(ap, args, blen);
+	error = xfs_filestream_new_ag(ap, &agno);
+	if (error)
+		return error;
+	if (agno == NULLAGNUMBER) {
+		agno = 0;
+		goto out_select;
+	}
+
+	pag = xfs_perag_grab(mp, agno);
+	if (!pag)
+		goto out_select;
+
+	error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
+	xfs_perag_rele(pag);
+	if (error) {
+		if (error != -EAGAIN)
+			return error;
+		*blen = 0;
+	}
+
+out_select:
+	ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
+	return 0;
 }
 
+
 void
 xfs_filestream_deassociate(
 	struct xfs_inode	*ip)
-- 
2.39.0

