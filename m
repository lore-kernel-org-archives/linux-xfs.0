Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227ACC8300B
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD018206A5
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rGI669Bg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732795AbgKQNpF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732589AbgKQNpE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 08:45:04 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA936C0613CF
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:04 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id b12so502183pjl.0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XvpLSvlcyBaKGUc+FLHnNx0Ewse7iXgrENCBElNIo4Y=;
        b=rGI669BgmHynESPTUV0fAkNTi+dsyJ7dh31dKP5nEN3zW5NEsy0uNknwdXxfRjUYAV
         YJyL7BiJmQtxxtuTFehNsB/7oj8gWUNBtRq29/acLc8m/7gyAQ9JrKd64xi6r4QK4Bei
         IYoHLs5FQFgU+bP1/0yHPoy2CfBbtHSSMHsKUR1LfPAmbZkGy17C9f07jsXHDvi+9XFZ
         g/PLOnhOOkvUYyYPT4D2K3R8aiGSZNEsZjRHznQZ0hHr64XpFpJjDVUhyONa9zxv6NU0
         wOAvq7CNJZuzR5WfDlfpPXT4gNj70L8DR1ku09OKgVtIontFZiEa64KT8zNc7Q/QnyPu
         25Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XvpLSvlcyBaKGUc+FLHnNx0Ewse7iXgrENCBElNIo4Y=;
        b=WFionHzvptARzhkfwuBONV40bAHaMoychqBGIDNu5Io5XmgRpJ0xdIzG4zQzeXJOqg
         Pq2k/ns5Qy6T2Xvj8WCAmYvUJ+xsZ5ZOTzRezZsn/kYeCm/Rg6BPuWSqLYDbYX1d0/P+
         2QUCbrZ6SRhnFEa/aPJat9c+Wp7dwBwJY/01ys6ONEm3pl+6xq8lO2hifCPTPyxHBXUm
         SKsNUec7vyPjh7cVPGNrNNo9qab4UWQ7Ykie2daVvePJRwi2NBaKJFgj7RSFLxrYdP9Q
         p3jbm3zSYAptTbJkHl2iC0FMQrjvKuia6+AXCUxNhvWCmWyQpTcHM9I++ijUeMYxDrmt
         HqxQ==
X-Gm-Message-State: AOAM531nrP87UMqjao5p+kVYVC/lFZo52vsI02oVHaxPtJ0Qgk4Ww+XB
        gPRnzEA1j6feQRkD8CRJNW6jbgWPWpU=
X-Google-Smtp-Source: ABdhPJwzfVgHwKdRauU+P0sNmWWHVPn//fauyBahSNH6j71cWJIpgRRYi9VZWZigzZhX3cQjcuZOkw==
X-Received: by 2002:a17:90a:4d47:: with SMTP id l7mr4636461pjh.121.1605620703999;
        Tue, 17 Nov 2020 05:45:03 -0800 (PST)
Received: from localhost.localdomain ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id y3sm3669399pjb.18.2020.11.17.05.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 05:45:03 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        Christoph Hellwig <hch@lst.de>,
        Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH V11 06/14] xfs: Check for extent overflow when writing to unwritten extent
Date:   Tue, 17 Nov 2020 19:14:08 +0530
Message-Id: <20201117134416.207945-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117134416.207945-1-chandanrlinux@gmail.com>
References: <20201117134416.207945-1-chandanrlinux@gmail.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
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

