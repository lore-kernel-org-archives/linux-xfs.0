Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA44C6379D
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 15:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D27BF206F7
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 15:52:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FAqDqxgx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389676AbgKXPwY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 10:52:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29003 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389781AbgKXPwX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 10:52:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606233142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=x8y8WjgQkYZjPuzLzq8Fs3USuayOj8l3E0SVvaPI1Vc=;
        b=FAqDqxgxymNBHVSFUGNOQkh2IjmumdZ66NSl5ujCpXLyaOTvKb2ugZFZxwng2md2kzieMj
        ax3hNjGe2C5ZfMyw6Wl9mlGuBVcfvOkKMkpTMBMQ29/3rkOcs1gyu17mVhtikYZmeRXRSx
        1hTqhutnmiswA0FByCrw0qrimtaNdMU=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-J1yxPkhiOqGSVK25W8aONQ-1; Tue, 24 Nov 2020 10:52:20 -0500
X-MC-Unique: J1yxPkhiOqGSVK25W8aONQ-1
Received: by mail-pg1-f199.google.com with SMTP id i7so10182965pgn.22
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 07:52:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=x8y8WjgQkYZjPuzLzq8Fs3USuayOj8l3E0SVvaPI1Vc=;
        b=oCGbli3WoFqTiw/OTYw8WlT0iUSWHKszlP6F1c9i8OIBFvZ0WBPbNDk88MSj175git
         9HGEQpv7hCthEtEUJLhqJZzwb8AGFcIsQwg0qtKLRB9saTpJ/PH8AABkao+r+I2f2+Y/
         G5NRATDUABYNk7NqGv6MguRy+9ccYuLSNKbJcp2zTSGHOLEsqzpjkweG7si/59sLMO7u
         pGx5u947Tin5d+nCwOs/IKWwvrLo5s32RNjaPwadxB3VLrUm2DpyzmyG8822MJ9fXSCV
         kQ/A6bCUu0ZEETQr3XcC2uKoJ0lEOgnYTED0e/Kc832fSLF3Nyr7cT92diGnjzLYYOiA
         Z9Eg==
X-Gm-Message-State: AOAM532c6PAOxCqMGwzQTM+BvD/TOhOChzSAdvgYBck34rwkf70CzeUx
        eTQrNzTHXgcsl4ndOINW+ye0pLnX8K4wcZH8Do4BQ+FWy+3mEyDa+CfcQbiJzkl3V6YDEVbzcXy
        iRQwjL931uK/oedwB2ceRb5bjIvL52cC6zacWJgAz4U4diYh3bVlCi4l7y0FTxg5XhTYuRj4HYw
        ==
X-Received: by 2002:a17:90a:460a:: with SMTP id w10mr5613725pjg.232.1606233138821;
        Tue, 24 Nov 2020 07:52:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLwGVuPWNkqttFygmFPIuRWFx7qTvhvCdGMI5xeR2NSVbKFHvgQjn8crzazX3c0XxRLg1uoQ==
X-Received: by 2002:a17:90a:460a:: with SMTP id w10mr5613698pjg.232.1606233138502;
        Tue, 24 Nov 2020 07:52:18 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mn21sm3723909pjb.28.2020.11.24.07.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 07:52:18 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 2/3] xfs: kill ialloced in xfs_dialloc()
Date:   Tue, 24 Nov 2020 23:51:29 +0800
Message-Id: <20201124155130.40848-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201124155130.40848-1-hsiangkao@redhat.com>
References: <20201124155130.40848-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

It's enough to just use return code, and get rid of an argument.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 45cf7e55f5ee..5c8b0210aad3 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -607,13 +607,14 @@ xfs_inobt_insert_sprec(
 
 /*
  * Allocate new inodes in the allocation group specified by agbp.
- * Return 0 for success, else error code.
+ * Return 0 for successfully allocating some inodes in this AG;
+ *        1 for skipping to allocating in the next AG;
+ *      < 0 for error code.
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
@@ -795,10 +796,9 @@ xfs_ialloc_ag_alloc(
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
@@ -903,7 +903,6 @@ xfs_ialloc_ag_alloc(
 	 */
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, (long)newlen);
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, (long)newlen);
-	*alloc = 1;
 	return 0;
 }
 
@@ -1715,7 +1714,6 @@ xfs_dialloc(
 	struct xfs_buf		*agbp;
 	xfs_agnumber_t		agno;
 	int			error;
-	int			ialloced;
 	bool			noroom = false;
 	xfs_agnumber_t		start_agno;
 	struct xfs_perag	*pag;
@@ -1799,8 +1797,8 @@ xfs_dialloc(
 			goto nextag_relse_buffer;
 
 
-		error = xfs_ialloc_ag_alloc(tp, agbp, &ialloced);
-		if (error) {
+		error = xfs_ialloc_ag_alloc(tp, agbp);
+		if (error < 0) {
 			xfs_trans_brelse(tp, agbp);
 
 			if (error != -ENOSPC)
@@ -1811,7 +1809,7 @@ xfs_dialloc(
 			return 0;
 		}
 
-		if (ialloced) {
+		if (!error) {
 			/*
 			 * We successfully allocated some inodes, return
 			 * the current context to the caller so that it
-- 
2.18.4

