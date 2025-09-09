Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8BC352081
	for <linux-xfs@vger.kernel.org>; Tue,  9 Sep 2025 15:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757431490; cv=none; b=dpzibfobTj5bmjlx0uafuSAe7KRUNKaf8920/QkRYdn7TXB0+vRRo1QKEUlE/sVji9tsqCX8jE2+F6fZKgWmz1EhWjoXkaRVY3aKB3qE6zVv72Dgcja3lNu0EHiQNn9vIoMcVvFFoDFi2ZqQnoMxoIuydUXB9BVlgzdGK5Hedxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757431490; c=relaxed/simple;
	bh=0P7SKLlU5ZMqeTvFiPkNMnQMwQAfXKWARkLjPYodK+g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kOIEtShxmIgAVy5ykT4iLcbkB8cXFfksLSscd3hIOY6C4MhCvwUzpM0I2kkG5Tf4zj46mcueMnwkptEVdKflgNNhgiNXiislwZZp/xNx7ARIez1ES9Sl5zVAgmotXZl9LijVqTzsdaJO21ui7rw+RelEATcYrijY6VuzIfLBoSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xt9SzwJr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xt9SzwJr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757431487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pKG/69ZwliyUOkPsiDTUk2UJHjdQ++vbsHxfCOT2oeE=;
	b=Xt9SzwJrjn3DXbXebNL9oH16TQFBC2Y9IY0X/nBkJL6ZDzNqFnmaJqXAd24Vvba3SY6YVo
	7uHe73pmoy1mI5UqLoh+kyG/j/dNsYJ5BlZaGZWSk5tOOhmx/9p5ukI2DIiarrE/MvAkea
	w5rN4d5lGqZ/xgFHuzsew3ZJBIOyS54=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-Bjrk8kcDP7Oalfm7FxtxTg-1; Tue, 09 Sep 2025 11:24:46 -0400
X-MC-Unique: Bjrk8kcDP7Oalfm7FxtxTg-1
X-Mimecast-MFC-AGG-ID: Bjrk8kcDP7Oalfm7FxtxTg_1757431485
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45decfa5b26so6085415e9.3
        for <linux-xfs@vger.kernel.org>; Tue, 09 Sep 2025 08:24:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757431485; x=1758036285;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pKG/69ZwliyUOkPsiDTUk2UJHjdQ++vbsHxfCOT2oeE=;
        b=QH+UaUkNdOk2vm/+c9ct5PhQfQlZYc/l1g2XjTtzrOi8rzp6jH27R+Ba8hHzzQ8p6I
         eGfE1+IPgEWslGlMdr/Kz14x3w81B+vOp4FuiYeWxj5R0q8nl1EXx+GpphW8/NdBjvEz
         IspbR28abWZ2czhR975vXruiC4SY0h+tyTo6I1VUPDsOj7HQluvq4nMAiPnoWj+ZfokP
         NgroWwvFW3PEVYZYBmq+tv4+nLgtwu9IB0W8pfOITxiaUa0ihc9CrPg/5muv41DXlWET
         o+GL3ikJyWuc2z0dYkUjHVEu4qDMazWbL/IcwhhY5Q0x+EGDYPFRqOYHbj45KF3AVulr
         cSAA==
X-Forwarded-Encrypted: i=1; AJvYcCWvCJvEWEPbDQM96PjbXsdS9B44ucWsuZY42zvH6BJD/1hS9zpRqUjFCR7DxGxh3tiz2HOQ4Y6AYa0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6zSUsn9OANUiQU9TcPfjbUO1RiEuSw7BhgqrKxMoH4tbSjSWd
	KhtHByXHvsQRUsrowgq+N3OxFQt4e2eTgdD+l9yV0zvjLGvcGJ7Ut0PaBiOQ6mmz7+tUFy6+heE
	YKx6gaJgpPjwvFZKCC0lqOs9ibBhdQz94end7p5FonIl3rscYWiavavmHpcnu
X-Gm-Gg: ASbGncv2uf9Rja/kMo9PyxsfEVEEe/Zyoseqpxop/Ql3gadL05RbGPEao0THZQ4A2c7
	xa+3usYHBhzBtYr09vMSJWr40XIqQEim38y2aKKQQdko4WtH7/k3tK6IPO+JQL3RNYBsAVcf26a
	XH/F228J7gPBm9BpyHZ0vexl9yl4u4qbIsJqx26ZMcnnesld5cniYbeNtRkix3YnMaDR3dMWbtR
	Sqkmke256B+aJy3HZuudiaefpQfZj9VAxd4bmeMbLTIKQGaLmDI4FwiDjd8erBzVKVPyIGU8QTt
	5oFbl1Q6OV87aMKggrlIzCkcmYXw/SlipNI+1Nc=
