Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8CFC3F68F
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 19:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E03B20838
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 19:05:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KlfcejXu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgBFTFP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 14:05:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44454 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727887AbgBFTFP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 14:05:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581015914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Keg5iUBK5oB0bOmvXjelgsq5GA/dSQa3hiKVGk6RBc4=;
        b=KlfcejXuAJ8pHCA8Nrma2BZGFv0v3gZxvZKW0IE45m2jQXIf8NWzMuOfQ2oeyJ5Nn5Wc5n
        9VhdJkSfSZXl+HJc+aFc4TJgQMhh4lM9HJ5h+byJJJf4ja01umGT5q08wf2iUptXCKV935
        r2ooAMyv0NpM2VWoERliJp5ZKXwkVig=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-647IfIMHMe6BWuCfByQYAg-1; Thu, 06 Feb 2020 14:05:10 -0500
X-MC-Unique: 647IfIMHMe6BWuCfByQYAg-1
Received: by mail-wr1-f71.google.com with SMTP id d15so3981161wru.1
        for <linux-xfs@vger.kernel.org>; Thu, 06 Feb 2020 11:05:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Keg5iUBK5oB0bOmvXjelgsq5GA/dSQa3hiKVGk6RBc4=;
        b=Jqp/7VD/MyfEoIrgVJ3mWQb9KRW3ZuNfKW1jl/mYRPysSr849iXEZCRP/E82otyMyP
         35Puq+Yeyv76ib4LBjXQ/xnRUoUo9Aat57/0AzJM+7G72285qglMNBneS2YEA8GY9E72
         RXbTAyDMozoxypjSScpdQ0y5ZGZ/IrkviemSfc/sOvOf3EJzo6RXPUy1jL1VOnj4oKNe
         6Lpl8KpT9bn4HAg+Md5RX9BBgakzfQww8VxNfsLKDLOFvfg27LNV/dfxwSTtanvhK9nB
         j4Gd3b57j0z4NnjEZuRz6ZorWngfFuCeJDcj7MEnI/XRaJGoU51U8D68bIpEGEheB1A6
         DN0g==
X-Gm-Message-State: APjAAAWq54HaIf2zz2v+Klwy5/dwAdRp3tpcTaXfpLw6R4u5iAQ4xtbe
        qWNHbkQoAfKvumZTkUjG/SV0/TqrRYR7bh/ikU4UrKkYbBoddg1HL6m11z3plCVQ4jwqOfRJdIO
        lFOzJWsOD+Xj1VHIip8Lb
X-Received: by 2002:a5d:4446:: with SMTP id x6mr5190099wrr.312.1581015908841;
        Thu, 06 Feb 2020 11:05:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqztvB1TUcrSRI2hPuZ6GxfnV3MLV1+uG5Ud1JXkBhJf0A0LlDLZoOqqwz6PcmoK4jPCKOZuew==
X-Received: by 2002:a5d:4446:: with SMTP id x6mr5190081wrr.312.1581015908625;
        Thu, 06 Feb 2020 11:05:08 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id l29sm215448wrb.64.2020.02.06.11.05.07
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 11:05:07 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 2/4] xfs: Fix WS in xfs_isilocked() calls
Date:   Thu,  6 Feb 2020 20:05:00 +0100
Message-Id: <20200206190502.389139-3-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206190502.389139-1-preichl@redhat.com>
References: <20200206190502.389139-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
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
index b5f71b9ae77b..7cc03dd45ff9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2828,7 +2828,7 @@ static void
 xfs_iunpin(
 	struct xfs_inode	*ip)
 {
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 
 	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
 
@@ -3692,7 +3692,7 @@ xfs_iflush(
 
 	XFS_STATS_INC(mp, xs_iflush_count);
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
@@ -3824,7 +3824,7 @@ xfs_iflush_int(
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

