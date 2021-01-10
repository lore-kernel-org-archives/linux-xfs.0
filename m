Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EB1C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FC7022A99
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbhAJDbL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 22:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbhAJDbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 22:31:10 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2F9C0617B1
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 19:30:10 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id r4so7713839pls.11
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 19:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hgR1oPCOzCW8TWEtHNzhJCtVP7q9OL+0geB2MdujRgQ=;
        b=A6jgBknJ2UbP8+6YzV+QP6DRrr494tsz+uDSZVd3zM1eCuimduB8+KIhH0RYc6f+B0
         QDQJkDK1Fl6tEYigY6Kw65aPxr7gACl45wx8Q30kag/fNAy/QVzt0Nk2XVFXUI8YHqzN
         AhFtj8KvAr7RLQl94W1JWFkw5LkUwDMPQc1mByFaFEGtQP4IlSRRYBRJdfowMH0AZNXI
         HIT9b4i8+hz43airM3U6LBXCd3cTEnxUpMtLNdOCU5/ydkjGR8CsP3jow+/g3PEiQLwU
         0qwyh5CBO3JV9dH0SobOp8B4NrPlDiRBE1CoXcD1GIKS2DkJuf7Cjmx/upeGJJTpHWRc
         rXIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hgR1oPCOzCW8TWEtHNzhJCtVP7q9OL+0geB2MdujRgQ=;
        b=FkuQ32oU6Z9S0a+IsEDtQZ+VBYaKTvnW97spSHnlgKtlNH5uh4brfn6y0oQXl8MM2z
         w3T293bvW09ivorBUnyxQHDRlGUpoWyUVBPVJgl9Qtt5ROqA4QyKURxJD4JArjkagFpv
         qslCopspuOLpVUbeK6LKkOcKLFyvmb+0oHnkf3wduO/Kg+SGuaAlKBKffJgS6G7QSHng
         TwypBF3vDeZv3r3/JEV03z1+fckvquK2BoYRuJgrLu2pJufyliZ08C2NfDxIynwwq/yJ
         WZudBT+AHKmUwO+epm7QvPzccs/H7L69YsyzgYL001vKJ7+/vKVWPPb753+aPqWhAzRs
         otTw==
X-Gm-Message-State: AOAM530WNKZ5ljgHTHY+52E5O0huHEDVWH3BW7qJCFgMaLP85m9xrrI9
        XmfcomDAJFDC5otFzVCcp5mUi/9ilcyP0g==
X-Google-Smtp-Source: ABdhPJzVeFHzKMNmTZd4AHLPCQHLBKEuK0bABQ09QAPtpfwHj1+xbMBtuRWzfhiYeYC5hBuOJ/DZdA==
X-Received: by 2002:a17:902:59dd:b029:db:cda3:39c0 with SMTP id d29-20020a17090259ddb02900dbcda339c0mr13970409plj.81.1610249410046;
        Sat, 09 Jan 2021 19:30:10 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id x6sm14079861pfq.57.2021.01.09.19.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 19:30:09 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V13 12/16] xfs: Introduce error injection to reduce maximum inode fork extent count
Date:   Sun, 10 Jan 2021 08:59:24 +0530
Message-Id: <20210110032928.3120861-13-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110032928.3120861-1-chandanrlinux@gmail.com>
References: <20210110032928.3120861-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag which enables
userspace programs to test "Inode fork extent count overflow detection"
by reducing maximum possible inode fork extent count to 10.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
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
2.29.2

