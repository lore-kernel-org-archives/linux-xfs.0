Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C9F0C05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjBIWSj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjBIWSg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:36 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FAE69527
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:32 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m2-20020a17090a414200b00231173c006fso7021317pjg.5
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=188CjcqOV0/JugY2Zh1YbPSsSzKubuvTz556CTdFQQo=;
        b=IfK8poRiwsCUoXFSidGZoUtcETr+6aXqM3QOFIJ1ai/kPRm1kDlZyuVYKQrXTS+XQe
         6cDUPJ1+kOgvCHtobAiXCko2Q5c5D+L1Gw9HGORdrryLWE+Mf+3EzDdWF6zEWbJYkUZw
         KvAMJU9K2DbVmJTm4Pt2Mlf7SQTR0hQJhSPxxz56ECNA8xjOWemzF1P2ITu32xYyX2fh
         Ch4XdRn5szYEfGoPvVCEjXIqvVeel2pWVZ0WoFUcn/EhPlrmCCQHMm1d5OhJ6nh1XmHS
         mBHPlAl9l7an1UlPMQiUSQtu5ACzu8ZIhF+qnoqBeAscfH+sd2cmHp2ySmx1Ca3ZPlCK
         W1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=188CjcqOV0/JugY2Zh1YbPSsSzKubuvTz556CTdFQQo=;
        b=ODAiZmuc/QNp/tECpcnG2SX0IDdR/IJc6t3ILTkCzCKXS03nD/OJgq/t0wbNmsQDZK
         e14rn4W2Krs4eQfcwdoKFNLFZfsZFqQHzR28WcdagnoRn2Vj6ZLLKCYY0u1SMQnxuYBj
         8WRqbDfW0oOla8nDaE6eSPBHrGG33GvjSZ9dHKw0q+S4jl1O0P7a+xkh3aY1v7zb3QcN
         4x0S93+BZ1HkDAOZZ4DKLW9OwYUbaRdgrdVydoYug03HJA7oDMkSdUQrTu5lWV5TUbv7
         WcNasQ/8fkvtusz7D4Zl46wPIbKsMC9iFcHh0LQ9tYPmQy3RWNzB9UQ3GBg6iOFZpT+S
         YDxw==
X-Gm-Message-State: AO0yUKX5s+cksqqPwxRM9S8hLNs+n10b1Zea6gqIfMCw7oq3MsBFW/9d
        o2NBnPSJC/BJNyQIkg5AUdZuwIN+K+dm7k/x
X-Google-Smtp-Source: AK7set9aN/65xKLLstDaKwGMTV/Oppi6s9TjuVfbvaEB/QrIVfB1jnMAlJy2qvbP7cormWEfjIwEOg==
X-Received: by 2002:a17:902:e751:b0:198:e8f3:6a48 with SMTP id p17-20020a170902e75100b00198e8f36a48mr16013624plf.9.1675981112001;
        Thu, 09 Feb 2023 14:18:32 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id s18-20020a170902a51200b00199136ded1dsm2010292plq.112.2023.02.09.14.18.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:30 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOW1-LE
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcOF-26
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 29/42] xfs: convert trim to use for_each_perag_range
Date:   Fri, 10 Feb 2023 09:18:12 +1100
Message-Id: <20230209221825.3722244-30-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To convert it to using active perag references and hence make it
shrink safe.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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
+		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1;
 
-	start_agno = xfs_daddr_to_agno(mp, start);
-	end_agno = xfs_daddr_to_agno(mp, end);
-
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

