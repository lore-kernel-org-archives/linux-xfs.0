Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 264E5C41513
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 01:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjGZB5J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jul 2023 21:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbjGZB5G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2023 21:57:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31807270C;
        Tue, 25 Jul 2023 18:56:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89A646109A;
        Wed, 26 Jul 2023 01:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3785C433C8;
        Wed, 26 Jul 2023 01:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690336612;
        bh=1yJvEsU5WxoQmlxaYQaEet12zgQoAqiLAvAr0rOG0W0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hycepsMSjh/LJAicBUN3cuoxs4X1L9q46UTSx+likHpKkEgrzYBDZazwXCoIntGel
         b6nXAwE0XEBrqNCHH+qu1FOZnV8qT2TqdOmggFhbplmrq4+b1dNxwiqruQhUNCoosd
         o5ulVA05LoecENUSsvzR2IiBqVxbHDTu9F60K2SSfqTezSwcFXu/mPJ+7dpolMU1kM
         2WErWOay0q9oJ6O4tQOHjuKIge9SqteDo84pKEwo/hEPm3t9p6FttdSl383b2oj2wS
         srPZp68pqk4TbypNjeAs0Pz3btqEehAuJHG4E55r/uepGvuUV5eYOot849gVx2q7ZW
         nzpoIpcNaNAeA==
Subject: [PATCH 2/2] check: generate gcov code coverage reports at the end of
 each section
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     tytso@mit.edu, kent.overstreet@linux.dev,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 Jul 2023 18:56:51 -0700
Message-ID: <169033661141.3222210.14155623533196891003.stgit@frogsfrogsfrogs>
In-Reply-To: <169033659987.3222210.11071346898413396128.stgit@frogsfrogsfrogs>
References: <169033659987.3222210.11071346898413396128.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Support collecting kernel code coverage information as reported in
debugfs.  At the start of each section, we reset the gcov counters;
during the section wrapup, we'll collect the kernel gcov data.

If lcov is installed and the kernel source code is available, it will
also generate a nice html report.  If a CLI web browser is available, it
will also format the html report into text for easy grepping.

This requires the test runner to set REPORT_GCOV=1 explicitly and gcov
to be enabled in the kernel.

Cc: tytso@mit.edu
Cc: kent.overstreet@linux.dev
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 README      |    3 ++
 check       |   18 ++++++++++++
 common/gcov |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+)
 create mode 100644 common/gcov


diff --git a/README b/README
index d4ec73d10d..966ec48ed6 100644
--- a/README
+++ b/README
@@ -249,6 +249,9 @@ Kernel/Modules related configuration:
    to "forever" and we'll wait forever until the module is gone.
  - Set KCONFIG_PATH to specify your preferred location of kernel config
    file. The config is used by tests to check if kernel feature is enabled.
+ - Set REPORT_GCOV to a directory path to make lcov and genhtml generate
+   html reports from any gcov code coverage data collected by the kernel.
+   If REPORT_GCOV is set to 1, the report will be written to $REPORT_DIR/gcov/.
 
 Test control:
  - Set LOAD_FACTOR to a nonzero positive integer to increase the amount of
diff --git a/check b/check
index c02e693642..9741be23c4 100755
--- a/check
+++ b/check
@@ -451,6 +451,11 @@ _global_log() {
 	fi
 }
 
