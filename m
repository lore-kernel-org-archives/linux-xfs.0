Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6A3283FD9;
	Thu, 15 Oct 2026 00:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792025504; cv=none; b=L6Io/XwzhC+TUD+bM2ajm/DJqiITpbz/jZkAh++fmCQrq8IVm+dldzx6ygeBXf3jJ2TevNdaKOyNWV2htHOGaxpgGXVUXjbxg1EA5tmsRwDHKat/hRYUV0vHPAXxR68cLwEW290u9d5xSeheDpgmXHbcHfpId3ejEul7TxxCl1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792025504; c=relaxed/simple;
	bh=ecLT0VuIvgRQnB8aslTs5ea7F4W99ksMeIgaHnexexc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZiMVCVvwCR0gEBHo8BUxzSbbrUevvLcIMZcbPIqNQW/Y07sdm4gVolClGmaBWZhx1MY3ZhITcqCm+CnAbDZnA+Y3yO9TMIxad63Cw+jLXQH6UNyJduEOtDzfJXrshrRYd2eIOusDJW0Gt9Z6Ove6ZE1cwFriXc0fZ/s2us5QB8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LqUSnE96; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LqUSnE96"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 21BCA1F000C4;
	Thu, 15 Oct 2026 00:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792025502;
	bh=rU58qFAOgxPGrHMh328UFY501BskW4Y0XWYEsilcEyo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=LqUSnE96H4HfuuhNQPjbcm0JeCDRRJPTpnWQfNr+AMwmkMHQc4e1DVCOqeTXUv86G
	 Knnm/+dzXL4CaYcrTi5CqaQEp538XrXe1wVy4hRmNxGkKNrDZBAet6LSxh0NiuqWuQ
	 2bQWb+Uz93IvovQOPz5CNbTuepHr3KrS2lypbWL/Sdw5oak4Pim3Une68kyIS6rP8O
	 jo3nVLwNRChhXu2HxwEbmCeoL1Plq5b1Ag8M2nQoSRUgDAytwr6nsHSbeT43Jl7pke
	 5Vk+9xc1+h5qrEnrsZiMKVTG6lwAU4R9eWhcVwunkXJ4tx72mVlCaFcnJKowTAqY1M
	 27KC4sBuofJVg==
Date: Wed, 14 Oct 2026 17:51:41 -0700
Subject: [PATCH 2/6] matrix: add per-VM test result reporter code
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, tytso@mit.edu, fstests@vger.kernel.org
Message-ID: <179202481219.3448668.5571303068658567989.stgit@frogsfrogsfrogs>
In-Reply-To: <179202481155.3448668.10918297235750961947.stgit@frogsfrogsfrogs>
References: <179202481155.3448668.10918297235750961947.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

Add an agent that is installed into each running test VM.  The agent
periodically packages the test xunit output file and relevant failure
data into a tarball and then uploads it to the web dashboard.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 matrix/reporter/collect-all-results           |   30 ++
 matrix/reporter/collect-results.in            |  142 +++++++++
 matrix/reporter/config                        |    5 
 matrix/reporter/copy-failure-info.in          |  374 +++++++++++++++++++++++++
 matrix/reporter/fingerprint-machine           |   19 +
 matrix/reporter/fingerprint-tests             |   58 ++++
 matrix/reporter/fstests-reporter.1            |   30 ++
 matrix/reporter/fstests-reporter.in           |   71 +++++
 matrix/reporter/fstmatrix-reporter            |   19 +
 matrix/reporter/fstmatrix-reporter.service.in |   20 +
 matrix/reporter/fstmatrix-reporter.timer      |   17 +
 matrix/reporter/fstmatrix-want-reporter       |   22 +
 matrix/reporter/starttime                     |   36 ++
 matrix/reporter/upload-all-results.in         |   52 +++
 matrix/reporter/xunit_failed.awk              |   14 +
 matrix/reporter/xunit_rollup.awk              |   22 +
 16 files changed, 931 insertions(+)
 create mode 100755 matrix/reporter/collect-all-results
 create mode 100755 matrix/reporter/collect-results.in
 create mode 100644 matrix/reporter/config
 create mode 100755 matrix/reporter/copy-failure-info.in
 create mode 100755 matrix/reporter/fingerprint-machine
 create mode 100755 matrix/reporter/fingerprint-tests
 create mode 100644 matrix/reporter/fstests-reporter.1
 create mode 100755 matrix/reporter/fstests-reporter.in
 create mode 100755 matrix/reporter/fstmatrix-reporter
 create mode 100644 matrix/reporter/fstmatrix-reporter.service.in
 create mode 100644 matrix/reporter/fstmatrix-reporter.timer
 create mode 100644 matrix/reporter/fstmatrix-want-reporter
 create mode 100644 matrix/reporter/starttime
 create mode 100755 matrix/reporter/upload-all-results.in
 create mode 100644 matrix/reporter/xunit_failed.awk
 create mode 100644 matrix/reporter/xunit_rollup.awk


