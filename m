Return-Path: <SRS0=fxM9=DK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E294C4363D
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01B6E206F8
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:57:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tpsohEN0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgJCF5K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCF5K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Oct 2020 01:57:10 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6070CC0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 22:57:10 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id i3so2257844pjz.4
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 22:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+tJN9ELT8vGh3ju1QQP8XSdKwFEEVPot2c6hJZSbnYU=;
        b=tpsohEN0oHpuOCsDu4I5UoV67+sbgajTkQ+y07GZ+B9rKKc0XTflVlZPryNMJfcKAJ
         5Cc5hiIzJmisTc/zPWYar4ew/DGf5CPMCQoiPME4PuaPdVXPvbrHTo71qxzrTJzxkak5
         fK3iQTtCAJe85oQkQqX7tNtUK8ZHs4qYDA1RqG58nHaDlMk2VuJDmy0fUG93VpzjugEJ
         o9MsDl7EedsXDbzWPn+YKPnkPzIfzZcmF4uhGhKL+jdSzKygVmttBjbKz383dxsJY+5z
         UUTzyOC5azyQzEV7aGmDq2b9DhyOmhAB2XPJgBsiW5zNhTS/+WbVtMKFxxMM2VNpoaTp
         Dw2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+tJN9ELT8vGh3ju1QQP8XSdKwFEEVPot2c6hJZSbnYU=;
        b=J21qJaK5cH84w+o6PN5e7hwxeaOmy3kWhLIv/Ce4zp5Lu2I9tXIjDM4IQCKBQIhkN3
         XBIA0E3O5+4bvGLR0meMlhpO5Mab/LoRyZbu2QcIXCXW/eKR94MJ9mwcrUoRvR8cHZv2
         fbywdCvLrTe9BQ2obxUs5WkOVDa0uwCC3zAWG436mdEeBC8Hi+3U5emObXcrQYrerdqe
         0HTCaO5ii7KmG8Lg8u2g7rulmM24tHSQnnwt/yi4nGas8ly76kEC452cs7BFeS/TPvOe
         ugOxju1F8/gnY5pbJmHYnOuJx6F7AzYh1uUbsSKuv2GWpvLCsvuk9/BH65WR/1Is8Znu
         5oFg==
X-Gm-Message-State: AOAM533KCfLYLU36s3YRu5jM+WWK1qvXA69idFk4s8Yl00NdWwKYduKe
        pzPHJPf2PyddCocGMZPaFl6/novjkni0uQ==
X-Google-Smtp-Source: ABdhPJysOrmmzMhxiEKRuqr7WV5Y0sNugGgyCapWqWx8ZX+bBZNaXsWEi8HbekqGtQYYLuM3pzGBFw==
X-Received: by 2002:a17:90b:4204:: with SMTP id iw4mr6302258pjb.175.1601704629581;
        Fri, 02 Oct 2020 22:57:09 -0700 (PDT)
Received: from localhost.localdomain ([122.171.168.96])
        by smtp.gmail.com with ESMTPSA id 125sm4106664pff.59.2020.10.02.22.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 22:57:09 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V5 10/12] xfs: Introduce error injection to reduce maximum inode fork extent count
Date:   Sat,  3 Oct 2020 11:26:31 +0530
Message-Id: <20201003055633.9379-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201003055633.9379-1-chandanrlinux@gmail.com>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag which enables
userspace programs to test "Inode fork extent count overflow detection"
by reducing maximum possible inode fork extent count to 10.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_errortag.h   | 4 +++-
 fs/xfs/libxfs/xfs_inode_fork.c | 4 ++++
 fs/xfs/xfs_error.c             | 3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)

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
index 8d48716547e5..e080d7e07643 100644
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
+		max_exts = 10;
+
 	nr_exts = ifp->if_nextents + nr_to_add;
 	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
 		return -EFBIG;
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
 
-- 
2.28.0

