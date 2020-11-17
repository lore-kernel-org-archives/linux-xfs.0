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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE69C63798
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C45B9206A5
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J3K6dKIC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733198AbgKQNpK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732494AbgKQNpH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 08:45:07 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6E4C0613CF
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:07 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id 35so6076469ple.12
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ILp5iM7cQcNHUrkAX0Lz/6PweGyzSkbIPzR9qhi/Ue0=;
        b=J3K6dKIC0iguqxWkDzjmmnqg2fcDts07PzNrwvamDhJ744Mzkt0lwRZtSIA/A502Xp
         1ROdDcwIE69z596zs/S7GIT2NJDwciuWrLdj46anKLRgSHH1BrHuSPQJwqD61MrKQB6r
         IFFm+fvugjCkNk5m+rU1SJ5sqjsutwnW0r9/C63QgI5NG9Yz5i8myg17k0wQa584ep+r
         nEKfW16qrE8QQcPQ9RV0kgUoKq0EGENM9DL++CjL2y5S6X8895mnlEWSI9H8jczKOYN3
         NTJiHIdi/bp9rY40lhfFMPCASTQC5rOXWhUIBeIflNLHYz9RWDOayp7kPLUWeZex7ZWA
         Th2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ILp5iM7cQcNHUrkAX0Lz/6PweGyzSkbIPzR9qhi/Ue0=;
        b=Rez7TkZlQY/H4JOdftvPWefiqvChxe0dqDhvJvv2QP2gkVI/mVC7ZYEuoFF9+muJEx
         rgS0Vif+VgF15bU6iP6hC6IpW9EbTHIcTUEPbR/Pg5wCiOzZHpmrPyBnmAftQo9Qh44I
         OLi6cnOBNDdpW7rDEc2+mNpRsseWmVcMdcESEIAHeRXYlm4Sz7vuBXeJaKEh3tfq9YJO
         quQxtE6+qEcYMRRP1rS5TkkWUbJcFuqdO5knqWvt39G3DPNmjcmtgSDubzrDzhTRk59R
         Tgoo6PsWychDtDf5SxI5ysXTGcmbfq5qV3RVbzPMY56Z//+8TqmPhv548l2wsebu/Mt3
         4fDg==
X-Gm-Message-State: AOAM532eabv+RF8cN6k7XXahG/9ndwAG0UGS1HQPGSKBy3tKAfxAdiwa
        nqknESy0d0AeikBjilAGsZDXXzLBVTA=
X-Google-Smtp-Source: ABdhPJzJQZrfcrwldGx1OINlkmy30u2zmlwyi54ku81CXyIloeHW5Dxvd7wnWBRMlb4pbg8saWC7hQ==
X-Received: by 2002:a17:902:7004:b029:d8:fc7c:4fef with SMTP id y4-20020a1709027004b02900d8fc7c4fefmr1454499plk.75.1605620706732;
        Tue, 17 Nov 2020 05:45:06 -0800 (PST)
Received: from localhost.localdomain ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id y3sm3669399pjb.18.2020.11.17.05.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 05:45:06 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        Christoph Hellwig <hch@lst.de>,
        Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH V11 07/14] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Tue, 17 Nov 2020 19:14:09 +0530
Message-Id: <20201117134416.207945-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117134416.207945-1-chandanrlinux@gmail.com>
References: <20201117134416.207945-1-chandanrlinux@gmail.com>
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

