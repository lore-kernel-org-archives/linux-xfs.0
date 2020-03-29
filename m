Return-Path: <SRS0=WYbU=5O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE92C43331
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Mar 2020 11:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A019B20675
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Mar 2020 11:03:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oq70FMGZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgC2LDp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 Mar 2020 07:03:45 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:35018 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbgC2LDo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Mar 2020 07:03:44 -0400
Received: by mail-pj1-f65.google.com with SMTP id g9so6014624pjp.0
        for <linux-xfs@vger.kernel.org>; Sun, 29 Mar 2020 04:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=v093eOw0Z1ABTduePqCbnnlKZVbj+DV/zfZdoot3V2c=;
        b=oq70FMGZ92Itwm9UoJYvCEev/tXC9SFtkka69bq6lEOaXJr7/1RSTZNjxPJi+JCdcb
         gyywsYEvG7t7Ce3QCU4r2caLQPRy7GrZT2HDBFuEm8aW761JAUGVGojpOcjtjMVmx1HM
         km6TREDA9jFGiD1zyaw0I0yBFokZP3hyW75mYKHaPGl+571jrGZutz+hb2/uE8uV/QRx
         0Bx3bqenjY+HxxoejeOWHp5w5qlj3v2Lj+QLlureuDJm7yk2zs5IXHasYQjPvL/7m39h
         uz/2IVVPMCXqdAkoS7ntecJFHoQ8wvtLVI8TQPGrsudfQkKLPGXTDoXQQKznnT0wlkzu
         S9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=v093eOw0Z1ABTduePqCbnnlKZVbj+DV/zfZdoot3V2c=;
        b=Yeam0yU/DwkF9ivRcdY2al1x63rT0KMrcnj2dGTKhg04ZFUC4T//63RN88pR/B3MZM
         WxFzh0mSsiAmLBaB+CcTyazNKOhkHZUD5Nl0a4k3UHfy5ODd0BMVfY/gyQ/fcq54BaLP
         o8YQdMcRUly2yPHnoox7X2Khdu44nDnvqKly8xrDM9V9tR/qIkO5FjSTVOoNbWwpyTXX
         nj2m1dbJCUIV37N1gU+ZGoy53b/mpUPERPBUj9FooWzdgAKS/pouGFtPUczjUSU686dR
         o03+m9SXsZbBKTnrhAF+JAFU9RHZoAtBPLIWO6NZRrojW8haWu5rVA3IpNis/OhJNLX3
         jozA==
X-Gm-Message-State: ANhLgQ3wnbUgwr1RRK0nZvL7O24TdZlWnVKkB3Dohh3lW7Lgu+C6ThEt
        mO/OSy1xLSyL4isYlkhnm8BxRLA=
X-Google-Smtp-Source: ADFU+vthcYihDuLvJCKduxqtJH/ZhtVqS1WY/y0BfWMEzKqmKwTY1fGBD5yUU7Fm8mERuzYJOUklAg==
X-Received: by 2002:a17:902:724c:: with SMTP id c12mr7918968pll.211.1585479823353;
        Sun, 29 Mar 2020 04:03:43 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id 185sm7770630pfz.119.2020.03.29.04.03.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Mar 2020 04:03:42 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: remove redundant variable assignment in xfs_symlink()
Date:   Sun, 29 Mar 2020 19:03:35 +0800
Message-Id: <1585479815-13459-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The variables 'udqp' and 'gdqp' have been initialized, so remove
redundant variable assignment in xfs_symlink().

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_symlink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index d762d42..3ad82c3 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -176,7 +176,6 @@
 		return -ENAMETOOLONG;
 	ASSERT(pathlen > 0);
 
-	udqp = gdqp = NULL;
 	prid = xfs_get_initial_prid(dp);
 
 	/*
-- 
1.8.3.1

