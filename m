Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8508ECE58C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 01:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D49D21479
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 01:03:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YJBhpsa/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbfJHBDf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 21:03:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58044 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbfJHBDf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Oct 2019 21:03:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x980xM21190786;
        Tue, 8 Oct 2019 01:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=gHQY9KWNJbUZfPmD+jF+V2FHrj0k0SEVSRngRx/Odvg=;
 b=YJBhpsa/ZLFrO/S9dJihonGuqvwpJsODNGO83b/LtwbcWxpq2Umqpsuv0MXu/cFJyzH5
 FsJVwtNLmASI74LfANSTw4KlqbT1E6hCbGk98+iyZDrvGwcyAS/dGBxkXD8YZor5vN90
 qRwkIj8ZkHVc2iRxKqBtzpqLL1CkgIIFS0+QNGzsBN21BWUocvLhoW1SdnIjRVUM07FL
 TXbydBqwahaNOhXM+noawh0RpOWv/gfJ8Zb6tW0nGwn7/XWGs2KqUVAueCSYOaxdtr5f
 pRjU41gUEc+BexBKTGReUzCz+Rlyw3Xli0DIC1tryckSVEvgDYyfYt1XWx2jlfiUZ76U aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vek4qa4gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 01:03:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x980wD2j007450;
        Tue, 8 Oct 2019 01:03:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vg1yuy2wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 01:03:32 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9813V9h011192;
        Tue, 8 Oct 2019 01:03:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Oct 2019 01:03:30 +0000
Subject: [PATCH 4/4] populate: punch files after writing to fragment free
 space properly
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 07 Oct 2019 18:03:29 -0700
Message-ID: <157049660991.2397321.6295105033631507023.stgit@magnolia>
In-Reply-To: <157049658503.2397321.13914737091290093511.stgit@magnolia>
References: <157049658503.2397321.13914737091290093511.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910080009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910080009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The filesystem population code frequently allocates a large file and
punches out every other block ("swiss-cheese files") in an attempt to
cause the creation of a lot of metadata to fill out the btrees.  This
pattern, however, has a subtle bug if the writes to the swiss-cheese
file are not allocated in batches and we're trying to fragment the free
space records in order to achieve a certain metadata btree shape.

This is exactly what happens on a DAX filesystem, since we no longer
have the page cache to stage delalloc writes.  Each xfs_io pwrite call
to the multi-megabyte swiss-chese file turns into multiple 4k pwrites,
which means that file data blocks are allocated 4k at a time.  This can
be fatal to our goal of fragmenting the free space btrees because the
allocator sees a 4k allocation request and uses 4k blocks from the
fragmented parts of the free space to satisfy the "small" request.  When
this happens, the XFS populate function cannot fill out the free space
btree to sufficient height and tests fail.

(In regular delalloc mode we'd cache all those small write() in memory
and try for a single large allocation, which we'd generally get.)

To fix this, we need to force the filesystem to allocate all blocks
before freeing any blocks.  Split the creation of swiss-cheese files
into two parts: (a) writing data to the file to force allocation, and
(b) punching the holes to fragment free space.  It's a little hokey for
helpers to be modifying variables in the caller's scope, but there's not
really a better way to do that in bash.

This bug affects only XFS but we convert the one ext4 usage anyway.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |   54 ++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 42 insertions(+), 12 deletions(-)


diff --git a/common/populate b/common/populate
index 7403dec3..4aab0274 100644
--- a/common/populate
+++ b/common/populate
@@ -120,6 +120,32 @@ _populate_xfs_qmount_option()
 	fi
 }
 
