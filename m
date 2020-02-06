Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE261C33CAC
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 19:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C98BB21775
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 19:05:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJ6sLBHr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgBFTFO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 14:05:14 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44684 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727887AbgBFTFO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 14:05:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581015913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c8SC3QnJNFmWJHFbsxGZWdEAhQqPNxGcxFTHwlYZJeQ=;
        b=EJ6sLBHrwi5nE9S++w9NXEOBLE/cvYb6OH3RWw9eGDleV3FmDUoblPlWcqEnX9Is6Jagla
        P1PSfPUMfdq438nPL7swR3kanl0qzkD4JR3aSfLpgiWEoNehVO1wUXVGfeTvvXXJIsSsFr
        E/V06+OaBc/1vXzJu/wDvnyQ77T8mcc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-wZQA9tRRPpO9hjS2Sxi2ng-1; Thu, 06 Feb 2020 14:05:11 -0500
X-MC-Unique: wZQA9tRRPpO9hjS2Sxi2ng-1
Received: by mail-wm1-f71.google.com with SMTP id p2so478985wma.3
        for <linux-xfs@vger.kernel.org>; Thu, 06 Feb 2020 11:05:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c8SC3QnJNFmWJHFbsxGZWdEAhQqPNxGcxFTHwlYZJeQ=;
        b=P1x+JbhzJpkyKoHM01wEU12M4p2fA9k4uOcZoYgWmbHspB7oxtMwt5uOlatjmA7Lx1
         4Gyt5vPtAtzEN4sPfzBbb0ePnTLdoAeJBJK79ZuGGhUz/BX/bYclTMoLQ5yyyVtpyYVQ
         WU6GhmomPhaZBAJLuGwLSrXaeCfsmawHKKx5lLkR2udDwWvPy+TsLQYfG0ItxU8MBEmD
         Ckk6YtTHM5D8kz1SMThWY2nXDVV5gY7EwriR338Dn8q17YHp4RbrLhlpc0Dg3fyluz5u
         iV4JjNtSdsSzREEXFyFdGK81SxwLOG2DGD1s8sJTg6/Bul61r7FC6Vkb0mxSBGR0cIze
         X38A==
X-Gm-Message-State: APjAAAXzYbH/dG6TYEppdSpIIThNbDtxD/aIMCWgl5Nba3fK+YZ7lqr5
        09+CudOa4bE/sK981K/NaoAQeJr8TG6ilmZKKVpC/9a5EWqoWMw3W4RYIkt/vtdqDhg1vJnytsF
        sbztGHn5CevZ43NhOQBgK
X-Received: by 2002:adf:dfce:: with SMTP id q14mr5354210wrn.324.1581015910034;
        Thu, 06 Feb 2020 11:05:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqwjGaONDd5iFt3Ru6QA9nhwrgCePkimtX0et7kx/7ZwZ6tf5Iu4qzXCWQbWOgCv5TF8cD8uRA==
X-Received: by 2002:adf:dfce:: with SMTP id q14mr5354190wrn.324.1581015909828;
        Thu, 06 Feb 2020 11:05:09 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id l29sm215448wrb.64.2020.02.06.11.05.08
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 11:05:09 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 3/4] xfs: Fix bug when checking diff. locks
Date:   Thu,  6 Feb 2020 20:05:01 +0100
Message-Id: <20200206190502.389139-4-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206190502.389139-1-preichl@redhat.com>
References: <20200206190502.389139-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_isilocked() will only check one lock type so it's needed to split
the check into 2 calls.

Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index bc2be29193aa..c9dc94f114ed 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5829,7 +5829,8 @@ xfs_bmap_collapse_extents(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, whichfork);
@@ -5946,7 +5947,8 @@ xfs_bmap_insert_extents(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, whichfork);
-- 
2.24.1

