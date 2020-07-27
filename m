Return-Path: <SRS0=NLen=BG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 576AEC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 20:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35CF920729
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 20:07:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T1iW1zM6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgG0UHH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jul 2020 16:07:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45994 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgG0UHH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jul 2020 16:07:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RK1aOE089777
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 20:07:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=6tWQsi7gFCybvNFBNAXKImOpWGi5Og56Nwu0QYwME3k=;
 b=T1iW1zM6992qmwsecBQgo7H8hfIegM3SkUmUPzG1DIV0Y+6Jj/4E+4A6n5OfGJsRR8Qq
 nb6M7eBQIirLZgMayRVjWfGZtF6e0JD0PqrUHrPBkfGbVQq5xoxCh5ppVMaXa0kfS6SP
 8ivqbr2Zap9J12uuFYk5cBCO4jjnlo73+hdrFhdQtol+iaNa0A5Fn3uNYdWrstTZpcr9
 eKNa9CHieaOgxdh8EfPELku4O5elP5ktqPQZBVeV2jW9At608I3Ra7V73NwS0wN+PG7B
 30w3iDCSu+1fr5ASK5C6LW3IUcExrKhJ5yky/7H8ou/wJXNMl6+GdMAVZUrKSfereeGF zA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32hu1jbmjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 20:07:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RK3J5b152476
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 20:07:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32hu5rc8u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 20:07:05 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06RK7426006166
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 20:07:04 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 13:07:04 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 1/2] xfs: Fix compiler warning in xfs_attr_node_removename_setup
Date:   Mon, 27 Jul 2020 13:06:55 -0700
Message-Id: <20200727200656.6318-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200727200656.6318-1-allison.henderson@oracle.com>
References: <20200727200656.6318-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=1 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=1 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix compiler warning for variable 'blk' set but not used in
xfs_attr_node_removename_setup.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d4583a0..e5ec9ed 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1174,15 +1174,14 @@ int xfs_attr_node_removename_setup(
 	struct xfs_da_state	**state)
 {
 	int			error;
-	struct xfs_da_state_blk	*blk;
 
 	error = xfs_attr_node_hasname(args, state);
 	if (error != -EEXIST)
 		return error;
 
-	blk = &(*state)->path.blk[(*state)->path.active - 1];
-	ASSERT(blk->bp != NULL);
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
+	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
+		XFS_ATTR_LEAF_MAGIC);
 
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_leaf_mark_incomplete(args, *state);
-- 
2.7.4

