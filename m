Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FE6C4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 21:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91977208C3
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 21:39:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OExfUQXP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgJEVjB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 17:39:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41898 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725616AbgJEVjA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 17:39:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601933939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nlqRPbcwPd/Uky8ewakSE96Ze9oxdn4UrbS50VrTO3E=;
        b=OExfUQXPAAucNvFTlhXa2fB7MAT6kPcM4rQR6HD2kHTgK1DGkrzXgFKBk9Kl5kNnDAZrA/
        03b21Th2NBf1ytB1vdERxNLOc3d2LVTFbnAhnfTHF9vd2KeSKqU3CtGA4veHGTI/YKf4Vz
        8JjN5+JpknHpqE/ZzsxiduVfNlDeS5A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-SfcbC46WNu2Eao94WNO-rw-1; Mon, 05 Oct 2020 17:38:57 -0400
X-MC-Unique: SfcbC46WNu2Eao94WNO-rw-1
Received: by mail-wm1-f69.google.com with SMTP id z7so333669wmi.3
        for <linux-xfs@vger.kernel.org>; Mon, 05 Oct 2020 14:38:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nlqRPbcwPd/Uky8ewakSE96Ze9oxdn4UrbS50VrTO3E=;
        b=Pn1xTfvOIiYXelaYhrd+I0raDWJ3/51fcXIWsGkmj7RWBDw+7GaTjkBG+1RJtZUtt/
         NlY8KiSntaS1GzlrjKWCFaUh8+f+Zlzd43aICRT/cyxJyJx6Hi/DBkuosRNzH+GfQh8q
         7kddWcXE0io2C8q42RboMSF5n/3444qkTzwkjgQa/Xz4vKFbgbF7/PXNbyurzn4ktnY6
         jAO2SjiFx0s6oSa5kGdmsbz/5fnZMvLwATUzSeoluVgqGA7yeuZysTse8ScKn1VKRdIN
         +zPcK749VtA36/y7MjDeCGftmfT5rBcR1aHcAI3HsKsDJIgQEOob7pgAQHb8X7OpUZjm
         ee0Q==
X-Gm-Message-State: AOAM533MXT9GT/rrWF5iRZDSoIFYsdkNulQoMt+bdWHaltzQ1cL/t1sA
        LRdwEGhJEgIueEO4UedlcMnSwddC7TiEU2iwA6AZnY76GjArA/I8R0ctEfMCj+wXM+ImNSDtIPZ
        eIgKem/G7DINVL5+cibgT
X-Received: by 2002:adf:e488:: with SMTP id i8mr1465107wrm.116.1601933936260;
        Mon, 05 Oct 2020 14:38:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5KzY5Dc602/9I9zYyz6o38QOGUpAjupfwQLHZ2McbGel6fcZt55tmRLQ8yQQ5l3RmOi+9rA==
X-Received: by 2002:adf:e488:: with SMTP id i8mr1465098wrm.116.1601933936041;
        Mon, 05 Oct 2020 14:38:56 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id r5sm1576499wrp.15.2020.10.05.14.38.54
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 14:38:54 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 2/4] xfs: clean up whitespace in xfs_isilocked() calls
Date:   Mon,  5 Oct 2020 23:38:50 +0200
Message-Id: <20201005213852.233004-3-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005213852.233004-1-preichl@redhat.com>
References: <20201005213852.233004-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make whitespace follow the same pattern in all xfs_isilocked() calls.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
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
index 1f39bce96656..49d296877494 100644
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

