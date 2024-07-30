Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E4E42C0B
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309694; cv=none; b=V/0+AyEjE2r6AUhBM6AVLGP2A/zEZVAR38EvuvgQN92V/qIPvEqOjnDDdrmq7Ku/KKVkqE1WlffEpiri/9wof3Clh1Op2m0EzA10Tc6kSaaVECgxSmx50UjTWorLDVSz2sBsm/CVM3FtASgirR3ELWcT6DXXJsBFmJSnt6vuFbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309694; c=relaxed/simple;
	bh=fIiFt7KyZKfNB57NaDTGLHfR3fBLvkrc6bbBUAsokoo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J1lP2e750pQXAlr8pm3EjtQdMHSxNZxKOXyQI55qHyrt8LJYQvzoT/IJiqCqxo3DKFQUdiz11sC3MtBZnjaFNeXdLo7R3VceQDrQ1yeJfoKo+C+YPaKELAjsHgPG9/aDI1DoEI3DUiSASDPYEq/h8FjOwONySewvItGyc8kB68A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhaRW9/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhaRW9/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72487C32786;
	Tue, 30 Jul 2024 03:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309693;
	bh=fIiFt7KyZKfNB57NaDTGLHfR3fBLvkrc6bbBUAsokoo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VhaRW9/ol8t/JHFSrl1+WWj79ukvSKVcreHZBRVS9VwDkg1n9mp8AwvR3wldFy/l1
	 hCNtg9SL1DEdUDHAeAIIj7DOw5KzsJ0JfeTQgpbPooS+O8opwgvYM+HrLzbwqHfR3t
	 TTnE+ekFW46fkby496BZbe26eM4ahcUdXuCA3T9SPdBWYpk0W5UQEakpLeDGGjQAgW
	 e+E162POr7/Bp9luIQHQkqhp7KwlDeFbaFT59YbCX2q/DeCufw9ndMpkR2AoDpZYVl
	 14KTeqqd/AQU77xsA1F7i8PZKNFUMHgkWQxdbXpEPKZz8sDccNUnRfq0I3QZrjdQpX
	 Poj039lnD/EhQ==
Date: Mon, 29 Jul 2024 20:21:32 -0700
Subject: [PATCH 7/7] xfs_property: add a new tool to administer fs properties
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172230940678.1543753.11215656166264361855.stgit@frogsfrogsfrogs>
In-Reply-To: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_property.8 |   52 ++++++++++++++++++++++++++++++++
 spaceman/Makefile       |    3 +-
 spaceman/xfs_property   |   77 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 131 insertions(+), 1 deletion(-)
 create mode 100644 man/man8/xfs_property.8
 create mode 100755 spaceman/xfs_property


diff --git a/man/man8/xfs_property.8 b/man/man8/xfs_property.8
new file mode 100644
index 000000000000..63245331bd86
--- /dev/null
+++ b/man/man8/xfs_property.8
@@ -0,0 +1,52 @@
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
diff --git a/spaceman/Makefile b/spaceman/Makefile
index 2688b37c770d..e914b921de8b 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -16,7 +16,7 @@ CFILES = \
 	init.c \
 	prealloc.c \
 	trim.c
-LSRCFILES = xfs_info.sh
+LSRCFILES = xfs_info.sh xfs_property
 
 LLDLIBS = $(LIBHANDLE) $(LIBXCMD) $(LIBFROG)
 LTDEPENDENCIES = $(LIBHANDLE) $(LIBXCMD) $(LIBFROG)
@@ -42,6 +42,7 @@ install: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 	$(INSTALL) -m 755 xfs_info.sh $(PKG_SBIN_DIR)/xfs_info
+	$(INSTALL) -m 755 xfs_property $(PKG_SBIN_DIR)/xfs_property
 install-dev:
 
 -include .dep
diff --git a/spaceman/xfs_property b/spaceman/xfs_property
new file mode 100755
index 000000000000..57185faa38db
--- /dev/null
+++ b/spaceman/xfs_property
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
+	V)	xfs_spaceman -p xfs_info -V
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
+spaceman_args=()
+
+case "$subcommand" in
+"list")
+	vparam=
+	if [ $# -eq 1 ] && [ "$1" = "-v" ]; then
+		vparam=" -v"
+	fi
+	db_args+=('-c' "attr_list -Z${vparam}")
+	spaceman_args+=('-c' "listfsprops${vparam}")
+	;;
+"get"|"remove"|"set")
+	for arg in "$@"; do
+		db_args+=('-c' "attr_${subcommand} -Z ${arg/=/ }")
+		spaceman_args+=('-c' "${subcommand}fsprops ${arg}")
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
+	exec xfs_spaceman -p xfs_property "${spaceman_args[@]}" "${mountpt}"
+else
+	exec xfs_db -p xfs_property -x -c 'path /' "${db_args[@]}" "${target}"
+fi

