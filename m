Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 638DEECE58C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 18:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AE2721848
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 18:18:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AQFTcNke"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbfJISS6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 14:18:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36782 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729883AbfJISS6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 14:18:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99I46XM092360;
        Wed, 9 Oct 2019 18:18:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=osUE0NssYzSEaGZkcfWTThXzR+zrodabuOdA0KZEGPQ=;
 b=AQFTcNkeHOq/tzRgN6ED7w1L3f5VOl+WcSzI7Vqj6690JMvOS5Cn9r4HtKxzEeWZiHl9
 i5laSqZ8OX5Pq5XsNEeo9aEgQPC56Tny2fXlepNvC0Jq8kVQsheT3OYhcBolsE6N8XRp
 HKASIywQ4bXyzs4SMZ5XRKSzShT65K4e+X/uGa9gJGYO01BpwceVN+X1Jj99gdLvLlwF
 2/kH7Ylgdn5XJ5q4RVzANjxd2QJQgeInjtt/m5wvCkQXTPHOpk8/PabUL8MHCevNADAV
 AM0Mpquba3ld76juGy7LCldcoHvmhJsVKMRnS3ruEjWhJF0KMW7DOqUCj6ouVZfo8HyI FQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vektrp83w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Oct 2019 18:18:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99I7f7x192931;
        Wed, 9 Oct 2019 18:18:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vhhsn2pds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Oct 2019 18:18:50 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x99IInVd024287;
        Wed, 9 Oct 2019 18:18:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 11:18:49 -0700
Date:   Wed, 9 Oct 2019 11:18:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        hch@infradead.org
Subject: [PATCH v2 4/4] populate: punch files after writing to fragment free
 space properly
Message-ID: <20191009181848.GG13097@magnolia>
References: <157049658503.2397321.13914737091290093511.stgit@magnolia>
 <157049660991.2397321.6295105033631507023.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157049660991.2397321.6295105033631507023.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090151
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
(b) punching the holes to fragment free space.

This bug affects only XFS but we convert the one ext4 usage anyway.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: don't do the weird array side effect thing per hch suggestion
---
 common/populate |   54 +++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 15 deletions(-)

