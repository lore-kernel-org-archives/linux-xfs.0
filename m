Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1784BC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 08:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0BF8205CA
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 08:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387752AbhARIjb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 03:39:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387627AbhARIj2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 03:39:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610959079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PZvpmG5or3JBdwdJ/ieTMuoFTtfP6U9OT9Q2X/rBLzA=;
        b=CARi2ToCT8TQ9+ry+6g9kDY2srm0ibKAqlNFRUY7xIfOLT5zrdr1RvTcfbw/X1xc2369zy
        bxYvlqYJuujrhdxfxvGOJCfYxkmkhri0G4cw88hW/Xm65cJNduKI2VSm3pXHmj5PKFgRmU
        Qije41Z7GUBLQZUT+i4oU2wnVojn0D4=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-Mr7BC0m2O0aerD1-tBFkOg-1; Mon, 18 Jan 2021 03:37:57 -0500
X-MC-Unique: Mr7BC0m2O0aerD1-tBFkOg-1
Received: by mail-pl1-f199.google.com with SMTP id 32so10968253plf.3
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 00:37:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PZvpmG5or3JBdwdJ/ieTMuoFTtfP6U9OT9Q2X/rBLzA=;
        b=W6EsWDeI3tXaQniFc5Zkyd8ZSOUE2qVAIaQaU2mgeGHsQMj4UVg45U7haSuoRvwDLE
         34m5yhDjhWlQS7aftKOP5ye+3FeJm5egzV1SbfHwClwIDSOrZ3u7cqzLPMxLMiLux+WF
         u+acMLionI4z1LsAAkM3b+0jxZqb5JY5TI9a7pq5/51E0ab9KpIwA3m2tP8BcOQ19gX+
         Mm5MvR3Ab8P8ydR4AKcdCB+p3/ei1RytgRgnP/aReFfbIWyyCFArkQb2tO+/1/5468Mp
         CXEcRvQcfP/YmPctTBhswb+hFurX1tHYAp+2hLgJt2upIRXIyA+ceyic6mXZPWCwn6Wz
         IDng==
X-Gm-Message-State: AOAM531UujICkUp6NssPxjIJElPoWdTd1yY2p7FSNFUm03JCi8GRCjo9
        /0SekFF6krTdX9prD5xQBTKJOeXnwptXoZm5ilnO0j5VT6XtbpDR84E7k3vaghCBO1mrzBY+hJf
        WlFEryxszJ5VPpBuCmu5Z+1ZXeXdEXkYkmq5CbtbclrRFizT1h3Hobhlf3+TcWXMbEkG9nAEJNg
        ==
X-Received: by 2002:a17:90b:d92:: with SMTP id bg18mr25236678pjb.66.1610959076223;
        Mon, 18 Jan 2021 00:37:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyPQKfILAc7VJdzzE2yPLctZ/iVHr+8AADUMdOPNqTMG5rOVNQ1npsegOeYT5UF/9ZtyusWhA==
X-Received: by 2002:a17:90b:d92:: with SMTP id bg18mr25236648pjb.66.1610959076017;
        Mon, 18 Jan 2021 00:37:56 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e5sm16293916pjs.0.2021.01.18.00.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 00:37:55 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Gao Xiang <hsiangkao@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH v5 2/5] xfs: get rid of xfs_growfs_{data,log}_t
Date:   Mon, 18 Jan 2021 16:36:57 +0800
Message-Id: <20210118083700.2384277-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210118083700.2384277-1-hsiangkao@redhat.com>
References: <20210118083700.2384277-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Such usage isn't encouraged by the kernel coding style. Leave the
definitions alone in case of userspace users.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_fsops.c | 12 ++++++------
 fs/xfs/xfs_fsops.h |  4 ++--
 fs/xfs/xfs_ioctl.c |  4 ++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 6ad31e6b4a04..0bc9c5ebd199 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -25,8 +25,8 @@
  */
 static int
 xfs_growfs_data_private(
-	xfs_mount_t		*mp,		/* mount point for filesystem */
-	xfs_growfs_data_t	*in)		/* growfs data input struct */
+	struct xfs_mount	*mp,		/* mount point for filesystem */
+	struct xfs_growfs_data	*in)		/* growfs data input struct */
 {
 	struct xfs_buf		*bp;
 	int			error;
@@ -35,7 +35,7 @@ xfs_growfs_data_private(
 	xfs_rfsblock_t		nb, nb_div, nb_mod;
 	xfs_rfsblock_t		delta;
 	xfs_agnumber_t		oagcount;
-	xfs_trans_t		*tp;
+	struct xfs_trans	*tp;
 	struct aghdr_init_data	id = {};
 
 	nb = in->newblocks;
@@ -170,8 +170,8 @@ xfs_growfs_data_private(
 
 static int
 xfs_growfs_log_private(
-	xfs_mount_t		*mp,	/* mount point for filesystem */
-	xfs_growfs_log_t	*in)	/* growfs log input struct */
+	struct xfs_mount	*mp,	/* mount point for filesystem */
+	struct xfs_growfs_log	*in)	/* growfs log input struct */
 {
 	xfs_extlen_t		nb;
 
@@ -268,7 +268,7 @@ xfs_growfs_data(
 int
 xfs_growfs_log(
 	xfs_mount_t		*mp,
-	xfs_growfs_log_t	*in)
+	struct xfs_growfs_log	*in)
 {
 	int error;
 
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 92869f6ec8d3..2cffe51a31e8 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -6,8 +6,8 @@
 #ifndef __XFS_FSOPS_H__
 #define	__XFS_FSOPS_H__
 
-extern int xfs_growfs_data(xfs_mount_t *mp, xfs_growfs_data_t *in);
-extern int xfs_growfs_log(xfs_mount_t *mp, xfs_growfs_log_t *in);
+extern int xfs_growfs_data(struct xfs_mount *mp, struct xfs_growfs_data *in);
+extern int xfs_growfs_log(struct xfs_mount *mp, struct xfs_growfs_log *in);
 extern void xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
 extern int xfs_reserve_blocks(xfs_mount_t *mp, uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3fbd98f61ea5..a62520f49ec5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -2260,7 +2260,7 @@ xfs_file_ioctl(
 	}
 
 	case XFS_IOC_FSGROWFSDATA: {
-		xfs_growfs_data_t in;
+		struct xfs_growfs_data in;
 
 		if (copy_from_user(&in, arg, sizeof(in)))
 			return -EFAULT;
@@ -2274,7 +2274,7 @@ xfs_file_ioctl(
 	}
 
 	case XFS_IOC_FSGROWFSLOG: {
-		xfs_growfs_log_t in;
+		struct xfs_growfs_log in;
 
 		if (copy_from_user(&in, arg, sizeof(in)))
 			return -EFAULT;
-- 
2.27.0

