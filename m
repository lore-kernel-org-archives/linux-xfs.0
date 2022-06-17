Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE12C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 02:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbiFQCbH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbiFQCbH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 22:31:07 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967CF64D37
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 19:31:06 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id k5-20020a17090a404500b001e8875e6242so3000827pjg.5
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 19:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fU3F4bcwZp70hCMjLKr900gPyRngGvpL8JmfItxitXw=;
        b=YZ1T+WkUtCd1jT1mYCSaUlL7TGNZ5XEi7l4Zzl7HYyYX1WzDbJvklCZS77fSKdiSBJ
         LQNZM6DaAef2aMdq63uzAtgpJ9ltwy23QfAGYqwhZLYK0OVzDb4Dec21iqfOOlDIcd7Q
         IIoDY07nZPCuQOCSr1vHCvBPIKGRN66ex7JW3m/z3NHw879FR7Q40i/Cfx6NvADo7kWM
         bkOgBxvm5lP9U36060gQhFxXnBdCVzgtZh/A/+CmiESVIj0I0p23IZYR10njtnzHWShz
         /cHtSUNSyXhWPdN5geQsLYLap5vR7YW64suIG16Bpe/5VqKp1RwKz7e9o7z/TR93a3/2
         yVkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fU3F4bcwZp70hCMjLKr900gPyRngGvpL8JmfItxitXw=;
        b=pkxpLiJUG1BYUI3TZc3SvGZnb8+YEKj6tzYP6SB6ZaEaRlKYeuHLaWM160L2fIGDEL
         NhjEju1crYoWVWhmlEyTs7+7XhZW8YSpA4WyDtMt6A7tOxlYaxS0rWrF4wAhr6c60FZn
         x+LYPgprf121NO1DrtCHPiP8Jo5lc2gvZnYtXJk9mQgQOvWkJfJR6wnh/ht3cLMMKDev
         1avfG8bbqDBhA6Lx7d+DD6pqJdaniDca3zRCUv8Cc02BHVbV8Ga7N0HcSHh1sEwOaESB
         LYRJ2HWkt/ok0lEB+kwF6X1r33Mg3FrIFO9TTmMEh73iFEQkny3fmJuignbQBglL/SSi
         ETzg==
X-Gm-Message-State: AJIora9l4UPCiA+kO4fvgsy60J4MJm27kfgQLoEKXGm0DfCXkz3w2R0t
        H6ibs9cKgZ1tePyaXXlHE7CyuOnuJA==
X-Google-Smtp-Source: AGRyM1u8fbXxxfMNE0NECxZwX/y1EAoLBnzebbAu+xX3O9hnZ6nLMx7UdBv6kDzSdxquHzEUeVFlLw==
X-Received: by 2002:a17:90b:4c44:b0:1e8:6ed8:db56 with SMTP id np4-20020a17090b4c4400b001e86ed8db56mr19201096pjb.202.1655433065884;
        Thu, 16 Jun 2022 19:31:05 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id u1-20020a170903124100b0016892555955sm2282654plh.179.2022.06.16.19.31.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jun 2022 19:31:05 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, david@fromorbit.com, hch@infradead.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [RESEND PATCH 2/2] xfs: use invalidate_lock to check the state of mmap_lock
Date:   Fri, 17 Jun 2022 10:30:34 +0800
Message-Id: <1655433034-17934-3-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1655433034-17934-1-git-send-email-kaixuxia@tencent.com>
References: <1655433034-17934-1-git-send-email-kaixuxia@tencent.com>
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

