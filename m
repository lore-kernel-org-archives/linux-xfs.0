Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FDEC4321E
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 05:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235799AbiKWF6Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 00:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235439AbiKWF6V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 00:58:21 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07309D22AE
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 21:58:18 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id z26so16436469pff.1
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 21:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQkrm+kQjUlJqW8qA0j3LPZCqK1TYyBRTrJ6LO0W9nc=;
        b=N5672HCrMUe23oLVM10lne7T83gWqFl4s0k8h15uJ3G3/1dM4qOKfL8kvwSLqbNvaf
         opO9N/sXtFTPL0DC+9KG/weZDLzg8tkyeGySDnq/c4ECQJGGz3kpLlmeffvp0wwLsj6Q
         h2c2HdUPu+704fgmC1atC0fB5Tpy02yBRGCV2YO1uMBEAG9y9FF4vDrEG/iaWs2OyZAQ
         coo0YygtI/C4a+XZh7/ozaxbrmZk+fEJeDZhwbD21qCRQ8bY6XpJUK4biKxpizbgAoOQ
         2ecqQjnxPuQ/6U1jfBT6dNUN3wr1D8aPiHlzssP6cdL323BMJBSgWzfJwLZHiFn6zlZw
         7wUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQkrm+kQjUlJqW8qA0j3LPZCqK1TYyBRTrJ6LO0W9nc=;
        b=CskGLGpJvGfA4sZDSJLsASusQTZs6+VuuTOkOfzuYsf5ZXTeYT6fhGPxAoL9QjD3g4
         EvbdBA0Xan2/+WSAfH9f/o6LVW5oB8QtRAx1VSSOSXpWX3BgAhWZpRRyu73yvOHw4yrG
         r2bkuw1xNZqT133KHZlVn1LNsKkqoe4Bv9hQRUPruEmWDO7BAHYID/ZBazXIB2TOaf9A
         hD4iyXChc5dR9BzyCpcvoeniRjxvhkP0sEieWx7t6G0qJTVKK0RRIgk7xnZL8DgSPQtx
         DCf/0gWxHvEp50rC7x7bAglyq7A5T51JAn0nKfy6yfyVeZ5FWKRzW1h14JU9TRF8KvIX
         egqg==
X-Gm-Message-State: ANoB5pkaKQltUvJXq/WY3E7QLIkvg0UEMsq6BLQv4F301rx8T+VAE/9q
        fW7/cViBGYRdB3SmWL2HyTP9xioOnZHF8g==
