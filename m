Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29618 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752018AbcLGATh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2016 19:19:37 -0500
Subject: [PATCH 11/11] xfs: fuzz every field of every structure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Dec 2016 16:19:20 -0800
Message-ID: <148106996091.19334.7694949797004978768.stgit@birch.djwong.org>
In-Reply-To: <148106989109.19334.6839386416313318071.stgit@birch.djwong.org>
References: <148106989109.19334.6839386416313318071.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Previously, our XFS fuzzing efforts were limited to using the xfs_db
blocktrash command to scribble garbage all over a block.  This is
pretty easy to discover; it would be far more interesting if we could
fuzz individual fields looking for unhandled corner cases.  Since we
now have an online scrub tool, use it to check for our targeted
corruptions prior to the usual steps of writing to the FS, taking it
offline, repairing, and re-checking.

These tests use the new xfs_db 'fuzz' command to test corner case
handling of every field.  The 'print' command tells us which fields
are available, and the fuzz command can write zeroes or ones to the
field; set the high, middle, or low bit; add or subtract numbers; or
randomize the field.  We loop through all fields and all fuzz verbs to
see if we can trip up the kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/fuzzy        |   96 ++++++++++++++++++++++++++++++++++++++++-----------
 common/populate     |   10 +++--
 tests/ext4/1300     |   60 ++++++++++++++++++++++++++++++++
 tests/ext4/1300.out |    3 ++
 tests/ext4/group    |    1 +
 tests/xfs/1300      |   63 +++++++++++++++++++++++++++++++++
 tests/xfs/1300.out  |    3 ++
 tests/xfs/1301      |   60 ++++++++++++++++++++++++++++++++
 tests/xfs/1301.out  |    4 ++
 tests/xfs/1302      |   60 ++++++++++++++++++++++++++++++++
 tests/xfs/1302.out  |    4 ++
 tests/xfs/1303      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1303.out  |    6 +++
 tests/xfs/1304      |   60 ++++++++++++++++++++++++++++++++
 tests/xfs/1304.out  |    4 ++
 tests/xfs/1305      |   60 ++++++++++++++++++++++++++++++++
 tests/xfs/1305.out  |    4 ++
 tests/xfs/1306      |   60 ++++++++++++++++++++++++++++++++
 tests/xfs/1306.out  |    4 ++
 tests/xfs/1307      |   60 ++++++++++++++++++++++++++++++++
 tests/xfs/1307.out  |    4 ++
 tests/xfs/1308      |   60 ++++++++++++++++++++++++++++++++
 tests/xfs/1308.out  |    4 ++
 tests/xfs/1309      |   61 ++++++++++++++++++++++++++++++++
 tests/xfs/1309.out  |    4 ++
 tests/xfs/1310      |   61 ++++++++++++++++++++++++++++++++
 tests/xfs/1310.out  |    4 ++
 tests/xfs/1311      |   62 +++++++++++++++++++++++++++++++++
 tests/xfs/1311.out  |    4 ++
 tests/xfs/1312      |   62 +++++++++++++++++++++++++++++++++
 tests/xfs/1312.out  |    4 ++
 tests/xfs/1313      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1313.out  |    5 +++
 tests/xfs/1314      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1314.out  |    5 +++
 tests/xfs/1315      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1315.out  |    5 +++
 tests/xfs/1316      |   67 ++++++++++++++++++++++++++++++++++++
 tests/xfs/1316.out  |    5 +++
 tests/xfs/1317      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1317.out  |    5 +++
 tests/xfs/1318      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1318.out  |    5 +++
 tests/xfs/1319      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1319.out  |    5 +++
 tests/xfs/1320      |   66 +++++++++++++++++++++++++++++++++++
 tests/xfs/1320.out  |    5 +++
 tests/xfs/1321      |   67 ++++++++++++++++++++++++++++++++++++
 tests/xfs/1321.out  |    5 +++
 tests/xfs/1322      |   67 ++++++++++++++++++++++++++++++++++++
 tests/xfs/1322.out  |    5 +++
 tests/xfs/1323      |   67 ++++++++++++++++++++++++++++++++++++
 tests/xfs/1323.out  |    5 +++
 tests/xfs/1324      |   67 ++++++++++++++++++++++++++++++++++++
 tests/xfs/1324.out  |    5 +++
 tests/xfs/1325      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1325.out  |    5 +++
 tests/xfs/1326      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1326.out  |    5 +++
 tests/xfs/1327      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1327.out  |    5 +++
 tests/xfs/1328      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1328.out  |    5 +++
 tests/xfs/1329      |   64 ++++++++++++++++++++++++++++++++++
 tests/xfs/1329.out  |    4 ++
 tests/xfs/1330      |   62 +++++++++++++++++++++++++++++++++
 tests/xfs/1330.out  |    4 ++
 tests/xfs/1331      |   62 +++++++++++++++++++++++++++++++++
 tests/xfs/1331.out  |    4 ++
 tests/xfs/1332      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1332.out  |    5 +++
 tests/xfs/1333      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1333.out  |    5 +++
 tests/xfs/1334      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1334.out  |    5 +++
 tests/xfs/1341      |   60 ++++++++++++++++++++++++++++++++
 tests/xfs/1341.out  |    4 ++
 tests/xfs/1342      |   60 ++++++++++++++++++++++++++++++++
 tests/xfs/1342.out  |    4 ++
 tests/xfs/1343      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1343.out  |    6 +++
 tests/xfs/1344      |   60 ++++++++++++++++++++++++++++++++
 tests/xfs/1344.out  |    4 ++
 tests/xfs/1345      |   60 ++++++++++++++++++++++++++++++++
 tests/xfs/1345.out  |    4 ++
 tests/xfs/1346      |   60 ++++++++++++++++++++++++++++++++
 tests/xfs/1346.out  |    4 ++
 tests/xfs/1347      |   60 ++++++++++++++++++++++++++++++++
 tests/xfs/1347.out  |    4 ++
 tests/xfs/1348      |   60 ++++++++++++++++++++++++++++++++
 tests/xfs/1348.out  |    4 ++
 tests/xfs/1349      |   61 ++++++++++++++++++++++++++++++++
 tests/xfs/1349.out  |    4 ++
 tests/xfs/1350      |   61 ++++++++++++++++++++++++++++++++
 tests/xfs/1350.out  |    4 ++
 tests/xfs/1351      |   62 +++++++++++++++++++++++++++++++++
 tests/xfs/1351.out  |    4 ++
 tests/xfs/1352      |   62 +++++++++++++++++++++++++++++++++
 tests/xfs/1352.out  |    4 ++
 tests/xfs/1353      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1353.out  |    5 +++
 tests/xfs/1354      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1354.out  |    5 +++
 tests/xfs/1355      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1355.out  |    5 +++
 tests/xfs/1356      |   67 ++++++++++++++++++++++++++++++++++++
 tests/xfs/1356.out  |    5 +++
 tests/xfs/1357      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1357.out  |    5 +++
 tests/xfs/1358      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1358.out  |    5 +++
 tests/xfs/1359      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1359.out  |    5 +++
 tests/xfs/1360      |   66 +++++++++++++++++++++++++++++++++++
 tests/xfs/1360.out  |    5 +++
 tests/xfs/1361      |   67 ++++++++++++++++++++++++++++++++++++
 tests/xfs/1361.out  |    5 +++
 tests/xfs/1362      |   67 ++++++++++++++++++++++++++++++++++++
 tests/xfs/1362.out  |    5 +++
 tests/xfs/1363      |   67 ++++++++++++++++++++++++++++++++++++
 tests/xfs/1363.out  |    5 +++
 tests/xfs/1364      |   67 ++++++++++++++++++++++++++++++++++++
 tests/xfs/1364.out  |    5 +++
 tests/xfs/1365      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1365.out  |    5 +++
 tests/xfs/1366      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1366.out  |    5 +++
 tests/xfs/1367      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1367.out  |    5 +++
 tests/xfs/1368      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1368.out  |    5 +++
 tests/xfs/1369      |   64 ++++++++++++++++++++++++++++++++++
 tests/xfs/1369.out  |    4 ++
 tests/xfs/1370      |   62 +++++++++++++++++++++++++++++++++
 tests/xfs/1370.out  |    4 ++
 tests/xfs/1371      |   62 +++++++++++++++++++++++++++++++++
 tests/xfs/1371.out  |    4 ++
 tests/xfs/1372      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1372.out  |    5 +++
 tests/xfs/1373      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1373.out  |    5 +++
 tests/xfs/1374      |   65 +++++++++++++++++++++++++++++++++++
 tests/xfs/1374.out  |    5 +++
 tests/xfs/group     |   69 +++++++++++++++++++++++++++++++++++++
 144 files changed, 4923 insertions(+), 26 deletions(-)
 create mode 100755 tests/ext4/1300
 create mode 100644 tests/ext4/1300.out
 create mode 100755 tests/xfs/1300
 create mode 100644 tests/xfs/1300.out
 create mode 100755 tests/xfs/1301
 create mode 100644 tests/xfs/1301.out
 create mode 100755 tests/xfs/1302
 create mode 100644 tests/xfs/1302.out
 create mode 100755 tests/xfs/1303
 create mode 100644 tests/xfs/1303.out
 create mode 100755 tests/xfs/1304
 create mode 100644 tests/xfs/1304.out
 create mode 100755 tests/xfs/1305
 create mode 100644 tests/xfs/1305.out
 create mode 100755 tests/xfs/1306
 create mode 100644 tests/xfs/1306.out
 create mode 100755 tests/xfs/1307
 create mode 100644 tests/xfs/1307.out
 create mode 100755 tests/xfs/1308
 create mode 100644 tests/xfs/1308.out
 create mode 100755 tests/xfs/1309
 create mode 100644 tests/xfs/1309.out
 create mode 100755 tests/xfs/1310
 create mode 100644 tests/xfs/1310.out
 create mode 100755 tests/xfs/1311
 create mode 100644 tests/xfs/1311.out
 create mode 100755 tests/xfs/1312
 create mode 100644 tests/xfs/1312.out
 create mode 100755 tests/xfs/1313
 create mode 100644 tests/xfs/1313.out
 create mode 100755 tests/xfs/1314
 create mode 100644 tests/xfs/1314.out
 create mode 100755 tests/xfs/1315
 create mode 100644 tests/xfs/1315.out
 create mode 100755 tests/xfs/1316
 create mode 100644 tests/xfs/1316.out
 create mode 100755 tests/xfs/1317
 create mode 100644 tests/xfs/1317.out
 create mode 100755 tests/xfs/1318
 create mode 100644 tests/xfs/1318.out
 create mode 100755 tests/xfs/1319
 create mode 100644 tests/xfs/1319.out
 create mode 100755 tests/xfs/1320
 create mode 100644 tests/xfs/1320.out
 create mode 100755 tests/xfs/1321
 create mode 100644 tests/xfs/1321.out
 create mode 100755 tests/xfs/1322
 create mode 100644 tests/xfs/1322.out
 create mode 100755 tests/xfs/1323
 create mode 100644 tests/xfs/1323.out
 create mode 100755 tests/xfs/1324
 create mode 100644 tests/xfs/1324.out
 create mode 100755 tests/xfs/1325
 create mode 100644 tests/xfs/1325.out
 create mode 100755 tests/xfs/1326
 create mode 100644 tests/xfs/1326.out
 create mode 100755 tests/xfs/1327
 create mode 100644 tests/xfs/1327.out
 create mode 100755 tests/xfs/1328
 create mode 100644 tests/xfs/1328.out
 create mode 100755 tests/xfs/1329
 create mode 100644 tests/xfs/1329.out
 create mode 100755 tests/xfs/1330
 create mode 100644 tests/xfs/1330.out
 create mode 100755 tests/xfs/1331
 create mode 100644 tests/xfs/1331.out
 create mode 100755 tests/xfs/1332
 create mode 100644 tests/xfs/1332.out
 create mode 100755 tests/xfs/1333
 create mode 100644 tests/xfs/1333.out
 create mode 100755 tests/xfs/1334
 create mode 100644 tests/xfs/1334.out
 create mode 100644 tests/xfs/1341
 create mode 100644 tests/xfs/1341.out
 create mode 100644 tests/xfs/1342
 create mode 100644 tests/xfs/1342.out
 create mode 100644 tests/xfs/1343
 create mode 100644 tests/xfs/1343.out
 create mode 100644 tests/xfs/1344
 create mode 100644 tests/xfs/1344.out
 create mode 100644 tests/xfs/1345
 create mode 100644 tests/xfs/1345.out
 create mode 100644 tests/xfs/1346
 create mode 100644 tests/xfs/1346.out
 create mode 100644 tests/xfs/1347
 create mode 100644 tests/xfs/1347.out
 create mode 100644 tests/xfs/1348
 create mode 100644 tests/xfs/1348.out
 create mode 100644 tests/xfs/1349
 create mode 100644 tests/xfs/1349.out
 create mode 100644 tests/xfs/1350
 create mode 100644 tests/xfs/1350.out
 create mode 100644 tests/xfs/1351
 create mode 100644 tests/xfs/1351.out
 create mode 100644 tests/xfs/1352
 create mode 100644 tests/xfs/1352.out
 create mode 100644 tests/xfs/1353
 create mode 100644 tests/xfs/1353.out
 create mode 100644 tests/xfs/1354
 create mode 100644 tests/xfs/1354.out
 create mode 100644 tests/xfs/1355
 create mode 100644 tests/xfs/1355.out
 create mode 100644 tests/xfs/1356
 create mode 100644 tests/xfs/1356.out
 create mode 100644 tests/xfs/1357
 create mode 100644 tests/xfs/1357.out
 create mode 100644 tests/xfs/1358
 create mode 100644 tests/xfs/1358.out
 create mode 100644 tests/xfs/1359
 create mode 100644 tests/xfs/1359.out
 create mode 100644 tests/xfs/1360
 create mode 100644 tests/xfs/1360.out
 create mode 100644 tests/xfs/1361
 create mode 100644 tests/xfs/1361.out
 create mode 100644 tests/xfs/1362
 create mode 100644 tests/xfs/1362.out
 create mode 100644 tests/xfs/1363
 create mode 100644 tests/xfs/1363.out
 create mode 100644 tests/xfs/1364
 create mode 100644 tests/xfs/1364.out
 create mode 100644 tests/xfs/1365
 create mode 100644 tests/xfs/1365.out
 create mode 100644 tests/xfs/1366
 create mode 100644 tests/xfs/1366.out
 create mode 100644 tests/xfs/1367
 create mode 100644 tests/xfs/1367.out
 create mode 100644 tests/xfs/1368
 create mode 100644 tests/xfs/1368.out
 create mode 100644 tests/xfs/1369
 create mode 100644 tests/xfs/1369.out
 create mode 100644 tests/xfs/1370
 create mode 100644 tests/xfs/1370.out
 create mode 100644 tests/xfs/1371
 create mode 100644 tests/xfs/1371.out
 create mode 100755 tests/xfs/1372
 create mode 100755 tests/xfs/1372.out
 create mode 100755 tests/xfs/1373
 create mode 100755 tests/xfs/1373.out
 create mode 100755 tests/xfs/1374
 create mode 100755 tests/xfs/1374.out


