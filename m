Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC4D3C04EBE
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 13:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AD732083B
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 13:46:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NBgPBaM6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbgJHNqO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 09:46:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730361AbgJHNqN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 09:46:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602164772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SDzBo1Hl39aW7kmMO7v5qnWfvx6c+eKzu7Cp3K2CdFg=;
        b=NBgPBaM6UPdbnsHjkBs+wyoASnmE+AWrv7YBcmQlhQYOjDe5lioNzwpYBHHTBwBZwxLaub
        5yKFifDa8L0lwPbaPAg7elYia0U8XlsWM3h/M19dSX4du2bWQHEtvZkkHhvZ3YMGjvJ2tG
        sLOrFBuuDKRN428rOib+xYklYt/QmjA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183--qa10oBtM3GlZOpICxnuhQ-1; Thu, 08 Oct 2020 09:46:11 -0400
X-MC-Unique: -qa10oBtM3GlZOpICxnuhQ-1
Received: by mail-wm1-f70.google.com with SMTP id u207so3080251wmu.4
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2020 06:46:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SDzBo1Hl39aW7kmMO7v5qnWfvx6c+eKzu7Cp3K2CdFg=;
        b=jHrltQ4p0Tt985Yu9znFl7RUPZr/SWXIKZABmx5S773Y3DavwaR51GeQBdHKjYSk5c
         xIMEHstatZiFZCKRiDkOqXxAEYbnlvDXlhgKKofYlvR8yLuW35jgn0XMbnv6Ryn9VCAF
         1seId5z/Sg9uLlYpbvB4XPkI/9a2DIIf/Y9vMkUyFHK4E5fwcSYP18y9I0Z4sDMfxlkE
         /Y9rXGy8j6d5nYJK0P8qJYeGiLpX5mngv9HgWsCVzLlp19L2b12nVkXhYVzD/URQ1wuS
         r31Cj85lDy/yZeg+Txuec7Czjz3Nl/jIWPAJq/1mwZIZdLg7Ce549ki6jbRIyEaThNFa
         Y90Q==
X-Gm-Message-State: AOAM532DFT4KW5dxEAXTOhM+fHFUdlNQnZTnMp97SC3tIgPLBNVU1WdZ
        TnERQysmCqwB/ZpG+Iy42nr+NMLY8Qr++TkYW2gVgwbPHLao3TMu6k2j5idb0Yy6stfY/kDgiSn
        8IIxkM7/9mdJ2DiZrBQMa
X-Received: by 2002:a05:600c:410c:: with SMTP id j12mr8758506wmi.179.1602164769685;
        Thu, 08 Oct 2020 06:46:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnU9fbjBVTDva5rYnM/EsjQVsbhebL5DpwTZk3qJ8WD63E8KmKrZ8XY0z2BMfmfOB2W5sc0g==
X-Received: by 2002:a05:600c:410c:: with SMTP id j12mr8758490wmi.179.1602164769502;
        Thu, 08 Oct 2020 06:46:09 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id s19sm7069465wmc.41.2020.10.08.06.46.08
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 06:46:08 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 2/4] xfs: clean up whitespace in xfs_isilocked() calls
Date:   Thu,  8 Oct 2020 15:46:03 +0200
Message-Id: <20201008134605.863269-3-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201008134605.863269-1-preichl@redhat.com>
References: <20201008134605.863269-1-preichl@redhat.com>
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

