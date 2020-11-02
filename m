Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C929DC00A89
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AB79222E8
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vu9Yybv2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgKBJvc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 04:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgKBJvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 04:51:31 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F13C0617A6
        for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2020 01:51:30 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id g12so10325523pgm.8
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 01:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/T4H2MiD0QBM8tig6ImJk3HvLU2caAc+kKCOLA74nf0=;
        b=Vu9Yybv2Egw80PdVTaFqaIKMn98C28jJfz5bqNeC4s91/RGEa6FsH3ofC60Eg+qG6Y
         3orKR1W/MPyfY8znK30/M9ANd4r7kJUBxao4TtxaNEIadUqWbz9x2bHdeXH7Foqw7Axs
         hJkIisSl9kIQ4yxm5ijGyDu7SKSUzahZ65j2nywdozrcnrd8bwaHmFCP8cdwh3q/pb0Q
         w8nUiVlnXrKcqqV65JWbnnkHQ4/ey0yTGfUa4Q9bRgnV/cCyBUO0gsTrbr0KwQz2xYRo
         aMmHr4Nw3fQBXznR+aW0GyU86tFY3xJ5y7hpAm4WaJ2ty/Jm3phfQqUi79UHObLljsVu
         8hNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/T4H2MiD0QBM8tig6ImJk3HvLU2caAc+kKCOLA74nf0=;
        b=RYXA6Ir2JQTstbaS8vsA4cgx5S0Hgv2J5M0xNgk4saRa+8yAZlCt0OHWlNADsn7h7e
         H2TTyvZXwDcEpkXDIGrTAuc946LPgTYRA0GPFSgUg704SBd6Wdf8ucieDYoDFJRrJbZk
         mPGWpaquz4Goa3J1QLYDEw3uhOGgADGQ6zmKOibMHb/nN5aOzQ9kiu7QNqLm8nHaZnaR
         uNRiFddTswT0/8X8E8qHEAJwj44G6C5eBiRt4Lu/nIo2atUbGRYGrzYCEPQgdTlajFRj
         +dIDYIrwozqbO+LXcoBpv6Ullu2AStWB0BfuyLARV+OUc3K237GHsUie2wZ1oyoPzhGg
         v5mg==
X-Gm-Message-State: AOAM530wmsNtvBPj7cBwkWIrzpglnq+xeUw6lYbSB92eLQ7uH1BwEieN
        vFYNBl/DXNo9cASpRqOsiokL29cUNbI=
X-Google-Smtp-Source: ABdhPJwrYelhbwVRvT3irO/pkw+74YLM02rLUwaWn/P68AfHYlToGoDH8lxQdWdxrkFAxWGRsrpZlQ==
X-Received: by 2002:a63:5819:: with SMTP id m25mr12155287pgb.398.1604310689696;
        Mon, 02 Nov 2020 01:51:29 -0800 (PST)
Received: from localhost.localdomain ([122.179.32.56])
        by smtp.gmail.com with ESMTPSA id x15sm467062pjh.21.2020.11.02.01.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 01:51:29 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V9 10/14] xfs: Introduce error injection to reduce maximum inode fork extent count
Date:   Mon,  2 Nov 2020 15:20:44 +0530
Message-Id: <20201102095048.100956-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102095048.100956-1-chandanrlinux@gmail.com>
References: <20201102095048.100956-1-chandanrlinux@gmail.com>
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
2.28.0

