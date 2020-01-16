Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62272C3F68F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F5DA2077B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:11:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QUHaRKrB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgAPFLd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 00:11:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45484 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgAPFLd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 00:11:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G59NcG154729;
        Thu, 16 Jan 2020 05:11:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rdAu31jvy3SuwtjMjFIJaLMclrspNsPP944IY33mKCA=;
 b=QUHaRKrBIghzLA5LAPueURvxR/aNPb97CQznGOwhLESs/b7R5rFs8vFUXwB0XCpVLt5T
 oM/9FcMDdk80DgkwagHprLqBQWZ4F7d8anaFSbYVnL87heSu9L46Dbpbvly8OKABZW4I
 fGSxRHe6QVfRzT/Pn3GhbFxYub4n83JBPULTtpoj9PQKkxV2ls9BCq4nTlhXdrEnCFGP
 8egZ94c7RdQriQB0jYfJTn3gLV8d/yBWBf/9ldZa1j3D0Ycn4tJUzFlYbJJKHom+hh9/
 7kyycVeFWccbbvtUf7HY3cI5TBbvIrW/tNLnkhynVWVtnlMPHQoXbgjbLHdZnBoLlUSn hA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xf73u04r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:11:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G59Caj102566;
        Thu, 16 Jan 2020 05:11:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xj61kwx19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:11:29 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00G5BTLW010521;
        Thu, 16 Jan 2020 05:11:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 21:11:28 -0800
Subject: [PATCH 1/1] xfs: test xfs_scrub phase 6 media error reporting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Wed, 15 Jan 2020 21:11:27 -0800
Message-ID: <157915148790.2375066.13411168728676634865.stgit@magnolia>
In-Reply-To: <157915148163.2375066.10400037630417570964.stgit@magnolia>
References: <157915148163.2375066.10400037630417570964.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add new helpers to dmerror to provide for marking selected ranges
totally bad -- both reads and writes will fail.  Create a new test for
xfs_scrub to check that it reports media errors correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/dmerror    |  107 +++++++++++++++++++++++++++++++++++++++++-
 tests/xfs/747     |  136 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/747.out |   12 +++++
 tests/xfs/748     |  105 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/748.out |    5 ++
 tests/xfs/group   |    2 +
 6 files changed, 366 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/747
 create mode 100644 tests/xfs/747.out
 create mode 100755 tests/xfs/748
 create mode 100644 tests/xfs/748.out


diff --git a/common/dmerror b/common/dmerror
index 426f1e96..3eb7a2d7 100644
--- a/common/dmerror
+++ b/common/dmerror
@@ -65,7 +65,7 @@ _dmerror_load_error_table()
 	$DMSETUP_PROG suspend $suspend_opt error-test
 	[ $? -ne 0 ] && _fail  "dmsetup suspend failed"
 
-	$DMSETUP_PROG load error-test --table "$DMERROR_TABLE"
+	echo "$DMERROR_TABLE" | $DMSETUP_PROG load error-test
 	load_res=$?
 
 	$DMSETUP_PROG resume error-test
@@ -100,3 +100,108 @@ _dmerror_load_working_table()
 	[ $load_res -ne 0 ] && _fail "dmsetup failed to load error table"
 	[ $resume_res -ne 0 ] && _fail  "dmsetup resume failed"
 }
