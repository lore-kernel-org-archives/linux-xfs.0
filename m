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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4846AC5517A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA7EF20791
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B9/9OvDO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgJ2KOq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgJ2KOq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 06:14:46 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D723C0613D2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:46 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g12so1937049pgm.8
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ILp5iM7cQcNHUrkAX0Lz/6PweGyzSkbIPzR9qhi/Ue0=;
        b=B9/9OvDOT+nVLCUPSrXG58gM7sQWx3CkauhSrW/JLizax3wbWfd/msQvA04fGsIVeD
         H2JlaMfeRnzORdtdiwSAdd/+yVwG4/DBxYiSoxg69508tqncPiiAq8VcgUxKqtKsnEru
         k7LgWz+yYte0s7niLdtjCrlDX5SkMifhMl2YxhcKuAkrBtTcF46ne+i9jykDNC2OVM3G
         xFf4bMP+UjzZZ/RCEtK32vlYPh45h18DhbwtSpI9cZM0tnEs3T7zAJ6TdzYklYzL9fUQ
         jyjnS+G16FmsP3eNwBQP1xmJG3NOm/TDOKkGITNR6Imiy7X2ahYTxYSpVSLGVIthPI9D
         yT/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ILp5iM7cQcNHUrkAX0Lz/6PweGyzSkbIPzR9qhi/Ue0=;
        b=ZfgEVVVWUAhcou2V89qb1VqPpeZklFu6xvK8UQITh+VhQvUCUvPYT+3MD2Qm0Y1BGy
         TTvpC4DZg4HVPws9LCIMJnM8FPgKvwvCwiSReRABjDPfqHTujcj5BKGSG5uk7k0saRAi
         U1wMIwwjyiZkrir3UVuBIyRgF341Uz46ufO+YV3KGj4LuctQo61Rzc9KLXq8SG9ArLuc
         SGOWlgsJYycMuYgSTRJamNfxT3txWOPZwcKruMJBrDdfhCeHSsX9CPldWnkv6zC7lPgw
         vXO/q2V1RDvJlCmovbxikB9xSSnE9SnqmXGUbbsCb+bGiF65NrZR1I8RUQeXM+Gwxzj6
         8nvg==
X-Gm-Message-State: AOAM532lt+4f+X9NOEPqkIS4Nq9hBay/mUYLIdtRjYlnebz7rWVwT6gj
        ObK4Hqx15LkvbEZMOMWSUZJx4G1grbc=
X-Google-Smtp-Source: ABdhPJzRC/gtEoSyIPazThofkJ0sNbRgutL8+BXgEU+LyCcole2zMkhV6ae+436Uf6L7SCXs1cfCUQ==
X-Received: by 2002:a17:90a:db55:: with SMTP id u21mr3497732pjx.235.1603966485565;
        Thu, 29 Oct 2020 03:14:45 -0700 (PDT)
Received: from localhost.localdomain ([122.179.67.57])
        by smtp.gmail.com with ESMTPSA id s9sm2488073pfh.67.2020.10.29.03.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:14:44 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V8 07/14] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Thu, 29 Oct 2020 15:43:41 +0530
Message-Id: <20201029101348.4442-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029101348.4442-1-chandanrlinux@gmail.com>
References: <20201029101348.4442-1-chandanrlinux@gmail.com>
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

