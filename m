Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9308CC43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 12:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbiFKMzO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 08:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbiFKMzN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 08:55:13 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817374C7A5
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 05:55:11 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id z17so1761493pff.7
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 05:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fU3F4bcwZp70hCMjLKr900gPyRngGvpL8JmfItxitXw=;
        b=ZuU9udweLnEcBFMkHL6l+d09zrwBSQ8bp7Ux85KMsFyWYMiwp4pmJeVwcW7HX0eeh2
         imKSjmcGrDRTYph+y2QKmImF86u0xkXpSuZl/M6YZmw+aZs38EIFhxaD5aRDdgrJSjPP
         wbQUP8IrW/z9geDFaWZssd35YJTYNz1HNvOVM7kay+Qefeir4VskE55JbljhoiaQomGu
         JUPV01JtaMjeNi0BskwD5l4xMwkB+vnn3DcbvIkFTyR7TINAUwMH9ghXs8oOAE21jjC8
         32Wq+dchcIu6EfUEW2V890DGb4rTvg9NKAnNmzKzmUK1LGIC0VsrzdKZZxgZvaM37YUY
         qe3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fU3F4bcwZp70hCMjLKr900gPyRngGvpL8JmfItxitXw=;
        b=jFyMwoqSf1svY61nL6c51FUp9HldFmlt0Il+kTMeLbAV+dfHO1fzsbUYFr5Brsi4lt
         3+HQoMsJBvOPk/Jq8CnwuglUpA6MHX/nWA1T8CGmk7pXKGTxOuJiiBdeWeW1/cRvJYl8
         orMTZeUmwoVlfNVFj+mqMqU7CK6BOTBwUSzzy8z0MGTKoM7tjjBnRUTZyWVymXygwPNm
         VMvssRpRYYOSDBoaVDG8mTkGrXW0E7Ejjw2KBvrxDEyGNGEFEarj/Pn6VIT2EBfD7z6T
         Mdy4GUky0OYju62a52YyyhRlxq72TtIM0Qbluc6Kjx4vGNB63wSWs3+jDGnm/SbwMOe4
         NdGA==
X-Gm-Message-State: AOAM530m0ts0/NS+e6cUWCuPN1g67eTEULSMtfRy2IfobozjQzwiwZ+9
        mU+vEjibYDjsWfcLgGLNFQHUXwQnCg==
X-Google-Smtp-Source: ABdhPJy82TgKG97EFytIw4Z2eZ3H4ZGXgCIS+e2M1csj4r3yM86mR6UtcW2PtjPq51YumxSsUnLRWw==
X-Received: by 2002:a63:6946:0:b0:405:f5:e914 with SMTP id e67-20020a636946000000b0040500f5e914mr5754201pgc.324.1654952110917;
        Sat, 11 Jun 2022 05:55:10 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id b10-20020a170902bd4a00b00168b7d639acsm1440115plx.170.2022.06.11.05.55.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Jun 2022 05:55:10 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, david@fromorbit.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH 2/2] xfs: use invalidate_lock to check the state of mmap_lock
Date:   Sat, 11 Jun 2022 20:54:45 +0800
Message-Id: <1654952085-13035-3-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1654952085-13035-1-git-send-email-kaixuxia@tencent.com>
References: <1654952085-13035-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

We should use invalidate_lock and XFS_MMAPLOCK_SHARED to check the state
of mmap_lock rw_semaphore in xfs_isilocked(), rather than i_rwsem and
XFS_IOLOCK_SHARED.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8b8bac7eba8c..3e1c62ffa4f7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -365,8 +365,8 @@ xfs_isilocked(
 	}
 
 	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
-		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem,
-				(lock_flags & XFS_IOLOCK_SHARED));
+		return __xfs_rwsem_islocked(&VFS_I(ip)->i_mapping->invalidate_lock,
+				(lock_flags & XFS_MMAPLOCK_SHARED));
 	}
 
 	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
-- 
2.27.0

