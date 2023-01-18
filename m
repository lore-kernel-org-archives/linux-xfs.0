Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D0CC46467
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjARWs0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjARWsN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:48:13 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E355E63E28
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:48:12 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id s13-20020a17090a6e4d00b0022900843652so4038065pjm.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jshD/9c7V6ANEfyMPGcv0GQviC/f5uQ0vJVfnkiQWRY=;
        b=54qOFW9hp++GmNfkvsC0HisOObL8PRFVr9E+oZoLIZcFVIU4jgQh0wN8Sg8ehuY+Ot
         jDyfHiJwG/Jk5qTseGLn55vDyqUPqZxfN0QzcstuJFQxSPR8HY46NhjL4bkRiyZtIHQB
         E13aHIJp7dVSFuHSW3F8MFO8G2XBqK6ySJr4EFtC97PuruLoufuuwYNwvRRrm0JuxTZT
         mklDZ6AeoMb4e3MvLw47zay9XPDTajY0EoOjF6DxtgMCro76cvSUhUkRDx0zGYbd4NRB
         GoyEYA09RYtgoFRSRrVrODs5QsOa8uC/Q1IvR45bN2pb8AmNz498MlIijGrpCMx7vrBM
         iQSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jshD/9c7V6ANEfyMPGcv0GQviC/f5uQ0vJVfnkiQWRY=;
        b=01I+te0AN2bQiksSIDOHuyqoQX4U2F6h29m+Dlr6/59m2orXvlMR/HCFadlLxFAR2r
         Dap/sVNXSWQEa0GNWkMY00Yu7ylMG2WOftADZN9h0C/WeKDi6NW0Po7z8XJJvMt2Qdwe
         S7FMfx0QCeZoLk1e4k1XF3nkBr/oKmuK4P1fEK4EB3qAz4Y4LXJwJIhTHOo3rlCkdyb5
         5kUhnMzuVaRV/P3U3SCWq2e5dsQzANxQaNMLUaiJj8I13c3mR7jQJDOXfq4H9TLSL2YE
         MnjxymqZ0oScOMu23xWzBhxnQP3degva/xHfv9hq8BHkc0i9tuotsRhNR9aUUaF0iGqV
         p69A==
X-Gm-Message-State: AFqh2krwbpmmkJXT12Y+yZ3oOv/n3bN3W0+YQb/EdwtHUq3NU62vBABw
        EPfA5R6jyy2lMjulbaLRtCy/2K47hob8kDvQ
X-Google-Smtp-Source: AMrXdXujiMGBHygf+k28wJrIbAuQ46FQ1IxLUbmllIgmoVf+H9Buman6XwLwNx8Rf8ztxH1WUXFIMA==
X-Received: by 2002:a17:902:720a:b0:193:25b6:71bc with SMTP id ba10-20020a170902720a00b0019325b671bcmr9702127plb.25.1674082092362;
        Wed, 18 Jan 2023 14:48:12 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id v13-20020a170902f0cd00b0019324fbec59sm6294135pla.41.2023.01.18.14.48.11
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:48:11 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iYF-Ob
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FFF-2S
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 34/42] xfs: merge filestream AG lookup into xfs_filestream_select_ag()
Date:   Thu, 19 Jan 2023 09:44:57 +1100
Message-Id: <20230118224505.1964941-35-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
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
---
 fs/xfs/xfs_filestream.c | 184 +++++++++++++++-------------------------
 1 file changed, 70 insertions(+), 114 deletions(-)

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
@@ -359,83 +310,70 @@ xfs_filestream_new_ag(
 	return err;
 }
 
-static int
-xfs_filestreams_select_lengths(
+/*
+ * Search for an allocation group with a single extent large enough for
+ * the request.  If one isn't found, then the largest available free extent is
+ * returned as the best length possible.
+ */
+int
+xfs_filestream_select_ag(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
 	xfs_extlen_t		*blen)
 {
 	struct xfs_mount	*mp = ap->ip->i_mount;
 	struct xfs_perag	*pag;
-	xfs_agnumber_t		start_agno;
+	struct xfs_inode	*pip = NULL;
+	xfs_agnumber_t		agno = NULLAGNUMBER;
+	struct xfs_mru_cache_elem *mru;
 	int			error;
 
 	args->total = ap->total;
+	*blen = 0;
 
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
+	pip = xfs_filestream_get_parent(ap->ip);
+	if (!pip) {
+		agno = 0;
+		goto new_ag;
 	}
 
-	if (*blen < args->maxlen) {
-		xfs_agnumber_t	agno = start_agno;
+	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
+	if (mru) {
+		agno = container_of(mru, struct xfs_fstrm_item, mru)->ag;
+		xfs_mru_cache_done(mp->m_filestream);
 
-		error = xfs_filestream_new_ag(ap, &agno);
-		if (error)
-			return error;
-		if (agno == NULLAGNUMBER)
-			goto out_select;
+		trace_xfs_filestream_lookup(mp, ap->ip->i_ino, agno);
+		xfs_irele(pip);
 
-		pag = xfs_perag_grab(mp, agno);
-		if (!pag)
-			goto out_select;
+		ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
+		xfs_bmap_adjacent(ap);
 
-		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-		xfs_perag_rele(pag);
-		if (error) {
-			if (error != -EAGAIN)
-				return error;
-			*blen = 0;
+		pag = xfs_perag_grab(mp, agno);
+		if (pag) {
+			error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
+			xfs_perag_rele(pag);
+			if (error) {
+				if (error != -EAGAIN)
+					return error;
+				*blen = 0;
+			}
 		}
-		start_agno = agno;
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
 	}
 
-out_select:
-	/*
-	 * Set the failure fallback case to look in the selected AG as stream
-	 * may have moved.
-	 */
-	ap->blkno = args->fsbno = XFS_AGB_TO_FSB(mp, start_agno, 0);
-	return 0;
-}
-
-/*
- * Search for an allocation group with a single extent large enough for
- * the request.  If one isn't found, then the largest available free extent is
- * returned as the best length possible.
- */
-int
-xfs_filestream_select_ag(
-	struct xfs_bmalloca	*ap,
-	struct xfs_alloc_arg	*args,
-	xfs_extlen_t		*blen)
-{
-	xfs_agnumber_t		start_agno = xfs_filestream_lookup_ag(ap->ip);
-
-	/* Determine the initial block number we will target for allocation. */
-	if (start_agno == NULLAGNUMBER)
-		start_agno = 0;
-	ap->blkno = XFS_AGB_TO_FSB(args->mp, start_agno, 0);
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

