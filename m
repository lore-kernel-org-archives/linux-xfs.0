Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A87C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 390FD20790
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mt1V+pA3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgJ2KOo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgJ2KOo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 06:14:44 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2390DC0613D2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:43 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id z24so1952645pgk.3
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XvpLSvlcyBaKGUc+FLHnNx0Ewse7iXgrENCBElNIo4Y=;
        b=Mt1V+pA3PtRsgxQ3EaAAuAjUx0YLl3TCz/0DlcdqZ7C71sZ3MZfvAaf7hDOMXSNAeP
         xYys8WfQuVRtnZlQ6t99xzG6N0vC49get7LAXEVb+qaK/A8st4gwA1zvlqgESwQ81Yiv
         bPhULYqLMHJfu/4tS59kSBy715l6cwkskaWet1dvQxGgCswTBNm/KgYWPGzOSkNwD7JZ
         94w3Xk/WpLqNOXOSJFa76Yk469nW+XDLHKdWi5Z/9SdaILZ3YtvbX9+iezGXUZE3whRm
         l7DHvAnaQckaoL6Eo7rmQl/W+fpwQQoCLxu+UC1nIcN+/ZjcdFlnen1CYmwK8jN/mS6H
         5EqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XvpLSvlcyBaKGUc+FLHnNx0Ewse7iXgrENCBElNIo4Y=;
        b=Ce62VuyQkxWYDkJpivqBObkqLtRBQ/o0m69C0g3dlWHqI+2R/ur8VCNS+0Hn62n4fW
         J0SRpI14w9XlSlEyuQZziiWK9r2YGTsEZm4NCh0IzSL1CWBLuFb/aHOn5OCSJOcVu7ZK
         FHsx/9/IPJykv7zA/nYgM0cVGIfaz5m/de4PeX2mriQQaRDB70cN9TSKlS3MnPwxz0DU
         g3DnvDhgbvf3FGmZef6Ei+qJfp9MV3CPWmCq8TblTad0yViUkyF1ae+Nyzg+ga1apu8t
         QCAt/AK0CyWoH0WijcgKbv2tZVHuNzNJCDeBkanrv9XwzEjiKmQsTzq3+a+kHGBjWZhe
         4bYg==
X-Gm-Message-State: AOAM532u5FltWf6YWo5Z1Twr+El2uPN5rLaJ/+pfk8eDNRR3+2DRdsjI
        ZT/gd0QwvCbEgcuNT6BkngemUHMuIwU=
X-Google-Smtp-Source: ABdhPJzjy0/LBmXYJ8700ufjQqWKC09TbE7tkfq9+FKR7SxfS26wWSbWYaNERDhSC0h+RaO3wZKgfA==
X-Received: by 2002:a05:6a00:2d5:b029:152:197a:a23a with SMTP id b21-20020a056a0002d5b0290152197aa23amr3478979pft.66.1603966482399;
        Thu, 29 Oct 2020 03:14:42 -0700 (PDT)
Received: from localhost.localdomain ([122.179.67.57])
        by smtp.gmail.com with ESMTPSA id s9sm2488073pfh.67.2020.10.29.03.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:14:41 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V8 06/14] xfs: Check for extent overflow when writing to unwritten extent
Date:   Thu, 29 Oct 2020 15:43:40 +0530
Message-Id: <20201029101348.4442-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029101348.4442-1-chandanrlinux@gmail.com>
References: <20201029101348.4442-1-chandanrlinux@gmail.com>
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

