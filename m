Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF53CC19437
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 12:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C41823AA8
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 12:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729480AbgLHMXa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 07:23:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729485AbgLHMX3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Dec 2020 07:23:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607430122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=G5zHoFl4vQEdOQtxHPJtiOs+Z6vqtbTnbc4CAVi7q6A=;
        b=WKgpbSjw+m4f9nnCnLCiB9rFzVYf4a+kHOWk7BnqqsFbhK2zF7CCbJCaRA9firvrfQXeYi
        S32vLeKATbAyVi2vKcRG+S64YbbMFmx4OmdyPujcr3nZTFsDfUW/DMhO9kWSuGa+Oa5DJb
        5tgPwDRk42ausv/BdE0myCQ2jx9JrDM=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-xX1UXkLSOMqQ1gHJDMV_4A-1; Tue, 08 Dec 2020 07:22:01 -0500
X-MC-Unique: xX1UXkLSOMqQ1gHJDMV_4A-1
Received: by mail-pg1-f197.google.com with SMTP id a27so11751649pga.6
        for <linux-xfs@vger.kernel.org>; Tue, 08 Dec 2020 04:22:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=G5zHoFl4vQEdOQtxHPJtiOs+Z6vqtbTnbc4CAVi7q6A=;
        b=FEe35UCn2j8RbsDEB0cGmdCPf5fydgg9TB9QrIQF6w9QAZm5Y2osvi5hk+FgAS/X6U
         c4ZzMDYhRPzHCj4zOiDk7TRaoQT0fac2G32xDgQzx/tf7fllEIcHkfRtaRYA0WQ5WSf2
         2UQQHB2MWhlHArkhCxtmNyRppkQ5pe9HaS2m2BjW/E2yPGH+UvBcCnUzL469YZCnS5mq
         ye1SWUuLNOEokEmnJ25MOgmBeKUHaeNSLzmSKfsOop7xBJkQ8MpV6evOPtmkax6O5x10
         Wl5mp4rrpoQDX/o2lHDlkQFmPCtJmUz6ZDL5iSpYxIvvsm+zqIdlue5wFg30PJU6nW0H
         U5Tg==
X-Gm-Message-State: AOAM530SYQe7e2sCWWCkKLWBXw/+6lYnG31gX9tW9JbHOo0tnCBThIql
        +wfw4lY2DDbUlWECVLInNBooE48ET+NSdZXF4sqtZjSZGmp3iT+hZu0GpXw1h6X+VcoC3piMT1J
        8WN6dlsT3M8rlh5h8MFtURZswR6A4x0Yf6xBjGeov+sIWj7AUGwqZPhy1GEU5P0V/Dx6N9nhbiQ
        ==
X-Received: by 2002:a17:902:b192:b029:d7:ca4a:4ec1 with SMTP id s18-20020a170902b192b02900d7ca4a4ec1mr20952202plr.76.1607430119824;
        Tue, 08 Dec 2020 04:21:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxcfa5QXZEbzzdXuLVGSTt+BxQXkEOOiP4M5OfpF8u2Q04N+i/9D9OErXQn2wOvsRDzIwwtzg==
X-Received: by 2002:a17:902:b192:b029:d7:ca4a:4ec1 with SMTP id s18-20020a170902b192b02900d7ca4a4ec1mr20952179plr.76.1607430119533;
        Tue, 08 Dec 2020 04:21:59 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a29sm1156926pfr.73.2020.12.08.04.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 04:21:59 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 6/6] xfs: kill ialloced in xfs_dialloc()
Date:   Tue,  8 Dec 2020 20:20:03 +0800
Message-Id: <20201208122003.3158922-7-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201208122003.3158922-1-hsiangkao@redhat.com>
References: <20201208122003.3158922-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

It's enough to just use return code, and get rid of an argument.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index dcb076d5c390..063a1a543890 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -607,13 +607,13 @@ xfs_inobt_insert_sprec(
 
 /*
  * Allocate new inodes in the allocation group specified by agbp.
- * Return 0 for success, else error code.
+ * Returns 0 if inodes were allocated in this AG; 1 if there was no space
+ * in this AG; or the usual negative error code.
  */
 STATIC int
 xfs_ialloc_ag_alloc(
 	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	int			*alloc)
+	struct xfs_buf		*agbp)
 {
 	struct xfs_agi		*agi;
 	struct xfs_alloc_arg	args;
@@ -795,10 +795,9 @@ xfs_ialloc_ag_alloc(
 		allocmask = (1 << (newlen / XFS_INODES_PER_HOLEMASK_BIT)) - 1;
 	}
 
-	if (args.fsbno == NULLFSBLOCK) {
-		*alloc = 0;
-		return 0;
-	}
+	if (args.fsbno == NULLFSBLOCK)
+		return 1;
+
 	ASSERT(args.len == args.minlen);
 
 	/*
@@ -903,7 +902,6 @@ xfs_ialloc_ag_alloc(
 	 */
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, (long)newlen);
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, (long)newlen);
-	*alloc = 1;
 	return 0;
 }
 
@@ -1747,7 +1745,6 @@ xfs_dialloc_select_ag(
 	struct xfs_buf		*agbp;
 	xfs_agnumber_t		agno;
 	int			error;
-	int			ialloced;
 	bool			noroom = false;
 	xfs_agnumber_t		start_agno;
 	struct xfs_perag	*pag;
@@ -1820,9 +1817,8 @@ xfs_dialloc_select_ag(
 		if (!okalloc)
 			goto nextag_relse_buffer;
 
-
-		error = xfs_ialloc_ag_alloc(*tpp, agbp, &ialloced);
-		if (error) {
+		error = xfs_ialloc_ag_alloc(*tpp, agbp);
+		if (error < 0) {
 			xfs_trans_brelse(*tpp, agbp);
 
 			if (error == -ENOSPC)
@@ -1830,7 +1826,7 @@ xfs_dialloc_select_ag(
 			break;
 		}
 
-		if (ialloced) {
+		if (error == 0) {
 			/*
 			 * We successfully allocated space for an inode cluster
 			 * in this AG.  Roll the transaction so that we can
-- 
2.18.4

