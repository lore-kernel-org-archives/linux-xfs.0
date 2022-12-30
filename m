Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FE2C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbiLaCVr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236211AbiLaCVq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:21:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0573F19C12
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:21:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9424D61C61
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DD2C433EF;
        Sat, 31 Dec 2022 02:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453305;
        bh=UZ8tVugLLIcDt+zXBcBe+w1oqKBE52p/MGUvrolIwy8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GaQxQ2GVABrty7u7PY7in8PSqscNu7wF3L4pDyFpKgL8xyfLxzkST9PljLJeFFwRb
         CUeh7yiVAJ1Y6Z6EF4gkOxyDp0YK8+9WA4Y+ySHvNzViCo6fvo9SrcU/cSlQK1bxWp
         skQqpJ70SoS2BFHyfXApoPSda1szEhSEAyO6gkOZrg5HSB7SoiO7BrLOPshlPqcGvO
         LgFzFlNo3+U41Wuky7v/dK1xXh6Ki4lkVkHerjYelXY4EGLPm456YOgXwK6ImQ9qNh
         c5hPAefRNHkIwnD+MuhBWG2gQ4u6rehzSblje8b54ss+9krZ58K6tM+gxgfTKcwrnc
         KqVDsQxYX6Uhg==
Subject: [PATCH 46/46] mkfs: add a utility to generate protofiles
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:25 -0800
Message-ID: <167243876533.725900.5568929101331536536.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new utility to generate mkfs protofiles from a directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_protofile.8 |   33 ++++++++++
 mkfs/Makefile            |   10 +++
 mkfs/xfs_protofile.in    |  152 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 194 insertions(+), 1 deletion(-)
 create mode 100644 man/man8/xfs_protofile.8
 create mode 100644 mkfs/xfs_protofile.in


diff --git a/man/man8/xfs_protofile.8 b/man/man8/xfs_protofile.8
new file mode 100644
index 00000000000..75090c138f3
--- /dev/null
+++ b/man/man8/xfs_protofile.8
@@ -0,0 +1,33 @@
+.TH xfs_protofile 8
+.SH NAME
+xfs_protofile \- create a protofile for use with mkfs.xfs
+.SH SYNOPSIS
+.B xfs_protofile
+.I path
+[
+.I paths...
+]
+.br
+.B xfs_protofile \-V
+.SH DESCRIPTION
+.B xfs_protofile
+walks a directory tree to generate a protofile.
+The protofile format is specified in the
+.BR mkfs.xfs (8)
+manual page and is derived from 3rd edition Unix.
+.SH OPTIONS
+.TP 1.0i
+.I path
+Create protofile directives to copy this path into the root directory.
+If the path is a directory, protofile directives will be emitted to
+replicate the entire subtree as a subtree of the root directory.
+If the path is a not a directory, protofile directives will be emitted
+to create the file as an entry in the root directory.
+The first path must resolve to a directory.
+
+.SH BUGS
+Filenames cannot contain spaces.
+Extended attributes are not copied into the filesystem.
+
+.PD
+.RE
diff --git a/mkfs/Makefile b/mkfs/Makefile
index 6c7ee186fa2..98463e4362b 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -6,6 +6,7 @@ TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
 LTCOMMAND = mkfs.xfs
+XFS_PROTOFILE = xfs_protofile
 
 HFILES =
 CFILES = proto.c xfs_mkfs.c
@@ -21,17 +22,24 @@ LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
 	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
 LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
+DIRT = $(XFS_PROTOFILE)
 
-default: depend $(LTCOMMAND) $(CFGFILES)
+default: depend $(LTCOMMAND) $(CFGFILES) $(XFS_PROTOFILE)
 
 include $(BUILDRULES)
 
 install: default
 	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
+	$(INSTALL) -m 755 $(XFS_PROTOFILE) $(PKG_ROOT_SBIN_DIR)
 	$(INSTALL) -m 755 -d $(MKFS_CFG_DIR)
 	$(INSTALL) -m 644 $(CFGFILES) $(MKFS_CFG_DIR)
 
 install-dev:
 
+$(XFS_PROTOFILE): $(XFS_PROTOFILE).in
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e "s|@pkg_version@|$(PKG_VERSION)|g" < $< > $@
+	$(Q)chmod a+x $@
+
 -include .dep
