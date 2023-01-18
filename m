Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF531C46467
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjARWsO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjARWr5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:47:57 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1844A1DD
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:47:42 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 127so125694pfe.4
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V4wObburgrZWXG01Q0SWeB3FM1sC8fnj6ToorhiMEJU=;
        b=KLd84KfL5/2j377EHOMHF4SPCmsIh/zaU+wHF0ae1gncvpewu9nhOu9QEKpOe05PAe
         GBIqD2f1mx+mQG3V63Q4SsS7TXlOMCOHoTflUb6tH4LlHeYgpRl+yA9IqitDX3WfOQLb
         0UH9ODt3nsa9s0xRcb105d+0+pPpFIBM3iKckTvYtCEJuS/IOr/ajNz1Q2mRB5inkE4j
         t/TUa+CkgtZBWxVRSd+i4nk1xu46gWjOcStbyyFbdvIDLTDaaf9QIK90ar4pEdtJ+vbi
         6BWNReJXrkxCVkiQOvzK+vW+CaOzYgmdEuIKqhLjUIn/WNKvNyvTTPBlCg4xjd6WgkR8
         GfCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V4wObburgrZWXG01Q0SWeB3FM1sC8fnj6ToorhiMEJU=;
        b=gnlN067KDSI0fXmh3YToV3QrBCAelihQHy6HDhvLjuMSZ4WhC3eiFZycwC6dwDalNG
         ynCnnLJQZWDz9XVQp1XCeeTjExnQ6g93EQM2g5zmX18roUd+EiKY5BdcoTCM1bz3hmPa
         3R0ghFPT4yYj4FldivitOd1UdF5p0cbjh7CZaoC85C3oRSaYlsgyhhroEzijz3TAuD6b
         ulgCfj8Dkk/MyEraJpq3VxcyZY+00iFt2vsgjvxzCiLN9HSGLd02mCloCcN34Lb70Awn
         VC/OUpt99MpfZ+jbhfDiGwxpxa753TglPLMBa+zQGoSXPOYcCLoy4rTHuJErBbfyaboH
         iS5A==
X-Gm-Message-State: AFqh2krMv05MdHP/qMvDbdASGLPYkUTvfQ3eojJqz+UTkMRWvznrmpxW
        5bJakVkgXzJTb37kXr1BMyPAtQLXKcDFTsSH
X-Google-Smtp-Source: AMrXdXt1zkX1xFapJ3zeFz6aPhbDXwtFC7QWbQeRHjjkVkCVenUUNkzN3QKjVWm80MqYyc0FiNXPgg==
X-Received: by 2002:a05:6a00:3390:b0:58c:6ba1:58dd with SMTP id cm16-20020a056a00339000b0058c6ba158ddmr9422895pfb.11.1674082062104;
        Wed, 18 Jan 2023 14:47:42 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id w4-20020aa79544000000b0058db5d4b391sm5647733pfq.19.2023.01.18.14.47.41
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:47:41 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iXz-Jx
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FEq-20
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 29/42] xfs: convert trim to use for_each_perag_range
Date:   Thu, 19 Jan 2023 09:44:52 +1100
Message-Id: <20230118224505.1964941-30-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To convert it to using active perag references and hence make it
shrink safe.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_discard.c | 50 ++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index bfc829c07f03..afc4c78b9eed 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -21,23 +21,20 @@
 
 STATIC int
 xfs_trim_extents(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_daddr_t		start,
 	xfs_daddr_t		end,
 	xfs_daddr_t		minlen,
 	uint64_t		*blocks_trimmed)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
 	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
 	struct xfs_btree_cur	*cur;
 	struct xfs_buf		*agbp;
 	struct xfs_agf		*agf;
-	struct xfs_perag	*pag;
 	int			error;
 	int			i;
 
