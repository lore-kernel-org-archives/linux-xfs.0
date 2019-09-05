Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C05AEC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3A4D2070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IGJ3dqDT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391116AbfIEWTj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59634 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389044AbfIEWTj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ9ps049757
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=BKau4YipsyRc71/c+m2z5WtkgyxF1/4AMQ7zaoQj0f8=;
 b=IGJ3dqDTucRM0DM5JeXNPWSEgeK1w2xODeKvUySOrnKjA4vW02QCflLN2qwuXVPSEmxr
 qk0TN4F3vXKB5R/ql1iyzTCwf9wpRZebXDobFatH93gcfxGAvvFO7l0uVkNqkN3za+iL
 ESdls6qkUlJ2LsaouocPYRD0vZg2Q02FYoM+5RNxnocN6nlENGenxgyYnc84ntZe3og/
 ZM68yZ6ZJ5/KyLqU9+2Y2Ld/eOblDJ1TzgN6+PTkVfDDNNR4QUKXmI9BptMl1kvejOmm
 SBRS2wTRKrblZZ+J1moNP5RIpeGTGH7wKK4/vdvSJB7ngnw7idmsAzFzaU2fDSIQ3nrn nA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2uuarc822d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MIeut123405
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2uthq27va2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:37 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85MJ5vm001707
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:05 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:19:05 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 18/21] xfsprogs: Enable delayed attributes
Date:   Thu,  5 Sep 2019 15:18:52 -0700
Message-Id: <20190905221855.17555-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221855.17555-1-allison.henderson@oracle.com>
References: <20190905221855.17555-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Finally enable delayed attributes in xfs_attr_set and
xfs_attr_remove.  We only do this for new filesystems that have
the feature bit enabled because we cant add new log entries to
older filesystems

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 43ecf45..15518a6 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -498,6 +498,7 @@ xfs_attr_set(
 	int			valuelen)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
 	int			rsvd = (name->type & ATTR_ROOT) != 0;
@@ -556,7 +557,34 @@ xfs_attr_set(
 		goto out_trans_cancel;
 
 	xfs_trans_ijoin(args.trans, dp, 0);
-	error = xfs_attr_set_args(&args);
+	if (xfs_sb_version_hasdelattr(sbp)) {
+		error = xfs_has_attr(&args);
+
+		if (error == -EEXIST) {
+			if (name->type & ATTR_CREATE)
+				goto out_trans_cancel;
+			else
+				name->type |= ATTR_REPLACE;
+		}
+
+		if (error == -ENOATTR && (name->type & ATTR_REPLACE))
+			goto out_trans_cancel;
+
+		if (name->type & ATTR_REPLACE) {
+			name->type &= ~ATTR_REPLACE;
+			error = xfs_attr_remove_deferred(dp, args.trans, name);
+			if (error)
+				goto out_trans_cancel;
+
+			name->type |= ATTR_CREATE;
+		}
+
+		error = xfs_attr_set_deferred(dp, args.trans, name, value,
+					      valuelen);
+	} else {
+		error = xfs_attr_set_args(&args);
+	}
+
 	if (error)
 		goto out_trans_cancel;
 	if (!args.trans) {
@@ -663,6 +691,7 @@ xfs_attr_remove(
 	struct xfs_name		*name)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_da_args	args;
 	int			error;
 
@@ -704,7 +733,14 @@ xfs_attr_remove(
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
 
-	error = xfs_attr_remove_args(&args);
+	error = xfs_has_attr(&args);
+	if (error == -ENOATTR)
+		goto out;
+
+	if (xfs_sb_version_hasdelattr(sbp))
+		error = xfs_attr_remove_deferred(dp, args.trans, name);
+	else
+		error = xfs_attr_remove_args(&args);
 	if (error)
 		goto out;
 
-- 
2.7.4

