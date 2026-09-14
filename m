Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D7A374A19
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 05:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789365062; cv=none; b=msRPs1yiQ75BRRY9EeJDIYKcyPfqiD96wkpy7qkts0efUqHqqi1/kpgU6AEiZPWU+CYPxMwLW0yyPP+SU5Gh5Oxj4ETQNAmXdMg7C4s8be0J/brk3hr+DhatkdhFhNoZ7G2fsc5FyGmtxPPCZHxcqMhRLRSQfpC+mdLMnpRuIKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789365062; c=relaxed/simple;
	bh=1W3BvLkKT+Zd4nKhCGRufBVc5j4JZx3H7vd7Jys4IyM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B+0Lmkfezid1Hvochb+X6OTChK88vUxfbbbTkeXUdKSUHnRYrcbY24VHZ4T5rAF7RSaZJTbWWud2TdNn+62PZBnfT+00AegJFCFljJ9bS9zUx1wUnsLdrvdKqn6tq5YYVlnqLffrUC/lrNzbzsbfhPtEzyII5bsymfxKnjwwWm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y6n9sLK/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y6n9sLK/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7F8C81F000FF;
	Mon, 14 Sep 2026 05:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789365053;
	bh=cwUXJvCq2tb9fKRkX/7/4ndf4ziu+hbz1GrSeplIW3Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Y6n9sLK/iXlGlUvyD8PhxrnLyRuBFUZJAVJkuRfMfCi/BAdk6iNreV5LLQd6+wv28
	 +V9iU8FNVIi3unNsP0pBT+NB4OG3J++Jyl0aHHS0hTO6anVgHZZHwBJOu0mAl/1vGj
	 nNystAyrHXmYe+rI2+NTUsJtFHMqaA69H2tlaC6sDzE+yhfZAXIiMFcLlP+nNxvJ+j
	 GKRGPtuWwsXGBuZIMf1huiueCIzOaB/A8EO7u6q+PfjTJD2Te7Q3Ox5IzUqJ25mAI8
	 ciCRbCtXG5dM0BEZBp42DYBnLIoqoy3FkJ8zxAoEN4G2l2XM07e68nP76MG/qupd9T
	 zVDuxlu6EMbxQ==
Date: Sun, 13 Sep 2026 22:50:53 -0700
Subject: [PATCH 5/7] libfrog: add quotactl_fd support to xfsquotactl
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178936484899.2108717.17872277106848553305.stgit@frogsfrogsfrogs>
In-Reply-To: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
References: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add support for the quotactl_fd syscall to the xfsquotactl call in
libfrog.  I rearranged the function arguments so that the fs connection
point (either an open fd or the fs source) come first.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/quotactl.h    |    2 +-
 configure.ac          |    1 +
 include/builddefs.in  |    1 +
 libfrog/Makefile      |    4 ++++
 libfrog/quotactl.c    |   15 +++++++++++++--
 m4/package_libcdev.m4 |   19 +++++++++++++++++++
 quota/edit.c          |    7 ++++---
 7 files changed, 43 insertions(+), 6 deletions(-)


diff --git a/libfrog/quotactl.h b/libfrog/quotactl.h
index dae03b787b7663..9df9327402726d 100644
--- a/libfrog/quotactl.h
+++ b/libfrog/quotactl.h
@@ -20,7 +20,7 @@ enum xfs_quota_cmd {
 	XFS_GETNEXTQUOTA, /* get disk limits and usage */
 };
 
