Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 235AAC38159
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjARWsZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjARWsK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:48:10 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05DE5356D
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:48:09 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 200so114144pfx.7
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DaIQWtHzJTO5NL5ekzY8BPUXBPXgLjETt+hTeq+rKVs=;
        b=F0Cp4u6AFUP0qR3FhVmoJfShnGi+WeEZZxaGF9jO491rl6+vAjHs5juAzm9ulgzi5j
         wQPryMEkJQN8QMqfTAFJWLkGA3fRJ1+w+XN5ZDpI46tBmtBZA2z302sXdjWPyWyAwZmL
         lxaSqL7mhCQHsT3GXmoa1G1dAKcIDW0qcRVr1us9sB/OUvW2ztVxSHjGMVIduJjipsOX
         /deE38aqjnVQN+i+zr7ZyytGoog3sO25qEXS6fqP4DWWPwnrR/5HnmE67AcT5Gdu0IEn
         Is75CskctA1Ztsek+v1ftxb9g/23prVV0AHo61NM8o8KapdintsiEYb7hpliyklHen4B
         LZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DaIQWtHzJTO5NL5ekzY8BPUXBPXgLjETt+hTeq+rKVs=;
        b=eD3YyZrJWuJqXZ5S1+yuLEyBQ3G5xxuUJ+bgqGE6KJkMKRueUVUpK5yDi5ouvLPhTb
         ZqYSob7uufd7PCcgJm1A52Y8vXQWh8tOmpLBHDnvLV8ogBruOC43/Aj2JLezcjuERlTf
         A/i64T5k2vskke9g8K8ROmAMpCo2aJluJQwczXjyuVDVgZqQ4owY14CJlctxzEfvKApT
         0A7UsryAQke4l83nWpj2G+D42Gk4vYo5WNRwOIjv34t6XyP+CAiEwWrOMB/6bd7awitA
         la7J2jQ0705RDaK8e1/a7L2WkygGOfsA5NPq5tqUchpQQyVVcalXKiJUtCCQHz/m3NVD
         eTLg==
X-Gm-Message-State: AFqh2kqZHk+ZlzsbnaU2k16lxGeVmq0YZWltT++wV6vlso/1iLQqjdr7
        k01PHBsW6vdn8rtWm4jRtJ1rfLEdRd6nQhcu
X-Google-Smtp-Source: AMrXdXu3FcDo+Kbqe+7vsaCKl/aPnRwZo3sxuoa0BJMbcMy1tVx34OdxMvvL57diMHRMBAHLnk9Fug==
X-Received: by 2002:aa7:880b:0:b0:58d:abd5:504a with SMTP id c11-20020aa7880b000000b0058dabd5504amr8344434pfo.31.1674082089190;
        Wed, 18 Jan 2023 14:48:09 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id a1-20020aa795a1000000b0058119caa82csm10009310pfk.205.2023.01.18.14.48.08
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:48:08 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iYC-Nf
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FFA-2M
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 33/42] xfs: move xfs_bmap_btalloc_filestreams() to xfs_filestreams.c
Date:   Thu, 19 Jan 2023 09:44:56 +1100
Message-Id: <20230118224505.1964941-34-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
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
---
 fs/xfs/libxfs/xfs_bmap.c |  94 +++++-------------------------------
 fs/xfs/libxfs/xfs_bmap.h |   3 ++
 fs/xfs/xfs_filestream.c  | 100 ++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_filestream.h  |   5 +-
 4 files changed, 115 insertions(+), 87 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c6a617dada27..098b46f3f3e3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3221,68 +3221,6 @@ xfs_bmap_btalloc_select_lengths(
 	return 0;
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
@@ -3576,7 +3514,7 @@ xfs_bmap_btalloc_at_eof(
  * transaction that we are critically low on space so they don't waste time on
  * allocation modes that are unlikely to succeed.
  */
-static int
+int
 xfs_bmap_btalloc_low_space(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args)
@@ -3605,36 +3543,25 @@ xfs_bmap_btalloc_filestreams(
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
@@ -3646,6 +3573,7 @@ xfs_bmap_btalloc_filestreams(
 	if (error || args->fsbno != NULLFSBLOCK)
 		return error;
 
+out_low_space:
 	return xfs_bmap_btalloc_low_space(ap, args);
 }
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 7bd619eb2f7d..94d9285eeba1 100644
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

