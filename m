Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361DE16C445
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 15:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715267888; cv=none; b=jeXtwUQ1P9UZyzqYcYSnqS7IBulV+I1DUlJ1Cd6t/Ubq4yWySAB1p61OcoGeP78wyxEJ+bnQ5aMNzNzATOiU8ZLihWbXUOmdTY7ar5FOES21d7WeL5AF0anMUn4/dXPwIDcyE398K93XDle8i4FVIgre7VCrO04mFVNDqiCfYtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715267888; c=relaxed/simple;
	bh=6mV8A/myla9ZZkQcCIn2TvAbEodWU/m2x+V14X4P99w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G1hhUiRJsc95vu3K1WT+MUcHcNioS7jiMhhVIMXYXKZA90e4mKXD+bVpMqzUU4N4BbgNYZwRAW/QJpkeuEyuuXFIddVDXe/cVne/CmLIHGLI9PNchEFCV9ogFBUZ7+I3/lnxDrlOyDQxeWNaQa3HsTSRGAC/46gHJWKtrn4AaKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FyB8uodU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FyB8uodU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715267886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2gYxaGmRqDtEFosgQHip4kQbPw7cWCu0+FSBYFkz7Hk=;
	b=FyB8uodU1Tmznpd7ouWZ5q02+5KC+J3UVFJMZyDegK/DfyES9Q0jy+ufs587E3pInZ4WCP
	85poQH8+IhY8w3GJr5zxK1o4OArzwP6h6vNinI5LbItM5DVr8zq4wMt2gKulXQYuLo+p6D
	ISZaMuz7ydF19fIYZtIcIlJabivZNPI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-FvI2LAKFP1WWRf3Ty5cdyA-1; Thu, 09 May 2024 11:18:04 -0400
X-MC-Unique: FvI2LAKFP1WWRf3Ty5cdyA-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-572f3859ff2so421706a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 09 May 2024 08:18:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715267883; x=1715872683;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2gYxaGmRqDtEFosgQHip4kQbPw7cWCu0+FSBYFkz7Hk=;
        b=D+MKV+bzdB8LNLEGhvilvrI+VZIGAeW2+V5ccL2Y5VTomGz8kvMTx4BXPEhvkcSx3I
         r88jxkUjFvsRfouuPclObbkdwN4CyA+DCnqovNdidV4tF/ZcHnoVrEGg9MgnGcacnp3L
         dfU8eYGf539tKQmM+kFmBUG4XTngAMOBxOlDn44uvnM1QQW1HC8Ryv7uJYuGf4FLhvxZ
         YETtXLKCCxf2n08VbioTMNyhXqGv0+QikhtrnfShxD/FZSiwVh4Sw2wIzZf8/YSxHNxe
         RrrlF9ouBYm6G3YzdxNL9c7rGK69RGF9LLjyNaSA7Xr/c6Jc53/VcSx+iGn5sGGp1HZG
         eW/Q==
X-Forwarded-Encrypted: i=1; AJvYcCX4oduQltmSVLxFSk1xjqeGCteW2nDQ3ggHUp1Q0Jwk7W7HUSJWg98uE6OpFKV1g/igD01N5/xi9blCP/Vgo+C8rSrG/CoQldIG
X-Gm-Message-State: AOJu0YzyVtA9BnYi/rEYuKJytne1/6M0qppYEzZTV/+bOnOECEBnORy+
	n0zJ4ftuucRgXTVfHVkYq/NEXaSlbdtGz8/tNzR/JHmigbzigKGlaVsHXuRSHw/RnzUdMDUEDHM
	476S91NAfQfmFDf9///vbgzQoqdwAw6tbDwuZs09GrIJMX+xnabNHZu2N
X-Received: by 2002:a50:a417:0:b0:570:5b70:d76d with SMTP id 4fb4d7f45d1cf-5734d67aacamr5165a12.28.1715267882620;
        Thu, 09 May 2024 08:18:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEd4DXfhj51dYdObjVILgPRWz36eNMiJN0V5KfnUfNcjtyyQ8B4iGrxFXc0n7SekQEEVZoGLg==
X-Received: by 2002:a50:a417:0:b0:570:5b70:d76d with SMTP id 4fb4d7f45d1cf-5734d67aacamr5133a12.28.1715267881682;
        Thu, 09 May 2024 08:18:01 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-573409d7763sm609899a12.75.2024.05.09.08.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 08:18:01 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-fsdevel@vgre.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH] libxfs/quota: utilize XFS_IOC_SETFSXATTRAT to set prjid on special files
Date: Thu,  9 May 2024 17:17:15 +0200
Message-ID: <20240509151714.3623695-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Utilize new XFS ioctl to set project ID on special files.
Previously, special files were skipped due to lack of the way to
call FS_IOC_SETFSXATTR on them. The quota accounting was therefore
missing a few inodes (special files created before project setup).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 libxfs/xfs_fs.h |  11 ++++
 quota/project.c | 139 +++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 144 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 6360073865db..1a560dfa7e15 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -662,6 +662,15 @@ typedef struct xfs_swapext
 	struct xfs_bstat sx_stat;	/* stat of target b4 copy */
 } xfs_swapext_t;
 
+/*
+ * Structure passed to XFS_IOC_GETFSXATTRAT/XFS_IOC_GETFSXATTRAT
+ */
+struct xfs_xattrat_req {
+	struct fsxattr	__user *fsx;		/* XATTR to get/set */
+	__u32		dfd;			/* parent dir */
+	const char	__user *path;		/* NUL terminated path */
+};
+
 /*
  * Flags for going down operation
  */
