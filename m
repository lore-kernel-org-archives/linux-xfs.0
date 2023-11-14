Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476B7C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 01:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbjKNBxy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbjKNBxx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 20:53:53 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C9CD45
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:51 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1ccbb7f79cdso38313025ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699926830; x=1700531630; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Fh3uE8eMbQXl+jds6nLngO0kMMfIRt9g0Eg/S6dtoY=;
        b=Bax+OukgzOGVFx/fvd6A9jANi6ZOH7LAv8//R+X07vzDro/zQJv22LKScmyvBLlZJO
         dnK+veWAyJ4timW0GhGtf0Q+7mRqM7Jp3pwfyFSmwka3XDoykkGh0fctdBzu5+H2OCde
         DFYy1lJreZbJmut/159fKszz8Dq+50MT+OnV3jXi0p/ojDpgGnqi0RB/uBOp32S+pI6G
         O0aVy86iupjqAG6knLnuoHJjE1c1qgIXY01UXVs2KtS5WqgLorEnZ23UzcLSc5kWMEU4
         PECTGzMS4pymTeqe2KKU3vna88fZwUuwhWDm2yoqNIcx80yKXBWbEokfs2M0ZuXM3tck
         +rwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699926830; x=1700531630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Fh3uE8eMbQXl+jds6nLngO0kMMfIRt9g0Eg/S6dtoY=;
        b=BshbGpObdjxhptYbM7aK7sAFoP25xZO/ptcjtVz2cZaX5H4cuuxxtUfsn9tY+1naep
         a8WmuMApATWMULd9lkbH73WeZ8gE/k7Q+/8IjGuVhOa7Kw63Fq9KWq12X7M81asI+X32
         4nw52bNYqbybDMT/D3WHUu+4m0KB22ErEepWu04D9JX0myq27dsIfj1WJaUcwq0EyS17
         ZHOQpsCve0p3IYpa+f36XUCfAV66f3mkCdfHxX1OkcmPglF1klEgdMIDckBevTDS7Yzj
         V/p+72EZ57qubCvoFaa0xH8JPNbIMS+zjTwBPAC5Hp1y48VZ9MuMU02V3DNlh9nUlnz+
         Mmng==
X-Gm-Message-State: AOJu0YxqiTQ4QcRKF0k5atq7C1ENs+6qvt3vnXQrhugf8BMP26iNKAGh
        Ki6ML4DLVv8WvMwcPp8ze4RxURxcIgK/sg==
X-Google-Smtp-Source: AGHT+IFv/duiTN1nk5EmvXpJmiXSp4PN9cAiGRrfbt6p6jkp8q6SdiBnbmeQKonYS/LZXw7+x1kYqA==
X-Received: by 2002:a17:902:704a:b0:1ca:d778:a9ce with SMTP id h10-20020a170902704a00b001cad778a9cemr973048plt.38.1699926830502;
        Mon, 13 Nov 2023 17:53:50 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d177:a8ad:804f:74f1])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902ecd100b001c9cb2fb8d8sm4668592plh.49.2023.11.13.17.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 17:53:50 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com, fred@cloudflare.com,
        Kaixu Xia <kaixuxia@tencent.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 04/17] xfs: use invalidate_lock to check the state of mmap_lock
Date:   Mon, 13 Nov 2023 17:53:25 -0800
Message-ID: <20231114015339.3922119-5-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114015339.3922119-1-leah.rumancik@gmail.com>
References: <20231114015339.3922119-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

[ Upstream commit 82af88063961da9425924d9aec3fb67a4ebade3e ]

We should use invalidate_lock and XFS_MMAPLOCK_SHARED to check the state
of mmap_lock rw_semaphore in xfs_isilocked(), rather than i_rwsem and
XFS_IOLOCK_SHARED.

Fixes: 2433480a7e1d ("xfs: Convert to use invalidate_lock")
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b2ea85318214..df64b902842d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -378,8 +378,8 @@ xfs_isilocked(
 	}
 
 	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
-		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem,
-				(lock_flags & XFS_IOLOCK_SHARED));
+		return __xfs_rwsem_islocked(&VFS_I(ip)->i_mapping->invalidate_lock,
+				(lock_flags & XFS_MMAPLOCK_SHARED));
 	}
 
 	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
-- 
2.43.0.rc0.421.g78406f8d94-goog

