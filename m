Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 634AAC05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjBIW0M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjBIW0K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:26:10 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112EE6812D
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:26:04 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id k13so4610179plg.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0RgNUJD9b/c5HsdTRopvri8PBmMjo6D2uruYVN97RYk=;
        b=zIs5tiU2ZLik/leWtQKWFbaAuVXCz1hEf0+ezlcJ2zH/vGW8fFkXlvw4/A2OA5yLVJ
         sUBdp+YVhzTR20ilVJz00TYMbH3x7oodEkXwRgWJsAZqyKHnCjF919vut49CWkut0Vf/
         SPc+N+280PTVU+vQ3nO4RjoTQfBKHDn5q55fL3bizR2sDuFByPuQ4bkfc0JmX0ibrEl5
         riHGgmRKUXeQfnZj/7Sbt6qsjTY8VFMW3sgdaRIEHGGNH1scZBokMkEnHg2oXu1PDyhT
         OsZesSmxFo5aUe07RAXjrLCqk/ZJ5xSwbN7RdByT/R99N1hWsBXRMe/7+QNpGPAEoGTl
         8CzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0RgNUJD9b/c5HsdTRopvri8PBmMjo6D2uruYVN97RYk=;
        b=ilMA0TKINVA3xbcwRPNbzfop6mheY9JORfB4bOklKezo60I/E8dupvI9AcX3WCWwo1
         GgLFTm8udw6Y6lZdyKRRNHke2jjvqsK6itLSJNUitpS9xhrAMdJylu7SjxNeKl3biqI7
         AL5GXLmhrKfVFogPx0O9A0T5qjFIfZqPpzRkp1D759NasGHAuTH6m0EkKC6xyt7iqTyo
         r+R5c+3b2FQBogDGC0N65foHBMJNEUTIPzRjn0XbnWNR4uee6ghOMepVh7tyY7vc+Fid
         P4Zm846R1QJBRVcOTQhs9pxMkwfgCAM8JFzBx8tUKqbuwp93fFKdK6ATVKPMENM5ZOd3
         i2KQ==
X-Gm-Message-State: AO0yUKUE88FHlQx8YKgRJLVjeofu4XhVMLkBU+lHOVLzczfAqg/59mut
        iFSa5xT/kNY3Pbz/wyJD2FVmz7VHuM1OjOad
X-Google-Smtp-Source: AK7set9Bpty/L+U/Omc0rJ08ZZW3Z6dVfetpq6qfRnKYH3DQcVyvD3cnjHIQz3JtCpY1XPq9j09ilg==
X-Received: by 2002:a17:903:291:b0:19a:5f59:f100 with SMTP id j17-20020a170903029100b0019a5f59f100mr2573450plr.9.1675981563411;
        Thu, 09 Feb 2023 14:26:03 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id j12-20020a170902c3cc00b001992e74d058sm2029651plj.7.2023.02.09.14.26.02
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:26:03 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOWD-Oz
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcOZ-2S
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 33/42] xfs: move xfs_bmap_btalloc_filestreams() to xfs_filestreams.c
Date:   Fri, 10 Feb 2023 09:18:16 +1100
Message-Id: <20230209221825.3722244-34-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_bmap_btalloc_filestreams() calls two filestreams functions to
select the AG to allocate from. Both those functions end up in
the same selection function that iterates all AGs multiple times.
Worst case, xfs_bmap_btalloc_filestreams() can iterate all AGs 4
times just to select the initial AG to allocate in.

Move the AG selection to fs/xfs/xfs_filestreams.c as a single
interface so that the inefficient AG interation is contained
entirely within the filestreams code. This will allow the
implementation to be simplified and made more efficient in future
patches.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |  94 +++++-------------------------------
 fs/xfs/libxfs/xfs_bmap.h |   3 ++
 fs/xfs/xfs_filestream.c  | 100 ++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_filestream.h  |   5 +-
 4 files changed, 115 insertions(+), 87 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 16628fdbcd55..11facb8a6b3a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3222,68 +3222,6 @@ xfs_bmap_btalloc_select_lengths(
 	return error;
 }
 
