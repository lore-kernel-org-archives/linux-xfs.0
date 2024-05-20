Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DBFE552
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 16:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716223607; cv=none; b=uv5aShAQ4RbF+/a2GFHD6aOSDAqTwlxcmRLjGD9bTUYfoc21N+TIpQnyfSNYlyMQmcNjDT75paPhexlMf0OXa5om+uxgQjnXagUyOozNg5ITOxddEOOwOUmlF6PEI6VK3ijgTZMWLW4y0NaUtADlOdHvC4xAPkRc4nvqCCG3rn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716223607; c=relaxed/simple;
	bh=NJljvBBncSXGFgCAhktMljdBsexiyMgQ3kAEmS7MYjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQw7NGh1VNLGRcVGFAmUKdFlTlgUdbc7G9kw7Yj4CteTzr+R7X2gL7EBEiSk05i6HcZR7ezeK0M7RrF46Q1AeNYrOtVg6VX65T9GFeAZToeaNeTiy9D1KIrAuDaRdTvfGGRQZV61Tr+bxxsgIh6f5vfDPaLQeAMZ6IXtntBvnO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QhuI+wUR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QhuI+wUR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716223605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mb47u4BUbRbQvL5WkGQg3GmOK00O3SGgwt1kI14z+kY=;
	b=QhuI+wURKmG4vu/X//o8LRpSQuBN0aV5TDg+JKp1c4egwax5Okwa9k0ebacWklMwwBz65m
	1UeutzwWpgM8G6/2vQle1bVbOXfOsxSXd3upK+s6Nwm/hfhBC3h+PtAcCfxfCEBtGrMJoM
	mvFr/ZzdQVBwUTlGczVKNDHdMV7YHc0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-rTwhFBaiNiqt3JQL2V7mVw-1; Mon, 20 May 2024 12:46:43 -0400
X-MC-Unique: rTwhFBaiNiqt3JQL2V7mVw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a5a05c4e0efso718457666b.1
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 09:46:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716223602; x=1716828402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mb47u4BUbRbQvL5WkGQg3GmOK00O3SGgwt1kI14z+kY=;
        b=BMC3of3Km90U8+rANIndagS/QCMkVK6lvK6bSrcvUnQxa80eo3SpSW0g7bqCDSagW0
         rHvAaQK6qu2xyHEn1jE3uUtA3/JL36nSfLpmmDuCMBTbfujfsgeJVhVgph0V7bnX7CW4
         sONsJOMIWhMFwrvghNc6Nlz+YsLhNQ9/L1SV+zHPtIqhewy5U0c8Ni6co53HixpEDjGS
         aE2/bKhGj1ot+O2g9CxKmLbNvisxLyddz/JGhlfbadsSlsW59IbjYFXv+ff+v44x7466
         lCEGjTVmLhx7FZCiID+PC4VcFd9fYdLVwi5PSHQu31nZbjg56LBCsenWQ25qcH/UDTx3
         8VJg==
X-Forwarded-Encrypted: i=1; AJvYcCUP0tlZVwsYfIpAJU1NWTcOq8ncBEIASNxP7paF+gFAKZ0vCecc16pYDczFl1bGgPHpB08iPZMkcP+8Q1QqiM3aJwF1BaXXPoLK
X-Gm-Message-State: AOJu0YyQie9IY89h09pR0yK1dTgPlhDDs+Qix1m3m3pFb6eIoSMraX9t
	gu9re/iurMsF0eI8bMZt/xYsV/gwz4JkyRfOZ4fKwMfe1r8C3AlwjWfK0tw6I0vdDkItlmvulhG
	FV7BDranHrgCalJPYi8JcmA4nF9qiSqzJJvdbdHHphM8P3kdE4/S6iIz/
X-Received: by 2002:a17:906:1797:b0:a5a:8d07:6a00 with SMTP id a640c23a62f3a-a5a8d076e2cmr1097251566b.64.1716223602257;
        Mon, 20 May 2024 09:46:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXq/eJmuS+/EKU25zG0+NkD2jNJAjk33AZAKqiESOoaaPGOJRW1cqPS3Ogh8tCt2A0TzJAEg==
X-Received: by 2002:a17:906:1797:b0:a5a:8d07:6a00 with SMTP id a640c23a62f3a-a5a8d076e2cmr1097248866b.64.1716223601635;
        Mon, 20 May 2024 09:46:41 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5df00490cfsm318872066b.159.2024.05.20.09.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 09:46:41 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-fsdevel@vgre.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 2/4] fs: add FS_IOC_FSSETXATTRAT and FS_IOC_FSGETXATTRAT
Date: Mon, 20 May 2024 18:46:21 +0200
Message-ID: <20240520164624.665269-4-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240520164624.665269-2-aalbersh@redhat.com>
References: <20240520164624.665269-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

XFS has project quotas which could be attached to a directory. All
new inodes in these directories inherit project ID set on parent
directory.

The project is created from userspace by opening and calling
FS_IOC_FSSETXATTR on each inode. This is not possible for special
files such as FIFO, SOCK, BLK etc. as opening them returns a special
inode from VFS. Therefore, some inodes are left with empty project
ID. Those inodes then are not shown in the quota accounting but
still exist in the directory.

This patch adds two new ioctls which allows userspace, such as
xfs_quota, to set project ID on special files by using parent
directory to open FS inode. This will let xfs_quota set ID on all
inodes and also reset it when project is removed. Also, as
vfs_fileattr_set() is now will called on special files too, let's
forbid any other attributes except projid and nextents (symlink can
have one).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/ioctl.c              | 93 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h | 11 +++++
 2 files changed, 104 insertions(+)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 1d5abfdf0f22..3e3aacb6ea6e 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -22,6 +22,7 @@
 #include <linux/mount.h>
 #include <linux/fscrypt.h>
 #include <linux/fileattr.h>
