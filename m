Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB51AC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 08:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A91E64E4B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 08:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhBWI10 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 03:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhBWI1Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 03:27:25 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836B3C06174A
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 00:26:44 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gm18so1316597pjb.1
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 00:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=53J0EUfLnexkRl9ELQbsBdCdX5nFWPKJqkRFvvCsJ6U=;
        b=LobAP0YHiePSHSdP1ESIKvqzXCLybDUbdu3UKsUkeCKGoAa7g1w9uB6IqYjpmD0p60
         7YUgwkawjWkSexnc4pxLvLjDAE3DpYXvry6G1alfUTfov/Kb7EatxWdPjAnwJg1eSHl2
         m+5/qjp1uR695C46JDsEMkAvUXdiqHbKCYIwgvnBMrXFiTeZu7IXnTsd2QGrJ2mX+qJf
         UD+Fu2nw553i+JEX5h5ajhVSNa8SFp6GbCJUL/D5JQfnzKgTeUWJahz4MpzyKUGbv1pA
         S7aPbM1HnH2mVYgq88lnqwrKdDqZAzBzFT06WIvqVoezXMJr4og9USTj5I8yIoQMx1cK
         9fgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=53J0EUfLnexkRl9ELQbsBdCdX5nFWPKJqkRFvvCsJ6U=;
        b=TFQ114xeCj/g4OqBDI3KKr7aJq1MWgEC/lfeK+rLzb1uZ6cc3/MO92IbCHKPRiC/D+
         Teu0NSk7gHguXyeFQbGSDXq1XGKuUytD2hr7gkJeVoNUQxCMK2QlXSTSCn+hu6qRBM+d
         aht0PsvgU4XgipOYaZzW7/+Ar/dgbUJqKcjb9HJJgXXq8C12i3Ycf84VDG+ec2SrQcv/
         7WQGehsdBE5vjz5MJIJxEORiuilBg95nkJrUACFqUiz+Pw5U/IfP8zB63Jm58761iujk
         sao8fwrpPWtz8/VKs4i/tidAFGYSYK2BNDBc/+P5Kx4vIil2ho4uLufTT6YiFmBK70gc
         Ts4w==
X-Gm-Message-State: AOAM533GUHX8EgWAmeQ3/7pe42SbLWsbuWPgkMYllvtU4lMkgNa3/Tmm
        VJ+5MZ4//Xm+FD0gj4csHPkUn0kr5r4=
X-Google-Smtp-Source: ABdhPJzyo99kPS51wHNRHCC/rvWLEmar4O9bPrXyffKMlHpw0VL2Db6fzUyxB7r1r0tV+aCKaltnIg==
X-Received: by 2002:a17:90a:5789:: with SMTP id g9mr27970740pji.236.1614068803869;
        Tue, 23 Feb 2021 00:26:43 -0800 (PST)
Received: from localhost.localdomain ([122.171.216.250])
        by smtp.gmail.com with ESMTPSA id q7sm2217932pjr.13.2021.02.23.00.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 00:26:43 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>
Subject: [PATCH] xfs: Allow scrub to detect inodes with non-maximal sized extents
Date:   Tue, 23 Feb 2021 13:56:29 +0530
Message-Id: <20210223082629.16719-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit now makes it possible for scrub to check if an inode's extents are
maximally sized i.e. it checks if an inode's extent is contiguous (in terms of
both file offset and disk offset) with neighbouring extents and the total
length of both the extents is less than the maximum allowed extent
length (i.e. MAXEXTLEN).

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/scrub/inode.c   | 11 +++++++----
 fs/xfs/xfs_bmap_util.c | 36 +++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_bmap_util.h |  5 +++--
 fs/xfs/xfs_qm.c        |  2 +-
 4 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index faf65eb5bd31..33b530785e36 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -478,23 +478,26 @@ xchk_inode_xref_bmap(
 	xfs_filblks_t		count;
 	xfs_filblks_t		acount;
 	int			error;
+	bool			maximal_sized_exts;
 
 	if (xchk_skip_xref(sc->sm))
 		return;
 
 	/* Walk all the extents to check nextents/naextents/nblocks. */
+	maximal_sized_exts = true;
 	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
-			&nextents, &count);
+			&nextents, &count, &maximal_sized_exts);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents < be32_to_cpu(dip->di_nextents))
+	if (nextents < be32_to_cpu(dip->di_nextents) || !maximal_sized_exts)
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
+	maximal_sized_exts = true;
 	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
