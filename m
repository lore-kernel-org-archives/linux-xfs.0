Return-Path: <SRS0=aQ/b=BI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA08C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 00:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6A33207E8
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 00:11:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q8Oc2TqB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730284AbgG2ALI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 20:11:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50666 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730219AbgG2ALG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jul 2020 20:11:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T07xJB165387
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 00:11:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=G9SLs6K7Qzcjkd6KNB7nYd1wML8WzHJpwrJx4GOGOzE=;
 b=Q8Oc2TqBPTtab83EFW1LPfzAcwCXFrpmTHWXiq8s4JmXSO31cxpyX1XUp1aFLRMPDoig
 Zi//AoUENTO2r1fizyJBX1mtFIDMR96+Vj0XpcLxbWli9qiBKEeDut7DMl+hAHV3pIKD
 j66F63VEvlwIMvKtrn4vL0kHYAhT54V8uDdm0Fizu6j8B9+HpsLz7ZZlvHI0wJuAx7O3
 sLI8qg6UJgBNHfW3OVFAwOg3vw6WtKJ5TfBqaNQyfIWCiBfZc7U8OC050XqyhYzjluf1
 jPq+YMgDYBd/IdGIYJnMi7jkxf5oPsJIx1FcOVHSSYs5CjBZGO1q/M259yWUUPqfW8aG eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32hu1jaj0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 00:11:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T08STm020821
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 00:09:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32hu5v9kuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 00:09:05 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06T095CG001651
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 00:09:05 GMT
Received: from localhost.localdomain (/67.1.123.207)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 17:09:04 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/1] xfs: Fix Smatch warning in xfs_attr_node_get
Date:   Tue, 28 Jul 2020 17:08:53 -0700
Message-Id: <20200729000853.10215-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007280173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=3 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007280173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix warning: variable dereferenced before check 'state' in
xfs_attr_node_get.  If xfs_attr_node_hasname fails, it may return a null
state.  If state is null, do not derefrence it.  Go straight to out.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e5ec9ed..90b7b24 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1409,6 +1409,9 @@ xfs_attr_node_get(
 	 * Search to see if name exists, and get back a pointer to it.
 	 */
 	error = xfs_attr_node_hasname(args, &state);
+	if (!state)
+		goto out;
+
 	if (error != -EEXIST)
 		goto out_release;
 
@@ -1426,7 +1429,7 @@ xfs_attr_node_get(
 		xfs_trans_brelse(args->trans, state->path.blk[i].bp);
 		state->path.blk[i].bp = NULL;
 	}
-
+out:
 	if (state)
 		xfs_da_state_free(state);
 	return error;
-- 
2.7.4

