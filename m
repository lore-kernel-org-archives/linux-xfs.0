Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABF9C43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3821721741
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:46:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KikI1KD5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgIOBqa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:46:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbgIOBq3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:46:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1iGuO059091;
        Tue, 15 Sep 2020 01:46:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HZ3NseXtTYtcravZxyBsnTn0FMgD+J8M98HCU3yLkUI=;
 b=KikI1KD5byvFsQ8vHsbHQpI0iOxl4Eyj66vJRABqHmz7l0sYJ/lDoEJFwNxqj7JqI+Rx
 aKGxCvX3YHktOcnazNSfmmGS9l2LjWBYH5rEFveI3f378/WzaINWoy/CfeFc+rSwnUei
 3PQSWQ3bEu0kysYd2gYfUjugRSdpmsD4p5pBXi36doFk65CTyqRf4TXIAvLIWY+hed2n
 9YSy3FVvYv0egrhy2B+GKpuCnGvhdg1EDGR6xI4O8eq2NRADIuYnsOe2l/j3vyWgekO6
 BhJOPYwhPZog7Qb81OaS7dNYWA9zQCmQfT3A+g0DB3+bo1toAz72frUH8euXKw2xToA9 TQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33j91dbhub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:46:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1duda076091;
        Tue, 15 Sep 2020 01:44:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33h7wn6hfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:44:26 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F1iQO1004367;
        Tue, 15 Sep 2020 01:44:26 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:44:25 +0000
Subject: [PATCH 14/24] common/xfs: extract minimum log size message from mkfs
 correctly
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:44:24 -0700
Message-ID: <160013426483.2923511.15242915902031465698.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Modify the command that searches for the minimum log size message from
mkfs to handle external log devices correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/common/xfs b/common/xfs
index f4a47dfb..6520ad29 100644
--- a/common/xfs
+++ b/common/xfs
@@ -103,7 +103,7 @@ _scratch_find_xfs_min_logblocks()
 	# try again without MKFS_OPTIONS because that's what _scratch_do_mkfs
 	# will do if we pass in the log size option.
 	if [ $mkfs_status -ne 0 ] &&
-	   ! grep -q 'log size.*too small, minimum' $tmp.mkfserr; then
+	   ! egrep -q '(log size.*too small, minimum|external log device.*too small, must be)' $tmp.mkfserr; then
 		eval "$mkfs_cmd $extra_mkfs_options $SCRATCH_DEV" \
 			2>$tmp.mkfserr 1>$tmp.mkfsstd
 		mkfs_status=$?
@@ -126,6 +126,12 @@ _scratch_find_xfs_min_logblocks()
 		rm -f $tmp.mkfsstd $tmp.mkfserr
 		return
 	fi
+	if grep -q 'external log device.*too small, must be' $tmp.mkfserr; then
+		grep 'external log device.*too small, must be' $tmp.mkfserr | \
+			sed -e 's/^.*must be at least \([0-9]*\) blocks/\1/g'
+		rm -f $tmp.mkfsstd $tmp.mkfserr
+		return
+	fi
 
 	# Don't know what to do, so fail
 	echo "Cannot determine minimum log size" >&2

