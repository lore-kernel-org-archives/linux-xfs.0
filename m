Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E75FC433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE877214F1
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:43:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DWV55jGV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgIOBnR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:43:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44628 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgIOBnO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:43:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1e4AM130181;
        Tue, 15 Sep 2020 01:43:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bWBUly2K0qKxLUN+6aY35OLs88s8LUxqAZOZ7fdG0Xg=;
 b=DWV55jGVAnnJ99gt31HcK9JsaJtzzGF3DATd5ZvcMYGxHinFiVNo2MV3u5atEdqQy5SF
 Mjc4UKx6pWBw5nLSIiHKJlYGfRuZoMrXdxTVsU8lLj3h759IFb2l6wFJ6vPhVKB+sGxu
 s69G1VRvaVnul/BU4Eh58NSTd4JJa+DuWS6iCwrycCM0SAoCcn50WWtAd9/Z4wKpcs4k
 ZOkPAPEwmH5M2SVWp0+ABo/sv0QeJ6TTfvLlVjliYbCFuTBfZgaWJ59VTP6VhDF3kz3x
 +wh+kEqSsqY14xYJqaBEB3x+8b0oqnEYmODeX3PtdCFUdUbXfOQbe1Ko3hwB0PzZuT6K ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33gnrqsxsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:43:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1dmP3111657;
        Tue, 15 Sep 2020 01:43:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33hm2ycc3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:43:11 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F1hAQk004006;
        Tue, 15 Sep 2020 01:43:10 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:43:09 +0000
Subject: [PATCH 02/24] generic/60[01]: fix test failure when setting new grace
 limit
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:43:08 -0700
Message-ID: <160013418837.2923511.12713913160160876814.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The setquota command can extend a quota grace period by a certain number
of seconds.  The extension is provided as a number of seconds relative
to right now.  However, if the system clock increments the seconds count
after this test assigns $now but before setquota gets called, the test
will fail because $get and $set will be off by that 1 second.  Allow for
that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/600 |    4 +++-
 tests/generic/601 |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)


diff --git a/tests/generic/600 b/tests/generic/600
index 7ea0d6c2..42e4ee55 100755
--- a/tests/generic/600
+++ b/tests/generic/600
@@ -60,7 +60,9 @@ let set=now+100
 setquota -T -u $qa_user 0 100 $SCRATCH_MNT 2>&1 | grep -v "^setquota"
 get=`repquota -up $SCRATCH_MNT | grep  "^$qa_user" | awk '{print $NF}'`
 
-if [ "$get" != "$set" ]; then
+# Either the new expiry must match; or be one second after the set time, to
+# deal with the seconds counter incrementing.
+if [ "$get" != "$set" ] && [ "$get" -ne "$((set + 1))" ]; then
 	echo "set grace to $set but got grace $get"
 fi
 
diff --git a/tests/generic/601 b/tests/generic/601
index 1baa6a90..b412ee8a 100755
--- a/tests/generic/601
+++ b/tests/generic/601
@@ -71,7 +71,9 @@ $XFS_QUOTA_PROG -x -c "timer -u -i 100 $qa_user" $SCRATCH_MNT
 # raw ("since epoch") grace expiry
 get=`repquota -up $SCRATCH_MNT | grep  "^$qa_user" | awk '{print $NF}'`
 
-if [ "$get" != "$set" ]; then
+# Either the new expiry must match; or be one second after the set time, to
+# deal with the seconds counter incrementing.
+if [ "$get" != "$set" ] && [ "$get" -ne "$((set + 1))" ]; then
 	echo "set grace to $set but got grace $get"
 fi
 

