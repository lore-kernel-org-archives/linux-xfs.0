Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435161B0425
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688832; cv=none; b=piYMfNZKpTd4Jl/g32B5qVTOK9255SnJc+ZcBQs93WAK8mcxwql1/IvrjO3LeDORBiHztfd7zzVOHcQv/Z8QVpuhDIh1SsWwIuZs8oG621zDPpPt8ryGhVbMec4QZXGh7/9lSODR1dNO63iToz0BuKJOldMqHyBbgN9OdsXs4PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688832; c=relaxed/simple;
	bh=nGZ/kamyUCLHyi1ECY6lZfxmMHTKO1Gup9Zj5nSqy8k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hba2fJBpYn7/KuwMHkInf8ccHQPCQ0JaqtyYvdRBI1Gr0nueJuWR1iJWbgA9ey8kLXXX4DMMZNUDJL4ihnCW0OCc5IPrtcByTOt195v+VAnL/NZZxEY5UXNSfbB7ty3p4iODhpvZlQAQc4xZnsxlm61r5VHr3bb3KkLTSHbn0Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZHyPBou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZHyPBou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2907C4CED2;
	Tue, 31 Dec 2024 23:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688831;
	bh=nGZ/kamyUCLHyi1ECY6lZfxmMHTKO1Gup9Zj5nSqy8k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SZHyPBoutiinawu/S0l9guhpypHzS+5HgVkgD9pQJf7Gsuie/ilktEIlGwWjjJj0K
	 BtBS6o61N01y9IZWq6ecu34rBbAUZPVIyNwTStZjHkBFFLuM/pPbdEHC8avaLHQvwM
	 qdM4SZn84ttqnLI7Tm1KruoLvJHhcF37OGLQ636AVAkjPiGgrzOjjdSJUGtJM0wpFP
	 ZH3Td92jSscoQhI/Pn4QOSoz5wSIg0JX2Ci8IB84C5Bimfm1GvLBs0JTqXV9U8+oPd
	 PdN0Mvmdu3VaFHAgKE7pwDdnInddNHvzhOn2RuO9K0zhw77Og3PD5Pzs/HetVkB15M
	 bI5qjw1u2SrbA==
Date: Tue, 31 Dec 2024 15:47:11 -0800
Subject: [PATCH 09/11] xfs_spaceman: port relocation structure to 32-bit
 systems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778008.2709794.12371752300604120680.stgit@frogsfrogsfrogs>
In-Reply-To: <173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs>
References: <173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 configure.ac          |    1 
 include/builddefs.in  |    1 
 m4/package_libcdev.m4 |   20 +++++
 spaceman/Makefile     |    4 +
 spaceman/relocation.c |  203 +++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 229 insertions(+)


diff --git a/configure.ac b/configure.ac
index 224d1d3930bf2f..1f7fec838e1239 100644
--- a/configure.ac
+++ b/configure.ac
@@ -212,6 +212,7 @@ fi
 
 AC_MANUAL_FORMAT
 AC_HAVE_LIBURCU_ATOMIC64
+AC_USE_RADIX_TREE_FOR_INUMS
 
 AC_CONFIG_FILES([include/builddefs])
 AC_OUTPUT
diff --git a/include/builddefs.in b/include/builddefs.in
index ac43b6412c8cbb..bb022c36627a72 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -114,6 +114,7 @@ CROND_DIR = @crond_dir@
 HAVE_UDEV = @have_udev@
 UDEV_RULE_DIR = @udev_rule_dir@
 HAVE_LIBURCU_ATOMIC64 = @have_liburcu_atomic64@
+USE_RADIX_TREE_FOR_INUMS = @use_radix_tree_for_inums@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 4ef7e8f67a3ba6..9e48273250244c 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -255,3 +255,23 @@ AC_DEFUN([AC_PACKAGE_CHECK_LTO],
     AC_SUBST(lto_cflags)
     AC_SUBST(lto_ldflags)
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
index 8980208285f610..d9d55245ffc47a 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -33,6 +33,10 @@ ifeq ($(HAVE_GETFSMAP),yes)
 CFILES += freesp.c clearfree.c
 endif
 
+ifeq ($(USE_RADIX_TREE_FOR_INUMS),yes)
+LCFLAGS += -DUSE_RADIX_TREE_FOR_INUMS
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/spaceman/relocation.c b/spaceman/relocation.c
index 7c7d9a2b4b236f..1c0db6a1dab465 100644
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

