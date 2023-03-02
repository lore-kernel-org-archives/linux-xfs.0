Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660A3C678D4
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Mar 2023 20:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjCBUfb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Mar 2023 15:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjCBUf1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Mar 2023 15:35:27 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B13F3B3D6
        for <linux-xfs@vger.kernel.org>; Thu,  2 Mar 2023 12:35:25 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id h17-20020a17090aea9100b0023739b10792so232457pjz.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Mar 2023 12:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677789325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=haZ42m0/l8xy8tqqGax15bMFS6+aIr3FtSypMBK7kbk=;
        b=hDSNVZK62lBg8np2+PDAEugUgzwPO6m8aaN0X6YnPVYZFWYrx4yMXZnJb+hmYhPPrF
         y87iy7IogyoGa0tLPaPYB0XOOuBfL84AQLGX99bkXDZTzEuLLEJcxtS1Lbd9xSgV6tUU
         qjEZMV3+dKc5MwAfDX9yspIuIjCQBA8xhNJnBDQLqZmIFaWaPMXBGNzmGtTjwqw6AE3c
         zoUuSu6ES7TaYQRz+6UrCVfE+MjjEQrkvL8oFnoiaECzfEn45zqTHe31r+YxCICucm3o
         ODBHFMYBp0m/bR1ne1SJUb6V6DmjSYB7CAWD+JrRxlkH6tYnnBM5kU/cJO2YWvu5RJTG
         5hZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677789325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=haZ42m0/l8xy8tqqGax15bMFS6+aIr3FtSypMBK7kbk=;
        b=63/pQNfXx9mPOLlSdWWyYqEwG21Oj+3jC6phEqKC2QxT19drfkKJdqtrilQ2/yUYQq
         ECtGRr7D41rG+kAgiYIOKMxEY+eWKtxaB3kTrDYnfTkDsZH4LJukHTQD8W+Zj76Djncw
         uiUQDFUX2D8UHgghViZs9ZJBoba1QBjfOn4v7rPctEA0lrXRgQS7N2OWmlx40dSd9QM3
         OBI82vpGzmU3cTC1if8Rv+29S+6xQn6m+0WgcUhsrxA+EnCH3WH61B2nKtt48eTePnlR
         iGKMHxLEzOSRupQ4Nz80WCN6rr/rV6UFoSiMDus/wPmONGW3vCelHKAawKMsyheBC7YK
         xRsg==
X-Gm-Message-State: AO0yUKXYd+aWvRgGOY1i7VDiT2Dp3fcEZvDvs0wjtO73cf/bs0+k3JMw
        0bx+oFa/VWfu4dvv9fLK3+1VLgeMYto4bQ==
X-Google-Smtp-Source: AK7set8WWb5h0X75vPpeSLGGn+361Z2gsHEmQo/zPL7LMf99IIv7wyrRrfU9nZ7eiWwySYuBUBGNVw==
X-Received: by 2002:a05:6a20:7f8c:b0:bf:8ee2:2009 with SMTP id d12-20020a056a207f8c00b000bf8ee22009mr4411881pzj.26.1677789325029;
        Thu, 02 Mar 2023 12:35:25 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:637a:4159:6b3f:42eb])
        by smtp.gmail.com with ESMTPSA id b13-20020aa7870d000000b005ac86f7b87fsm113459pfo.77.2023.03.02.12.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 12:35:24 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Christian Brauner <brauner@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 08/11] fs: move should_remove_suid()
Date:   Thu,  2 Mar 2023 12:35:01 -0800
Message-Id: <20230302203504.2998773-9-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230302203504.2998773-1-leah.rumancik@gmail.com>
References: <20230302203504.2998773-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit e243e3f94c804ecca9a8241b5babe28f35258ef4 upstream.

Move the helper from inode.c to attr.c. This keeps the the core of the
set{g,u}id stripping logic in one place when we add follow-up changes.
It is the better place anyway, since should_remove_suid() returns
ATTR_KILL_S{G,U}ID flags.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/attr.c  | 29 +++++++++++++++++++++++++++++
 fs/inode.c | 29 -----------------------------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 686840aa91c8..f045431bab1a 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -20,6 +20,35 @@
 
 #include "internal.h"
 
+/*
+ * The logic we want is
+ *
+ *	if suid or (sgid and xgrp)
+ *		remove privs
+ */
+int should_remove_suid(struct dentry *dentry)
+{
+	umode_t mode = d_inode(dentry)->i_mode;
+	int kill = 0;
+
+	/* suid always must be killed */
+	if (unlikely(mode & S_ISUID))
+		kill = ATTR_KILL_SUID;
+
+	/*
+	 * sgid without any exec bits is just a mandatory locking mark; leave
+	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
+	 */
+	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
+		kill |= ATTR_KILL_SGID;
+
+	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
+		return kill;
+
+	return 0;
+}
+EXPORT_SYMBOL(should_remove_suid);
+
 /**
  * chown_ok - verify permissions to chown inode
  * @mnt_userns:	user namespace of the mount @inode was found from
diff --git a/fs/inode.c b/fs/inode.c
index a71fb82279bb..3811269259e1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1864,35 +1864,6 @@ void touch_atime(const struct path *path)
 }
 EXPORT_SYMBOL(touch_atime);
 
-/*
- * The logic we want is
- *
- *	if suid or (sgid and xgrp)
- *		remove privs
- */
-int should_remove_suid(struct dentry *dentry)
-{
-	umode_t mode = d_inode(dentry)->i_mode;
-	int kill = 0;
-
-	/* suid always must be killed */
-	if (unlikely(mode & S_ISUID))
-		kill = ATTR_KILL_SUID;
-
-	/*
-	 * sgid without any exec bits is just a mandatory locking mark; leave
-	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
-	 */
-	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
-		kill |= ATTR_KILL_SGID;
-
-	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
-		return kill;
-
-	return 0;
-}
-EXPORT_SYMBOL(should_remove_suid);
-
 /*
  * Return mask of changes for notify_change() that need to be done as a
  * response to write or truncate. Return 0 if nothing has to be changed.
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

