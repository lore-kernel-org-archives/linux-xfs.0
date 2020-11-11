Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D683C5517A
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3613421D91
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:43:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lkYTO5IE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732350AbgKKAnk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:43:40 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34506 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgKKAni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:43:38 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0ZaiP016919;
        Wed, 11 Nov 2020 00:43:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=jVb9HtEAfL2emr1WrOmAy/0Nx5SxiZuMmNEOnu4Qg6c=;
 b=lkYTO5IEIkMMmRpeyUJQ7jy96U0J5wtvrx8Wv2zBrBe1oOvpb+FqTLs67XtQeZgG5HUD
 KNLeGxLpF5m2ObExkvyN39wCsa6dSUd2IuumJGKo88oyrec1bD31RzhqLp0J8wJf/aJT
 EKVAE1cgZAbV71r+7RWcFUG9zrlWsW6RNyw2yNv7iqf1GrujTrC/h6x9zeZaR9maNybt
 DovQYOvgbb/v/fwmkG0BaGeUiiRMWN1iq1c3CT8U4XjRbsURpzN0Yh/o7rbsJaVJOJRH
 iy3/N+s3Gpy0MwTBLXCNgQdnHlGuSXlnn+js4VmvXnA6BSiHQ/3m7V2mfZ35IP/zJpZQ Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34p72emv45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 00:43:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0UsPi171596;
        Wed, 11 Nov 2020 00:43:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34p5g12pjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 00:43:35 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB0hYbJ017954;
        Wed, 11 Nov 2020 00:43:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 16:43:34 -0800
Subject: [PATCH 4/6] misc: fix $MKFS_PROG.$FSTYP usage treewide
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:43:33 -0800
Message-ID: <160505541337.1388647.13512171256174815582.stgit@magnolia>
In-Reply-To: <160505537312.1388647.14788379902518687395.stgit@magnolia>
References: <160505537312.1388647.14788379902518687395.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace all the $MKFS_PROG.$FSTYP invocations with $MKFS_PROG -t $FSTYP.
The mkfs wrapper binary knows how to search the user's $PATH to find the
appropriate mkfs delegate, which the author uses to switch between
development and distro versions of various tools.

Unfortunately, using "$MKFS_PROG.$FSTYP" means that the shell only looks
in the same directory as the mkfs wrapper, which means that we can end
up mixing different tool versions when this is the case.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc        |   16 ++++++++--------
 tests/ext4/032   |    2 +-
 tests/shared/032 |    2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/common/rc b/common/rc
index 019b9b2b..9b10d455 100644
--- a/common/rc
+++ b/common/rc
@@ -987,7 +987,7 @@ _scratch_mkfs_sized()
 		fi
 		;;
 	ext2|ext3|ext4|ext4dev)
-		${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+		${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
 		;;
 	gfs2)
 		# mkfs.gfs2 doesn't automatically shrink journal files on small
@@ -1002,10 +1002,10 @@ _scratch_mkfs_sized()
 			(( journal_size >= min_journal_size )) || journal_size=$min_journal_size
 			MKFS_OPTIONS="-J $journal_size $MKFS_OPTIONS"
 		fi
-		${MKFS_PROG}.$FSTYP $MKFS_OPTIONS -O -b $blocksize $SCRATCH_DEV $blocks
+		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -O -b $blocksize $SCRATCH_DEV $blocks
 		;;
 	ocfs2)
-		yes | ${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+		yes | ${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
 		;;
 	udf)
 		$MKFS_UDF_PROG $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
@@ -1019,10 +1019,10 @@ _scratch_mkfs_sized()
 		$MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize $SCRATCH_DEV
 		;;
 	jfs)
-		${MKFS_PROG}.$FSTYP $MKFS_OPTIONS $SCRATCH_DEV $blocks
+		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS $SCRATCH_DEV $blocks
 		;;
 	reiserfs)
-		${MKFS_PROG}.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
 		;;
 	reiser4)
 		# mkfs.resier4 requires size in KB as input for creating filesystem
@@ -1101,13 +1101,13 @@ _scratch_mkfs_blocksized()
 	_scratch_mkfs_xfs $MKFS_OPTIONS -b size=$blocksize
 	;;
     ext2|ext3|ext4)
-	${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV
+	${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV
 	;;
     gfs2)
-	${MKFS_PROG}.$FSTYP $MKFS_OPTIONS -O -b $blocksize $SCRATCH_DEV
+	${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -O -b $blocksize $SCRATCH_DEV
 	;;
     ocfs2)
-	yes | ${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize -C $blocksize $SCRATCH_DEV
+	yes | ${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize -C $blocksize $SCRATCH_DEV
 	;;
     *)
 	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_blocksized"
diff --git a/tests/ext4/032 b/tests/ext4/032
index c63e7034..4e8dac42 100755
--- a/tests/ext4/032
+++ b/tests/ext4/032
@@ -46,7 +46,7 @@ ext4_online_resize()
 	echo "+++ create fs on image file $original_size" | \
 		tee -a $seqres.full
 
-	${MKFS_PROG}.${FSTYP} -F -O bigalloc,resize_inode -C $CLUSTER_SIZ \
+	${MKFS_PROG} -t ${FSTYP} -F -O bigalloc,resize_inode -C $CLUSTER_SIZ \
 		-b $BLK_SIZ ${LOOP_DEVICE} $original_size >> \
 		$seqres.full 2>&1 || _fail "mkfs failed"
 
diff --git a/tests/shared/032 b/tests/shared/032
index 40d27898..00ae6860 100755
--- a/tests/shared/032
+++ b/tests/shared/032
@@ -67,7 +67,7 @@ do
 	if [ $? -eq 0 ] ; then
 		# next, ensure we don't overwrite it
 		echo "=== Attempting $FSTYP overwrite of $fs..." >>$seqres.full
-		${MKFS_PROG}.$FSTYP $SCRATCH_DEV >>$seqres.full 2>&1
+		${MKFS_PROG} -t $FSTYP $SCRATCH_DEV >>$seqres.full 2>&1
 
 		[ $? -eq 0 ] && echo "Failed - overwrote fs type ${fs}!"
 	else

