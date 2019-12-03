Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1300C432C0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 04:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1E1F2068E
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 04:43:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ghiEXJd9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfLCEnB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 23:43:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54426 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfLCEnB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 23:43:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB32iBBc089447;
        Tue, 3 Dec 2019 02:47:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=0rVxu7IdwdyayFviP8WdbNGeQx9ltugImTUhdvCqQUA=;
 b=ghiEXJd9uEgpJ8DQ6sdaa5DsXOfFx8K+m/K3GcKhkm56ZacIvJCbX1pXHxqlFFDWe/ua
 OztP6phm1wnIlipWb0xvByrE4c++B16fOB63N5Z9rsEcG7e0lYdYyVjSQrKjSkRcRe3l
 Sc+3EBjcUxhYgWX9sVBG9J9ydB3w7DiZLZY1KYWMiw97msIBKCqx2wP1Ncnpg2DwWtAL
 Qa+Hxw6nrRWzoxztF7H/tyCWNHOTKqBAi106c6ZNs6LkIFZmcwwRNQupyaLH/7EUBAWw
 sENaJ43IU32R3y6LXMdP5zmSe9w8qzukLGjvo60BYjVBAOJ8wbgv1CtMPtdNrJi+OKFR tQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wkgcq49k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 02:47:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB32huFi017266;
        Tue, 3 Dec 2019 02:47:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wn7pnxabw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 02:47:51 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB32loZ1018450;
        Tue, 3 Dec 2019 02:47:50 GMT
Received: from localhost (/10.159.148.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 18:47:50 -0800
Subject: [PATCH 1/2] xfs_admin: support external log devices
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 02 Dec 2019 18:47:49 -0800
Message-ID: <157534126919.396264.193318734395972520.stgit@magnolia>
In-Reply-To: <157534126287.396264.13869948892885966217.stgit@magnolia>
References: <157534126287.396264.13869948892885966217.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add to xfs_admin the ability to pass external log devices to xfs_db.
This is necessary to make changes on such filesystems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/xfs_admin.sh      |   12 ++++++++++--
 man/man8/xfs_admin.8 |   14 ++++++++++++++
 2 files changed, 24 insertions(+), 2 deletions(-)


diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 305ef2b7..bd325da2 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -7,7 +7,7 @@
 status=0
 DB_OPTS=""
 REPAIR_OPTS=""
-USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device"
+USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device [logdev]"
 
 while getopts "efjlpuc:L:U:V" c
 do
@@ -33,7 +33,15 @@ done
 set -- extra $@
 shift $OPTIND
 case $# in
-	1)	if [ -n "$DB_OPTS" ]
+	1|2)
+		# Pick up the log device, if present
+		if [ -n "$2" ]; then
+			DB_OPTS=$DB_OPTS" -l '$2'"
+			test -n "$REPAIR_OPTS" && \
+				REPAIR_OPTS=$REPAIR_OPTS" -l '$2'"
+		fi
+
+		if [ -n "$DB_OPTS" ]
 		then
 			eval xfs_db -x -p xfs_admin $DB_OPTS $1
 			status=$?
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 20a114f5..8afc873f 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -15,6 +15,9 @@ xfs_admin \- change parameters of an XFS filesystem
 .I uuid
 ]
 .I device
+[
+.I logdev
+]
 .br
 .B xfs_admin \-V
 .SH DESCRIPTION
@@ -31,6 +34,17 @@ A number of parameters of a mounted filesystem can be examined
 and modified using the
 .BR xfs_growfs (8)
 command.
+.PP
+The optional
+.B logdev
+parameter specifies the device special file where the filesystem's external
+log resides.
+This is required only for filesystems that use an external log.
+See the
+.B mkfs.xfs \-l
+option, and refer to
+.BR xfs (5)
+for a detailed description of the XFS log.
 .SH OPTIONS
 .TP
 .B \-e

