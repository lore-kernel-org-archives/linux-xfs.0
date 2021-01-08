Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14770C43381
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 19:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC38B239D4
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 19:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbhAHTLu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 14:11:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727893AbhAHTLt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jan 2021 14:11:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610133022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GCNgsBdrHAjdMsh8S3TROZvhbqN8Ai8wTayaAsO9JBs=;
        b=J7yOavtG1laYdTEw1N5WP57rdZ+9gJnvu8V2mKdhOX7DfDxcU433ORKtA39o3cnVmruypG
        y5dBbNvsBTiK9zktC484RuIbLUX+B5/00i9nHw8/z0aYUzoWGKySQ28GbnuZBj3vYndBV/
        MTHkDpEvfO8LfNYSvEVbjCeFCf89rz8=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-r0UkMf44MTiKCWaVw2LQ8Q-1; Fri, 08 Jan 2021 14:10:21 -0500
X-MC-Unique: r0UkMf44MTiKCWaVw2LQ8Q-1
Received: by mail-pf1-f199.google.com with SMTP id d84so4405704pfd.21
        for <linux-xfs@vger.kernel.org>; Fri, 08 Jan 2021 11:10:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GCNgsBdrHAjdMsh8S3TROZvhbqN8Ai8wTayaAsO9JBs=;
        b=qk3LDjxCg9JpQOvducQFRJIGRVm2TBAtUDcvGzJM+fpk+I6+HHSEqu9870nltxNTZu
         zvZD3JlCR5dBb/LaMsUZHMiGWqVmkbJPV8YfSGbLjm7kj4ttXOGlSrXKQmo6bNAPjTY9
         NNaaUBl/JSt/SApF4fOsN9vkvJfFBckK36rKunKU9/gH4sXzPfigTGQrxTziZpyNMTEm
         wV/FwyAx07sLsBgkeraZjCLcTi5OSa2RwHdHUdgoyjdXDpFz0T/98XPEVQ2TN9vODMM1
         dAgAKDSgpu6NhqhK/ZTaZ3/udly/YW9InBgjcY+SPevYXRw4wNUaarCwa0+ZR1fYZata
         7NPw==
X-Gm-Message-State: AOAM5305LVBLUOl1xB5K9zgXs90u3ubo3hDrDZsipW19vBSctJD8AYD4
        I7dh7gRt+3CB//ztbkooe10mTHlldonrKB4GmAAt+fiXPmYWJh3flzGpSxo7i+qVe9DuU7FTf6p
        YAM1elWPn5uTiV95/NMaUrAUoX5l/qs4UCiUYYjcHtGUevHlULnShkfO97S9wDPk1VDvwlSMtVg
        ==
X-Received: by 2002:aa7:9706:0:b029:19d:a2c6:aeb with SMTP id a6-20020aa797060000b029019da2c60aebmr5063576pfg.36.1610133019818;
        Fri, 08 Jan 2021 11:10:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxEiZPvQbTY4yEg35MkZXJjuo/H1iWOcLJdSKj7DnW7BOX9X3Ku4DK8YGtgerZD0XyNU43Mxg==
X-Received: by 2002:aa7:9706:0:b029:19d:a2c6:aeb with SMTP id a6-20020aa797060000b029019da2c60aebmr5063545pfg.36.1610133019502;
        Fri, 08 Jan 2021 11:10:19 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h15sm9761824pfo.71.2021.01.08.11.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 11:10:19 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 2/4] xfs: get rid of xfs_growfs_{data,log}_t
Date:   Sat,  9 Jan 2021 03:09:17 +0800
Message-Id: <20210108190919.623672-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210108190919.623672-1-hsiangkao@redhat.com>
References: <20210108190919.623672-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Such usage isn't encouraged by the kernel coding style.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_fs.h |  4 ++--
 fs/xfs/xfs_fsops.c     | 12 ++++++------
 fs/xfs/xfs_fsops.h     |  4 ++--
 fs/xfs/xfs_ioctl.c     |  4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2a2e3cfd94f0..a17313efc1fe 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -308,12 +308,12 @@ struct xfs_ag_geometry {
 typedef struct xfs_growfs_data {
 	__u64		newblocks;	/* new data subvol size, fsblocks */
 	__u32		imaxpct;	/* new inode space percentage limit */
-} xfs_growfs_data_t;
+};
 
 typedef struct xfs_growfs_log {
 	__u32		newblocks;	/* new log size, fsblocks */
 	__u32		isint;		/* 1 if new log is internal */
-} xfs_growfs_log_t;
+};
 
 typedef struct xfs_growfs_rt {
 	__u64		newblocks;	/* new realtime size, fsblocks */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index d254588f6e21..6c5f6a50da2e 100644
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
 	xfs_rfsblock_t		nb, nb_mod;
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
index 92869f6ec8d3..d7e9af4a28eb 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -6,8 +6,8 @@
 #ifndef __XFS_FSOPS_H__
 #define	__XFS_FSOPS_H__
 
-extern int xfs_growfs_data(xfs_mount_t *mp, xfs_growfs_data_t *in);
-extern int xfs_growfs_log(xfs_mount_t *mp, xfs_growfs_log_t *in);
+extern int xfs_growfs_data(xfs_mount_t *mp, struct xfs_growfs_data *in);
+extern int xfs_growfs_log(xfs_mount_t *mp, struct xfs_growfs_log *in);
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

