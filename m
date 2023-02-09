Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0ABCC05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjBIW0W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjBIW0O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:26:14 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C281F6ADFF
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:26:06 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso7266989pju.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IGIP+vWaiAWlP6fAcVUIEfCZ13eq3PI7213N3rtq5hg=;
        b=JShyh5Uxb7PAFgMAHP//S0GxcYvrNCQibuMnPCjA/EHgpQDRd6WzPGDpXYGRRj4QAQ
         2dL923TAj0I7v/+X8jeyhay1dydU+Wsbg+2pUL7amcYxSijSVZcXjh6H70+kZOaPVIfO
         3LwjR1MLtsWh2g092//AraRHZ1IaMYMu2Xk6ZV640TUGNJ/YRhyiYR62xOIyXKrOXbZk
         dYSeXk+bgS8w/I7kXLk6mqWKqJJSj8UyGi+8PN2oDcT2T5azACTCV6hh7dlu4exTguJK
         IJIf1f2WVwrrlCY72kYCAFIB8xodJneputyisTrcQPtHX+uQN97HPwazv+uJYnvq186b
         KYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IGIP+vWaiAWlP6fAcVUIEfCZ13eq3PI7213N3rtq5hg=;
        b=bdQtEnUJEOPKR24kfzqvo3QMioCImIhmxbTUrRSN5bZ+Gevq1TJ0TRJQE8gxliUnW+
         X7yMkLueRD+YAUBhJRrD/aT6ElEsTUGBv0qc/3x1UebP2Nw6QfUIMe4RBq/w/VLRgDXc
         auroWT25Tzff3T9kSEPNl1wyBZyGh1PkVD59WqhHGUwYgdqNBA7RB/id7AeelWLlGhkf
         A4Ae+fVl9Kq7fhleUc7nyYpn3P8q9POQZ/3Mf6+ndgAFQmhXA2OwO2JPRpri8EcVBThp
         4xIHUTUoG5n2EYqOff2ccU/BlwA7HgZjnO+cvlhlD1h4IlPJlgWiYl4MGSUqwBZaFzmW
         DEXA==
X-Gm-Message-State: AO0yUKV+x7JQo3wps/iodrWSI5nVaUI+8RMRPOWWgYR3b6w5q2SBoNn8
        rjpkvYkJlgcLHyNA99i2nv5tVGkU27PG/uB0
X-Google-Smtp-Source: AK7set81X8yKHTL5PEy7e8DbYkGOlkDLkwHK0usplOgzWf5c/uh6HJqzSRs54QDpSNUfVkuRxuymMA==
X-Received: by 2002:a05:6a20:54a9:b0:bc:e2f6:8788 with SMTP id i41-20020a056a2054a900b000bce2f68788mr16163248pzk.24.1675981566271;
        Thu, 09 Feb 2023 14:26:06 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id c3-20020aa78803000000b005a8577f193esm1936337pfo.68.2023.02.09.14.26.05
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:26:05 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOW8-N7
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcOP-2H
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 31/42] xfs: get rid of notinit from xfs_bmap_longest_free_extent
Date:   Fri, 10 Feb 2023 09:18:14 +1100
Message-Id: <20230209221825.3722244-32-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 85 +++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 187200488ac0..89398172d8be 100644
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
@@ -3220,17 +3208,17 @@ xfs_bmap_btalloc_select_lengths(
 
 	*blen = 0;
 	for_each_perag_wrap(mp, startag, agno, pag) {
-		error = xfs_bmap_longest_free_extent(pag, args->tp, blen,
-						     &notinit);
-		if (error)
+		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
+		if (error && error != -EAGAIN)
 			break;
+		error = 0;
 		if (*blen >= args->maxlen)
 			break;
 	}
 	if (pag)
 		xfs_perag_rele(pag);
 
-	xfs_bmap_select_minlen(ap, args, blen, notinit);
+	args->minlen = xfs_bmap_select_minlen(ap, args, *blen);
 	return error;
 }
 
@@ -3243,7 +3231,6 @@ xfs_bmap_btalloc_filestreams_select_lengths(
 	struct xfs_mount	*mp = ap->ip->i_mount;
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		start_agno;
-	int			notinit = 0;
 	int			error;
 
 	args->total = ap->total;
@@ -3254,11 +3241,13 @@ xfs_bmap_btalloc_filestreams_select_lengths(
 
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
@@ -3274,18 +3263,18 @@ xfs_bmap_btalloc_filestreams_select_lengths(
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

