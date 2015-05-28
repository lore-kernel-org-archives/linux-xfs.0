Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5E6A07F54
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 00:08:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 22564304039
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 22:08:21 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id nsFi3zvXhm3OdBmY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 May 2015 22:08:18 -0700 (PDT)
Date: Wed, 27 May 2015 22:08:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/5] xfs_db: enable blocktrash for checksummed filesystems
Message-ID: <20150528050815.GF10175@birch.djwong.org>
References: <20150526225126.26434.69010.stgit@birch.djwong.org>
	<20150526225159.26434.92261.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150526225159.26434.92261.stgit@birch.djwong.org>
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
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

On Tue, May 26, 2015 at 03:51:59PM -0700, Darrick J. Wong wrote:
> Disable the write verifiers when we're trashing a block.  With this
> in place, create a xfs fuzzer script that formats, populates, corrupts,
> tries to use, repairs, and tries again to use a crash test xfs image.
> Hopefully this will shake out some v5 filesystem bugs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/check.c    |    7 +
>  db/xfsfuzz.sh |  305 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 312 insertions(+)
>  create mode 100755 db/xfsfuzz.sh
> 
> 
> diff --git a/db/check.c b/db/check.c
> index 8f8096d..2c2a02e 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -953,6 +953,7 @@ blocktrash_b(
>  	int		mask;
>  	int		newbit;
>  	int		offset;
> +	const struct xfs_buf_ops *stashed_ops;
>  	static char	*modestr[] = {
>  		N_("zeroed"), N_("set"), N_("flipped"), N_("randomized")
>  	};
> @@ -963,6 +964,8 @@ blocktrash_b(
>  	push_cur();
>  	set_cur(&typtab[DBM_UNKNOWN],

So... seeing as the the TYP_* and DBM_* values don't correspond and every other
user of typtab uses the TYP_ values for array index, what's the point of
unconditionally using the AGF verifier on this block?  Passing NULL as the
first argument doesn't seem to hurt anything.

(DBM_UNKNOWN == TYP_AGF)

Seeing as we're going to trash the block anyway, why bother?

>  		XFS_AGB_TO_DADDR(mp, agno, agbno), blkbb, DB_RING_IGN, NULL);
> +	stashed_ops = iocur_top->bp->b_ops;
> +	iocur_top->bp->b_ops = NULL;
>  	if ((buf = iocur_top->data) == NULL) {
>  		dbprintf(_("can't read block %u/%u for trashing\n"), agno, agbno);
>  		pop_cur();
> @@ -993,6 +996,7 @@ blocktrash_b(
>  			buf[byte] &= ~mask;
>  	}
>  	write_cur();
> +	iocur_top->bp->b_ops = stashed_ops;
>  	pop_cur();
>  	printf(_("blocktrash: %u/%u %s block %d bit%s starting %d:%d %s\n"),
>  		agno, agbno, typename[type], len, len == 1 ? "" : "s",
> @@ -1049,9 +1053,12 @@ blocktrash_f(
>  		   (1 << DBM_BTINO) |
>  		   (1 << DBM_DIR) |
>  		   (1 << DBM_INODE) |
> +		   (1 << DBM_LOG) |

It's useful to be able to fuzz the log, but that'll bias the block selection
towards the log.  Maybe it should be masked off by default in tmask = goodmask
below?

>  		   (1 << DBM_QUOTA) |
>  		   (1 << DBM_RTBITMAP) |
>  		   (1 << DBM_RTSUM) |
> +		   (1 << DBM_SYMLINK) |
> +		   (1 << DBM_BTFINO) |
>  		   (1 << DBM_SB);
>  	while ((c = getopt(argc, argv, "0123n:s:t:x:y:")) != EOF) {
>  		switch (c) {
> diff --git a/db/xfsfuzz.sh b/db/xfsfuzz.sh
> new file mode 100755
> index 0000000..fc40e97
> --- /dev/null
> +++ b/db/xfsfuzz.sh

[working on stuffing this into xfstests]
[maybe I'll see about doing likewise for the ext4 fuzzer]

--D

> @@ -0,0 +1,305 @@
> +#!/bin/bash
> +
> +# Test harness to fuzz a filesystem over and over...
> +# Copyright (C) 2014 Oracle.
> +
> +DIR=/tmp
> +PASSES=10000
> +SZ=32m
> +SCRIPT_DIR="$(dirname "$0")"
> +FEATURES="-m crc=1,finobt=1"
> +xEATURES="-m crc=0"
> +BLK_SZ=4096
> +INODE_SZ=512
> +RUN_FSCK=1
> +OVERRIDE_PATH=1
> +MAX_FSCK=10
> +SRCDIR=/etc
> +FUZZ_ARGS="-3 -n 32"
> +XFS_REPAIR_OPTS="-P"
> +
> +print_help() {
> +	echo "Usage: $0 OPTIONS"
> +	echo "-b:	FS block size is this. (${BLK_SZ})"
> +	echo "-B:	Corrupt this many bytes per run."
> +	echo "-d:	Create test files in this directory. (${DIR})"
> +	echo "-f:	Do not run xfs_repair after each pass."
> +	echo "-I:	Create inodes of this size. (${INODE_SZ})"
> +	echo "-n:	Run this many passes. (${PASSES})"
> +	echo "-O:	Pass this to mkfs.xfs."
> +	echo "-p:	Use system's xfsprogs tools."
> +	echo "-s:	Create FS images of this size. (${SZ})"
> +	echo "-S:	Copy files from this dir. (${SRCDIR})"
> +	echo "-x:	Run xfs_repair at most this many times. (${MAX_FSCK})"
> +	exit 0
> +}
> +
> +GETOPT="d:n:s:O:I:b:B:fpx:S:"
> +
> +while getopts "${GETOPT}" opt; do
> +	case "${opt}" in
> +	"B")
> +		FUZZ_ARGS="-3 -n ${OPTARG}"
> +		;;
> +	"d")
> +		DIR="${OPTARG}"
> +		;;
> +	"n")
> +		PASSES="${OPTARG}"
> +		;;
> +	"s")
> +		SZ="${OPTARG}"
> +		;;
> +	"O")
> +		FEATURES="${OPTARG}"
> +		;;
> +	"I")
> +		INODE_SZ="${OPTARG}"
> +		;;
> +	"b")
> +		BLK_SZ="${OPTARG}"
> +		;;
> +	"f")
> +		RUN_FSCK=0
> +		;;
> +	"p")
> +		OVERRIDE_PATH=0
> +		;;
> +	"x")
> +		MAX_FSCK="${OPTARG}"
> +		;;
> +	"S")
> +		SRCDIR="${OPTARG}"
> +		;;
> +	*)
> +		print_help
> +		;;
> +	esac
> +done
> +
> +if [ "${OVERRIDE_PATH}" -gt 0 ]; then
> +	PATH="${SCRIPT_DIR}:${SCRIPT_DIR}/../repair/:${SCRIPT_DIR}/../db/:${SCRIPT_DIR}/../mkfs/:${PATH}"
> +	export PATH
> +fi
> +
> +TESTDIR="${DIR}/tests/"
> +TESTMNT="${DIR}/mnt/"
> +BASE_IMG="${DIR}/xfsfuzz.img"
> +
> +# Set up FS image
> +echo "+ create fs image"
> +umount "${TESTDIR}"
> +umount "${TESTMNT}"
> +rm -rf "${TESTDIR}"
> +rm -rf "${TESTMNT}"
> +mkdir -p "${TESTDIR}"
> +mkdir -p "${TESTMNT}"
> +rm -rf "${BASE_IMG}"
> +truncate -s "${SZ}" "${BASE_IMG}"
> +mkfs.xfs -f ${FEATURES} -b "size=${BLK_SZ}" -i "size=${INODE_SZ}" "${BASE_IMG}"
> +if [ $? -ne 0 ]; then
> +	exit $?
> +fi
> +
> +# Populate FS image
> +echo "+ populate fs image"
> +modprobe loop
> +mount "${BASE_IMG}" "${TESTMNT}" -o loop
> +if [ $? -ne 0 ]; then
> +	exit $?
> +fi
> +SRC_SZ="$(du -ks "${SRCDIR}" | awk '{print $1}')"
> +FS_SZ="$(( $(stat -f "${TESTMNT}" -c '%a * %S') / 1024 ))"
> +NR="$(( (FS_SZ * 6 / 10) / SRC_SZ ))"
> +if [ "${NR}" -lt 1 ]; then
> +	NR=1
> +fi
> +echo "+ make ${NR} copies"
> +seq 1 "${NR}" | while read nr; do
> +	cp -pRdu "${SRCDIR}" "${TESTMNT}/test.${nr}" 2> /dev/null
> +done
> +umount "${TESTMNT}"
> +xfs_repair ${XFS_REPAIR_OPTS} -vn "${BASE_IMG}"
> +if [ $? -ne 0 ]; then
> +	echo "fsck failed??"
> +	exit 1
> +fi
> +
> +# Run tests
> +echo "+ run test"
> +ret=0
> +seq 1 "${PASSES}" | while read pass; do
> +	echo "+ pass ${pass}"
> +	PASS_IMG="${TESTDIR}/xfsfuzz-${pass}.img"
> +	FSCK_IMG="${TESTDIR}/xfsfuzz-${pass}.fsck"
> +	FUZZ_LOG="${TESTDIR}/xfsfuzz-${pass}.fuzz.log"
> +	OPS_LOG="${TESTDIR}/xfsfuzz-${pass}.ops.log"
> +
> +	echo "++ copy image"
> +	cp "${BASE_IMG}" "${PASS_IMG}"
> +	if [ $? -ne 0 ]; then
> +		exit $?
> +	fi
> +	xfs_db -x -c "label xfsfuzz-${pass}" "${PASS_IMG}"
> +
> +	echo "++ corrupt image"
> +	xfs_db -x -c blockget -c "blocktrash ${FUZZ_ARGS}" "${PASS_IMG}" > "${FUZZ_LOG}"
> +#	res=$?
> +#	if [ "${res}" -ne 0 ]; then
> +#		echo "blocktrash returns ${res}"
> +#		exit "${res}"
> +#	fi
> +
> +	echo "++ mount image"
> +	mount "${PASS_IMG}" "${TESTMNT}" -o loop
> +	res=$?
> +
> +	if [ "${res}" -eq 0 ]; then
> +		echo "+++ ls -laR"
> +		ls -laR "${TESTMNT}/test.1/" > /dev/null 2> "${OPS_LOG}"
> +
> +		echo "+++ cat files"
> +		find "${TESTMNT}/test.1/" -type f -size -1048576k -print0 | xargs -0 cat > /dev/null 2>> "${OPS_LOG}"
> +
> +		echo "+++ expand"
> +		find "${TESTMNT}/" -type f 2> /dev/null | head -n 50000 | while read f; do
> +			attr -l "$f" > /dev/null 2>> "${OPS_LOG}"
> +			if [ -f "$f" -a -w "$f" ]; then
> +				dd if=/dev/zero bs="${BLK_SZ}" count=1 >> "$f" 2>> "${OPS_LOG}"
> +			fi
> +			mv "$f" "$f.longer" > /dev/null 2>> "${OPS_LOG}"
> +		done
> +		sync
> +
> +		echo "+++ create files"
> +		cp -pRdu "${SRCDIR}" "${TESTMNT}/test.moo" 2>> "${OPS_LOG}"
> +		sync
> +
> +		echo "+++ remove files"
> +		rm -rf "${TESTMNT}/test.moo" 2>> "${OPS_LOG}"
> +
> +		umount "${TESTMNT}"
> +		res=$?
> +		if [ "${res}" -ne 0 ]; then
> +			ret=1
> +			break
> +		fi
> +		sync
> +	fi
> +	if [ "${RUN_FSCK}" -gt 0 ]; then
> +		cp "${PASS_IMG}" "${FSCK_IMG}"
> +		pass_img_sz="$(stat -c '%s' "${PASS_IMG}")"
> +
> +		seq 1 "${MAX_FSCK}" | while read fsck_pass; do
> +			echo "++ fsck pass ${fsck_pass}: $(which xfs_repair) -v ${FSCK_IMG}"
> +			FSCK_LOG="${TESTDIR}/xfsfuzz-${pass}-${fsck_pass}.log"
> +			echo "repairing" > "${FSCK_LOG}"
> +			xfs_repair ${XFS_REPAIR_OPTS} -v "${FSCK_IMG}" >> "${FSCK_LOG}" 2>&1
> +			res=$?
> +			if [ "${res}" -eq 0 ]; then
> +				echo "reverify" >> "${FSCK_LOG}"
> +				xfs_repair ${XFS_REPAIR_OPTS} -v -n "${FSCK_IMG}" >> "${FSCK_LOG}" 2>&1
> +				res=$?
> +			fi
> +			echo "++ fsck returns ${res}"
> +			if [ "${res}" -eq 0 ]; then
> +				exit 0
> +			elif [ "${res}" -eq 2 ]; then
> +				# replay log?
> +				echo "replaying log" >> "${FSCK_LOG}"
> +				dmesg > /tmp/a
> +				mount "${FSCK_IMG}" "${TESTMNT}" -o loop
> +				res=$?
> +				if [ "${res}" -gt 0 ]; then
> +					echo "+++ zeroing log"
> +					echo "zeroing log" >> "${FSCK_LOG}"
> +					xfs_repair ${XFS_REPAIR_OPTS} -L -v "${FSCK_IMG}" >> "${FSCK_LOG}" 2>&1
> +				else
> +					umount "${TESTMNT}"
> +				fi
> +				dmesg > /tmp/b
> +				diff -u /tmp/a /tmp/b >> "${FSCK_LOG}"
> +			elif [ "${fsck_pass}" -eq "${MAX_FSCK}" ]; then
> +				echo "++ fsck did not fix in ${MAX_FSCK} passes."
> +				exit 1
> +			fi
> +			if [ "${fsck_pass}" -gt 1 ]; then
> +				diff -u "${TESTDIR}/xfsfuzz-${pass}-$((fsck_pass - 1)).log" "${FSCK_LOG}"
> +				if [ $? -eq 0 ]; then
> +					echo "++ fsck makes no progress"
> +					exit 2
> +				fi
> +			fi
> +
> +			fsck_img_sz="$(stat -c '%s' "${FSCK_IMG}")"
> +			if [ "${fsck_img_sz}" -ne "${pass_img_sz}" ]; then
> +				echo "++ fsck image size changed"
> +				exit 3
> +			fi
> +		done
> +		fsck_loop_ret=$?
> +		if [ "${fsck_loop_ret}" -gt 0 ]; then
> +			break;
> +		fi
> +	fi
> +
> +	echo "+++ check fs for round 2"
> +	FSCK_LOG="${TESTDIR}/xfsfuzz-${pass}-round2.log"
> +	xfs_repair ${XFS_REPAIR_OPTS} -v -n "${FSCK_IMG}" > "${FSCK_LOG}" 2>&1
> +	res=$?
> +	if [ "${res}" -ne 0 ]; then
> +		echo "++++ fsck failed."
> +		exit 1
> +	fi
> +
> +	echo "++ mount image (2)"
> +	mount "${FSCK_IMG}" "${TESTMNT}" -o loop
> +	res=$?
> +
> +	if [ "${res}" -eq 0 ]; then
> +		echo "+++ ls -laR (2)"
> +		ls -laR "${TESTMNT}/test.1/" > /dev/null 2> "${OPS_LOG}"
> +
> +		echo "+++ cat files (2)"
> +		find "${TESTMNT}/test.1/" -type f -size -1048576k -print0 | xargs -0 cat > /dev/null 2>> "${OPS_LOG}"
> +
> +		echo "+++ expand (2)"
> +		find "${TESTMNT}/" -type f 2> /dev/null | head -n 50000 | while read f; do
> +			attr -l "$f" > /dev/null 2>> "${OPS_LOG}"
> +			if [ -f "$f" -a -w "$f" ]; then
> +				dd if=/dev/zero bs="${BLK_SZ}" count=1 >> "$f" 2>> "${OPS_LOG}"
> +			fi
> +			mv "$f" "$f.longer" > /dev/null 2>> "${OPS_LOG}"
> +		done
> +		sync
> +
> +		echo "+++ create files (2)"
> +		cp -pRdu "${SRCDIR}" "${TESTMNT}/test.moo" 2>> "${OPS_LOG}"
> +		sync
> +
> +		echo "+++ remove files (2)"
> +		rm -rf "${TESTMNT}/test.moo" 2>> "${OPS_LOG}"
> +
> +		umount "${TESTMNT}"
> +		res=$?
> +		if [ "${res}" -ne 0 ]; then
> +			ret=1
> +			break
> +		fi
> +		sync
> +
> +		echo "+++ check fs (2)"
> +		xfs_repair ${XFS_REPAIR_OPTS} -v -n "${FSCK_IMG}" >> "${FSCK_LOG}" 2>&1
> +		res=$?
> +		if [ "${res}" -ne 0 ]; then
> +			echo "++++ fsck failed."
> +			exit 1
> +		fi
> +	else
> +		echo "++ mount(2) failed with ${res}"
> +		exit 1
> +	fi
> +	rm -rf "${FSCK_IMG}" "${PASS_IMG}" "${FUZZ_LOG}" "${TESTDIR}"/xfsfuzz*.log
> +done
> +
> +exit $ret
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
