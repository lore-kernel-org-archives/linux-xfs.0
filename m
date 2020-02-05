Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74233C3524D
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A106214AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:02:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m84Mg4DB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbgBEACF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:02:05 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42568 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbgBEACF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:02:05 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014Nw1DU085079;
        Wed, 5 Feb 2020 00:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ADGovvgAva/Nd4VUaQIeGfE29ESgFUENNm2c5R+ubqQ=;
 b=m84Mg4DBO68SLbyqDyLkUT6dLxxDBk4nySRbiQjvScg7ym1JAQrEvWkb4q/eY55m3GHt
 2FvdWrNUEPZvlfzq/b6MYX3iXd2tWAsxwHMNVAgyC90A4rSuJMB7o2cWdA8S6SPFboWu
 3Q5UhXOdBTtx9eqWI3Vdnif3Ihh8a86MkNeBk10+uxLJE9e7vSgjpc6EI1pf9IhSbTlf
 c9Wl6rcVB6XokhwbWtWX8yTTepMgBSBsvAwuZKffh/9hwG7BTfOnpq9Knb6kawC/Q6RB
 eH+0RihYQ29LP2C6EcQHFro2BzaQb7hmSbK2oaX8lVHcZefYFcM5rm2Lnz5Q/ugB2INs Sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xyhkf88ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:02:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014NxG0H036699;
        Wed, 5 Feb 2020 00:02:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xyhmqwar5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:02:02 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0150223s021842;
        Wed, 5 Feb 2020 00:02:02 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:02:01 -0800
Subject: [PATCH 3/5] generic/402: skip test if xfs_io can't parse the date
 value
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 04 Feb 2020 16:02:00 -0800
Message-ID: <158086092087.1989378.18220785148122680849.stgit@magnolia>
In-Reply-To: <158086090225.1989378.6869317139530865842.stgit@magnolia>
References: <158086090225.1989378.6869317139530865842.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2001150001 definitions=main-2002040164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-2001150001
 definitions=main-2002040164
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
---
 tests/generic/402 |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)


diff --git a/tests/generic/402 b/tests/generic/402
index 2a34d127..32988866 100755
--- a/tests/generic/402
+++ b/tests/generic/402
@@ -63,10 +63,19 @@ run_test_individual()
 	# check if the time needs update
 	if [ $update_time -eq 1 ]; then
 		echo "Updating file: $file to timestamp $timestamp"  >> $seqres.full
-		$XFS_IO_PROG -f -c "utimes $timestamp 0 $timestamp 0" $file
+		$XFS_IO_PROG -f -c "utimes $timestamp 0 $timestamp 0" $file >> $tmp.utimes 2>&1
+		cat $tmp.utimes >> $seqres.full
+		if grep -q "Bad value" "$tmp.utimes"; then
+			rm -f $file $tmp.utimes
+			return
+		fi
+		cat $tmp.utimes
+		rm $tmp.utimes
 		if [ $? -ne 0 ]; then
 			echo "Failed to update times on $file" | tee -a $seqres.full
 		fi
+	else
+		test -f $file || return
 	fi
 
 	tsclamp=$((timestamp<tsmin?tsmin:timestamp>tsmax?tsmax:timestamp))

