Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F8B7C4707F
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 01:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31B366142E
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 01:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhEZBsa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 21:48:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230147AbhEZBsa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 May 2021 21:48:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6916C61090;
        Wed, 26 May 2021 01:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621993619;
        bh=IhLEmXlI3tiYRj6u/aAWrucRxP/OTXBetUdBItm9nFU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bn8x3lm1KlCRLTKQZ5YPYpMv5HZqb8E+ax928uRcY4S8SkOQc3fTQtfKmeZieiIVy
         yWb244HaoLmrhrkQjjtVEZx3pDAzFMrzLYK9wVWKIwcX6wYeTXA26P57Opn0P/O3FH
         WvIJnJQgcycnJIJz1KdFcztJwh+nulpoFsKvtdN4dcc/J7HpKenx+oYsucEMX5dZXS
         i0QznKBBQOf20xQinFNykBiM5U3Hai4ZeOubirZj/26UsldnMeEIvR8CpQfvPOi5BZ
         +4yaHnGhpVtxvwKpgJ5d6jzXqI6Ecy0Fq4ghcH+xrh5vFTrbweToY8RHQJIoWbeMKt
         LhqhNuGJaoExQ==
Subject: [PATCH 03/10] fstests: add tool migrate group membership data to test
 files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 May 2021 18:46:59 -0700
Message-ID: <162199361915.3744214.4666565580602969000.stgit@locust>
In-Reply-To: <162199360248.3744214.17042613373014687643.stgit@locust>
References: <162199360248.3744214.17042613373014687643.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a tool to migrate the mapping of tests <-> groups out of the
group file and into the individual test file as a _set_seq_and_groups
call.  In the next patches we'll rewrite all the test files and auto
generate the group files from the tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tools/convert-group |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100755 tools/convert-group


diff --git a/tools/convert-group b/tools/convert-group
new file mode 100755
index 00000000..e7af10e0
--- /dev/null
+++ b/tools/convert-group
@@ -0,0 +1,64 @@
+#!/bin/bash
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
+		sed -e '/^seqres=\$RESULT_DIR\/\$seq$/d' \
+		    -e '/^echo "QA output created by \$seq"$/d' \
+		    -e '/^here=`pwd`$/d' \
+		    -e '/^tmp=\/tmp\/\$\$$/d' \
+		    -e '/^status=1.*failure.*is.*the.*default/d' \
+		    -e '/^status=1.*FAILure.*is.*the.*default/d' \
+		    -e '/^status=1.*success.*is.*the.*default/d' \
+		    -e '/^status=1.*default.*failure/d' \
+		    -e '/^echo.*QA output created by.*seq/d' \
+		    -e 's|^seq=.*$|. ./common/test_names\n_set_seq_and_groups '"$groups"'|g' \
+		    -i "$test"
+		if grep -q '^status=1$' "$test"; then
+			# Replace the "status=1" lines that don't have the usual
+			# "failure is the default" message if there's no other
+			# code between _set_seq_and_groups and status=1.
+			awk '
+BEGIN {
+	saw_groupinfo = 0;
+}
+{
+	if ($0 ~ /^_set_seq_and_groups/) {
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
+	done
+}
+
+curr_dir="$PWD"
+for tdir in "$@"; do
+	cd "tests/$tdir"
+	obliterate_group_file
+	cd "$curr_dir"
+done