diff --git a/mkfs/xfs_protofile.in b/mkfs/xfs_protofile.in
new file mode 100644
index 00000000000..f2d09735a11
--- /dev/null
+++ b/mkfs/xfs_protofile.in
@@ -0,0 +1,152 @@
+#!/usr/bin/python3
+
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (C) 2022 Oracle.  All rights reserved.
+#
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+# Walk a filesystem tree to generate a protofile for mkfs.
+
+import os
+import argparse
+import sys
+import stat
+
+def emit_proto_header():
+	'''Emit the protofile header.'''
+	print('/')
+	print('0 0')
+
+def stat_to_str(statbuf):
+	'''Convert a stat buffer to a proto string.'''
+
+	if stat.S_ISREG(statbuf.st_mode):
+		type = '-'
+	elif stat.S_ISCHR(statbuf.st_mode):
+		type = 'c'
+	elif stat.S_ISBLK(statbuf.st_mode):
+		type = 'b'
+	elif stat.S_ISFIFO(statbuf.st_mode):
+		type = 'p'
+	elif stat.S_ISDIR(statbuf.st_mode):
+		type = 'd'
+	elif stat.S_ISLNK(statbuf.st_mode):
+		type = 'l'
+
+	if statbuf.st_mode & stat.S_ISUID:
+		suid = 'u'
+	else:
+		suid = '-'
+
+	if statbuf.st_mode & stat.S_ISGID:
+		sgid = 'g'
+	else:
+		sgid = '-'
+
+	perms = stat.S_IMODE(statbuf.st_mode)
+
+	return '%s%s%s%o %d %d' % (type, suid, sgid, perms, statbuf.st_uid, \
+			statbuf.st_gid)
+
+def stat_to_extra(statbuf, fullpath):
+	'''Compute the extras column for a protofile.'''
+
+	if stat.S_ISREG(statbuf.st_mode):
+		return ' %s' % fullpath
+	elif stat.S_ISCHR(statbuf.st_mode) or stat.S_ISBLK(statbuf.st_mode):
+		return ' %d %d' % (statbuf.st_rdev, statbuf.st_rdev)
+	elif stat.S_ISLNK(statbuf.st_mode):
+		return ' %s' % os.readlink(fullpath)
+	return ''
+
+def max_fname_len(s1):
+	'''Return the length of the longest string in s1.'''
+	ret = 0
+	for s in s1:
+		if len(s) > ret:
+			ret = len(s)
+	return ret
+
+def walk_tree(path, depth):
+	'''Walk the directory tree rooted by path.'''
+	dirs = []
+	files = []
+
+	for fname in os.listdir(path):
+		fullpath = os.path.join(path, fname)
+		sb = os.lstat(fullpath)
+
+		if stat.S_ISDIR(sb.st_mode):
+			dirs.append(fname)
+			continue
+		elif stat.S_ISSOCK(sb.st_mode):
+			continue
+		else:
+			files.append(fname)
+
+	for fname in files:
+		if ' ' in fname:
+			raise ValueError( \
+				f'{fname}: Spaces not allowed in file names.')
+	for fname in dirs:
+		if ' ' in fname:
+			raise Exception( \
+				f'{fname}: Spaces not allowed in file names.')
+
+	fname_width = max_fname_len(files)
+	for fname in files:
+		fullpath = os.path.join(path, fname)
+		sb = os.lstat(fullpath)
+		extra = stat_to_extra(sb, fullpath)
+		print('%*s%-*s %s%s' % (depth, ' ', fname_width, fname, \
+				stat_to_str(sb), extra))
+
+	for fname in dirs:
+		fullpath = os.path.join(path, fname)
+		sb = os.lstat(fullpath)
+		extra = stat_to_extra(sb, fullpath)
+		print('%*s%s %s' % (depth, ' ', fname, \
+				stat_to_str(sb)))
+		walk_tree(fullpath, depth + 1)
+
+	if depth > 1:
+		print('%*s$' % (depth - 1, ' '))
+
+def main():
+	parser = argparse.ArgumentParser( \
+			description = "Generate mkfs.xfs protofile for a directory tree.")
+	parser.add_argument('paths', metavar = 'paths', type = str, \
+			nargs = '*', help = 'Directory paths to walk.')
+	parser.add_argument("-V", help = "Report version and exit.", \
+			action = "store_true")
+	args = parser.parse_args()
+
+	if args.V:
+		print("xfs_protofile version @pkg_version@")
+		sys.exit(0)
+
+	emit_proto_header()
+	if len(args.paths) == 0:
+		print('d--755 0 0')
+		print('$')
+	else:
+		# Copy the first argument's stat to the rootdir
+		statbuf = os.stat(args.paths[0])
+		if not stat.S_ISDIR(statbuf.st_mode):
+			raise NotADirectoryError(path)
+		print(stat_to_str(statbuf))
+
+		# All files under each path go in the root dir, recursively
+		for path in args.paths:
+			print(': Descending path %s' % path)
+			try:
+				walk_tree(path, 1)
+			except Exception as e:
+				print(e, file = sys.stderr)
+				return 1
+
+		print('$')
+	return 0
+
+if __name__ == '__main__':
+	sys.exit(main())

