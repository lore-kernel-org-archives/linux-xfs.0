Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC031EB64DD
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 01:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjGSBLF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jul 2023 21:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjGSBLE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2023 21:11:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDAC1BCB;
        Tue, 18 Jul 2023 18:11:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CA0160FB0;
        Wed, 19 Jul 2023 01:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D43C433C7;
        Wed, 19 Jul 2023 01:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689729062;
        bh=YlegWtWV8eVnqQvCpHFz7P6/RowwsJxR7vr7zoLnIAI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fGUJRZwfC3CWScbglBpR5rPpJXaYFK9YxA5A+lnaCi0wIBoGG3B/uQudPct0+2uGr
         BVlvb7SDmb1tZsqUKRniXk6J55lj6sdMk1Zt6xM7F5wIk68mKAERFa2RDTNO3JeBld
         WxOt+WrxwbEIWHuLIkUlUWowMjpPfdsufe3b2tceIo5Knr2XGSy6yGILLFV+ybvFY/
         ZpOo7RXpyKxlK+eWJWGwevIOmFmGaC+nwMMBi7+BT0YmRDpyLiT3rNqQqmr4hczjYs
         uPlv3ZIsuDHDfJrfoCVh2s/A5VjLVqQblfj5d2R1Y5k850or97SrXXloZ/pTBUHUQR
         Z2O+FIu+nKFXw==
Subject: [PATCH 2/2] check: generate gcov code coverage reports at the end of
 each section
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     tytso@mit.edu, kent.overstreet@linux.dev,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 18 Jul 2023 18:11:01 -0700
Message-ID: <168972906191.1698606.10738894314642211560.stgit@frogsfrogsfrogs>
In-Reply-To: <168972905065.1698606.6829635791058054610.stgit@frogsfrogsfrogs>
References: <168972905065.1698606.6829635791058054610.stgit@frogsfrogsfrogs>
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
 README |    3 ++
 check  |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)


diff --git a/README b/README
index 9790334db1..ccfdcbe703 100644
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
index 97c7c4c7d1..3e6f27c653 100755
--- a/check
+++ b/check
@@ -451,6 +451,87 @@ _global_log() {
 	fi
 }
 
+GCOV_DIR=/sys/kernel/debug/gcov
+
+# Find the topmost directories of the .gcno directory hierarchy
+_gcov_find_topdirs() {
+	find "${GCOV_DIR}/" -name '*.gcno' -printf '%d|%h\n' | \
+		sort -g -k 1 | \
+		uniq | \
+		$AWK_PROG -F '|' 'BEGIN { x = -1 } { if (x < 0) x = $1; if ($1 == x) printf("%s\n", $2);}'
+}
+
+# Generate lcov html report from kernel gcov data if configured
+_gcov_generate_report() {
+	unset REPORT_GCOV	# don't trigger multiple times if ^C
+
+	local output_dir="$1"
+	test -n "${output_dir}" || return
+	test "$output_dir" = "1" && output_dir="$REPORT_DIR/gcov"
+
+	# Kernel support built in?
+	test -d "$GCOV_DIR" || return
+
+	readarray -t gcno_dirs < <(_gcov_find_topdirs)
+	test "${#gcno_dirs[@]}" -gt 0 || return
+
+	mkdir -p "${output_dir}/"
+
+	# Collect raw coverage data from the kernel
+	readarray -t source_dirs < <(find "${GCOV_DIR}/" -mindepth 1 -maxdepth 1 -type d)
+	for dir in "${source_dirs[@]}"; do
+		cp -p -R -d -u "${dir}" "${output_dir}/"
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
+	test -n "${REPORT_GCOV}" || return
+
+	if [ -w "${GCOV_DIR}/reset" ]; then
+		echo 1 > "${GCOV_DIR}/reset"
+	else
+		unset REPORT_GCOV
+	fi
+}
+
 _wrapup()
 {
 	seq="check"
@@ -527,6 +608,10 @@ _wrapup()
 					     "${#bad[*]}" "${#notrun[*]}" \
 					     "$((sect_stop - sect_start))"
 		fi
+
+		# Generate code coverage report
+		test -n "$REPORT_GCOV" && _gcov_generate_report "$REPORT_GCOV"
+
 		needwrap=false
 	fi
 
@@ -801,6 +886,7 @@ function run_section()
 	  echo "MOUNT_OPTIONS -- `_scratch_mount_options`"
 	fi
 	echo
+	_gcov_reset
 	needwrap=true
 
 	if [ ! -z "$SCRATCH_DEV" ]; then