X-Received: by 2002:a05:600c:524f:b0:45d:e326:96ca with SMTP id 5b1f17b1804b1-45de4e80095mr83475895e9.36.1757431485129;
        Tue, 09 Sep 2025 08:24:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4L1ZypQ28cg3IM40ZlXuEmO0tTigmyLPxis3gb9GTZzw4/t6CZh5CEniMNdDS7YBxYiE1QQ==
X-Received: by 2002:a05:600c:524f:b0:45d:e326:96ca with SMTP id 5b1f17b1804b1-45de4e80095mr83475715e9.36.1757431484630;
        Tue, 09 Sep 2025 08:24:44 -0700 (PDT)
Received: from [127.0.0.2] ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45df17d9774sm11432015e9.9.2025.09.09.08.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 08:24:44 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Tue, 09 Sep 2025 17:24:37 +0200
Subject: [PATCH v3 v3 2/4] xfs_quota: utilize file_setattr to set prjid on
 special files
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-xattrat-syscall-v3-2-4407a714817e@kernel.org>
References: <20250909-xattrat-syscall-v3-0-4407a714817e@kernel.org>
In-Reply-To: <20250909-xattrat-syscall-v3-0-4407a714817e@kernel.org>
To: aalbersh@kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7111; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=tH69RkF2QRVFquTMUMn8VRWpXIuIO9+pJZTSM0auQFw=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMg647apl+SW+k/N5UMiTKqkNp8sn3L1QvdI0635wZ
 Hpb+Bdjh7cdpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJsK2hJHhKSejyS6Pn+9m
 Bn2NtpbfyvIoZlfLqeYvm3/P8ONc//3laoZ/Bn0GjWaJDczPvM58PHVzf77i46k5L0y6G/4f3Xv
 t6jUeZgAmpk0q
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

Utilize new file_getattr/file_setattr syscalls to set project ID on
special files. Previously, special files were skipped due to lack of the
way to call FS_IOC_SETFSXATTR ioctl on them. The quota accounting was
therefore missing these inodes (special files created before project
setup). The ones created after project initialization did inherit the
projid flag from the parent.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 quota/project.c | 142 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 74 insertions(+), 68 deletions(-)

diff --git a/quota/project.c b/quota/project.c
index adb26945fa57..5832e1474e25 100644
--- a/quota/project.c
+++ b/quota/project.c
@@ -4,14 +4,17 @@
  * All Rights Reserved.
  */
 
+#include <unistd.h>
 #include "command.h"
 #include "input.h"
 #include "init.h"
+#include "libfrog/file_attr.h"
 #include "quota.h"
 
 static cmdinfo_t project_cmd;
 static prid_t prid;
 static int recurse_depth = -1;
+static int dfd;
 
 enum {
 	CHECK_PROJECT	= 0x1,
@@ -19,13 +22,6 @@ enum {
 	CLEAR_PROJECT	= 0x4,
 };
 
-#define EXCLUDED_FILE_TYPES(x) \
-	   (S_ISCHR((x)) \
-	|| S_ISBLK((x)) \
-	|| S_ISFIFO((x)) \
-	|| S_ISLNK((x)) \
-	|| S_ISSOCK((x)))
-
 static void
 project_help(void)
 {
@@ -85,8 +81,8 @@ check_project(
 	int			flag,
 	struct FTW		*data)
 {
-	struct fsxattr		fsx;
-	int			fd;
+	int			error;
+	struct file_attr	fa;
 
 	if (recurse_depth >= 0 && data->level > recurse_depth)
 		return 0;
@@ -96,30 +92,30 @@ check_project(
 		fprintf(stderr, _("%s: cannot stat file %s\n"), progname, path);
 		return 0;
 	}
-	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
-		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
-		return 0;
-	}
 
-	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
-		exitcode = 1;
-		fprintf(stderr, _("%s: cannot open %s: %s\n"),
-			progname, path, strerror(errno));
-	} else if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
-		exitcode = 1;
+	error = xfrog_file_getattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
+	if (error && errno == EOPNOTSUPP) {
+		if (SPECIAL_FILE(stat->st_mode)) {
+			fprintf(stderr, _("%s: skipping special file %s: %s\n"),
+					progname, path, strerror(errno));
+			return 0;
+		}
+	}
+	if (error) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
-			progname, path, strerror(errno));
-	} else {
-		if (fsx.fsx_projid != prid)
-			printf(_("%s - project identifier is not set"
-				 " (inode=%u, tree=%u)\n"),
-				path, fsx.fsx_projid, (unsigned int)prid);
-		if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT) && S_ISDIR(stat->st_mode))
-			printf(_("%s - project inheritance flag is not set\n"),
-				path);
+				progname, path, strerror(errno));
+		exitcode = 1;
+		return 0;
 	}
