Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E9EC5ACB2
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 02:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344560AbjKPC27 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344553AbjKPC25 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2023 21:28:57 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957A9127;
        Wed, 15 Nov 2023 18:28:54 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1cc316ccc38so3295555ad.1;
        Wed, 15 Nov 2023 18:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700101734; x=1700706534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pgc3h0AwqHUrwPpFzWFi4BDhnxjKsHQVu3SzDC/FvdM=;
        b=EoUGXA2uPhPb+/0rjsK2OQcblVI5tZCzS1weCNuTm55Y7vC9yAHOWACmTvsh0r8tey
         GPdq1q5tCuIWx5hvyRZsWjxYr1xfTIcZzrwggoSIg8CTxWzaRkoj+n6HpdXYtKdLf6r6
         0wnsNzDMHv8+gZhV1g40x2gM1Y2rbqz7F3uhtI/4V3IF3nLAbQu2FwWbVwpx9XN4t+VU
         ww/bdtkIRr+nev8PmRYL2bNoMn5vVyVC89VGRTS3v8hCQm+y9lCxjzaNPhbPKjT0qyNF
         lugZF5zyxiUwYoxwPiLh81srJz1z4yeTcQZFlC54p8xyMQA+g6Sg/UIxlOTmVqesG9yx
         zX8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700101734; x=1700706534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pgc3h0AwqHUrwPpFzWFi4BDhnxjKsHQVu3SzDC/FvdM=;
        b=AH9MI0PDy+/L/jU+5d2dBMS/swTeZt9PLC6/+7lokJ0XToH1MaeDz736rvnc+H3Drq
         Z2heL35blxea2wybWoWaARQIbetiSGfaWkhszagqA/cXOcu9VP/zrEJC+ghJKdLibdzu
         OsuSU4DTQ1MlDaLgAo4ZNwVR6aFC0YSYxUWa4C0oeJphD0x9XL6fXKRstgVTr52TxrCy
         9VpmFj5BEQwLc4ZskatHx8Zjr8NRQ7pONYoNOYFfDL1m2MfLkVvQFbqoD+xHiHFtK64P
         GqZWHAptxyIqsCHCgMBwvJPQgubQeVvA4vttVAAw7jSZLzYpoIvjNtaMQNVCI2h93rnZ
         7ojw==
X-Gm-Message-State: AOJu0YyYt9M6Gm54hKB8SwQ4YBdX2FpOoMtLzu3PXpK2O/PhInORNFxz
        SxApFGeo2W4deS7soghCQovGqZBXl/7l5g==
X-Google-Smtp-Source: AGHT+IGKW0US3/3TcQtWvhZcv7qboZm/tyeGt5FpR7AOLHf7lzjqbqa/yOWkJY/yiLXEegNj3Nh8VQ==
X-Received: by 2002:a17:903:22c2:b0:1cc:478c:2f32 with SMTP id y2-20020a17090322c200b001cc478c2f32mr9532778plg.0.1700101733927;
        Wed, 15 Nov 2023 18:28:53 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:25ea:d6bb:623c:d6a0])
        by smtp.gmail.com with ESMTPSA id j9-20020a170903024900b001b8b1f6619asm8087072plh.75.2023.11.15.18.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 18:28:53 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, fred@cloudflare.com,
        Zeng Heng <zengheng4@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.15 16/17] xfs: fix memory leak in xfs_errortag_init
Date:   Wed, 15 Nov 2023 18:28:32 -0800
Message-ID: <20231116022833.121551-16-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231116022833.121551-1-leah.rumancik@gmail.com>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit cf4f4c12dea7a977a143c8fe5af1740b7f9876f8 ]

When `xfs_sysfs_init` returns failed, `mp->m_errortag` needs to free.
Otherwise kmemleak would report memory leak after mounting xfs image:

unreferenced object 0xffff888101364900 (size 192):
  comm "mount", pid 13099, jiffies 4294915218 (age 335.207s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000f08ad25c>] __kmalloc+0x41/0x1b0
    [<00000000dca9aeb6>] kmem_alloc+0xfd/0x430
    [<0000000040361882>] xfs_errortag_init+0x20/0x110
    [<00000000b384a0f6>] xfs_mountfs+0x6ea/0x1a30
    [<000000003774395d>] xfs_fs_fill_super+0xe10/0x1a80
    [<000000009cf07b6c>] get_tree_bdev+0x3e7/0x700
    [<00000000046b5426>] vfs_get_tree+0x8e/0x2e0
    [<00000000952ec082>] path_mount+0xf8c/0x1990
    [<00000000beb1f838>] do_mount+0xee/0x110
    [<000000000e9c41bb>] __x64_sys_mount+0x14b/0x1f0
    [<00000000f7bb938e>] do_syscall_64+0x3b/0x90
    [<000000003fcd67a9>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: c68401011522 ("xfs: expose errortag knobs via sysfs")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_error.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 81c445e9489b..b0ccec92e015 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -224,13 +224,18 @@ int
 xfs_errortag_init(
 	struct xfs_mount	*mp)
 {
+	int ret;
+
 	mp->m_errortag = kmem_zalloc(sizeof(unsigned int) * XFS_ERRTAG_MAX,
 			KM_MAYFAIL);
 	if (!mp->m_errortag)
 		return -ENOMEM;
 
-	return xfs_sysfs_init(&mp->m_errortag_kobj, &xfs_errortag_ktype,
-			       &mp->m_kobj, "errortag");
+	ret = xfs_sysfs_init(&mp->m_errortag_kobj, &xfs_errortag_ktype,
+				&mp->m_kobj, "errortag");
+	if (ret)
+		kmem_free(mp->m_errortag);
+	return ret;
 }
 
 void
-- 
2.43.0.rc0.421.g78406f8d94-goog

