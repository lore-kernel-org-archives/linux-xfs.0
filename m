Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C9EC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 11:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E6E723B23
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 11:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgLILe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 06:34:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727970AbgLILe2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 06:34:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607513582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1zyT/hm2nAM99UvYak/INvxUxfGjQvEiSb6l+IMi4YI=;
        b=ZSMaKhFm5r/ig1AeaOXoZ8soNI+6bqEsXF3G3k27FWHzB69czoyYHRZskny7M47OdVBGUV
        tsUbXtRzfGLKzmQUv5WhZT2d9/lc3D325pqLl9V5as4A29xgmYRxpCljnaYubIquWrZ0L3
        OHcPivDm3ykt8kyLk8bdtalCv2IfwhI=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-hbx-PrsENbuISDOXa21qAA-1; Wed, 09 Dec 2020 06:29:46 -0500
X-MC-Unique: hbx-PrsENbuISDOXa21qAA-1
Received: by mail-pg1-f198.google.com with SMTP id m15so914048pgs.7
        for <linux-xfs@vger.kernel.org>; Wed, 09 Dec 2020 03:29:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1zyT/hm2nAM99UvYak/INvxUxfGjQvEiSb6l+IMi4YI=;
        b=ZvXKmhA4ZLwvpbAjzhcGMeZdClDkoPs9ExzbFb+dUtQblxig0JfU0MpZKKojfTqS/H
         MWOoQzq35Y2YzV6Tl1LVWMkrQuc8dBss6QYDQVa5uXhfqyOp/vrclWLoMysvaB3N1kCo
         P0adWp27m3zcv+qLvoPS0X2/lwLjsPHVvxKpCWj0TafzDgBPEUpVc8vMyHTRlv+CWgOy
         GsDhUyVRbohRYFE8LarwRtFTtb3q3+ffUKTkAtrVb/w9VNyIfFsZ1F8trCa/ffpwmdss
         6biHdaGYhh6z4vo3A9qMjuHcqlfItsFYA7qjsJPlIgz+6YaqwJU1cr1egLVuXrv896Ls
         16UA==
X-Gm-Message-State: AOAM5334p1m8pEr9vOaV5AkG0Zhlx1lOvLv3QiCJq/lDt+6G1I0gSPKx
        A+rl6BORUEWuMqJPffaHuj375V9sReQhV6e17JUeEfa5p5Ys+ln3auORKd9KUAi8I2Qu1OXbA8H
        DqjQJRVC77xD7/PlukQLGWC5Qb/EV8mZ05spTtNU6YTRStl1ZZ8bSM1HUn3E+KpgqWjg2KujVcQ
        ==
X-Received: by 2002:a63:1a5b:: with SMTP id a27mr1546946pgm.169.1607513384941;
        Wed, 09 Dec 2020 03:29:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLGL0c1Q+jvu25liIWm4YVISCN2B7dyjCd8206US+99gVQ2mGCz7U49tyHQ1GQAqjDfp0Lxg==
X-Received: by 2002:a63:1a5b:: with SMTP id a27mr1546925pgm.169.1607513384663;
        Wed, 09 Dec 2020 03:29:44 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y5sm2231280pfp.45.2020.12.09.03.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 03:29:44 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v5 6/6] xfs: kill ialloced in xfs_dialloc()
Date:   Wed,  9 Dec 2020 19:28:20 +0800
Message-Id: <20201209112820.114863-7-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201209112820.114863-1-hsiangkao@redhat.com>
References: <20201209112820.114863-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.27.0

