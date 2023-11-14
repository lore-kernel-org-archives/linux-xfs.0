Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 830CCC4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 01:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjKNByH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbjKNByG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 20:54:06 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFD3D44
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:54:03 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1cc316ccc38so39078675ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699926842; x=1700531642; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e7Weq4mcO8egufoNanwWgqHQ/ZlZcVQcelpjA5N9A5k=;
        b=g9VZaK1CHvyvNcwkObqD5JKE+ZWXuBkA+uOKuBaZF+A4oo4OMy6loh4HR3kNTabS2k
         P81KDzi4VF4E6r46U5rqVyOiR5gxLgufjhNcpeLeEFcKLzC7Y6Ertj+bwNd5C9q7vGIu
         tF4WEItitF6PIKPn/RvqKX+us9Vyc8ZoNR+14tTP2XmoE/gQqvyBJH1lmz/FxaWnFun8
         sCt2mT3VNVgG3mv9fyAdeXmTP1ngLDbrpfhEGumi223DVxZdFbUtXs8hEV4LfOYUD4yC
         Dzdv1ISVlHmT+/AP7igQijpjr0N0wcAJbpNrSkdnl7+kZUSNQi+SNfgVcr37H3M/VX4G
         QOgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699926842; x=1700531642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e7Weq4mcO8egufoNanwWgqHQ/ZlZcVQcelpjA5N9A5k=;
        b=tKJYYk6cmzAI6Yy7QzwK9bt3VdWCFilrZUgqV0oQ1voO6AxdOKYZs0XxJPjrBKJBQo
         lM7Y/gdZep2ttDJ8bvuFC6FdzPtSwM7KGsj2RFls2wQDFCBqAm7qIqbcnykOAIzDOWt3
         TwJr5fVAoy6XPUuPAPMOEJ6kfhmPv7zlU8UqGT/ZjZwXs1gtKY3fVB7jeP8N6UtujgaU
         8gnpNUtUy7OEm7R5KU1ASPwXDr+8DYxKP3eiL8j1mlUCsHiysG/U7aQ0+tAN9pBJfE4h
         qzPvjQ4QRhyfNZbL04WLqEOzuQz9WE+w+8ioa/7CB6Xnv4Lgbz89VTibKFYA5+StvSX1
         2K/Q==
X-Gm-Message-State: AOJu0YxO4TRbm7fOL8raQl5Daj1/Uqtl8yYlow6EN3Y7+YiDnZDXqr82
        viV9Wx3xyiTd/juBWlODtOEP74GT5PgV0g==
X-Google-Smtp-Source: AGHT+IH6XsFgt4mmKSzl55D8l7oeHd4a7SGaV1ph/QjbEhWHC3sCrXZOh9UoNL0Vjy3CssaeSma3sA==
X-Received: by 2002:a17:902:9343:b0:1cc:6597:f42c with SMTP id g3-20020a170902934300b001cc6597f42cmr867291plp.21.1699926842575;
        Mon, 13 Nov 2023 17:54:02 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d177:a8ad:804f:74f1])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902ecd100b001c9cb2fb8d8sm4668592plh.49.2023.11.13.17.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 17:54:02 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com, fred@cloudflare.com,
        Li Zetao <lizetao1@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 17/17] xfs: Fix unreferenced object reported by kmemleak in xfs_sysfs_init()
Date:   Mon, 13 Nov 2023 17:53:38 -0800
Message-ID: <20231114015339.3922119-18-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114015339.3922119-1-leah.rumancik@gmail.com>
References: <20231114015339.3922119-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit d08af40340cad0e025d643c3982781a8f99d5032 ]

kmemleak reported a sequence of memory leaks, and one of them indicated we
failed to free a pointer:
  comm "mount", pid 19610, jiffies 4297086464 (age 60.635s)
    hex dump (first 8 bytes):
      73 64 61 00 81 88 ff ff                          sda.....
    backtrace:
      [<00000000d77f3e04>] kstrdup_const+0x46/0x70
      [<00000000e51fa804>] kobject_set_name_vargs+0x2f/0xb0
      [<00000000247cd595>] kobject_init_and_add+0xb0/0x120
      [<00000000f9139aaf>] xfs_mountfs+0x367/0xfc0
      [<00000000250d3caf>] xfs_fs_fill_super+0xa16/0xdc0
      [<000000008d873d38>] get_tree_bdev+0x256/0x390
      [<000000004881f3fa>] vfs_get_tree+0x41/0xf0
      [<000000008291ab52>] path_mount+0x9b3/0xdd0
      [<0000000022ba8f2d>] __x64_sys_mount+0x190/0x1d0

As mentioned in kobject_init_and_add() comment, if this function
returns an error, kobject_put() must be called to properly clean up
the memory associated with the object. Apparently, xfs_sysfs_init()
does not follow such a requirement. When kobject_init_and_add()
returns an error, the space of kobj->kobject.name alloced by
kstrdup_const() is unfree, which will cause the above stack.

Fix it by adding kobject_put() when kobject_init_and_add returns an
error.

Fixes: a31b1d3d89e4 ("xfs: add xfs_mount sysfs kobject")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_sysfs.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index 43585850f154..513095e353a5 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -33,10 +33,15 @@ xfs_sysfs_init(
 	const char		*name)
 {
 	struct kobject		*parent;
+	int err;
 
 	parent = parent_kobj ? &parent_kobj->kobject : NULL;
 	init_completion(&kobj->complete);
-	return kobject_init_and_add(&kobj->kobject, ktype, parent, "%s", name);
+	err = kobject_init_and_add(&kobj->kobject, ktype, parent, "%s", name);
+	if (err)
+		kobject_put(&kobj->kobject);
+
+	return err;
 }
 
 static inline void
-- 
2.43.0.rc0.421.g78406f8d94-goog