-int xfsquotactl(enum xfs_quota_cmd xcommand, const char *device,
+int xfsquotactl(int mnt_fd, const char *device, enum xfs_quota_cmd xcommand,
 		unsigned int xtype, unsigned int id, void *addr);
 
 struct fs_path;
diff --git a/configure.ac b/configure.ac
index 40ccd88aa2a950..8a2505e37c70ab 100644
--- a/configure.ac
+++ b/configure.ac
@@ -195,6 +195,7 @@ if test "$have_listmount" = "yes"; then
 fi
 AC_HAVE_STATMOUNT_SUPPORTED_MASK
 AC_HAVE_FANOTIFY_MOUNTINFO
+AC_HAVE_QUOTACTL_FD
 
 if test "$enable_ubsan" = "yes" || test "$enable_ubsan" = "probe"; then
         AC_PACKAGE_CHECK_UBSAN
diff --git a/include/builddefs.in b/include/builddefs.in
index 3b52d1afd7031c..5d2e6c1b90ddbe 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -126,6 +126,7 @@ HAVE_LISTMOUNT_NS_FD = @have_listmount_ns_fd@
 HAVE_STATMOUNT_SUPPORTED_MASK = @have_statmount_supported_mask@
 NEED_INTERNAL_STATMOUNT = @need_internal_statmount@
 HAVE_FANOTIFY_MOUNTINFO = @have_fanotify_mountinfo@
+HAVE_QUOTACTL_FD = @have_quotactl_fd@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/libfrog/Makefile b/libfrog/Makefile
index b0e8d1a10cd0c7..c7bcd6a778d702 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -108,6 +108,10 @@ ifeq ($(HAVE_LISTMOUNT_NS_FD),yes)
 CFLAGS+=-DHAVE_LISTMOUNT_NS_FD
 endif
 
+ifeq ($(HAVE_QUOTACTL_FD),yes)
+CFLAGS += -DHAVE_QUOTACTL_FD
+endif
+
 default: ltdepend $(LTLIBRARY) $(GETTEXT_PY)
 
 crc32table.h: gen_crc32table.c crc32defs.h
diff --git a/libfrog/quotactl.c b/libfrog/quotactl.c
index 6129fa155ce75e..19b5405be47946 100644
--- a/libfrog/quotactl.c
+++ b/libfrog/quotactl.c
@@ -56,14 +56,24 @@ xcommand_to_qcommand(
 
 int
 xfsquotactl(
-	enum xfs_quota_cmd	xcommand,
+	int			mnt_fd,
 	const char		*device,
+	enum xfs_quota_cmd	xcommand,
 	uint			xtype,
 	uint			id,
 	void			*addr)
 {
 	const int		op = QCMD(xcommand_to_qcommand(xcommand),
 					  xtype_to_qtype(xtype));
+	int			ret = -1;
+
+	errno = ENOSYS;
+#ifdef HAVE_QUOTACTL_FD
+	if (mnt_fd >= 0)
+		ret = syscall(SYS_quotactl_fd, mnt_fd, op, id, addr);
+#endif
+	if (ret != -1 || errno != ENOSYS)
+		return ret;
 
 	return quotactl(op, device, id, addr);
 }
@@ -76,5 +86,6 @@ xfrog_quotactl(
 	uint			id,
 	void			*addr)
 {
-	return xfsquotactl(xcommand, mount->fs_name, xtype, id, addr);
+	return xfsquotactl(mount->mnt_fd, mount->fs_name, xcommand, xtype, id,
+			addr);
 }
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 9586bc01fe0f25..5c1b6e4667d0ee 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -476,3 +476,22 @@ AC_DEFUN([AC_HAVE_FANOTIFY_MOUNTINFO],
        AC_MSG_RESULT(no))
     AC_SUBST(have_fanotify_mountinfo)
   ])
+
+#
+# Check if we have a quotactl_fd system call (5.14).
+#
+AC_DEFUN([AC_HAVE_QUOTACTL_FD],
+  [AC_MSG_CHECKING([for quotactl_fd])
+    AC_LINK_IFELSE(
+    [AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <sys/syscall.h>
+#include <unistd.h>
+  ]], [[
+	return syscall(SYS_quotactl_fd);
+  ]])
+    ], have_quotactl_fd=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_quotactl_fd)
+  ])
diff --git a/quota/edit.c b/quota/edit.c
index d28a4319024038..cf4f8cdaeead63 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -140,6 +140,7 @@ set_limits(
 	uint32_t	id,
 	uint		type,
 	uint		mask,
+	int		mnt_fd,
 	char		*dev,
 	uint64_t	*bsoft,
 	uint64_t	*bhard,
@@ -162,7 +163,7 @@ set_limits(
 	d.d_rtb_hardlimit = *rtbhard;
 	d.d_rtb_softlimit = *rtbsoft;
 
-	if (xfsquotactl(XFS_SETQLIM, dev, type, id, (void *)&d) < 0) {
+	if (xfsquotactl(mnt_fd, dev, XFS_SETQLIM, type, id, (void *)&d) < 0) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot set limits: %s\n"),
 				progname, strerror(errno));
@@ -310,7 +311,7 @@ limit_f(
 	if (id == -1)
 		return 0;
 
-	set_limits(id, type, mask, fs_path->fs_name,
+	set_limits(id, type, mask, fs_path->mnt_fd, fs_path->fs_name,
 		   &bsoft, &bhard, &isoft, &ihard, &rtbsoft, &rtbhard);
 	return 0;
 }
@@ -356,7 +357,7 @@ restore_file(
 			mask = FS_DQ_ISOFT|FS_DQ_IHARD|FS_DQ_BSOFT|FS_DQ_BHARD;
 			if (cnt == 7)
 				mask |= FS_DQ_RTBSOFT|FS_DQ_RTBHARD;
-			set_limits(id, type, mask, dev, &bsoft, &bhard,
+			set_limits(id, type, mask, -1, dev, &bsoft, &bhard,
 					&isoft, &ihard, &rtbsoft, &rtbhard);
 		}
 	}

