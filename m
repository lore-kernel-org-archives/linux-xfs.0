Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1CFC433E9
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 13:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 983252312E
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 13:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbhAZNFN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 08:05:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392452AbhAZM6m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 07:58:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611665835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KJdGSnBzSu18VjehFOROpG0iRoxMea584ylyyu64ZCg=;
        b=XHGr+HDTa6hNB3IpGThv9jlBHvIJeBF1zEjZopfUoSP5GpPOlPg4sYtdP8DAY2uadlJj2s
        dMhGCulVqlSgDWL24TfmMr5RdQhd/ApYBp6Thd4tXZWigac9Axhp4RFps6Uj076IpljthH
        oFeHV8fAyioiQauvTEw5Cxm5z4Sr7P8=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-ff22R4nFPpeqPF4iAwFKGA-1; Tue, 26 Jan 2021 07:57:14 -0500
X-MC-Unique: ff22R4nFPpeqPF4iAwFKGA-1
Received: by mail-pf1-f198.google.com with SMTP id x206so8009240pfc.16
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jan 2021 04:57:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KJdGSnBzSu18VjehFOROpG0iRoxMea584ylyyu64ZCg=;
        b=qYj4fc+JQbNusc7Wm6fm8v6avYBDKJInqu9c4oFuTNJhlVoElhIwC08o32eOZD37hJ
         DUvpTm3ExeN2EEtgldvi2FO/2N8bRwJlAWasUuWo1N4LPS9jwtG5ZoNpOzaT1WzmSBDx
         iNjqccieIZ8NT4DZmYEY9/OHBtzNqWBGMRFpZuxbTWcb8sWZCrLAn7nzsZkztm+XJWhF
         DOf3yzloEBfoZzE1TnORegeJYdqay8/aloAKUZqP0VXtOn0sX3lohTMv+sPgZHgGX9D3
         LcS4bcVv3hgxStaOLWClMWBbybql/L9AUBv/Z9z81T5PPCZKwHzIHmb+SHET4NYVcKyA
         ztPA==
X-Gm-Message-State: AOAM533u+94SbRK1eU85t9q4gPjr/tp9vwaRYFMgYkprFBjoHoQyCNBq
        E90iZlvc4vfaCXzdieoutApzd4VsOen1OYjPezdNqHVInYMcR1vL7BGUkHbMfXzf4J+CtJ9Jnf9
        X3gIiLDXJgoJv53REUjgNEOgmv8g4NGZ3cZRIjz3TwmqQhGX5980OxddiE75AiUbCWAs9FzXBsg
        ==
X-Received: by 2002:a65:6119:: with SMTP id z25mr5528669pgu.17.1611665831775;
        Tue, 26 Jan 2021 04:57:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdagUpQeiZlFQ7p3wAM5hWMfm2adzsyMkrKi3BY9LG/pxJwTi0HIhpBL11ImWzbk0GZZbhYQ==
X-Received: by 2002:a65:6119:: with SMTP id z25mr5528645pgu.17.1611665831465;
        Tue, 26 Jan 2021 04:57:11 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b203sm19243174pfb.11.2021.01.26.04.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 04:57:11 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Gao Xiang <hsiangkao@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH v6 2/7] xfs: get rid of xfs_growfs_{data,log}_t
Date:   Tue, 26 Jan 2021 20:56:16 +0800
Message-Id: <20210126125621.3846735-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210126125621.3846735-1-hsiangkao@redhat.com>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
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
index 62600d78bbf1..a2a407039227 100644
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

