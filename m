Return-Path: <SRS0=Jdfz=DX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E402EC43457
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 02:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E5052087D
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 02:10:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f5iKauky"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393357AbgJPCKO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:10:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46656 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393350AbgJPCKO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 22:10:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602814213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qpy0VrxMWvkww01mbI8Z5eZUiI2zU20d6Xjwcz513Pw=;
        b=f5iKauky5u0KZCj8bDIeNHsPmDVW4Ua0nU+uA8InCwe/Evql6lye7BHNhiH3eNEeL/5Tbe
        qRS4zaTCDfIGEn9uNROZp96RupQqR+48SjVr6FB2iM2eC0iPAuj4rqua+PfQ4YrZL/AnN7
        db4ffH5Uis6vM4AIB6O/hvLtENZr2WA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-gl6hD_njOaKPUrHn5fA6-A-1; Thu, 15 Oct 2020 22:10:11 -0400
X-MC-Unique: gl6hD_njOaKPUrHn5fA6-A-1
Received: by mail-wr1-f70.google.com with SMTP id b11so627553wrm.3
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 19:10:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qpy0VrxMWvkww01mbI8Z5eZUiI2zU20d6Xjwcz513Pw=;
        b=qC0RQbBV3h+5w4Fefo18WxuotqWCRW3WoFlx5GLo2jIHM+yEgBNVLUNd2XQhdwztvt
         k7Nh0wb3Uf6le7JSRHZZZgVHcCDytVFEvuFDlXRFABPP4r/3nd2DosTOti/yOKyQSjgp
         7BkEF1Gqf07ZDp4oTQDcgUQjXS1TAgi+BJWuKhAop0Un/OxykJRZ8cI5MOaD8mmmc/sX
         rhodl8llPMMeK9RiTvhRk6vju/8XpGIf4KC7UVZHnQvHxLQKMDzeW1uprSz8gWgwDQFS
         /xAyo94eE5tiPc3uLkXRLfBqWxrMtBINeG2iYCuu48xc2d5/pJckijMA4pUf6xo4o26N
         2hMg==
X-Gm-Message-State: AOAM530YN0Ql0/AgR9l9zwtfNm+fg2mD2DE0odNRvd0xHmYIp3CiMLoG
        y4eizVcH3wZMwHBNymCuPaLDk9iarWB4JOPOeRlGgiCyZbDThN58N+ETiTKlw6BhVEgVOZpkGXm
        yWn//8yt6a7gnDk7T2eR6
X-Received: by 2002:a1c:4856:: with SMTP id v83mr1382516wma.118.1602814209404;
        Thu, 15 Oct 2020 19:10:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9VSKkfccbfDrQlhJ9eMz3ngkjGTB+pYGYpo9+3r6iSmMmgV4x9NV8iXOX5MdM+994xYdCKw==
X-Received: by 2002:a1c:4856:: with SMTP id v83mr1382507wma.118.1602814209233;
        Thu, 15 Oct 2020 19:10:09 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id v3sm1420685wre.17.2020.10.15.19.10.08
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 19:10:08 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 2/4] xfs: clean up whitespace in xfs_isilocked() calls
Date:   Fri, 16 Oct 2020 04:10:03 +0200
Message-Id: <20201016021005.548850-3-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201016021005.548850-1-preichl@redhat.com>
References: <20201016021005.548850-1-preichl@redhat.com>
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
index 1fdf8c7eb990..085927700530 100644
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

