Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 017DCC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 01:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbjKNByG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbjKNByF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 20:54:05 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67905D43
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:54:02 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1cc4f777ab9so38444515ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699926842; x=1700531642; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hUGX3VgFsnNHZC9R3rbXJYOY523PFQ3Z8gGKhkElgwg=;
        b=l8yZFMVlR3Au0a5PuYXGOcoNIeiSNVHEKVSyF+IFaORw5ht7+iKSPBaG9G1HmqmLSc
         fbRTPv5InhdgtqbtWL6PCn+44z4YfyYbwZiZCUPq1MR9Xi0rjqk/WUb4BgYRAUaflPoJ
         ZyGdpNtlT9G+FxlnEkw6AnxFJpebmRxzNkLoyxEbcHu5opMznSf27hiRxrpBH9QXQKdP
         bzrsN+b/j7L/C6/cW7/Of1M+txBQFBAsz7UWCzwieQt0dfdDYlbQfbn3EejDhsVZgIe0
         9nC3W6YVFnEEq3xHM/sIB0pDZcv332r2jf7hCaHh5tTO9hYhL4hxjgDg6gI6LJu669r1
         my/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699926842; x=1700531642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hUGX3VgFsnNHZC9R3rbXJYOY523PFQ3Z8gGKhkElgwg=;
        b=LIQnxjlX0atHXjfKbQTQ+paaanIjvk6ZD9niISRuq/GM6zOG+p4imzO9i7tf53SR2/
         8Y2PKZK4uzOqOmqxyRVz4QVB3P91IvyftHjNgj4cexGafqLnxs1sOTJAPUUbqOrPlf0q
         RdwkhaxF62WkvtMwY3KP+tGiFPiWKPSTjF5BX3LUdIzTb0nUzaGQWVWhpEgd+hYq+o1u
         Td9OsK4ax6dHcQDtqtg0usy9lHJw3uE/AzGC9RFeoKNhsL9b63tdIxYk3oCtusuF3xEA
         RFltymQYTICWwI51sjBU+i5GSNmVNr6FxQT9ReI4pXTkVFkWVvmEO7buclOmGB5TWa2F
         rtUg==
X-Gm-Message-State: AOJu0YyvUglRtkuCnd3Fh0PqqwK0sjupnmsEK0CAIoBMnA+kQbHb7bEZ
        oXQDRS/dKP0s3mGe9Q2Lw1KeGOvZOyO5fA==
X-Google-Smtp-Source: AGHT+IFLcvMabqelLpN6wbScfkRsqJ++8AXUqODX8OVvI8WSHP12yR4rdWMfpbmBI6SpR0pKsyXeTg==
X-Received: by 2002:a17:902:8603:b0:1cc:449b:68a8 with SMTP id f3-20020a170902860300b001cc449b68a8mr1017872plo.46.1699926841731;
        Mon, 13 Nov 2023 17:54:01 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d177:a8ad:804f:74f1])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902ecd100b001c9cb2fb8d8sm4668592plh.49.2023.11.13.17.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 17:54:01 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com, fred@cloudflare.com,
        Zeng Heng <zengheng4@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 16/17] xfs: fix memory leak in xfs_errortag_init
Date:   Mon, 13 Nov 2023 17:53:37 -0800
Message-ID: <20231114015339.3922119-17-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114015339.3922119-1-leah.rumancik@gmail.com>
References: <20231114015339.3922119-1-leah.rumancik@gmail.com>
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

