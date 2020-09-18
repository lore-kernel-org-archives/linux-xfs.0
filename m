Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC74C43463
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13F4321D43
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QL9n+QAV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgIRJss (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 05:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgIRJss (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Sep 2020 05:48:48 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FB8C06174A
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:47 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g29so3173849pgl.2
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VX63uv7POSnrcDddgcRKLVv71UU0uzfi3cgBN/u3dbU=;
        b=QL9n+QAVExmeV9WVPd+DVixL3Xr9DvQpS7DsxJ/R2oj2CtppNsDUDUrgpjghv+JwjO
         juCEnaKkMZ5ebRJB595VN1NTygwWAVL9dMMnC/KLNnc7IRCgrUlb8tJB2GoeGzwrm91z
         0fr+788IFrGtFwPztcz2lTK2eBS4RAYDqpNDPRhV5zY3awz5/AEFZlWZcr5Devm37JGh
         WYbSE4444CYc61QvP2m/x2I1upij6u8sEhZ8+vKvImNteh3V8HNhMQ3HIyvC//Il6pbq
         ftKxaTFuJg6iKlmdTJwd+Bt0YpZvbLANAluWu64VDnniOTVdK2iGoJD2NiUTIuL3gRHf
         cwBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VX63uv7POSnrcDddgcRKLVv71UU0uzfi3cgBN/u3dbU=;
        b=gvo6udGv1op9SrmHQDfsgJCFdfJhg2KsTXX/OuDHB99hCB1+hcsbgIzRfEjRmwa1pj
         S9sS25+saq13oMkfXRkJ80RY/7AfbVn3y5lDBeBiHzDkrq/BS5XogLSYnCMMHhoFcfVu
         Ws3OXmkpGHdLpCG+IQvykyJUHwOSKPgtdonFVWd+Ui9xd+6zNZ17k2h9wEfs05st1F3r
         DZFxVqQWSsvprIToywPb8tscpmVcUu6vUuDh7sHthiDmjTdiN0t7qbXHcJ3f3tFyMvO0
         4qlPfpp5vSzpPqqwbflNnRf4YT/IZSPeepnmCv2t/XTPwAoWgPfgaQtDdtU3kkE+acrM
         GUlw==
X-Gm-Message-State: AOAM532M0Pc4xp4OsmRF2DA/ytzPZXjRZFy1qCC9U8h7emI/fUprGyWi
        qJxZT1VQhhaFB/nn61olMVbGFe0RlIo=
X-Google-Smtp-Source: ABdhPJz1uZuz7wtbY2NCIS3mIGudR35j3yaZfEZtOmjWptregPlb1IbpJnUhq7o/RZ9G7zOkInh36w==
X-Received: by 2002:a63:1257:: with SMTP id 23mr24285432pgs.401.1600422527077;
        Fri, 18 Sep 2020 02:48:47 -0700 (PDT)
Received: from localhost.localdomain ([122.179.62.164])
        by smtp.gmail.com with ESMTPSA id s24sm2227194pjp.53.2020.09.18.02.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 02:48:46 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V4 10/10] xfs: Introduce error injection to reduce maximum inode fork extent count
Date:   Fri, 18 Sep 2020 15:17:59 +0530
Message-Id: <20200918094759.2727564-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918094759.2727564-1-chandanrlinux@gmail.com>
References: <20200918094759.2727564-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag which enables
userspace programs to test "Inode fork extent count overflow detection"
by reducing maximum possible inode fork extent count to
10 (i.e. MAXERRTAGEXTNUM).

This commit makes the following additional changes to enable writing
deterministic userspace tests for checking inode extent count overflow,
1. xfs_bmap_add_extent_hole_real()
   File & disk offsets at which extents are allocated by Directory,
   Xattr and Realtime code cannot be controlled explicitly from
   userspace. When XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag is enabled,
   xfs_bmap_add_extent_hole_real() prevents extents from being merged
   even though the new extent might be contiguous and have the same
   state as its neighbours.
2. xfs_growfs_rt_alloc()
   This function allocates as large an extent as possible to fit in the
   additional bitmap/summary blocks. We now force allocation of block
   sized extents when XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag is
   enabled.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |  9 +++++++--
 fs/xfs/libxfs/xfs_errortag.h   |  4 +++-
 fs/xfs/libxfs/xfs_inode_fork.c |  4 ++++
 fs/xfs/libxfs/xfs_types.h      |  1 +
 fs/xfs/xfs_error.c             |  3 +++
 fs/xfs/xfs_rtalloc.c           | 16 ++++++++++++++--
 6 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9c665e379dfc..287f0c4f6d33 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2729,11 +2729,14 @@ xfs_bmap_add_extent_hole_real(
 	int			rval=0;	/* return value (logging flags) */
 	int			state = xfs_bmap_fork_to_state(whichfork);
 	struct xfs_bmbt_irec	old;
+	int			test_iext_overflow;
 
 	ASSERT(!isnullstartblock(new->br_startblock));
 	ASSERT(!cur || !(cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL));
 
 	XFS_STATS_INC(mp, xs_add_exlist);
+	test_iext_overflow = XFS_TEST_ERROR(false, ip->i_mount,
+				XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 
 	/*
 	 * Check and set flags if this segment has a left neighbor.
@@ -2762,7 +2765,8 @@ xfs_bmap_add_extent_hole_real(
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
 	    left.br_startblock + left.br_blockcount == new->br_startblock &&
 	    left.br_state == new->br_state &&
-	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN &&
+	    !test_iext_overflow)
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
@@ -2772,7 +2776,8 @@ xfs_bmap_add_extent_hole_real(
 	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     left.br_blockcount + new->br_blockcount +
-	     right.br_blockcount <= MAXEXTLEN))
+	     right.br_blockcount <= MAXEXTLEN) &&
+	    !test_iext_overflow)
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 53b305dea381..1c56fcceeea6 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -56,7 +56,8 @@
 #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
 #define XFS_ERRTAG_BUF_IOERROR				35
-#define XFS_ERRTAG_MAX					36
+#define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
+#define XFS_ERRTAG_MAX					37
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -97,5 +98,6 @@
 #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
 #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
+#define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 8d48716547e5..14389d10c597 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -24,6 +24,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_types.h"
+#include "xfs_errortag.h"
 
 kmem_zone_t *xfs_ifork_zone;
 
@@ -745,6 +746,9 @@ xfs_iext_count_may_overflow(
 
 	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
 
+	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
+		max_exts = MAXERRTAGEXTNUM;
+
 	nr_exts = ifp->if_nextents + nr_to_add;
 	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
 		return -EFBIG;
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 397d94775440..f2d6736b72e0 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -61,6 +61,7 @@ typedef void *		xfs_failaddr_t;
 #define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
 #define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
 #define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+#define	MAXERRTAGEXTNUM	((xfs_extnum_t)0xa)
 
 /*
  * Minimum and maximum blocksize and sectorsize.
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 7f6e20899473..3780b118cc47 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -54,6 +54,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_FORCE_SUMMARY_RECALC,
 	XFS_RANDOM_IUNLINK_FALLBACK,
 	XFS_RANDOM_BUF_IOERROR,
+	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
 };
 
 struct xfs_errortag_attr {
@@ -164,6 +165,7 @@ XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
 XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
 XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
 XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
+XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -202,6 +204,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(bad_summary),
 	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
 	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
+	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
 	NULL,
 };
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 3e841a75f272..29a519fc30fb 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -18,6 +18,8 @@
 #include "xfs_trans_space.h"
 #include "xfs_icache.h"
 #include "xfs_rtalloc.h"
+#include "xfs_error.h"
+#include "xfs_errortag.h"
 
 
 /*
@@ -780,17 +782,27 @@ xfs_growfs_rt_alloc(
 	int			resblks;	/* space reservation */
 	enum xfs_blft		buf_type;
 	struct xfs_trans	*tp;
+	xfs_extlen_t		nr_blks_alloc;
+	int			test_iext_overflow;
 
 	if (ip == mp->m_rsumip)
 		buf_type = XFS_BLFT_RTSUMMARY_BUF;
 	else
 		buf_type = XFS_BLFT_RTBITMAP_BUF;
 
+	test_iext_overflow = XFS_TEST_ERROR(false, ip->i_mount,
+				XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
+
 	/*
 	 * Allocate space to the file, as necessary.
 	 */
 	while (oblocks < nblocks) {
-		resblks = XFS_GROWFSRT_SPACE_RES(mp, nblocks - oblocks);
+		if (likely(!test_iext_overflow))
+			nr_blks_alloc = nblocks - oblocks;
+		else
+			nr_blks_alloc = 1;
+
+		resblks = XFS_GROWFSRT_SPACE_RES(mp, nr_blks_alloc);
 		/*
 		 * Reserve space & log for one extent added to the file.
 		 */
@@ -813,7 +825,7 @@ xfs_growfs_rt_alloc(
 		 * Allocate blocks to the bitmap file.
 		 */
 		nmap = 1;
-		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
+		error = xfs_bmapi_write(tp, ip, oblocks, nr_blks_alloc,
 					XFS_BMAPI_METADATA, 0, &map, &nmap);
 		if (!error && nmap < 1)
 			error = -ENOSPC;
-- 
2.28.0

