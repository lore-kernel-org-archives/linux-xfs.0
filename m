Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BA7204F63
	for <linux-xfs@vger.kernel.org>; Tue,  1 Apr 2025 14:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743518670; cv=none; b=ShCgQgyUTKPctEwDwb6xD5YPPe5crmBdXWzi1ua07YGgEc+wNFbFoF2tIDShfnM9HcJeuGQivPdKaIT7R+J7Rwytf2UOFGAFQPL6z7+OIoen2AwfAF0gU43E8zq/KQ7WQ1d0oVfj5Lk5+k+I94tGv4G7+F/JV1AoA2NVkEa4PsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743518670; c=relaxed/simple;
	bh=H3/Fr3iShRO7rD7Dx5dWa4GOk4x6eV7IKnRV0t+Y+u8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QQ13DFq88FV4ghwDbZ0bkBB4wXs/lZb9eoSICujfJSL7BI4ZuDHr0HhiSLfABNwfBK5WVB+M6d7jMB2VOrqJp6l08T7lVxgoU/JGBMA5v2WTAzGW9qsn3j+LNkAuVQMdALOgDCjgz5Ti9Y0LyADHgDti7feIK2DsyZUf0ffRxxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jdhe68Go; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jdhe68Go"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1E6C4CEE4;
	Tue,  1 Apr 2025 14:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743518669;
	bh=H3/Fr3iShRO7rD7Dx5dWa4GOk4x6eV7IKnRV0t+Y+u8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Jdhe68GocCreogPMf6LrZ9tJDZAFI+0IB11Ar21j2DcqPOezT/vzvG8/D1hKUKvFt
	 IEo2ztQ0OFry4L5E9sY9/UB0EBxY/zeUPUznCXO28GykPZ+9mXNfa0agVDq2YkKXMT
	 Dj57mv0u8NAVrOnPdzBVeXD1kGC3tXG2yzVPYTe+ldjy2s6nus8mZm47ulfsL5rRn0
	 6pVblOqO/yEhf2E/4QsW4VUZsqdEwHjDi1VBTyFJg7OlEY70pJ5OOapYziou0Pvc3i
	 a8ObI6Uu1y4chzXzgeApsF7EZRZjbPcF/rCxruj0YF4YUyolObKHzXtOxhQDGunIUq
	 STERVKll5DjHQ==
Date: Tue, 01 Apr 2025 07:44:28 -0700
Subject: [PATCH 4/5] xfs_protofile: add messages to localization catalog
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <174351857651.2774496.8820026963646861833.stgit@frogsfrogsfrogs>
In-Reply-To: <174351857556.2774496.13689449454739654191.stgit@frogsfrogsfrogs>
References: <174351857556.2774496.13689449454739654191.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add the source code of these two Python programs to the list of files
that are scanned for the gettext message catalog.  This will enable
localization of the outputs of these programs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 configure.ac             |    2 +-
 include/buildrules       |    1 -
 libfrog/Makefile         |   18 +++++++++++++++++-
 libfrog/gettext.py.in    |   12 ++++++++++++
 mkfs/Makefile            |    7 +++++--
 mkfs/xfs_protofile.py.in |   21 ++++++++++++---------
 6 files changed, 47 insertions(+), 14 deletions(-)
 create mode 100644 libfrog/gettext.py.in


diff --git a/configure.ac b/configure.ac
index 71596711685a8a..4202144710d187 100644
--- a/configure.ac
+++ b/configure.ac
@@ -130,7 +130,7 @@ test -n "$multiarch" && enable_lib64=no
 # to "find" is required, to avoid including such directories in the
 # list.
 LOCALIZED_FILES=""
-for lfile in `find ${srcdir} -path './.??*' -prune -o -name '*.c' -type f -print || exit 1`; do
+for lfile in `find ${srcdir} -path './.??*' -prune -o -name '*.c' -print -o -name '*.py.in' -print || exit 1`; do
     LOCALIZED_FILES="$LOCALIZED_FILES \$(TOPDIR)/$lfile"
 done
 AC_SUBST(LOCALIZED_FILES)
diff --git a/include/buildrules b/include/buildrules
index ae047ac41fe27c..871e92db02de14 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -86,7 +86,6 @@ endif
 
 ifdef POTHEAD
 XGETTEXT_FLAGS=\
-	--language=C \
 	--keyword=_ \
 	--keyword=N_ \
 	--package-name=$(PKG_NAME) \
diff --git a/libfrog/Makefile b/libfrog/Makefile
index fc7e506d96bbad..b64ca4597f4ea9 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -64,11 +64,20 @@ randbytes.h \
 scrub.h \
 workqueue.h
 
+GETTEXT_PY = \
+	gettext.py
+
 LSRCFILES += gen_crc32table.c
 
 LDIRT = gen_crc32table crc32table.h
 
