Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B75C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJcfnlEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D805EC433C8;
	Sun, 31 Dec 2023 23:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065172;
	bh=7zjPdUkNY6KYNV1dcUdgOo9OosczSACeJ6L2SobRmcQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GJcfnlELt1OUpflTifBFQ3sxNz3Z56kFU8oh9FNQrQdk4S84gN9EamjI/djwyblxs
	 9kIzObN0ezjUM3LzJwqJPZXt45PDkBWFTrFjPDhbFsLt8Kx+15wt3HLGoBuCIv1hQS
	 shWOtHYtJgl/kmkUBdTiaCKyX85Ov1le/0w825vVTqJ031E4WqY7qK3kuJBLGwtjPh
	 l+DRIBGqJ4rb0xapReg8f5G62Oe/pWXxJT7LzoRtn7KL+Sh4I2skvuA7UfMoBfZkmD
	 MM7J5Bls5jL4V+RfLTX4LO59x8D+FZHXgUJV3qdesV8H6V17fm/mMHYJNQGmujchKj
	 K2J3sIrAqCFNg==
Date: Sun, 31 Dec 2023 15:26:12 -0800
Subject: [PATCH 15/28] libxfs: implement get_random_u32
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009376.1808635.3813225550918033017.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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
 libxfs/Makefile       |    3 +++
 libxfs/libxfs_priv.h  |   11 +++++++----
 libxfs/util.c         |   19 +++++++++++++++++++
 m4/package_libcdev.m4 |   15 +++++++++++++++
 mkfs/proto.c          |    3 +++
 7 files changed, 49 insertions(+), 4 deletions(-)


diff --git a/configure.ac b/configure.ac
index 38b62619a7a..3b36d769eac 100644
--- a/configure.ac
+++ b/configure.ac
@@ -194,6 +194,7 @@ AC_HAVE_MAP_SYNC
 AC_HAVE_DEVMAPPER
 AC_HAVE_MALLINFO
 AC_HAVE_MALLINFO2
+AC_HAVE_GETRANDOM_NONBLOCK
 AC_PACKAGE_WANT_ATTRIBUTES_H
 AC_HAVE_LIBATTR
 if test "$enable_scrub" = "yes"; then
diff --git a/include/builddefs.in b/include/builddefs.in
index daac1b5d18a..6668e9bbe8b 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -120,6 +120,7 @@ HAVE_MAP_SYNC = @have_map_sync@
 HAVE_DEVMAPPER = @have_devmapper@
 HAVE_MALLINFO = @have_mallinfo@
 HAVE_MALLINFO2 = @have_mallinfo2@
+HAVE_GETRANDOM_NONBLOCK = @have_getrandom_nonblock@
 HAVE_LIBATTR = @have_libattr@
 HAVE_LIBICU = @have_libicu@
 HAVE_OPENAT = @have_openat@
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 6007353ade2..a251322d0f6 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -141,6 +141,9 @@ endif
 ifeq ($(HAVE_MKOSTEMP_CLOEXEC),yes)
 	LCFLAGS += -DHAVE_MKOSTEMP_CLOEXEC
 endif
+ifeq ($(HAVE_GETRANDOM_NONBLOCK),yes)
+	LCFLAGS += -DHAVE_GETRANDOM_NONBLOCK
+endif
 
 FCFLAGS = -I.
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 1609a8fd03f..e9c6bbf16ee 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -64,6 +64,9 @@
 #include "libfrog/crc32c.h"
 
 #include <sys/xattr.h>
+#ifdef HAVE_GETRANDOM_NONBLOCK
+#include <sys/random.h>
+#endif
 
 /* Zones used in libxfs allocations that aren't in shared header files */
 extern struct kmem_cache *xfs_buf_item_cache;
@@ -207,11 +210,11 @@ static inline bool WARN_ON(bool expr) {
 #define percpu_counter_read_positive(x)	((*x) > 0 ? (*x) : 0)
 #define percpu_counter_sum(x)		(*x)
 
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
index 7aa92c0e4a6..a3f3ad29933 100644
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
index c81a7a031d2..2228697a7a3 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -440,6 +440,21 @@ test = mallinfo2();
     AC_SUBST(have_mallinfo2)
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
 #
 # Check if we have a openat call
 #
diff --git a/mkfs/proto.c b/mkfs/proto.c
index bb262390536..f9b0f837ed9 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -460,6 +460,9 @@ creatproto(
 		ip->i_diflags2 = xfs_flags2diflags2(ip, fsx->fsx_xflags);
 		ip->i_cowextsize = fsx->fsx_cowextsize;
 	}
+	/* xfsdump breaks if the root dir has a nonzero generation */
+	if (!dp)
+		VFS_I(ip)->i_generation = 0;
 	libxfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
 	return 0;
 }

