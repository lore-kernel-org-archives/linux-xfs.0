Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EECCEC433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 00:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C31B322E03
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 00:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgLGASU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 19:18:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54409 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbgLGASU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 19:18:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607300213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=V/FQM7+BNIZb8xy/yAEOGBR4rK3IjDnj432W9+MGeq4=;
        b=VnMgp8z+JQ0Pbo3ykv77Q5/ZJY73/BR9Jlya0+1aYZFCiGl3t2yGLm9SY81LU37jjHufJY
        0XBxjDVDhK5BjRiSpOvWVs90nVv2cVKbsNWNGYL4cpmFTPB5Q7kjVo+LuKr/h26KnkfnDt
        AOxWCUcOmLvytm5bPAGsQLQfTz5kCEc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-4ctzrekqPquDb4p2qJBmkw-1; Sun, 06 Dec 2020 19:16:51 -0500
X-MC-Unique: 4ctzrekqPquDb4p2qJBmkw-1
Received: by mail-pj1-f69.google.com with SMTP id gv14so8054581pjb.1
        for <linux-xfs@vger.kernel.org>; Sun, 06 Dec 2020 16:16:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=V/FQM7+BNIZb8xy/yAEOGBR4rK3IjDnj432W9+MGeq4=;
        b=DURmmNMI7Dm0O0xEEHnDHIyDhctzDwvgHh443d2lWvjH2kP1eoKQEjL3pB46RD5an3
         rArfsJA3FJSx5T1dvVvpejuxPAhCuJXWKPBHQ084DfClvSwsyHC2OgdxEG4kmddHowFd
         CAjECfkRatBWefaeQl8LXDz9Z6uTr90t7aKppM3J+7iErhwqln4PQcboaNulZ5RabVg8
         1RWlzBl2pdkXw6E2zQMFY7hBOZB+T9IsFE513Kp+3PeSBrvgthmOn14Hj5loaupBeRBi
         /P6G6FmngIIjhRueVyowgHpW9KXb2oaqW88nMUQGp+5JP4fHsr3xfhDEvASixYQ6zZbd
         2gLw==
X-Gm-Message-State: AOAM530ifwGNSd5Krt6H8y6GOGu6l9G93dLwpmw9K0WKFf29Knz3vGrb
        qA0pwcw032c0GmxY28c8A8S7nwBmtQRyjGgF9HWmslShvL19MIR6luGEw66REgPR7hTvqH8hmmy
        mgSDeI9jH+4wU2uy3lmG+h5A7vPkEnDQP6Ms/ddcXqyKCauTlSS4kUQJuclJ6rfyNBbzRUfJBOQ
        ==
X-Received: by 2002:a17:90a:fa0c:: with SMTP id cm12mr14239261pjb.87.1607300210698;
        Sun, 06 Dec 2020 16:16:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxBfzhn/az6pMcNfySeI4XEUwIOiRduKJKkuvYOjGIWHjTYScAXBZhFcmso7RVultU5x21PiQ==
X-Received: by 2002:a17:90a:fa0c:: with SMTP id cm12mr14239246pjb.87.1607300210382;
        Sun, 06 Dec 2020 16:16:50 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o9sm8218056pjl.11.2020.12.06.16.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 16:16:50 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 6/6] xfs: kill ialloced in xfs_dialloc()
Date:   Mon,  7 Dec 2020 08:15:33 +0800
Message-Id: <20201207001533.2702719-7-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201207001533.2702719-1-hsiangkao@redhat.com>
References: <20201207001533.2702719-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

It's enough to just use return code, and get rid of an argument.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 527f17f09bd3..a0e6e333eea2 100644
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
 
@@ -1749,7 +1747,6 @@ xfs_dialloc_select_ag(
 	struct xfs_buf		*agbp;
 	xfs_agnumber_t		agno;
 	int			error;
-	int			ialloced;
 	bool			noroom = false;
 	xfs_agnumber_t		start_agno;
 	struct xfs_perag	*pag;
@@ -1823,17 +1820,14 @@ xfs_dialloc_select_ag(
 		if (!okalloc)
 			goto nextag_relse_buffer;
 
-
-		error = xfs_ialloc_ag_alloc(*tpp, agbp, &ialloced);
-		if (error) {
+		error = xfs_ialloc_ag_alloc(*tpp, agbp);
+		if (error < 0) {
 			xfs_trans_brelse(*tpp, agbp);
 
 			if (error == -ENOSPC)
 				error = 0;
 			break;
-		}
-
-		if (ialloced) {
+		} else if (error == 0) {
 			/*
 			 * We successfully allocated some inodes, so roll the
 			 * transaction and return the locked AGI buffer to the
-- 
2.18.4

