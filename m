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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B6DC4363D
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DA5F2072E
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:57:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qXya0zxu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgJCF5B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCF5B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Oct 2020 01:57:01 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEBEC0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 22:57:00 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id u3so2261528pjr.3
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 22:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=syOqEuploIW5wOLjFtUhHHVglk6+YbYMa9cQ0Bzwmu0=;
        b=qXya0zxu5tpJK2h8gsQZKs00ilESCtgL6aITUgVnJ9xFobTNdzoL64HAkvnqY3vqw1
         4oyT9MHCfpjTGRtM3eI14NRtrDkTJxgrWqeL4Jn6BNEg6ZJpnoLnX+/FKfOKqtdNXKXm
         pV3vUpZ5Gwf+rbsg8/02W/nQzKOZs1O9Px+Q3aIjN5k0k8g5x+8StX+4W10ytx6PzL/P
         H9Jwwj2aDa7Y2+ZK5PLLBxYIjl+W0sKghEvSP1dyY86IqqhA/Yn7vyJm4jsDqdo/cor2
         DDEWJGNtX/qntodVE/WKhT/cSboapssVup3xse8wTVkHoEyd39ObYUPu5BHWhMg2Xu/+
         QPdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=syOqEuploIW5wOLjFtUhHHVglk6+YbYMa9cQ0Bzwmu0=;
        b=le1lNJHTRMgmQFi+Blbcueajbn5ACAQHpYuYlGSF9yk+8y1KauYzfA8N0r+3PgS92r
         yiBVFMjfQQA0OJ1CJrG22yCW7W8AWr2nDOYXSjn457DXhTexVWufpZVwXA5coKSrLrFY
         G6EM6eWugiUf1LI4C2pEph7Z/GQ1tQNj9Wt/Zs8ZRG20un0K831Rw+kOfB9g0v0xKCRt
         FWtyQP4Coiz930h3m4igWG3nuzWLDzosVzZtXR1tpAf2eDEr+0tEth1c2xwJRZmNJqEm
         ws1hdgYdCt7VBskxMjbbkSYhgonjFQAirxWIu9FrkIHMnB25X507CSdtWcFwaoqYm9TS
         kZ4g==
X-Gm-Message-State: AOAM530UNYlHEO1EGvDL5D4XQjeu45QH3ci4Hk4NNemeqSiR7dif1jHY
        JQ8CcrTqAiuolsSjfBZpweYym8XkakWcqg==
X-Google-Smtp-Source: ABdhPJwbM7bUqez4OJdUF+rXXPpHauZm3Gx+1/tim8KgTPUjIFJOYW51LlLpiny2kvyr7np8MKtV0g==
X-Received: by 2002:a17:90a:6a4e:: with SMTP id d14mr5995398pjm.63.1601704620088;
        Fri, 02 Oct 2020 22:57:00 -0700 (PDT)
Received: from localhost.localdomain ([122.171.168.96])
        by smtp.gmail.com with ESMTPSA id 125sm4106664pff.59.2020.10.02.22.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 22:56:59 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V5 06/12] xfs: Check for extent overflow when writing to unwritten extent
Date:   Sat,  3 Oct 2020 11:26:27 +0530
Message-Id: <20201003055633.9379-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201003055633.9379-1-chandanrlinux@gmail.com>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
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

