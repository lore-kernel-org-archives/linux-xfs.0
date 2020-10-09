Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FDE6C832E8
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 19:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E559822B48
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 19:55:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KPJcnv7M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732835AbgJITza (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 15:55:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391255AbgJITzY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 15:55:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602273323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SDzBo1Hl39aW7kmMO7v5qnWfvx6c+eKzu7Cp3K2CdFg=;
        b=KPJcnv7Mxr/+PTGZovV3VqYAcIPy+62dxgo76hRaFoQA98MJ0Yr2oVs96QeEL0iPFbGvby
        qGEN2K6DLRaPp7l1jDByVtvt5/OW70p2U8dkPuxi2pfZp9icm1NWkd+UobeL4z64Wh+efh
        G8swefqm7go8WK2/VXW+YnrVfyQi2xM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-eHySza3yP2mRz9akgbuJMQ-1; Fri, 09 Oct 2020 15:55:21 -0400
X-MC-Unique: eHySza3yP2mRz9akgbuJMQ-1
Received: by mail-wr1-f69.google.com with SMTP id y6so875034wra.9
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2020 12:55:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SDzBo1Hl39aW7kmMO7v5qnWfvx6c+eKzu7Cp3K2CdFg=;
        b=eKh6OiaPEzVJVOSiGf0TtKsEzNiQaInwZ/R3yW06WDn8VuxgjPcXLkaIC1npO2deTN
         kI6J7Ntg1wV2w7+HupF2fhZVgNs1ejMpSxBpzN21LyVIYXNYE6gTLgOn7baeMm0xHdf6
         muLG7bgFo6SW30fpYe/nc+brgKyiW21r+YvzRRQk6jmkRZ+wS+LYEyAqoWOYxFkgI59j
         OWKnbNL5ylTwdY/3PpU6bOKlrrdz81WZdf4Gmp2pJA/O/ytJPDGPFbRFC5gIH2HnzfJy
         d67EjFS2IscM6nVLZzptarwoUK64ynnlXDtafpVLPeWT2tHWjfB5tUVqbdeZKyJ/imIi
         TRcQ==
X-Gm-Message-State: AOAM530Lzwb/wWEeUydkiuX+X6vPrVfQBc0JgakADLkdwExpgbrfWjhE
        XA71Lx7fugIFZEpET66RBjWXnDOtDumCtn+IV7l9+HcgC9wGCbvc2JAsq7tfqbGM7AJziJY4BQ+
        3qlOj1GdaLJa64d8gLppF
X-Received: by 2002:a5d:6a86:: with SMTP id s6mr7413719wru.344.1602273319252;
        Fri, 09 Oct 2020 12:55:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6QPtm/5Y1eB5X9O5J8NzNLhf1rFkyNfsMnDSpscmNO8zQgs2ZD+Xq7QHMS/yH5l9cAxJd9w==
X-Received: by 2002:a5d:6a86:: with SMTP id s6mr7413709wru.344.1602273319073;
        Fri, 09 Oct 2020 12:55:19 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id u2sm14069451wre.7.2020.10.09.12.55.18
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 12:55:18 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 2/4] xfs: clean up whitespace in xfs_isilocked() calls
Date:   Fri,  9 Oct 2020 21:55:13 +0200
Message-Id: <20201009195515.82889-3-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201009195515.82889-1-preichl@redhat.com>
References: <20201009195515.82889-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make whitespace follow the same pattern in all xfs_isilocked() calls.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 fs/xfs/xfs_file.c        | 3 ++-
 fs/xfs/xfs_inode.c       | 4 ++--
 fs/xfs/xfs_qm.c          | 2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1b0a01b06a05..ced3b996cd8a 100644
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
index a29f78a663ca..c8b1d4e4199a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -763,7 +763,8 @@ xfs_break_layouts(
 	bool			retry;
 	int			error;
 
-	ASSERT(xfs_isilocked(XFS_I(inode), XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(XFS_I(inode),
+			XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
 
 	do {
 		retry = false;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7c1ceb4df4ec..a3baec1c5bcf 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2781,7 +2781,7 @@ static void
 xfs_iunpin(
 	struct xfs_inode	*ip)
 {
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 
 	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
 
@@ -3474,7 +3474,7 @@ xfs_iflush(
 	struct xfs_mount	*mp = ip->i_mount;
 	int			error;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
 	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index be67570badf8..57bfa5266c47 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1803,7 +1803,7 @@ xfs_qm_vop_chown_reserve(
 	int			error;
 
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	delblks = ip->i_delayed_blks;
-- 
2.26.2

