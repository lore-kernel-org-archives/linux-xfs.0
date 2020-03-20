Return-Path: <SRS0=ynSb=5F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92FEAC4332B
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 21:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64FFD20658
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 21:03:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CGCRWeBR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgCTVDn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 17:03:43 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:46441 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727192AbgCTVDm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Mar 2020 17:03:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584738221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y6JvE2XM3f5G73ENCohJroPWB8ILaAoDXoWtL5206qY=;
        b=CGCRWeBRnmCqL4bdZCpAvlI8SNuECPlwDBZ5yIjuRNASSmX8Gdrn8JSwrlqJ1g7V9RKwS/
        21uoadvhZ0dfttjixfyu0wxcyM4IuUiLfpbXGx/pOEyJ6UWapaJWTYhjU90LdzsMshMWtS
        TotfY5G+GJvUfIoR1tJDGn5F/jbF4M4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-_EDhaaq8MFaKwiivk6496w-1; Fri, 20 Mar 2020 17:03:39 -0400
X-MC-Unique: _EDhaaq8MFaKwiivk6496w-1
Received: by mail-wr1-f72.google.com with SMTP id u12so3217748wrw.10
        for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2020 14:03:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y6JvE2XM3f5G73ENCohJroPWB8ILaAoDXoWtL5206qY=;
        b=HDLVWepj8qIc5EtwtPHaxIOsmiVdY2lIWbd6R+tcpBjL5KN1V4vIZ6ea4jZfJLDsvE
         0bNN7Gom+6b5L8t2RYCVGQMzpsszRQkl8OPnBH4KFrGQCAxV19p7v3sJO0eQkDzH0/RF
         lWK4BFTs00HV6fFA/SRew3gHJxbmadVlD7EJHa+zMt7uq3eMnGDqMkv9U4eYy8jSQan8
         M/1Jo1daT5h9tr33WssFH1oDBRfmX/E3WLCSrEkvztfLTss9P0yH8qTghNs2U1JVCYii
         5UqX8ztm9L8LTVu111+5Qpx7PuAVvjQ5xjJQ2ywIOfQXzwpmCrPyA4jiCvef+BetMFdg
         iD2Q==
X-Gm-Message-State: ANhLgQ1EN8Fs13gvjqxmx573ycyNFqypjNXuuyeplIzc3ii+SOQ8pJ41
        qk0CEe/62dxZ7UYEkBcfLMpu0ebxU6bkMhTH2KkaQ5rwUSS8LNUZ1D8IayR7xhV22Vrc845bSQk
        JZXY7g4LFmqu1uz0ZKZwu
X-Received: by 2002:a7b:cc72:: with SMTP id n18mr3516933wmj.71.1584738217383;
        Fri, 20 Mar 2020 14:03:37 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvbs8ThiGZm0KwRVdrjrh7GTleswhlbcKwvj4GmruMC1YdxFyftWuklaq3UETDAwy9z/nPY8A==
X-Received: by 2002:a7b:cc72:: with SMTP id n18mr3516923wmj.71.1584738217145;
        Fri, 20 Mar 2020 14:03:37 -0700 (PDT)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id w7sm10479668wrr.60.2020.03.20.14.03.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 14:03:35 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 3/4] xfs: xfs_isilocked() can only check a single lock type
Date:   Fri, 20 Mar 2020 22:03:16 +0100
Message-Id: <20200320210317.1071747-4-preichl@redhat.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200320210317.1071747-1-preichl@redhat.com>
References: <20200320210317.1071747-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In its current form, xfs_isilocked() is only able to test one lock type
at a time - ilock, iolock, or mmap lock, but combinations are not
properly handled. The intent here is to check that both XFS_IOLOCK_EXCL
and XFS_ILOCK_EXCL are held, so test them each separately.

The commit ecfea3f0c8c6 ("xfs: split xfs_bmap_shift_extents") ORed the
flags together which was an error, so this patch reverts that part of
the change and check the locks independently.

Fixes: ecfea3f0c8c6 ("xfs: split xfs_bmap_shift_extents")

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
2.25.1

