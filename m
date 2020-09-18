Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CA4C43465
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 02:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36DFC238E6
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 02:41:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RHeWMerw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgIRClJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:41:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51846 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbgIRCLW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 22:11:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I2AQUR100536;
        Fri, 18 Sep 2020 02:11:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=X1wYdPxklvpY0TUe/W3b2PxhiaH4nIQYooJnRGNGZu0=;
 b=RHeWMerwihdGbAABlVa4B7hdUS6iMLvasDvGbO/UgILiIf2zzQq+rFlOcY++iLVJQZ1H
 lLZprTQtVXYdOgyQHpS+U5OVUx9KgLVYyFiiMoK8M09BaUC6ZcufOCEGxjEr7WaRezth
 ZU7gQqAlMPNxx+b32HVLeXdVBBtTV/5HdPmc2muaEETLs7mgOn3AjSayNxgatRIVq6iO
 2tcXL0G0JAPuYY2qnPaGR9iDvSWYL5KvKInNTK8jKnKKPLUQZn8J30aAY1bo+QwIChQg
 255hMbG9h8MquMPPdOqIAQAo3MxcK5LpRsTyTy/vk5WXIjIvsa2Z2FSXthB/9hhUqC+S Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33j91dx7ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 02:11:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I24pDD167163;
        Fri, 18 Sep 2020 02:11:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33megag5vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 02:11:12 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08I2BBud018993;
        Fri, 18 Sep 2020 02:11:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 02:11:10 +0000
Date:   Thu, 17 Sep 2020 19:11:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 27/24] common/rc: fix indentation in _scratch_mkfs_sized
Message-ID: <20200918021109.GL7954@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=5 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180019
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix the weird indentation in _scratch_mkfs_sized.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc |  205 ++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 102 insertions(+), 103 deletions(-)

diff --git a/common/rc b/common/rc
index 3adeeefe..94936a8e 100644
--- a/common/rc
+++ b/common/rc
@@ -956,116 +956,115 @@ _available_memory_bytes()
 # _scratch_mkfs_sized <size in bytes> [optional blocksize]
 _scratch_mkfs_sized()
 {
-    local fssize=$1
-    local blocksize=$2
-    local def_blksz
+	local fssize=$1
+	local blocksize=$2
+	local def_blksz
 
-    case $FSTYP in
-    xfs)
-	def_blksz=`echo $MKFS_OPTIONS|sed -rn 's/.*-b ?size= ?+([0-9]+).*/\1/p'`
-	;;
-    ext2|ext3|ext4|ext4dev|udf|btrfs|reiser4|ocfs2|reiserfs)
-	def_blksz=`echo $MKFS_OPTIONS| sed -rn 's/.*-b ?+([0-9]+).*/\1/p'`
-	;;
-    jfs)
-	def_blksz=4096
-	;;
-    esac
+	case $FSTYP in
+	xfs)
+		def_blksz=`echo $MKFS_OPTIONS | sed -rn 's/.*-b ?size= ?+([0-9]+).*/\1/p'`
+		;;
+	ext2|ext3|ext4|ext4dev|udf|btrfs|reiser4|ocfs2|reiserfs)
+		def_blksz=`echo $MKFS_OPTIONS | sed -rn 's/.*-b ?+([0-9]+).*/\1/p'`
+		;;
+	jfs)
+		def_blksz=4096
+		;;
+	esac
 
-    [ -n "$def_blksz" ] && blocksize=$def_blksz
-    [ -z "$blocksize" ] && blocksize=4096
+	[ -n "$def_blksz" ] && blocksize=$def_blksz
+	[ -z "$blocksize" ] && blocksize=4096
 
+	local re='^[0-9]+$'
+	if ! [[ $fssize =~ $re ]] ; then
+		_notrun "error: _scratch_mkfs_sized: fs size \"$fssize\" not an integer."
+	fi
+	if ! [[ $blocksize =~ $re ]] ; then
+		_notrun "error: _scratch_mkfs_sized: block size \"$blocksize\" not an integer."
+	fi
 
