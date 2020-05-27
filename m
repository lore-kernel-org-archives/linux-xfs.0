Return-Path: <SRS0=YlU2=7J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994BEC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 17:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 593212065F
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 17:25:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PZYLtdFU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgE0RZT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 May 2020 13:25:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50034 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbgE0RZT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 May 2020 13:25:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RHMJLP060807;
        Wed, 27 May 2020 17:25:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=7vQRNfliHOkDlF5da7qKlJYgtKeOPEy6auelL7QsXRk=;
 b=PZYLtdFUIGUB9uPCSsHxXnPpLtSpqdyhxYLuzvrV3WdeCUVHt6+niWAFFcvlzv+Q37xO
 r0+RxGGwa21JkjPfRh8cUPjEZsI/jDbnQubJVJjTeLrUJ/l9T4LANbTS68aCT4mHiGze
 vfPE+8BNk3KMlAAEnKDVYlVkZYKqcXVli0Yk5krPofcD+xoxHvoFsowPN2iRZ1dlLNi9
 Fhmty+rrKT3kbLufN5PvL/g9hGuPfVbzGVsp+xw0SJCCMSsjJZ5RviQ6XOJamr6yvPeF
 iQckmzISin3oAxvcjD8vK48nijrkV0xs+3cKsAaGIFcA4DsqEGGAh8X7NqTBXZ0Fl4xo mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 318xe1gshq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 17:25:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RHNasD040891;
        Wed, 27 May 2020 17:25:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 317j5ses0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 17:25:16 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04RHPF2O007349;
        Wed, 27 May 2020 17:25:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 May 2020 10:25:15 -0700
Date:   Wed, 27 May 2020 10:25:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_quota: fix unsigned int id comparisons
Message-ID: <20200527172514.GK252930@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=1
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 cotscore=-2147483648 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=1 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270135
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
 
