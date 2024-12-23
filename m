Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA95918BBAC
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991093; cv=none; b=mfCsjKzURyQ2Q0Ocgk7E65oMLHMWQLLtBqvc555IwtMaSXra3jtKhjSOdfv47GW0W4O+4xPsAHfhjAeEgKifFshMxaNabIv5os7YGbPE0J5+X3/UU5weNn+RP54Dk/wwWCfBCcb+0tWKZay2eQeFQpN4huko/4TfrF+jOQ5BKzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991093; c=relaxed/simple;
	bh=zsJIsJcSFDJGarZb3+weqEjM+wb2PWvrWq9bEYNucQA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iL4VUhkvuMuBEPUORLfLA5KpsgGRqfBzbgrR/aL4DnJzgKgAIC7e6HnG+Xtwm6UQHyJFt0Gb8/mQR8PJyIatBsWNYlWyVCXP3cIymV0zSK0NHrEGsl40UymrLsKZxI8kLoTJW0YctwYfhXJ+gHZDrk6U2yfxoLUiwR5GF0qjVMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s7/T/rIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s7/T/rIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DD1C4CED3;
	Mon, 23 Dec 2024 21:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991093;
	bh=zsJIsJcSFDJGarZb3+weqEjM+wb2PWvrWq9bEYNucQA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s7/T/rIaHWt0Y9RZx/ONHteWh05B3Twys2pcrtzUA08mORVGFoNOxmyF3wBBfmPCP
	 azLwa0yMrZoiAAKTbfe8dgAq2ojj2SbJR4UKojr+cj/p26FrKczmqmP0uQiXpo7WNr
	 xauqh2aIu/TApnErS6TRn4wm2qtxJI2JXh3mRqy3jCDfcbK5vmR74rI6R1cELcwsGa
	 5pCAtB1KLlkJO6xW963NsfS+iulEwTVrMf7LtESGudeNYEpwspN/jcWHg8IhD5TwBx
	 JkKy6t2zzQQRJHV7sYcncwHzkU2LLBjuZ3AveQD/K6Oom62qp+ZiFF5M4VhkeX/1Qi
	 JO7e2TI3Vrc2g==
Date: Mon, 23 Dec 2024 13:58:13 -0800
Subject: [PATCH 4/4] mkfs: add a utility to generate protofiles
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941990.2295644.470215387134229607.stgit@frogsfrogsfrogs>
In-Reply-To: <173498941923.2295644.12590815257028938964.stgit@frogsfrogsfrogs>
References: <173498941923.2295644.12590815257028938964.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a new utility to generate mkfs protofiles from a directory tree.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/xfs_protofile.8 |   33 ++++++++++
 mkfs/Makefile            |   10 +++
 mkfs/xfs_protofile.in    |  152 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 194 insertions(+), 1 deletion(-)
 create mode 100644 man/man8/xfs_protofile.8
 create mode 100644 mkfs/xfs_protofile.in


diff --git a/man/man8/xfs_protofile.8 b/man/man8/xfs_protofile.8
new file mode 100644
index 00000000000000..75090c138f3393
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
index 754a17ea5137b7..3d3f08ad54f844 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -6,6 +6,7 @@ TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
 LTCOMMAND = mkfs.xfs
+XFS_PROTOFILE = xfs_protofile
 
 HFILES =
 CFILES = proto.c xfs_mkfs.c
@@ -23,14 +24,21 @@ LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
 	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
 LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
+DIRT = $(XFS_PROTOFILE)
 
-default: depend $(LTCOMMAND) $(CFGFILES)
+default: depend $(LTCOMMAND) $(CFGFILES) $(XFS_PROTOFILE)
 
 include $(BUILDRULES)
 
+$(XFS_PROTOFILE): $(XFS_PROTOFILE).in
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e "s|@pkg_version@|$(PKG_VERSION)|g" < $< > $@
+	$(Q)chmod a+x $@
+
 install: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
+	$(INSTALL) -m 755 $(XFS_PROTOFILE) $(PKG_SBIN_DIR)
 	$(INSTALL) -m 755 -d $(MKFS_CFG_DIR)
 	$(INSTALL) -m 644 $(CFGFILES) $(MKFS_CFG_DIR)
 
diff --git a/mkfs/xfs_protofile.in b/mkfs/xfs_protofile.in
new file mode 100644
index 00000000000000..9aee4336888523
--- /dev/null
+++ b/mkfs/xfs_protofile.in
@@ -0,0 +1,152 @@
+#!/usr/bin/python3
+
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2018-2024 Oracle.  All rights reserved.
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

