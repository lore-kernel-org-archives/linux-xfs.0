Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0CEFC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 15:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A767C619CF
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 15:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhC3P6T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 11:58:19 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:53128 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbhC3P6H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 11:58:07 -0400
Received: by mail-wm1-f45.google.com with SMTP id d191so8658335wmd.2
        for <linux-xfs@vger.kernel.org>; Tue, 30 Mar 2021 08:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rVyYeW3X2uusqqVNrZqVWrFDZ5umfclHle9H04qtGDs=;
        b=O6PIqadFnTSrYhXI2nw1n0FTgr+FxMeSdHBUL5BLoWD64KlA4QZyIurcSG9iwHO8LT
         Y+vnE0oTpm2gw6WK1QjvmowDcNjmk4iW5eJxL09cCGP1o/SI11uzo5nehqYWbeenKOt7
         rbQ5+mRXV7rCVT2by34iv728XgkL0LdZsNBCcRt1uAo2yBZ1socniqhedhXgGE85PVBa
         209w/s5xxARZl5mkIejowdXEEMIO+z/XMzLODEso9vqpVNw+K621wPtQb147/J31GMZ3
         ZdU0SXbHwXCxF/weUr3iOwWZPhEYZdDugTKrdCAeG3YjC191I4fyq5yp4c4B6Cfyg6Z4
         bliQ==
X-Gm-Message-State: AOAM532QNsc4xDCCiPxTUXHi+8cDuxHQaM1nbaKG9sCxQe+JQkIjKX9Z
        8PDddJyKA2Bexhb3JcEbFXqIJZOXaDQCud8q
X-Google-Smtp-Source: ABdhPJwzK3nH7y6b/mMJKDMGMCjjYozIShwnvL0vBYe8gONVt3SSIsGh1Z4+0AuLeo+omJgA6Q9T1Q==
X-Received: by 2002:a1c:b0c4:: with SMTP id z187mr4627919wme.81.1617119886501;
        Tue, 30 Mar 2021 08:58:06 -0700 (PDT)
Received: from rhea.home.vuxu.org ([2a01:4f8:c010:17cd:ea6a:64ff:fe4d:ff9e])
        by smtp.gmail.com with ESMTPSA id n4sm3997756wmq.40.2021.03.30.08.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 08:58:05 -0700 (PDT)
Received: from localhost (rhea.home.vuxu.org [local])
        by rhea.home.vuxu.org (OpenSMTPD) with ESMTPA id ff603842;
        Tue, 30 Mar 2021 15:58:04 +0000 (UTC)
From:   Leah Neukirchen <leah@vuxu.org>
To:     linux-xfs@vger.kernel.org
Cc:     leah@vuxu.org
Subject: [PATCH] xfsprogs: include <signal.h> for platform_crash
Date:   Tue, 30 Mar 2021 17:57:42 +0200
Message-Id: <20210330155741.17193-1-leah@vuxu.org>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Needed for kill(2) prototype and SIGKILL definition.
Fixes build on musl 1.1.24.

Signed-off-by: Leah Neukirchen <leah@vuxu.org>
---
 include/linux.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux.h b/include/linux.h
index 7bf59e07..a22f7812 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -18,6 +18,7 @@
 #include <endian.h>
 #include <stdbool.h>
 #include <stdio.h>
+#include <signal.h>
 #include <asm/types.h>
 #include <mntent.h>
 #include <fcntl.h>
-- 
2.31.0