-    local re='^[0-9]+$'
-    if ! [[ $fssize =~ $re ]] ; then
-        _notrun "error: _scratch_mkfs_sized: fs size \"$fssize\" not an integer."
-    fi
-    if ! [[ $blocksize =~ $re ]] ; then
-        _notrun "error: _scratch_mkfs_sized: block size \"$blocksize\" not an integer."
-    fi
-
-    local blocks=`expr $fssize / $blocksize`
-
-    if [ -b "$SCRATCH_DEV" ]; then
-	local devsize=`blockdev --getsize64 $SCRATCH_DEV`
-	[ "$fssize" -gt "$devsize" ] && _notrun "Scratch device too small"
-    fi
-
-    if [ "$FSTYP" = "xfs" ] && [ -b "$SCRATCH_RTDEV" ]; then
-	local rtdevsize=`blockdev --getsize64 $SCRATCH_RTDEV`
-	[ "$fssize" -gt "$rtdevsize" ] && _notrun "Scratch rt device too small"
-	rt_ops="-r size=$fssize"
-    fi
+	local blocks=`expr $fssize / $blocksize`
 
-    case $FSTYP in
-    xfs)
-	# don't override MKFS_OPTIONS that set a block size.
-	echo $MKFS_OPTIONS |egrep -q "b?size="
-	if [ $? -eq 0 ]; then
-		_scratch_mkfs_xfs -d size=$fssize $rt_ops
-	else
-		_scratch_mkfs_xfs -d size=$fssize $rt_ops -b size=$blocksize
-	fi
-	;;
-    ext2|ext3|ext4|ext4dev)
-	${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
-	;;
-    gfs2)
-	# mkfs.gfs2 doesn't automatically shrink journal files on small
-	# filesystems, so the journal files may end up being bigger than the
-	# filesystem, which will cause mkfs.gfs2 to fail.  Until that's fixed,
-	# shrink the journal size to at most one eigth of the filesystem and at
-	# least 8 MiB, the minimum size allowed.
-	local min_journal_size=8
-	local default_journal_size=128
-	if (( fssize/8 / (1024*1024) < default_journal_size )); then
-	    local journal_size=$(( fssize/8 / (1024*1024) ))
-	    (( journal_size >= min_journal_size )) || journal_size=$min_journal_size
-	    MKFS_OPTIONS="-J $journal_size $MKFS_OPTIONS"
+	if [ -b "$SCRATCH_DEV" ]; then
+		local devsize=`blockdev --getsize64 $SCRATCH_DEV`
+		[ "$fssize" -gt "$devsize" ] && _notrun "Scratch device too small"
 	fi
-	${MKFS_PROG}.$FSTYP $MKFS_OPTIONS -O -b $blocksize $SCRATCH_DEV $blocks
-	;;
-    ocfs2)
-	yes | ${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
-	;;
-    udf)
-	$MKFS_UDF_PROG $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
-	;;
-    btrfs)
-	local mixed_opt=
-	# minimum size that's needed without the mixed option.
-	# Ref: btrfs-prog: btrfs_min_dev_size()
-	# Non mixed mode is also the default option.
-	(( fssize < $((256 * 1024 *1024)) )) && mixed_opt='--mixed'
-	$MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize $SCRATCH_DEV
-	;;
-    jfs)
-	${MKFS_PROG}.$FSTYP $MKFS_OPTIONS $SCRATCH_DEV $blocks
-	;;
-    reiserfs)
-	${MKFS_PROG}.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
-	;;
-    reiser4)
-	# mkfs.resier4 requires size in KB as input for creating filesystem
-	$MKFS_REISER4_PROG $MKFS_OPTIONS -y -b $blocksize $SCRATCH_DEV \
-			   `expr $fssize / 1024`
-	;;
-    f2fs)
-	# mkfs.f2fs requires # of sectors as an input for the size
-	local sector_size=`blockdev --getss $SCRATCH_DEV`
-	$MKFS_F2FS_PROG $MKFS_OPTIONS $SCRATCH_DEV `expr $fssize / $sector_size`
-	;;
-    tmpfs)
-	local free_mem=`_free_memory_bytes`
-	if [ "$free_mem" -lt "$fssize" ] ; then
-	   _notrun "Not enough memory ($free_mem) for tmpfs with $fssize bytes"
+
+	if [ "$FSTYP" = "xfs" ] && [ -b "$SCRATCH_RTDEV" ]; then
+		local rtdevsize=`blockdev --getsize64 $SCRATCH_RTDEV`
+		[ "$fssize" -gt "$rtdevsize" ] && _notrun "Scratch rt device too small"
+		rt_ops="-r size=$fssize"
 	fi