-static int
-xfs_bmap_btalloc_filestreams_select_lengths(
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
-	args->minlen = xfs_bmap_select_minlen(ap, args, *blen);
-
-	/*
-	 * Set the failure fallback case to look in the selected AG as stream
-	 * may have moved.
-	 */
-	ap->blkno = args->fsbno = XFS_AGB_TO_FSB(mp, start_agno, 0);
-	return 0;
-}
-
 /* Update all inode and quota accounting for the allocation we just did. */
 static void
 xfs_bmap_btalloc_accounting(
@@ -3577,7 +3515,7 @@ xfs_bmap_btalloc_at_eof(
  * transaction that we are critically low on space so they don't waste time on
  * allocation modes that are unlikely to succeed.
  */
-static int
+int
 xfs_bmap_btalloc_low_space(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args)
@@ -3606,36 +3544,25 @@ xfs_bmap_btalloc_filestreams(
 	struct xfs_alloc_arg	*args,
 	int			stripe_align)
 {
-	xfs_agnumber_t		agno = xfs_filestream_lookup_ag(ap->ip);
 	xfs_extlen_t		blen = 0;
 	int			error;
 
-	/* Determine the initial block number we will target for allocation. */
-	if (agno == NULLAGNUMBER)
-		agno = 0;
-	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
-	xfs_bmap_adjacent(ap);
+
+	error = xfs_filestream_select_ag(ap, args, &blen);
+	if (error)
+		return error;
 
 	/*
-	 * If there is very little free space before we start a
-	 * filestreams allocation, we're almost guaranteed to fail to
-	 * find an AG with enough contiguous free space to succeed, so
-	 * just go straight to the low space algorithm.
+	 * If we are in low space mode, then optimal allocation will fail so
+	 * prepare for minimal allocation and jump to the low space algorithm
+	 * immediately.
 	 */
 	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
 		args->minlen = ap->minlen;
-		return xfs_bmap_btalloc_low_space(ap, args);
+		goto out_low_space;
 	}
 
-	/*
-	 * Search for an allocation group with a single extent large enough for
-	 * the request.  If one isn't found, then adjust the minimum allocation
-	 * size to the largest space found.
-	 */
-	error = xfs_bmap_btalloc_filestreams_select_lengths(ap, args, &blen);
-	if (error)
-		return error;
-
+	args->minlen = xfs_bmap_select_minlen(ap, args, blen);
 	if (ap->aeof) {
 		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align,
 				true);
@@ -3647,6 +3574,7 @@ xfs_bmap_btalloc_filestreams(
 	if (error || args->fsbno != NULLFSBLOCK)
 		return error;
 
+out_low_space:
 	return xfs_bmap_btalloc_low_space(ap, args);
 }
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index b52cfdcb9320..dd08361ca5a6 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -12,6 +12,7 @@ struct xfs_ifork;
 struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
+struct xfs_alloc_arg;
 
 /*
  * Argument structure for xfs_bmap_alloc.
@@ -224,6 +225,8 @@ int	xfs_bmap_add_extent_unwritten_real(struct xfs_trans *tp,
 		struct xfs_bmbt_irec *new, int *logflagsp);
 xfs_extlen_t xfs_bmapi_minleft(struct xfs_trans *tp, struct xfs_inode *ip,
 		int fork);
+int	xfs_bmap_btalloc_low_space(struct xfs_bmalloca *ap,
+		struct xfs_alloc_arg *args);
 
 enum xfs_bmap_intent_type {
 	XFS_BMAP_MAP = 1,
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 2eb702034d05..a641404aa9a6 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -12,6 +12,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_alloc.h"
 #include "xfs_mru_cache.h"
 #include "xfs_trace.h"
@@ -263,7 +264,7 @@ xfs_filestream_get_parent(
  *
  * Returns NULLAGNUMBER in case of an error.
  */
-xfs_agnumber_t
+static xfs_agnumber_t
 xfs_filestream_lookup_ag(
 	struct xfs_inode	*ip)
 {
@@ -312,7 +313,7 @@ xfs_filestream_lookup_ag(
  * This is called when the allocator can't find a suitable extent in the
  * current AG, and we have to move the stream into a new AG with more space.
  */
-int
+static int
 xfs_filestream_new_ag(
 	struct xfs_bmalloca	*ap,
 	xfs_agnumber_t		*agp)
@@ -358,6 +359,101 @@ xfs_filestream_new_ag(
 	return err;
 }
 
+static int
+xfs_filestreams_select_lengths(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_extlen_t		*blen)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		start_agno;
+	int			error;
+
+	args->total = ap->total;
+
+	start_agno = XFS_FSB_TO_AGNO(mp, ap->blkno);
+	if (start_agno == NULLAGNUMBER)
+		start_agno = 0;
+
+	pag = xfs_perag_grab(mp, start_agno);
+	if (pag) {
+		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
+		xfs_perag_rele(pag);
+		if (error) {
+			if (error != -EAGAIN)
+				return error;
+			*blen = 0;
+		}
+	}
+
+	if (*blen < args->maxlen) {
+		xfs_agnumber_t	agno = start_agno;
+
+		error = xfs_filestream_new_ag(ap, &agno);
+		if (error)
+			return error;
+		if (agno == NULLAGNUMBER)
+			goto out_select;
+
+		pag = xfs_perag_grab(mp, agno);
+		if (!pag)
+			goto out_select;
+
+		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
+		xfs_perag_rele(pag);
+		if (error) {
+			if (error != -EAGAIN)
+				return error;
+			*blen = 0;
+		}
+		start_agno = agno;
+	}
+
+out_select:
+	/*
+	 * Set the failure fallback case to look in the selected AG as stream
+	 * may have moved.
+	 */
+	ap->blkno = args->fsbno = XFS_AGB_TO_FSB(mp, start_agno, 0);
+	return 0;
+}
+
+/*
+ * Search for an allocation group with a single extent large enough for
+ * the request.  If one isn't found, then the largest available free extent is
+ * returned as the best length possible.
+ */
+int
+xfs_filestream_select_ag(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_extlen_t		*blen)
+{
+	xfs_agnumber_t		start_agno = xfs_filestream_lookup_ag(ap->ip);
+
+	/* Determine the initial block number we will target for allocation. */
+	if (start_agno == NULLAGNUMBER)
+		start_agno = 0;
+	ap->blkno = XFS_AGB_TO_FSB(args->mp, start_agno, 0);
+	xfs_bmap_adjacent(ap);
+
+	/*
+	 * If there is very little free space before we start a filestreams
+	 * allocation, we're almost guaranteed to fail to find a better AG with
+	 * larger free space available so we don't even try.
+	 */
+	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
+		return 0;
+
+	/*
+	 * Search for an allocation group with a single extent large enough for
+	 * the request.  If one isn't found, then adjust the minimum allocation
+	 * size to the largest space found.
+	 */
+	return xfs_filestreams_select_lengths(ap, args, blen);
+}
+
 void
 xfs_filestream_deassociate(
 	struct xfs_inode	*ip)
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index 403226ebb80b..df9f7553e106 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -9,13 +9,14 @@
 struct xfs_mount;
 struct xfs_inode;
 struct xfs_bmalloca;
+struct xfs_alloc_arg;
 
 int xfs_filestream_mount(struct xfs_mount *mp);
 void xfs_filestream_unmount(struct xfs_mount *mp);
 void xfs_filestream_deassociate(struct xfs_inode *ip);
-xfs_agnumber_t xfs_filestream_lookup_ag(struct xfs_inode *ip);
-int xfs_filestream_new_ag(struct xfs_bmalloca *ap, xfs_agnumber_t *agp);
 int xfs_filestream_peek_ag(struct xfs_mount *mp, xfs_agnumber_t agno);
+int xfs_filestream_select_ag(struct xfs_bmalloca *ap,
+		struct xfs_alloc_arg *args, xfs_extlen_t *blen);
 
 static inline int
 xfs_inode_is_filestream(
-- 
2.39.0