X-Google-Smtp-Source: AA0mqf4V/qYrj31yyQmE3Bae8RB2HAhRbsX8xPnZh6R1cncysiVXFbowPrONzONjjSWCrNREpCZG1A==
X-Received: by 2002:a63:4e64:0:b0:477:a782:31be with SMTP id o36-20020a634e64000000b00477a78231bemr4611293pgl.38.1669183098475;
        Tue, 22 Nov 2022 21:58:18 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id w5-20020aa79545000000b0056c410fd03fsm11730094pfq.40.2022.11.22.21.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 21:58:17 -0800 (PST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oxily-00HYSe-HV; Wed, 23 Nov 2022 16:58:14 +1100
Received: from dave by discord.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1oxily-003A2p-1e;
        Wed, 23 Nov 2022 16:58:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
Subject: [PATCH 6/9] xfs: xfs_bmap_punch_delalloc_range() should take a byte range
Date:   Wed, 23 Nov 2022 16:58:09 +1100
Message-Id: <20221123055812.747923-7-david@fromorbit.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221123055812.747923-1-david@fromorbit.com>
References: <20221123055812.747923-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

All the callers of xfs_bmap_punch_delalloc_range() jump through
hoops to convert a byte range to filesystem blocks before calling
xfs_bmap_punch_delalloc_range(). Instead, pass the byte range to
xfs_bmap_punch_delalloc_range() and have it do the conversion to
filesystem blocks internally.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c      | 16 ++++++----------
 fs/xfs/xfs_bmap_util.c | 10 ++++++----
 fs/xfs/xfs_bmap_util.h |  2 +-
 fs/xfs/xfs_iomap.c     |  8 ++------
 4 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5d1a995b15f8..6aadc5815068 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -114,9 +114,8 @@ xfs_end_ioend(
 	if (unlikely(error)) {
 		if (ioend->io_flags & IOMAP_F_SHARED) {
 			xfs_reflink_cancel_cow_range(ip, offset, size, true);
-			xfs_bmap_punch_delalloc_range(ip,
-						      XFS_B_TO_FSBT(mp, offset),
-						      XFS_B_TO_FSB(mp, size));
+			xfs_bmap_punch_delalloc_range(ip, offset,
+					offset + size);
 		}
 		goto done;
 	}
@@ -455,12 +454,8 @@ xfs_discard_folio(
 	struct folio		*folio,
 	loff_t			pos)
 {
-	struct inode		*inode = folio->mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_inode	*ip = XFS_I(folio->mapping->host);
 	struct xfs_mount	*mp = ip->i_mount;
-	size_t			offset = offset_in_folio(folio, pos);
-	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, pos);
-	xfs_fileoff_t		pageoff_fsb = XFS_B_TO_FSBT(mp, offset);
 	int			error;
 
 	if (xfs_is_shutdown(mp))
@@ -470,8 +465,9 @@ xfs_discard_folio(
 		"page discard on page "PTR_FMT", inode 0x%llx, pos %llu.",
 			folio, ip->i_ino, pos);
 
-	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
-			i_blocks_per_folio(inode, folio) - pageoff_fsb);
+	error = xfs_bmap_punch_delalloc_range(ip, pos,
+			round_up(pos, folio_size(folio)));
+
 	if (error && !xfs_is_shutdown(mp))
 		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
 }
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 04d0c2bff67c..867645b74d88 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -590,11 +590,13 @@ xfs_getbmap(
 int
 xfs_bmap_punch_delalloc_range(
 	struct xfs_inode	*ip,
-	xfs_fileoff_t		start_fsb,
-	xfs_fileoff_t		length)
+	xfs_off_t		start_byte,
+	xfs_off_t		end_byte)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = &ip->i_df;
-	xfs_fileoff_t		end_fsb = start_fsb + length;
+	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, start_byte);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end_byte);
 	struct xfs_bmbt_irec	got, del;
 	struct xfs_iext_cursor	icur;
 	int			error = 0;
@@ -607,7 +609,7 @@ xfs_bmap_punch_delalloc_range(
 
 	while (got.br_startoff + got.br_blockcount > start_fsb) {
 		del = got;
-		xfs_trim_extent(&del, start_fsb, length);
+		xfs_trim_extent(&del, start_fsb, end_fsb - start_fsb);
 
 		/*
 		 * A delete can push the cursor forward. Step back to the
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 24b37d211f1d..6888078f5c31 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -31,7 +31,7 @@ xfs_bmap_rtalloc(struct xfs_bmalloca *ap)
 #endif /* CONFIG_XFS_RT */
 
 int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
-		xfs_fileoff_t start_fsb, xfs_fileoff_t length);
+		xfs_off_t start_byte, xfs_off_t end_byte);
 
 struct kgetbmap {
 	__s64		bmv_offset;	/* file offset of segment in blocks */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ea96e8a34868..09676ff6940e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1126,12 +1126,8 @@ xfs_buffered_write_delalloc_punch(
 	loff_t			offset,
 	loff_t			length)
 {
-	struct xfs_mount	*mp = XFS_M(inode->i_sb);
-	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, offset);
-	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + length);
-
-	return xfs_bmap_punch_delalloc_range(XFS_I(inode), start_fsb,
-				end_fsb - start_fsb);
+	return xfs_bmap_punch_delalloc_range(XFS_I(inode), offset,
+			offset + length);
 }
 
 static int
-- 
2.37.2