-	pag = xfs_perag_get(mp, agno);
-
 	/*
 	 * Force out the log.  This means any transactions that might have freed
 	 * space before we take the AGF buffer lock are now on disk, and the
@@ -47,7 +44,7 @@ xfs_trim_extents(
 
 	error = xfs_alloc_read_agf(pag, NULL, 0, &agbp);
 	if (error)
-		goto out_put_perag;
+		return error;
 	agf = agbp->b_addr;
 
 	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_CNT);
@@ -71,10 +68,10 @@ xfs_trim_extents(
 
 		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
 		if (error)
-			goto out_del_cursor;
+			break;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
 			error = -EFSCORRUPTED;
-			goto out_del_cursor;
+			break;
 		}
 		ASSERT(flen <= be32_to_cpu(agf->agf_longest));
 
@@ -83,15 +80,15 @@ xfs_trim_extents(
 		 * the format the range/len variables are supplied in by
 		 * userspace.
 		 */
-		dbno = XFS_AGB_TO_DADDR(mp, agno, fbno);
+		dbno = XFS_AGB_TO_DADDR(mp, pag->pag_agno, fbno);
 		dlen = XFS_FSB_TO_BB(mp, flen);
 
 		/*
 		 * Too small?  Give up.
 		 */
 		if (dlen < minlen) {
-			trace_xfs_discard_toosmall(mp, agno, fbno, flen);
-			goto out_del_cursor;
+			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
+			break;
 		}
 
 		/*
@@ -100,7 +97,7 @@ xfs_trim_extents(
 		 * down partially overlapping ranges for now.
 		 */
 		if (dbno + dlen < start || dbno > end) {
-			trace_xfs_discard_exclude(mp, agno, fbno, flen);
+			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
 			goto next_extent;
 		}
 
@@ -109,32 +106,30 @@ xfs_trim_extents(
 		 * discard and try again the next time.
 		 */
 		if (xfs_extent_busy_search(mp, pag, fbno, flen)) {
-			trace_xfs_discard_busy(mp, agno, fbno, flen);
+			trace_xfs_discard_busy(mp, pag->pag_agno, fbno, flen);
 			goto next_extent;
 		}
 
-		trace_xfs_discard_extent(mp, agno, fbno, flen);
+		trace_xfs_discard_extent(mp, pag->pag_agno, fbno, flen);
 		error = blkdev_issue_discard(bdev, dbno, dlen, GFP_NOFS);
 		if (error)
-			goto out_del_cursor;
+			break;
 		*blocks_trimmed += flen;
 
 next_extent:
 		error = xfs_btree_decrement(cur, 0, &i);
 		if (error)
-			goto out_del_cursor;
+			break;
 
 		if (fatal_signal_pending(current)) {
 			error = -ERESTARTSYS;
-			goto out_del_cursor;
+			break;
 		}
 	}
 
 out_del_cursor:
 	xfs_btree_del_cursor(cur, error);
 	xfs_buf_relse(agbp);
-out_put_perag:
-	xfs_perag_put(pag);
 	return error;
 }
 
@@ -152,11 +147,12 @@ xfs_ioc_trim(
 	struct xfs_mount		*mp,
 	struct fstrim_range __user	*urange)
 {
+	struct xfs_perag	*pag;
 	unsigned int		granularity =
 		bdev_discard_granularity(mp->m_ddev_targp->bt_bdev);
 	struct fstrim_range	range;
 	xfs_daddr_t		start, end, minlen;
-	xfs_agnumber_t		start_agno, end_agno, agno;
+	xfs_agnumber_t		agno;
 	uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
 
@@ -193,18 +189,18 @@ xfs_ioc_trim(
 	end = start + BTOBBT(range.len) - 1;
 
 	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
-		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)- 1;
-
-	start_agno = xfs_daddr_to_agno(mp, start);
-	end_agno = xfs_daddr_to_agno(mp, end);
+		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1;
 
-	for (agno = start_agno; agno <= end_agno; agno++) {
-		error = xfs_trim_extents(mp, agno, start, end, minlen,
+	agno = xfs_daddr_to_agno(mp, start);
+	for_each_perag_range(mp, agno, xfs_daddr_to_agno(mp, end), pag) {
+		error = xfs_trim_extents(pag, start, end, minlen,
 					  &blocks_trimmed);
 		if (error) {
 			last_error = error;
-			if (error == -ERESTARTSYS)
+			if (error == -ERESTARTSYS) {
+				xfs_perag_rele(pag);
 				break;
+			}
 		}
 	}
 
-- 
2.39.0

