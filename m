Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2988FC3F2C6
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 02:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03E3420866
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 02:46:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RpXixwfu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387432AbgCDCqj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 21:46:39 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44916 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387411AbgCDCqj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 21:46:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0242iNCS190181;
        Wed, 4 Mar 2020 02:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=K8fe4a4yZut3SyJTG8V6xLgjbfY3gs8iO0DeMbyzA2A=;
 b=RpXixwfudJx83RnU2b3YoXgYN4NZlVhW7Cg3v/pAGqp15mOPvdGoy4TmFDZ3gtWFtv+X
 kL3qbOALBlPiYrMRvkhBsBkPF8DwBo/mLon8/qadvsJAhLqeMax6xpSY5Caor1zrd4lg
 +E+F4wI7/aiWdLBC52uk3AI/uINKjx/eCSfKZuqknl7M/BRopRQb9h3ETRpqGIq4+/aE
 THTXhJQb92o5AFKFq2CuwRARI+PrXh6PNpnyz2o3MpvNLpmLyC3OTZd5ZV1fDiHZ1ZYk
 /fDRO85wGMcbUxK/gJtl6JKZDcuA2/3qULb/Tow6hgZQw4PkbZZ/8J10opsoUimTedew 0w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yffwqucyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 02:46:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0242ieZ6104627;
        Wed, 4 Mar 2020 02:46:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2yg1p63rwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 02:46:36 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0242kZdr012388;
        Wed, 4 Mar 2020 02:46:35 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 18:46:35 -0800
Subject: [PATCH 1/3] generic/402: skip test if xfs_io can't parse the date
 value
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        fstests@vger.kernel.org
Date:   Tue, 03 Mar 2020 18:46:34 -0800
Message-ID: <158328999421.2374922.12052887381904972734.stgit@magnolia>
In-Reply-To: <158328998787.2374922.4223951558305234252.stgit@magnolia>
References: <158328998787.2374922.4223951558305234252.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003040019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003040019
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If xfs_io's utimes command cannot interpret the arguments that are given
to it, it will print out "Bad value for [am]time".  Detect when this
happens and drop the file out of the test entirely.

This is particularly noticeable on 32-bit platforms and the largest
timestamp seconds supported by the filesystem is INT_MAX.  In this case,
the maximum value we can cram into tv_sec is INT_MAX, and there is no
way to actually test setting a timestamp of INT_MAX + 1 to test the
clamping.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/402 |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)


diff --git a/tests/generic/402 b/tests/generic/402
index 2a34d127..2481a5d2 100755
--- a/tests/generic/402
+++ b/tests/generic/402
@@ -63,10 +63,26 @@ run_test_individual()
 	# check if the time needs update
 	if [ $update_time -eq 1 ]; then
 		echo "Updating file: $file to timestamp $timestamp"  >> $seqres.full
-		$XFS_IO_PROG -f -c "utimes $timestamp 0 $timestamp 0" $file
-		if [ $? -ne 0 ]; then
+		rm -f $tmp.utimes
+		$XFS_IO_PROG -f -c "utimes $timestamp 0 $timestamp 0" $file > $tmp.utimes 2>&1
+		local res=$?
+
+		cat $tmp.utimes >> $seqres.full
+		if [ "$timestamp" -ne 0 ] && grep -q "Bad value" "$tmp.utimes"; then
+			echo "xfs_io could not interpret time value \"$timestamp\", skipping \"$file\" test." >> $seqres.full
+			rm -f $file $tmp.utimes
+			return
+		fi
+		cat $tmp.utimes
+		rm -f $tmp.utimes
+		if [ $res -ne 0 ]; then
 			echo "Failed to update times on $file" | tee -a $seqres.full
 		fi
+	else
+		if [ ! -f "$file" ]; then
+			echo "xfs_io did not create file for time value \"$timestamp\", skipping test." >> $seqres.full
+			return
+		fi
 	fi
 
 	tsclamp=$((timestamp<tsmin?tsmin:timestamp>tsmax?tsmax:timestamp))

