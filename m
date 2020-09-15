Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AAD9C43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 124A920756
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:45:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OxfCc8Zg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgIOBp1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:45:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51342 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgIOBpT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:45:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1ikxu031207;
        Tue, 15 Sep 2020 01:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=S0nratNUDmAVWn1HogoEh+M2+urRpGz99fmYteFZIlg=;
 b=OxfCc8ZghxyzFzkEiC9ugp3qiodc9cWPznWc10G1vRhSCC6ZBhavIESins72//qMBbqC
 QosOttqMuVvhT1apjrSFAlsVDgLm2xa6niwCAC/Erl1tOT8YNlsgXAyTI1dfUFOpHaNC
 8Q2hz6IC5DUUXj9OsWd9XreyUxI5/iAfgkYew5nsUyyJVgF7np14Chpc7fmmIHalEdfu
 iRP36MdvZY+Y9uyXatAeigSdCtZNK+J+y1eJGqgRHN62czubaGCcKp9aYIzyqKNZEsZX
 Ukz1w6qXYkBWnEw3b0GyJWUadV83o6c+2dKulHcN/rGLm1gR9l443XjJr+YULInKOLUp SQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33gp9m1wv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:45:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1dloZ111547;
        Tue, 15 Sep 2020 01:43:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33hm2yccd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:43:17 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F1hGSG004017;
        Tue, 15 Sep 2020 01:43:16 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:43:16 +0000
Subject: [PATCH 03/24] generic/607: don't break on filesystems that don't
 support FSGETXATTR on dirs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:43:15 -0700
Message-ID: <160013419510.2923511.4577521065964693699.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This test requires that the filesystem support calling FSGETXATTR on
regular files and directories to make sure the FS_XFLAG_DAX flag works.
The _require_xfs_io_command tests a regular file but doesn't check
directories, so generic/607 should do that itself.  Also fix some typos.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc         |   10 ++++++++--
 tests/generic/607 |    5 +++++
 2 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/common/rc b/common/rc
index aa5a7409..f78b1cfc 100644
--- a/common/rc
+++ b/common/rc
@@ -2162,6 +2162,12 @@ _require_xfs_io_command()
 	local testfile=$TEST_DIR/$$.xfs_io
 	local testio
 	case $command in
+	"lsattr")
+		# Test xfs_io lsattr support and filesystem FS_IOC_FSSETXATTR
+		# support.
+		testio=`$XFS_IO_PROG -F -f -c "lsattr $param" $testfile 2>&1`
+		param_checked="$param"
+		;;
 	"chattr")
 		if [ -z "$param" ]; then
 			param=s
@@ -3205,7 +3211,7 @@ _check_s_dax()
 	if [ $exp_s_dax -eq 0 ]; then
 		(( attributes & 0x2000 )) && echo "$target has unexpected S_DAX flag"
 	else
-		(( attributes & 0x2000 )) || echo "$target doen't have expected S_DAX flag"
+		(( attributes & 0x2000 )) || echo "$target doesn't have expected S_DAX flag"
 	fi
 }
 
@@ -3217,7 +3223,7 @@ _check_xflag()
 	if [ $exp_xflag -eq 0 ]; then
 		_test_inode_flag dax $target && echo "$target has unexpected FS_XFLAG_DAX flag"
 	else
-		_test_inode_flag dax $target || echo "$target doen't have expected FS_XFLAG_DAX flag"
+		_test_inode_flag dax $target || echo "$target doesn't have expected FS_XFLAG_DAX flag"
 	fi
 }
 
diff --git a/tests/generic/607 b/tests/generic/607
index b15085ea..14d2c05f 100755
--- a/tests/generic/607
+++ b/tests/generic/607
@@ -38,6 +38,11 @@ _require_scratch
 _require_dax_iflag
 _require_xfs_io_command "lsattr" "-v"
 
+# Make sure we can call FSGETXATTR on a directory...
+output="$($XFS_IO_PROG -c "lsattr -v" $TEST_DIR 2>&1)"
+echo "$output" | grep -q "Inappropriate ioctl for device" && \
+	_notrun "$FSTYP: FSGETXATTR not supported on directories."
+
 # If a/ is +x, check that a's new children
 # inherit +x from a/.
 test_xflag_inheritance1()

