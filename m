Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7717C32793
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjARWsL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjARWrx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:47:53 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E2B66CD8
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:47:37 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id x2-20020a17090a46c200b002295ca9855aso4026807pjg.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zJpmWxutomaetKGVWIq9UhyMnsLIAD4UZ0Z9oHuCJ3s=;
        b=haS4XP9toNYBbnDLYRtGc6MjZm4oyLL0uM0RVEmpW46QAUj2wqiaYzcKrFgFh4i4wy
         lEZ/LSyCpW1XvO4s41Fy/Jg4TTY3/5VTzme9jDQ5SKjsUMdw7piagdLcga0mB5/ntEml
         Osf+UnC29FU+cbCb1C/8w1ht/ofoRAgSJ3qFjYDrCDRKJwuGCAdt6N8Nj5oXKn02e7bV
         ME/PQqNpXoQ1Zqw0Ntl5UpxsV3zza0itp3+m56XYbzTq3rO3Yxq47kxwW6nH9NsNJ/yu
         DEk1GsjLkQZKzc8tkf7jS+6BTottEvfQyDhDkiSsxq9JSnBkk1seRgt9l170uTdXp4vl
         Kmuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zJpmWxutomaetKGVWIq9UhyMnsLIAD4UZ0Z9oHuCJ3s=;
        b=J3OAVMEaT5jxUbcSMfbu9wNRnkq9HxcWZkmo4TFKY9+Iw/fCwL6/o5YVBSbRKEz/lJ
         VSiR9iSKArMGjYXktY6VQkXV7vxcsg6PFTa7pXEs3FuTPyUwDKjKBl41N5bE4rB6LEAl
         /Imxdr5l4YKQEXIncorsUwHLz8ByYhoSRH/9wIIjJIoemjNSER7zNFe2mcg0z7rCVeLM
         5nSzEXDletYymof9Fo7ZZBFGYqa+kPN/5ksebulCjCDiRryTMcxy7Sag+xW4vTLduCf8
         KZqjnR3FkCYQgVV6m3B2cTL5dBXaWtk7RT0KvMQfiY0cOyTXzggsmwBFzNTluNIBDwLc
         +6yQ==
X-Gm-Message-State: AFqh2ko0+W0LdFPeKkF55Ou8HCM54wdoIhlQxTXGGb4lh6oM+j0aa4qJ
        PvHwhdYc6soC/WW0WQJZJooZUWnN1cT0+YlB
X-Google-Smtp-Source: AMrXdXs34Gsn2QQl2+TBSkaIkyPatmjWmM2KP0yx04Gi772F4eq4e4gMfF0plSvrf7/y7tV5B2g4LQ==
X-Received: by 2002:a17:902:8d83:b0:193:39bd:df97 with SMTP id v3-20020a1709028d8300b0019339bddf97mr9211100plo.14.1674082055642;
        Wed, 18 Jan 2023 14:47:35 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id p17-20020a170902c71100b001947b539140sm9201161plp.23.2023.01.18.14.47.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:47:35 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iY6-Lq
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FF0-2B
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 31/42] xfs: get rid of notinit from xfs_bmap_longest_free_extent
Date:   Thu, 19 Jan 2023 09:44:54 +1100
Message-Id: <20230118224505.1964941-32-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It is only set if reading the AGF gets a EAGAIN error. Just return
the EAGAIN error and handle that error in the callers.

This means we can remove the not_init parameter from
xfs_bmap_select_minlen(), too, because the use of not_init there is
pessimistic. If we can't read the agf, it won't increase blen.

The only time we actually care whether we checked all the AGFs for
contiguous free space is when the best length is less than the
minimum allocation length. If not_init is set, then we ignore blen
and set the minimum alloc length to the absolute minimum, not the
best length we know already is present.

