Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6647C4727D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 19:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8457520797
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 19:15:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CY31AKT4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgJFTPt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 15:15:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36999 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726918AbgJFTPt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 15:15:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602011748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m4lYOA3dHKqQNC2RMQF6WCyySkZiAXO8oo+sg/fo1Rs=;
        b=CY31AKT48z457tFhkM1mX+bYdVUOXymxMGhLh754AVGQYMoyMecB1yiUM+3p34mH3+EouI
        rn1eRMeGcMKVZD7Vu25ju62dWvCLd/nfPzvCLBjFvmnqeQh0w+ee8c0TETVXn1h1kZAtnK
        61wzW7UZW9Zg1hnxJwWEQoWLmm7JAMo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-epvaJOSVOYm4SSQjTtqT3w-1; Tue, 06 Oct 2020 15:15:46 -0400
X-MC-Unique: epvaJOSVOYm4SSQjTtqT3w-1
Received: by mail-wm1-f71.google.com with SMTP id r19so1462497wmh.9
        for <linux-xfs@vger.kernel.org>; Tue, 06 Oct 2020 12:15:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m4lYOA3dHKqQNC2RMQF6WCyySkZiAXO8oo+sg/fo1Rs=;
        b=GT1sHpOscb9qMiJvbPMJ7KUqzICI5I/15XhfI9Va7iZQgifJWYx5d6v901G1qox1lg
         m1FnwP2h9sbRQb1/sqr/VCaGESjVCslu28MlL2pXOJPTGcBhdyfpgsVowOSRNi6i7enw
         85Hx96uJqRS1xkzNZCqFu032DxXaP/DzDNmBvmenNCz2DpgpPcqm5mKEy45AReOfXU3C
         EJJBl1TE1XTzVpF3Oiu2uBfpHEbBIqk4GUROc6gahH8HeX178qJIeq2/IqLuabnzXCFk
         doXEgIwIQggL6Gc7ksq3uczBnbH/VNrWvL0mcBz6dzg4YLNDWHKHlTfuwrOGQEm9OUJq
         YcfA==
X-Gm-Message-State: AOAM531YNJUSgJmnwNPRNIWhKvV8O5l5fVjsqHtfHzSvZ+HN3EDFfVH+
        sWGy7qTsy6GuJiXfVrqT08ax3SjBL41iIsDk5CLYi7ZuuWnS6cdsw7ItChzFbFNes16hho7KpCO
        AEBPaik0kkrabfJo/deQZ
X-Received: by 2002:adf:fc0a:: with SMTP id i10mr6520586wrr.111.1602011745412;
        Tue, 06 Oct 2020 12:15:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHsHZT7wTqVNDdzBotNfST2iqa8MFquEnqjFvrQ9JHYBuxx6tmhDhnfu7k0Xsvpp+qTlL3Og==
X-Received: by 2002:adf:fc0a:: with SMTP id i10mr6520578wrr.111.1602011745237;
        Tue, 06 Oct 2020 12:15:45 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id v17sm5317074wrc.23.2020.10.06.12.15.44
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 12:15:44 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 2/4] xfs: clean up whitespace in xfs_isilocked() calls
Date:   Tue,  6 Oct 2020 21:15:39 +0200
Message-Id: <20201006191541.115364-3-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201006191541.115364-1-preichl@redhat.com>
References: <20201006191541.115364-1-preichl@redhat.com>
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
index f3b3821e3c35..035925d406d5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2779,7 +2779,7 @@ static void
 xfs_iunpin(
 	struct xfs_inode	*ip)
 {
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 
 	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
 
@@ -3472,7 +3472,7 @@ xfs_iflush(
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

