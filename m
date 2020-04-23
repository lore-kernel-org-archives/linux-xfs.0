Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 396CEC55186
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1529020736
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:31:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gHpegKb+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgDWXbW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 19:31:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58280 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgDWXbW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 19:31:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNSZIb140236;
        Thu, 23 Apr 2020 23:31:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3DepZGjQ7/a+0HELHMzy9KHgzM9W0XFzc0YjxZLcjho=;
 b=gHpegKb+P9bIIDF/deltZie4B/J25xe5dkon5PinM0Hi2Qe35oSGRqJFFdEywHHmnSB1
 ar+ge34if5zQvwSUL5qmaPh+91ZXYO1qlku3y0ogFUJJUIbsQupLF6iEMbCghuwuR0PO
 W+nN5IiMMxnqOjqInBakveRgEDmUi74S/dieHttndBcZqeqw7pjpKAyzMylUJavk+tP4
 PjYolWIehzxf1YJGQWUSOItqv0HTz3lX0vE/5iJ3TxAhECEG3PxBd0ShY357aUmMsuXE
 wm/rL+aVPEns3e1m8KU8nJbC2wwbHHvwC4vHNY0weLZKkiTr0R0UnEpESV6upc/gkJVo EQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30ketdhm4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:31:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNSNbE031685;
        Thu, 23 Apr 2020 23:31:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30gb1nmruu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:31:20 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03NNVJbd021353;
        Thu, 23 Apr 2020 23:31:19 GMT
Received: from localhost (/10.159.232.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Apr 2020 16:31:19 -0700
Subject: [PATCH 1/5] generic/590: fix the xfs feature detection logic
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Thu, 23 Apr 2020 16:31:18 -0700
Message-ID: <158768467794.3019327.1909486240720460347.stgit@magnolia>
In-Reply-To: <158768467175.3019327.8681440148230401150.stgit@magnolia>
References: <158768467175.3019327.8681440148230401150.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004230168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1011 suspectscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The setup code in this regression test case tries to figure out if
certain features known to be incompatible with realtime are known to
mkfs, and if so, to forcibly disable them.

Unfortunately, the reflink feature detection logic here is broken,
because we have no way of distinguishing between the helper function
_scratch_mkfs_xfs_supported returning nonzero because reflink isn't
compatible with mkfs's defaults (e.g. your mkfs has rmapbt=1 by default)
vs. reflink isn't recognized at all vs. something else broke.

However, we can grep the mkfs output to look for reflink support, and if
we find it then we disable it.  That's fine for this test, since on XFS
it's trying to set up the exact conditions to test a known bug.

Second, rmapbt isn't currently compatible with realtime either, so we
need to detect and mask that off too.

Third, the test only needs to perform this feature detection if the test
runner didn't set SCRATCH_RTDEV, because we require that if the runner
configured SCRATCH_RTDEV, they also set MKFS_OPTIONS appropriately.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/590 |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)


diff --git a/tests/generic/590 b/tests/generic/590
index 45f443c3..284bd49d 100755
--- a/tests/generic/590
+++ b/tests/generic/590
@@ -41,6 +41,21 @@ bs=4096
 rextsize=4
 filesz=$(((maxextlen + 1) * bs))
 
+must_disable_feature() {
+	local feat="$1"
+
+	# If mkfs doesn't know about the feature, we don't need to disable it
+	$MKFS_XFS_PROG --help 2>&1 | grep -q "${feat}=0" || return 1
+
+	# If turning the feature on works, we don't need to disable it
+	_scratch_mkfs_xfs_supported -m "${feat}=1" "${disabled_features[@]}" \
+		> /dev/null 2>&1 && return 1
+
+	# Otherwise mkfs knows of the feature and formatting with it failed,
+	# so we do need to mask it.
+	return 0
+}
+
 extra_options=""
 # If we're testing XFS, set up the realtime device to reproduce the bug.
 if [[ $FSTYP = xfs ]]; then
@@ -54,14 +69,20 @@ if [[ $FSTYP = xfs ]]; then
 		loop="$(_create_loop_device "$TEST_DIR/$seq")"
 		USE_EXTERNAL=yes
 		SCRATCH_RTDEV="$loop"
+		disabled_features=()
+
+		# disable reflink if not supported by realtime devices
+		must_disable_feature reflink &&
+			disabled_features=(-m reflink=0)
+
+		# disable rmap if not supported by realtime devices
+		must_disable_feature rmapbt &&
+			disabled_features+=(-m rmapbt=0)
 	fi
 	extra_options="$extra_options -r extsize=$((bs * rextsize))"
 	extra_options="$extra_options -d agsize=$(((maxextlen + 1) * bs / 2)),rtinherit=1"
-	# disable reflink as reflink not supported with realtime devices
-	if _scratch_mkfs_xfs_supported -m reflink=0 >/dev/null 2>&1; then
-		extra_options="$extra_options -m reflink=0"
-	fi
-	_scratch_mkfs $extra_options >>$seqres.full 2>&1
+
+	_scratch_mkfs $extra_options "${disabled_features[@]}" >>$seqres.full 2>&1
 	_try_scratch_mount >>$seqres.full 2>&1 || \
 		_notrun "mount failed, kernel doesn't support realtime?"
 	_scratch_unmount