diff --git a/common/fuzzy b/common/fuzzy
index 046a198..2e525dd 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -85,20 +85,32 @@ _scratch_scrub() {
 # Filter the xfs_db print command's field debug information
 # into field name and type.
 __filter_xfs_db_print_fields() {
+	filter="$1"
+	if [ -z "${filter}" ] || [ "${filter}" = "nofilter" ]; then
+		filter='^'
+	fi
 	grep ' = ' | while read key equals value; do
-		fuzzkey="$(echo "${key}" | sed -e 's/\([a-zA-Z0-9_]*\)\[\([0-9]*\)-[0-9]*\]/\1[\2]/g')"
-		if [[ "${value}" == "["* ]]; then
+		# Filter out any keys with an array index >= 10, and
+		# collapse any array range ("[1-195]") to the first item.
+		fuzzkey="$(echo "${key}" | sed -e '/\([a-z]*\)\[\([0-9][0-9]\+\)\].*/d' -e 's/\([a-zA-Z0-9_]*\)\[\([0-9]*\)-[0-9]*\]/\1[\2]/g')"
+		if [ -z "${fuzzkey}" ]; then
+			continue
+		elif [[ "${value}" == "["* ]]; then
 			echo "${value}" | sed -e 's/^.//g' -e 's/.$//g' -e 's/,/\n/g' | while read subfield; do
 				echo "${fuzzkey}.${subfield}"
 			done
 		else
 			echo "${fuzzkey}"
 		fi
-	done
+	done | egrep "${filter}"
 }
 
 # Navigate to some part of the filesystem and print the field info.
+# The first argument is an egrep filter for the fields
+# The rest of the arguments are xfs_db commands to locate the metadata.
 _scratch_xfs_list_metadata_fields() {
+	filter="$1"
+	shift
 	if [ -n "${SCRATCH_XFS_LIST_METADATA_FIELDS}" ]; then
 		echo "${SCRATCH_XFS_LIST_METADATA_FIELDS}" | sed -e 's/ /\n/g'
 		return;
@@ -107,10 +119,12 @@ _scratch_xfs_list_metadata_fields() {
 	(for arg in "$@"; do
 		echo "${arg}"
 	done
-	echo "print") | _scratch_xfs_db | __filter_xfs_db_print_fields
+	echo "print") | _scratch_xfs_db | __filter_xfs_db_print_fields "${filter}"
 }
 
 # Get a metadata field
+# The first arg is the field name
+# The rest of the arguments are xfs_db commands to find the metadata.
 _scratch_xfs_get_metadata_field() {
 	key="$1"
 	shift
@@ -124,6 +138,9 @@ _scratch_xfs_get_metadata_field() {
 }
 
 # Set a metadata field
+# The first arg is the field name
+# The second arg is the new value
+# The rest of the arguments are xfs_db commands to find the metadata.
 _scratch_xfs_set_metadata_field() {
 	key="$1"
 	value="$2"
@@ -136,6 +153,9 @@ _scratch_xfs_set_metadata_field() {
 }
 
 # Fuzz a metadata field
+# The first arg is the field name
+# The second arg is the xfs_db fuzz verb
+# The rest of the arguments are xfs_db commands to find the metadata.
 _scratch_xfs_fuzz_metadata_field() {
 	key="$1"
 	value="$2"
@@ -163,7 +183,7 @@ _scratch_xfs_fuzz_metadata_field() {
 # Try to forcibly unmount the scratch fs
 __scratch_xfs_fuzz_unmount()
 {
-	while ! _scratch_unmount 2>/dev/null; do sleep 0.2; done
+	while _scratch_unmount 2>/dev/null; do sleep 0.2; done
 }
 
 # Restore metadata to scratch device prior to field-fuzzing.
@@ -180,11 +200,15 @@ __fuzz_notify() {
 	test -w /dev/ttyprintk && echo "$@" >> /dev/ttyprintk
 }
 
-# Fuzz one field of some piece of metadata
+# Fuzz one field of some piece of metadata.
+# First arg is the field name
+# Second arg is the fuzz verb (ones, zeroes, random, add, sub...)
+# Third arg is the repair mode (online, offline, both)
 __scratch_xfs_fuzz_field_test() {
 	field="$1"
 	fuzzverb="$2"
-	shift; shift
+	repair="$3"
+	shift; shift; shift
 
 	# Set the new field value
 	__fuzz_notify "+ Fuzz ${field} = ${fuzzverb}"
@@ -198,33 +222,51 @@ __scratch_xfs_fuzz_field_test() {
 	_scratch_mount 2>&1
 	res=$?
 	if [ $res -eq 0 ]; then
-		_scratch_scrub -a 1 -e continue 2>&1
+		echo "++ Online scrub"
+		_scratch_scrub -n -a 1 -e continue 2>&1
 		res=$?
 		test $res -eq 0 && \
 			(>&2 echo "scrub didn't fail with ${field} = ${fuzzverb}.")
 
-		# Try modifying the filesystem!
-		__fuzz_notify "++ Try to write filesystem"
-		#_scratch_fuzz_modify 100 2>&1
+		# Try fixing the filesystem online?!
+		if [ "${repair}" = "online" ] || [ "${repair}" = "both" ]; then
+			__fuzz_notify "++ Try to repair filesystem online"
+			_scratch_scrub -y 2>&1
+			res=$?
+			test $res -ne 0 && \
+				(>&2 echo "online repair failed ($res) with ${field} = ${fuzzverb}.")
+		fi
+
 		__scratch_xfs_fuzz_unmount
+	elif [ "${repair}" = "online" ] || [ "${repair}" = "both" ]; then
+		(>&2 echo "mount failed ($res) with ${field} = ${fuzzverb}.")
 	fi
 
-	# Repair the filesystem
-	echo "+ Fix the error"
-	_repair_scratch_fs 2>&1
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
 	res=$?
 	test $res -ne 0 && \
-		(>&2 echo "repair failed ($res) with ${field} = ${fuzzverb}.")
+		(>&2 echo "offline re-scrub ($res) with ${field} = ${fuzzverb}.")
 
 	# See if scrub finds a clean fs
-	echo "+ Make sure error is gone"
+	echo "+ Make sure error is gone (online)"
 	_scratch_mount 2>&1
 	res=$?
 	if [ $res -eq 0 ]; then
 		_scratch_scrub -e continue 2>&1
 		res=$?
 		test $res -ne 0 && \
-			(>&2 echo "re-scrub ($res) with ${field} = ${fuzzverb}.")
+			(>&2 echo "online re-scrub ($res) with ${field} = ${fuzzverb}.")
 
 		# Try modifying the filesystem again!
 		__fuzz_notify "++ Try to write filesystem again"
@@ -235,6 +277,7 @@ __scratch_xfs_fuzz_field_test() {
 	fi
 
 	# See if repair finds a clean fs
+	echo "+ Re-check the filesystem (offline)"
 	_scratch_xfs_repair -n 2>&1
 	res=$?
 	test $res -ne 0 && \
@@ -261,12 +304,23 @@ _scratch_xfs_list_fuzz_verbs() {
 		sed -e 's/[,.]//g' -e 's/Verbs: //g' -e 's/ /\n/g'
 }
 
-# Fuzz the fields of some piece of metadata
-_scratch_xfs_fuzz_fields() {
-	_scratch_xfs_list_metadata_fields "$@" | while read field; do
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
+	echo "Fields we propose to fuzz under: $@"
+	_scratch_xfs_list_metadata_fields "${filter}" "$@"
+	_scratch_xfs_list_metadata_fields "${filter}" "$@" | while read field; do
 		_scratch_xfs_list_fuzz_verbs | while read fuzzverb; do
 			__scratch_xfs_fuzz_mdrestore
-			__scratch_xfs_fuzz_field_test "${field}" "${fuzzverb}" "$@"
+			__scratch_xfs_fuzz_field_test "${field}" "${fuzzverb}" "${repair}" "$@"
 		done
 	done
 }
diff --git a/common/populate b/common/populate
index f0a9f68..7eb177d 100644
--- a/common/populate
+++ b/common/populate
@@ -201,13 +201,13 @@ _scratch_xfs_populate() {
 	# FMT_EXTENTS with a remote less-than-a-block value
 	echo "+ attr extents with a remote less-than-a-block value"
 	touch "${SCRATCH_MNT}/ATTR.FMT_EXTENTS_REMOTE3K"
-	$XFS_IO_PROG -f -c "pwrite -S 0x43 0 3k" "${SCRATCH_MNT}/attrvalfile" > /dev/null
+	$XFS_IO_PROG -f -c "pwrite -S 0x43 0 $((blksz - 300))" "${SCRATCH_MNT}/attrvalfile" > /dev/null
 	attr -q -s user.remotebtreeattrname "${SCRATCH_MNT}/ATTR.FMT_EXTENTS_REMOTE3K" < "${SCRATCH_MNT}/attrvalfile"
 
 	# FMT_EXTENTS with a remote block-size value
 	echo "+ attr extents with a remote one-block value"
 	touch "${SCRATCH_MNT}/ATTR.FMT_EXTENTS_REMOTE4K"
-	$XFS_IO_PROG -f -c "pwrite -S 0x44 0 4k" "${SCRATCH_MNT}/attrvalfile" > /dev/null
+	$XFS_IO_PROG -f -c "pwrite -S 0x44 0 ${blksz}" "${SCRATCH_MNT}/attrvalfile" > /dev/null
 	attr -q -s user.remotebtreeattrname "${SCRATCH_MNT}/ATTR.FMT_EXTENTS_REMOTE4K" < "${SCRATCH_MNT}/attrvalfile"
 	rm -rf "${SCRATCH_MNT}/attrvalfile"
 
@@ -518,8 +518,8 @@ _scratch_xfs_populate_check() {
 	__populate_check_xfs_aformat "${btree_attr}" "btree"
 	__populate_check_xfs_agbtree_height "bno"
 	__populate_check_xfs_agbtree_height "cnt"
-	test -n $is_rmapbt && __populate_check_xfs_agbtree_height "rmap"
-	test -n $is_reflink && __populate_check_xfs_agbtree_height "refcnt"
+	test $is_rmapbt -ne 0 && __populate_check_xfs_agbtree_height "rmap"
+	test $is_reflink -ne 0 && __populate_check_xfs_agbtree_height "refcnt"
 }
 
 # Check data fork format of ext4 file
@@ -645,7 +645,7 @@ _scratch_populate_cached() {
 	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
 
 	# Throw away cached image if it doesn't match our spec.
-	meta_descr="FSTYP ${FSTYP} MKFS_OPTIONS ${MKFS_OPTIONS} ARGS $@"
+	meta_descr="FSTYP ${FSTYP} MKFS_OPTIONS $(_scratch_mkfs_options) ARGS $@"
 	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || rm -rf "${POPULATE_METADUMP}"
 
 	# Do we have a cached image?
diff --git a/tests/ext4/1300 b/tests/ext4/1300
new file mode 100755
index 0000000..3f8135e
--- /dev/null
+++ b/tests/ext4/1300
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 1300
+#
+# Populate a ext4 filesystem and ensure that scrub and repair are happy.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs ext4
+_require_scratch
+_require_scrub
+
+echo "Format and populate"
+_scratch_populate_cached > $seqres.full 2>&1
+
+echo "Scrub"
+_scratch_mount >> $seqres.full 2>&1
+_scratch_scrub >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/1300.out b/tests/ext4/1300.out
new file mode 100644
index 0000000..8aaa3bb
--- /dev/null
+++ b/tests/ext4/1300.out
@@ -0,0 +1,3 @@
+QA output created by 1300
+Format and populate
+Scrub
diff --git a/tests/ext4/group b/tests/ext4/group
index 8e4aad2..bb5654f 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -36,3 +36,4 @@
 308 auto ioctl rw prealloc quick
 400 auto quick
 401 auto quick
+1300 auto quick scrub
diff --git a/tests/xfs/1300 b/tests/xfs/1300
new file mode 100755
index 0000000..e190124
--- /dev/null
+++ b/tests/xfs/1300
@@ -0,0 +1,63 @@
+#! /bin/bash
+# FS QA Test No. 1300
+#
+# Populate a XFS filesystem and ensure that scrub and repair are happy.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+
+_require_scratch
+_require_scrub
+_require_populate_commands
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Scrub"
+_scratch_mount >> $seqres.full 2>&1
+_scratch_scrub >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1300.out b/tests/xfs/1300.out
new file mode 100644
index 0000000..8aaa3bb
--- /dev/null
+++ b/tests/xfs/1300.out
@@ -0,0 +1,3 @@
+QA output created by 1300
+Format and populate
+Scrub
diff --git a/tests/xfs/1301 b/tests/xfs/1301
new file mode 100755
index 0000000..6210c02
--- /dev/null
+++ b/tests/xfs/1301
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 1301
+#
+# Populate a XFS filesystem and fuzz every superblock field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz superblock"
+_scratch_xfs_fuzz_metadata '' 'offline' 'sb 0' >> $seqres.full
+echo "Done fuzzing superblock"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1301.out b/tests/xfs/1301.out
new file mode 100644
index 0000000..f804acc
--- /dev/null
+++ b/tests/xfs/1301.out
@@ -0,0 +1,4 @@
+QA output created by 1301
+Format and populate
+Fuzz superblock
+Done fuzzing superblock
diff --git a/tests/xfs/1302 b/tests/xfs/1302
new file mode 100755
index 0000000..b07479e
--- /dev/null
+++ b/tests/xfs/1302
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 1302
+#
+# Populate a XFS filesystem and fuzz every AGF field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1302  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz AGF"
+_scratch_xfs_fuzz_metadata '' 'offline' 'agf 0' >> $seqres.full
+echo "Done fuzzing AGF"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1302.out b/tests/xfs/1302.out
new file mode 100644
index 0000000..1e416d5
--- /dev/null
+++ b/tests/xfs/1302.out
@@ -0,0 +1,4 @@
+QA output created by 1302
+Format and populate
+Fuzz AGF
+Done fuzzing AGF
diff --git a/tests/xfs/1303 b/tests/xfs/1303
new file mode 100755
index 0000000..c98304f
--- /dev/null
+++ b/tests/xfs/1303
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1303
+#
+# Populate a XFS filesystem and fuzz every AGFL field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz AGFL"
+_scratch_xfs_fuzz_metadata '' 'offline' 'agfl 0' >> $seqres.full
+echo "Done fuzzing AGFL"
+
+echo "Fuzz AGFL flfirst"
+flfirst=$(_scratch_xfs_db -c 'agf 0' -c 'p flfirst' | sed -e 's/flfirst = //g')
+SCRATCH_XFS_LIST_METADATA_FIELDS="bno[${flfirst}]" _scratch_xfs_fuzz_metadata '' 'offline' 'agfl 0' >> $seqres.full
+echo "Done fuzzing AGFL flfirst"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1303.out b/tests/xfs/1303.out
new file mode 100644
index 0000000..d8afaf4
--- /dev/null
+++ b/tests/xfs/1303.out
@@ -0,0 +1,6 @@
+QA output created by 1303
+Format and populate
+Fuzz AGFL
+Done fuzzing AGFL
+Fuzz AGFL flfirst
+Done fuzzing AGFL flfirst
diff --git a/tests/xfs/1304 b/tests/xfs/1304
new file mode 100755
index 0000000..d0ca677
--- /dev/null
+++ b/tests/xfs/1304
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 1304
+#
+# Populate a XFS filesystem and fuzz every AGI field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz AGI"
+_scratch_xfs_fuzz_metadata '' 'offline' 'agi 0' >> $seqres.full
+echo "Done fuzzing AGI"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1304.out b/tests/xfs/1304.out
new file mode 100644
index 0000000..886157b
--- /dev/null
+++ b/tests/xfs/1304.out
@@ -0,0 +1,4 @@
+QA output created by 1304
+Format and populate
+Fuzz AGI
+Done fuzzing AGI
diff --git a/tests/xfs/1305 b/tests/xfs/1305
new file mode 100755
index 0000000..fd608b1
--- /dev/null
+++ b/tests/xfs/1305
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 1305
+#
+# Populate a XFS filesystem and fuzz every bnobt field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz bnobt recs"
+_scratch_xfs_fuzz_metadata '' 'offline'  'agf 0' 'addr bnoroot' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing bnobt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1305.out b/tests/xfs/1305.out
new file mode 100644
index 0000000..b2108f1
--- /dev/null
+++ b/tests/xfs/1305.out
@@ -0,0 +1,4 @@
+QA output created by 1305
+Format and populate
+Fuzz bnobt recs
+Done fuzzing bnobt recs
diff --git a/tests/xfs/1306 b/tests/xfs/1306
new file mode 100755
index 0000000..fbfff12
--- /dev/null
+++ b/tests/xfs/1306
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 1306
+#
+# Populate a XFS filesystem and fuzz every bnobt key/pointer.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz bnobt keyptr"
+_scratch_xfs_fuzz_metadata '' 'offline'  'agf 0' 'addr bnoroot' >> $seqres.full
+echo "Done fuzzing bnobt keyptr"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1306.out b/tests/xfs/1306.out
new file mode 100644
index 0000000..4b1e0c6
--- /dev/null
+++ b/tests/xfs/1306.out
@@ -0,0 +1,4 @@
+QA output created by 1306
+Format and populate
+Fuzz bnobt keyptr
+Done fuzzing bnobt keyptr
diff --git a/tests/xfs/1307 b/tests/xfs/1307
new file mode 100755
index 0000000..54a114d
--- /dev/null
+++ b/tests/xfs/1307
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 1307
+#
+# Populate a XFS filesystem and fuzz every cntbt field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz cntbt"
+_scratch_xfs_fuzz_metadata '' 'offline'  'agf 0' 'addr cntroot' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing cntbt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1307.out b/tests/xfs/1307.out
new file mode 100644
index 0000000..a7cedf1
--- /dev/null
+++ b/tests/xfs/1307.out
@@ -0,0 +1,4 @@
+QA output created by 1307
+Format and populate
+Fuzz cntbt
+Done fuzzing cntbt
diff --git a/tests/xfs/1308 b/tests/xfs/1308
new file mode 100755
index 0000000..847f739
--- /dev/null
+++ b/tests/xfs/1308
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 1308
+#
+# Populate a XFS filesystem and fuzz every inobt field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz inobt"
+_scratch_xfs_fuzz_metadata '' 'offline'  'agi 0' 'addr root' >> $seqres.full
+echo "Done fuzzing inobt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1308.out b/tests/xfs/1308.out
new file mode 100644
index 0000000..cc72bb7
--- /dev/null
+++ b/tests/xfs/1308.out
@@ -0,0 +1,4 @@
+QA output created by 1308
+Format and populate
+Fuzz inobt
+Done fuzzing inobt
diff --git a/tests/xfs/1309 b/tests/xfs/1309
new file mode 100755
index 0000000..d3925c0
--- /dev/null
+++ b/tests/xfs/1309
@@ -0,0 +1,61 @@
+#! /bin/bash
+# FS QA Test No. 1309
+#
+# Populate a XFS filesystem and fuzz every finobt field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_finobt
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz finobt"
+_scratch_xfs_fuzz_metadata '' 'offline'  'agi 0' 'addr free_root' >> $seqres.full
+echo "Done fuzzing finobt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1309.out b/tests/xfs/1309.out
new file mode 100644
index 0000000..b4084ef
--- /dev/null
+++ b/tests/xfs/1309.out
@@ -0,0 +1,4 @@
+QA output created by 1309
+Format and populate
+Fuzz finobt
+Done fuzzing finobt
diff --git a/tests/xfs/1310 b/tests/xfs/1310
new file mode 100755
index 0000000..d4dfda1
--- /dev/null
+++ b/tests/xfs/1310
@@ -0,0 +1,61 @@
+#! /bin/bash
+# FS QA Test No. 1310
+#
+# Populate a XFS filesystem and fuzz every rmapbt field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rmapbt recs"
+_scratch_xfs_fuzz_metadata '' 'offline' 'agf 0' 'addr rmaproot' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing rmapbt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1310.out b/tests/xfs/1310.out
new file mode 100644
index 0000000..e784f8b
--- /dev/null
+++ b/tests/xfs/1310.out
@@ -0,0 +1,4 @@
+QA output created by 1310
+Format and populate
+Fuzz rmapbt recs
+Done fuzzing rmapbt recs
diff --git a/tests/xfs/1311 b/tests/xfs/1311
new file mode 100755
index 0000000..009be50
--- /dev/null
+++ b/tests/xfs/1311
@@ -0,0 +1,62 @@
+#! /bin/bash
+# FS QA Test No. 1311
+#
+# Populate a XFS filesystem and fuzz every rmapbt key/pointer field.
+# Use xfs_repair to fix the corruption.
+# Use xfs_repair to repair the problems.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rmapbt keyptr"
+_scratch_xfs_fuzz_metadata '' 'offline' 'agf 0' 'addr rmaproot' >> $seqres.full
+echo "Done fuzzing rmapbt keyptr"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1311.out b/tests/xfs/1311.out
new file mode 100644
index 0000000..70150a1
--- /dev/null
+++ b/tests/xfs/1311.out
@@ -0,0 +1,4 @@
+QA output created by 1311
+Format and populate
+Fuzz rmapbt keyptr
+Done fuzzing rmapbt keyptr
diff --git a/tests/xfs/1312 b/tests/xfs/1312
new file mode 100755
index 0000000..ea2215f
--- /dev/null
+++ b/tests/xfs/1312
@@ -0,0 +1,62 @@
+#! /bin/bash
+# FS QA Test No. 1312
+#
+# Populate a XFS filesystem and fuzz every refcountbt field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz refcountbt"
+_scratch_xfs_fuzz_metadata '' 'offline'  'agf 0' 'addr refcntroot' >> $seqres.full
+echo "Done fuzzing refcountbt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1312.out b/tests/xfs/1312.out
new file mode 100644
index 0000000..ca40b46
--- /dev/null
+++ b/tests/xfs/1312.out
@@ -0,0 +1,4 @@
+QA output created by 1312
+Format and populate
+Fuzz refcountbt
+Done fuzzing refcountbt
diff --git a/tests/xfs/1313 b/tests/xfs/1313
new file mode 100755
index 0000000..b492d4e
--- /dev/null
+++ b/tests/xfs/1313
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1313
+#
+# Populate a XFS filesystem and fuzz every btree-format directory inode field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find btree-format dir inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_BTREE)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1313.out b/tests/xfs/1313.out
new file mode 100644
index 0000000..b087a06
--- /dev/null
+++ b/tests/xfs/1313.out
@@ -0,0 +1,5 @@
+QA output created by 1313
+Format and populate
+Find btree-format dir inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1314 b/tests/xfs/1314
new file mode 100755
index 0000000..5a45baf
--- /dev/null
+++ b/tests/xfs/1314
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1314
+#
+# Populate a XFS filesystem and fuzz every extents-format file inode field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find extents-format file inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFREG.FMT_EXTENTS)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1314.out b/tests/xfs/1314.out
new file mode 100644
index 0000000..c5c1a3a
--- /dev/null
+++ b/tests/xfs/1314.out
@@ -0,0 +1,5 @@
+QA output created by 1314
+Format and populate
+Find extents-format file inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1315 b/tests/xfs/1315
new file mode 100755
index 0000000..6f8e05a
--- /dev/null
+++ b/tests/xfs/1315
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1315
+#
+# Populate a XFS filesystem and fuzz every btree-format file inode field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find btree-format file inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFREG.FMT_BTREE)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1315.out b/tests/xfs/1315.out
new file mode 100644
index 0000000..421b645
--- /dev/null
+++ b/tests/xfs/1315.out
@@ -0,0 +1,5 @@
+QA output created by 1315
+Format and populate
+Find btree-format file inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1316 b/tests/xfs/1316
new file mode 100755
index 0000000..785ce0e
--- /dev/null
+++ b/tests/xfs/1316
@@ -0,0 +1,67 @@
+#! /bin/bash
+# FS QA Test No. 1316
+#
+# Populate a XFS filesystem and fuzz every bmbt block field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find bmbt block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFREG.FMT_BTREE)
+_scratch_unmount
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "inode ${inum}")
+
+echo "Fuzz bmbt"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" "addr u${inode_ver}.bmbt.ptrs[1]" >> $seqres.full
+echo "Done fuzzing bmbt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1316.out b/tests/xfs/1316.out
new file mode 100644
index 0000000..1ae75f6
--- /dev/null
+++ b/tests/xfs/1316.out
@@ -0,0 +1,5 @@
+QA output created by 1316
+Format and populate
+Find bmbt block
+Fuzz bmbt
+Done fuzzing bmbt
diff --git a/tests/xfs/1317 b/tests/xfs/1317
new file mode 100755
index 0000000..ec3e0da
--- /dev/null
+++ b/tests/xfs/1317
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1317
+#
+# Populate a XFS filesystem and fuzz every symlink remote block field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find symlink remote block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFLNK.FMT_EXTENTS)
+_scratch_unmount
+
+echo "Fuzz symlink remote block"
+_scratch_xfs_fuzz_metadata '' 'offline' "inode ${inum}" 'dblock 0' >> $seqres.full
+echo "Done fuzzing symlink remote block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1317.out b/tests/xfs/1317.out
new file mode 100644
index 0000000..92affb2
--- /dev/null
+++ b/tests/xfs/1317.out
@@ -0,0 +1,5 @@
+QA output created by 1317
+Format and populate
+Find symlink remote block
+Fuzz symlink remote block
+Done fuzzing symlink remote block
diff --git a/tests/xfs/1318 b/tests/xfs/1318
new file mode 100755
index 0000000..e3feefa
--- /dev/null
+++ b/tests/xfs/1318
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1318
+#
+# Populate a XFS filesystem and fuzz every inline directory inode field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find inline-format dir inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_INLINE)
+_scratch_unmount
+
+echo "Fuzz inline-format dir inode"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inline-format dir inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1318.out b/tests/xfs/1318.out
new file mode 100644
index 0000000..c12e336
--- /dev/null
+++ b/tests/xfs/1318.out
@@ -0,0 +1,5 @@
+QA output created by 1318
+Format and populate
+Find inline-format dir inode
+Fuzz inline-format dir inode
+Done fuzzing inline-format dir inode
diff --git a/tests/xfs/1319 b/tests/xfs/1319
new file mode 100755
index 0000000..18fdac7
--- /dev/null
+++ b/tests/xfs/1319
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1319
+#
+# Populate a XFS filesystem and fuzz every block-format dir block field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find data-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_BLOCK)
+_scratch_unmount
+
+echo "Fuzz data-format dir block"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" 'dblock 0' >> $seqres.full
+echo "Done fuzzing data-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1319.out b/tests/xfs/1319.out
new file mode 100644
index 0000000..72ab82a
--- /dev/null
+++ b/tests/xfs/1319.out
@@ -0,0 +1,5 @@
+QA output created by 1319
+Format and populate
+Find data-format dir block
+Fuzz data-format dir block
+Done fuzzing data-format dir block
diff --git a/tests/xfs/1320 b/tests/xfs/1320
new file mode 100755
index 0000000..858a2a8
--- /dev/null
+++ b/tests/xfs/1320
@@ -0,0 +1,66 @@
+#! /bin/bash
+# FS QA Test No. 1320
+#
+# Populate a XFS filesystem and fuzz every data-format dir block field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find data-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_LEAF)
+blk_sz=$(get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+echo "Fuzz data-format dir block"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" "dblock 0" >> $seqres.full
+echo "Done fuzzing data-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1320.out b/tests/xfs/1320.out
new file mode 100644
index 0000000..409a25b
--- /dev/null
+++ b/tests/xfs/1320.out
@@ -0,0 +1,5 @@
+QA output created by 1320
+Format and populate
+Find data-format dir block
+Fuzz data-format dir block
+Done fuzzing data-format dir block
diff --git a/tests/xfs/1321 b/tests/xfs/1321
new file mode 100755
index 0000000..69821f9
--- /dev/null
+++ b/tests/xfs/1321
@@ -0,0 +1,67 @@
+#! /bin/bash
+# FS QA Test No. 1321
+#
+# Populate a XFS filesystem and fuzz every leaf1-format dir block field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find leaf1-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_LEAF)
+blk_sz=$(get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( (2 ** 35) / blk_sz))
+echo "Fuzz leaf1-format dir block"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing leaf1-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1321.out b/tests/xfs/1321.out
new file mode 100644
index 0000000..ef3fa37
--- /dev/null
+++ b/tests/xfs/1321.out
@@ -0,0 +1,5 @@
+QA output created by 1321
+Format and populate
+Find leaf1-format dir block
+Fuzz leaf1-format dir block
+Done fuzzing leaf1-format dir block
diff --git a/tests/xfs/1322 b/tests/xfs/1322
new file mode 100755
index 0000000..dc3166b
--- /dev/null
+++ b/tests/xfs/1322
@@ -0,0 +1,67 @@
+#! /bin/bash
+# FS QA Test No. 1322
+#
+# Populate a XFS filesystem and fuzz every leafn-format dir block field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find leafn-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_NODE)
+blk_sz=$(get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( ( (2 ** 35) / blk_sz) + 1))
+echo "Fuzz leafn-format dir block"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing leafn-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1322.out b/tests/xfs/1322.out
new file mode 100644
index 0000000..d1e0c7d
--- /dev/null
+++ b/tests/xfs/1322.out
@@ -0,0 +1,5 @@
+QA output created by 1322
+Format and populate
+Find leafn-format dir block
+Fuzz leafn-format dir block
+Done fuzzing leafn-format dir block
diff --git a/tests/xfs/1323 b/tests/xfs/1323
new file mode 100755
index 0000000..0185bf8
--- /dev/null
+++ b/tests/xfs/1323
@@ -0,0 +1,67 @@
+#! /bin/bash
+# FS QA Test No. 1323
+#
+# Populate a XFS filesystem and fuzz every node-format dir block field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find node-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_NODE)
+blk_sz=$(get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( (2 ** 35) / blk_sz ))
+echo "Fuzz node-format dir block"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing node-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1323.out b/tests/xfs/1323.out
new file mode 100644
index 0000000..2debc5c
--- /dev/null
+++ b/tests/xfs/1323.out
@@ -0,0 +1,5 @@
+QA output created by 1323
+Format and populate
+Find node-format dir block
+Fuzz node-format dir block
+Done fuzzing node-format dir block
diff --git a/tests/xfs/1324 b/tests/xfs/1324
new file mode 100755
index 0000000..33e2603
--- /dev/null
+++ b/tests/xfs/1324
@@ -0,0 +1,67 @@
+#! /bin/bash
+# FS QA Test No. 1324
+#
+# Populate a XFS filesystem and fuzz every freeindex-format dir block field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find freeindex-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_NODE)
+blk_sz=$(get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( (2 ** 36) / blk_sz ))
+echo "Fuzz freeindex-format dir block"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing freeindex-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1324.out b/tests/xfs/1324.out
new file mode 100644
index 0000000..1e373e0
--- /dev/null
+++ b/tests/xfs/1324.out
@@ -0,0 +1,5 @@
+QA output created by 1324
+Format and populate
+Find freeindex-format dir block
+Fuzz freeindex-format dir block
+Done fuzzing freeindex-format dir block
diff --git a/tests/xfs/1325 b/tests/xfs/1325
new file mode 100755
index 0000000..eb4ee77
--- /dev/null
+++ b/tests/xfs/1325
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1325
+#
+# Populate a XFS filesystem and fuzz every inline attr inode field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find inline-format attr inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_LOCAL)
+_scratch_unmount
+
+echo "Fuzz inline-format attr inode"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inline-format attr inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1325.out b/tests/xfs/1325.out
new file mode 100644
index 0000000..5259fe8
--- /dev/null
+++ b/tests/xfs/1325.out
@@ -0,0 +1,5 @@
+QA output created by 1325
+Format and populate
+Find inline-format attr inode
+Fuzz inline-format attr inode
+Done fuzzing inline-format attr inode
diff --git a/tests/xfs/1326 b/tests/xfs/1326
new file mode 100755
index 0000000..669e3dd
--- /dev/null
+++ b/tests/xfs/1326
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1326
+#
+# Populate a XFS filesystem and fuzz every leaf-format attr block field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find leaf-format attr block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_LEAF)
+_scratch_unmount
+
+echo "Fuzz leaf-format attr block"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" 'ablock 0' >> $seqres.full
+echo "Done fuzzing leaf-format attr block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1326.out b/tests/xfs/1326.out
new file mode 100644
index 0000000..d10cdb7
--- /dev/null
+++ b/tests/xfs/1326.out
@@ -0,0 +1,5 @@
+QA output created by 1326
+Format and populate
+Find leaf-format attr block
+Fuzz leaf-format attr block
+Done fuzzing leaf-format attr block
diff --git a/tests/xfs/1327 b/tests/xfs/1327
new file mode 100755
index 0000000..c0caae8
--- /dev/null
+++ b/tests/xfs/1327
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1327
+#
+# Populate a XFS filesystem and fuzz every node-format attr block field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find node-format attr block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_NODE)
+_scratch_unmount
+
+echo "Fuzz node-format attr block"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" "ablock 0" >> $seqres.full
+echo "Done fuzzing node-format attr block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1327.out b/tests/xfs/1327.out
new file mode 100644
index 0000000..b3a4f1d
--- /dev/null
+++ b/tests/xfs/1327.out
@@ -0,0 +1,5 @@
+QA output created by 1327
+Format and populate
+Find node-format attr block
+Fuzz node-format attr block
+Done fuzzing node-format attr block
diff --git a/tests/xfs/1328 b/tests/xfs/1328
new file mode 100755
index 0000000..66574ce
--- /dev/null
+++ b/tests/xfs/1328
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1328
+#
+# Populate a XFS filesystem and fuzz every external attr block field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find external attr block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_EXTENTS_REMOTE3K)
+_scratch_unmount
+
+echo "Fuzz external attr block"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" "ablock 1" >> $seqres.full
+echo "Done fuzzing external attr block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1328.out b/tests/xfs/1328.out
new file mode 100644
index 0000000..758f322
--- /dev/null
+++ b/tests/xfs/1328.out
@@ -0,0 +1,5 @@
+QA output created by 1328
+Format and populate
+Find external attr block
+Fuzz external attr block
+Done fuzzing external attr block
diff --git a/tests/xfs/1329 b/tests/xfs/1329
new file mode 100755
index 0000000..fc3b096
--- /dev/null
+++ b/tests/xfs/1329
@@ -0,0 +1,64 @@
+#! /bin/bash
+# FS QA Test No. 1329
+#
+# Populate a XFS filesystem and fuzz every rtrmapbt record field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'sb 0' 'addr rrmapino')
+
+echo "Fuzz rtrmapbt recs"
+_scratch_xfs_fuzz_metadata '' 'offline' 'sb 0' 'addr rrmapino' "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
+echo "Done fuzzing rtrmapbt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1329.out b/tests/xfs/1329.out
new file mode 100644
index 0000000..d9d8b89
--- /dev/null
+++ b/tests/xfs/1329.out
@@ -0,0 +1,4 @@
+QA output created by 1329
+Format and populate
+Fuzz rtrmapbt recs
+Done fuzzing rtrmapbt recs
diff --git a/tests/xfs/1330 b/tests/xfs/1330
new file mode 100755
index 0000000..da82556
--- /dev/null
+++ b/tests/xfs/1330
@@ -0,0 +1,62 @@
+#! /bin/bash
+# FS QA Test No. 1330
+#
+# Populate a XFS filesystem and fuzz every rtrmapbt keyptr field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rtrmapbt keyptrs"
+_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'offline' 'sb 0' 'addr rrmapino' >> $seqres.full
+echo "Done fuzzing rtrmapbt keyptrs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1330.out b/tests/xfs/1330.out
new file mode 100644
index 0000000..ce16b43
--- /dev/null
+++ b/tests/xfs/1330.out
@@ -0,0 +1,4 @@
+QA output created by 1330
+Format and populate
+Fuzz rtrmapbt keyptrs
+Done fuzzing rtrmapbt keyptrs
diff --git a/tests/xfs/1331 b/tests/xfs/1331
new file mode 100755
index 0000000..1d80d64
--- /dev/null
+++ b/tests/xfs/1331
@@ -0,0 +1,62 @@
+#! /bin/bash
+# FS QA Test No. 1331
+#
+# Populate a XFS filesystem and fuzz every refcountbt field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz refcountbt"
+_scratch_xfs_fuzz_metadata '' 'offline'  'agf 0' 'addr refcntroot' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing refcountbt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1331.out b/tests/xfs/1331.out
new file mode 100644
index 0000000..8dbbf16
--- /dev/null
+++ b/tests/xfs/1331.out
@@ -0,0 +1,4 @@
+QA output created by 1331
+Format and populate
+Fuzz refcountbt
+Done fuzzing refcountbt
diff --git a/tests/xfs/1332 b/tests/xfs/1332
new file mode 100755
index 0000000..793761c
--- /dev/null
+++ b/tests/xfs/1332
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1332
+#
+# Populate a XFS filesystem and fuzz every btree-format attr inode field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find btree-format attr inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_BTREE)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1332.out b/tests/xfs/1332.out
new file mode 100644
index 0000000..34feb40
--- /dev/null
+++ b/tests/xfs/1332.out
@@ -0,0 +1,5 @@
+QA output created by 1332
+Format and populate
+Find btree-format attr inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1333 b/tests/xfs/1333
new file mode 100755
index 0000000..a263bcc
--- /dev/null
+++ b/tests/xfs/1333
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1333
+#
+# Populate a XFS filesystem and fuzz every blockdev inode field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find blockdev inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFBLK)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1333.out b/tests/xfs/1333.out
new file mode 100644
index 0000000..168dd52
--- /dev/null
+++ b/tests/xfs/1333.out
@@ -0,0 +1,5 @@
+QA output created by 1333
+Format and populate
+Find blockdev inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1334 b/tests/xfs/1334
new file mode 100755
index 0000000..57aa138
--- /dev/null
+++ b/tests/xfs/1334
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1334
+#
+# Populate a XFS filesystem and fuzz every local-format symlink inode field.
+# Use xfs_repair to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find local-format symlink inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFLNK.FMT_LOCAL)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1334.out b/tests/xfs/1334.out
new file mode 100644
index 0000000..c5512e0
--- /dev/null
+++ b/tests/xfs/1334.out
@@ -0,0 +1,5 @@
+QA output created by 1334
+Format and populate
+Find local-format symlink inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1341 b/tests/xfs/1341
new file mode 100644
index 0000000..cc3c5e3
--- /dev/null
+++ b/tests/xfs/1341
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 1341
+#
+# Populate a XFS filesystem and fuzz every superblock field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz superblock"
+_scratch_xfs_fuzz_metadata '' 'online' 'sb 1' >> $seqres.full
+echo "Done fuzzing superblock"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1341.out b/tests/xfs/1341.out
new file mode 100644
index 0000000..e1fb358
--- /dev/null
+++ b/tests/xfs/1341.out
@@ -0,0 +1,4 @@
+QA output created by 1341
+Format and populate
+Fuzz superblock
+Done fuzzing superblock
diff --git a/tests/xfs/1342 b/tests/xfs/1342
new file mode 100644
index 0000000..0038de8
--- /dev/null
+++ b/tests/xfs/1342
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 1342
+#
+# Populate a XFS filesystem and fuzz every AGF field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1302  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz AGF"
+_scratch_xfs_fuzz_metadata '' 'online' 'agf 0' >> $seqres.full
+echo "Done fuzzing AGF"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1342.out b/tests/xfs/1342.out
new file mode 100644
index 0000000..216cad2
--- /dev/null
+++ b/tests/xfs/1342.out
@@ -0,0 +1,4 @@
+QA output created by 1342
+Format and populate
+Fuzz AGF
+Done fuzzing AGF
diff --git a/tests/xfs/1343 b/tests/xfs/1343
new file mode 100644
index 0000000..e2bb737
--- /dev/null
+++ b/tests/xfs/1343
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1343
+#
+# Populate a XFS filesystem and fuzz every AGFL field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz AGFL"
+_scratch_xfs_fuzz_metadata '' 'online' 'agfl 0' >> $seqres.full
+echo "Done fuzzing AGFL"
+
+echo "Fuzz AGFL flfirst"
+flfirst=$(_scratch_xfs_db -c 'agf 0' -c 'p flfirst' | sed -e 's/flfirst = //g')
+SCRATCH_XFS_LIST_METADATA_FIELDS="bno[${flfirst}]" _scratch_xfs_fuzz_metadata '' 'online' 'agfl 0' >> $seqres.full
+echo "Done fuzzing AGFL flfirst"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1343.out b/tests/xfs/1343.out
new file mode 100644
index 0000000..444ec17
--- /dev/null
+++ b/tests/xfs/1343.out
@@ -0,0 +1,6 @@
+QA output created by 1343
+Format and populate
+Fuzz AGFL
+Done fuzzing AGFL
+Fuzz AGFL flfirst
+Done fuzzing AGFL flfirst
diff --git a/tests/xfs/1344 b/tests/xfs/1344
new file mode 100644
index 0000000..e3fa2a7
--- /dev/null
+++ b/tests/xfs/1344
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 1344
+#
+# Populate a XFS filesystem and fuzz every AGI field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz AGI"
+_scratch_xfs_fuzz_metadata '' 'online' 'agi 0' >> $seqres.full
+echo "Done fuzzing AGI"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1344.out b/tests/xfs/1344.out
new file mode 100644
index 0000000..f70956e
--- /dev/null
+++ b/tests/xfs/1344.out
@@ -0,0 +1,4 @@
+QA output created by 1344
+Format and populate
+Fuzz AGI
+Done fuzzing AGI
diff --git a/tests/xfs/1345 b/tests/xfs/1345
new file mode 100644
index 0000000..cdbdccd
--- /dev/null
+++ b/tests/xfs/1345
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 1345
+#
+# Populate a XFS filesystem and fuzz every bnobt field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz bnobt recs"
+_scratch_xfs_fuzz_metadata '' 'online'  'agf 0' 'addr bnoroot' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing bnobt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1345.out b/tests/xfs/1345.out
new file mode 100644
index 0000000..c3b878c
--- /dev/null
+++ b/tests/xfs/1345.out
@@ -0,0 +1,4 @@
+QA output created by 1345
+Format and populate
+Fuzz bnobt recs
+Done fuzzing bnobt recs
diff --git a/tests/xfs/1346 b/tests/xfs/1346
new file mode 100644
index 0000000..7dda9d0
--- /dev/null
+++ b/tests/xfs/1346
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 1346
+#
+# Populate a XFS filesystem and fuzz every bnobt key/pointer.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz bnobt keyptr"
+_scratch_xfs_fuzz_metadata '' 'online'  'agf 0' 'addr bnoroot' >> $seqres.full
+echo "Done fuzzing bnobt keyptr"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1346.out b/tests/xfs/1346.out
new file mode 100644
index 0000000..9b96ddf
--- /dev/null
+++ b/tests/xfs/1346.out
@@ -0,0 +1,4 @@
+QA output created by 1346
+Format and populate
+Fuzz bnobt keyptr
+Done fuzzing bnobt keyptr
diff --git a/tests/xfs/1347 b/tests/xfs/1347
new file mode 100644
index 0000000..2fca8ec
--- /dev/null
+++ b/tests/xfs/1347
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 1347
+#
+# Populate a XFS filesystem and fuzz every cntbt field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz cntbt"
+_scratch_xfs_fuzz_metadata '' 'online'  'agf 0' 'addr cntroot' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing cntbt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1347.out b/tests/xfs/1347.out
new file mode 100644
index 0000000..5033fa6
--- /dev/null
+++ b/tests/xfs/1347.out
@@ -0,0 +1,4 @@
+QA output created by 1347
+Format and populate
+Fuzz cntbt
+Done fuzzing cntbt
diff --git a/tests/xfs/1348 b/tests/xfs/1348
new file mode 100644
index 0000000..0502806
--- /dev/null
+++ b/tests/xfs/1348
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 1348
+#
+# Populate a XFS filesystem and fuzz every inobt field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz inobt"
+_scratch_xfs_fuzz_metadata '' 'online'  'agi 0' 'addr root' >> $seqres.full
+echo "Done fuzzing inobt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1348.out b/tests/xfs/1348.out
new file mode 100644
index 0000000..20ad257
--- /dev/null
+++ b/tests/xfs/1348.out
@@ -0,0 +1,4 @@
+QA output created by 1348
+Format and populate
+Fuzz inobt
+Done fuzzing inobt
diff --git a/tests/xfs/1349 b/tests/xfs/1349
new file mode 100644
index 0000000..bd9a051
--- /dev/null
+++ b/tests/xfs/1349
@@ -0,0 +1,61 @@
+#! /bin/bash
+# FS QA Test No. 1349
+#
+# Populate a XFS filesystem and fuzz every finobt field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_finobt
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz finobt"
+_scratch_xfs_fuzz_metadata '' 'online'  'agi 0' 'addr free_root' >> $seqres.full
+echo "Done fuzzing finobt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1349.out b/tests/xfs/1349.out
new file mode 100644
index 0000000..addb6b4
--- /dev/null
+++ b/tests/xfs/1349.out
@@ -0,0 +1,4 @@
+QA output created by 1349
+Format and populate
+Fuzz finobt
+Done fuzzing finobt
diff --git a/tests/xfs/1350 b/tests/xfs/1350
new file mode 100644
index 0000000..75c1372
--- /dev/null
+++ b/tests/xfs/1350
@@ -0,0 +1,61 @@
+#! /bin/bash
+# FS QA Test No. 1350
+#
+# Populate a XFS filesystem and fuzz every rmapbt field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rmapbt recs"
+_scratch_xfs_fuzz_metadata '' 'online' 'agf 0' 'addr rmaproot' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing rmapbt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1350.out b/tests/xfs/1350.out
new file mode 100644
index 0000000..fc636fe
--- /dev/null
+++ b/tests/xfs/1350.out
@@ -0,0 +1,4 @@
+QA output created by 1350
+Format and populate
+Fuzz rmapbt recs
+Done fuzzing rmapbt recs
diff --git a/tests/xfs/1351 b/tests/xfs/1351
new file mode 100644
index 0000000..4733aa7
--- /dev/null
+++ b/tests/xfs/1351
@@ -0,0 +1,62 @@
+#! /bin/bash
+# FS QA Test No. 1351
+#
+# Populate a XFS filesystem and fuzz every rmapbt key/pointer field.
+# Use xfs_scrub to fix the corruption.
+# Use xfs_scrub to repair the problems.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rmapbt keyptr"
+_scratch_xfs_fuzz_metadata '' 'online' 'agf 0' 'addr rmaproot' >> $seqres.full
+echo "Done fuzzing rmapbt keyptr"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1351.out b/tests/xfs/1351.out
new file mode 100644
index 0000000..034c31c
--- /dev/null
+++ b/tests/xfs/1351.out
@@ -0,0 +1,4 @@
+QA output created by 1351
+Format and populate
+Fuzz rmapbt keyptr
+Done fuzzing rmapbt keyptr
diff --git a/tests/xfs/1352 b/tests/xfs/1352
new file mode 100644
index 0000000..e05fb8c
--- /dev/null
+++ b/tests/xfs/1352
@@ -0,0 +1,62 @@
+#! /bin/bash
+# FS QA Test No. 1352
+#
+# Populate a XFS filesystem and fuzz every refcountbt field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz refcountbt"
+_scratch_xfs_fuzz_metadata '' 'online'  'agf 0' 'addr refcntroot' >> $seqres.full
+echo "Done fuzzing refcountbt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1352.out b/tests/xfs/1352.out
new file mode 100644
index 0000000..def6d29
--- /dev/null
+++ b/tests/xfs/1352.out
@@ -0,0 +1,4 @@
+QA output created by 1352
+Format and populate
+Fuzz refcountbt
+Done fuzzing refcountbt
diff --git a/tests/xfs/1353 b/tests/xfs/1353
new file mode 100644
index 0000000..f9aaaaa
--- /dev/null
+++ b/tests/xfs/1353
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1353
+#
+# Populate a XFS filesystem and fuzz every btree-format directory inode field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find btree-format dir inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_BTREE)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1353.out b/tests/xfs/1353.out
new file mode 100644
index 0000000..3780bd0
--- /dev/null
+++ b/tests/xfs/1353.out
@@ -0,0 +1,5 @@
+QA output created by 1353
+Format and populate
+Find btree-format dir inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1354 b/tests/xfs/1354
new file mode 100644
index 0000000..3771702
--- /dev/null
+++ b/tests/xfs/1354
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1354
+#
+# Populate a XFS filesystem and fuzz every extents-format file inode field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find extents-format file inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFREG.FMT_EXTENTS)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1354.out b/tests/xfs/1354.out
new file mode 100644
index 0000000..afb934a
--- /dev/null
+++ b/tests/xfs/1354.out
@@ -0,0 +1,5 @@
+QA output created by 1354
+Format and populate
+Find extents-format file inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1355 b/tests/xfs/1355
new file mode 100644
index 0000000..61719d4
--- /dev/null
+++ b/tests/xfs/1355
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1355
+#
+# Populate a XFS filesystem and fuzz every btree-format file inode field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find btree-format file inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFREG.FMT_BTREE)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1355.out b/tests/xfs/1355.out
new file mode 100644
index 0000000..63465b5
--- /dev/null
+++ b/tests/xfs/1355.out
@@ -0,0 +1,5 @@
+QA output created by 1355
+Format and populate
+Find btree-format file inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1356 b/tests/xfs/1356
new file mode 100644
index 0000000..8e8eead
--- /dev/null
+++ b/tests/xfs/1356
@@ -0,0 +1,67 @@
+#! /bin/bash
+# FS QA Test No. 1356
+#
+# Populate a XFS filesystem and fuzz every bmbt block field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find bmbt block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFREG.FMT_BTREE)
+_scratch_unmount
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "inode ${inum}")
+
+echo "Fuzz bmbt"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" "addr u${inode_ver}.bmbt.ptrs[1]" >> $seqres.full
+echo "Done fuzzing bmbt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1356.out b/tests/xfs/1356.out
new file mode 100644
index 0000000..22d79bb
--- /dev/null
+++ b/tests/xfs/1356.out
@@ -0,0 +1,5 @@
+QA output created by 1356
+Format and populate
+Find bmbt block
+Fuzz bmbt
+Done fuzzing bmbt
diff --git a/tests/xfs/1357 b/tests/xfs/1357
new file mode 100644
index 0000000..725243f
--- /dev/null
+++ b/tests/xfs/1357
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1357
+#
+# Populate a XFS filesystem and fuzz every symlink remote block field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find symlink remote block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFLNK.FMT_EXTENTS)
+_scratch_unmount
+
+echo "Fuzz symlink remote block"
+_scratch_xfs_fuzz_metadata '' 'online' "inode ${inum}" 'dblock 0' >> $seqres.full
+echo "Done fuzzing symlink remote block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1357.out b/tests/xfs/1357.out
new file mode 100644
index 0000000..83b428b
--- /dev/null
+++ b/tests/xfs/1357.out
@@ -0,0 +1,5 @@
+QA output created by 1357
+Format and populate
+Find symlink remote block
+Fuzz symlink remote block
+Done fuzzing symlink remote block
diff --git a/tests/xfs/1358 b/tests/xfs/1358
new file mode 100644
index 0000000..ef34b6d
--- /dev/null
+++ b/tests/xfs/1358
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1358
+#
+# Populate a XFS filesystem and fuzz every inline directory inode field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find inline-format dir inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_INLINE)
+_scratch_unmount
+
+echo "Fuzz inline-format dir inode"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inline-format dir inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1358.out b/tests/xfs/1358.out
new file mode 100644
index 0000000..7d18d45
--- /dev/null
+++ b/tests/xfs/1358.out
@@ -0,0 +1,5 @@
+QA output created by 1358
+Format and populate
+Find inline-format dir inode
+Fuzz inline-format dir inode
+Done fuzzing inline-format dir inode
diff --git a/tests/xfs/1359 b/tests/xfs/1359
new file mode 100644
index 0000000..385a28f
--- /dev/null
+++ b/tests/xfs/1359
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1359
+#
+# Populate a XFS filesystem and fuzz every block-format dir block field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find data-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_BLOCK)
+_scratch_unmount
+
+echo "Fuzz data-format dir block"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" 'dblock 0' >> $seqres.full
+echo "Done fuzzing data-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1359.out b/tests/xfs/1359.out
new file mode 100644
index 0000000..9a70632
--- /dev/null
+++ b/tests/xfs/1359.out
@@ -0,0 +1,5 @@
+QA output created by 1359
+Format and populate
+Find data-format dir block
+Fuzz data-format dir block
+Done fuzzing data-format dir block
diff --git a/tests/xfs/1360 b/tests/xfs/1360
new file mode 100644
index 0000000..27ed773
--- /dev/null
+++ b/tests/xfs/1360
@@ -0,0 +1,66 @@
+#! /bin/bash
+# FS QA Test No. 1360
+#
+# Populate a XFS filesystem and fuzz every data-format dir block field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find data-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_LEAF)
+blk_sz=$(get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+echo "Fuzz data-format dir block"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" "dblock 0" >> $seqres.full
+echo "Done fuzzing data-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1360.out b/tests/xfs/1360.out
new file mode 100644
index 0000000..9ce6a67
--- /dev/null
+++ b/tests/xfs/1360.out
@@ -0,0 +1,5 @@
+QA output created by 1360
+Format and populate
+Find data-format dir block
+Fuzz data-format dir block
+Done fuzzing data-format dir block
diff --git a/tests/xfs/1361 b/tests/xfs/1361
new file mode 100644
index 0000000..3622f6f
--- /dev/null
+++ b/tests/xfs/1361
@@ -0,0 +1,67 @@
+#! /bin/bash
+# FS QA Test No. 1361
+#
+# Populate a XFS filesystem and fuzz every leaf1-format dir block field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find leaf1-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_LEAF)
+blk_sz=$(get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( (2 ** 35) / blk_sz))
+echo "Fuzz leaf1-format dir block"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing leaf1-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1361.out b/tests/xfs/1361.out
new file mode 100644
index 0000000..251a100
--- /dev/null
+++ b/tests/xfs/1361.out
@@ -0,0 +1,5 @@
+QA output created by 1361
+Format and populate
+Find leaf1-format dir block
+Fuzz leaf1-format dir block
+Done fuzzing leaf1-format dir block
diff --git a/tests/xfs/1362 b/tests/xfs/1362
new file mode 100644
index 0000000..474a965
--- /dev/null
+++ b/tests/xfs/1362
@@ -0,0 +1,67 @@
+#! /bin/bash
+# FS QA Test No. 1362
+#
+# Populate a XFS filesystem and fuzz every leafn-format dir block field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find leafn-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_NODE)
+blk_sz=$(get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( ( (2 ** 35) / blk_sz) + 1))
+echo "Fuzz leafn-format dir block"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing leafn-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1362.out b/tests/xfs/1362.out
new file mode 100644
index 0000000..d6694b3
--- /dev/null
+++ b/tests/xfs/1362.out
@@ -0,0 +1,5 @@
+QA output created by 1362
+Format and populate
+Find leafn-format dir block
+Fuzz leafn-format dir block
+Done fuzzing leafn-format dir block
diff --git a/tests/xfs/1363 b/tests/xfs/1363
new file mode 100644
index 0000000..370fc25
--- /dev/null
+++ b/tests/xfs/1363
@@ -0,0 +1,67 @@
+#! /bin/bash
+# FS QA Test No. 1363
+#
+# Populate a XFS filesystem and fuzz every node-format dir block field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find node-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_NODE)
+blk_sz=$(get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( (2 ** 35) / blk_sz ))
+echo "Fuzz node-format dir block"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing node-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1363.out b/tests/xfs/1363.out
new file mode 100644
index 0000000..c5d8fd6
--- /dev/null
+++ b/tests/xfs/1363.out
@@ -0,0 +1,5 @@
+QA output created by 1363
+Format and populate
+Find node-format dir block
+Fuzz node-format dir block
+Done fuzzing node-format dir block
diff --git a/tests/xfs/1364 b/tests/xfs/1364
new file mode 100644
index 0000000..994d6d5
--- /dev/null
+++ b/tests/xfs/1364
@@ -0,0 +1,67 @@
+#! /bin/bash
+# FS QA Test No. 1364
+#
+# Populate a XFS filesystem and fuzz every freeindex-format dir block field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find freeindex-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_NODE)
+blk_sz=$(get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( (2 ** 36) / blk_sz ))
+echo "Fuzz freeindex-format dir block"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing freeindex-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1364.out b/tests/xfs/1364.out
new file mode 100644
index 0000000..f85d52e
--- /dev/null
+++ b/tests/xfs/1364.out
@@ -0,0 +1,5 @@
+QA output created by 1364
+Format and populate
+Find freeindex-format dir block
+Fuzz freeindex-format dir block
+Done fuzzing freeindex-format dir block
diff --git a/tests/xfs/1365 b/tests/xfs/1365
new file mode 100644
index 0000000..04d5865
--- /dev/null
+++ b/tests/xfs/1365
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1365
+#
+# Populate a XFS filesystem and fuzz every inline attr inode field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find inline-format attr inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_LOCAL)
+_scratch_unmount
+
+echo "Fuzz inline-format attr inode"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inline-format attr inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1365.out b/tests/xfs/1365.out
new file mode 100644
index 0000000..e9a62d5
--- /dev/null
+++ b/tests/xfs/1365.out
@@ -0,0 +1,5 @@
+QA output created by 1365
+Format and populate
+Find inline-format attr inode
+Fuzz inline-format attr inode
+Done fuzzing inline-format attr inode
diff --git a/tests/xfs/1366 b/tests/xfs/1366
new file mode 100644
index 0000000..03f5c6d
--- /dev/null
+++ b/tests/xfs/1366
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1366
+#
+# Populate a XFS filesystem and fuzz every leaf-format attr block field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find leaf-format attr block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_LEAF)
+_scratch_unmount
+
+echo "Fuzz leaf-format attr block"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" 'ablock 0' >> $seqres.full
+echo "Done fuzzing leaf-format attr block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1366.out b/tests/xfs/1366.out
new file mode 100644
index 0000000..5a45bab
--- /dev/null
+++ b/tests/xfs/1366.out
@@ -0,0 +1,5 @@
+QA output created by 1366
+Format and populate
+Find leaf-format attr block
+Fuzz leaf-format attr block
+Done fuzzing leaf-format attr block
diff --git a/tests/xfs/1367 b/tests/xfs/1367
new file mode 100644
index 0000000..6dbd965
--- /dev/null
+++ b/tests/xfs/1367
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1367
+#
+# Populate a XFS filesystem and fuzz every node-format attr block field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find node-format attr block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_NODE)
+_scratch_unmount
+
+echo "Fuzz node-format attr block"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" "ablock 0" >> $seqres.full
+echo "Done fuzzing node-format attr block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1367.out b/tests/xfs/1367.out
new file mode 100644
index 0000000..798131d
--- /dev/null
+++ b/tests/xfs/1367.out
@@ -0,0 +1,5 @@
+QA output created by 1367
+Format and populate
+Find node-format attr block
+Fuzz node-format attr block
+Done fuzzing node-format attr block
diff --git a/tests/xfs/1368 b/tests/xfs/1368
new file mode 100644
index 0000000..9e6ab9e
--- /dev/null
+++ b/tests/xfs/1368
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1368
+#
+# Populate a XFS filesystem and fuzz every external attr block field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find external attr block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_EXTENTS_REMOTE3K)
+_scratch_unmount
+
+echo "Fuzz external attr block"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" "ablock 1" >> $seqres.full
+echo "Done fuzzing external attr block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1368.out b/tests/xfs/1368.out
new file mode 100644
index 0000000..6847bdb
--- /dev/null
+++ b/tests/xfs/1368.out
@@ -0,0 +1,5 @@
+QA output created by 1368
+Format and populate
+Find external attr block
+Fuzz external attr block
+Done fuzzing external attr block
diff --git a/tests/xfs/1369 b/tests/xfs/1369
new file mode 100644
index 0000000..a14d20e
--- /dev/null
+++ b/tests/xfs/1369
@@ -0,0 +1,64 @@
+#! /bin/bash
+# FS QA Test No. 1369
+#
+# Populate a XFS filesystem and fuzz every rtrmapbt record field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'sb 0' 'addr rrmapino')
+
+echo "Fuzz rtrmapbt recs"
+_scratch_xfs_fuzz_metadata '' 'online' 'sb 0' 'addr rrmapino' "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
+echo "Done fuzzing rtrmapbt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1369.out b/tests/xfs/1369.out
new file mode 100644
index 0000000..9d1e592
--- /dev/null
+++ b/tests/xfs/1369.out
@@ -0,0 +1,4 @@
+QA output created by 1369
+Format and populate
+Fuzz rtrmapbt recs
+Done fuzzing rtrmapbt recs
diff --git a/tests/xfs/1370 b/tests/xfs/1370
new file mode 100644
index 0000000..82096ad
--- /dev/null
+++ b/tests/xfs/1370
@@ -0,0 +1,62 @@
+#! /bin/bash
+# FS QA Test No. 1370
+#
+# Populate a XFS filesystem and fuzz every rtrmapbt keyptr field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rtrmapbt keyptrs"
+_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'offline' 'sb 0' 'addr rrmapino' >> $seqres.full
+echo "Done fuzzing rtrmapbt keyptrs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1370.out b/tests/xfs/1370.out
new file mode 100644
index 0000000..768c9de
--- /dev/null
+++ b/tests/xfs/1370.out
@@ -0,0 +1,4 @@
+QA output created by 1370
+Format and populate
+Fuzz rtrmapbt keyptrs
+Done fuzzing rtrmapbt keyptrs
diff --git a/tests/xfs/1371 b/tests/xfs/1371
new file mode 100644
index 0000000..0cbc4c6
--- /dev/null
+++ b/tests/xfs/1371
@@ -0,0 +1,62 @@
+#! /bin/bash
+# FS QA Test No. 1371
+#
+# Populate a XFS filesystem and fuzz every refcountbt field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz refcountbt"
+_scratch_xfs_fuzz_metadata '' 'online'  'agf 0' 'addr refcntroot' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing refcountbt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1371.out b/tests/xfs/1371.out
new file mode 100644
index 0000000..08bce89
--- /dev/null
+++ b/tests/xfs/1371.out
@@ -0,0 +1,4 @@
+QA output created by 1371
+Format and populate
+Fuzz refcountbt
+Done fuzzing refcountbt
diff --git a/tests/xfs/1372 b/tests/xfs/1372
new file mode 100755
index 0000000..0c07d7c
--- /dev/null
+++ b/tests/xfs/1372
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1372
+#
+# Populate a XFS filesystem and fuzz every btree-format attr inode field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find btree-format attr inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_BTREE)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1372.out b/tests/xfs/1372.out
new file mode 100755
index 0000000..1907c59
--- /dev/null
+++ b/tests/xfs/1372.out
@@ -0,0 +1,5 @@
+QA output created by 1372
+Format and populate
+Find btree-format attr inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1373 b/tests/xfs/1373
new file mode 100755
index 0000000..b291e2d
--- /dev/null
+++ b/tests/xfs/1373
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1373
+#
+# Populate a XFS filesystem and fuzz every blockdev inode field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find blockdev inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFBLK)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1373.out b/tests/xfs/1373.out
new file mode 100755
index 0000000..45ed4c0
--- /dev/null
+++ b/tests/xfs/1373.out
@@ -0,0 +1,5 @@
+QA output created by 1373
+Format and populate
+Find blockdev inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1374 b/tests/xfs/1374
new file mode 100755
index 0000000..14d25c8
--- /dev/null
+++ b/tests/xfs/1374
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1374
+#
+# Populate a XFS filesystem and fuzz every local-format symlink inode field.
+# Use xfs_scrub to fix the corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find local-format symlink inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFLNK.FMT_LOCAL)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1374.out b/tests/xfs/1374.out
new file mode 100755
index 0000000..1f11fa4
--- /dev/null
+++ b/tests/xfs/1374.out
@@ -0,0 +1,5 @@
+QA output created by 1374
+Format and populate
+Find local-format symlink inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/group b/tests/xfs/group
index fcb9644..db5f672 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -336,3 +336,72 @@
 347 auto quick clone
 400 auto quick
 401 auto quick
+1300 dangerous_fuzzers scrub
+1301 dangerous_fuzzers dangerous_scrub dangerous_repair
+1302 dangerous_fuzzers dangerous_scrub dangerous_repair
+1303 dangerous_fuzzers dangerous_scrub dangerous_repair
+1304 dangerous_fuzzers dangerous_scrub dangerous_repair
+1305 dangerous_fuzzers dangerous_scrub dangerous_repair
+1306 dangerous_fuzzers dangerous_scrub dangerous_repair
+1307 dangerous_fuzzers dangerous_scrub dangerous_repair
+1308 dangerous_fuzzers dangerous_scrub dangerous_repair
+1309 dangerous_fuzzers dangerous_scrub dangerous_repair
+1310 dangerous_fuzzers dangerous_scrub dangerous_repair
+1311 dangerous_fuzzers dangerous_scrub dangerous_repair
+1312 dangerous_fuzzers dangerous_scrub dangerous_repair
+1313 dangerous_fuzzers dangerous_scrub dangerous_repair
+1314 dangerous_fuzzers dangerous_scrub dangerous_repair
+1315 dangerous_fuzzers dangerous_scrub dangerous_repair
+1316 dangerous_fuzzers dangerous_scrub dangerous_repair
+1317 dangerous_fuzzers dangerous_scrub dangerous_repair
+1318 dangerous_fuzzers dangerous_scrub dangerous_repair
+1319 dangerous_fuzzers dangerous_scrub dangerous_repair
+1320 dangerous_fuzzers dangerous_scrub dangerous_repair
+1321 dangerous_fuzzers dangerous_scrub dangerous_repair
+1322 dangerous_fuzzers dangerous_scrub dangerous_repair
+1323 dangerous_fuzzers dangerous_scrub dangerous_repair
+1324 dangerous_fuzzers dangerous_scrub dangerous_repair
+1325 dangerous_fuzzers dangerous_scrub dangerous_repair
+1326 dangerous_fuzzers dangerous_scrub dangerous_repair
+1327 dangerous_fuzzers dangerous_scrub dangerous_repair
+1328 dangerous_fuzzers dangerous_scrub dangerous_repair
+1329 dangerous_fuzzers dangerous_scrub dangerous_repair
+1330 dangerous_fuzzers dangerous_scrub dangerous_repair
+1331 dangerous_fuzzers dangerous_scrub dangerous_repair
+1332 dangerous_fuzzers dangerous_scrub dangerous_repair
+1333 dangerous_fuzzers dangerous_scrub dangerous_repair
+1334 dangerous_fuzzers dangerous_scrub dangerous_repair
+1341 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1342 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1343 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1344 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1345 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1346 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1347 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1348 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1349 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1350 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1351 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1352 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1353 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1354 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1355 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1356 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1357 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1358 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1359 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1360 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1361 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1362 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1363 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1364 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1365 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1366 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1367 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1368 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1369 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1370 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1371 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1372 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1373 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1374 dangerous_fuzzers dangerous_scrub dangerous_online_repair

