Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E377EF
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ec0f4u/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983E0C433C8;
	Mon,  1 Jan 2024 00:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069724;
	bh=Q29ko0xklu7WgMsKn2ToxV7cTkrhXGB2diVpJ58EJFY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ec0f4u/nr3+zq7QbegeaSMIwELCd3cscWnZ4vkUzgwhU1WxsIsABPaVTqUQNA6Okk
	 f4oKd7zjjm9unGtyYE4WOsy3n5U373CH3efKB07FyRfYgoSPExLzJRWCxZmRPWUYZv
	 62DX+psWKxG+fjq31LKgvuUwA5LeJ/0dMSl3KLdvl5GoWKLP7UgBSb8R+oZqms93I/
	 VDA920hGp+rrSiccAZbdQV+kCWwQn9iRgn0NDEXtEmbKm9vFUdT3Xx/2r7udstbYyS
	 qYdFIVKQHfEqRosRhoVIpnEO88ldtUqOyWVWGZ5Z4Cz/0z7YP2xTcN7AWOO4d0rlUy
	 TFoLuWhssAOpg==
Date: Sun, 31 Dec 2023 16:42:04 +9900
Subject: [PATCH 08/10] xfs_spaceman: port relocation structure to 32-bit
 systems
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405020431.1820796.10977053037186099530.stgit@frogsfrogsfrogs>
In-Reply-To: <170405020316.1820796.451112156000559887.stgit@frogsfrogsfrogs>
References: <170405020316.1820796.451112156000559887.stgit@frogsfrogsfrogs>
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

We can't use the radix tree to store relocation information on 32-bit
systems because unsigned longs are not large enough to hold 64-bit
inodes.  Use an avl64 tree instead.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |    1 
 include/builddefs.in  |    1 
 m4/package_libcdev.m4 |   20 +++++
 spaceman/Makefile     |    4 +
 spaceman/relocation.c |  203 +++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 229 insertions(+)


diff --git a/configure.ac b/configure.ac
index 3b36d769eac..db6366dcdab 100644
--- a/configure.ac
+++ b/configure.ac
@@ -258,6 +258,7 @@ AC_HAVE_MEMFD_CLOEXEC
 AC_HAVE_MEMFD_NOEXEC_SEAL
 AC_HAVE_O_TMPFILE
 AC_HAVE_MKOSTEMP_CLOEXEC
+AC_USE_RADIX_TREE_FOR_INUMS
 
 AC_CONFIG_FILES([include/builddefs])
 AC_OUTPUT
diff --git a/include/builddefs.in b/include/builddefs.in
index 6668e9bbe8b..30c8f301bca 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -138,6 +138,7 @@ HAVE_MEMFD_CLOEXEC = @have_memfd_cloexec@
 HAVE_MEMFD_NOEXEC_SEAL = @have_memfd_noexec_seal@
 HAVE_O_TMPFILE = @have_o_tmpfile@
 HAVE_MKOSTEMP_CLOEXEC = @have_mkostemp_cloexec@
+USE_RADIX_TREE_FOR_INUMS = @use_radix_tree_for_inums@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 2228697a7a3..003379ec2b8 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -612,3 +612,23 @@ AC_DEFUN([AC_HAVE_MKOSTEMP_CLOEXEC],
        AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
     AC_SUBST(have_mkostemp_cloexec)
   ])
+
+#
+# Check if the radix tree index (unsigned long) is large enough to hold a
+# 64-bit inode number
+#
+AC_DEFUN([AC_USE_RADIX_TREE_FOR_INUMS],
+  [ AC_MSG_CHECKING([if radix tree can store XFS inums])
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
+#include <sys/param.h>
+#include <stdint.h>
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+    ]], [[
+         typedef uint64_t    xfs_ino_t;
+
+         BUILD_BUG_ON(sizeof(unsigned long) < sizeof(xfs_ino_t));
+         return 0;
+    ]])],[use_radix_tree_for_inums=yes
+       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
+    AC_SUBST(use_radix_tree_for_inums)
+  ])
diff --git a/spaceman/Makefile b/spaceman/Makefile
index 16a13e4bc19..9c866339ac5 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -22,6 +22,10 @@ ifeq ($(HAVE_GETFSMAP),yes)
 CFILES += freesp.c clearfree.c
 endif
 
+ifeq ($(USE_RADIX_TREE_FOR_INUMS),yes)
+LCFLAGS += -DUSE_RADIX_TREE_FOR_INUMS
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/spaceman/relocation.c b/spaceman/relocation.c
index 7c7d9a2b4b2..1c0db6a1dab 100644
--- a/spaceman/relocation.c
+++ b/spaceman/relocation.c
@@ -6,7 +6,11 @@
 
 #include "libxfs.h"
 #include "libfrog/fsgeom.h"
+#ifdef USE_RADIX_TREE_FOR_INUMS
 #include "libfrog/radix-tree.h"
+#else
+#include "libfrog/avl64.h"
+#endif /* USE_RADIX_TREE_FOR_INUMS */
 #include "libfrog/paths.h"
 #include "command.h"
 #include "init.h"
@@ -24,6 +28,7 @@ get_reloc_count(void)
 	return inode_count;
 }
 
