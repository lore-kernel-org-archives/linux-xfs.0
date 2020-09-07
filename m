Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17CE4C43461
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D18C22177B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:52:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XYd4lxLY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbgIGRwp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 13:52:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57528 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729448AbgIGRwi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 13:52:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HmWui099989;
        Mon, 7 Sep 2020 17:52:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/Bh3fF1AkguB8dITIjhuKyx6+UclQw3y2icWLhnkrR8=;
 b=XYd4lxLYemau+xltrrtBk0cGgqbl9dk2vqGvw2K0D78PsJ78t+bLPwHdYW0EA3cGseRr
 p8vJurlwptPjIkSEIcc1gzxk4jKvZ+3vTM42h5vtuTGe+com3+PkTGAzZBd3G5d7ohaW
 O+BO/28lPf/DyBcNuEIJvSbQJjbI/THmxPSdf49Q0t1lT9mRTh8h5CQiilnmK5+Jn/ba
 oZfyq1bj6cf72sTmIwPV8GziVnR8OVX3r1yqybEj9uDwfd4AU4AGw9SqNQ1SUZRLIu6g
 1PDRygZgZRN9jWBz/gzGAezr1p1oV0PuRHwWS1eqwkKoW6q2Pp8R3bVEVnXtee93xBfw cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33c2mkqj8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Sep 2020 17:52:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HoDmp066483;
        Mon, 7 Sep 2020 17:52:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33cmkuur84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Sep 2020 17:52:29 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 087HqToM006571;
        Mon, 7 Sep 2020 17:52:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Sep 2020 10:51:37 -0700
Subject: [PATCH 1/4] man: install all manpages that redirect to another
 manpage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 07 Sep 2020 10:51:36 -0700
Message-ID: <159950109644.567664.3395622067779955144.stgit@magnolia>
In-Reply-To: <159950108982.567664.1544351129609122663.stgit@magnolia>
References: <159950108982.567664.1544351129609122663.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Some of the ioctl manpages do not contain any information other than a
pointer to a different manpage.  These aren't picked up by the install
scripts, so fix them so that they do.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/buildmacros |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/include/buildmacros b/include/buildmacros
index f8d54200382a..6f34d7c528fa 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -95,9 +95,10 @@ INSTALL_MAN = \
 	@for d in $(MAN_PAGES); do \
 		first=true; \
 		for m in `$(AWK) \
-			'/^\.S[h|H] NAME/ {ok=1; next} ok {print; exit}' $$d \
+			'/^\.S[h|H] NAME/ {ok=1; next} /^\.so/ {printf("so %s\n", FILENAME); exit} ok {print; exit}' $$d \
 			| $(SED) \
 				-e 's/^\.Nm //' -e 's/,/ /g' -e 's/\\-.*//' \
+				-e 's/^so \([_a-zA-Z]*\)\.[0-9]/\1/g' \
 				-e 's/\\\f[0-9]//g' -e 's/  / /g;q'`; \
 		do \
 			[ -z "$$m" -o "$$m" = "\\" ] && continue; \

