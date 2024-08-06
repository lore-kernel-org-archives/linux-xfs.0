Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A7662A02;
	Tue,  6 Aug 2024 18:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968469; cv=none; b=mkjno3qyQ8By7lGWKaCtPAMVOScelFH7oC4r+N4YYlSEDFInLcT4PxUEENzxt1DfSLZewnPCYadZPToK+CuoaANgfQg59xubHJwgeVX/Btne+y49g9neRerD4ftf5isnHr0UswjYMMEo6EQiT0vj0Y7gZmU8mAsIX2jbkD/gZZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968469; c=relaxed/simple;
	bh=uqcjpf2o7546mReVzdEBsAL0m4K90/rgFgCWi0mg2fs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VoYZleRo6gomrPJAjJzNM3oLUbOkWy99GMPtn9OiMsZNe3zR0P0bpsEh21I6ikaZMkuGt9rgSHlDlEa1wrIO10f6f3+MmurXnFqtl2mnE7dIkM4RtN+IzzQ43T6hY7KJBXG61gjy/JGtxfhnOamUG3fgpIRXBJQWV84XUIX0dmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RScTdpAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RScTdpAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B556C32786;
	Tue,  6 Aug 2024 18:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722968469;
	bh=uqcjpf2o7546mReVzdEBsAL0m4K90/rgFgCWi0mg2fs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RScTdpAhDeK7Aibhk7Wudch5+g55l0/9PYVXaqS+28FWYR4d3VMHPn8y/1GcBUJqn
	 ClN7HnKCmvZk2k+sYRVwQRIleTdL8zK++d1v57ipQAoke04pE4lx3ppThXQ5JZqUn+
	 1nm6ZlN/tmS1+px4jJmDooXWH3tSQPnjX97eYGwSYyI26VTUlgkysp1g9ECSyXQBFx
	 niTLfp0iCoSgOnKebL86JQS+MMDS2x4wSV2DzKKMG56Gn3dMng18UPYpAj7ew+XwbE
	 1IqxXReVvxyoJBRCEMD7r1cVbDFkcWO+ASGSDbcUSX2K5jzhTIdLG6Oq/v/v8lKZ72
	 lmFLjYUvRHjEw==
Date: Tue, 06 Aug 2024 11:21:08 -0700
Subject: [PATCH 7/7] xfs_property: add a new tool to administer fs properties
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, hch@lst.de, dchinner@redhat.com,
 fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172296825294.3193059.14566423047686344749.stgit@frogsfrogsfrogs>
In-Reply-To: <172296825181.3193059.14803487307894313362.stgit@frogsfrogsfrogs>
References: <172296825181.3193059.14803487307894313362.stgit@frogsfrogsfrogs>
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

Create a tool to list, get, set, and remove filesystem properties.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>Acked-by: Dave Chinner <dchinner@redhat.com>
---
 io/Makefile             |    3 +-
 io/xfs_property         |   77 +++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_property.8 |   61 +++++++++++++++++++++++++++++++++++++
 3 files changed, 140 insertions(+), 1 deletion(-)
 create mode 100755 io/xfs_property
 create mode 100644 man/man8/xfs_property.8


diff --git a/io/Makefile b/io/Makefile
index 0bdd05b57..c33d57f5e 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -6,7 +6,7 @@ TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
 LTCOMMAND = xfs_io
-LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
+LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh xfs_property
 HFILES = init.h io.h
 CFILES = \
 	attr.c \
@@ -92,6 +92,7 @@ install: default
 	$(LTINSTALL) -m 755 xfs_bmap.sh $(PKG_SBIN_DIR)/xfs_bmap
 	$(LTINSTALL) -m 755 xfs_freeze.sh $(PKG_SBIN_DIR)/xfs_freeze
 	$(LTINSTALL) -m 755 xfs_mkfile.sh $(PKG_SBIN_DIR)/xfs_mkfile
+	$(LTINSTALL) -m 755 xfs_property $(PKG_SBIN_DIR)/xfs_property
 install-dev:
 
 -include .dep