+#include <linux/namei.h>
 
 #include "internal.h"
 
@@ -647,6 +648,19 @@ static int fileattr_set_prepare(struct inode *inode,
 	if (fa->fsx_cowextsize == 0)
 		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
 
+	/*
+	 * The only use case for special files is to set project ID, forbid any
+	 * other attributes
+	 */
+	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))) {
+		if (fa->fsx_xflags & ~FS_XFLAG_PROJINHERIT)
+			return -EINVAL;
+		if (!S_ISLNK(inode->i_mode) && fa->fsx_nextents)
+			return -EINVAL;
+		if (fa->fsx_extsize || fa->fsx_cowextsize)
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -763,6 +777,79 @@ static int ioctl_fssetxattr(struct file *file, void __user *argp)
 	return err;
 }
 
+static int ioctl_fsgetxattrat(struct file *file, void __user *argp)
+{
+	struct path filepath;
+	struct fsxattrat fsxat;
+	struct fileattr fa;
+	int error;
+
+	if (!S_ISDIR(file_inode(file)->i_mode))
+		return -EBADF;
+
+	if (copy_from_user(&fsxat, argp, sizeof(struct fsxattrat)))
+		return -EFAULT;
+
+	error = user_path_at(fsxat.dfd, fsxat.path, 0, &filepath);
+	if (error)
+		return error;
+
+	error = vfs_fileattr_get(filepath.dentry, &fa);
+	if (error) {
+		path_put(&filepath);
+		return error;
+	}
+
+	fsxat.fsx.fsx_xflags = fa.fsx_xflags;
+	fsxat.fsx.fsx_extsize = fa.fsx_extsize;
+	fsxat.fsx.fsx_nextents = fa.fsx_nextents;
+	fsxat.fsx.fsx_projid = fa.fsx_projid;
+	fsxat.fsx.fsx_cowextsize = fa.fsx_cowextsize;
+
+	if (copy_to_user(argp, &fsxat, sizeof(struct fsxattrat)))
+		error = -EFAULT;
+
+	path_put(&filepath);
+	return error;
+}
+
+static int ioctl_fssetxattrat(struct file *file, void __user *argp)
+{
+	struct mnt_idmap *idmap = file_mnt_idmap(file);
+	struct fsxattrat fsxat;
+	struct path filepath;
+	struct fileattr fa;
+	int error;
+
+	if (!S_ISDIR(file_inode(file)->i_mode))
+		return -EBADF;
+
+	if (copy_from_user(&fsxat, argp, sizeof(struct fsxattrat)))
+		return -EFAULT;
+
+	error = user_path_at(fsxat.dfd, fsxat.path, 0, &filepath);
+	if (error)
+		return error;
+
+	error = mnt_want_write(filepath.mnt);
+	if (error) {
+		path_put(&filepath);
+		return error;
+	}
+
+	fileattr_fill_xflags(&fa, fsxat.fsx.fsx_xflags);
+	fa.fsx_extsize = fsxat.fsx.fsx_extsize;
+	fa.fsx_nextents = fsxat.fsx.fsx_nextents;
+	fa.fsx_projid = fsxat.fsx.fsx_projid;
+	fa.fsx_cowextsize = fsxat.fsx.fsx_cowextsize;
+	fa.fsx_valid = true;
+
+	error = vfs_fileattr_set(idmap, filepath.dentry, &fa);
+	mnt_drop_write(filepath.mnt);
+	path_put(&filepath);
+	return error;
+}
+
 static int ioctl_getfsuuid(struct file *file, void __user *argp)
 {
 	struct super_block *sb = file_inode(file)->i_sb;
@@ -872,6 +959,12 @@ static int do_vfs_ioctl(struct file *filp, unsigned int fd,
 	case FS_IOC_FSSETXATTR:
 		return ioctl_fssetxattr(filp, argp);
 
+	case FS_IOC_FSGETXATTRAT:
+		return ioctl_fsgetxattrat(filp, argp);
+
+	case FS_IOC_FSSETXATTRAT:
+		return ioctl_fssetxattrat(filp, argp);
+
 	case FS_IOC_GETFSUUID:
 		return ioctl_getfsuuid(filp, argp);
 
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 45e4e64fd664..f8cd8d7bf35d 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -139,6 +139,15 @@ struct fsxattr {
 	unsigned char	fsx_pad[8];
 };
 
+/*
+ * Structure passed to FS_IOC_FSGETXATTRAT/FS_IOC_FSSETXATTRAT
+ */
+struct fsxattrat {
+	struct fsxattr	fsx;		/* XATTR to get/set */
+	__u32		dfd;		/* parent dir */
+	const char	__user *path;
+};
+
 /*
  * Flags for the fsx_xflags field
  */
@@ -231,6 +240,8 @@ struct fsxattr {
 #define FS_IOC32_SETVERSION		_IOW('v', 2, int)
 #define FS_IOC_FSGETXATTR		_IOR('X', 31, struct fsxattr)
 #define FS_IOC_FSSETXATTR		_IOW('X', 32, struct fsxattr)
+#define FS_IOC_FSGETXATTRAT		_IOR('X', 33, struct fsxattrat)
+#define FS_IOC_FSSETXATTRAT		_IOW('X', 34, struct fsxattrat)
 #define FS_IOC_GETFSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
 #define FS_IOC_SETFSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
 /* Returns the external filesystem UUID, the same one blkid returns */
-- 
2.42.0

