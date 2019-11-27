Return-Path: <SRS0=zxI9=ZT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC36C43215
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 04:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF19420869
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 04:17:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LCz17aBT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfK0ERt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 23:17:49 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55030 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfK0ERt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Nov 2019 23:17:49 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR441oS075794;
        Wed, 27 Nov 2019 04:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=FAdR+mfQxEt+usdDxr2Z7fdATGLpEuEAv83hXAuDqYw=;
 b=LCz17aBTY6jH0ZLFAgukzccMdMrtdesAdvxi2xcBMiMz4+S7qkOSUMblLYVVxuISFloc
 XRmOyG1lIpAgQhcVitr+/hR2PzySt+vHA8rnOJqEFK3O+svLWWo65ZGMzFt74/IHCQI6
 m7Mbn10EVLVn1gR5A6nRAi3Qd7ClAsCqjLwcND2mF6JlzIOybPXijab/H/QcuAS4cx62
 I3o9Vtx451kk2NG9Ed9G0sZlhhW6sz6UoU9qgHbZ1WarbYmAHbSnEoaH6G26sSUKG9FX
 TQTtKjR6QMx8kQVhQ31vnKE/7xknqDPw9gmtwqg9h3nYXOetF91Yb9yQewtMyA7YJIGX 6A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wewdrarh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 04:17:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR440m0178043;
        Wed, 27 Nov 2019 04:15:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wh0rfxund-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 04:15:42 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAR4FfWV019227;
        Wed, 27 Nov 2019 04:15:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 20:15:41 -0800
Date:   Tue, 26 Nov 2019 20:15:38 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH] generic/050: fix xfsquota configuration failures
Message-ID: <20191127041538.GH6212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911270032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911270032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The new 'xfsquota' configuration for generic/050 doesn't filter out
SCRATCH_MNT properly and seems to be missing an error message in the
golden output.  Fix both of these problems.

Fixes: e088479871 ("generic/050: Handle xfs quota special case with different output")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/050              |    6 +++---
 tests/generic/050.out.xfsquota |    5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/tests/generic/050 b/tests/generic/050
index cf2b9381..6f536aff 100755
--- a/tests/generic/050
+++ b/tests/generic/050
@@ -58,7 +58,7 @@ blockdev --setro $SCRATCH_DEV
 # Mount it, and make sure we can't write to it, and we can unmount it again
 #
 echo "mounting read-only block device:"
-_try_scratch_mount 2>&1 | _filter_ro_mount
+_try_scratch_mount 2>&1 | _filter_ro_mount | _filter_scratch
 echo "touching file on read-only filesystem (should fail)"
 touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
 
@@ -92,7 +92,7 @@ blockdev --setro $SCRATCH_DEV
 # -o norecovery is used.
 #
 echo "mounting filesystem that needs recovery on a read-only device:"
-_try_scratch_mount 2>&1 | _filter_ro_mount
+_try_scratch_mount 2>&1 | _filter_ro_mount | _filter_scratch
 
 echo "unmounting read-only filesystem"
 _scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
@@ -103,7 +103,7 @@ _scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
 # data recovery hack.
 #
 echo "mounting filesystem with -o norecovery on a read-only device:"
-_try_scratch_mount -o norecovery 2>&1 | _filter_ro_mount
+_try_scratch_mount -o norecovery 2>&1 | _filter_ro_mount | _filter_scratch
 echo "unmounting read-only filesystem"
 _scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
 
diff --git a/tests/generic/050.out.xfsquota b/tests/generic/050.out.xfsquota
index f204bd2f..10e395da 100644
--- a/tests/generic/050.out.xfsquota
+++ b/tests/generic/050.out.xfsquota
@@ -1,8 +1,9 @@
 QA output created by 050
 setting device read-only
 mounting read-only block device:
-mount: /mnt-scratch: permission denied
+mount: SCRATCH_MNT: permission denied
 touching file on read-only filesystem (should fail)
+touch: cannot touch 'SCRATCH_MNT/foo': Read-only file system
 unmounting read-only filesystem
 umount: SCRATCH_DEV: not mounted
 setting device read-write
@@ -17,7 +18,7 @@ mount: cannot mount device read-only
 unmounting read-only filesystem
 umount: SCRATCH_DEV: not mounted
 mounting filesystem with -o norecovery on a read-only device:
-mount: /mnt-scratch: permission denied
+mount: SCRATCH_MNT: permission denied
 unmounting read-only filesystem
 umount: SCRATCH_DEV: not mounted
 setting device read-write
