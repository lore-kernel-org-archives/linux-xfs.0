Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC1EC678D4
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Mar 2023 20:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjCBUf2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Mar 2023 15:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjCBUfX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Mar 2023 15:35:23 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C8237578
        for <linux-xfs@vger.kernel.org>; Thu,  2 Mar 2023 12:35:22 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id fd25so266701pfb.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Mar 2023 12:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677789321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y5DAo6RoTpyDLR7cV5ESavM8boSIcTHziYnivYOeXIk=;
        b=ghNzOXilJY3CVs3dnABE0xhqW0FpvMrfLhoaBb0Hh4gcpUMrREPBw3ff921y/a4Mda
         veMAAoTdVkasccPdF308IYLm1XqnTqcUbgii8ml9SUwlOHKCWOgT45xGMRicwDLy7JX5
         YHgqBbcVZQQSaLnXyLKDg/qRTGH1h78oO7SneVZZCI9b0FvCbEXUzRMT2rr3OZq1chph
         JRSUp/pClFnge8gAhEFDdeFHH9x98vitEkoW0crif8NyknWovfvz0yKKEvT08OMo4Enw
         +N5znkt/N50hr7B4XfBL3Vk0t8j9jb9mvW3vdaz66+gO4yjrySfjZ9AwGJH3elN3Qzzv
         WStg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677789321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y5DAo6RoTpyDLR7cV5ESavM8boSIcTHziYnivYOeXIk=;
        b=QwZi8EhC0Nt/83eL6I4CvfF7tfgQvvOGyYJ+Mt7v9PdedaIlPF2AQjjs80PDTKt7n4
         fOvIsYyIHJbMmuGqMcgQWqu3g84/RJYf+DNgkkkTT9RDeblJ3uvGHIdiiKo2nkxmgKaq
         Ah2SIxfpD3ue++nYJO/ul199eR+p3HWpcYLIH+ADnZDcJhtdHNb6vlwtuNCp2ukiLoHL
         6DdffFHwQrOiBbMDkGySKqi+NTB3DmSBLgkO7oxjUJn1u7PIk4+VYWM5/zKUMzz5/Ssg
         Z/jH33Vi47YpAByN+rRWg6uOSUqKGIS17pb7NuTxsX4G//bT2y0Jg1eVSX1HeDgh/na3
         Ba7Q==
X-Gm-Message-State: AO0yUKXFobBg29y9NTrJdA87zcoo0G5HOKr7tjS/wi3Ln4Vvc+KQywZ9
        qgYaleQN68U9DwtwFw2/ewTHpI68J2Y38A==
X-Google-Smtp-Source: AK7set8+b0aaGn/2ZTm2Qk8UYoypU/OxaEOaishRkAYsfKjGkKVdTSZKV2LWsGaT3QZHN4kjGsI3XA==
X-Received: by 2002:a62:4ecb:0:b0:5a8:bbac:1cf2 with SMTP id c194-20020a624ecb000000b005a8bbac1cf2mr8843244pfb.1.1677789321421;
        Thu, 02 Mar 2023 12:35:21 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:637a:4159:6b3f:42eb])
        by smtp.gmail.com with ESMTPSA id b13-20020aa7870d000000b005ac86f7b87fsm113459pfo.77.2023.03.02.12.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 12:35:21 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Yang Xu <xuyang2018.jy@fujitsu.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 05/11] fs: add mode_strip_sgid() helper
Date:   Thu,  2 Mar 2023 12:34:58 -0800
Message-Id: <20230302203504.2998773-6-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230302203504.2998773-1-leah.rumancik@gmail.com>
References: <20230302203504.2998773-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Yang Xu <xuyang2018.jy@fujitsu.com>

commit 2b3416ceff5e6bd4922f6d1c61fb68113dd82302 upsream.

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
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/inode.c         | 36 ++++++++++++++++++++++++++++++++----
 include/linux/fs.h |  2 ++
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 8279c700a2b7..3740102c9bd5 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2165,10 +2165,8 @@ void inode_init_owner(struct user_namespace *mnt_userns, struct inode *inode,
 		/* Directories are special, and always inherit S_ISGID */
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-		else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
-			 !in_group_p(i_gid_into_mnt(mnt_userns, dir)) &&
-			 !capable_wrt_inode_uidgid(mnt_userns, dir, CAP_FSETID))
-			mode &= ~S_ISGID;
+		else
+			mode = mode_strip_sgid(mnt_userns, dir, mode);
 	} else
 		inode_fsgid_set(inode, mnt_userns);
 	inode->i_mode = mode;
@@ -2324,3 +2322,33 @@ struct timespec64 current_time(struct inode *inode)
 	return timestamp_truncate(now, inode);
 }
 EXPORT_SYMBOL(current_time);
+
+/**
+ * mode_strip_sgid - handle the sgid bit for non-directories
+ * @mnt_userns: User namespace of the mount the inode was created from
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
+umode_t mode_strip_sgid(struct user_namespace *mnt_userns,
+			const struct inode *dir, umode_t mode)
+{
+	if ((mode & (S_ISGID | S_IXGRP)) != (S_ISGID | S_IXGRP))
+		return mode;
+	if (S_ISDIR(mode) || !dir || !(dir->i_mode & S_ISGID))
+		return mode;
+	if (in_group_p(i_gid_into_mnt(mnt_userns, dir)))
+		return mode;
+	if (capable_wrt_inode_uidgid(mnt_userns, dir, CAP_FSETID))
+		return mode;
+
+	return mode & ~S_ISGID;
+}
+EXPORT_SYMBOL(mode_strip_sgid);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1e1ac116dd13..be9be4a7216c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1941,6 +1941,8 @@ extern long compat_ptr_ioctl(struct file *file, unsigned int cmd,
 void inode_init_owner(struct user_namespace *mnt_userns, struct inode *inode,
 		      const struct inode *dir, umode_t mode);
 extern bool may_open_dev(const struct path *path);
+umode_t mode_strip_sgid(struct user_namespace *mnt_userns,
+			const struct inode *dir, umode_t mode);
 
 /*
  * This is the "filldir" function type, used by readdir() to let
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

