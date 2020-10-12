Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66AF1C433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 09:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04726208B6
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 09:30:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OQhAEUL5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgJLJaV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 05:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbgJLJaV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 05:30:21 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D2DC0613CE
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:21 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g29so13705062pgl.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=syOqEuploIW5wOLjFtUhHHVglk6+YbYMa9cQ0Bzwmu0=;
        b=OQhAEUL5JRLlULBSMLkbwsHOWHglJlMKxPErykm41wIZpB7RdufAZ0uGVdn+k84Ama
         42dn3WREM5zZJzgPeyEwxt77mqvpcG/UxjAc8Jp42StOeHjhCXpthedc3NnDb36I9mCE
         koPDJIgL81O9TRTX5PqVSQcTCXvPpNGTFNXHWFHKwnR30dqVGjOXyvuqcH7aR8l9Dg69
         bNTGWk1fBl/MnC+eeg662qT94B3t5SFFmCINEWudu5WQG+yXcadZ8jG+BbgWIWl9/k3G
         rUDV6RDgxaUBKIBc9NAjUjc4BYhF6q9Sv+oAfUX/mLsvO6SSt4FngBjzRJN6AA/cD3hV
         +ymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=syOqEuploIW5wOLjFtUhHHVglk6+YbYMa9cQ0Bzwmu0=;
        b=iBKF8jT8vsN6BUmM6v8xfX7VRjTHbC2L1UO3mPJWO+Sii8MKtGHtKBshyi/HYVV2J3
         vXRa5Nu/FKec0Di9ZQZHZ2XfsadNRv92jI9hKR0jLXSL+YlCvrch7H2/zp+XGg9o8KN6
         Ak1DTTJV3e7bF5v4TMQs+jz5iPciOZZaG8rsmWLpseXHFdIs4/tNd2YnAoKBvrHWsZPH
         /XubMOkt9HwteZbnIisjQHUM3g+diFrmoqHWxBdyBaDkef5o7SDxfalaUSL5dew2A1j0
         mEEXMm7FJ1vLklssOkrsLzGzskio2KdwH86GvRMtWHbgLOoJVoy/rhNnijtW/96/0znI
         /Ymw==
X-Gm-Message-State: AOAM531oNv2ehPSPY2hdSJ0PQtdBpbd98kgaVCkxZr1zblCZ2XBa8cyh
        rJnvw6xHnYI/mUqMGNZ1wAI92CtiFdw=
X-Google-Smtp-Source: ABdhPJwJj1/AVzagyf8iDv3fYFCSg87KpP1H+ifQuTUQgvIVQzS7hJJk21x4RMNLCJ+LiOKagZEVIQ==
X-Received: by 2002:a17:90b:4398:: with SMTP id in24mr18171527pjb.236.1602495020613;
        Mon, 12 Oct 2020 02:30:20 -0700 (PDT)
Received: from localhost.localdomain ([122.172.180.109])
        by smtp.gmail.com with ESMTPSA id z142sm19451985pfc.179.2020.10.12.02.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 02:30:20 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V6 06/11] xfs: Check for extent overflow when writing to unwritten extent
Date:   Mon, 12 Oct 2020 14:59:33 +0530
Message-Id: <20201012092938.50946-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012092938.50946-1-chandanrlinux@gmail.com>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A write to a sub-interval of an existing unwritten extent causes
the original extent to be split into 3 extents
i.e. | Unwritten | Real | Unwritten |
Hence extent count can increase by 2.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 8 ++++++++
 fs/xfs/xfs_iomap.c             | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index fd93fdc67ee4..afb647e1e3fa 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -70,6 +70,14 @@ struct xfs_ifork {
 #define XFS_IEXT_DIR_MANIP_CNT(mp) \
 	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
 
+/*
+ * A write to a sub-interval of an existing unwritten extent causes the original
+ * extent to be split into 3 extents
+ * i.e. | Unwritten | Real | Unwritten |
+ * Hence extent count can increase by 2.
+ */
+#define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index a302a96823b8..2aa788379611 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -566,6 +566,11 @@ xfs_iomap_write_unwritten(
 		if (error)
 			goto error_on_bmapi_transaction;
 
+		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+				XFS_IEXT_WRITE_UNWRITTEN_CNT);
+		if (error)
+			goto error_on_bmapi_transaction;
+
 		/*
 		 * Modify the unwritten extent state of the buffer.
 		 */
-- 
2.28.0