+# Set up a file that we'll later use to fragment metadata and free space.
+# Our strategy here is to force the fs to allocate large contiguous extents
+# to a file and then punch every other block to force the fs to suffer the
+# worst allocation outcome possible.
+#
+# NOTE: In order to prevent *subsequent* allocations from using the holes we
+# punch, we must store the relevant filenames for later.  This function
+# deliberately adds each file name to the @punch_files array, which must be
+# declared by the caller and will be picked up by __force_fragmentation.
+function __setup_fragmentation() {
+	local sz="$1"
+	local fname="$2"
+
+	$XFS_IO_PROG -f -c "pwrite -S 0x62 -W -b 1m 0 $sz" "${fname}"
+	punch_files+=("${fname}")
+}
+
+# Actually punch holes in the file.  Call this /after/ you're done calling
+# __setup_fragmentation.
+__force_fragmentation() {
+	for file in "${punch_files[@]}"; do
+		./src/punch-alternating "${file}"
+	done
+	punch_files=()
+}
+
 # Populate an XFS on the scratch device with (we hope) all known
 # types of metadata block
 _scratch_xfs_populate() {
@@ -132,6 +158,8 @@ _scratch_xfs_populate() {
 		esac
 	done
 
+	local punch_files=()
+
 	_populate_xfs_qmount_option
 	_scratch_mount
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
@@ -161,8 +189,7 @@ _scratch_xfs_populate() {
 	# - FMT_BTREE
 	echo "+ btree extents file"
 	nr="$((blksz * 2 / 16))"
-	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/S_IFREG.FMT_BTREE"
-	./src/punch-alternating "${SCRATCH_MNT}/S_IFREG.FMT_BTREE"
+	__setup_fragmentation $((blksz * nr)) "${SCRATCH_MNT}/S_IFREG.FMT_BTREE"
 
 	# Directories
 	# - INLINE
@@ -257,8 +284,7 @@ _scratch_xfs_populate() {
 	# Free space btree
 	echo "+ freesp btree"
 	nr="$((blksz * 2 / 8))"
-	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/BNOBT"
-	./src/punch-alternating "${SCRATCH_MNT}/BNOBT"
+	__setup_fragmentation $((blksz * nr)) "${SCRATCH_MNT}/BNOBT"
 
 	# Inode btree
 	echo "+ inobt btree"
@@ -280,8 +306,7 @@ _scratch_xfs_populate() {
 	if [ $is_rmapbt -gt 0 ]; then
 		echo "+ rmapbt btree"
 		nr="$((blksz * 2 / 24))"
-		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/RMAPBT"
-		./src/punch-alternating "${SCRATCH_MNT}/RMAPBT"
+		__setup_fragmentation $((blksz * nr)) "${SCRATCH_MNT}/RMAPBT"
 	fi
 
 	# Realtime Reverse-mapping btree
@@ -289,8 +314,7 @@ _scratch_xfs_populate() {
 	if [ $is_rmapbt -gt 0 ] && [ $is_rt -gt 0 ]; then
 		echo "+ rtrmapbt btree"
 		nr="$((blksz * 2 / 32))"
-		$XFS_IO_PROG -f -R -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/RTRMAPBT"
-		./src/punch-alternating "${SCRATCH_MNT}/RTRMAPBT"
+		__setup_fragmentation $((blksz * nr)) "${SCRATCH_MNT}/RTRMAPBT"
 	fi
 
 	# Reference-count btree
@@ -298,15 +322,17 @@ _scratch_xfs_populate() {
 	if [ $is_reflink -gt 0 ]; then
 		echo "+ reflink btree"
 		nr="$((blksz * 2 / 12))"
-		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/REFCOUNTBT"
+		__setup_fragmentation $((blksz * nr)) "${SCRATCH_MNT}/REFCOUNTBT"
 		cp --reflink=always "${SCRATCH_MNT}/REFCOUNTBT" "${SCRATCH_MNT}/REFCOUNTBT2"
-		./src/punch-alternating "${SCRATCH_MNT}/REFCOUNTBT"
 	fi
 
 	# Copy some real files (xfs tests, I guess...)
 	echo "+ real files"
 	test $fill -ne 0 && __populate_fill_fs "${SCRATCH_MNT}" 5
 
+	# Make sure we get all the fragmentation we asked for
+	__force_fragmentation
+
 	umount "${SCRATCH_MNT}"
 }
 
@@ -322,6 +348,8 @@ _scratch_ext4_populate() {
 		esac
 	done
 
+	local punch_files=()
+
 	_scratch_mount
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 	dblksz="${blksz}"
@@ -342,8 +370,7 @@ _scratch_ext4_populate() {
 	# - FMT_ETREE
 	echo "+ extent tree file"
 	nr="$((blksz * 2 / 12))"
-	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/S_IFREG.FMT_ETREE"
-	./src/punch-alternating "${SCRATCH_MNT}/S_IFREG.FMT_ETREE"
+	__setup_fragmentation $((blksz * nr)) "${SCRATCH_MNT}/S_IFREG.FMT_ETREE"
 
 	# Directories
 	# - INLINE
@@ -406,6 +433,9 @@ _scratch_ext4_populate() {
 	echo "+ real files"
 	test $fill -ne 0 && __populate_fill_fs "${SCRATCH_MNT}" 5
 
+	# Make sure we get all the fragmentation we asked for
+	__force_fragmentation
+
 	umount "${SCRATCH_MNT}"
 }
 