-default: ltdepend $(LTLIBRARY)
+ifeq ($(ENABLE_GETTEXT),yes)
+HAVE_GETTEXT = True
+else
+HAVE_GETTEXT = False
+endif
+
+default: ltdepend $(LTLIBRARY) $(GETTEXT_PY)
 
 crc32table.h: gen_crc32table.c crc32defs.h
 	@echo "    [CC]     gen_crc32table"
@@ -76,6 +85,13 @@ crc32table.h: gen_crc32table.c crc32defs.h
 	@echo "    [GENERATE] $@"
 	$(Q) ./gen_crc32table > crc32table.h
 
+$(GETTEXT_PY): $(GETTEXT_PY).in $(TOPDIR)/include/builddefs
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e "s|@HAVE_GETTEXT@|$(HAVE_GETTEXT)|g" \
+		   -e "s|@PACKAGE@|$(PKG_NAME)|g" \
+		   -e "s|@LOCALEDIR@|$(PKG_LOCALE_DIR)|g" \
+		   < $< > $@
+
 include $(BUILDRULES)
 
 install install-dev: default
diff --git a/libfrog/gettext.py.in b/libfrog/gettext.py.in
new file mode 100644
index 00000000000000..61559f7373b6b3
--- /dev/null
+++ b/libfrog/gettext.py.in
@@ -0,0 +1,12 @@
+
+if __name__ == '__main__':
+	if @HAVE_GETTEXT@:
+		import gettext
+		# set up gettext before main so that we can set up _().
+		gettext.bindtextdomain("@PACKAGE@", "@LOCALEDIR@")
+		gettext.textdomain("@PACKAGE@")
+		_ = gettext.gettext
+	else:
+		def _(a):
+			return a
+
diff --git a/mkfs/Makefile b/mkfs/Makefile
index b1369e1853a98f..04905bd5101ccb 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -30,9 +30,12 @@ default: depend $(LTCOMMAND) $(CFGFILES) $(XFS_PROTOFILE)
 
 include $(BUILDRULES)
 
-$(XFS_PROTOFILE): $(XFS_PROTOFILE).in
+$(XFS_PROTOFILE): $(XFS_PROTOFILE).in $(TOPDIR)/include/builddefs $(TOPDIR)/libfrog/gettext.py
 	@echo "    [SED]    $@"
-	$(Q)$(SED) -e "s|@pkg_version@|$(PKG_VERSION)|g" < $< > $@
+	$(Q)$(SED) -e "s|@pkg_version@|$(PKG_VERSION)|g" \
+		   -e '/@INIT_GETTEXT@/r $(TOPDIR)/libfrog/gettext.py' \
+		   -e '/@INIT_GETTEXT@/d' \
+		   < $< > $@
 	$(Q)chmod a+x $@
 
 install: default
diff --git a/mkfs/xfs_protofile.py.in b/mkfs/xfs_protofile.py.in
index e83c39f5325846..040454da1da4df 100644
--- a/mkfs/xfs_protofile.py.in
+++ b/mkfs/xfs_protofile.py.in
@@ -7,6 +7,7 @@
 
 # Walk a filesystem tree to generate a protofile for mkfs.
 
+@INIT_GETTEXT@
 import os
 import argparse
 import sys
@@ -86,12 +87,12 @@ def walk_tree(path, depth):
 
 	for fname in files:
 		if ' ' in fname:
-			raise ValueError( \
-				f'{fname}: Spaces not allowed in file names.')
+			msg = _("Spaces not allowed in file names.")
+			raise ValueError(f'{fname}: {msg}')
 	for fname in dirs:
 		if ' ' in fname:
-			raise Exception( \
-				f'{fname}: Spaces not allowed in file names.')
+			msg = _("Spaces not allowed in subdirectory names.")
+			raise Exception(f'{fname}: {msg}')
 
 	fname_width = max_fname_len(files)
 	for fname in files:
@@ -114,15 +115,17 @@ def walk_tree(path, depth):
 
 def main():
 	parser = argparse.ArgumentParser( \
-			description = "Generate mkfs.xfs protofile for a directory tree.")
-	parser.add_argument('paths', metavar = 'paths', type = str, \
-			nargs = '*', help = 'Directory paths to walk.')
-	parser.add_argument("-V", help = "Report version and exit.", \
+			description = _("Generate mkfs.xfs protofile for a directory tree."))
+	parser.add_argument('paths', metavar = _('paths'), type = str, \
+			nargs = '*', help = _('Directory paths to walk.'))
+	parser.add_argument("-V", help = _("Report version and exit."), \
 			action = "store_true")
 	args = parser.parse_args()
 
 	if args.V:
-		print("xfs_protofile version @pkg_version@")
+		msg = _("xfs_protofile version")
+		pkgver = "@pkg_version@"
+		print(f"{msg} {pkgver}")
 		sys.exit(0)
 
 	emit_proto_header()

