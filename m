Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26273 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbdAUILI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:11:08 -0500
Subject: [PATCH 7/9] populate: discover XFS structure fields and fuzz verbs,
 and use them to fuzz fields
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:11:04 -0800
Message-ID: <148498626496.17109.10417397686046944573.stgit@birch.djwong.org>
In-Reply-To: <148498621936.17109.4249711513404036449.stgit@birch.djwong.org>
References: <148498621936.17109.4249711513404036449.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Create some routines to help us perform targeted fuzzing of individual
fields in various XFS structures.  Specifically, we want the caller to
drop the xfs_db iocursor on the victim field; from there, the scripts
should discover all available fields and fuzzing verbs, and try each
fuzz verb on every available field.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
--
v2: fix some errors found by Eryu Guan.
v3: allow tests to blacklist certain fields, and allow the user to
force fuzz certain fields using certain fuzz verbs.
---
 common/fuzzy |  264 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 264 insertions(+)


diff --git a/common/fuzzy b/common/fuzzy
index d4f8274..2df7222 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -78,3 +78,267 @@ _scratch_scrub() {
 		;;
 	esac
 }
+
+# Filter the xfs_db print command's field debug information
+# into field name and type.
+__filter_xfs_db_print_fields() {
+	filter="$1"
+	if [ -z "${filter}" ] || [ "${filter}" = "nofilter" ]; then
+		filter='^'
+	fi
+	grep ' = ' | while read key equals value; do
+		# Filter out any keys with an array index >= 10, and
+		# collapse any array range ("[1-195]") to the first item.
+		fuzzkey="$(echo "${key}" | sed -e '/\([a-z]*\)\[\([0-9][0-9]\+\)\].*/d' -e 's/\([a-zA-Z0-9_]*\)\[\([0-9]*\)-[0-9]*\]/\1[\2]/g')"
+		if [ -z "${fuzzkey}" ]; then
+			continue
+		elif [[ "${value}" == "["* ]]; then
+			echo "${value}" | sed -e 's/^.//g' -e 's/.$//g' -e 's/,/\n/g' | while read subfield; do
+				echo "${fuzzkey}.${subfield}"
+			done
+		else
+			echo "${fuzzkey}"
+		fi
+	done | egrep "${filter}"
+}
+
+# Navigate to some part of the filesystem and print the field info.
+# The first argument is an egrep filter for the fields
+# The rest of the arguments are xfs_db commands to locate the metadata.
+_scratch_xfs_list_metadata_fields() {
+	filter="$1"
+	shift
+	if [ -n "${SCRATCH_XFS_LIST_METADATA_FIELDS}" ]; then
+		echo "${SCRATCH_XFS_LIST_METADATA_FIELDS}" | tr '[ ,]' '[\n\n]'
+		return;
+	fi
+
+	local cmds=()
+	for arg in "$@"; do
+		cmds+=("-c" "${arg}")
+	done
+	_scratch_xfs_db "${cmds[@]}" -c print | __filter_xfs_db_print_fields "${filter}"
+}
+
+# Get a metadata field
+# The first arg is the field name
+# The rest of the arguments are xfs_db commands to find the metadata.
+_scratch_xfs_get_metadata_field() {
+	key="$1"
+	shift
+
+	grep_key="$(echo "${key}" | tr '[]()' '....')"
+	local cmds=()
+	for arg in "$@"; do
+		cmds+=("-c" "${arg}")
+	done
+	_scratch_xfs_db "${cmds[@]}" -c "print ${key}" | grep "^${grep_key}" | \
+		sed -e 's/^.* = //g'
+}
+
+# Set a metadata field
+# The first arg is the field name
+# The second arg is the new value
+# The rest of the arguments are xfs_db commands to find the metadata.
+_scratch_xfs_set_metadata_field() {
+	key="$1"
+	value="$2"
+	shift; shift
+
+	local cmds=()
+	for arg in "$@"; do
+		cmds+=("-c" "${arg}")
+	done
+	_scratch_xfs_db -x "${cmds[@]}" -c "write -d ${key} ${value}"
+	echo
+}
+
+# Fuzz a metadata field
+# The first arg is the field name
+# The second arg is the xfs_db fuzz verb
+# The rest of the arguments are xfs_db commands to find the metadata.
+_scratch_xfs_fuzz_metadata_field() {
+	key="$1"
+	value="$2"
+	shift; shift
+
+	if [[ "${key}" == *crc ]]; then
+		fuzz_arg="-c"
+	else
+		fuzz_arg="-d"
+	fi
+	oldval="$(_scratch_xfs_get_metadata_field "${key}" "$@")"
+
+	local cmds=()
+	for arg in "$@"; do
+		cmds+=("-c" "${arg}")
+	done
+	_scratch_xfs_db -x "${cmds[@]}" -c "fuzz ${fuzz_arg} ${key} ${value}"
+	echo
+	newval="$(_scratch_xfs_get_metadata_field "${key}" "$@" 2> /dev/null)"
+	if [ "${oldval}" = "${newval}" ]; then
+		echo "Field ${key} already set to ${newval}, skipping test."
+		return 1
+	fi
+	return 0
+}
+
+# Try to forcibly unmount the scratch fs
+__scratch_xfs_fuzz_unmount()
+{
+	while _scratch_unmount 2>/dev/null; do sleep 0.2; done
+}
+
+# Restore metadata to scratch device prior to field-fuzzing.
+__scratch_xfs_fuzz_mdrestore()
+{
+	test -e "${POPULATE_METADUMP}" || _fail "Need to set POPULATE_METADUMP"
+
+	__scratch_xfs_fuzz_unmount
+	xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}"
+}
+
+__fuzz_notify() {
+	echo "$@"
+	test -w /dev/ttyprintk && echo "$@" >> /dev/ttyprintk
+}
+
+# Fuzz one field of some piece of metadata.
+# First arg is the field name
+# Second arg is the fuzz verb (ones, zeroes, random, add, sub...)
+# Third arg is the repair mode (online, offline, both)
+__scratch_xfs_fuzz_field_test() {
+	field="$1"
+	fuzzverb="$2"
+	repair="$3"
+	shift; shift; shift
+
+	# Set the new field value
+	__fuzz_notify "+ Fuzz ${field} = ${fuzzverb}"
+	echo "========================"
+	_scratch_xfs_fuzz_metadata_field "${field}" ${fuzzverb} "$@"
+	res=$?
+	test $res -ne 0 && return
+
+	# Try to catch the error with scrub
+	echo "+ Try to catch the error"
+	_scratch_mount 2>&1
+	res=$?
+	if [ $res -eq 0 ]; then
+		# Try an online scrub unless we're fuzzing ag 0's sb,
+		# which scrub doesn't know how to fix.
+		echo "++ Online scrub"
+		if [ "$1" != "sb 0" ]; then
+			_scratch_scrub -n -a 1 -e continue 2>&1
+			res=$?
+			test $res -eq 0 && \
+				(>&2 echo "scrub didn't fail with ${field} = ${fuzzverb}.")
+		fi
+
+		# Try fixing the filesystem online?!
+		if [ "${repair}" = "online" ] || [ "${repair}" = "both" ]; then
+			__fuzz_notify "++ Try to repair filesystem online"
+			_scratch_scrub -y 2>&1
+			res=$?
+			test $res -ne 0 && \
+				(>&2 echo "online repair failed ($res) with ${field} = ${fuzzverb}.")
+		fi
+
+		__scratch_xfs_fuzz_unmount
+	elif [ "${repair}" = "online" ] || [ "${repair}" = "both" ]; then
+		(>&2 echo "mount failed ($res) with ${field} = ${fuzzverb}.")
+	fi
+
+	# Repair the filesystem offline?
+	if [ "${repair}" = "offline" ] || [ "${repair}" = "both" ]; then
+		echo "+ Try to repair the filesystem offline"
+		_repair_scratch_fs 2>&1
+		res=$?
+		test $res -ne 0 && \
+			(>&2 echo "offline repair failed ($res) with ${field} = ${fuzzverb}.")
+	fi
+
+	# See if repair finds a clean fs
+	echo "+ Make sure error is gone (offline)"
+        _scratch_xfs_repair -n 2>&1
+	res=$?
+	test $res -ne 0 && \
+		(>&2 echo "offline re-scrub ($res) with ${field} = ${fuzzverb}.")
+
+	# See if scrub finds a clean fs
+	echo "+ Make sure error is gone (online)"
+	_scratch_mount 2>&1
+	res=$?
+	if [ $res -eq 0 ]; then
+		# Try an online scrub unless we're fuzzing ag 0's sb,
+		# which scrub doesn't know how to fix.
+		echo "++ Online scrub"
+		if [ "$1" != "sb 0" ]; then
+			_scratch_scrub -e continue 2>&1
+			res=$?
+			test $res -ne 0 && \
+				(>&2 echo "online re-scrub ($res) with ${field} = ${fuzzverb}.")
+		fi
+
+		# Try modifying the filesystem again!
+		__fuzz_notify "++ Try to write filesystem again"
+		_scratch_fuzz_modify 100 2>&1
+		__scratch_xfs_fuzz_unmount
+	else
+		(>&2 echo "re-mount failed ($res) with ${field} = ${fuzzverb}.")
+	fi
+
+	# See if repair finds a clean fs
+	echo "+ Re-check the filesystem (offline)"
+	_scratch_xfs_repair -n 2>&1
+	res=$?
+	test $res -ne 0 && \
+		(>&2 echo "re-repair failed ($res) with ${field} = ${fuzzverb}.")
+}
+
+# Make sure we have all the pieces we need for field fuzzing
+_require_scratch_xfs_fuzz_fields()
+{
+	_require_scratch_nocheck
+	_require_scrub
+	_require_populate_commands
+	_scratch_mkfs_xfs >/dev/null 2>&1
+	_require_xfs_db_command "fuzz"
+}
+
+# Grab the list of available fuzzing verbs
+_scratch_xfs_list_fuzz_verbs() {
+	if [ -n "${SCRATCH_XFS_LIST_FUZZ_VERBS}" ]; then
+		echo "${SCRATCH_XFS_LIST_FUZZ_VERBS}" | tr '[ ,]' '[\n\n]'
+		return;
+	fi
+	_scratch_xfs_db -x -c 'sb 0' -c 'fuzz' | grep '^Verbs:' | \
+		sed -e 's/[,.]//g' -e 's/Verbs: //g' -e 's/ /\n/g'
+}
+
+# Fuzz some of the fields of some piece of metadata
+# The first argument is an egrep filter for the field names
+# The second argument is the repair mode (online, offline, both)
+# The rest of the arguments are xfs_db commands to locate the metadata.
+#
+# Users can specify the fuzz verbs via SCRATCH_XFS_LIST_FUZZ_VERBS
+# They can specify the fields via SCRATCH_XFS_LIST_METADATA_FIELDS
+_scratch_xfs_fuzz_metadata() {
+	filter="$1"
+	repair="$2"
+	shift; shift
+
+	fields="$(_scratch_xfs_list_metadata_fields "${filter}" "$@")"
+	verbs="$(_scratch_xfs_list_fuzz_verbs)"
+	echo "Fields we propose to fuzz under: $@"
+	echo $(echo "${fields}")
+	echo "Verbs we propose to fuzz with:"
+	echo $(echo "${verbs}")
+
+	echo "${fields}" | while read field; do
+		echo "${verbs}" | while read fuzzverb; do
+			__scratch_xfs_fuzz_mdrestore
+			__scratch_xfs_fuzz_field_test "${field}" "${fuzzverb}" "${repair}" "$@"
+		done
+	done
+}

