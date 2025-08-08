Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D46287510
	for <linux-xfs@vger.kernel.org>; Fri,  8 Aug 2025 19:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754681428; cv=none; b=n8Kfrl+yJcDJPMpXvoSNNN83mQdPwCKMI36HtA+HI0EEtUBeS2vOvpM5p+BMny8e3DdGwRFI2eG7jmb9ShGUU5T8lDu/+Gnltg4KC/isDZb6jlcEf05buUh5O8GDCjPhsC/lh+0bLtIylaIGTdWSSaN7cG4cx0F+U5X/rjJ3g9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754681428; c=relaxed/simple;
	bh=eg/DSoHIYQ2Xa/D8nefv5BPFGPXBwI7m3WJ+RITvhfI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Gu6tA1SdQclXawhgD0FgDdDNBeNsYy8Maf2v6a/xnVku2LHV2CNqKNRXHLpemeIWXXgU0ARC0A/CF6irrKKl1TA2pABEgfoUiAnjUYc5N64ME0HZF3F9mJmNjMhbDZIK7wHp4Kvt2bOW4i7b/Dj5N00o5Tz+UtIMFSqP6PDltTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BpmhG2Gw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BpmhG2Gw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754681426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ey2QTtaZjTVUUOsnGVoF6yUZobYQXb+AIsFSKD5G0C0=;
	b=BpmhG2Gwet9put6WoRZjWOfNF3ZTUPOwoL5kmgLyRkuluf36cPwBrCMMlJ/O7udntf/JyS
	GIJxtyiyltR6Lc/jc4hMllMu/K4Ro796K3vRdQ84vX1l2i3VRGm5OLUCDw+SU+/wGvZh5+
	nVZRpA5ZyoMRVB8rwYL+MsZ0D2dfI0Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-jOmJCx05M3OUMx7zYwYCoQ-1; Fri, 08 Aug 2025 15:30:25 -0400
X-MC-Unique: jOmJCx05M3OUMx7zYwYCoQ-1
X-Mimecast-MFC-AGG-ID: jOmJCx05M3OUMx7zYwYCoQ_1754681424
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b8dac70703so1267717f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 08 Aug 2025 12:30:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754681423; x=1755286223;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ey2QTtaZjTVUUOsnGVoF6yUZobYQXb+AIsFSKD5G0C0=;
        b=jhwfwnu1iYc3xmJlRf/bPFypU7tcSjzP4oKJ/Rnd5CW2QfQ+FPCSkkyOsuI8nF44ZI
         8rE5NcwFqeVCCn8LkLCxGWXt28KIuZbmbgtKeluXtIgL6mvSdLX28SU+oXw6UOkSIbhH
         scu0agjcs4YVSAXbRuDfY3BcX2kYRRO9ZflnYqgRdUZt0xUXbB+WnXINO2Orjxnf9f+j
         3JwZlMs6BIuo4j3Zz7Gsq6f1HDD8NU4Yi6JNPMjdNGKXjJO2ON5OfLRmnBsOnsuU6cKC
         4HRG6GgaRSCpHf/xbhoOnx3tzpgDbOHFdHSGen1ltcVAje+TI1d5iEvexjOTHYcfsnOg
         uUoA==
X-Forwarded-Encrypted: i=1; AJvYcCV+Ekn5g7WZQnjD9vF6b2dAYXIgPbAJKbg/TVj4VnYjItpUBYInR3k3GFcuZTfqJwMLqor9IcIQWiw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLkzdc9bhyAQsZeaUIN/rE0T1xLqz/2SzJ31u2yunPxdAMT6T5
	kysmA8NQKMkuqMY5uQIptR/GXUcIEs0UzFnb12MCaRBQMtSwPdOIumBvw9LL9wNYR0tSLNgTawu
	4dgHdV/oAMsklIk7c77WT3icuJeaqeW3Cz0YczJIfSKhUfT8oP1z2CGLwPE14J3f9dDdQ
