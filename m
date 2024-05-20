Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6621F136E21
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 16:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716223945; cv=none; b=sEB6Bf8uVK2YpogRGfM0/fGpOi34kNGDdFSgWzo4qbvBlsOHKDXlXaQ+1ljXrIvm94NwizC6FBYpYbOqWH+BizDT+LVeTGk9OPy725n3Z/rafLdY2UgNmd9KHZOPJwdJcA847nNRat8P5Xh4Mjja1G08IQHm5nkSQB/5tKZ6gb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716223945; c=relaxed/simple;
	bh=aKiR1XDkQvTdKOxILDKPX6CTWBi4iMUywYD916jJB7w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I/qlEhYhZ18hObRUg8lXyi+55w1fMGrWt5WQ5dwAYwtqsoWwoXoP7wnuWZ18kGDrWeFzZ8wcHdGQBPyCR7/mSWzaSLvzFlXD3/W35p31BwDCRN4RG1Tqp+lVU1sZz5YuX6BunL/51QSKOqh3VKT1Cvy+bQ+TTjvPzZAuZGmB5mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fs3RlrYd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fs3RlrYd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716223942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=65H4te+myzQavgKsFnf2LkjMdfX6nM/bERzoSlqXCrM=;
	b=fs3RlrYdmcHj7z9ecGmY8lEXFAjX9GxKykIp5ES3ufnoPRcZggN4k5mdDCbMa0Tf5UWRz5
	Mjwa1xorN65SvQBkNGx+VqQi8ogbr2XxVxRUj3HhVnJOacroUU0G768RpOErznbaVtYx8n
	RjgfElimHqaO/JjZ3horrcOP6rO/yWc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-TtdvfJwyP8uUhjcr7Q1Dhw-1; Mon, 20 May 2024 12:52:20 -0400
X-MC-Unique: TtdvfJwyP8uUhjcr7Q1Dhw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a59c942611bso714291966b.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 09:52:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716223939; x=1716828739;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=65H4te+myzQavgKsFnf2LkjMdfX6nM/bERzoSlqXCrM=;
        b=cHY5O3oMxU7c7CBCXNaz9ov8ZSs/6UopyUAmiO0+qZKrhcpjnDBxfWX6CKDbD42+oZ
         uttQCKcV5SVf4Y6rU4J1Ls/GjkUH5j1tQlq4P8a3hg6oe4/pgCSFn+N9Y0I/FHwvq0O0
         dI/LEfYvK3U7JDSGf8XiFxvQangGXoVrI1XapU/AYkHKPd0/ap+Y5MEe0KHbHhIPrSz/
         uKFZa3s/sawUSpRdgsrNjKJOpo8po/jqcNTcQ1QZRY11hkL0UrZ9leWr6kVGiBArLeVE
         F16Akw1fd9IsHNuSrLe763oCFVGR753qwNNTxhG6b5KccNiJPnD/29/OS7cuozpzsI2q
         7k/w==
X-Gm-Message-State: AOJu0YzbtHbO0HjZXuU5hWNK0OWYq3FZGYP02N7dbfdrKXmITijO93ql
	po26eQCWVgfEVbDtKA+yaItFQ68SX8Gs6CjOxt/3BuuwHvKn65WY2oRE3QFe0b1gv0InTqyfK1S
	Z2AiF2F5mMoXVUPOcwnQAh0HQbgwKvdXLWG1OZJ3GNeVNQ4c7GCAxCMWP66i55/G768wlFaTA1/
	F7B2UpJO90O7v99pyFNp+8CX7K5gATQXDhurr/SZGN
X-Received: by 2002:a17:906:b79a:b0:a59:ccc8:577a with SMTP id a640c23a62f3a-a5a2d66547amr2150322366b.47.1716223938854;
        Mon, 20 May 2024 09:52:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwPTLaFSlIAXQMsNIHqjUFE608wWepoTCUbbweO/gzYDF5wFa4Hg2WLzPcKhn3LTqy+7kr6g==
X-Received: by 2002:a17:906:b79a:b0:a59:ccc8:577a with SMTP id a640c23a62f3a-a5a2d66547amr2150319866b.47.1716223938155;
        Mon, 20 May 2024 09:52:18 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a179c7e8fsm1464730466b.122.2024.05.20.09.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 09:52:17 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	cem@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2] libxfs/quota: utilize FS_IOC_FSSETXATTRAT to set prjid on special files
