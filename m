Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6B5C76195
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 11:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjCQLIo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjCQLIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 07:08:43 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEF729E2B
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:41 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso3058726wmo.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679051319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hNVncBi+eLx3DXaqCOJRdjKPPS5ZKYBqno7LFhDYHyo=;
        b=YsxpE5jN4uNyxuhxOsd0x5Y2hiJVHXeCd7G5CZqPWNkwYZh0SyWJ1CAF/izDcqvO7A
         Q2twQKM9TZO6uPp45oiD4I8V/t5G33CtjmBq+F8goCWDYRwMrixwLzlUSajMOW/JaL2i
         KuXJ96s8m0RhlzJyvBb+20OORP8krQvDU0k+vbLRbZLIp+UUrR3NOtneo7gsOBBMxftI
         QISJfGvq8j4T+1pM3GskhL0htICfX6txK91DaFbdH6FmXKiyYynRArsqMDgbfT4IlWiI
         5F5KFHSAA2bZi5hVBE+GTonFm+dKnP3Zqr/FFw5io+MXw46Otr0N2l2cJs4gLKtuoXs3
         TNFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679051319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hNVncBi+eLx3DXaqCOJRdjKPPS5ZKYBqno7LFhDYHyo=;
        b=cmmVPWa36sLMvieF0QySX8AGcaKn8WQGEZ6o6/CmhgiTTycAt1PhIWOV+gz1ykzK0u
         jvFW3S4Zqr3gWKU4zO36iTnRm+P6FlTNHQ3boTXGN8nNmj3t9f1lQ011/mm4fiIovia2
         ImAEa7ipcTNBGHKBK5uAhq15F4k4b95VGhMV4qGia2ier80c40p46YVb9vOWQn2oZM4D
         se1C9YJoqItLezqOYlQKUGvdqr6ARlL8wQbRrC+wBImSLRcUD7xZVq/BcG2Vs/ELnbqa
         w5cG0yORbhlNPBBOmntltRfPAuGecRIC8xjFH3G8XTfjbTrlLv71M5JiN4XlIJGBDFI/
         W0tQ==
X-Gm-Message-State: AO0yUKUIQL17gRFbl5rrG+Bh3U5xfMb4ptIY+q35/inBGottRFgWsBCo
        SUIY7uUpIz1aCNWvoov61Ik=
X-Google-Smtp-Source: AK7set9lTwE5I1Qf6JIF1R0lPD4xYk0R9WrFg1rjtj+PF6qBoN4xwCKB52OF13UE7J1VcOqPSqA0KQ==
X-Received: by 2002:a05:600c:21c6:b0:3ed:775e:5257 with SMTP id x6-20020a05600c21c600b003ed775e5257mr2059800wmj.35.1679051319499;
        Fri, 17 Mar 2023 04:08:39 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t14-20020a1c770e000000b003daf7721bb3sm7551100wmi.12.2023.03.17.04.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:08:39 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE 11/15] fs: move should_remove_suid()
Date:   Fri, 17 Mar 2023 13:08:13 +0200
Message-Id: <20230317110817.1226324-12-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317110817.1226324-1-amir73il@gmail.com>
References: <20230317110817.1226324-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

commit e243e3f94c804ecca9a8241b5babe28f35258ef4 upstream.

Move the helper from inode.c to attr.c. This keeps the the core of the
set{g,u}id stripping logic in one place when we add follow-up changes.
It is the better place anyway, since should_remove_suid() returns
ATTR_KILL_S{G,U}ID flags.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/attr.c  | 29 +++++++++++++++++++++++++++++
 fs/inode.c | 29 -----------------------------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 300ba5153868..666489157978 100644
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
 static bool chown_ok(const struct inode *inode, kuid_t uid)
 {
 	if (uid_eq(current_fsuid(), inode->i_uid) &&
diff --git a/fs/inode.c b/fs/inode.c
index 63f86aeda7fd..f52dd6feea98 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1854,35 +1854,6 @@ void touch_atime(const struct path *path)
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
2.34.1