+#ifdef USE_RADIX_TREE_FOR_INUMS
 static RADIX_TREE(relocation_data, 0);
 
 bool
@@ -112,3 +117,201 @@ forget_reloc_ino(
 {
 	radix_tree_delete(&relocation_data, ino);
 }
+#else
+struct reloc_node {
+	struct avl64node	node;
+	uint64_t		ino;
+	struct inode_path	*ipath;
+	unsigned int		flags;
+};
+
+static uint64_t
+reloc_start(
+	struct avl64node	*node)
+{
+	struct reloc_node	*rln;
+
+	rln = container_of(node, struct reloc_node, node);
+	return rln->ino;
+}
+
+static uint64_t
+reloc_end(
+	struct avl64node	*node)
+{
+	struct reloc_node	*rln;
+
+	rln = container_of(node, struct reloc_node, node);
+	return rln->ino + 1;
+}
+
+static struct avl64ops reloc_ops = {
+	reloc_start,
+	reloc_end,
+};
+
+static struct avl64tree_desc	relocation_data = {
+	.avl_ops = &reloc_ops,
+};
+
+bool
+is_reloc_populated(void)
+{
+	return relocation_data.avl_firstino != NULL;
+}
+
+static inline struct reloc_node *
+reloc_lookup(
+	uint64_t		ino)
+{
+	avl64node_t		*node;
+
+	node = avl64_find(&relocation_data, ino);
+	if (!node)
+		return NULL;
+
+	return container_of(node, struct reloc_node, node);
+}
+
+static inline struct reloc_node *
+reloc_insert(
+	uint64_t		ino)
+{
+	struct reloc_node	*rln;
+	avl64node_t		*node;
+
+	rln = malloc(sizeof(struct reloc_node));
+	if (!rln)
+		return NULL;
+
+	rln->node.avl_nextino = NULL;
+	rln->ino = ino;
+	rln->ipath = UNLINKED_IPATH;
+	rln->flags = 0;
+
+	node = avl64_insert(&relocation_data, &rln->node);
+	if (node == NULL) {
+		free(rln);
+		return NULL;
+	}
+
+	return rln;
+}
+
+bool
+test_reloc_iflag(
+	uint64_t		ino,
+	unsigned int		flag)
+{
+	struct reloc_node	*rln;
+
+	rln = reloc_lookup(ino);
+	if (!rln)
+		return false;
+
+	return rln->flags & flag;
+}
+
+void
+set_reloc_iflag(
+	uint64_t		ino,
+	unsigned int		flag)
+{
+	struct reloc_node	*rln;
+
+	rln = reloc_lookup(ino);
+	if (!rln) {
+		rln = reloc_insert(ino);
+		if (!rln)
+			abort();
+		if (flag != INODE_PATH)
+			inode_count++;
+	}
+	if (flag == INODE_PATH)
+		inode_paths++;
+
+	rln->flags |= flag;
+}
+
+#define avl_for_each_range_safe(pos, n, l, first, last) \
+	for (pos = (first), n = pos->avl_nextino, l = (last)->avl_nextino; \
+			pos != (l); \
+			pos = n, n = pos ? pos->avl_nextino : NULL)
+
+struct inode_path *
+get_next_reloc_ipath(
+	uint64_t		ino)
+{
+	struct avl64node	*firstn;
+	struct avl64node	*lastn;
+	struct avl64node	*pos;
+	struct avl64node	*n;
+	struct avl64node	*l;
+	struct reloc_node	*rln;
+
+	avl64_findranges(&relocation_data, ino - 1, -1ULL, &firstn, &lastn);
+	if (firstn == NULL && lastn == NULL)
+		return NULL;
+
+	avl_for_each_range_safe(pos, n, l, firstn, lastn) {
+		rln = container_of(pos, struct reloc_node, node);
+
+		if (rln->flags & INODE_PATH)
+			return rln->ipath;
+	}
+
+	return NULL;
+}
+
+uint64_t
+get_next_reloc_unlinked(
+	uint64_t		ino)
+{
+	struct avl64node	*firstn;
+	struct avl64node	*lastn;
+	struct avl64node	*pos;
+	struct avl64node	*n;
+	struct avl64node	*l;
+	struct reloc_node	*rln;
+
+	avl64_findranges(&relocation_data, ino - 1, -1ULL, &firstn, &lastn);
+	if (firstn == NULL && lastn == NULL)
+		return 0;
+
+	avl_for_each_range_safe(pos, n, l, firstn, lastn) {
+		rln = container_of(pos, struct reloc_node, node);
+
+		if (!(rln->flags & INODE_PATH))
+			return rln->ino;
+	}
+
+	return 0;
+}
+
+struct inode_path **
+get_reloc_ipath_slot(
+	uint64_t		ino)
+{
+	struct reloc_node	*rln;
+
+	rln = reloc_lookup(ino);
+	if (!rln)
+		return NULL;
+
+	return &rln->ipath;
+}
+
+void
+forget_reloc_ino(
+	uint64_t		ino)
+{
+	struct reloc_node	*rln;
+
+	rln = reloc_lookup(ino);
+	if (!rln)
+		return;
+
+	avl64_delete(&relocation_data, &rln->node);
+	free(rln);
+}
+#endif /* USE_RADIX_TREE_FOR_INUMS */