@@ -837,6 +846,8 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
 #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
+#define XFS_IOC_GETFSXATTRAT	     _IOR ('X', 130, struct xfs_xattrat_req)
+#define XFS_IOC_SETFSXATTRAT	     _IOW ('X', 131, struct xfs_xattrat_req)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/quota/project.c b/quota/project.c
index adb26945fa57..e6059db93a77 100644
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
@@ -78,6 +80,42 @@ project_help(void)
 "\n"));
 }
 
+static int
+check_special_file(
+	const char		*path,
+	const struct stat	*stat,
+	int			flag,
+	struct FTW		*data)
+{
+	int			error;
+	struct fsxattr		fa;
+	struct xfs_xattrat_req	xreq = {
+		.fsx = &fa,
+		.dfd = dfd,
+		.path = path + (data->level ? dlen + 1 : 0),
+	};
+
+	error = xfsctl(path, dfd, XFS_IOC_GETFSXATTRAT, &xreq);
+	if (error == -ENOTTY) {
+		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
+		return 0;
+	}
+
+	if (error) {
+		exitcode = 1;
+		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
+			progname, path, strerror(errno));
+		return 0;
+	}
+
+	if (xreq.fsx->fsx_projid != prid)
+		printf(_("%s - project identifier is not set"
+			 " (inode=%u, tree=%u)\n"),
+			path, xreq.fsx->fsx_projid, (unsigned int)prid);
+
+	return 0;
+}
+
 static int
 check_project(
 	const char		*path,
@@ -97,8 +135,7 @@ check_project(
 		return 0;
 	}
 	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
-		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
-		return 0;
+		return check_special_file(path, stat, flag, data);
 	}
 
 	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
@@ -123,6 +160,48 @@ check_project(
 	return 0;
 }
 
+static int
+clear_special_file(
+	const char		*path,
+	const struct stat	*stat,
+	int			flag,
+	struct FTW		*data)
+{
+	int			error;
+	struct fsxattr		fa;
+	struct xfs_xattrat_req	xreq = {
+		.fsx = &fa,
+		.dfd = dfd,
+		.path = path + (data->level ? dlen + 1 : 0),
+	};
+
+	error = xfsctl(path, dfd, XFS_IOC_GETFSXATTRAT, &xreq);
+	if (error == -ENOTTY) {
+		fprintf(stderr, _("%s: skipping special file %s\n"),
+				progname, path);
+		return 0;
+	}
+
+	if (error) {
+		exitcode = 1;
+		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
+			progname, path, strerror(errno));
+		return 0;
+	}
+
+	xreq.fsx->fsx_projid = 0;
+	xreq.fsx->fsx_xflags &= ~FS_XFLAG_PROJINHERIT;
+	error = xfsctl(path, dfd, XFS_IOC_SETFSXATTRAT, &xreq);
+	if (error) {
+		exitcode = 1;
+		fprintf(stderr, _("%s: cannot clear project on %s: %s\n"),
+			progname, path, strerror(errno));
+		return 0;
+	}
+
+	return 0;
+}
+
 static int
 clear_project(
 	const char		*path,
@@ -142,8 +221,7 @@ clear_project(
 		return 0;
 	}
 	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
-		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
-		return 0;
+		return clear_special_file(path, stat, flag, data);
 	}
 
 	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
@@ -170,6 +248,47 @@ clear_project(
 	return 0;
 }
 
+static int
+setup_special_file(
+	const char		*path,
+	const struct stat	*stat,
+	int			flag,
+	struct FTW		*data)
+{
+	int			error;
+	struct fsxattr		fa;
+	struct xfs_xattrat_req	xreq = {
+		.fsx = &fa,
+		.dfd = dfd,
+		/* Cut path to parent - make it relative to the dfd */
+		.path = path + (data->level ? dlen + 1 : 0),
+	};
+
+	error = xfsctl(path, dfd, XFS_IOC_GETFSXATTRAT, &xreq);
+	if (error == -ENOTTY) {
+                fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
+                return 0;
+        }
+
+	if (error) {
+		exitcode = 1;
+		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
+			progname, path, strerror(errno));
+		return 0;
+	}
+	xreq.fsx->fsx_projid = prid;
+	xreq.fsx->fsx_xflags |= FS_XFLAG_PROJINHERIT;
+	error = xfsctl(path, dfd, XFS_IOC_SETFSXATTRAT, &xreq);
+	if (error) {
+		exitcode = 1;
+		fprintf(stderr, _("%s: cannot set project on %s: %s\n"),
+			progname, path, strerror(errno));
+		return 0;
+	}
+
+	return 0;
+}
+
 static int
 setup_project(
 	const char		*path,
@@ -189,8 +308,7 @@ setup_project(
 		return 0;
 	}
 	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
-		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
-		return 0;
+		return setup_special_file(path, stat, flag, data);
 	}
 
 	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
@@ -223,6 +341,13 @@ project_operations(
 	char		*dir,
 	int		type)
 {
+	if ((dfd = open(dir, O_RDONLY|O_NOCTTY)) == -1) {
+		printf(_("Error opening dir %s for project %s...\n"), dir,
+				project);
+		return;
+	}
+	dlen = strlen(dir);
+
 	switch (type) {
 	case CHECK_PROJECT:
 		printf(_("Checking project %s (path %s)...\n"), project, dir);
@@ -237,6 +362,8 @@ project_operations(
 		nftw(dir, clear_project, 100, FTW_PHYS|FTW_MOUNT);
 		break;
 	}
+
+	close(dfd);
 }
 
 static void
-- 
2.42.0