-			&nextents, &acount);
+			&nextents, &acount, &maximal_sized_exts);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents != be16_to_cpu(dip->di_anextents))
+	if (nextents != be16_to_cpu(dip->di_anextents) || !maximal_sized_exts)
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	/* Check nblocks against the inode. */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index e7d68318e6a5..eca39677a46f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -176,6 +176,25 @@ xfs_bmap_rtalloc(
  * Extent tree block counting routines.
  */
 
+STATIC bool
+is_maximal_extent(
+	struct xfs_ifork	*ifp,
+	struct xfs_iext_cursor	*icur,
+	struct xfs_bmbt_irec	*got)
+{
+	struct xfs_bmbt_irec	left;
+
+	if (xfs_iext_peek_prev_extent(ifp, icur, &left) &&
+		!isnullstartblock(left.br_startblock) &&
+		left.br_startoff + left.br_blockcount == got->br_startoff &&
+		left.br_startblock + left.br_blockcount == got->br_startblock &&
+		left.br_state == got->br_state &&
+		left.br_blockcount + got->br_blockcount <= MAXEXTLEN)
+		return false;
+	else
+		return true;
+}
+
 /*
  * Count leaf blocks given a range of extent records.  Delayed allocation
  * extents are not counted towards the totals.
@@ -183,7 +202,8 @@ xfs_bmap_rtalloc(
 xfs_extnum_t
 xfs_bmap_count_leaves(
 	struct xfs_ifork	*ifp,
-	xfs_filblks_t		*count)
+	xfs_filblks_t		*count,
+	bool			*maximal_sized_exts)
 {
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_irec	got;
@@ -191,6 +211,10 @@ xfs_bmap_count_leaves(
 
 	for_each_xfs_iext(ifp, &icur, &got) {
 		if (!isnullstartblock(got.br_startblock)) {
+			if (maximal_sized_exts)
+				*maximal_sized_exts =
+					is_maximal_extent(ifp, &icur, &got);
+
 			*count += got.br_blockcount;
 			numrecs++;
 		}
@@ -209,7 +233,8 @@ xfs_bmap_count_blocks(
 	struct xfs_inode	*ip,
 	int			whichfork,
 	xfs_extnum_t		*nextents,
-	xfs_filblks_t		*count)
+	xfs_filblks_t		*count,
+	bool			*maximal_sized_exts)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
@@ -246,7 +271,8 @@ xfs_bmap_count_blocks(
 
 		/* fall through */
 	case XFS_DINODE_FMT_EXTENTS:
-		*nextents = xfs_bmap_count_leaves(ifp, count);
+		*nextents = xfs_bmap_count_leaves(ifp, count,
+				maximal_sized_exts);
 		break;
 	}
 
@@ -1442,14 +1468,14 @@ xfs_swap_extent_forks(
 	if (XFS_IFORK_Q(ip) && ip->i_afp->if_nextents > 0 &&
 	    ip->i_afp->if_format != XFS_DINODE_FMT_LOCAL) {
 		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK, &junk,
-				&aforkblks);
+				&aforkblks, NULL);
 		if (error)
 			return error;
 	}
 	if (XFS_IFORK_Q(tip) && tip->i_afp->if_nextents > 0 &&
 	    tip->i_afp->if_format != XFS_DINODE_FMT_LOCAL) {
 		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK, &junk,
-				&taforkblks);
+				&taforkblks, NULL);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 9f993168b55b..7b0ce227c7bd 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -71,10 +71,11 @@ int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
 
 xfs_daddr_t xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb);
 
-xfs_extnum_t xfs_bmap_count_leaves(struct xfs_ifork *ifp, xfs_filblks_t *count);
+xfs_extnum_t xfs_bmap_count_leaves(struct xfs_ifork *ifp, xfs_filblks_t *count,
+		bool *maximal_sized_exts);
 int xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 			  int whichfork, xfs_extnum_t *nextents,
-			  xfs_filblks_t *count);
+			  xfs_filblks_t *count, bool *maximal_sized_exts);
 
 int	xfs_flush_unmap_range(struct xfs_inode *ip, xfs_off_t offset,
 			      xfs_off_t len);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 742d1413e2d0..04fcca5583b3 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1170,7 +1170,7 @@ xfs_qm_dqusage_adjust(
 				goto error0;
 		}
 
-		xfs_bmap_count_leaves(ifp, &rtblks);
+		xfs_bmap_count_leaves(ifp, &rtblks, NULL);
 	}
 
 	nblks = (xfs_qcnt_t)ip->i_d.di_nblocks - rtblks;
-- 
2.29.2