+if [ -n "$REPORT_GCOV" ]; then
+	. ./common/gcov
+	_gcov_check_report_gcov
+fi
+
 _wrapup()
 {
 	seq="check"
@@ -527,6 +532,18 @@ _wrapup()
 					     "${#bad[*]}" "${#notrun[*]}" \
 					     "$((sect_stop - sect_start))"
 		fi
+
+		# Generate code coverage report
+		if [ -n "$REPORT_GCOV" ]; then
+			# don't trigger multiple times if caller hits ^C
+			local gcov_report_dir="$REPORT_GCOV"
+			test "$gcov_report_dir" = "1" && \
+				gcov_report_dir="$REPORT_DIR/gcov"
+			unset REPORT_GCOV
+
+			_gcov_generate_report "$gcov_report_dir"
+		fi
+
 		needwrap=false
 	fi
 
@@ -801,6 +818,7 @@ function run_section()
 	  echo "MOUNT_OPTIONS -- `_scratch_mount_options`"
 	fi
 	echo
+	test -n "$REPORT_GCOV" && _gcov_reset
 	needwrap=true
 
 	if [ ! -z "$SCRATCH_DEV" ]; then
diff --git a/common/gcov b/common/gcov
new file mode 100644
index 0000000000..b7e3ed5a93
--- /dev/null
+++ b/common/gcov
@@ -0,0 +1,87 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Oracle.  All Rights Reserved.
+#
+# Routines for capturing kernel code coverage reports
+
+GCOV_DIR=/sys/kernel/debug/gcov
+
+# Find the topmost directories of the .gcno directory hierarchy
+__gcov_find_topdirs() {
+	find "${GCOV_DIR}/" -name '*.gcno' -printf '%d|%h\n' | \
+		sort -g -k 1 | \
+		uniq | \
+		$AWK_PROG -F '|' 'BEGIN { x = -1 } { if (x < 0) x = $1; if ($1 == x) printf("%s\n", $2);}'
+}
+
+# Generate lcov html report from kernel gcov data if configured
+_gcov_generate_report() {
+	local output_dir="$1"
+	test -n "${output_dir}" || return
+
+	# Kernel support built in?
+	test -d "$GCOV_DIR" || return
+
+	readarray -t gcno_dirs < <(__gcov_find_topdirs)
+	test "${#gcno_dirs[@]}" -gt 0 || return
+
+	mkdir -p "${output_dir}/raw/"
+
+	# Collect raw coverage data from the kernel
+	readarray -t source_dirs < <(find "${GCOV_DIR}/" -mindepth 1 -maxdepth 1 -type d)
+	for dir in "${source_dirs[@]}"; do
+		cp -p -R -d -u "${dir}" "${output_dir}/raw/"
+	done
+
+	# If lcov is installed, use it to summarize the gcda data.
+	# If it is not installed, there's no point in going forward
+	command -v lcov > /dev/null || return
+	local lcov=(lcov --exclude 'include*' --capture)
+	lcov+=(--output-file "${output_dir}/gcov.report")
+	for d in "${gcno_dirs[@]}"; do
+		lcov+=(--directory "${d}")
+	done
+
+	# Generate a detailed HTML report from the summary
+	local gcov_start_time="$(date --date="${fstests_start_time:-now}")"
+	local genhtml=()
+	if command -v genhtml > /dev/null; then
+		genhtml+=(genhtml -o "${output_dir}/" "${output_dir}/gcov.report")
+		genhtml+=(--title "fstests on $(hostname -s) @ ${gcov_start_time}" --legend)
+	fi
+
+	# Try to convert the HTML report summary as text for easier grepping if
+	# there's an HTML renderer present
+	local totext=()
+	test "${#totext[@]}" -eq 0 && \
+		command -v lynx &>/dev/null && \
+		totext=(lynx -dump "${output_dir}/index.html" -width 120 -nonumbers -nolist)
+	test "${#totext[@]}" -eq 0 && \
+		command -v links &>/dev/null && \
+		totext=(links -dump "${output_dir}/index.html" -width 120)
+	test "${#totext[@]}" -eq 0 && \
+		command -v elinks &>/dev/null && \
+		totext=(elinks -dump "${output_dir}/index.html" --dump-width 120 --no-numbering --no-references)
+
+	# Analyze kernel data
+	"${lcov[@]}" > "${output_dir}/gcov.stdout" 2> "${output_dir}/gcov.stderr"
+	test "${#genhtml[@]}" -ne 0 && \
+		"${genhtml[@]}" >> "${output_dir}/gcov.stdout" 2>> "${output_dir}/gcov.stderr"
+	test "${#totext[@]}" -ne 0 && \
+		"${totext[@]}" > "${output_dir}/index.txt" 2>> "${output_dir}/gcov.stderr"
+}
+
+# Reset gcov usage data
+_gcov_reset() {
+	echo 1 > "${GCOV_DIR}/reset"
+}
+
+# If the caller wanted us to capture gcov reports but the kernel doesn't
+# support it, turn it off.
+_gcov_check_report_gcov() {
+	test -z "$REPORT_GCOV" && return 0
+	test -w "${GCOV_DIR}/reset" && return 0
+
+	unset REPORT_GCOV
+	return 1
+}

