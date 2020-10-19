Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B8BC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF2BE22260
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q0vBTl+v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgJSGll (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 02:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgJSGll (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 02:41:41 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A031C061755
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:41 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d23so4483553pll.7
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=54hvVruCep9acEanme5+7TKVjKYTNPLwPjk5IJSQZBU=;
        b=q0vBTl+vkVsKp9MTgMn42QQ6tAy8VqkzjphBfa/9RS8ngV5skJLF0VixfiCTooJo4/
         fzLqVjerMVpe+2XVY3i57aG1HhjfAFvcuH4cfvkVHOpzNmp2rFuxKVrbsLSPc+binqSK
         ZRLKWBrSdEvLGxxgydvzqQbem7FPtf1m0fvs6W8F4kUtgx79tDuPvYov8tTBKxgoPmc+
         mHmbHUGtPA6timY//7TOTTo7ffm981u/elmhgkLtZl9ewXkaLQC4VPaiHkyYs8nkUgrt
         C4yMkBQCnc4UBwn9T+2XaJGLZSOveYHXKGGpVKww1oSLH4jMT30hFwq+MJ8KDj1JiOT+
         U1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=54hvVruCep9acEanme5+7TKVjKYTNPLwPjk5IJSQZBU=;
        b=SshHDx81Ku59DlFH4YJNrTHG3CGAYev5atMRNqoV2P39s6Kb7z2rfdRHtqJ8pkAEPM
         G7F1cHk92RfEvcT7PLI/DXs4piY28IAYY9rBQXAsmyPtNel8bVX1jUYP5woJUs4R1W9t
         Zg9kQtcegFjZi0BcbB7L/D+FFPmkv162NLTUc0XOhile18I4pWwztj0XA9kSM07l4WdO
         5dnmHcNdOFOvGqXxe6jI5g3nl2MedQbJRJ7zkuBpMdsxHxFUWE0ibmPYVdrhC7E/2OWh
         8QTC/beqY7izUa1BOQX0DHZ8yu39pJufldp2p9jofNSa2ItwaiV39CIlHQimHx2KAxVw
         c69g==
X-Gm-Message-State: AOAM532Fy72P/uPEScuVr0T/PQ1VRai2fn16pZAAxKrft+rzWqEb7pU0
        CF2w1il686WFV4h67vPO/I40qJ100tc=
X-Google-Smtp-Source: ABdhPJw1FiaWWD2J6TXLh7o6ljhu6GlzY0Add9viL8Yjs6fsZyioZ4KS107xNI8HpTL8uiYvDpq8vA==
X-Received: by 2002:a17:902:ee52:b029:d5:dd2d:df92 with SMTP id 18-20020a170902ee52b02900d5dd2ddf92mr6231597plo.37.1603089700326;
        Sun, 18 Oct 2020 23:41:40 -0700 (PDT)
Received: from localhost.localdomain ([122.179.121.224])
        by smtp.gmail.com with ESMTPSA id w74sm11164189pff.200.2020.10.18.23.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 23:41:39 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH V7 10/14] xfs: Introduce error injection to reduce maximum inode fork extent count
Date:   Mon, 19 Oct 2020 12:10:44 +0530
Message-Id: <20201019064048.6591-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019064048.6591-1-chandanrlinux@gmail.com>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
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