+
+# Given a list of (start, length) tuples on stdin, combine adjacent tuples into
+# larger ones and write the new list to stdout.
+__dmerror_combine_extents()
+{
+	awk 'BEGIN{start = 0; len = 0;}{
+if (start + len == $1) {
+	len += $2;
+} else {
+	if (len > 0)
+		printf("%d %d\n", start, len);
+	start = $1;
+	len = $2;
+}
+} END {
+	if (len > 0)
+		printf("%d %d\n", start, len);
+}'
+}
+
+# Given a block device, the name of a preferred dm target, the name of an
+# implied dm target, and a list of (start, len) tuples on stdin, create a new
+# dm table which maps each of the tuples to the preferred target and all other
+# areas to the implied dm target.
+__dmerror_recreate_map()
+{
+	local device="$1"
+	local preferred_tgt="$2"
+	local implied_tgt="$3"
+	local size=$(blockdev --getsz "$device")
+
+	awk -v device="$device" -v size=$size -v implied_tgt="$implied_tgt" \
+		-v preferred_tgt="$preferred_tgt" 'BEGIN{implied_start = 0;}{
+	extent_start = $1;
+	extent_len = $2;
+
+	if (extent_start > size) {
+		extent_start = size;
+		extent_len = 0;
+	} else if (extent_start + extent_len > size) {
+		extent_len = size - extent_start;
+	}
+
+	if (implied_start < extent_start)
+		printf("%d %d %s %s %d\n", implied_start,
+				extent_start - implied_start, implied_tgt,
+				device, implied_start);
+	printf("%d %d %s %s %d\n", extent_start, extent_len, preferred_tgt,
+			device, extent_start);
+	implied_start = extent_start + extent_len;
+}END{
+	if (implied_start < size)
+		printf("%d %d %s %s %d\n", implied_start, size - implied_start,
+				implied_tgt, device, implied_start);
+}'
+}
+
+# Update the dm error table so that the range (start, len) maps to the
+# preferred dm target, overriding anything that maps to the implied dm target.
+# This assumes that the only desired targets for this dm device are the
+# preferred and and implied targets.  The optional fifth argument can be used
+# to change the underlying device.
+__dmerror_change()
+{
+	local start="$1"
+	local len="$2"
+	local preferred_tgt="$3"
+	local implied_tgt="$4"
+	local dm_backing_dev="$5"
+	test -z "$dm_backing_dev" && dm_backing_dev="$SCRATCH_DEV"
+
+	DMERROR_TABLE="$( (echo "$DMERROR_TABLE"; echo "$start $len $preferred_tgt") | \
+		awk -v type="$preferred_tgt" '{if ($3 == type) print $0;}' | \
+		sort -g | \
+		__dmerror_combine_extents | \
+		__dmerror_recreate_map "$dm_backing_dev" "$preferred_tgt" \
+				"$implied_tgt" )"
+}
+
+# Reset the dm error table to everything ok.  The dm device itself must be
+# remapped by calling _dmerror_load_error_table.
+_dmerror_reset_table()
+{
+	DMERROR_TABLE="$DMLINEAR_TABLE"
+}
+
+# Update the dm error table so that IOs to the given range will return EIO.
+# The dm device itself must be remapped by calling _dmerror_load_error_table.
+_dmerror_mark_range_bad()
+{
+	local start="$1"
+	local len="$2"
+
+	__dmerror_change "$start" "$len" error linear
+}
+
+# Update the dm error table so that IOs to the given range will succeed.
+# The dm device itself must be remapped by calling _dmerror_load_error_table.
+_dmerror_mark_range_good()
+{
+	local start="$1"
+	local len="$2"
+
+	__dmerror_change "$start" "$len" linear error
+}
diff --git a/tests/xfs/747 b/tests/xfs/747
new file mode 100755
index 00000000..0fd666c3
--- /dev/null
+++ b/tests/xfs/747
@@ -0,0 +1,136 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 747
+#
+# Check xfs_scrub's media scan can actually return diagnostic information for
+# media errors in file data extents.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	_dmerror_cleanup
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/fuzzy
+. ./common/filter
+. ./common/dmerror
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_dm_target error
+_require_scratch_xfs_crc
+_require_scrub
+
+rm -f $seqres.full
+
+filter_scrub_errors() {
+	_filter_scratch | sed -e "s/offset $((blksz * 2)) /offset 2FSB /g" \
+		-e "s/length $blksz.*/length 1FSB./g"
+}
+
+_scratch_mkfs > $tmp.mkfs
+_dmerror_init
+_dmerror_mount >> $seqres.full 2>&1
+
+_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || _notrun "Scrub not supported"
+
+victim=$SCRATCH_MNT/a
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 1m" -c "fsync" $victim >> $seqres.full
+bmap_str="$($XFS_IO_PROG -c "bmap -elpv" $victim | grep "^[[:space:]]*0:")"
+echo "$bmap_str" >> $seqres.full
+
+phys="$(echo "$bmap_str" | $AWK_PROG '{print $3}')"
+len="$(echo "$bmap_str" | $AWK_PROG '{print $6}')"
+blksz=$(_get_file_block_size $SCRATCH_MNT)
+sectors_per_block=$((blksz / 512))
+
+# Did we get at least 4 fs blocks worth of extent?
+min_len_sectors=$(( 4 * sectors_per_block ))
+test "$len" -lt $min_len_sectors && \
+	_fail "could not format a long enough extent on an empty fs??"
+
+phys_start=$(echo "$phys" | sed -e 's/\.\..*//g')
+
+
+echo ":$phys:$len:$blksz:$phys_start" >> $seqres.full
+echo "victim file:" >> $seqres.full
+od -tx1 -Ad -c $victim >> $seqres.full
+
+# Reset the dmerror table so that all IO will pass through.
+_dmerror_reset_table
+
+cat >> $seqres.full << ENDL
+dmerror before:
+$DMERROR_TABLE
+<end table>
+ENDL
+
+# Now mark /only/ the middle of the extent bad.
+_dmerror_mark_range_bad $(( phys_start + (2 * sectors_per_block) + 1 )) 1
+
+cat >> $seqres.full << ENDL
+dmerror after marking bad:
+$DMERROR_TABLE
+<end table>
+ENDL
+
+_dmerror_load_error_table
+
+# See if the media scan picks it up.
+echo "Scrub for injected media error (single threaded)"
+
+# Once in single-threaded mode
+_scratch_scrub -b -x >> $seqres.full 2> $tmp.error
+cat $tmp.error | filter_scrub_errors
+
+# Once in parallel mode
+echo "Scrub for injected media error (multi threaded)"
+_scratch_scrub -x >> $seqres.full 2> $tmp.error
+cat $tmp.error | filter_scrub_errors
+
+# Remount to flush the page cache and reread to see the IO error
+_dmerror_unmount
+_dmerror_mount
+echo "victim file:" >> $seqres.full
+od -tx1 -Ad -c $victim >> $seqres.full 2> $tmp.error
+cat $tmp.error | _filter_scratch
+
+# Scrub again to re-confirm the media error across a remount
+echo "Scrub for injected media error (after remount)"
+_scratch_scrub -x >> $seqres.full 2> $tmp.error
+cat $tmp.error | filter_scrub_errors
+
+# Now mark the bad range good.
+_dmerror_mark_range_good $(( phys_start + (2 * sectors_per_block) + 1 )) 1
+_dmerror_load_error_table
+
+cat >> $seqres.full << ENDL
+dmerror after marking good:
+$DMERROR_TABLE
+<end table>
+ENDL
+
+echo "Scrub after removing injected media error"
+
+# Scrub one last time to make sure the error's gone.
+_scratch_scrub -x >> $seqres.full 2> $tmp.error
+cat $tmp.error | filter_scrub_errors
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/747.out b/tests/xfs/747.out
new file mode 100644
index 00000000..f85f1753
--- /dev/null
+++ b/tests/xfs/747.out
@@ -0,0 +1,12 @@
+QA output created by 747
+Scrub for injected media error (single threaded)
+Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
+SCRATCH_MNT: unfixable errors found: 1
+Scrub for injected media error (multi threaded)
+Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
+SCRATCH_MNT: unfixable errors found: 1
+od: SCRATCH_MNT/a: read error: Input/output error
+Scrub for injected media error (after remount)
+Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
+SCRATCH_MNT: unfixable errors found: 1
+Scrub after removing injected media error
diff --git a/tests/xfs/748 b/tests/xfs/748
new file mode 100755
index 00000000..0168b1ee
--- /dev/null
+++ b/tests/xfs/748
@@ -0,0 +1,105 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 748
+#
+# Check xfs_scrub's media scan can actually return diagnostic information for
+# media errors in filesystem metadata.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	_dmerror_cleanup
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/fuzzy
+. ./common/filter
+. ./common/dmerror
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_dm_target error
+
+# rmapbt is required to enable reporting of what metadata was lost.
+_require_xfs_scratch_rmapbt
+
+_require_scrub
+
+rm -f $seqres.full
+
+filter_scrub_errors() {
+	_filter_scratch | sed -e "s/disk offset [0-9]*: /disk offset NNN: /g" \
+		-e "/errors found:/d" -e 's/phase6.c line [0-9]*/!/g' \
+		-e "/corruptions found:/d" | uniq
+}
+
+_scratch_mkfs > $tmp.mkfs
+_dmerror_init
+_dmerror_mount >> $seqres.full 2>&1
+
+_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || _notrun "Scrub not supported"
+
+# Create a bunch of metadata so that we can mark them bad in the next step.
+victim=$SCRATCH_MNT/a
+$FSSTRESS_PROG -z -n 200 -p 10 \
+	       -f creat=10 \
+	       -f resvsp=1 \
+	       -f truncate=1 \
+	       -f punch=1 \
+	       -f chown=5 \
+	       -f mkdir=5 \
+	       -f mknod=1 \
+	       -d $victim >> $seqres.full 2>&1
+
+# Mark all the metadata bad
+_dmerror_reset_table
+$XFS_IO_PROG -c "fsmap -n100 -vvv" $victim | grep inodes > $tmp.fsmap
+while read a b c crap; do
+	phys="$(echo $c | sed -e 's/^.\([0-9]*\)\.\.\([0-9]*\).*$/\1:\2/g')"
+	target_begin="$(echo "$phys" | cut -d ':' -f 1)"
+	target_end="$(echo "$phys" | cut -d ':' -f 2)"
+
+	_dmerror_mark_range_bad $target_begin $((target_end - target_begin))
+done < $tmp.fsmap
+cat $tmp.fsmap >> $seqres.full
+
+cat >> $seqres.full << ENDL
+dmerror after marking bad:
+$DMERROR_TABLE
+<end table>
+ENDL
+
+_dmerror_load_error_table
+
+# See if the media scan picks it up.
+echo "Scrub for injected media error"
+
+XFS_SCRUB_PHASE=6 _scratch_scrub -x >> $seqres.full 2> $tmp.error
+cat $tmp.error | filter_scrub_errors
+
+# Make the disk work again
+_dmerror_load_working_table
+
+echo "Scrub after removing injected media error"
+
+# Scrub one last time to make sure the error's gone.
+XFS_SCRUB_PHASE=6 _scratch_scrub -x >> $seqres.full 2> $tmp.error
+cat $tmp.error | filter_scrub_errors
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/748.out b/tests/xfs/748.out
new file mode 100644
index 00000000..49dc2d7a
--- /dev/null
+++ b/tests/xfs/748.out
@@ -0,0 +1,5 @@
+QA output created by 748
+Scrub for injected media error
+Corruption: disk offset NNN: media error in inodes. (!)
+SCRATCH_MNT: Unmount and run xfs_repair.
+Scrub after removing injected media error
diff --git a/tests/xfs/group b/tests/xfs/group
index c7253cf1..a6c9ef08 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -509,3 +509,5 @@
 509 auto ioctl
 510 auto ioctl quick
 511 auto quick quota
+747 auto quick scrub
+748 auto quick scrub

