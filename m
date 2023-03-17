Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2824FC6FD1D
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 11:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCQLIm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCQLIl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 07:08:41 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E02298D8
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:39 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id bh21-20020a05600c3d1500b003ed1ff06fb0so3043720wmb.3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679051318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eatdB0z21nbZqAoMxbWVck3KnIwW4SpkowjlzDGzwpw=;
        b=E+wZztEvhoP/kHQMt48w3RP4c1QnDiZUB+6wBcJpgAToIZ4XGecWMZC+tYuSoYoT/2
         OeCCOmT+m1EewdfIeoTzfwnjvftz5v1ze0ZLwVeaMF5Ub8OHr5lhMii03VviZPkG6nwb
         CTHYAHRd+6Lz/icknm/O+g5jmv7jsBB30fH2wRFMXe/eE+kQu/KK+aD+NaPxH99dzMyD
         LdaBF+LfgwRBOpAXV/xCVxcD1c4Oyp8+LD9gMrtGNzvSephttjvTJfe8B8Cu8YH62OkS
         lbUgXtnf2snfM3eMP4fnT8BDOmzDws0OFHPorPiax/yO+p8FrlXHzDrhenUq0Wu5TgDL
         gLTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679051318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eatdB0z21nbZqAoMxbWVck3KnIwW4SpkowjlzDGzwpw=;
        b=VSuW365W1CVy4RlUxTtHC7p2jJdiaIASUflZ4qV5mmEmYoWkceRjHg0JUsleEnR7ul
         AtOrjQw0RklhjwBrMG03yuBqldnoDdIKQdZjy9vO0tiylg1zu+hHWWrlFyLBIPpwNMSl
         7sHkMc+4LLuMjJ/mZ3Y72qXZQFxdErE9Eig5uPb3mOZWQBQHEwG5oAYb6/N1KgRpkT3H
         kS0AniYWzpcexII3/SYazk3CYKWfgdZFmoia0Uu51pTPlpbqL6N9GObjBihsLSKnqUet
         Ww40maJlIBXBH5nSqP/AWU6AEbCskAtbMNdXozJs0i1i28IxS6vzwD5tWhgqo7G3LGjX
         Shww==
X-Gm-Message-State: AO0yUKUTV4n8SYoSCD9QCHliktF0n3cNaH6NIPsf1hlholyWbTyVLpuW
        LZeVYHZeS9ba4oKjtyVRE/k=
X-Google-Smtp-Source: AK7set8Gg4lF9jV0r22/bJ39qf0w0SUeLy0jxJSdKdfoJj4frNwZ9hPf1fxJubYe/3PV8NdI2wkk+w==
X-Received: by 2002:a05:600c:5487:b0:3ed:418a:ec06 with SMTP id iv7-20020a05600c548700b003ed418aec06mr6446652wmb.28.1679051318173;
        Fri, 17 Mar 2023 04:08:38 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t14-20020a1c770e000000b003daf7721bb3sm7551100wmi.12.2023.03.17.04.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:08:37 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE 10/15] attr: add in_group_or_capable()
Date:   Fri, 17 Mar 2023 13:08:12 +0200
Message-Id: <20230317110817.1226324-11-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317110817.1226324-1-amir73il@gmail.com>
References: <20230317110817.1226324-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

commit 11c2a8700cdcabf9b639b7204a1e38e2a0b6798e upstream.

[backported to 5.10.y, prior to idmapped mounts]

In setattr_{copy,prepare}() we need to perform the same permission
checks to determine whether we need to drop the setgid bit or not.
Instead of open-coding it twice add a simple helper the encapsulates the
logic. We will reuse this helpers to make dropping the setgid bit during
write operations more consistent in a follow up patch.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/attr.c     | 11 +++++------
 fs/inode.c    | 25 +++++++++++++++++++++----
 fs/internal.h |  1 +
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 848ffe6e3c24..300ba5153868 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -18,6 +18,8 @@
 #include <linux/evm.h>
 #include <linux/ima.h>
 
+#include "internal.h"
+
 static bool chown_ok(const struct inode *inode, kuid_t uid)
 {
 	if (uid_eq(current_fsuid(), inode->i_uid) &&
@@ -90,9 +92,8 @@ int setattr_prepare(struct dentry *dentry, struct iattr *attr)
 		if (!inode_owner_or_capable(inode))
 			return -EPERM;
 		/* Also check the setgid bit! */
-		if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
-				inode->i_gid) &&
-		    !capable_wrt_inode_uidgid(inode, CAP_FSETID))
+		if (!in_group_or_capable(inode, (ia_valid & ATTR_GID) ?
+						attr->ia_gid : inode->i_gid))
 			attr->ia_mode &= ~S_ISGID;
 	}
 
@@ -193,9 +194,7 @@ void setattr_copy(struct inode *inode, const struct iattr *attr)
 		inode->i_ctime = attr->ia_ctime;
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
-
-		if (!in_group_p(inode->i_gid) &&
-		    !capable_wrt_inode_uidgid(inode, CAP_FSETID))
+		if (!in_group_or_capable(inode, inode->i_gid))
 			mode &= ~S_ISGID;
 		inode->i_mode = mode;
 	}
diff --git a/fs/inode.c b/fs/inode.c
index 52f834b6a3ad..63f86aeda7fd 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2379,6 +2379,26 @@ int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
 }
 EXPORT_SYMBOL(vfs_ioc_fssetxattr_check);
 
+/**
+ * in_group_or_capable - check whether caller is CAP_FSETID privileged
+ * @inode:	inode to check
+ * @gid:	the new/current gid of @inode
+ *
+ * Check wether @gid is in the caller's group list or if the caller is
+ * privileged with CAP_FSETID over @inode. This can be used to determine
+ * whether the setgid bit can be kept or must be dropped.
+ *
+ * Return: true if the caller is sufficiently privileged, false if not.
+ */
+bool in_group_or_capable(const struct inode *inode, kgid_t gid)
+{
+	if (in_group_p(gid))
+		return true;
+	if (capable_wrt_inode_uidgid(inode, CAP_FSETID))
+		return true;
+	return false;
+}
+
 /**
  * mode_strip_sgid - handle the sgid bit for non-directories
  * @dir: parent directory inode
@@ -2398,11 +2418,8 @@ umode_t mode_strip_sgid(const struct inode *dir, umode_t mode)
 		return mode;
 	if (S_ISDIR(mode) || !dir || !(dir->i_mode & S_ISGID))
 		return mode;
-	if (in_group_p(dir->i_gid))
-		return mode;
-	if (capable_wrt_inode_uidgid(dir, CAP_FSETID))
+	if (in_group_or_capable(dir, dir->i_gid))
 		return mode;
-
 	return mode & ~S_ISGID;
 }
 EXPORT_SYMBOL(mode_strip_sgid);
diff --git a/fs/internal.h b/fs/internal.h
index 06d313b9beec..0fe920d9f393 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -149,6 +149,7 @@ extern int vfs_open(const struct path *, struct file *);
 extern long prune_icache_sb(struct super_block *sb, struct shrink_control *sc);
 extern void inode_add_lru(struct inode *inode);
 extern int dentry_needs_remove_privs(struct dentry *dentry);
+bool in_group_or_capable(const struct inode *inode, kgid_t gid);
 
 /*
  * fs-writeback.c
-- 
2.34.1

