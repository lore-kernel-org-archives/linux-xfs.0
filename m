Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDFCC433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFABC206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:27:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K+2csg9o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgFBE1O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:27:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34406 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgFBE1O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:27:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HODo106930;
        Tue, 2 Jun 2020 04:27:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Vd29LH/YNdn0VZY/kCU+SsC+OGiJthMBLsLp9uCiEIo=;
 b=K+2csg9o+PxwePGiWcqGGdEpe0vlcVAZhjrBYo/OG1aG0kpht+3AW4L6sxjungcyP51w
 rz5lI83CBMUO2BoBJEM78An2S4JhFD7kW1TAoMcc440H9g2+RZYVPgmMIBPcYaMgTTIf
 /2dQx1nKswmca7/Yvms18Uen/uupSDUGoP5Sud/LBR+WoDqcVsbaqNUjCfT6sajEf3/g
 lvCn7oleGn44NifrGTjtaQPTk7GMMEgvXz0/kjMshtkcI5CxoHBF1a6NY+PV9/+HAuKc
 oDP+OJud8PrENggjIjcbDel4ELClc0+CfLzEcNN4gy3Fl8+Empu4UHxLdL3iYDiZpjNd Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31bfem1tb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:27:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HwW2040219;
        Tue, 2 Jun 2020 04:25:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31c18sgg0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:25:11 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524PADL020245;
        Tue, 2 Jun 2020 04:25:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:25:10 -0700
Subject: [PATCH 01/17] xfs_quota: fix unsigned int id comparisons
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:25:07 -0700
Message-ID: <159107190741.313760.11195530788081068638.stgit@magnolia>
In-Reply-To: <159107190111.313760.8056083399475334567.stgit@magnolia>
References: <159107190111.313760.8056083399475334567.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix compiler warnings about unsigned int comparisons by replacing them
with an explicit check for the one possible invalid value (-1U).
id_from_string sets exitcode to nonzero when it sees this value, so the
call sites don't have to do that.

Coverity-id: 1463855, 1463856, 1463857
Fixes: 67a73d6139d0 ("xfs_quota: refactor code to generate id from name")
Fixes: 36dc471cc9bb ("xfs_quota: allow individual timer extension")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 quota/edit.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)


diff --git a/quota/edit.c b/quota/edit.c
index cf9508bf..01d358f7 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -307,11 +307,11 @@ limit_f(
 
 
 	id = id_from_string(name, type);
-	if (id >= 0)
-		set_limits(id, type, mask, fs_path->fs_name,
-			   &bsoft, &bhard, &isoft, &ihard, &rtbsoft, &rtbhard);
-	else
-		exitcode = -1;
+	if (id == -1)
+		return 0;
+
+	set_limits(id, type, mask, fs_path->fs_name,
+		   &bsoft, &bhard, &isoft, &ihard, &rtbsoft, &rtbhard);
 	return 0;
 }
 
@@ -545,9 +545,10 @@ timer_f(
 	if (name)
 		id = id_from_string(name, type);
 
-	if (id >= 0)
-		set_timer(id, type, mask, fs_path->fs_name, value);
+	if (id == -1)
+		return 0;
 
+	set_timer(id, type, mask, fs_path->fs_name, value);
 	return 0;
 }
 
@@ -642,11 +643,10 @@ warn_f(
 	}
 
 	id = id_from_string(name, type);
-	if (id >= 0)
-		set_warnings(id, type, mask, fs_path->fs_name, value);
-	else
-		exitcode = -1;
+	if (id == -1)
+		return 0;
 
+	set_warnings(id, type, mask, fs_path->fs_name, value);
 	return 0;
 }
 

