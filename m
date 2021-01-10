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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F1DC433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E0F122AAA
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbhAJDbF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 22:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbhAJDbF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 22:31:05 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207FDC0617A9
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 19:30:01 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id z21so10317547pgj.4
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 19:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z+k0Pox3xLg6g4VRM1QJf7emz8PSzx7P6FqqWv5XY+g=;
        b=ltVUgkB6S/b1wQjf/4qyTnNJon4ps5RGvHGJZ76rXfwh0jFTIGQenNXUA6bpcE3p8/
         esWKiq9Szl5NtPWJKOTnN04xr8SsOwTA+TJl/BVOIZxabvdW4BaHyO9c3Os+yib8yp5r
         1oEI/LG9Ooez+WdDk1thxt9CFwG0KJRCuQH8RvR8Iz3HEAgdXWTiJ2TOugHVIAAFn6jg
         SMfDYajgI2mTyG2pmVXfF1fRJag2qORv6TRTpS6nGyDI/HWM9K/u41HX0gcgJi5H+bPO
         GJT3IoKQvQvZrDFF3EOgThhNaiI1EDwkf2QzhHHnrhRIta0xmVTXCc+kXnx94WzZ7hq5
         OpIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z+k0Pox3xLg6g4VRM1QJf7emz8PSzx7P6FqqWv5XY+g=;
        b=Q3GJ23oRvv+qNtvJPSsprjYY06ifcm7v/72x72OCV89M3+q6Q8QYsCNJ8bIOuUuoR5
         Eh7x8BYb6bHJ5ZTw6xMYU447reI1IwsTYG99A2ln9N/7awRsvvNrtHLFyqBpnDPtOXbC
         5bGQmO114IUdFmV4gSR2IeRqHhUxOzukG4H2OzZBnVNzEPlhlm89VY7Ttfet7ZXrfZ3w
         lC5RRhde0MB3Dt5ii/fEDGXaYsMXiyzm6FdMUDEpwFFXnC+roBLI36VitmW1o9qSg2OM
         fwgCrlwzoMV9mpYYqshv8O99bJR3egTYJJjzVGMSCuAwFuT2xpE0cU5q+p6P4+AMO+zL
         7wQw==
X-Gm-Message-State: AOAM530ou3XydyS1q74qxu1/0gd0X3FyA9B4XGvaZwn/SbOvcxNgU8lt
        DLy0f9R+CUKcfhW5DmB4Ifw+66/y5eebOA==
X-Google-Smtp-Source: ABdhPJzQPWJ9M4YKH6ybFKF8HeoU4jxRAis3mDkVaSevFaASXbqE/RgArwMKKt9x6gSk/D6BCw48Dg==
X-Received: by 2002:aa7:95a4:0:b029:19e:abd2:4a88 with SMTP id a4-20020aa795a40000b029019eabd24a88mr14202805pfk.2.1610249400560;
        Sat, 09 Jan 2021 19:30:00 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id x6sm14079861pfq.57.2021.01.09.19.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 19:30:00 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V13 08/16] xfs: Check for extent overflow when writing to unwritten extent
Date:   Sun, 10 Jan 2021 08:59:20 +0530
Message-Id: <20210110032928.3120861-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110032928.3120861-1-chandanrlinux@gmail.com>
References: <20210110032928.3120861-1-chandanrlinux@gmail.com>
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

