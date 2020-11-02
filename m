Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A2DC388F9
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 19:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04F5C22268
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 19:41:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iZ9d/WZa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbgKBTlr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 14:41:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726625AbgKBTlr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 14:41:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604346105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YMu3vYRAW3ybH8a6jQ+nMdueqKJ/7j/qGQLc1LrL4jc=;
        b=iZ9d/WZamrN5S1E+AzkT8UaXvTqLpYzUSGAWwZ4yxR25SJHVoPRW+O35CCFLjNoDgIwW5x
        4P3ueip/FS3GXOHzAQJo3qJb9hdJ/63pgxuQEztzY+U+kjeSw9n4maeq+xgUWZQypU9fDJ
        TAUHzuJoAkpc0TaKoYWcTazssHXXGB4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-yp-U_v_0Poi8JiItk5KQ0w-1; Mon, 02 Nov 2020 14:41:42 -0500
X-MC-Unique: yp-U_v_0Poi8JiItk5KQ0w-1
Received: by mail-wr1-f70.google.com with SMTP id 33so6769965wrf.22
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 11:41:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YMu3vYRAW3ybH8a6jQ+nMdueqKJ/7j/qGQLc1LrL4jc=;
        b=azYp9WmTdHyqv/tnQoe9Q2W5gvaJ16a9f6yo3qzQRkJpzok3pK/UEs0XxTqLrvTwjV
         VeZVkGdZEquB3F/P7qazovBkklpz9QLa4z7pswSFYMa3JUo0vVWGov4DWw2gXXC5FcUx
         7JfJRUlbGdf6FDq37S+0AHrzMd9b2OJH4IbTM1pGcOn6wVF/k57BbFFfFsE1d8sCP9gV
         aBlJXpNJcmiP1AjMH6oKJxsKF4myyMzlUI8oTiLzJqRwzrFHjRo0AfYcexSJy9CjTJyi
         XQilKUTOEp5lPMgi1Qwwvb9y7ivjrKpcA6srtVBgNtRHs0UQTABQdYgQcv1+iTAjjFEN
         f8zQ==
X-Gm-Message-State: AOAM532z2sGv96ozJKVZZYSsE8/0rNNzwvuK6/EZLTpgfUvm5hxMxSBP
        Jj7CuXo1/9i3s0TsiQsNEjCQCSAxv4V4c21pRdAyBD0BMfs1n1Z3vL1apkMrQPHj/IhxnThvV1l
        FoEb811d7hCmV31KR7oSS
X-Received: by 2002:a7b:c201:: with SMTP id x1mr8825485wmi.42.1604346100560;
        Mon, 02 Nov 2020 11:41:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzumNVuAvstF0kazBB+d/Bx1tR2jI7akCaXF8znx7CFHLLBIKCMVDKq0SssMuA6OukCQrhVFQ==
X-Received: by 2002:a7b:c201:: with SMTP id x1mr8825473wmi.42.1604346100407;
        Mon, 02 Nov 2020 11:41:40 -0800 (PST)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id 6sm11742465wrc.88.2020.11.02.11.41.39
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 11:41:39 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v13 2/4] xfs: clean up whitespace in xfs_isilocked() calls
Date:   Mon,  2 Nov 2020 20:41:33 +0100
Message-Id: <20201102194135.174806-3-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102194135.174806-1-preichl@redhat.com>
References: <20201102194135.174806-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make whitespace follow the same pattern in all xfs_isilocked() calls.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 fs/xfs/xfs_file.c        | 3 ++-
 fs/xfs/xfs_inode.c       | 4 ++--
 fs/xfs/xfs_qm.c          | 2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d9a692484eae..666aa47e4f4f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3883,7 +3883,7 @@ xfs_bmapi_read(
 
 	ASSERT(*nmap >= 1);
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE)));
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 
 	if (WARN_ON_ONCE(!ifp))
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5b0f93f73837..874c5edc7b4a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -796,7 +796,8 @@ xfs_break_layouts(
 	bool			retry;
 	int			error;
 
-	ASSERT(xfs_isilocked(XFS_I(inode), XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(XFS_I(inode),
+			XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
 
 	do {
 		retry = false;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index efe4a0afa23e..16d481cf3793 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2772,7 +2772,7 @@ static void
 xfs_iunpin(
 	struct xfs_inode	*ip)
 {
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 
 	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
 
@@ -3465,7 +3465,7 @@ xfs_iflush(
 	struct xfs_mount	*mp = ip->i_mount;
 	int			error;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(xfs_iflags_test(ip, XFS_IFLUSHING));
 	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b2a9abee8b2b..e0bc7c739061 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1818,7 +1818,7 @@ xfs_qm_vop_chown_reserve(
 	int			error;
 
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	delblks = ip->i_delayed_blks;
-- 
2.26.2

