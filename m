Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A89FC47254
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18C8E20774
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:52:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ixlxlaeg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgD3Wwj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:52:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34462 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgD3Wwj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:52:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMlXA0066961
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:52:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Gdb78XZ07BZMbWHrWCxvAzcwGb0lTm7V0otXkEtMvdI=;
 b=ixlxlaegCrpr1NAkYs4P0K/pIQeIk1vQV1KOywAm4m5JOyMO+J/uI84OfnJd2fEPobpU
 Wj6OnSFM9thsCqbrDTZ7Kmm7k04g+A44qUcdG5rgqLkbixBBYKwVXUZlDtZgCiDnwB9X
 eFlz4QS7ENQpZFoRRAdOhirsNSO3lw8NMZ4lI6YoLk2kfQG1uQfqCbYcAAL7VpkWwoRp
 Y4N2b4OzQ4BvAtbT+e6rtcWeAGlwRKinSkUO/73buzu/yVuJLwWgU1dOy8Fkk/n0fqh6
 XPqDsLuE55HJcy6omcOnhhw6iKO6igF8Wb4LpBtBMOqllbkDto1TDUgnL5a3Bx0XS/x2 BA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30r7f802ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:52:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgEFX141482
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30qtg23n6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:38 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UMobHw013842
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:37 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:50:37 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 18/24] xfs: Add helper function xfs_attr_node_removename_rmt
Date:   Thu, 30 Apr 2020 15:50:10 -0700
Message-Id: <20200430225016.4287-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430225016.4287-1-allison.henderson@oracle.com>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 mlxlogscore=997 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=1 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds another new helper function
xfs_attr_node_removename_rmt. This will also help modularize
xfs_attr_node_removename when we add delay ready attributes later.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index c8226c6..ab1c9fa 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1216,6 +1216,24 @@ int xfs_attr_node_removename_setup(
 	return 0;
 }
 
+STATIC int
+xfs_attr_node_removename_rmt (
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	int			error = 0;
+
+	error = xfs_attr_rmtval_remove(args);
+	if (error)
+		return error;
+
+	/*
+	 * Refill the state structure with buffers, the prior calls released our
+	 * buffers.
+	 */
+	return xfs_attr_refillstate(state);
+}
+
 /*
  * Remove a name from a B-tree attribute list.
  *
@@ -1244,15 +1262,7 @@ xfs_attr_node_removename(
 	 * overflow the maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			goto out;
-
-		/*
-		 * Refill the state structure with buffers, the prior calls
-		 * released our buffers.
-		 */
-		error = xfs_attr_refillstate(state);
+		error = xfs_attr_node_removename_rmt(args, state);
 		if (error)
 			goto out;
 	}
-- 
2.7.4

