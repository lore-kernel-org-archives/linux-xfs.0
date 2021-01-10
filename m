Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE03C433E9
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51552229C7
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbhAJQLA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Jan 2021 11:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbhAJQK7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jan 2021 11:10:59 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D86BC0617A7
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:09:55 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id be12so8214136plb.4
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z+k0Pox3xLg6g4VRM1QJf7emz8PSzx7P6FqqWv5XY+g=;
        b=B+/cuhaAzj8xpCL27K6baBQeWUm/b46hgi+nG8j4nTFInWUBQSs5ZqsrAy+yQCL0BF
         bPZuyCxK8x7aLvd9XuUTPrO7JctVTaQCGTGBXBVZYZcse0gclc78xrfh8TOmCOgrGA6k
         2n1lKmrran2Gx478iAu1P01R3zlWJrVB6jaPO0geCLIGMYke39x5ofxO2YSWvUCj1JcQ
         CRLR2h7Jf/zF9muQuRLpRbT2skCrYwb4sI1y6ERhelP8/UiYQzYkNS9V5HveUHT4eX7f
         beaC2w27XhT85R5prXu3SrrmxEC7uH4yDxM6MWOhSVKp4mNUWGGYxMhWiY58lM0mHe6x
         B2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z+k0Pox3xLg6g4VRM1QJf7emz8PSzx7P6FqqWv5XY+g=;
        b=g4GouV1Ay2htUoFcpcSdEzw0dzV4qpH1uESHASsP+xkjlQGK7cEvTu6DlnYFblJR4r
         Uj2poTe+XHnWma12JdVQE/JgIZ812blldaCcXQTGdlE99Fko4AFcxDuPpGXRpUbVjgPI
         nNgl+2Yufp0q5Vbg9x5A9h56d2IsuG6fr2ZmnG6t6Sud1m4zJZtjvXU85VQ4miPdS/D9
         2+g4AAxHQidl8n/vAoURySSOHsF2s32JyYdY23ZIVNDLtXNnR88v+vr99o5WatOnMK29
         B5Vn/isS3862ttsC2zFbww5VlHuqTERTTG8fhRLbbH2IwupiK+bQUBuyiHa3u62HO2A1
         Ymag==
X-Gm-Message-State: AOAM531tIhG4OZScyG2n9P+11OIhc3+mrNy+xxD97r/5mk9MOZLMRBVN
        0aPWW4/I/LCsqKRcDMIwD/VwU6o91cE=
X-Google-Smtp-Source: ABdhPJx0BuZrDFH2Dz21Ctz7VAVa7zNbinj6BNRJSxfZ23/XGHr01nqwVTx06ndsc9RQzd28SNAtUw==
X-Received: by 2002:a17:902:ac90:b029:da:fd0c:53ba with SMTP id h16-20020a170902ac90b02900dafd0c53bamr12795841plr.23.1610294994829;
        Sun, 10 Jan 2021 08:09:54 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id d6sm15525896pfo.199.2021.01.10.08.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 08:09:54 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V14 08/16] xfs: Check for extent overflow when writing to unwritten extent
Date:   Sun, 10 Jan 2021 21:37:12 +0530
Message-Id: <20210110160720.3922965-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110160720.3922965-1-chandanrlinux@gmail.com>
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
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
 fs/xfs/libxfs/xfs_inode_fork.h | 9 +++++++++
 fs/xfs/xfs_iomap.c             | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 8d89838e23f8..917e289ad962 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -70,6 +70,15 @@ struct xfs_ifork {
 #define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
 	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
 
+/*
+ * A write to a sub-interval of an existing unwritten extent causes the original
+ * extent to be split into 3 extents
+ * i.e. | Unwritten | Real | Unwritten |
+ * Hence extent count can increase by 2.
+ */
+#define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
+
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f53690febb22..5bf84622421d 100644
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
2.29.2

