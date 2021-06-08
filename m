Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE10C47082
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 17:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CA5161351
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 17:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbhFHRVi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 13:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232516AbhFHRVh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jun 2021 13:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CCE861359;
        Tue,  8 Jun 2021 17:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623172784;
        bh=YkUP0bsy1DYjSzvwt6C34unUNh66ehLYgYxXCSKthIc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K7lIyeC2VDAqV6UDllcaZRv7SDImYPXwQEmGnPvC6fJaZSaW6oW1qp1XbNmfHg64f
         op3O3f6t8H+kUBVMhmOV/vjvXWVNqhcIXN9D/tiJDA5rrL+I/d+t12HkiBColBJ0kg
         KGvu41GwQPnqm7Ws5F5ZkvqvVq1rG9Zg1xynhXeOn8O/ZylkNRWVIhjqkcEr7tlxLL
         JwGgGGYlvFGVDD/IcaolqgNrYUIeM14bnl26Z20OLtMR6Vb7EWVxqpkbETEkNXb1g0
         5upCxFEZNSfUhJejS5EDWy9vi0tS/JhPUpB8KRAFb6r8wRYkBsPJZF5iM6FiXpXwDp
         zLJMcN/PJKczA==
Subject: [PATCH 04/13] fstests: add tool migrate group membership data to test
 files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Date:   Tue, 08 Jun 2021 10:19:44 -0700
Message-ID: <162317278412.653489.8220326541398463657.stgit@locust>
In-Reply-To: <162317276202.653489.13006238543620278716.stgit@locust>
References: <162317276202.653489.13006238543620278716.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a tool to migrate the mapping of tests <-> groups out of the
group file and into the individual test file as a _begin_fstest
call.  In the next patches we'll rewrite all the test files and auto
generate the group files from the tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tools/convert-group |  131 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)
 create mode 100755 tools/convert-group


diff --git a/tools/convert-group b/tools/convert-group
new file mode 100755
index 00000000..42a99fe5
--- /dev/null
+++ b/tools/convert-group
@@ -0,0 +1,131 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+
+# Move group tags from the groups file into the test files themselves.
+
+if [ -z "$1" ] || [ "$1" = "--help" ]; then
+	echo "Usage: $0 test_dir [test_dirs...]"
+	exit 1
+fi
+
+obliterate_group_file() {
+	sed -e 's/^#.*$//g' < group | while read test groups; do
+		if [ -z "$test" ]; then
+			continue;
+		elif [ ! -e "$test" ]; then
+			echo "Ignoring unknown test file \"$test\"."
+			continue
+		fi
+
+		# Replace all the open-coded test preparation code with a
+		# single call to _begin_fstest.
+		sed -e '/^seqres=\$RESULT_DIR\/\$seq$/d' \
+		    -e '/^seqres=\"\$RESULT_DIR\/\$seq\"$/d' \
+		    -e '/^echo "QA output created by \$seq"$/d' \
+		    -e '/^here=`pwd`$/d' \
+		    -e '/^here=\$(pwd)$/d' \
+		    -e '/^here=\$PWD$/d' \
+		    -e '/^here=\"`pwd`\"$/d' \
+		    -e '/^tmp=\/tmp\/\$\$$/d' \
+		    -e '/^status=1.*failure.*is.*the.*default/d' \
+		    -e '/^status=1.*FAILure.*is.*the.*default/d' \
+		    -e '/^status=1.*success.*is.*the.*default/d' \
+		    -e '/^status=1.*default.*failure/d' \
+		    -e '/^echo.*QA output created by.*seq/d' \
+		    -e '/^# remove previous \$seqres.full before test/d' \
+		    -e '/^rm -f \$seqres.full/d' \
+		    -e 's|^# get standard environment, filters and checks|# Import common functions.|g' \
+		    -e '/^\. \.\/common\/rc/d' \
+		    -e '/^\. common\/rc/d' \
+		    -e 's|^seq=.*$|. ./common/preamble\n_begin_fstest '"$groups"'|g' \
+		    -i "$test"
+
+		# Replace the open-coded trap calls that register cleanup code
+		# with a call to _register_cleanup.
+		#
+		# For tests that registered empty-string cleanups or open-coded
+		# calls to remove $tmp files, remove the _register_cleanup
+		# calls entirely because the default _cleanup does that for us.
+		#
+		# For tests that now have a _register_cleanup call for the
+		# _cleanup function, remove the explicit call because
+		# _begin_fstest already registers that for us.
+		#
+		# For tests that override _cleanup, insert a comment noting
+		# that it is overriding the default, to match the ./new
+		# template.
+		sed -e 's|^trap "exit \\\$status" 0 1 2 3 15|_register_cleanup ""|g' \
+		    -e 's|^trap "\(.*\)[[:space:]]*; exit \\\$status" 0 1 2 3 15|_register_cleanup "\1"|g' \
+		    -e 's|^trap "\(.*\)[[:space:]]*; exit \\\$status" 1 2 3 15|_register_cleanup "\1"|g' \
+		    -e 's|^trap '"'"'\(.*\)[[:space:]]*; exit \$status'"'"' 0 1 2 3 15|_register_cleanup "\1"|g' \
+		    -e 's|^trap "\(.*\)[[:space:]]*; exit \\\$status" 0 1 2 3 7 15|_register_cleanup "\1" BUS|g' \
+		    -e 's|^_register_cleanup "[[:space:]]*\([^[:space:]]*\)[[:space:]]*"|_register_cleanup "\1"|g' \
+		    -e '/^_register_cleanup ""$/d' \
+		    -e '/^_register_cleanup "rm -f \$tmp.*"$/d' \
+		    -e '/^_register_cleanup "_cleanup"$/d' \
+		    -e 's|^_cleanup()|# Override the default cleanup function.\n_cleanup()|g' \
+		    -i "$test"
+
+		# If the test doesn't import any common functionality,
+		# get rid of the pointless comment.
+		if ! grep -q '^\. .*common' "$test"; then
+			sed -e '/^# Import common functions.$/d' -i "$test"
+		fi
+
+		# Replace the "status=1" lines that don't have the usual
+		# "failure is the default" message if there's no other code
+		# between _begin_fstest and status=1.
+		if grep -q '^status=1$' "$test"; then
+			awk '
+BEGIN {
+	saw_groupinfo = 0;
+}
+{
+	if ($0 ~ /^_begin_fstest/) {
+		saw_groupinfo = 1;
+		printf("%s\n", $0);
+	} else if ($0 ~ /^status=1$/) {
+		if (saw_groupinfo == 0) {
+			printf("%s\n", $0);
+		}
+	} else if ($0 == "") {
+		printf("\n");
+	} else {
+		saw_groupinfo = 0;
+		printf("%s\n", $0);
+	}
+}
+' < "$test" > "$test.new"
+			cat "$test.new" > "$test"
+			rm -f "$test.new"
+		fi
+
+		# Collapse sequences of blank lines to a single blank line.
+		awk '
+BEGIN {
+	saw_blank = 0;
+}
+{
+	if ($0 ~ /^$/) {
+		if (saw_blank == 0) {
+			printf("\n");
+			saw_blank = 1;
+		}
+	} else {
+		printf("%s\n", $0);
+		saw_blank = 0;
+	}
+}
+' < "$test" > "$test.new"
+		cat "$test.new" > "$test"
+		rm -f "$test.new"
+	done
+}
+
+curr_dir="$PWD"
+for tdir in "$@"; do
+	cd "tests/$tdir"
+	obliterate_group_file
+	cd "$curr_dir"
+done

