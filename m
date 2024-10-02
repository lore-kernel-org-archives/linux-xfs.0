Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B634431
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831584; cv=none; b=qY3ZFRYxsPdjjZNpWD0y2Su7CSi25RvFMkCro/Cf1ic7gaXZ6OdsniAyuvhLKONAenYEqCG/URANuQgMQAvow8NCzo0jt8PimE4CTBlKIdr89Ay3y8IxCuw4t624OhQhNfSjN3Z8TzKicaaBHPUehegvp67/YqnbA9Akg3tUG1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831584; c=relaxed/simple;
	bh=NTcS6/c8hfHS//N10CXgenOQeKh9HJeqsAoBg5YzLcE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d6Lqbej8Vx1E1/s8GFSXeBtxTvtjXzmLJ+phGjsJ0VX7DbPMYZOIQzCHsMiPDY9AdraqeO9n9DXQp0fnU3dWdPcgJ6X/eb2Zw3UNjD03qbDQjo00s0xrlGq4Sn7YhDHhWjNlyNMed4fC/9tnKTfg32oNW5MuoYcSHyzewAKcOLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uFpuHGGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uFpuHGGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8DCC4CEC6;
	Wed,  2 Oct 2024 01:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831583;
	bh=NTcS6/c8hfHS//N10CXgenOQeKh9HJeqsAoBg5YzLcE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uFpuHGGQr7vTcxJoF/Cpx8tCTWMDZcBqGiyqdUO0A483GKdVwevZdd3cq96tje/yC
	 stUdsBeMcqOrNwuVGbNJYlMRGhvgQaACADb+Gm2fqelC8QXwPNLntModjfoRgslhT3
	 4Im3hEgtGjnsDdOs8BaYF6Ub5XmuK/C6XGKh716tlXhQmwvr5bYeEd12PYxFsLnAkG
	 AJxQDEJGegqcnlcfvH0j5b47r+RrKFYXGGBQ3C1xrNCjVK3B9uM7ROzqp7ERJQ1fIy
	 chAqfURcOtVtChuyT1NW+kJyQTe8qOqQp+WKtq1ZQ21cMDyrkRStzPOj2gIel5R6K5
	 UzonRnE5YDukw==
Date: Tue, 01 Oct 2024 18:13:02 -0700
Subject: [PATCH 20/64] libxfs: implement get_random_u32
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783102082.4036371.11970213127667558908.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Actually query the kernel for some random bytes instead of returning
zero, if that's possible.  The most noticeable effect of this is that
mkfs will now create the rtbitmap file, the rtsummary file, and children
of the root directory with a nonzero generation.  Apparently xfsdump
requires that the root directory have a generation number of zero.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |    1 +
 include/builddefs.in  |    1 +
 libxfs/Makefile       |    4 ++++
 libxfs/libxfs_priv.h  |   11 +++++++----
 libxfs/util.c         |   19 +++++++++++++++++++
 m4/package_libcdev.m4 |   15 +++++++++++++++
 mkfs/proto.c          |    3 +++
 7 files changed, 50 insertions(+), 4 deletions(-)


diff --git a/configure.ac b/configure.ac
index d021c519d..1c9fa8173 100644
--- a/configure.ac
+++ b/configure.ac
@@ -152,6 +152,7 @@ AC_HAVE_DEVMAPPER
 AC_HAVE_MALLINFO
 AC_HAVE_MALLINFO2
 AC_HAVE_MEMFD_CREATE
+AC_HAVE_GETRANDOM_NONBLOCK
 if test "$enable_scrub" = "yes"; then
         if test "$enable_libicu" = "yes" || test "$enable_libicu" = "probe"; then
                 AC_HAVE_LIBICU
diff --git a/include/builddefs.in b/include/builddefs.in
index 07c4a43f7..c8c7de7fd 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -102,6 +102,7 @@ HAVE_DEVMAPPER = @have_devmapper@
 HAVE_MALLINFO = @have_mallinfo@
 HAVE_MALLINFO2 = @have_mallinfo2@
 HAVE_MEMFD_CREATE = @have_memfd_create@