-	if (fd != -1)
-		close(fd);
+
+	if (fa.fa_projid != prid)
+		printf(_("%s - project identifier is not set"
+				" (inode=%u, tree=%u)\n"),
+			path, fa.fa_projid, (unsigned int)prid);
+	if (!(fa.fa_xflags & FS_XFLAG_PROJINHERIT) && S_ISDIR(stat->st_mode))
+		printf(_("%s - project inheritance flag is not set\n"),
+			path);
+
 	return 0;
 }
 
@@ -130,8 +126,8 @@ clear_project(
 	int			flag,
 	struct FTW		*data)
 {
-	struct fsxattr		fsx;
-	int			fd;
+	int			error;
+	struct file_attr	fa;
 
 	if (recurse_depth >= 0 && data->level > recurse_depth)
 		return 0;
@@ -141,32 +137,32 @@ clear_project(
 		fprintf(stderr, _("%s: cannot stat file %s\n"), progname, path);
 		return 0;
 	}
-	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
-		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
-		return 0;
+
+	error = xfrog_file_getattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
+	if (error && errno == EOPNOTSUPP) {
+		if (SPECIAL_FILE(stat->st_mode)) {
+			fprintf(stderr, _("%s: skipping special file %s: %s\n"),
+					progname, path, strerror(errno));
+			return 0;
+		}
 	}
 
-	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
-		exitcode = 1;
-		fprintf(stderr, _("%s: cannot open %s: %s\n"),
-			progname, path, strerror(errno));
-		return 0;
-	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx) < 0) {
-		exitcode = 1;
+	if (error) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
-			progname, path, strerror(errno));
-		close(fd);
+				progname, path, strerror(errno));
+		exitcode = 1;
 		return 0;
 	}
 
-	fsx.fsx_projid = 0;
-	fsx.fsx_xflags &= ~FS_XFLAG_PROJINHERIT;
-	if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx) < 0) {
-		exitcode = 1;
+	fa.fa_projid = 0;
+	fa.fa_xflags &= ~FS_XFLAG_PROJINHERIT;
+
+	error = xfrog_file_setattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
+	if (error) {
 		fprintf(stderr, _("%s: cannot clear project on %s: %s\n"),
 			progname, path, strerror(errno));
+		exitcode = 1;
 	}
-	close(fd);
 	return 0;
 }
 
@@ -177,8 +173,8 @@ setup_project(
 	int			flag,
 	struct FTW		*data)
 {
-	struct fsxattr		fsx;
-	int			fd;
+	struct file_attr	fa;
+	int			error;
 
 	if (recurse_depth >= 0 && data->level > recurse_depth)
 		return 0;
@@ -188,32 +184,33 @@ setup_project(
 		fprintf(stderr, _("%s: cannot stat file %s\n"), progname, path);
 		return 0;
 	}
-	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
-		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
-		return 0;
+
+	error = xfrog_file_getattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
+	if (error && errno == EOPNOTSUPP) {
+		if (SPECIAL_FILE(stat->st_mode)) {
+			fprintf(stderr, _("%s: skipping special file %s\n"),
+					progname, path);
+			return 0;
+		}
 	}
 
-	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
-		exitcode = 1;
-		fprintf(stderr, _("%s: cannot open %s: %s\n"),
-			progname, path, strerror(errno));
-		return 0;
-	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx) < 0) {
-		exitcode = 1;
+	if (error) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
-			progname, path, strerror(errno));
-		close(fd);
+				progname, path, strerror(errno));
+		exitcode = 1;
 		return 0;
 	}
 
-	fsx.fsx_projid = prid;
-	fsx.fsx_xflags |= FS_XFLAG_PROJINHERIT;
-	if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx) < 0) {
-		exitcode = 1;
+	fa.fa_projid = prid;
+	if (S_ISDIR(stat->st_mode))
+		fa.fa_xflags |= FS_XFLAG_PROJINHERIT;
+
+	error = xfrog_file_setattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
+	if (error) {
 		fprintf(stderr, _("%s: cannot set project on %s: %s\n"),
 			progname, path, strerror(errno));
+		exitcode = 1;
 	}
-	close(fd);
 	return 0;
 }
 
@@ -223,6 +220,13 @@ project_operations(
 	char		*dir,
 	int		type)
 {
+	dfd = open(dir, O_RDONLY | O_NOCTTY);
+	if (dfd < -1) {
+		printf(_("Error opening dir %s for project %s...\n"), dir,
+				project);
+		return;
+	}
+
 	switch (type) {
 	case CHECK_PROJECT:
 		printf(_("Checking project %s (path %s)...\n"), project, dir);
@@ -237,6 +241,8 @@ project_operations(
 		nftw(dir, clear_project, 100, FTW_PHYS|FTW_MOUNT);
 		break;
 	}
+
+	close(dfd);
 }
 
 static void

-- 
2.50.1

