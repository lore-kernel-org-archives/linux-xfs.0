Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765C5C6FA8E
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Mar 2023 20:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjCBUfa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Mar 2023 15:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjCBUf1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Mar 2023 15:35:27 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CCE3C796
        for <linux-xfs@vger.kernel.org>; Thu,  2 Mar 2023 12:35:24 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id a7so232942pfx.10
        for <linux-xfs@vger.kernel.org>; Thu, 02 Mar 2023 12:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677789324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ffHjllkvVvRGZ1w2VQreYrwPABI5RgMVuGLe+1NrrCo=;
        b=kP2yJ6cFfDxLYG6HQLR4KZrcmJz+EMZo9P6iMOEXw31ezqECmn+rrcRFglcSIfpbU7
         xy5Tao0NFxHR1EDGUcJc37oFUD59e22WR/uXJ3mERcR14Blk0i+02sCacTLUvtHWh3W6
         w5WaS+WgyH4TYd5rZGG0cba0trz2qgib9P2C7R7jf/AEwe9rIhmKA4BX2/isJieBJj7N
         5gi++0tXcqnKOClJ3o0uLl0MDpbeUy/irrRjeP/pXDjW8YdE7PqoVGwH7BPZq8i4kztI
         Ho7qq1X1X2JuEJ+Z8iD+kyg5JUajYEBlLyyZ9/teZVluzMOP41KXtGY85t4YOEpt88Rx
         TTtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677789324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ffHjllkvVvRGZ1w2VQreYrwPABI5RgMVuGLe+1NrrCo=;
        b=Wp6VxpZiF0e1MhBd7Ubw//cK8t9/JpwJLqxgDWCbmKB9us+y9M0pOwMwKbTSmFfs2m
         HzzdqCEPv8KECD/uOaF0M/R3vpo+XsCS3AlFNu5h5KST/OCzdJH9/eq3GRJUd8eTe9D4
         cVhzX6aKSa2Rilhdcpn7bptFIQ0t1VqRj1w48n6Xjn+V/ZBvORdEMBOpM19TjNh6TIUC
         NUm+SQPd1sYQO1cr4xyhRir/Rbxd+lEOpEsQQzwTkp6w6sfghapSrVVY1yVSHiOGDepf
         kf2SQzLJ5ezWPrSmtTiqEv7to91ULsjPusvUYsFQlNdROhbdxgH3WQbI1iARmft3Zax0
         F58g==
X-Gm-Message-State: AO0yUKWCdLVH/Fv6k5ysMn6ftObx15Em98m78K9Gn3FX4f2ClOyIokuj
        zAX9p0HOxCxIyor2EU9EwJBI121GENQZtA==
X-Google-Smtp-Source: AK7set9HdnYHfXy6oLoZ9o9Xce1/FBNSbKPRVCLGt1JxVkIYysQ+qtf4ANsB5UpX3fAYc5wavBavWw==
X-Received: by 2002:aa7:9821:0:b0:5aa:9ef7:4f7f with SMTP id q1-20020aa79821000000b005aa9ef74f7fmr11447498pfl.9.1677789323717;
        Thu, 02 Mar 2023 12:35:23 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:637a:4159:6b3f:42eb])
        by smtp.gmail.com with ESMTPSA id b13-20020aa7870d000000b005ac86f7b87fsm113459pfo.77.2023.03.02.12.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 12:35:23 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Christian Brauner <brauner@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 07/11] attr: add in_group_or_capable()
Date:   Thu,  2 Mar 2023 12:35:00 -0800
Message-Id: <20230302203504.2998773-8-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230302203504.2998773-1-leah.rumancik@gmail.com>
References: <20230302203504.2998773-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit 11c2a8700cdcabf9b639b7204a1e38e2a0b6798e upstream.

[backport to 5.15.y, prior to vfsgid_t]

