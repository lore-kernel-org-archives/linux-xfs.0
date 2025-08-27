Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD34279333
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 15:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307767; cv=none; b=D7SZ9IbL6miB7H9rFdpLhCZCPEt5/SrNMKvApYS5/wDC0y7XDbLkizcXa1gnxquINaRJnzJRwelxZFf3bXLa3AL6naUzAJYVhIsdnWN7P3QajxIAasO9ZTjEqUfLuVJXJX6k+qI7B4G2A0G1SmA1A8vCngIg4GsIjzENdGVdgP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307767; c=relaxed/simple;
	bh=jUlUkUZ/8dRb/EDcAZ1Z91+YLA2/sEZ0Hs2BlGpkv+4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ljn9vdn3ERs7PHFbH281CZ+96XKOL6GYvMrtYz/c382CcCYhpybAVdkoB4rL2f0pTwhFl1lLZwzZk6nb5ZJPJwQuYiyjDv6jX4GzQja50sYjheOx6fbAlGHfflmthHM5UachIEVyFveyeXz/2glpkogh4g0Staz/6Fn9XL5/mgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SzJUBjdT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SzJUBjdT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756307764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vtMYdI+yafsqcqwR0/UzD8UhQwCzX1DzLMbhM3xXh8o=;
	b=SzJUBjdTqq7bciYqvo4eowwGn3GtJ2GZJ+9IFv2dHg8ncRCjrYwBqusirS0bcYsBQmLzUz
	+BWUy/JMUKp23/vMBQMAnLnEitno9XBk0X1D6S0irDei/8D6b3oY+jqZ7dcK7ll0hCnSMU
	6tIXCbYmZcO0lsEQzmddHJChRC/K5qQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-HdI1zEhCPMOmLVwYyVZDeA-1; Wed, 27 Aug 2025 11:16:00 -0400
X-MC-Unique: HdI1zEhCPMOmLVwYyVZDeA-1
X-Mimecast-MFC-AGG-ID: HdI1zEhCPMOmLVwYyVZDeA_1756307759
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b6490ea91so11428175e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 08:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756307759; x=1756912559;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vtMYdI+yafsqcqwR0/UzD8UhQwCzX1DzLMbhM3xXh8o=;
        b=JlaCg/+p0g9eUfXh4Kh3tqcH8p9v2nhgEGpDQAiZDM9RmXMp9XCNd+YSpXufcF7x0W
         p5bUcudqTLZTcuCqVhsAZRROJHs55agCiKBxQuEWEzbi+/klc0BoZ5bg2WBu4TQAplZ8
         iqcJYTDNHZbh+eqFbStKo5x5JIThGAFHWfxsIu2t0aIxf4wHnlWzKF8v8ox4ognz0E4Z
         mP/BR33Wbk6f2lAHmbmbSkWlPyfZhY2D6s3EhxuCiyquj0vfB8vk3+6A/dMgG56oppoG
         TrrlTAUui7KcHsRL1BqqVOQWGUD99UsMex2x8GeBgRv6aFkllVQuR6fXaPfzEHOqAjd6
         Sw4w==
X-Forwarded-Encrypted: i=1; AJvYcCWxiET1GO4TwnexB9o4cR1/kgKGpW5VscG3uPauR1eeEPkcubG3omVYcGX2hoFBBFWGFXf7orp1IDI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9j21A7fOG6cJJP8AV+QiegKzqw9A8FS4bO3ft+cceQ7t5UWXq
	ODv3oKg2d7NpN4Xcetk8ZN1HmDZwjtrgzILRf8uFV+2elHlCaxRJHhHnF+KPDK6tSqawB6BhBR1
	4XGtJfXOpJnv7XzQRGtlV1BikuUzC0GbqgfJyp+TqPoTdcKXQIqwVvfDkV2Ql
X-Gm-Gg: ASbGncv+pHNSqc4jCd/9yQ4hVB7aRw0+3GLUbbM8S0gQJTceXtDH0hpHfDejtJqR6V6
	fnhjkJvMnlM/xOsFI9WoKXInbQmq6Z7tYRS3/uf37PF5RTTiTkt+dcJIj0SrlZPIIEj4JYx1kEl
	eLNUschE/p51qlVZmxmZaeKRB6pJc6N9qxfr9zMyfbM1iKbeKTASR47lNVbvAt8yYxhDTYo4tL1
	fhx2h/FvFxt1MFc4XMgX1iGCh9vEZ2R9zKOEHyX9n1P0d3WE5ugYNU/3WcMC2EmsgxT/zMhgSIQ
	QitcLMsMNgIX6bSG0Q==
X-Received: by 2002:a05:600c:1f8f:b0:456:1a41:f932 with SMTP id 5b1f17b1804b1-45b517b9a7bmr144280535e9.22.1756307759291;
        Wed, 27 Aug 2025 08:15:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6CoMiqgq5dnrSq5DtIqWX8eEWXPPN2tOnWY/GpftY55mHm6cTRGAA5YOpuk+XbmMv3RzAOw==
X-Received: by 2002:a05:600c:1f8f:b0:456:1a41:f932 with SMTP id 5b1f17b1804b1-45b517b9a7bmr144280305e9.22.1756307758797;
        Wed, 27 Aug 2025 08:15:58 -0700 (PDT)
Received: from [127.0.0.2] ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0e27b2sm33896285e9.10.2025.08.27.08.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 08:15:58 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 27 Aug 2025 17:15:54 +0200
Subject: [PATCH v2 2/4] xfs_quota: utilize file_setattr to set prjid on
 special files
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-xattrat-syscall-v2-2-82a2d2d5865b@kernel.org>
References: <20250827-xattrat-syscall-v2-0-82a2d2d5865b@kernel.org>
In-Reply-To: <20250827-xattrat-syscall-v2-0-82a2d2d5865b@kernel.org>
To: aalbersh@kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7109; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=OCAVYG258W7Af2EdQLExdEEBR5XHyJJSbqHxIhWHiTE=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtYr6qh51OjJzD/1JqzxgNXJ2dm8WoFPpHzOi820P
 iv+IIpd711HKQuDGBeDrJgiyzppralJRVL5Rwxq5GHmsDKBDGHg4hSAiSyVZWT4IFiexX7/qf2c
 d07+e3YevJr5zcCzZrKJGZtVu4xLg0UUI8P+vZMeP7WPvPwtZa721Mz27nnPvl56X/ah5+jhpwa
 nHktzAQDePUd8
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
index adb26945fa57..857b1abe71c7 100644
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
+	dfd = open(dir, O_RDONLY|O_NOCTTY);
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
2.49.0