X-Gm-Gg: ASbGncvglkBKA966svnK+AdNHpct2qDMdZtIcWMLI/zvkh+J+WlQT2wOKNqgGFt02ad
	WO2ESJ6BGEz3+Au5g7DoHj0Z4UhZRM5luO+A6RgsiKDTS7S+MBGYWtmpG4ncG+kDlillIc4Hr4u
	/aEnvP1fDdIjkhitwQ1Rxjh6B+syTsqbWuzqiM0SoWcynD9F9YaQZmt2JBjDrwkZQBfCtY9XFDV
	ETvR+BHUf4rvmPRDHjhC41msaUmfbeCZyFHGEI4fh05IV9C5zsipfDMxCykM1e4dniaOcC6nj+3
	Z5Fa1IFzUCMxpLvZjrqU3QLr6Yi4e27IwAcaiJGn9hhf5Q==
X-Received: by 2002:a05:6000:4310:b0:3b7:8646:eeb3 with SMTP id ffacd0b85a97d-3b900fdd7edmr4459629f8f.15.1754681423332;
        Fri, 08 Aug 2025 12:30:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHStybTVVERxYlQ5+zy8iYCL9DbPx/EgBHkjUD++gkEHV1J8O+bbmjXRk4DCcfy6+bQ1MVIQ==
X-Received: by 2002:a05:6000:4310:b0:3b7:8646:eeb3 with SMTP id ffacd0b85a97d-3b900fdd7edmr4459602f8f.15.1754681422919;
        Fri, 08 Aug 2025 12:30:22 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8f8b1bc81sm8925162f8f.69.2025.08.08.12.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 12:30:21 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 08 Aug 2025 21:30:18 +0200
Subject: [PATCH 3/4] xfs_io: make ls/chattr work with special files
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250808-xattrat-syscall-v1-3-48567c29e45c@kernel.org>
References: <20250808-xattrat-syscall-v1-0-48567c29e45c@kernel.org>
In-Reply-To: <20250808-xattrat-syscall-v1-0-48567c29e45c@kernel.org>
To: aalbersh@kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5478; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=4zK7ywtk5dBgZL66VuvRbszYNCLsIpa4lxCLuNHStLE=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMqYFeKuVxcZelU5JM2vkTGw8ItItYsXgdNTsX/e++
 ZyOmd/mKXSUsjCIcTHIiimyrJPWmppUJJV/xKBGHmYOKxPIEAYuTgGYyPEChv8Z17bwVkUcydw4
 zXjWjrbz68/t4Td8vtx8lWBQSbGHcOVXRobT75xnmUiaznt8+Pamc38ex3Me3fVN19x1weKlmSd
 f6KkyAwDyOEc1
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

With new file_getattr/file_setattr syscalls we can now list/change file
attributes on special files instead for ignoring them.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 io/attr.c | 130 ++++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 75 insertions(+), 55 deletions(-)

diff --git a/io/attr.c b/io/attr.c
index fd82a2e73801..1cce602074f4 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -8,6 +8,7 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
+#include "libfrog/file_attr.h"
 
 static cmdinfo_t chattr_cmd;
 static cmdinfo_t lsattr_cmd;
@@ -156,36 +157,35 @@ lsattr_callback(
 	int			status,
 	struct FTW		*data)
 {
-	struct fsxattr		fsx;
-	int			fd;
+	struct file_attr	fa;
+	int			error;
 
 	if (recurse_dir && !S_ISDIR(stat->st_mode))
 		return 0;
 
-	if ((fd = open(path, O_RDONLY)) == -1) {
-		fprintf(stderr, _("%s: cannot open %s: %s\n"),
-			progname, path, strerror(errno));
-		exitcode = 1;
-	} else if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
+	error = file_getattr(AT_FDCWD, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
+	if (error) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, path, strerror(errno));
 		exitcode = 1;
-	} else
-		printxattr(fsx.fsx_xflags, 0, 1, path, 0, 1);
+		return 0;
+	}
+
+	printxattr(fa.fa_xflags, 0, 1, path, 0, 1);
 
