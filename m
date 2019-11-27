Return-Path: <SRS0=zxI9=ZT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF66C43215
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 16:35:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85A39206F0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 16:35:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lFEl6RCL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfK0QfF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Nov 2019 11:35:05 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33748 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfK0QfE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Nov 2019 11:35:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xARGYDWi138365;
        Wed, 27 Nov 2019 16:35:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=oJMxGL1cPMD1dBv26thcZ/DQrrQ3vEEcC0vYN7F8HoQ=;
 b=lFEl6RCLCTzv7yVhGQAYFpSAPKZ0/wtQR0x8BZPFVdHCCCmwyPCV8IDeOOUQqzZRWnO5
 3sC2YrJSHCnb3MoQ7yvKkiriG0TT8hkTdapCcNEe7SmRbPUgO4ylSvRG1bi7u1e3nuT6
 B38Gk7Un6WMpx+3KVtuzBCSiXrUQocqvlwvOrGT/Uy0Owt3C5oPwZSR/CMLKCkS+owDU
 sUNZZFu5Uoq0Ud5tZYLpQuEVGIkDQU6RA4PQoHvkc85OdXFnP2BNJ3na+1hRG5ekEWlb
 teAL/et4TnkcgxTeip+W5PDmiVUqIoAGbChb+wxbUVFm4E7rO7IPds6/W2yL+HCkRsHO XQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wev6ueqk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 16:35:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xARGY9Df185485;
        Wed, 27 Nov 2019 16:35:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2whrkrnqau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 16:34:59 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xARGYw2g003250;
        Wed, 27 Nov 2019 16:34:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 Nov 2019 08:34:58 -0800
Date:   Wed, 27 Nov 2019 08:34:57 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH v2] generic/050: fix xfsquota configuration failures
Message-ID: <20191127163457.GL6212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9454 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911270140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9454 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911270140
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
v2: don't try the touch if the mount fails
---
 tests/generic/050              |   12 +++++++-----
 tests/generic/050.out.xfsquota |    5 ++---
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/tests/generic/050 b/tests/generic/050
index cf2b9381..7eabc7a7 100755
--- a/tests/generic/050
+++ b/tests/generic/050
@@ -58,9 +58,11 @@ blockdev --setro $SCRATCH_DEV
 # Mount it, and make sure we can't write to it, and we can unmount it again
 #
 echo "mounting read-only block device:"
-_try_scratch_mount 2>&1 | _filter_ro_mount
-echo "touching file on read-only filesystem (should fail)"
-touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
+_try_scratch_mount 2>&1 | _filter_ro_mount | _filter_scratch
+if [ "${PIPESTATUS[0]}" -eq 0 ]; then
+	echo "touching file on read-only filesystem (should fail)"
+	touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
+fi
 
 #
 # Apparently this used to be broken at some point:
@@ -92,7 +94,7 @@ blockdev --setro $SCRATCH_DEV
 # -o norecovery is used.
 #
 echo "mounting filesystem that needs recovery on a read-only device:"
-_try_scratch_mount 2>&1 | _filter_ro_mount
+_try_scratch_mount 2>&1 | _filter_ro_mount | _filter_scratch
 
 echo "unmounting read-only filesystem"
 _scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
@@ -103,7 +105,7 @@ _scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
 # data recovery hack.
 #
 echo "mounting filesystem with -o norecovery on a read-only device:"
-_try_scratch_mount -o norecovery 2>&1 | _filter_ro_mount
+_try_scratch_mount -o norecovery 2>&1 | _filter_ro_mount | _filter_scratch
 echo "unmounting read-only filesystem"
 _scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
 
diff --git a/tests/generic/050.out.xfsquota b/tests/generic/050.out.xfsquota
index f204bd2f..35d7bd68 100644
--- a/tests/generic/050.out.xfsquota
+++ b/tests/generic/050.out.xfsquota
@@ -1,8 +1,7 @@
 QA output created by 050
 setting device read-only
 mounting read-only block device:
-mount: /mnt-scratch: permission denied
-touching file on read-only filesystem (should fail)
+mount: SCRATCH_MNT: permission denied
 unmounting read-only filesystem
 umount: SCRATCH_DEV: not mounted
 setting device read-write
@@ -17,7 +16,7 @@ mount: cannot mount device read-only
 unmounting read-only filesystem
 umount: SCRATCH_DEV: not mounted
 mounting filesystem with -o norecovery on a read-only device:
-mount: /mnt-scratch: permission denied
+mount: SCRATCH_MNT: permission denied
 unmounting read-only filesystem
 umount: SCRATCH_DEV: not mounted
 setting device read-write