+HAVE_GETRANDOM_NONBLOCK = @have_getrandom_nonblock@
 HAVE_LIBICU = @have_libicu@
 HAVE_SYSTEMD = @have_systemd@
 SYSTEMD_SYSTEM_UNIT_DIR = @systemd_system_unit_dir@
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 8c93d7b53..fd623cf40 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -135,6 +135,10 @@ ifeq ($(HAVE_MEMFD_CREATE),yes)
 LCFLAGS += -DHAVE_MEMFD_CREATE
 endif
 
+ifeq ($(HAVE_GETRANDOM_NONBLOCK),yes)
+LCFLAGS += -DHAVE_GETRANDOM_NONBLOCK
+endif
+
 FCFLAGS = -I.
 
 LTLIBS = $(LIBPTHREAD) $(LIBRT)
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index ecacfff82..8dd364b0d 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -63,6 +63,9 @@
 #include "libfrog/crc32c.h"
 
 #include <sys/xattr.h>
+#ifdef HAVE_GETRANDOM_NONBLOCK
+#include <sys/random.h>
+#endif
 
 /* Zones used in libxfs allocations that aren't in shared header files */
 extern struct kmem_cache *xfs_buf_item_cache;
@@ -212,11 +215,11 @@ static inline bool WARN_ON(bool expr) {
 #define percpu_counter_read_positive(x)	((*x) > 0 ? (*x) : 0)
 #define percpu_counter_sum_positive(x)	((*x) > 0 ? (*x) : 0)
 
-/*
- * get_random_u32 is used for di_gen inode allocation, it must be zero for
- * libxfs or all sorts of badness can occur!
- */
+#ifdef HAVE_GETRANDOM_NONBLOCK
+uint32_t get_random_u32(void);
+#else
 #define get_random_u32()	(0)
+#endif
 
 #define PAGE_SIZE		getpagesize()
 
diff --git a/libxfs/util.c b/libxfs/util.c
index 7aa92c0e4..a3f3ad299 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -462,3 +462,22 @@ void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork) { }
 void xfs_da_mark_sick(struct xfs_da_args *args) { }
 void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask) { }
 void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
+
+#ifdef HAVE_GETRANDOM_NONBLOCK
+uint32_t
+get_random_u32(void)
+{
+	uint32_t	ret;
+	ssize_t		sz;
+
+	/*
+	 * Try to extract a u32 of randomness from /dev/urandom.  If that
+	 * fails, fall back to returning zero like we used to do.
+	 */
+	sz = getrandom(&ret, sizeof(ret), GRND_NONBLOCK);
+	if (sz != sizeof(ret))
+		return 0;
+
+	return ret;
+}
+#endif
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 6de8b33ee..13cb5156d 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -195,6 +195,21 @@ memfd_create(0, 0);
     AC_SUBST(have_memfd_create)
   ])
 
+#
+# Check if we have a getrandom syscall with a GRND_NONBLOCK flag
+#
+AC_DEFUN([AC_HAVE_GETRANDOM_NONBLOCK],
+  [ AC_MSG_CHECKING([for getrandom and GRND_NONBLOCK])
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
+#include <sys/random.h>
+    ]], [[
+         unsigned int moo;
+         return getrandom(&moo, sizeof(moo), GRND_NONBLOCK);
+    ]])],[have_getrandom_nonblock=yes
+       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
+    AC_SUBST(have_getrandom_nonblock)
+  ])
+
 AC_DEFUN([AC_PACKAGE_CHECK_LTO],
   [ AC_MSG_CHECKING([if C compiler supports LTO])
     OLD_CFLAGS="$CFLAGS"
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 58edc59f7..96cb9f854 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -462,6 +462,9 @@ creatproto(
 							fsx->fsx_xflags);
 			ip->i_cowextsize = fsx->fsx_cowextsize;
 		}
+
+		/* xfsdump breaks if the root dir has a nonzero generation */
+		inode->i_generation = 0;
 	}
 
 	libxfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);