diff --git a/common/populate b/common/populate
index 7403dec3..f2953a67 100644
--- a/common/populate
+++ b/common/populate
@@ -22,6 +22,26 @@ _require_xfs_db_blocktrash_z_command() {
 # Attempt to make files of "every" format for data, dirs, attrs etc.
 # (with apologies to Eric Sandeen for mutating xfser.sh)
 
+# Create a file of a given size.
+__populate_create_file() {
+	local sz="$1"
+	local fname="$2"
+
+	$XFS_IO_PROG -f -c "pwrite -S 0x62 -W -b 1m 0 $sz" "${fname}"
+}
+
+# Punch out every other hole in this file, if it exists.
+#
+# The goal here is to force the creation of a large number of metadata records
+# by creating a lot of tiny extent mappings in a file.  Callers should ensure
+# that fragmenting the file actually causes record creation.  Call this
+# function /after/ creating all other metadata structures.
+__populate_fragment_file() {
+	local fname="$1"
+
+	test -f "${fname}" && ./src/punch-alternating "${fname}"
+}
+
 # Create a large directory
 __populate_create_dir() {
 	name="$1"
@@ -156,13 +176,12 @@ _scratch_xfs_populate() {
 	# Regular files
 	# - FMT_EXTENTS
 	echo "+ extents file"
-	$XFS_IO_PROG -f -c "pwrite -S 0x61 0 ${blksz}" "${SCRATCH_MNT}/S_IFREG.FMT_EXTENTS"
+	__populate_create_file $blksz "${SCRATCH_MNT}/S_IFREG.FMT_EXTENTS"
 
 	# - FMT_BTREE
 	echo "+ btree extents file"
 	nr="$((blksz * 2 / 16))"
-	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/S_IFREG.FMT_BTREE"
-	./src/punch-alternating "${SCRATCH_MNT}/S_IFREG.FMT_BTREE"
+	__populate_create_file $((blksz * nr)) "${SCRATCH_MNT}/S_IFREG.FMT_BTREE"
 
 	# Directories
 	# - INLINE
@@ -257,8 +276,7 @@ _scratch_xfs_populate() {
 	# Free space btree
 	echo "+ freesp btree"
 	nr="$((blksz * 2 / 8))"
-	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/BNOBT"
-	./src/punch-alternating "${SCRATCH_MNT}/BNOBT"
+	__populate_create_file $((blksz * nr)) "${SCRATCH_MNT}/BNOBT"
 
 	# Inode btree
 	echo "+ inobt btree"
@@ -280,8 +298,7 @@ _scratch_xfs_populate() {
 	if [ $is_rmapbt -gt 0 ]; then
 		echo "+ rmapbt btree"
 		nr="$((blksz * 2 / 24))"
-		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/RMAPBT"
-		./src/punch-alternating "${SCRATCH_MNT}/RMAPBT"
+		__populate_create_file $((blksz * nr)) "${SCRATCH_MNT}/RMAPBT"
 	fi
 
 	# Realtime Reverse-mapping btree
@@ -289,8 +306,7 @@ _scratch_xfs_populate() {
 	if [ $is_rmapbt -gt 0 ] && [ $is_rt -gt 0 ]; then
 		echo "+ rtrmapbt btree"
 		nr="$((blksz * 2 / 32))"
-		$XFS_IO_PROG -f -R -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/RTRMAPBT"
-		./src/punch-alternating "${SCRATCH_MNT}/RTRMAPBT"
+		__populate_create_file $((blksz * nr)) "${SCRATCH_MNT}/RTRMAPBT"
 	fi
 
 	# Reference-count btree
@@ -298,15 +314,21 @@ _scratch_xfs_populate() {
 	if [ $is_reflink -gt 0 ]; then
 		echo "+ reflink btree"
 		nr="$((blksz * 2 / 12))"
-		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/REFCOUNTBT"
+		__populate_create_file $((blksz * nr)) "${SCRATCH_MNT}/REFCOUNTBT"
 		cp --reflink=always "${SCRATCH_MNT}/REFCOUNTBT" "${SCRATCH_MNT}/REFCOUNTBT2"
-		./src/punch-alternating "${SCRATCH_MNT}/REFCOUNTBT"
 	fi
 
 	# Copy some real files (xfs tests, I guess...)
 	echo "+ real files"
 	test $fill -ne 0 && __populate_fill_fs "${SCRATCH_MNT}" 5
 
+	# Make sure we get all the fragmentation we asked for
+	__populate_fragment_file "${SCRATCH_MNT}/S_IFREG.FMT_BTREE"
+	__populate_fragment_file "${SCRATCH_MNT}/BNOBT"
+	__populate_fragment_file "${SCRATCH_MNT}/RMAPBT"
+	__populate_fragment_file "${SCRATCH_MNT}/RTRMAPBT"
+	__populate_fragment_file "${SCRATCH_MNT}/REFCOUNTBT"
+
 	umount "${SCRATCH_MNT}"
 }
 
@@ -333,17 +355,16 @@ _scratch_ext4_populate() {
 	# Regular files
 	# - FMT_INLINE
 	echo "+ inline file"
-	$XFS_IO_PROG -f -c "pwrite -S 0x61 0 1" "${SCRATCH_MNT}/S_IFREG.FMT_INLINE"
+	__populate_create_file 1 "${SCRATCH_MNT}/S_IFREG.FMT_INLINE"
 
 	# - FMT_EXTENTS
 	echo "+ extents file"
-	$XFS_IO_PROG -f -c "pwrite -S 0x61 0 ${blksz}" "${SCRATCH_MNT}/S_IFREG.FMT_EXTENTS"
+	__populate_create_file $blksz "${SCRATCH_MNT}/S_IFREG.FMT_EXTENTS"
 
 	# - FMT_ETREE
 	echo "+ extent tree file"
 	nr="$((blksz * 2 / 12))"
-	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/S_IFREG.FMT_ETREE"
-	./src/punch-alternating "${SCRATCH_MNT}/S_IFREG.FMT_ETREE"
+	__populate_create_file $((blksz * nr)) "${SCRATCH_MNT}/S_IFREG.FMT_ETREE"
 
 	# Directories
 	# - INLINE
@@ -406,6 +427,9 @@ _scratch_ext4_populate() {
 	echo "+ real files"
 	test $fill -ne 0 && __populate_fill_fs "${SCRATCH_MNT}" 5
 
+	# Make sure we get all the fragmentation we asked for
+	__populate_fragment_file "${SCRATCH_MNT}/S_IFREG.FMT_ETREE"
+
 	umount "${SCRATCH_MNT}"
 }
 