However, if blen is less than the minimum we're going to ignore it
anyway, regardless of whether we scanned all the AGFs or not.  Hence
not_init can go away, because we only use if blen is good from
the scanned AGs otherwise we ignore it altogether and use minlen.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 84 +++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7ae08b44e4d8..58790951be3e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3139,8 +3139,7 @@ static int
 xfs_bmap_longest_free_extent(
 	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
-	xfs_extlen_t		*blen,
-	int			*notinit)
+	xfs_extlen_t		*blen)
 {
 	xfs_extlen_t		longest;
 	int			error = 0;
@@ -3148,14 +3147,8 @@ xfs_bmap_longest_free_extent(
 	if (!xfs_perag_initialised_agf(pag)) {
 		error = xfs_alloc_read_agf(pag, tp, XFS_ALLOC_FLAG_TRYLOCK,
 				NULL);
-		if (error) {
-			/* Couldn't lock the AGF, so skip this AG. */
-			if (error == -EAGAIN) {
-				*notinit = 1;
-				error = 0;
-			}
+		if (error)
 			return error;
-		}
 	}
 
 	longest = xfs_alloc_longest_free_extent(pag,
@@ -3167,32 +3160,28 @@ xfs_bmap_longest_free_extent(
 	return 0;
 }
 
-static void
+static xfs_extlen_t
 xfs_bmap_select_minlen(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
-	xfs_extlen_t		*blen,
-	int			notinit)
+	xfs_extlen_t		blen)
 {
-	if (notinit || *blen < ap->minlen) {
-		/*
-		 * Since we did a BUF_TRYLOCK above, it is possible that
-		 * there is space for this request.
-		 */
-		args->minlen = ap->minlen;
-	} else if (*blen < args->maxlen) {
-		/*
-		 * If the best seen length is less than the request length,
-		 * use the best as the minimum.
-		 */
-		args->minlen = *blen;
-	} else {
-		/*
-		 * Otherwise we've seen an extent as big as maxlen, use that
-		 * as the minimum.
-		 */
-		args->minlen = args->maxlen;
-	}
+
+	/*
+	 * Since we used XFS_ALLOC_FLAG_TRYLOCK in _longest_free_extent(), it is
+	 * possible that there is enough contiguous free space for this request.
+	 */
+	if (blen < ap->minlen)
+		return ap->minlen;
+
+	/*
+	 * If the best seen length is less than the request length,
+	 * use the best as the minimum, otherwise we've got the maxlen we
+	 * were asked for.
+	 */
+	if (blen < args->maxlen)
+		return blen;
+	return args->maxlen;
 }
 
 static int
@@ -3204,7 +3193,6 @@ xfs_bmap_btalloc_select_lengths(
 	struct xfs_mount	*mp = args->mp;
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno, startag;
-	int			notinit = 0;
 	int			error = 0;
 
 	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
@@ -3220,9 +3208,8 @@ xfs_bmap_btalloc_select_lengths(
 
 	*blen = 0;
 	for_each_perag_wrap(mp, startag, agno, pag) {
-		error = xfs_bmap_longest_free_extent(pag, args->tp, blen,
-						     &notinit);
-		if (error)
+		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
+		if (error && error != -EAGAIN)
 			break;
 		if (*blen >= args->maxlen)
 			break;
@@ -3230,7 +3217,7 @@ xfs_bmap_btalloc_select_lengths(
 	if (pag)
 		xfs_perag_rele(pag);
 
-	xfs_bmap_select_minlen(ap, args, blen, notinit);
+	args->minlen = xfs_bmap_select_minlen(ap, args, *blen);
 	return 0;
 }
 
@@ -3243,7 +3230,6 @@ xfs_bmap_btalloc_filestreams_select_lengths(
 	struct xfs_mount	*mp = ap->ip->i_mount;
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		start_agno;
-	int			notinit = 0;
 	int			error;
 
 	args->total = ap->total;
@@ -3254,11 +3240,13 @@ xfs_bmap_btalloc_filestreams_select_lengths(
 
 	pag = xfs_perag_grab(mp, start_agno);
 	if (pag) {
-		error = xfs_bmap_longest_free_extent(pag, args->tp, blen,
-				&notinit);
+		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
 		xfs_perag_rele(pag);
-		if (error)
-			return error;
+		if (error) {
+			if (error != -EAGAIN)
+				return error;
+			*blen = 0;
+		}
 	}
 
 	if (*blen < args->maxlen) {
@@ -3274,18 +3262,18 @@ xfs_bmap_btalloc_filestreams_select_lengths(
 		if (!pag)
 			goto out_select;
 
-		error = xfs_bmap_longest_free_extent(pag, args->tp,
-				blen, &notinit);
+		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
 		xfs_perag_rele(pag);
-		if (error)
-			return error;
-
+		if (error) {
+			if (error != -EAGAIN)
+				return error;
+			*blen = 0;
+		}
 		start_agno = agno;
-
 	}
 
 out_select:
-	xfs_bmap_select_minlen(ap, args, blen, notinit);
+	args->minlen = xfs_bmap_select_minlen(ap, args, *blen);
 
 	/*
 	 * Set the failure fallback case to look in the selected AG as stream
-- 
2.39.0