-	if (fd != -1)
-		close(fd);
 	return 0;
 }
 
 static int
 lsattr_f(
-	int		argc,
-	char		**argv)
+	int			argc,
+	char			**argv)
 {
-	struct fsxattr	fsx;
-	char		*name = file->name;
-	int		c, aflag = 0, vflag = 0;
+	struct file_attr	fa;
+	char			*name = file->name;
+	int			c, aflag = 0, vflag = 0;
+	struct stat		st;
+	int			error;
 
 	recurse_all = recurse_dir = 0;
 	while ((c = getopt(argc, argv, "DRav")) != EOF) {
@@ -211,17 +211,27 @@ lsattr_f(
 	if (recurse_all || recurse_dir) {
 		nftw(name, lsattr_callback,
 			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
-	} else if ((xfsctl(name, file->fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
+		return 0;
+	}
+
+	error = stat(name, &st);
+	if (error)
+		return error;
+
+	error = file_getattr(AT_FDCWD, name, &st, &fa, AT_SYMLINK_NOFOLLOW);
+	if (error) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, name, strerror(errno));
 		exitcode = 1;
-	} else {
-		printxattr(fsx.fsx_xflags, vflag, !aflag, name, vflag, !aflag);
-		if (aflag) {
-			fputs("/", stdout);
-			printxattr(-1, 0, 1, name, 0, 1);
-		}
+		return 0;
 	}
+
+	printxattr(fa.fa_xflags, vflag, !aflag, name, vflag, !aflag);
+	if (aflag) {
+		fputs("/", stdout);
+		printxattr(-1, 0, 1, name, 0, 1);
+	}
+
 	return 0;
 }
 
@@ -232,44 +242,43 @@ chattr_callback(
 	int			status,
 	struct FTW		*data)
 {
-	struct fsxattr		attr;
-	int			fd;
+	struct file_attr	attr;
+	int			error;
 
 	if (recurse_dir && !S_ISDIR(stat->st_mode))
 		return 0;
 
-	if ((fd = open(path, O_RDONLY)) == -1) {
-		fprintf(stderr, _("%s: cannot open %s: %s\n"),
-			progname, path, strerror(errno));
-		exitcode = 1;
-	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &attr) < 0) {
+	error = file_getattr(AT_FDCWD, path, stat, &attr, AT_SYMLINK_NOFOLLOW);
+	if (error) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, path, strerror(errno));
 		exitcode = 1;
-	} else {
-		attr.fsx_xflags |= orflags;
-		attr.fsx_xflags &= ~andflags;
-		if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &attr) < 0) {
-			fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
-				progname, path, strerror(errno));
-			exitcode = 1;
-		}
+		return 0;
+	}
+
+	attr.fa_xflags |= orflags;
+	attr.fa_xflags &= ~andflags;
+	error = file_setattr(AT_FDCWD, path, stat, &attr, AT_SYMLINK_NOFOLLOW);
+	if (error) {
+		fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
+			progname, path, strerror(errno));
+		exitcode = 1;
 	}
 
-	if (fd != -1)
-		close(fd);
 	return 0;
 }
 
 static int
 chattr_f(
-	int		argc,
-	char		**argv)
+	int			argc,
+	char			**argv)
 {
-	struct fsxattr	attr;
-	struct xflags	*p;
-	unsigned int	i = 0;
-	char		*c, *name = file->name;
+	struct file_attr	attr;
+	struct xflags		*p;
+	unsigned int		i = 0;
+	char			*c, *name = file->name;
+	struct stat		st;
+	int			error;
 
 	orflags = andflags = 0;
 	recurse_all = recurse_dir = 0;
@@ -326,19 +335,30 @@ chattr_f(
 	if (recurse_all || recurse_dir) {
 		nftw(name, chattr_callback,
 			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
-	} else if (xfsctl(name, file->fd, FS_IOC_FSGETXATTR, &attr) < 0) {
+		return 0;
+	}
+
+	error = stat(name, &st);
+	if (error)
+		return error;
+
+	error = file_getattr(AT_FDCWD, name, &st, &attr, AT_SYMLINK_NOFOLLOW);
+	if (error) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, name, strerror(errno));
 		exitcode = 1;
-	} else {
-		attr.fsx_xflags |= orflags;
-		attr.fsx_xflags &= ~andflags;
-		if (xfsctl(name, file->fd, FS_IOC_FSSETXATTR, &attr) < 0) {
-			fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
-				progname, name, strerror(errno));
-			exitcode = 1;
-		}
+		return 0;
 	}
+
+	attr.fa_xflags |= orflags;
+	attr.fa_xflags &= ~andflags;
+	error = file_setattr(AT_FDCWD, name, &st, &attr, AT_SYMLINK_NOFOLLOW);
+	if (error) {
+		fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
+			progname, name, strerror(errno));
+		exitcode = 1;
+	}
+
 	return 0;
 }
 

-- 
2.49.0