Date: Mon, 20 May 2024 18:52:01 +0200
Message-ID: <20240520165200.667150-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Utilize new FS_IOC_FS[SET|GET]XATTRAT ioctl to set project ID on
special files. Previously, special files were skipped due to lack of
the way to call FS_IOC_SETFSXATTR on them. The quota accounting was
therefore missing a few inodes (special files created before project
setup).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 include/linux.h |  14 +++++
 quota/project.c | 158 ++++++++++++++++++++++++++++++++----------------
 2 files changed, 120 insertions(+), 52 deletions(-)

diff --git a/include/linux.h b/include/linux.h
index 95a0deee2594..baae28727030 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -249,6 +249,20 @@ struct fsxattr {
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
 #endif
 
+#ifndef FS_IOC_FSGETXATTRAT
+/*
+ * Structure passed to FS_IOC_FSGETXATTRAT/FS_IOC_FSSETXATTRAT
+ */
+struct fsxattrat {
+	struct fsxattr	fsx;		/* XATTR to get/set */
+	__u32		dfd;		/* parent dir */
+	const char	*path;
+};
+
+#define FS_IOC_FSGETXATTRAT   _IOR ('X', 33, struct fsxattrat)
+#define FS_IOC_FSSETXATTRAT   _IOW ('X', 34, struct fsxattrat)
+#endif
+
 /*
  * Reminder: anything added to this file will be compiled into downstream
  * userspace projects!
diff --git a/quota/project.c b/quota/project.c
index adb26945fa57..438dd925c884 100644
--- a/quota/project.c
+++ b/quota/project.c
@@ -12,6 +12,8 @@
 static cmdinfo_t project_cmd;
 static prid_t prid;
 static int recurse_depth = -1;
+static int dfd;
+static int dlen;
 
 enum {
 	CHECK_PROJECT	= 0x1,
@@ -19,7 +21,7 @@ enum {
 	CLEAR_PROJECT	= 0x4,
 };
 
-#define EXCLUDED_FILE_TYPES(x) \
+#define SPECIAL_FILE(x) \
 	   (S_ISCHR((x)) \
 	|| S_ISBLK((x)) \
 	|| S_ISFIFO((x)) \
@@ -78,6 +80,71 @@ project_help(void)
 "\n"));
 }
 
+static int
+get_fsxattr(
+	const char		*path,
+	const struct stat	*stat,
+	struct FTW		*data,
+	struct fsxattr		*fsx)
+{
+	int			error;
+	int			fd;
+	struct fsxattrat	xreq = {
+		.fsx = { 0 },
+		.dfd = dfd,
+		.path = path + (data->level ? dlen + 1 : 0),
+	};
+
+	if (SPECIAL_FILE(stat->st_mode)) {
+		error = ioctl(dfd, FS_IOC_FSGETXATTRAT, &xreq);
+		if (error)
+			return error;
+
+		memcpy(fsx, &xreq.fsx, sizeof(struct fsxattr));
+		return error;
+	}
+
+	fd = open(path, O_RDONLY|O_NOCTTY);
+	if (fd == -1)
+		return errno;
+
+	error = ioctl(fd, FS_IOC_FSGETXATTR, fsx);
+	close(fd);
+
+	return error;
+}
+
+static int
+set_fsxattr(
+	const char		*path,
+	const struct stat	*stat,
+	struct FTW		*data,
+	struct fsxattr		*fsx)
+{
+	int			error;
+	int			fd;
+	struct fsxattrat	xreq = {
+		.fsx = { 0 },
+		.dfd = dfd,
+		.path = path + (data->level ? dlen + 1 : 0),
+	};
+
+	if (SPECIAL_FILE(stat->st_mode)) {
+		memcpy(&xreq.fsx, fsx, sizeof(struct fsxattr));
+		error = ioctl(dfd, FS_IOC_FSSETXATTRAT, &xreq);
+		return error;
+	}
+
+	fd = open(path, O_RDONLY|O_NOCTTY);
+	if (fd == -1)
+		return errno;
+
+	error = ioctl(fd, FS_IOC_FSSETXATTR, fsx);
+	close(fd);
+
+	return error;
+}
+
 static int
 check_project(
 	const char		*path,
@@ -85,8 +152,8 @@ check_project(
 	int			flag,
 	struct FTW		*data)
 {
-	struct fsxattr		fsx;
-	int			fd;
+	int			error;
+	struct fsxattr		fsx = { 0 };
 
 	if (recurse_depth >= 0 && data->level > recurse_depth)
 		return 0;
@@ -96,30 +163,23 @@ check_project(
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
+	error = get_fsxattr(path, stat, data, &fsx);
+	if (error) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, path, strerror(errno));
-	} else {
-		if (fsx.fsx_projid != prid)
-			printf(_("%s - project identifier is not set"
-				 " (inode=%u, tree=%u)\n"),
-				path, fsx.fsx_projid, (unsigned int)prid);
-		if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT) && S_ISDIR(stat->st_mode))
-			printf(_("%s - project inheritance flag is not set\n"),
-				path);
+		return 0;
 	}
-	if (fd != -1)
-		close(fd);
+
+	if (fsx.fsx_projid != prid)
+		printf(_("%s - project identifier is not set"
+				" (inode=%u, tree=%u)\n"),
+			path, fsx.fsx_projid, (unsigned int)prid);
+	if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT) && S_ISDIR(stat->st_mode))
+		printf(_("%s - project inheritance flag is not set\n"),
+			path);
+
 	return 0;
 }
 
@@ -130,8 +190,8 @@ clear_project(
 	int			flag,
 	struct FTW		*data)
 {
+	int			error;
 	struct fsxattr		fsx;
-	int			fd;
 
 	if (recurse_depth >= 0 && data->level > recurse_depth)
 		return 0;
@@ -141,32 +201,24 @@ clear_project(
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
-		return 0;
-	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx) < 0) {
+	error = get_fsxattr(path, stat, data, &fsx);
+	if (error) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
-			progname, path, strerror(errno));
-		close(fd);
+				progname, path, strerror(errno));
 		return 0;
 	}
 
 	fsx.fsx_projid = 0;
 	fsx.fsx_xflags &= ~FS_XFLAG_PROJINHERIT;
-	if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx) < 0) {
+
+	error = set_fsxattr(path, stat, data, &fsx);
+	if (error) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot clear project on %s: %s\n"),
 			progname, path, strerror(errno));
 	}
-	close(fd);
 	return 0;
 }
 
@@ -178,7 +230,7 @@ setup_project(
 	struct FTW		*data)
 {
 	struct fsxattr		fsx;
-	int			fd;
+	int			error;
 
 	if (recurse_depth >= 0 && data->level > recurse_depth)
 		return 0;
@@ -188,32 +240,24 @@ setup_project(
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
-		return 0;
-	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx) < 0) {
+	error = get_fsxattr(path, stat, data, &fsx);
+	if (error) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
-			progname, path, strerror(errno));
-		close(fd);
+				progname, path, strerror(errno));
 		return 0;
 	}
 
 	fsx.fsx_projid = prid;
 	fsx.fsx_xflags |= FS_XFLAG_PROJINHERIT;
-	if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx) < 0) {
+
+	error = set_fsxattr(path, stat, data, &fsx);
+	if (error) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot set project on %s: %s\n"),
 			progname, path, strerror(errno));
 	}
-	close(fd);
 	return 0;
 }
 
@@ -223,6 +267,14 @@ project_operations(
 	char		*dir,
 	int		type)
 {
+	dfd = open(dir, O_RDONLY|O_NOCTTY);
+	if (dfd < -1) {
+		printf(_("Error opening dir %s for project %s...\n"), dir,
+				project);
+		return;
+	}
+	dlen = strlen(dir);
+
 	switch (type) {
 	case CHECK_PROJECT:
 		printf(_("Checking project %s (path %s)...\n"), project, dir);
@@ -237,6 +289,8 @@ project_operations(
 		nftw(dir, clear_project, 100, FTW_PHYS|FTW_MOUNT);
 		break;
 	}
+
+	close(dfd);
 }
 
 static void
-- 
2.42.0

