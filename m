Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE73C11D3D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 971962469C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:36:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hUGrUBOq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbgB0Ugp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 15:36:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52151 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729351AbgB0Ugp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 15:36:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582835804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tq12WWJbCLJ3UGDavyT1Ia8p+H5z66yhgHqbUDK4lLE=;
        b=hUGrUBOqQA9nqk7mPkksSRx3kjuiPBEGlTiJLpKKqRBasOqmzk2pfTvtYVu0Saq+X//2pM
        Hs/7gXglwkACiJZQ5YuI7F8UJLNcxUFyzEER6stjjH0a0x4Yk7GhHkWkIvQHrkThK0qJFl
        4JFOXc92D8xMGrbDg+MMeqpwaVes7Q8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-2WfmJaDhNSGDJ8Mh2ajwQA-1; Thu, 27 Feb 2020 15:36:41 -0500
X-MC-Unique: 2WfmJaDhNSGDJ8Mh2ajwQA-1
Received: by mail-wr1-f72.google.com with SMTP id w18so342135wro.2
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 12:36:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tq12WWJbCLJ3UGDavyT1Ia8p+H5z66yhgHqbUDK4lLE=;
        b=M65ywVbsalXX2z3nBrbDws5cAw4A9sSWcmXB3tC8IRrKVsu7yZ9C6jIqWKsbu3bPtR
         qPcVzacQV5W2ctLobIR8BgK2piW/hIj/zOXeHAjwwe0vLXjAJTw9Io4XgY7zU7AY5bZ8
         QwN3gmO5/0vs6qSTvRYaLFH/x3dxrM7bLYwUHbPcjt5MXpVN9eomCAYzXjffeb3YIUSG
         Wfi+BPmXg9CI64h9FRoZ3pNPjMCDntObjWORVC5Edpn9yYVr3Z2VkWbNIlfKYx0tA+2H
         YC9DeJO27a1/JLMCCzHdRoZ6AK8DRuiTZ13x/pgHMuDRNzJDci6yTgSoFWeGA7QCuywl
         52MA==
X-Gm-Message-State: APjAAAU4ZmEZG0+GAU5r6S9hgTyUv561+V6VeXuS3KwHsmA9QB9zHTi2
        DzPSIjgn66upDK79YqG6MJW6spF4XeC2MOgMH6Eu2bXZgN5sznS/fDWygBAg1FXpF13qPAmiAV5
        PuyFkaYxPqP1N2NDZP6m3
X-Received: by 2002:a7b:c850:: with SMTP id c16mr593343wml.68.1582835800159;
        Thu, 27 Feb 2020 12:36:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqw65mRByJKkP74yKC5zCVbXynJ4gs86ZpmM/kljQXD+gHPpWtYrR6oBbuyIJ9vAsgo6us+MEg==
X-Received: by 2002:a7b:c850:: with SMTP id c16mr593325wml.68.1582835799882;
        Thu, 27 Feb 2020 12:36:39 -0800 (PST)
Received: from localhost.localdomain (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id e11sm9217157wrm.80.2020.02.27.12.36.39
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 12:36:39 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 2/4] xfs: clean up whitespace in xfs_isilocked() calls
Date:   Thu, 27 Feb 2020 21:36:34 +0100
Message-Id: <20200227203636.317790-3-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227203636.317790-1-preichl@redhat.com>
References: <20200227203636.317790-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make whitespace follow the same pattern in all xfs_isilocked() calls.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
Changes from V5: None


 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 fs/xfs/xfs_file.c        | 3 ++-
 fs/xfs/xfs_inode.c       | 6 +++---
 fs/xfs/xfs_qm.c          | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9a6d7a84689a..bc2be29193aa 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3906,7 +3906,7 @@ xfs_bmapi_read(
 	ASSERT(*nmap >= 1);
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK|XFS_BMAPI_ENTIRE|
 			   XFS_BMAPI_COWFORK)));
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b8a4a3f29b36..6b65572bdb21 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -770,7 +770,8 @@ xfs_break_layouts(
 	bool			retry;
 	int			error;
 
-	ASSERT(xfs_isilocked(XFS_I(inode), XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(XFS_I(inode),
+			XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
 
 	do {
 		retry = false;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4faf7827717b..e778739adbf8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2816,7 +2816,7 @@ static void
 xfs_iunpin(
 	struct xfs_inode	*ip)
 {
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 
 	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
 
@@ -3680,7 +3680,7 @@ xfs_iflush(
 
 	XFS_STATS_INC(mp, xs_iflush_count);
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
@@ -3812,7 +3812,7 @@ xfs_iflush_int(
 	struct xfs_dinode	*dip;
 	struct xfs_mount	*mp = ip->i_mount;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 0b0909657bad..d2896925b5ca 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1802,7 +1802,7 @@ xfs_qm_vop_chown_reserve(
 	int			error;
 
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	delblks = ip->i_delayed_blks;
-- 
2.24.1

