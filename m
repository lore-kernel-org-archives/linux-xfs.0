Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD957C5AE5E
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 02:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344570AbjKPC3A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344546AbjKPC27 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2023 21:28:59 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA8B1A3;
        Wed, 15 Nov 2023 18:28:55 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1cc3216b2a1so3216855ad.2;
        Wed, 15 Nov 2023 18:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700101735; x=1700706535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f/8p2nh/EQfm8BLQl1x9/gVeam8E7sG95xahOTM0H18=;
        b=if61hywGcrqmHXS2fPCZMSjZNTr3MuUj985yS6DszteixahQkwwTFQCy7VC7WcZtdG
         IhZP1umSdX4DzlmW+SIpNR0DV4A/RVP63sAa1GaT20N5zXP+UZpBSaruhTTHYuGKq9C8
         JcAsLTzHqJ3hKAsmjK2MA3+h/Sk50CGsHU0trtYaEpnQDx0WqgUXQS9MR0R0le5wXTaE
         +hxdFNn5xIfmi6hjChKKloXwUGjDUcPY4Kg1+980O89WnjngCXDAcSlxmCRZ1allPTJz
         +TkcMUPxzr0xEJBOL748D/Gm3RCCVQulxEN4y8N6swQ1nh0Dxv5l1w4JvIcqyZgAdEnc
         nSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700101735; x=1700706535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f/8p2nh/EQfm8BLQl1x9/gVeam8E7sG95xahOTM0H18=;
        b=hZtZmY5ItVMBZPgDGWTAoEuZ8LtasQvC+N4ji6UVw2vGcaJ6Fn+iiH3bn967/L+tv1
         8W3bT2whgqa7qS+B1JQ9HKCloTdfCuQhLnPTsGDIa9o8J7JzNmSyW62Z5bUmlLe4Bjdl
         CqSZa0797ZDm0PNkM5yFkHNoYz8OsChNc0y4IUgSsnjsAI8INQ/cQxxT1Yl+9s9NTHmg
         2yFQmCPn7+WENWvflzdvSIyrxdShlk6OvuE2JkSbMpjUkNrqdyscnBriTmlEGjhyG6Sd
         DMJ7lNfjJPKDHaek2k4bn3ZjXe2Wx6e2HF/s76P0f4aHkzoUQ7MfNZbApdrj7SkPJBUh
         m+ww==
X-Gm-Message-State: AOJu0Yw9gclGkGmWV6SwkacCkzfvv4txQ3v5RYAfC0P1Gopt1LcU80Fg
        bu0K2W34Uj3/HPn+uNP4hAvMxn+8pZaXjA==
X-Google-Smtp-Source: AGHT+IEQ7+lKkehv/x32iIi/VNyuM+LyvF/M0Ub9TdMznYeF4+z8Fnc8V3xEBv9NFBcQnQ5kQzlXKw==
X-Received: by 2002:a17:902:e88a:b0:1cc:50ed:4931 with SMTP id w10-20020a170902e88a00b001cc50ed4931mr7396075plg.16.1700101734868;
        Wed, 15 Nov 2023 18:28:54 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:25ea:d6bb:623c:d6a0])
        by smtp.gmail.com with ESMTPSA id j9-20020a170903024900b001b8b1f6619asm8087072plh.75.2023.11.15.18.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 18:28:54 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, fred@cloudflare.com,
        Li Zetao <lizetao1@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.15 17/17] xfs: Fix unreferenced object reported by kmemleak in xfs_sysfs_init()
Date:   Wed, 15 Nov 2023 18:28:33 -0800
Message-ID: <20231116022833.121551-17-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231116022833.121551-1-leah.rumancik@gmail.com>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
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
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
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