In setattr_{copy,prepare}() we need to perform the same permission
checks to determine whether we need to drop the setgid bit or not.
Instead of open-coding it twice add a simple helper the encapsulates the
logic. We will reuse this helpers to make dropping the setgid bit during
write operations more consistent in a follow up patch.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/attr.c     |  8 ++++----
 fs/inode.c    | 28 ++++++++++++++++++++++++----
 fs/internal.h |  2 ++
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index f581c4d00897..686840aa91c8 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -18,6 +18,8 @@
 #include <linux/evm.h>
 #include <linux/ima.h>
 
+#include "internal.h"
+
 /**
  * chown_ok - verify permissions to chown inode
  * @mnt_userns:	user namespace of the mount @inode was found from
@@ -141,8 +143,7 @@ int setattr_prepare(struct user_namespace *mnt_userns, struct dentry *dentry,
 			mapped_gid = i_gid_into_mnt(mnt_userns, inode);
 
 		/* Also check the setgid bit! */
-		if (!in_group_p(mapped_gid) &&
-		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		if (!in_group_or_capable(mnt_userns, inode, mapped_gid))
 			attr->ia_mode &= ~S_ISGID;
 	}
 
@@ -257,8 +258,7 @@ void setattr_copy(struct user_namespace *mnt_userns, struct inode *inode,
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
 		kgid_t kgid = i_gid_into_mnt(mnt_userns, inode);
-		if (!in_group_p(kgid) &&
-		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		if (!in_group_or_capable(mnt_userns, inode, kgid))
 			mode &= ~S_ISGID;
 		inode->i_mode = mode;
 	}
diff --git a/fs/inode.c b/fs/inode.c
index 957b2d18ec29..a71fb82279bb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2321,6 +2321,28 @@ struct timespec64 current_time(struct inode *inode)
 }
 EXPORT_SYMBOL(current_time);
 
+/**
+ * in_group_or_capable - check whether caller is CAP_FSETID privileged
+ * @mnt_userns: user namespace of the mount @inode was found from
+ * @inode:	inode to check
+ * @gid:	the new/current gid of @inode
+ *
+ * Check wether @gid is in the caller's group list or if the caller is
+ * privileged with CAP_FSETID over @inode. This can be used to determine
+ * whether the setgid bit can be kept or must be dropped.
+ *
+ * Return: true if the caller is sufficiently privileged, false if not.
+ */
+bool in_group_or_capable(struct user_namespace *mnt_userns,
+			 const struct inode *inode, kgid_t gid)
+{
+	if (in_group_p(gid))
+		return true;
+	if (capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		return true;
+	return false;
+}
+
 /**
  * mode_strip_sgid - handle the sgid bit for non-directories
  * @mnt_userns: User namespace of the mount the inode was created from
@@ -2342,11 +2364,9 @@ umode_t mode_strip_sgid(struct user_namespace *mnt_userns,
 		return mode;
 	if (S_ISDIR(mode) || !dir || !(dir->i_mode & S_ISGID))
 		return mode;
-	if (in_group_p(i_gid_into_mnt(mnt_userns, dir)))
-		return mode;
-	if (capable_wrt_inode_uidgid(mnt_userns, dir, CAP_FSETID))
+	if (in_group_or_capable(mnt_userns, dir,
+				i_gid_into_mnt(mnt_userns, dir)))
 		return mode;
-
 	return mode & ~S_ISGID;
 }
 EXPORT_SYMBOL(mode_strip_sgid);
diff --git a/fs/internal.h b/fs/internal.h
index 9075490f21a6..c89814727281 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -150,6 +150,8 @@ extern int vfs_open(const struct path *, struct file *);
 extern long prune_icache_sb(struct super_block *sb, struct shrink_control *sc);
 extern void inode_add_lru(struct inode *inode);
 extern int dentry_needs_remove_privs(struct dentry *dentry);
+bool in_group_or_capable(struct user_namespace *mnt_userns,
+			 const struct inode *inode, kgid_t gid);
 
 /*
  * fs-writeback.c
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