diff --git a/matrix/reporter/collect-all-results b/matrix/reporter/collect-all-results
new file mode 100755
index 00000000000000..d54f71daecafbe
--- /dev/null
+++ b/matrix/reporter/collect-all-results
@@ -0,0 +1,30 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+# Collect all the test result info from all runs
+# Usage: $0 fstests-dir results-base console-output output-dir
+
+scriptdir="$(dirname "$0")"
+
+fstests_dir="$1"
+resultbase="$2"
+console_output="$3"
+outdir="$4"
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+test ! -d "${fstests_dir}" && die "no fstests dir"
+test -z "${outdir}" && die "no output dir"
+test ! -d "${resultbase}" && die "no fstests results dir"
+
+find_checkfiles() {
+	find "${resultbase}/" -name result.xml -print 2> /dev/null
+}
+
+find_checkfiles | while read checkfile; do
+	results="$(dirname "${checkfile}")"
+	"${scriptdir}/collect-results" "${fstests_dir}" "${results}" "${console_output}" "${outdir}"
+done
diff --git a/matrix/reporter/collect-results.in b/matrix/reporter/collect-results.in
new file mode 100755
index 00000000000000..18ce8a8f1d7c6c
--- /dev/null
+++ b/matrix/reporter/collect-results.in
@@ -0,0 +1,142 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+# Collect all the test result info from a given run
+# Usage: $0 fstests-dir fstests-results-dir console-output output-dir
+
+scriptdir="$(dirname "$0")"
+
+fstests_dir="$1"
+results="$2"
+console_output="$3"
+outdir="$4"
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+test ! -d "${fstests_dir}" && die "no fstests dir"
+test ! -d "${results}" && die "no fstests results dir"
+test -z "${outdir}" && die "no output dir"
+
+if [ ! -e "${results}/check.starttime" ]; then
+	if [ -e "${results}/result.xml" ]; then
+		# We don't have the start time recorded.  See if we can extract
+		# it from the xunit report.
+		xunit_starttime="$("${scriptdir}/starttime" "${results}/result.xml")"
+
+		# If parsing result.xml fails for any reason (e.g. reporter
+		# racing with fstests that hasn't generated a report yet),
+		# leave the check.starttime file blank and we'll put in the
+		# current time below.
+		if [ -n "${xunit_starttime}" ]; then
+			date --date="${xunit_starttime}" '+%s' > "${results}/check.starttime" 2>/dev/null || \
+				rm -f "${results}/check.starttime"
+		fi
+	fi
+	if [ ! -s "${results}/check.starttime" ]; then
+		# Otherwise we'll just use the current time.
+		date '+%s' > "${results}/check.starttime"
+	fi
+fi
+raw_starttime="$(cat "${results}/check.starttime")"
+
+hostname="$(hostname | tr './' '__')"
+test -z "${hostname}" && hostname="unknown"
+starttime="$(TZ=UTC date --date="@${raw_starttime}" '+%Y-%m-%d_%H-%M-%S')"
+tarballs="${outdir}/tarballs"
+
+if command -v zstd &>/dev/null; then
+	tarball="${tarballs}/${hostname}_${starttime}.tar.zst"
+	compressor=(zstd -9)
+elif command -v gzip &>/dev/null; then
+	tarball="${tarballs}/${hostname}_${starttime}.tar.gz"
+	compressor=(gzip)
+elif command -v xz &>/dev/null; then
+	tarball="${tarballs}/${hostname}_${starttime}.tar.xz"
+	compressor=(xz)
+fi
+
+outsnapshot="${outdir}/${starttime}"
+outsummary="${outsnapshot}/summary"
+outresults="${outsnapshot}/results"
+outmachine="${outsnapshot}/machine"
+machine="${results}/machine"
+
+# Create basic output directory structure for tarballing
+mkdir -p "${outsummary}" "${outresults}"
+
+# Fingerprint the machine if we haven't already
+if [ ! -d "${outmachine}" ]; then
+	rm -r -f "${outmachine}"
+	mkdir -p "${outmachine}"
+	"${scriptdir}/fingerprint-machine" "${outmachine}"
+fi
+
+# Find all groupfiles under the fstests directory.
+list_groupfiles()
+{
+	find "${fstests_dir}/tests/" -name group -print -o -name group.list -print
+}
+
+# Fingerprint the test files and groups if we haven't already
+list_tests()
+{
+	# Make a list of every test mentioned in a test/*/group file.
+	list_groupfiles | while read grpfile; do
+		dir="$(dirname "${grpfile}")"
+		groupname="$(basename "${dir}")"
+		while read testcase groups; do
+			test -n "${testcase}" || continue
+			fname="${dir}/${testcase}"
+			test -e "${fname}" && \
+				echo "${groupname}/${testcase} ${groups}"
+		done < "${grpfile}"
+	done
+}
+if [ ! -e "${outsummary}/test-fingerprints" ]; then
+	list_tests | sort > "${outsummary}/test-groups"
+	awk '{print $1}' < "${outsummary}/test-groups" | \
+		"${scriptdir}/fingerprint-tests" "${fstests_dir}" > \
+		"${outsummary}/test-fingerprints"
+fi
+
+# Save an abbreviated version of the xunit output if ./check has updated the
+# report since the last time we ran.
+fstests_summary="$(readlink -m "${results}/result.xml")"
+fstmatrix_summary="$(readlink -m "${outsummary}/result.xml")"
+if [ "${fstests_summary}" -nt "${fstmatrix_summary}" ]; then
+	awk -v kernel="$(uname -r)" -f "%pkg_lib_dir%/xunit_rollup.awk" \
+		< "${fstests_summary}" > "${fstmatrix_summary}"
+fi
+
+# Link live(?) fstests results into output directory.
+cd "${results}"
+for file in check.*; do
+	test -e "${outsummary}/${file}" || \
+		ln -s -f "${results}/${file}" "${outsummary}/"
+done
+"${scriptdir}/copy-failure-info" "${fstests_dir}" "${results}" "${console_output}" "${outsnapshot}"
+
+# Tarball everything, being careful not to disturb the tarball unless
+# something really changed.
+cd "${outsnapshot}/"
+mkdir -p "${tarballs}"
+if [ -e last_report ] && [ "$(find -L . -newercc last_report | wc -l)" -eq 0 ]; then
+	exit 0
+fi
+touch last_report
+tar ch summary machine results stats | "${compressor[@]}" > "${tarball}.new"
+if [ "${PIPESTATUS[0]}" -ne 0 ]; then
+	exit 1
+fi
+
+old_hash="$(sha256sum "${tarball}" 2> /dev/null)"
+new_hash="$(sha256sum "${tarball}.new")"
+if [ "${old_hash}" != "${new_hash}" ]; then
+	mv "${tarball}.new" "${tarball}"
+else
+	rm -f "${tarball}.new"
+fi
+exit 0
diff --git a/matrix/reporter/config b/matrix/reporter/config
new file mode 100644
index 00000000000000..f94f3236777fa4
--- /dev/null
+++ b/matrix/reporter/config
@@ -0,0 +1,5 @@
+# Configuration file for fstmatrix-reporter
+#
+# Set this to a list of URLs that will accept fstests results.  Generally, this
+# will be the URL of the uploader.php script from the -collector package.
+# REPORTER_URLS=("https://example.com/fstests/uploader.php")
diff --git a/matrix/reporter/copy-failure-info.in b/matrix/reporter/copy-failure-info.in
new file mode 100755
index 00000000000000..f08969d50721bb
--- /dev/null
+++ b/matrix/reporter/copy-failure-info.in
@@ -0,0 +1,374 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+# Generate diffs of the golden output
+# Usage: $0 fstests-dir fstests-results-dir console-output outputdir
+
+fstests_dir="$1"
+results="$2"
+console_output="$3"
+outsnapshot="$4"
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+test ! -d "${fstests_dir}" && die "no fstests dir"
+test ! -d "${results}" && die "no results dir"
+test -z "${outsnapshot}" && die "no output dir"
+
+outsummary="${outsnapshot}/summary"
+outresults="${outsnapshot}/results"
+outstats="${outsnapshot}/stats"
+
+FAIL_LOGS=(".out.bad" ".full" ".dmesg" ".kmemleak" ".mountfail")
+TEST_STATS=()
+
+# Maximum file sizes for anything we collect from fstests
+declare -A MAX_FILESIZES
+MAX_FILESIZES[".full"]=262144
+MAX_FILESIZES[".out.diff"]=16384
+MAX_FILESIZES[".out.bad"]=16384
+MAX_FILESIZES[".dmesg"]=16384
+MAX_FILESIZES[".kmemleak"]=16384
+MAX_FILESIZES[".mountfail"]=16384
+MAX_FILESIZES["console.txt"]=65536
+
+# Multiply the above max sizes by this factor; this is the maximum amount
+# of information that we'll feed to a compressor.
+COMPRESSION_SRC_FACTOR=2
+
+# Compress to this level
+COMPRESSION_LEVEL=9
+
+# Supported compression schemes
+COMPRESSION=(".gz" ".bz2" ".lz4" ".xz" ".zst" ".br")
+
+declare -A COMPRESSORS
+COMPRESSORS[".gz"]="gzip"
+COMPRESSORS[".bz2"]="bzip2"
+COMPRESSORS[".lz4"]="lz4"
+COMPRESSORS[".xz"]="xz"
+COMPRESSORS[".zst"]="zstd"
+COMPRESSORS[".br"]="brotli"
+
+DEFAULT_COMPRESSOR=".br"
+
+# Make sure our destination directory structure exists
+cd "${results}/" || exit
+mkdir -p "${outsummary}" "${outresults}" "${outstats}"
+
+if [ ! -e check.failures ] && [ ! -e "${outsummary}/result.xml" ]; then
+	die "Unknown test report format"
+fi
+
+# Extract file extension from filenames
+fileext()
+{
+	echo "$@" | sed -e 's/^.*\(\..*\)$/\1/g' -e '/^[^.]/d'
+}
+
+# Is this file extension really a compression format?
+is_compressed()
+{
+	local compr
+
+	for compr in "${COMPRESSION[@]}"; do
+		test "$1" = "${compr}" && return 0
+	done
+	return 1
+}
+
+# Should we process a compressed log file over an uncompressed version?
+want_compressed_logfile()
+{
+	local src="$1"
+	local logtype="$2"
+	local compr="$3"
+
+	# Compressed version has to exist.
+	test -f "${src}${logtype}${compr}" || return 1
+
+	# Compressed version is newer than the uncompressed version or there is
+	# no uncompressed version.
+	test "${src}${logtype}${compr}" -nt "${src}${logtype}"
+}
+
+# Should we regenerate the dest file from the source file?
+want_dest_update()
+{
+	local src_path="$1"
+	local dst_path="$2"
+
+	# Clear out any file type on the dest that we don't create ourselves.
+	if [ ! -L "${dst_path}" ] && [ ! -f "${dst_path}" ]; then
+		if [ -d "${dst_path}" ]; then
+			rmdir "${dst_path}"
+		else
+			rm -f "${dst_path}"
+		fi
+	fi
+
+	# If the destination exists and the source path is the same age or
+	# older than the destination path, we don't need to do anything.
+	if [ -e "${dst_path}" ] && [ ! "${src_path}" -nt "${dst_path}" ]; then
+		return 1
+	fi
+
+	return 0
+}
+
+# Move timestamp from source to dest so that we can detect stale dest files.
+finish_dest_update()
+{
+	local src_path="$1"
+	local dst_path="$2"
+
+	touch --reference="${src_path}" --no-create "${dst_path}"
+}
+
+# Preserve or excerpt a compressed log file.
+preserve_compressed_logfile()
+{
+	local src="$1"
+	local dst="$2"
+	local logtype="$3"
+	local compr="$4"
+	local maxfilesize="${MAX_FILESIZES["${logtype}"]}"
+	local compressor="${COMPRESSORS["${compr}"]}"
+	local src_size
+	local compr_size
+
+	local src_path="${src}${logtype}${compr}"
+	local dst_path="${dst}${logtype}${compr}"
+
+	test -e "${src_path}" || return 1
+
+	want_dest_update "${src_path}" "${dst_path}" || return
+
+	# If the compressed size is less than max file size, just link it
+	# and delete any uncompressed log file on the destination.
+	src_size="$(stat -c '%s' "${src_path}")"
+	if (( src_size < maxfilesize )); then
+		test -d "${dst_path}" && rmdir "${dst_path}"
+		ln -s -f "${src_path}" "${dst_path}" && \
+			rm -f "${dst}${logtype}"
+		return
+	fi
+
+	# Otherwise, delete dst_path if it's a symlink, excerpt the compressed
+	# file, and delete any uncompressed file in the dest dir.
+	test -L "${dst_path}" && rm -f "${dst_path}"
+
+	# Decompress the file, excerpt it, and recompress that.
+	compr_size=$((COMPRESSION_SRC_FACTOR * maxfilesize))
+	"${compressor}" -d < "${src_path}" | \
+			head -c "${compr_size}" | \
+			"${compressor}" "-${COMPRESSION_LEVEL}" > "${dst_path}" && \
+		rm -f "${dst}${logtype}"
+	finish_dest_update "${src_path}" "${dst_path}"
+}
+
+# Preserve or excerpt an uncompressed log file.
+preserve_uncompressed_logfile()
+{
+	local src="$1"
+	local dst="$2"
+	local logtype="$3"
+	local maxfilesize="${MAX_FILESIZES["${logtype}"]}"
+	local compressor="${COMPRESSORS["${DEFAULT_COMPRESSOR}"]}"
+	local src_size
+	local compr_size
+
+	local src_path="${src}${logtype}"
+	local dst_path="${dst}${logtype}"
+
+	test -e "${src_path}" || return 1
+
+	# This is a small file; link it without compressing it.
+	src_size="$(stat -c '%s' "${src_path}")"
+	if (( src_size < maxfilesize )); then
+
+		want_dest_update "${src_path}" "${dst_path}" || return
+
+		test -d "${dst_path}" && rmdir "${dst_path}"
+		ln -s -f "${src_path}" "${dst_path}"
+		return
+	fi
+
+	# If our chosen compressor is not available, excerpt the file.
+	if ! command -v "${compressor}" &>/dev/null; then
+		want_dest_update "${src_path}" "${dst_path}" || return
+
+		head -c "${maxfilesize}" < "${src_path}" > "${dst_path}"
+		finish_dest_update "${src_path}" "${dst_path}"
+		return
+	fi
+
+	# Let's see if the compressed version is somehow newer than the
+	# source file.  If so, skip it.
+	dst_path="${dst_path}${compr}"
+	want_dest_update "${src_path}" "${dst_path}" || return
+
+	# Otherwise, delete dst_path if it's a symlink, excerpt the
+	# uncompressed file, and compress the output.
+	test -L "${dst_path}" && rm -f "${dst_path}"
+	compr_size=$((COMPRESSION_SRC_FACTOR * maxfilesize))
+	head -c "${compr_size}" "${src_path}" | \
+			"${compressor}" "-${COMPRESSION_LEVEL}" > "${dst_path}" && \
+		rm -f "${dst}${logtype}"
+	finish_dest_update "${src_path}" "${dst_path}"
+}
+
+# Preserve a possibly compressed log file.
+preserve_logfile()
+{
+	local src="$1"
+	local dst="$2"
+	local logtype="$3"
+	local compr
+
+	# Check for a compressed source file...
+	for compr in "${COMPRESSION[@]}"; do
+		if want_compressed_logfile "${src}" "${logtype}" "${compr}"; then
+			preserve_compressed_logfile "${src}" "${dst}" "${logtype}" "${compr}"
+			return
+		fi
+	done
+
+	preserve_uncompressed_logfile "${src}" "${dst}" "${logtype}"
+}
+
+# Create a golden output diff from a compressed bad output file.
+diff_compressed_golden()
+{
+	local orig="$1"
+	local src="$2"
+	local dst="$3"
+	local compr="$4"
+	local badout="${src}.out.bad${compr}"
+	local golden="${orig}.out"
+	local diff="${dst}.out.diff"
+	local maxfilesize="${MAX_FILESIZES[".out.diff"]}"
+	local compressor="${COMPRESSORS["${compr}"]}"
+
+	test -f "${badout}" || return 1
+	command -v "${compressor}" &>/dev/null || return 1
+
+	want_dest_update "${badout}" "${diff}" || return
+
+	diff -Naurp --label "${src}.out.bad" "${golden}" <("${compressor}" -d < "${badout}") | \
+		head -c "${maxfilesize}" > "${diff}"
+	finish_dest_update "${badout}" "${diff}"
+}
+
+# Create a golden output diff from a compressed bad output file.
+diff_uncompressed_golden()
+{
+	local orig="$1"
+	local src="$2"
+	local dst="$3"
+	local badout="${src}.out.bad"
+	local golden="${orig}.out"
+	local diff="${dst}.out.diff"
+	local maxfilesize="${MAX_FILESIZES[".out.diff"]}"
+
+	test -f "${badout}" || return 1
+
+	want_dest_update "${badout}" "${diff}" || return
+
+	diff -Naurp "${golden}" "${badout}" | head -c "${maxfilesize}" > "${diff}"
+	finish_dest_update "${badout}" "${diff}"
+}
+
+# Create a golden output diff from a possibly compressed bad output file.
+diff_golden()
+{
+	local orig="$1"
+	local src="$2"
+	local dst="$3"
+	local compr
+
+	for compr in "${COMPRESSION[@]}"; do
+		if [ -e "${src}.out.bad${compr}" ]; then
+			diff_compressed_golden "${orig}" "${src}" "${dst}" "${compr}"
+			return
+		fi
+	done
+
+	diff_uncompressed_golden "${orig}" "${src}" "${dst}"
+}
+
+# Print failing tests from the results.xml file
+dump_failures() {
+	if [ -e "${outsummary}/result.xml" ]; then
+		# flatten xunit file, extract failed list...
+		awk -f "%pkg_lib_dir%/xunit_failed.awk" < "${outsummary}/result.xml" | \
+			sed -e 's/^.*name="//g' -e 's/".*$//g'
+	fi
+}
+
+# Handle files that are collected for failed tests.
+readarray -t targets < <(dump_failures)
+for target in "${targets[@]}"; do
+	orig="${fstests_dir}/tests/${target}"
+	src="${results}/${target}"
+	dst="${outresults}/${target}"
+
+	mkdir -p "$(dirname "${dst}")"
+
+	diff_golden "${orig}" "${src}" "${dst}"
+
+	for logtype in "${FAIL_LOGS[@]}"; do
+		preserve_logfile "${src}" "${dst}" "${logtype}"
+	done
+done
+
+# Preserve console output, if it's a regular file.  Note the trailing slashes
+# because we consider "console.txt" to be its own log type.
+if [ -f "${console_output}" ]; then
+	ln -s -f "${console_output}" "${results}/console.txt"
+	preserve_logfile "${results}/" "${outresults}/" "console.txt"
+fi
+
+# Link statistics information into a subdir of the output dir
+dump_stats() {
+	local args=()
+	for pattern in "${TEST_STATS[@]}"; do
+		test "${#args[@]}" -ne 0 && args+=(-o)
+		args+=(-name "*${pattern}*" -print)
+	done
+	if [ "${#args[@]}" -gt 0 ]; then
+		find "${results}/" "${args[@]}"
+	fi
+}
+
+readarray -t targets < <(dump_stats)
+for target in "${targets[@]}"; do
+	# Extract first file extension, see if it's compressed.
+	ext="$(fileext "${target}")"
+	test -z "${ext}" && continue
+
+	unset compr
+	if is_compressed "${ext}"; then
+		compr="${ext}"
+		target="${target%${ext}}"
+		ext="$(fileext "${target}")"
+	fi
+
+	# Extract another file extension to figure out its type
+	test -z "${ext}" && continue
+	logtype="${ext}"
+
+	src="${target%${ext}}"
+	dst="${outstats}/${src#${results}}"
+
+	mkdir -p "$(dirname "${dst}")"
+
+	if [ -n "${compr}" ]; then
+		preserve_compressed_logfile "${src}" "${dst}" "${logtype}" "${compr}"
+	else
+		preserve_uncompressed_logfile "${src}" "${dst}" "${logtype}"
+	fi
+done
diff --git a/matrix/reporter/fingerprint-machine b/matrix/reporter/fingerprint-machine
new file mode 100755
index 00000000000000..3c83cb664d089a
--- /dev/null
+++ b/matrix/reporter/fingerprint-machine
@@ -0,0 +1,19 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+# Compute machine fingerprint
+# Usage: $0 output-dir
+
+cd "$1"
+lscpu | egrep '(^Architecture:|^CPU.s.:|^NUMA node.s.:)' > fingerprint
+/bin/egrep '(^MemTotal:|^SwapTotal:)' /proc/meminfo | awk '{printf("%s %.0f GB\n", $1, $2 / 1048576);}' >> fingerprint
+lsblk -n -o NAME,SIZE,PHY-SEC,LOG-SEC,ROTA,SCHED,TYPE | grep '^[[:alpha:]]' | sort >> fingerprint
+
+lscpu > cpu
+lsblk -O -J > blk
+lspci > pci
+cat /proc/meminfo > mem
+
+hostname="$(hostname | tr './' '__')"
+test -z "${hostname}" && hostname="unknown"
+echo "${hostname}" > hostname
diff --git a/matrix/reporter/fingerprint-tests b/matrix/reporter/fingerprint-tests
new file mode 100755
index 00000000000000..0061c345486078
--- /dev/null
+++ b/matrix/reporter/fingerprint-tests
@@ -0,0 +1,58 @@
+#!/usr/bin/python3
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+# Fingerprint the tests coming in on stdin and print the map
+# Usage: $0 fstests-dir
+
+import sys
+import hashlib
+import re
+
+qatest = re.compile('FS\s*QA\s*Test')
+qatest = re.compile('FS.*QA.*Test.*[0-9]')
+
+# We fingerprint a test file by computing the hash of everything in the
+# first comments area after the 'FS QA Test No. XXX' to insulate ourselves
+# from renumbering or random test cleanups.
+def fingerprint(testdir, testname, fingerprints):
+	def descr_lines():
+		yet = False
+		with open('%s/tests/%s' % (testdir, testname), mode = 'r', encoding = 'utf-8') as fd:
+			for line in fd:
+				stripline = line.strip()
+				if len(stripline) < 2:
+					continue
+				if stripline[0] != '#':
+					return
+				if not yet:
+					if qatest.search(line) != None:
+						yet = True
+					if not yet:
+						continue
+				yield line
+	m = hashlib.sha256()
+	any_lines = False
+	for descr_line in descr_lines():
+		m.update(descr_line.encode('utf-8'))
+		any_lines = True
+	if not any_lines:
+		return
+	fingerprints[testname] = m.hexdigest()
+
+def main():
+	testdir = sys.argv[1]
+	fingerprints = {}
+	for line in sys.stdin:
+		fingerprint(testdir, line.strip(), fingerprints)
+	fingerset = set()
+	for test in fingerprints:
+		hash = fingerprints[test]
+		if hash in fingerset:
+			print('WARNING: %s has duplicate fingerprint.' % test, file = sys.stderr)
+		fingerset.add(hash)
+
+	for test in sorted(fingerprints):
+		print("%s\t%s" % (test, fingerprints[test]))
+
+if __name__ == '__main__':
+	main()
diff --git a/matrix/reporter/fstests-reporter.1 b/matrix/reporter/fstests-reporter.1
new file mode 100644
index 00000000000000..343ea724a6eb66
--- /dev/null
+++ b/matrix/reporter/fstests-reporter.1
@@ -0,0 +1,30 @@
+.TH FSTESTS-REPORTER "1" "October 2018" "fstests-reporter"
+.SH NAME
+fstests-reporter - Manage fstests result reporting service
+.SH SYNOPSYS
+.B
+fstests-reporter VERB [options...]
+.SH DESCRIPTION
+Manages the fstests results reporting service, which collects all available
+test results and uploads them somewhere.
+.SH VERBS
+Verbs are as follows:
+.TP
+.B stop
+Deactivate the service.
+.TP
+.B status
+Report status of the service.
+.TP
+.B start
+Starts the service.
+Three parameters are required: the path to the fstests directory, a path
+where the results will be collected, and the rsync upload target.
+The optional fourth argument is the path to the console output.
+.TP
+.B upload
+Upload the most recent reports to the server.
+.SH AUTHOR
+Oracle
+.SH COPYRIGHT
+Copyright ©2026 Oracle.  License is GPLv2+. <http://www.gnu.org/licenses/gpl-2.0.html>
diff --git a/matrix/reporter/fstests-reporter.in b/matrix/reporter/fstests-reporter.in
new file mode 100755
index 00000000000000..9e2d5ecd60b11a
--- /dev/null
+++ b/matrix/reporter/fstests-reporter.in
@@ -0,0 +1,71 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+# Control the fstmatrix-reporter service
+
+svcdir="%systemd_services_conf_dir%/fstmatrix-reporter.service.d"
+svc_conf="${svcdir}/00-runtime.conf"
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+force_upload() {
+	test -e "${svc_conf}" || return
+
+	local grep_str='^Environment=OUTPUT_DIR='
+	local outdir="$(grep "${grep_str}" "${svc_conf}" | sed -e "s/${grep_str}//g")"
+	rm -f "${outdir}/tarballs/.upload"
+	systemctl restart fstmatrix-reporter.service
+}
+
+case "$1" in
+"start")
+	shift
+
+	test -d "$1" || die "fstests dir doesn't exist."
+	test -n "$2" || die "missing output dir."
+	test -n "$3" || die "missing fstests result base."
+	console_output="${4:-/dev/null}"
+
+	# Configure service
+	mkdir -p "${svcdir}" "$2"
+	cat > "${svc_conf}" << ENDL
+[Service]
+Environment=FSTESTS_DIR=$1
+Environment=OUTPUT_DIR=$2
+Environment=RESULT_BASE=$3
+Environment=CONSOLE_OUTPUT=${console_output}
+ENDL
+
+	systemctl daemon-reload
+
+	# Start the timer
+	systemctl enable fstmatrix-reporter.timer 2> /dev/null
+	systemctl start fstmatrix-reporter.timer
+	;;
+"stop")
+	# Stop the timer
+	systemctl stop fstmatrix-reporter.timer
+	systemctl disable fstmatrix-reporter.timer 2> /dev/null
+
+	# Run once more to report final results
+	force_upload
+	;;
+"status")
+	systemctl "$1" fstmatrix-reporter.timer
+	;;
+"upload")
+	force_upload
+	;;
+"--help")
+	echo "Usage: $0 [start fstests_dir output_dir result_base console_output|stop|status|upload]"
+	exit 1
+	;;
+*)
+	echo "Unknown command \"$1\"."
+	echo "Usage: $0 [start fstests_dir output_dir result_base console_output|stop|status|upload]"
+	exit 1
+	;;
+esac
diff --git a/matrix/reporter/fstmatrix-reporter b/matrix/reporter/fstmatrix-reporter
new file mode 100755
index 00000000000000..a912e00cb7b212
--- /dev/null
+++ b/matrix/reporter/fstmatrix-reporter
@@ -0,0 +1,19 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+# Collect and report fstests results
+# Usage: $0 fstests-dir result-base console-output outdir
+
+scriptdir="$(dirname "$0")"
+
+fstests_dir="$1"
+resultbase="$2"
+console_output="$3"
+outdir="$4"
+
+# Linux 6.19 has a NFS bug where mtime doesn't get updated on write()
+# so we must do it explicitly.
+test -e "${console_output}" && touch "${console_output}"
+
+"${scriptdir}/collect-all-results" "${fstests_dir}" "${resultbase}" "${console_output}" "${outdir}"
+"${scriptdir}/upload-all-results" "${outdir}"
diff --git a/matrix/reporter/fstmatrix-reporter.service.in b/matrix/reporter/fstmatrix-reporter.service.in
new file mode 100644
index 00000000000000..95f39316219017
--- /dev/null
+++ b/matrix/reporter/fstmatrix-reporter.service.in
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2018-2026 Oracle
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=fstests Results Uploader
+DefaultDependencies=no
+
+[Service]
+Type=oneshot
+ExecStart=%pkg_libexec_dir%/fstmatrix-reporter ${FSTESTS_DIR} ${RESULT_BASE} ${CONSOLE_OUTPUT} ${OUTPUT_DIR}
+ExecCondition=%pkg_libexec_dir%/fstmatrix-want-reporter ${RESULT_BASE}
+TimeoutSec=infinity
+
+# Don't let OOM kills of processes in this containment group kill the whole
+# service, since it's directly associated with running fstests.  On those
+# grounds, set the OOM score adjustment to the same as fstests.
+OOMPolicy=continue
+OOMScoreAdjust=-500
diff --git a/matrix/reporter/fstmatrix-reporter.timer b/matrix/reporter/fstmatrix-reporter.timer
new file mode 100644
index 00000000000000..13f7231c849faa
--- /dev/null
+++ b/matrix/reporter/fstmatrix-reporter.timer
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2018-2026 Oracle
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=Periodic fstests Results Uploader
+
+[Timer]
+# Run the uploader 10s after the timer starts, then every 13 minutes
+# after that
+OnActiveSec=10s
+OnUnitActiveSec=13m
+AccuracySec=1s
+Persistent=true
+
+[Install]
+WantedBy=timers.target
diff --git a/matrix/reporter/fstmatrix-want-reporter b/matrix/reporter/fstmatrix-want-reporter
new file mode 100644
index 00000000000000..47635cfa2bf87f
--- /dev/null
+++ b/matrix/reporter/fstmatrix-want-reporter
@@ -0,0 +1,22 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+# Decide if we have fstests results to report
+# Usage: $0 result-base
+
+scriptdir="$(dirname "$0")"
+
+resultbase="$1"
+
+find_args=("${resultbase}/")
+
+files=(result.xml)
+nr=0
+for file in "${files[@]}"; do
+	test "${nr}" -gt 0 && find_args+=('-o')
+	find_args+=('-name' "${file}" '-print')
+	nr=$((nr + 1))
+done
+
+# Do we get any output at all?
+test -n "$(find "${find_args[@]}" 2> /dev/null)"
diff --git a/matrix/reporter/starttime b/matrix/reporter/starttime
new file mode 100644
index 00000000000000..5bc99ec60a0514
--- /dev/null
+++ b/matrix/reporter/starttime
@@ -0,0 +1,36 @@
+#!/usr/bin/python3
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+
+# Extract the start time (or the report time) from the results.xml file
+# Usage: $0 path/to/results.xml
+
+import sys
+import json
+import sqlite3
+import os
+import argparse
+import xml.etree.ElementTree as ET
+
+def main():
+	p = argparse.ArgumentParser(
+			description = 'Extract timestamp from results.xml.')
+	p.add_argument('xmlfile', type = str,
+			help = 'Path to results.xml.')
+	args = p.parse_args()
+
+	# Read the junit xml report.  fstests didn't always assign a namespace
+	# in the xml document, so the xpath selectors must use a wildcard.
+	# AFAICT etree doesn't let us set a default ns if the file doesn't
+	# specify.
+	xml = ET.parse(f'{args.xmlfile}')
+	testsuite = xml.getroot()
+
+	if 'start_timestamp' in testsuite.attrib:
+		print(testsuite.attrib['start_timestamp'])
+	else:
+		print(testsuite.attrib['timestamp'])
+	sys.exit(0)
+
+if __name__ == '__main__':
+	main()
diff --git a/matrix/reporter/upload-all-results.in b/matrix/reporter/upload-all-results.in
new file mode 100755
index 00000000000000..9a97aaeead1fd6
--- /dev/null
+++ b/matrix/reporter/upload-all-results.in
@@ -0,0 +1,52 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+# Upload all the test result info from all runs
+# Usage: $0 output-dir [urls...]
+
+scriptdir="$(dirname "$0")"
+
+outdir="$1"
+shift
+
+REPORTER_URLS=()
+
+test -r "%etc_dir%/fstmatrix-reporter" && . "%etc_dir%/fstmatrix-reporter"
+
+for url in "$@"; do
+	REPORTER_URLS+=("${url}")
+done
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+test -z "${outdir}" && die "no output dir"
+test ! -d "${outdir}/tarballs" && die "no tarballs found"
+test "${#REPORTER_URLS[@]}" -gt 0 || die "no urls configured"
+
+curl=(curl --silent --show-error --request POST --max-time 90 --fail)
+curl+=(--header "Content-Type: application/octet-stream")
+
+cd "${outdir}/tarballs/"
+
+find_tarballs() {
+	local newer=()
+
+	test -e .upload && newer+=(-newer .upload)
+	find . "${newer[@]}" -type f \( -name '*.tar.xz' -print -o \
+					-name '*.tar.gz' -print -o \
+					-name '*.tar.zst' -print \)
+}
+
+while read tarball; do
+	test -s "${tarball}" || continue
+	tb="$(basename "${tarball}")"
+	echo "Uploading ${tb}..."
+	for url in "${REPORTER_URLS[@]}"; do
+		while ! "${curl[@]}" --data-binary "@${tb}" "${url}?fname=${tb}"; do sleep 2; done &
+	done
+	wait
+done < <(find_tarballs)
+touch .upload
diff --git a/matrix/reporter/xunit_failed.awk b/matrix/reporter/xunit_failed.awk
new file mode 100644
index 00000000000000..bce663533ef461
--- /dev/null
+++ b/matrix/reporter/xunit_failed.awk
@@ -0,0 +1,14 @@
+#!/usr/bin/awk
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+# awk script to extract just the failing tests
+
+{
+	if ($1 ~ /<testcase/) {
+		startline = $0;
+	} else if ($1 ~ /<fail/) {
+		printf("%s%s</testcase>\n", startline, $0);
+	} else {
+		;
+	}
+}
diff --git a/matrix/reporter/xunit_rollup.awk b/matrix/reporter/xunit_rollup.awk
new file mode 100644
index 00000000000000..86a2ba38f6d2a3
--- /dev/null
+++ b/matrix/reporter/xunit_rollup.awk
@@ -0,0 +1,22 @@
+#!/usr/bin/awk
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+# awk script to filter the golden output and error messages out of an xunit
+# xml file.
+
+BEGIN {
+	ignore = 0;
+}
+{
+	if ($1 ~ /<system-(out|err)>/) {
+		ignore = 1;
+	} else if ($1 ~ /<\/system-(out|err)>/) {
+		ignore = 0;
+	} else if (ignore) {
+		;
+	} else if ($1 ~ /<properties/) {
+		printf("%s\n\t\t<property name=\"KERNEL\" value=\"%s\"/>\n", $0, kernel);
+	} else {
+		print $0;
+	}
+}

