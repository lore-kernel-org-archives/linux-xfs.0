Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25468 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934946AbcKDSbQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 14:31:16 -0400
Subject: [PATCH 11/11] tools: create libxfs-diff to compare libxfses
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 11:31:13 -0700
Message-ID: <147828427347.31492.2327135081578753144.stgit@birch.djwong.org>
In-Reply-To: <147828420554.31492.4173929442743951581.stgit@birch.djwong.org>
References: <147828420554.31492.4173929442743951581.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Create a script to compare every file in libxfs to the same files
in another libxfs.  This is useful for comparing upstream kernel
and user progs to look for unported changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/libxfs-diff |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100755 tools/libxfs-diff


diff --git a/tools/libxfs-diff b/tools/libxfs-diff
new file mode 100755
index 0000000..ad69c85
--- /dev/null
+++ b/tools/libxfs-diff
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+if [ -z "$1" ] || [ ! -d "$1" ] || [ "$1" = "--help" ]; then
+	echo "Usage: $0 kernel_libxfs_dir"
+	exit 1
+fi
+
+if [ ! -d "libxfs/" ]; then
+	echo "$0: Must be run from the top level directory."
+	exit 2
+fi
+
+dir="$1"
+
+if [ ! -e "${dir}/xfs_format.h" ]; then
+	echo "${dir}: This doesn't seem to be a libxfs/ directory."
+	exit 3
+fi
+
+dir="$(readlink -m "${dir}/..")"
+
+for i in libxfs/xfs*.[ch]; do
+	kfile="${dir}/$i"
+	diff -Naurpw --label "$i" <(sed -e '/#include/d' "$i") --label "${kfile}" <(sed -e '/#include/d' "${kfile}")
+done

