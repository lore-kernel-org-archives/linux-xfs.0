Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6515C64E75
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 689812467A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HEOgu4E5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733210AbgKQNpT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733022AbgKQNpP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 08:45:15 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28FCC0613CF
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:14 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id m9so6503619pgb.4
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1+73tUpCP28xwGN/QBPz9W2Stq7CFunwSFbP10k5M0o=;
        b=HEOgu4E5GZaNV1L+suqo8TuDbP1Xso7SdYAfVs5WeqiL5rcdmuWGU1Pi+VPCcvr7Ra
         SGW90XyqB0wRvI4ovUtTgij+9zAKfvm+kd0Yhn4c8wGpzQAqOIokC13Ee9d8qjxgAqCZ
         SKja+kX2wXpVmSCUjobi/GwpN9T7/CprehBnHqiie6JsHeRlOaJOx3VsNV/lSqeop2j5
         Kw/3e4KQ9ALSYHGkOMLePLPyH9Yx18vNiDFysblYsy7vfb2AJAObsRjBZxvt7ou3mNa4
         FMuO2hC2uHND3DaXKvbPRjyBhKGqzPX9oIN4J9dOUOQJNdI6wzyZQakDGyByki3Otiu4
         TWzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1+73tUpCP28xwGN/QBPz9W2Stq7CFunwSFbP10k5M0o=;
        b=iHcO/Aa4WmwBaGzRW2Q+QOMhkF8/iryqZkgxki/mL1CafPgXhUgkV31tkEdsrw9Far
         FUJlOvZpIjZdTo+B6gRgNuDMiu9CxCMDI6UHz8Kj8vImXDsqhBr6aRGSw1tnHYlk8xN6
         w49LrRa6V8X2SdLky+oTzpdnJbmwvURIpyY5PN4ZTnLF/TpdAgA/WXx5MWhfLwNklZKD
         OP+9qXSa1LAZdHYcd8K71OMeFcQ3DTLKL1U6o08qvrKCVLkc3gLzOua2JpEe8TGEW7Bd
         9eIwsv/kRCYstf2cjG20ytIOc1eWtTz/5Utl8cbW6cDsvbTi0IY6vvNKfrK3j9IOnit+
         JUew==
X-Gm-Message-State: AOAM531ii+JKqkHeByhCg4XbpDBXnxsNfVfsMUgZsHzjyfHWR6uvBsYA
        hFg/afqyq3rECG0pb8rjJSIYLUcjjFE=
X-Google-Smtp-Source: ABdhPJyvnxH+uOsAYsodAb7m2r97TH0WsFCiR07QFmdaQqA7yXyTXQlnCPL6cn0hujjzOzJnNCYhdg==
X-Received: by 2002:a63:ff03:: with SMTP id k3mr3568294pgi.304.1605620714018;
        Tue, 17 Nov 2020 05:45:14 -0800 (PST)
Received: from localhost.localdomain ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id y3sm3669399pjb.18.2020.11.17.05.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 05:45:13 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com
Subject: [PATCH V11 10/14] xfs: Introduce error injection to reduce maximum inode fork extent count
Date:   Tue, 17 Nov 2020 19:14:12 +0530
Message-Id: <20201117134416.207945-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117134416.207945-1-chandanrlinux@gmail.com>
References: <20201117134416.207945-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag which enables
userspace programs to test "Inode fork extent count overflow detection"
by reducing maximum possible inode fork extent count to 35.

With block size of 4k, xattr (with local value) insert operation would
require in the worst case "XFS_DA_NODE_MAXDEPTH + 1" plus
"XFS_DA_NODE_MAXDEPTH + (64k / 4k)" (required for guaranteeing removal
of a maximum sized xattr) number of extents. This evaluates to ~28
extents. To allow for additions of two or more xattrs during extent
overflow testing, the pseudo max extent count is set to 35.

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
index 8d48716547e5..989b20977654 100644
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
+		max_exts = 35;
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

