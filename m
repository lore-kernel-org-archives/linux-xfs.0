Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681F6C5DF9D
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FEE22242E
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:07:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tIey9QqO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgKCPHj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 10:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbgKCPHQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 10:07:16 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0122C0613D1
        for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2020 07:07:15 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 133so14426652pfx.11
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2020 07:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ILp5iM7cQcNHUrkAX0Lz/6PweGyzSkbIPzR9qhi/Ue0=;
        b=tIey9QqODpXKQrzeZNmJU7AvQWknbFjvIIIhBWJnWIvp33i/WKXnJkJtUIv9AAhv9y
         tXUJtDVh0vTbU1O3YgnK0Ywcf4FI78Kq2dCzbA5kIf+m/a0I9tAdWC979KT4ayS14LU1
         TbeA1bQN/TtsdJqlwGoyT9SAOiuAhg79mQrSIqtN0oWHMtMpe7J1ooPge3ftOOaqsU8S
         DTa1tHLhGBKU2DEn+Tx8z+uuIb6YabnARu0D5PgG3tLpOPhcIPJhQ/7B8LFPu6Qz5mn2
         +BUAoCoRn535Js2PYR94DMAB9k0tW2d0Oyko4VXZ+7L+j1MD7Ohquc4E04RP7uWDp09Q
         +W9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ILp5iM7cQcNHUrkAX0Lz/6PweGyzSkbIPzR9qhi/Ue0=;
        b=MsOUoG9fi/24u9Bx/0NWGgtbh1YGHA/Z3dhqOEfkPonXqWbK955Y5IG1lcWzOrkLbu
         UmqjFrD6ecZHeKpEKK8X/3Pu1BLyPZLsTOXFEaBTIcCLpgE+/LUaXH2BAAKVv0yLm9f2
         UHnKHmTfDyBpUChBfX3cSm0s/dREnr45twulztoJaephwKpx+MIoRVVcEP7qP+iOhnSR
         kZQ8PMzASLycgc8OyzyeEgAjwQGHfatIq0y4YYquu5PcWehhdjNVBf0uw3nn8M1yGqaZ
         UFkyd5edMNcC2jgku4P+1ezqlOm1/qawPxVMfFhRValnTEhnFOSVhgr4GMmLZCW/REFU
         BVqg==
X-Gm-Message-State: AOAM5311XwSYQjN7ZSqxR0GW2uLJC0enzaw0AKOdsUDez8lrqmQ+Q61f
        fdkhI8Ry5mDNTlWugyhKjSzkDh+/zNu9oA==
X-Google-Smtp-Source: ABdhPJyh+XKjzjCARwnJDbvwV6DgZlD3iGLXe2A2qBTdr99G7S64tY8vEuAy+BnTJAAUMSUuGV3KLQ==
X-Received: by 2002:aa7:9afc:0:b029:152:9d45:6723 with SMTP id y28-20020aa79afc0000b02901529d456723mr25412417pfp.35.1604416035260;
        Tue, 03 Nov 2020 07:07:15 -0800 (PST)
Received: from localhost.localdomain ([122.179.48.228])
        by smtp.gmail.com with ESMTPSA id 15sm15936955pgs.52.2020.11.03.07.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 07:07:14 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V10 07/14] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Tue,  3 Nov 2020 20:36:35 +0530
Message-Id: <20201103150642.2032284-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103150642.2032284-1-chandanrlinux@gmail.com>
References: <20201103150642.2032284-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Moving an extent to data fork can cause a sub-interval of an existing
extent to be unmapped. This will increase extent count by 1. Mapping in
the new extent can increase the extent count by 1 again i.e.
 | Old extent | New extent | Old extent |
Hence number of extents increases by 2.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 9 +++++++++
 fs/xfs/xfs_reflink.c           | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index afb647e1e3fa..b99e67e7b59b 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -78,6 +78,15 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
 
+/*
+ * Moving an extent to data fork can cause a sub-interval of an existing extent
+ * to be unmapped. This will increase extent count by 1. Mapping in the new
+ * extent can increase the extent count by 1 again i.e.
+ * | Old extent | New extent | Old extent |
+ * Hence number of extents increases by 2.
+ */
+#define XFS_IEXT_REFLINK_END_COW_CNT	(2)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 16098dc42add..4f0198f636ad 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -628,6 +628,11 @@ xfs_reflink_end_cow_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_REFLINK_END_COW_CNT);
+	if (error)
+		goto out_cancel;
+
 	/*
 	 * In case of racing, overlapping AIO writes no COW extents might be
 	 * left by the time I/O completes for the loser of the race.  In that
-- 
2.28.0

