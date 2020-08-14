Return-Path: <SRS0=kyg5=BY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3A4C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB5E72068E
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:10:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LAMheQXH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgHNIKF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 04:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgHNIKF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Aug 2020 04:10:05 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E16FC061383
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:10:05 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ep8so4029990pjb.3
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9NQNiEsE2oSpO8KD806KMNjp9qpAmlHnF7jbyd7kmx0=;
        b=LAMheQXHQh42fmWBBoEYHcKfKesNLobvsM6kj5U2cjlUvLwM5TpolbH+O04HqfKnPB
         J9v7MFZRGOPC1asl2XOx+zACe2g3KRc133KrNF9I9OlEnRInZpXEznEM3Uc49C8HqLY7
         ASArVxsOiniqAHKgB1fBdUHuly+1k/68X3SerX7oONkwAKa8L7oVv1M3zUcVHArVJBg2
         LgD3XNymI03Yg34dZPz4TGU6KB4D4AFQuquRnPVB+zFklOLJ7UhySJ7oz+gvgujUQMWz
         gN7KgzBUAIdnxopS9cJL7A3AEW357V2GYVyc0yLMqRnAxO4K8y83hXZKf11XxDb0jjEa
         hxyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9NQNiEsE2oSpO8KD806KMNjp9qpAmlHnF7jbyd7kmx0=;
        b=cZcrW8nZy3RhWuhSWKfa4t/KM1tJK1Kv4FHgTkTx1d6Yip2jLlunvwOmW5/mmp4tPn
         LhYcNNTwxeImdd1TuaBdrj1k5aOk8nMguYMxGvs3J4AgRh10+8+gz1/9LZYn86qIkowo
         Fo25q/IJI7e+pDvXcghqSd+byHcl+nrzi95d80hhxVCOYvTmbqPYx2iUtL4MmwjZ9uYg
         YAQnH05UvaC8ecgYkyNiiVBy893BJk5u5xoXhrfq02nYkjGJi+pfk1S5JzA2JtKGS/FB
         k/dgoH4hr4xitHZ7ODT2b+VOvejEKWoCM39bQxanth1m6/A1mUR6ACXWUxYiEj0Kebx7
         7njQ==
X-Gm-Message-State: AOAM53196UOOr2iYSxzOr3f4VEOZEZoqmBcKXPr+ltuESDHM8hsjaHAQ
        fBBLzsH77E+Kg28hYXoRL66ldR2Ps8E=
X-Google-Smtp-Source: ABdhPJyz6+ybJ0oGzLVL29I8eBUmmDfgn0m7IDHN+1Ec6vS41qfsbMRhmlyvFoQ6Ex2mol6Qz9aUyQ==
X-Received: by 2002:a17:90a:d78e:: with SMTP id z14mr1232014pju.133.1597392602591;
        Fri, 14 Aug 2020 01:10:02 -0700 (PDT)
Received: from localhost.localdomain ([122.179.47.119])
        by smtp.gmail.com with ESMTPSA id z17sm8594289pfq.38.2020.08.14.01.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 01:10:02 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V2 10/10] xfs: Check for extent overflow when swapping extents
Date:   Fri, 14 Aug 2020 13:38:33 +0530
Message-Id: <20200814080833.84760-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200814080833.84760-1-chandanrlinux@gmail.com>
References: <20200814080833.84760-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Removing an initial range of source/donor file's extent and adding a new
extent (from donor/source file) in its place will cause extent count to
increase by 1.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h |  6 ++++++
 fs/xfs/xfs_bmap_util.c         | 11 +++++++++++
 2 files changed, 17 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index afff20703270..82b26536f218 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -98,6 +98,12 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
 	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
+/*
+ * Removing an initial range of source/donor file's extent and
+ * adding a new extent (from donor/source file) in its place
+ * will cause extent count to increase by 1.
+ */
+#define XFS_IEXT_SWAP_RMAP_CNT 1
 
 
 /*
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f6352b5e5552..8159306a8c41 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1375,6 +1375,17 @@ xfs_swap_extent_rmap(
 		/* Unmap the old blocks in the source file. */
 		while (tirec.br_blockcount) {
 			ASSERT(tp->t_firstblock == NULLFSBLOCK);
+
+			error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+					XFS_IEXT_SWAP_RMAP_CNT);
+			if (error)
+				goto out;
+
+			error = xfs_iext_count_may_overflow(tip, XFS_DATA_FORK,
+					XFS_IEXT_SWAP_RMAP_CNT);
+			if (error)
+				goto out;
+
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
 
 			/* Read extent from the source file */
-- 
2.28.0

