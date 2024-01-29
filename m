Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9ACB4F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513595; cv=none; b=UGZCGyoTpevq71aqEbZC4XBJaElVEEm5Adf1hMVByiXrKhJlBCb1d0wPXgxudqa4sKu87Cq3fA6pSa83C2cWG+r5nhAUu0hbZJmd5rBTUHI/2fKSkHEtKCTCRp4YUzuNfjOtohphyBWOGq7dU6VCZxQH6tC7qM1MDwjh8uqaGDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513595; c=relaxed/simple;
	bh=5EMDtBz3MlFfzd5zLe1Hd/qHYkedl1OEvwBGtuyYG0I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sEh1oLhA2wWNWFUDnag8oCtZlGl3TbpPb2iz9pQp0uGqAGw+CT5O+RxNb4FniHXGFE1H0LIWhmBHpYnxavMOegh9opnHz9EQSeDPhLnmGwEjDK041xXaj8Kg/S9ioJnCi9VKX3qbJDnR5dxKdxUTxHmLy1XqM1wqT8rKVGXMnbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j0i809GV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j0i809GV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5oXZwd1FKW6Byhk9UiVAGwbKowTxtnQkNC3uVKrvyQA=; b=j0i809GV+TMU6V0yh25dc830Wf
	L53cpKB8kFsqJUosXcyBT2s4+Lwel82RjCm4i8J17qF/fSXdvIiiYg5r5RqeK/7ih+R9K13sGH35f
	ziISihhW5idBOVlBpX0fJJTbLhGmhEyOOp0LdCzCQrZ12fZAkBF2zHkInhEXDB1VLPijCKNS1JIaQ
	gj4UkXY9VlCfB8sMP46jZXuifqkhK4Tjh3IC2ke4nYqhWpIv/DKSEXEouVd98XKkzOetYFgK7V65Q
	W9GZxO10AHm8CGGMRiy641DLiS7hSJH4NhEn9A0LX7fAVxbgQRKLs8UMt/iiPZcoLTiiIf/LHY0yA
	R17k45vw==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8n-0000000BclB-04sB;
	Mon, 29 Jan 2024 07:33:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 21/27] configure: don't check for fsetxattr
Date: Mon, 29 Jan 2024 08:32:09 +0100
Message-Id: <20240129073215.108519-22-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129073215.108519-1-hch@lst.de>
References: <20240129073215.108519-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

fsetxattr has been supported since Linux 2.4 and glibc 2.3.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 fsr/xfs_fsr.c         |  2 --
 include/builddefs.in  |  4 ----
 m4/package_libcdev.m4 | 13 -------------
 4 files changed, 20 deletions(-)

diff --git a/configure.ac b/configure.ac
index dd000f11c..ce9a8a935 100644
--- a/configure.ac
+++ b/configure.ac
@@ -164,7 +164,6 @@ AC_PACKAGE_NEED_RCU_INIT
 
 AC_HAVE_PWRITEV2
 AC_HAVE_COPY_FILE_RANGE
-AC_HAVE_FSETXATTR
 AC_NEED_INTERNAL_FSXATTR
 AC_NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG
 AC_NEED_INTERNAL_FSCRYPT_POLICY_V2
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index ba02506d8..971445c2d 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -954,7 +954,6 @@ fsr_setup_attr_fork(
 	int		tfd,
 	struct xfs_bstat *bstatp)
 {
-#ifdef HAVE_FSETXATTR
 	struct xfs_fd	txfd = XFS_FD_INIT(tfd);
 	struct stat	tstatbuf;
 	int		i;
@@ -1119,7 +1118,6 @@ out:
 	if (dflag && diff)
 		fsrprintf(_("failed to match fork offset\n"));;
 
-#endif /* HAVE_FSETXATTR */
 	return 0;
 }
 
diff --git a/include/builddefs.in b/include/builddefs.in
index 4b55f97cd..b84369ea7 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -92,7 +92,6 @@ HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 
 HAVE_PWRITEV2 = @have_pwritev2@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
-HAVE_FSETXATTR = @have_fsetxattr@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
 NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG = @need_internal_fscrypt_add_key_arg@
 NEED_INTERNAL_FSCRYPT_POLICY_V2 = @need_internal_fscrypt_policy_v2@
@@ -125,9 +124,6 @@ DEPENDFLAGS = -D__linux__
 ifeq ($(HAVE_MNTENT),yes)
 PCFLAGS+= -DHAVE_MNTENT
 endif
-ifeq ($(HAVE_FSETXATTR),yes)
-PCFLAGS+= -DHAVE_FSETXATTR
-endif
 ifeq ($(NEED_INTERNAL_FSXATTR),yes)
 PCFLAGS+= -DOVERRIDE_SYSTEM_FSXATTR
 endif
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index dd04be5f0..ff0e83752 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -35,19 +35,6 @@ syscall(__NR_copy_file_range, 0, 0, 0, 0, 0, 0);
     AC_SUBST(have_copy_file_range)
   ])
 
-#
-# Check if we have a fsetxattr call
-#
-AC_DEFUN([AC_HAVE_FSETXATTR],
-  [ AC_CHECK_DECL([fsetxattr],
-       have_fsetxattr=yes,
-       [],
-       [#include <sys/types.h>
-        #include <sys/xattr.h>]
-       )
-    AC_SUBST(have_fsetxattr)
-  ])
-
 #
 # Check if we need to override the system struct fsxattr with
 # the internal definition.  This /only/ happens if the system
-- 
2.39.2

