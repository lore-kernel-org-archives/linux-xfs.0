Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E72857F37
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 18:25:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D3FD9304043
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 16:25:11 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id wj5SzM13IKPyBzYj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Mar 2015 16:25:09 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id t2INP8dd002778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 23:25:08 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	t2INP7bP002588
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 23:25:08 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	t2INP7OS025878 for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 23:25:07 GMT
Date: Wed, 18 Mar 2015 16:25:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC 2/2] xfs_db: enable blocktrash for checksummed filesystems
Message-ID: <20150318232505.GD24608@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Disable the write verifiers when we're trashing a block.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c    |    4 +
 db/xfsfuzz.sh |  303 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 307 insertions(+)
 create mode 100755 db/xfsfuzz.sh

diff --git a/db/check.c b/db/check.c
index 767022f..aa8750a 100644
--- a/db/check.c
+++ b/db/check.c
@@ -949,6 +949,7 @@ blocktrash_b(
 	int		mask;
 	int		newbit;
 	int		offset;
+	const struct xfs_buf_ops *stashed_ops;
 	static char	*modestr[] = {
 		N_("zeroed"), N_("set"), N_("flipped"), N_("randomized")
 	};
@@ -959,6 +960,8 @@ blocktrash_b(
 	push_cur();
 	set_cur(&typtab[DBM_UNKNOWN],
 		XFS_AGB_TO_DADDR(mp, agno, agbno), blkbb, DB_RING_IGN, NULL);
+	stashed_ops = iocur_top->bp->b_ops;
+	iocur_top->bp->b_ops = NULL;
 	if ((buf = iocur_top->data) == NULL) {
 		dbprintf(_("can't read block %u/%u for trashing\n"), agno, agbno);
 		pop_cur();
@@ -989,6 +992,7 @@ blocktrash_b(
 			buf[byte] &= ~mask;
 	}
 	write_cur();
+	iocur_top->bp->b_ops = stashed_ops;
 	pop_cur();
 	printf(_("blocktrash: %u/%u %s block %d bit%s starting %d:%d %s\n"),
 		agno, agbno, typename[type], len, len == 1 ? "" : "s",
diff --git a/db/xfsfuzz.sh b/db/xfsfuzz.sh
new file mode 100755
index 0000000..fe9573c
--- /dev/null
+++ b/db/xfsfuzz.sh
@@ -0,0 +1,303 @@
+#!/bin/bash
+
+# Test harness to fuzz a filesystem over and over...
+# Copyright (C) 2014 Oracle.
+
+DIR=/tmp
+PASSES=10000
+SZ=32m
+SCRIPT_DIR="$(dirname "$0")"
+FEATURES="-m crc=1,finobt=1"
+xEATURES="-m crc=0"
+BLK_SZ=4096
+INODE_SZ=512
+RUN_FSCK=1
+OVERRIDE_PATH=1
+MAX_FSCK=10
+SRCDIR=/etc
+FUZZ_ARGS="-3 -n 32"
+XFS_REPAIR_OPTS="-P"
+
+print_help() {
+	echo "Usage: $0 OPTIONS"
+	echo "-b:	FS block size is this. (${BLK_SZ})"
+	echo "-B:	Corrupt this many bytes per run."
+	echo "-d:	Create test files in this directory. (${DIR})"
+	echo "-f:	Do not run xfs_repair after each pass."
+	echo "-I:	Create inodes of this size. (${INODE_SZ})"
+	echo "-n:	Run this many passes. (${PASSES})"
+	echo "-O:	Pass this to mkfs.xfs."
+	echo "-p:	Use system's xfsprogs tools."
+	echo "-s:	Create FS images of this size. (${SZ})"
+	echo "-S:	Copy files from this dir. (${SRCDIR})"
+	echo "-x:	Run xfs_repair at most this many times. (${MAX_FSCK})"
+	exit 0
+}
+
+GETOPT="d:n:s:O:I:b:B:fpx:S:"
+
+while getopts "${GETOPT}" opt; do
+	case "${opt}" in
+	"B")
+		FUZZ_ARGS="-3 -n ${OPTARG}"
+		;;
+	"d")
+		DIR="${OPTARG}"
+		;;
+	"n")
+		PASSES="${OPTARG}"
+		;;
+	"s")
+		SZ="${OPTARG}"
+		;;
+	"O")
+		FEATURES="${OPTARG}"
+		;;
+	"I")
+		INODE_SZ="${OPTARG}"
+		;;
+	"b")
+		BLK_SZ="${OPTARG}"
+		;;
+	"f")
+		RUN_FSCK=0
+		;;
+	"p")
+		OVERRIDE_PATH=0
+		;;
+	"x")
+		MAX_FSCK="${OPTARG}"
+		;;
+	"S")
+		SRCDIR="${OPTARG}"
+		;;
+	*)
+		print_help
+		;;
+	esac
+done
+
+if [ "${OVERRIDE_PATH}" -gt 0 ]; then
+	PATH="${SCRIPT_DIR}:${SCRIPT_DIR}/../repair/:${SCRIPT_DIR}/../db/:${SCRIPT_DIR}/../mkfs/:${PATH}"
+	export PATH
+fi
+
+TESTDIR="${DIR}/tests/"
+TESTMNT="${DIR}/mnt/"
+BASE_IMG="${DIR}/xfsfuzz.img"
+
+# Set up FS image
+echo "+ create fs image"
+umount "${TESTDIR}"
+umount "${TESTMNT}"
+rm -rf "${TESTDIR}"
+rm -rf "${TESTMNT}"
+mkdir -p "${TESTDIR}"
+mkdir -p "${TESTMNT}"
+rm -rf "${BASE_IMG}"
+truncate -s "${SZ}" "${BASE_IMG}"
+mkfs.xfs -f ${FEATURES} -b "size=${BLK_SZ}" -i "size=${INODE_SZ}" "${BASE_IMG}"
+if [ $? -ne 0 ]; then
+	exit $?
+fi
+
+# Populate FS image
+echo "+ populate fs image"
+modprobe loop
+mount "${BASE_IMG}" "${TESTMNT}" -o loop
+if [ $? -ne 0 ]; then
+	exit $?
+fi
+SRC_SZ="$(du -ks "${SRCDIR}" | awk '{print $1}')"
+FS_SZ="$(( $(stat -f "${TESTMNT}" -c '%a * %S') / 1024 ))"
+NR="$(( (FS_SZ * 6 / 10) / SRC_SZ ))"
+if [ "${NR}" -lt 1 ]; then
+	NR=1
+fi
+echo "+ make ${NR} copies"
+seq 1 "${NR}" | while read nr; do
+	cp -pRdu "${SRCDIR}" "${TESTMNT}/test.${nr}" 2> /dev/null
+done
+umount "${TESTMNT}"
+xfs_repair ${XFS_REPAIR_OPTS} -vn "${BASE_IMG}"
+if [ $? -ne 0 ]; then
+	echo "fsck failed??"
+	exit 1
+fi
+
+# Run tests
+echo "+ run test"
+ret=0
+seq 1 "${PASSES}" | while read pass; do
+	echo "+ pass ${pass}"
+	PASS_IMG="${TESTDIR}/xfsfuzz-${pass}.img"
+	FSCK_IMG="${TESTDIR}/xfsfuzz-${pass}.fsck"
+	FUZZ_LOG="${TESTDIR}/xfsfuzz-${pass}.fuzz.log"
+	OPS_LOG="${TESTDIR}/xfsfuzz-${pass}.ops.log"
+
+	echo "++ corrupt image"
+	cp "${BASE_IMG}" "${PASS_IMG}"
+	if [ $? -ne 0 ]; then
+		exit $?
+	fi
+	xfs_db -x -c "label xfsfuzz-${pass}" "${PASS_IMG}"
+	xfs_db -x -c blockget -c "blocktrash ${FUZZ_ARGS}" "${PASS_IMG}" > "${FUZZ_LOG}"
+#	res=$?
+#	if [ "${res}" -ne 0 ]; then
+#		echo "blocktrash returns ${res}"
+#		exit "${res}"
+#	fi
+
+	echo "++ mount image"
+	mount "${PASS_IMG}" "${TESTMNT}" -o loop
+	res=$?
+
+	if [ "${res}" -eq 0 ]; then
+		echo "+++ ls -laR"
+		ls -laR "${TESTMNT}/test.1/" > /dev/null 2> "${OPS_LOG}"
+
+		echo "+++ cat files"
+		find "${TESTMNT}/test.1/" -type f -size -1048576k -print0 | xargs -0 cat > /dev/null 2>> "${OPS_LOG}"
+
+		echo "+++ expand"
+		find "${TESTMNT}/" -type f 2> /dev/null | head -n 50000 | while read f; do
+			attr -l "$f" > /dev/null 2>> "${OPS_LOG}"
+			if [ -f "$f" -a -w "$f" ]; then
+				dd if=/dev/zero bs="${BLK_SZ}" count=1 >> "$f" 2>> "${OPS_LOG}"
+			fi
+			mv "$f" "$f.longer" > /dev/null 2>> "${OPS_LOG}"
+		done
+		sync
+
+		echo "+++ create files"
+		cp -pRdu "${SRCDIR}" "${TESTMNT}/test.moo" 2>> "${OPS_LOG}"
+		sync
+
+		echo "+++ remove files"
+		rm -rf "${TESTMNT}/test.moo" 2>> "${OPS_LOG}"
+
+		umount "${TESTMNT}"
+		res=$?
+		if [ "${res}" -ne 0 ]; then
+			ret=1
+			break
+		fi
+		sync
+	fi
+	if [ "${RUN_FSCK}" -gt 0 ]; then
+		cp "${PASS_IMG}" "${FSCK_IMG}"
+		pass_img_sz="$(stat -c '%s' "${PASS_IMG}")"
+
+		seq 1 "${MAX_FSCK}" | while read fsck_pass; do
+			echo "++ fsck pass ${fsck_pass}: $(which xfs_repair) -v ${FSCK_IMG}"
+			FSCK_LOG="${TESTDIR}/xfsfuzz-${pass}-${fsck_pass}.log"
+			echo "repairing" > "${FSCK_LOG}"
+			xfs_repair ${XFS_REPAIR_OPTS} -v "${FSCK_IMG}" >> "${FSCK_LOG}" 2>&1
+			res=$?
+			if [ "${res}" -eq 0 ]; then
+				echo "reverify" >> "${FSCK_LOG}"
+				xfs_repair ${XFS_REPAIR_OPTS} -v -n "${FSCK_IMG}" >> "${FSCK_LOG}" 2>&1
+				res=$?
+			fi
+			echo "++ fsck returns ${res}"
+			if [ "${res}" -eq 0 ]; then
+				exit 0
+			elif [ "${res}" -eq 2 ]; then
+				# replay log?
+				echo "replaying log" >> "${FSCK_LOG}"
+				dmesg > /tmp/a
+				mount "${FSCK_IMG}" "${TESTMNT}" -o loop
+				res=$?
+				if [ "${res}" -gt 0 ]; then
+					echo "+++ zeroing log"
+					echo "zeroing log" >> "${FSCK_LOG}"
+					xfs_repair ${XFS_REPAIR_OPTS} -L -v "${FSCK_IMG}" >> "${FSCK_LOG}" 2>&1
+				else
+					umount "${TESTMNT}"
+				fi
+				dmesg > /tmp/b
+				diff -u /tmp/a /tmp/b >> "${FSCK_LOG}"
+			elif [ "${fsck_pass}" -eq "${MAX_FSCK}" ]; then
+				echo "++ fsck did not fix in ${MAX_FSCK} passes."
+				exit 1
+			fi
+			if [ "${fsck_pass}" -gt 1 ]; then
+				diff -u "${TESTDIR}/xfsfuzz-${pass}-$((fsck_pass - 1)).log" "${FSCK_LOG}"
+				if [ $? -eq 0 ]; then
+					echo "++ fsck makes no progress"
+					exit 2
+				fi
+			fi
+
+			fsck_img_sz="$(stat -c '%s' "${FSCK_IMG}")"
+			if [ "${fsck_img_sz}" -ne "${pass_img_sz}" ]; then
+				echo "++ fsck image size changed"
+				exit 3
+			fi
+		done
+		fsck_loop_ret=$?
+		if [ "${fsck_loop_ret}" -gt 0 ]; then
+			break;
+		fi
+	fi
+
+	echo "+++ check fs for round 2"
+	FSCK_LOG="${TESTDIR}/xfsfuzz-${pass}-round2.log"
+	xfs_repair ${XFS_REPAIR_OPTS} -v -n "${FSCK_IMG}" > "${FSCK_LOG}" 2>&1
+	res=$?
+	if [ "${res}" -ne 0 ]; then
+		echo "++++ fsck failed."
+		exit 1
+	fi
+
+	echo "++ mount image (2)"
+	mount "${FSCK_IMG}" "${TESTMNT}" -o loop
+	res=$?
+
+	if [ "${res}" -eq 0 ]; then
+		echo "+++ ls -laR (2)"
+		ls -laR "${TESTMNT}/test.1/" > /dev/null 2> "${OPS_LOG}"
+
+		echo "+++ cat files (2)"
+		find "${TESTMNT}/test.1/" -type f -size -1048576k -print0 | xargs -0 cat > /dev/null 2>> "${OPS_LOG}"
+
+		echo "+++ expand (2)"
+		find "${TESTMNT}/" -type f 2> /dev/null | head -n 50000 | while read f; do
+			attr -l "$f" > /dev/null 2>> "${OPS_LOG}"
+			if [ -f "$f" -a -w "$f" ]; then
+				dd if=/dev/zero bs="${BLK_SZ}" count=1 >> "$f" 2>> "${OPS_LOG}"
+			fi
+			mv "$f" "$f.longer" > /dev/null 2>> "${OPS_LOG}"
+		done
+		sync
+
+		echo "+++ create files (2)"
+		cp -pRdu "${SRCDIR}" "${TESTMNT}/test.moo" 2>> "${OPS_LOG}"
+		sync
+
+		echo "+++ remove files (2)"
+		rm -rf "${TESTMNT}/test.moo" 2>> "${OPS_LOG}"
+
+		umount "${TESTMNT}"
+		res=$?
+		if [ "${res}" -ne 0 ]; then
+			ret=1
+			break
+		fi
+		sync
+
+		echo "+++ check fs (2)"
+		xfs_repair ${XFS_REPAIR_OPTS} -v -n "${FSCK_IMG}" >> "${FSCK_LOG}" 2>&1
+		res=$?
+		if [ "${res}" -ne 0 ]; then
+			echo "++++ fsck failed."
+			exit 1
+		fi
+	else
+		echo "++ mount(2) failed with ${res}"
+		exit 1
+	fi
+	rm -rf "${FSCK_IMG}" "${PASS_IMG}" "${FUZZ_LOG}" "${TESTDIR}"/xfsfuzz*.log
+done
+
+exit $ret

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
