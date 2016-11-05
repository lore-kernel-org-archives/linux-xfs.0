Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17353 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbcKEASA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:18:00 -0400
Subject: [PATCH 7/9] populate: discover XFS structure fields and fuzz verbs,
 and use them to fuzz fields
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:17:54 -0700
Message-ID: <147830507411.1919.17534443838350465519.stgit@birch.djwong.org>
In-Reply-To: <147830503054.1919.4998804611100937975.stgit@birch.djwong.org>
References: <147830503054.1919.4998804611100937975.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Create some routines to help us perform targeted fuzzing of individual
fields in various XFS structures.  Specifically, we want the caller to
drop the xfs_db iocursor on the victim field; from there, the scripts
should discover all available fields and fuzzing verbs, and try each
fuzz verb on every available field.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/fuzzy |  191 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 191 insertions(+)


diff --git a/common/fuzzy b/common/fuzzy
index 20f1d29..6af47f1 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -81,3 +81,194 @@ _scratch_scrub() {
 		;;
 	esac
 }
+
+# Filter the xfs_db print command's field debug information
+# into field name and type.
+__filter_xfs_db_print_fields() {
+	grep ' = ' | while read key equals value; do
+		fuzzkey="$(echo "${key}" | sed -e 's/\([a-zA-Z0-9_]*\)\[\([0-9]*\)-[0-9]*\]/\1[\2]/g')"
+		if [[ "${value}" == "["* ]]; then
+			echo "${value}" | sed -e 's/^.//g' -e 's/.$//g' -e 's/,/\n/g' | while read subfield; do
+				echo "${fuzzkey}.${subfield}"
+			done
+		else
+			echo "${fuzzkey}"
+		fi
+	done
+}
+
+# Navigate to some part of the filesystem and print the field info.
+_scratch_xfs_list_metadata_fields() {
+	if [ -n "${SCRATCH_XFS_LIST_METADATA_FIELDS}" ]; then
+		echo "${SCRATCH_XFS_LIST_METADATA_FIELDS}" | sed -e 's/ /\n/g'
+		return;
+	fi
+
+	(for arg in "$@"; do
+		echo "${arg}"
+	done
+	echo "print") | _scratch_xfs_db | __filter_xfs_db_print_fields
+}
+
+# Get a metadata field
+_scratch_xfs_get_metadata_field() {
+	key="$1"
+	shift
+
+	grep_key="$(echo "${key}" | tr '[]()' '....')"
+	(for arg in "$@"; do
+		echo "${arg}"
+	done
+	echo "print ${key}") | _scratch_xfs_db | grep "^${grep_key}" | \
+		sed -e 's/^.* = //g'
+}
+
+# Set a metadata field
+_scratch_xfs_set_metadata_field() {
+	key="$1"
+	value="$2"
+	shift; shift
+	(for arg in "$@"; do
+		echo "${arg}"
+	done
+	echo "write -d ${key} ${value}") | _scratch_xfs_db -x
+	echo
+}
+
+# Fuzz a metadata field
+_scratch_xfs_fuzz_metadata_field() {
+	key="$1"
+	value="$2"
+	shift; shift
+
+	if [ "${key}" = "crc" ]; then
+		fuzz_arg="-c"
+	else
+		fuzz_arg="-d"
+	fi
+	oldval="$(_scratch_xfs_get_metadata_field "${key}" "$@")"
+	(for arg in "$@"; do
+		echo "${arg}"
+	done
+	echo "fuzz ${fuzz_arg} ${key} ${value}") | _scratch_xfs_db -x
+	echo
+	newval="$(_scratch_xfs_get_metadata_field "${key}" "$@" 2> /dev/null)"
+	if [ "${oldval}" = "${newval}" ]; then
+		echo "Field ${key} already set to ${oldval}, skipping test."
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
+# Fuzz one field of some piece of metadata
+__scratch_xfs_fuzz_field_test() {
+	field="$1"
+	fuzzverb="$2"
+	shift; shift
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
+		_scratch_scrub -a 1 -e continue 2>&1
+		res=$?
+		test $res -eq 0 && \
+			(>&2 echo "scrub didn't fail with ${field} = ${fuzzverb}.")
+
+		# Try modifying the filesystem!
+		__fuzz_notify "++ Try to write filesystem"
+		#_scratch_fuzz_modify 100 2>&1
+		__scratch_xfs_fuzz_unmount
+	fi
+
+	# Repair the filesystem
+	echo "+ Fix the error"
+	_repair_scratch_fs 2>&1
+	res=$?
+	test $res -ne 0 && \
+		(>&2 echo "repair failed ($res) with ${field} = ${fuzzverb}.")
+
+	# See if scrub finds a clean fs
+	echo "+ Make sure error is gone"
+	_scratch_mount 2>&1
+	res=$?
+	if [ $res -eq 0 ]; then
+		_scratch_scrub -e continue 2>&1
+		res=$?
+		test $res -ne 0 && \
+			(>&2 echo "re-scrub ($res) with ${field} = ${fuzzverb}.")
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
+	_scratch_xfs_repair -n 2>&1
+	res=$?
+	test $res -ne 0 && \
+		(>&2 echo "re-repair failed ($res) with ${field} = ${fuzzverb}.")
+}
+
+# Make sure we have all the pieces we need for field fuzzing
+_require_scratch_xfs_fuzz_fields()
+{
+	_require_scratch
+	_require_scrub
+	_require_populate_commands
+	_require_command "$XFS_DB_PROG" "xfs_db"
+	_scratch_mkfs_xfs >/dev/null 2>&1
+	_scratch_xfs_db -x -c 'fuzz' 2>&1 | grep -q 'not found' && \
+		_notrun "xfs_db does not have fuzz command"
+}
+
+# Grab the list of available fuzzing verbs
+_scratch_xfs_list_fuzz_verbs() {
+	if [ -n "${SCRATCH_XFS_LIST_FUZZ_VERBS}" ]; then
+		echo "${SCRATCH_XFS_LIST_FUZZ_VERBS}" | sed -e 's/ /\n/g'
+		return;
+	fi
+	_scratch_xfs_db -x -c 'sb 0' -c 'fuzz' | grep '^Verbs:' | \
+		sed -e 's/[,.]//g' -e 's/Verbs: //g' -e 's/ /\n/g'
+}
+
+# Fuzz the fields of some piece of metadata
+_scratch_xfs_fuzz_fields() {
+	_scratch_xfs_list_metadata_fields "$@" | while read field; do
+		_scratch_xfs_list_fuzz_verbs | while read fuzzverb; do
+			__scratch_xfs_fuzz_mdrestore
+			__scratch_xfs_fuzz_field_test "${field}" "${fuzzverb}" "$@"
+		done
+	done
+}

