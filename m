Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E2CDC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 13:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 417A121919
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 13:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731150AbhAKNZR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 08:25:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55414 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730680AbhAKNZP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 08:25:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610371428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PZvpmG5or3JBdwdJ/ieTMuoFTtfP6U9OT9Q2X/rBLzA=;
        b=HkpXqQWLoSJbiXLaDYLZfeMLNkFll7dMZR1jhmowJTor4aDs7utyOp2m29XJZ6wHfzAFno
        w8u4jEFU3TB3Yg8SR2ub9B+wgAUcn5Hqb8p0ae55s4AeTKIlC7XljvjmayP+t0xjg1llsC
        k7lLwUL2d9NtKpMekHR8UMtlr5x5Gs0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-WZa_tJsnO2S2YIH3V2x2Uw-1; Mon, 11 Jan 2021 08:23:46 -0500
X-MC-Unique: WZa_tJsnO2S2YIH3V2x2Uw-1
Received: by mail-pl1-f198.google.com with SMTP id y5so9252298plr.19
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 05:23:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PZvpmG5or3JBdwdJ/ieTMuoFTtfP6U9OT9Q2X/rBLzA=;
        b=m6Kf2qKiTCUKB32HSPHIisxhPKm6fhtUjV4gflVS+5D3P3pNUacoWTcg9jymPTzCc2
         B4TP8KD9GBfYSoWa8uHh8ocnPeR76hLLtv7Kfg+xC0x84A2hNDNnAlF5aHVKgJXSNmQK
         1cy5xGux++hBKd7yTjRVH/yAFqpBVEnYrdC0B529kKqv+eFwFpo3rH5R8kXyOfoj+fur
         pn//enwsCwlc0OyqKWhSTDH7MtI5epRprJgT5m6hme5evt2GQSrZKETztQdJB4+ReU6l
         Zn6QXmnTmQsCP+O1El0UatwEkkjfyYuK2UME10c2krTtdiPnifINekSKX+W2JwXIDjw8
         tAig==
X-Gm-Message-State: AOAM532tIegPU4IajOrd6UnNVVF4SBNajeAa6boVQhIqSNbJR39r3DJk
        +7yX86stq9X1fe8BtOpUGRNqgjE8nPVyfBW9axfbxgvFogsDHPJEgzPjsN635gctU0w4BEipJ3C
        FRMp7M9aKs2xhtpYun42ZiNc+lNd9+alTty89zqx4XnyFD9Si1Lcqkt3hatlfYVA23Ij1ShPdbg
        ==
X-Received: by 2002:a17:90b:228e:: with SMTP id kx14mr18483790pjb.210.1610371425187;
        Mon, 11 Jan 2021 05:23:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxWqLcDXdUbGN0VMrqZ49vM3xGElXxfU5sZ/17wUke8gFbHvNDw/2akJ9J9FdkDdXFTcV1a6A==
X-Received: by 2002:a17:90b:228e:: with SMTP id kx14mr18483760pjb.210.1610371424932;
        Mon, 11 Jan 2021 05:23:44 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id cu4sm16179355pjb.18.2021.01.11.05.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 05:23:44 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH v4 2/4] xfs: get rid of xfs_growfs_{data,log}_t
Date:   Mon, 11 Jan 2021 21:22:41 +0800
Message-Id: <20210111132243.1180013-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210111132243.1180013-1-hsiangkao@redhat.com>
References: <20210111132243.1180013-1-hsiangkao@redhat.com>
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