-	export MOUNT_OPTIONS="-o size=$fssize $TMPFS_MOUNT_OPTIONS"
-	;;
-    *)
-	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
-	;;
-    esac
+
+	case $FSTYP in
+	xfs)
+		# don't override MKFS_OPTIONS that set a block size.
+		echo $MKFS_OPTIONS |egrep -q "b?size="
+		if [ $? -eq 0 ]; then
+			_scratch_mkfs_xfs -d size=$fssize $rt_ops
+		else
+			_scratch_mkfs_xfs -d size=$fssize $rt_ops -b size=$blocksize
+		fi
+		;;
+	ext2|ext3|ext4|ext4dev)
+		${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+		;;
+	gfs2)
+		# mkfs.gfs2 doesn't automatically shrink journal files on small
+		# filesystems, so the journal files may end up being bigger than the
+		# filesystem, which will cause mkfs.gfs2 to fail.  Until that's fixed,
+		# shrink the journal size to at most one eigth of the filesystem and at
+		# least 8 MiB, the minimum size allowed.
+		local min_journal_size=8
+		local default_journal_size=128
+		if (( fssize/8 / (1024*1024) < default_journal_size )); then
+			local journal_size=$(( fssize/8 / (1024*1024) ))
+			(( journal_size >= min_journal_size )) || journal_size=$min_journal_size
+			MKFS_OPTIONS="-J $journal_size $MKFS_OPTIONS"
+		fi
+		${MKFS_PROG}.$FSTYP $MKFS_OPTIONS -O -b $blocksize $SCRATCH_DEV $blocks
+		;;
+	ocfs2)
+		yes | ${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+		;;
+	udf)
+		$MKFS_UDF_PROG $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+		;;
+	btrfs)
+		local mixed_opt=
+		# minimum size that's needed without the mixed option.
+		# Ref: btrfs-prog: btrfs_min_dev_size()
+		# Non mixed mode is also the default option.
+		(( fssize < $((256 * 1024 *1024)) )) && mixed_opt='--mixed'
+		$MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize $SCRATCH_DEV
+		;;
+	jfs)
+		${MKFS_PROG}.$FSTYP $MKFS_OPTIONS $SCRATCH_DEV $blocks
+		;;
+	reiserfs)
+		${MKFS_PROG}.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+		;;
+	reiser4)
+		# mkfs.resier4 requires size in KB as input for creating filesystem
+		$MKFS_REISER4_PROG $MKFS_OPTIONS -y -b $blocksize $SCRATCH_DEV \
+				   `expr $fssize / 1024`
+		;;
+	f2fs)
+		# mkfs.f2fs requires # of sectors as an input for the size
+		local sector_size=`blockdev --getss $SCRATCH_DEV`
+		$MKFS_F2FS_PROG $MKFS_OPTIONS $SCRATCH_DEV `expr $fssize / $sector_size`
+		;;
+	tmpfs)
+		local free_mem=`_free_memory_bytes`
+		if [ "$free_mem" -lt "$fssize" ] ; then
+		   _notrun "Not enough memory ($free_mem) for tmpfs with $fssize bytes"
+		fi
+		export MOUNT_OPTIONS="-o size=$fssize $TMPFS_MOUNT_OPTIONS"
+		;;
+	*)
+		_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
+		;;
+	esac
 }
 
 # Emulate an N-data-disk stripe w/ various stripe units
