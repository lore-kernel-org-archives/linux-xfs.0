Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D80C6FD1D
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 11:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjCQLIk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjCQLIi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 07:08:38 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01F626C23
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:36 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso4886589wmb.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679051315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iF1mN6zvABPJFTbU5QEGrkBoU8KKs2uGJMLFx2CtOkE=;
        b=hVDDeKntU0dbmuyrknNwT8AtQNKk/uwAI+GMumi6zmsUUs62SzCPPXmAHrJoLFj2bi
         0gYNKLoeMTLoIezGdFlJaou+vFh+FNJx+opQbtqltfOIpTgIk3Sz3+3kPymgK8WasZe5
         7VEUs+G7PS2eDAVbnba6Yp7wZqgZCYMn1/MhaBf+w/NDZXWctzoyYgnRwOGdlcx8+qrE
         Rc4q0Imp09Ubl/nbDmwou7ac+wWKvo7ROpm4GjC6N6iMpmeIZW0yEf47IQpvAItwvPnj
         Pf4BF7rH9rVkOdfMf6ogPOuZ1E84iIFvxKMg9G5Fb6sPTcydx3c+ciltNEDgULjWwaxB
         tr+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679051315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iF1mN6zvABPJFTbU5QEGrkBoU8KKs2uGJMLFx2CtOkE=;
        b=8DdlUG4qRMpR7BH19nXbum6e6xz3UpBtVj3gL8wP9D6Kt3Dcr/JnkIVXAWPuFdh+Ad
         wdaZFVTJfEVI0I+2Ge0VYo/8bMRoWD9mz24J90AH1xhuX1ZmChT+n+je0FXXSXpjwXNc
         Abw2FZRz1QbOVURVctXeqKY9K50xvQPu/53LZjeo6RKUt2B3oJEmr98IU64JZpq67ku2
         r/iW7tBYTO8cNG/NwES2dIYWZsa5Of0NQgUE38pfuwziTvY5kP1ObHVyHdSzuadOHq4H
         V/rAFdsFw2cdpBU7Bu2xpfLndB1N4rfTzaettHeWV6AEq0+4M58hLwDstM7YBF954+oL
         NFdw==
X-Gm-Message-State: AO0yUKUGd4k+hQt+vOsRx/8+BcWdvgR4e6y9VDzlD/50LiIQLtWSpAMN
        W+YUTNmDLwpfL/VcmHdrJa4zAmCp6wI=
X-Google-Smtp-Source: AK7set8tGd52uCgPbb9fEB/iwXpNd2nv+q9A/p2zL3Hf+qKKcDzvUvd/G68+4fEnNuuWwwnY1u4YgA==
X-Received: by 2002:a05:600c:1546:b0:3ed:22f2:554c with SMTP id f6-20020a05600c154600b003ed22f2554cmr17308124wmg.29.1679051315355;
        Fri, 17 Mar 2023 04:08:35 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t14-20020a1c770e000000b003daf7721bb3sm7551100wmi.12.2023.03.17.04.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:08:34 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org, Yang Xu <xuyang2018.jy@fujitsu.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.10 CANDIDATE 08/15] fs: add mode_strip_sgid() helper
Date:   Fri, 17 Mar 2023 13:08:10 +0200
Message-Id: <20230317110817.1226324-9-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317110817.1226324-1-amir73il@gmail.com>
References: <20230317110817.1226324-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Yang Xu <xuyang2018.jy@fujitsu.com>

commit 2b3416ceff5e6bd4922f6d1c61fb68113dd82302 upstream.

[remove userns argument of helper for 5.10.y backport]

Add a dedicated helper to handle the setgid bit when creating a new file
in a setgid directory. This is a preparatory patch for moving setgid
stripping into the vfs. The patch contains no functional changes.

Currently the setgid stripping logic is open-coded directly in
inode_init_owner() and the individual filesystems are responsible for
handling setgid inheritance. Since this has proven to be brittle as
evidenced by old issues we uncovered over the last months (see [1] to
[3] below) we will try to move this logic into the vfs.

Link: e014f37db1a2 ("xfs: use setattr_copy to set vfs inode attributes") [1]
Link: 01ea173e103e ("xfs: fix up non-directory creation in SGID directories") [2]
Link: fd84bfdddd16 ("ceph: fix up non-directory creation in SGID directories") [3]
Link: https://lore.kernel.org/r/1657779088-2242-1-git-send-email-xuyang2018.jy@fujitsu.com
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-and-Tested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/inode.c         | 34 ++++++++++++++++++++++++++++++----
 include/linux/fs.h |  1 +
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 9f49e0bdc2f7..23d03abcb0ff 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2147,10 +2147,8 @@ void inode_init_owner(struct inode *inode, const struct inode *dir,
 		/* Directories are special, and always inherit S_ISGID */
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-		else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
-			 !in_group_p(inode->i_gid) &&
-			 !capable_wrt_inode_uidgid(dir, CAP_FSETID))
-			mode &= ~S_ISGID;
+		else
+			mode = mode_strip_sgid(dir, mode);
 	} else
 		inode->i_gid = current_fsgid();
 	inode->i_mode = mode;
@@ -2382,3 +2380,31 @@ int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
 	return 0;
 }
 EXPORT_SYMBOL(vfs_ioc_fssetxattr_check);
+
+/**
+ * mode_strip_sgid - handle the sgid bit for non-directories
+ * @dir: parent directory inode
+ * @mode: mode of the file to be created in @dir
+ *
+ * If the @mode of the new file has both the S_ISGID and S_IXGRP bit
+ * raised and @dir has the S_ISGID bit raised ensure that the caller is
+ * either in the group of the parent directory or they have CAP_FSETID
+ * in their user namespace and are privileged over the parent directory.
+ * In all other cases, strip the S_ISGID bit from @mode.
+ *
+ * Return: the new mode to use for the file
+ */
+umode_t mode_strip_sgid(const struct inode *dir, umode_t mode)
+{
+	if ((mode & (S_ISGID | S_IXGRP)) != (S_ISGID | S_IXGRP))
+		return mode;
+	if (S_ISDIR(mode) || !dir || !(dir->i_mode & S_ISGID))
+		return mode;
+	if (in_group_p(dir->i_gid))
+		return mode;
+	if (capable_wrt_inode_uidgid(dir, CAP_FSETID))
+		return mode;
+
+	return mode & ~S_ISGID;
+}
+EXPORT_SYMBOL(mode_strip_sgid);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 74e19bccbf73..527791e4860b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1768,6 +1768,7 @@ extern long compat_ptr_ioctl(struct file *file, unsigned int cmd,
 extern void inode_init_owner(struct inode *inode, const struct inode *dir,
 			umode_t mode);
 extern bool may_open_dev(const struct path *path);
+umode_t mode_strip_sgid(const struct inode *dir, umode_t mode);
 
 /*
  * This is the "filldir" function type, used by readdir() to let
-- 
2.34.1

