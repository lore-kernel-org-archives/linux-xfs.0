Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9C6C6379F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjARA5q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjARA5S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:57:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2C459741;
        Tue, 17 Jan 2023 16:44:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56EB461587;
        Wed, 18 Jan 2023 00:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB11AC433EF;
        Wed, 18 Jan 2023 00:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002658;
        bh=/t5e4H63A0yA50yAugMJjgVV/sdWPXrKyv6xll7M8hQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=un66hR7atZVcgL/l4GKWGRb3AutOvIk8m6q04ueEDj9NPhhGely5x3CCiPBmWkchl
         x4q/0rfySiJhI0ps9wI3mANHJIIylRl2c9CS3r9jMUtizBFwGbnQndrl+ANIGzVCA5
         RXa8pW/3IyqL3HbPi8GqB5mEvA3ffpc9zl4AOjwSaTwfL/y4Ujro5v7uOySBOgT0RC
         sErpWQ5FcUK08FKuVB53++/zEr1cgoak33t+vBrUF8YGwlxccKKsNxddeoZDk+LJNP
         fEv3+vdJNjt3t3cYz7nBW/VQRNHuZGmiP97nO4gmfUpYwQwBHR0iMY2vn4NhwJG87S
         XDS/OpmMOLN5w==
Date:   Tue, 17 Jan 2023 16:44:18 -0800
Subject: [PATCH 3/4] populate: improve attr creation runtime
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        david@fromorbit.com
Message-ID: <167400103083.1915094.17122126052905864562.stgit@magnolia>
In-Reply-To: <167400103044.1915094.5935980986164675922.stgit@magnolia>
References: <167400103044.1915094.5935980986164675922.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Replace the file creation loops with a python script that does
everything we want from a single process.  This reduces the runtime of
_scratch_xfs_populate substantially by avoiding thousands of execve
overhead.  This patch builds on the previous one by reducing the runtime
of xfs/349 from ~45s to ~15s.

For people who don't have python3, use setfattr's "restore" mode to bulk
create xattrs.  This reduces runtime to about ~25s.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |   22 +++++++++++++++++---
 src/popattr.py  |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+), 3 deletions(-)
 create mode 100755 src/popattr.py


diff --git a/common/populate b/common/populate
index 180540aedd..f34551d272 100644
--- a/common/populate
+++ b/common/populate
@@ -12,6 +12,10 @@ _require_populate_commands() {
 	_require_xfs_io_command "fpunch"
 	_require_test_program "punch-alternating"
 	_require_test_program "popdir.pl"
+	if [ -n "${PYTHON3_PROG}" ]; then
+		_require_command $PYTHON3_PROG python3
+		_require_test_program "popattr.py"
+	fi
 	case "${FSTYP}" in
 	"xfs")
 		_require_command "$XFS_DB_PROG" "xfs_db"
@@ -108,9 +112,21 @@ __populate_create_attr() {
 	missing="$3"
 
 	touch "${name}"
-	seq 0 "${nr}" | while read d; do
-		setfattr -n "user.$(printf "%.08d" "$d")" -v "$(printf "%.08d" "$d")" "${name}"
-	done
+
+	if [ -n "${PYTHON3_PROG}" ]; then
+		${PYTHON3_PROG} $here/src/popattr.py --file "${name}" --end "${nr}"
+
+		test -z "${missing}" && return
+		${PYTHON3_PROG} $here/src/popattr.py --file "${name}" --start 1 --incr 2 --end "${nr}" --remove
+		return
+	fi
+
+	# Simulate a getfattr dump file so we can bulk-add attrs.
+	(
+		echo "# file: ${name}";
+		seq --format "user.%08g=\"abcdefgh\"" 0 "${nr}"
+		echo
+	) | setfattr --restore -
 
 	test -z "${missing}" && return
 	seq 1 2 "${nr}" | while read d; do
diff --git a/src/popattr.py b/src/popattr.py
new file mode 100755
index 0000000000..397ced9d33
--- /dev/null
+++ b/src/popattr.py
@@ -0,0 +1,62 @@
+#!/usr/bin/python3
+
+# Copyright (c) 2023 Oracle.  All rights reserved.
+# SPDX-License-Identifier: GPL-2.0
+#
+# Create a bunch of xattrs in a file.
+
+import argparse
+import sys
+import os
+
+parser = argparse.ArgumentParser(description = 'Mass create xattrs in a file')
+parser.add_argument(
+	'--file', required = True, type = str, help = 'manipulate this file')
+parser.add_argument(
+	'--start', type = int, default = 0,
+	help = 'create xattrs starting with this number')
+parser.add_argument(
+	'--incr', type = int, default = 1,
+	help = 'increment attr number by this much')
+parser.add_argument(
+	'--end', type = int, default = 1000,
+	help = 'stop at this attr number')
+parser.add_argument(
+	'--remove', dest = 'remove', action = 'store_true',
+	help = 'remove instead of creating')
+parser.add_argument(
+	'--format', type = str, default = '%08d',
+	help = 'printf formatting string for attr name')
+parser.add_argument(
+	'--verbose', dest = 'verbose', action = 'store_true',
+	help = 'verbose output')
+
+args = parser.parse_args()
+
+fmtstring = "user.%s" % args.format
+
+# If we are passed a regular file, open it as a proper file descriptor and
+# pass that around for speed.  Otherwise, we pass the path.
+fp = None
+try:
+	fp = open(args.file, 'r')
+	fd = fp.fileno()
+	os.listxattr(fd)
+	if args.verbose:
+		print("using fd calls")
+except:
+	if args.verbose:
+		print("using path calls")
+	fd = args.file
+
+for i in range(args.start, args.end + 1, args.incr):
+	fname = fmtstring % i
+
+	if args.remove:
+		if args.verbose:
+			print("removexattr %s" % fname)
+		os.removexattr(fd, fname)
+	else:
+		if args.verbose:
+			print("setxattr %s" % fname)
+		os.setxattr(fd, fname, b'abcdefgh')