diff --git a/io/xfs_property b/io/xfs_property
new file mode 100755
index 000000000..6f630312a
--- /dev/null
+++ b/io/xfs_property
@@ -0,0 +1,77 @@
+#!/bin/bash -f
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+#
+
+OPTS=""
+USAGE="Usage: xfs_property [-V] [mountpoint|device|file] [list [-v]|get name...|set name=value...|remove name...]"
+
+# Try to find a loop device associated with a file.  We only want to return
+# one loopdev (multiple loop devices can attach to a single file) so we grab
+# the last line and return it if it's actually a block device.
+try_find_loop_dev_for_file() {
+	local x="$(losetup -O NAME -j "$1" 2> /dev/null | tail -n 1)"
+	test -b "${x}" && echo "${x}"
+}
+
+while getopts "V" c
+do
+	case $c in
+	V)	xfs_io -p xfs_info -V
+		status=$?
+		exit ${status}
+		;;
+	*)	echo "${USAGE}" 1>&2
+		exit 2
+		;;
+	esac
+done
+set -- extra "$@"
+shift $OPTIND
+
+if [ $# -lt 2 ]; then
+	echo "${USAGE}" 1>&2
+	exit 2
+fi
+
+target="$1"
+shift
+subcommand="$1"
+shift
+
+db_args=()
+io_args=()
+
+case "$subcommand" in
+"list")
+	vparam=
+	if [ $# -eq 1 ] && [ "$1" = "-v" ]; then
+		vparam=" -v"
+	fi
+	db_args+=('-c' "attr_list -Z${vparam}")
+	io_args+=('-c' "listfsprops${vparam}")
+	;;
+"get"|"remove"|"set")
+	for arg in "$@"; do
+		db_args+=('-c' "attr_${subcommand} -Z ${arg/=/ }")
+		io_args+=('-c' "${subcommand}fsprops ${arg}")
+	done
+	;;
+*)
+	echo "${USAGE}" 1>&2
+	exit 2
+esac
+
+# See if we can map the arg to a loop device
+loopdev="$(try_find_loop_dev_for_file "${target}")"
+test -n "${loopdev}" && target="${loopdev}"
+
+# If we find a mountpoint for the device, do a live query; otherwise try
+# reading the fs with xfs_db.
+if mountpt="$(findmnt -t xfs -f -n -o TARGET "${target}" 2> /dev/null)"; then
+	exec xfs_io -p xfs_property "${io_args[@]}" "${mountpt}"
+else
+	exec xfs_db -p xfs_property -x -c 'path /' "${db_args[@]}" "${target}"
+fi
diff --git a/man/man8/xfs_property.8 b/man/man8/xfs_property.8
new file mode 100644
index 000000000..19c1c0e37
--- /dev/null
+++ b/man/man8/xfs_property.8
@@ -0,0 +1,61 @@
+.TH xfs_property 8
+.SH NAME
+xfs_property \- examine and edit properties about an XFS filesystem
+.SH SYNOPSIS
+.B xfs_property
+.I target
+.B get
+.IR name ...
+.br
+.B xfs_property
+.I target
+.B list [ \-v ]
+.br
+.B xfs_property
+.I target
+.B set
+.IR name=value ...
+.br
+.B xfs_property
+.I target
+.B remove
+.IR name ...
+.br
+.B xfs_property \-V
+.SH DESCRIPTION
+.B xfs_property
+retrieves, lists, sets, or removes properties of an XFS filesystem.
+Filesystem properties are root-controlled attributes set on the root directory
+of the filesystem to enable the system administrator to coordinate with
+userspace programs.
+
+.I target
+is one of: the root directory of a mounted filesystem; a block device containing
+an XFS filesystem; or a regular file containing an XFS filesystem.
+
+.SH OPTIONS
+.TP
+.B \-V
+Print the version number and exits.
+
+.SH COMMANDS
+.TP
+.B get
+.IR name ...
+Prints the values of the given filesystem properties.
+.TP
+.B list
+Lists the names of all filesystem properties.
+If the
+.B -v
+flag is specified, prints the values as well.
+.TP
+.B set
+.IR name = value ...
+Sets the given filesystem properties to the specified values and prints what
+was set.
+.TP
+.B
+remove
+.IR name ...
+Unsets the given filesystem properties.

