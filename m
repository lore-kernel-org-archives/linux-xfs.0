Return-Path: <SRS0=aQ/b=BI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9654C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 04:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB2862070B
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 04:37:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UgL3fw77"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgG2Eh6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 00:37:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:32854 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgG2Eh6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jul 2020 00:37:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T4bvjb015431
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 04:37:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=Cbw2wJ3Vs9KwuiM5NQiwRdjq+eOfiTkj8woZsGs/qhc=;
 b=UgL3fw77ZVmvQFjxqmMGUQG5pmS0UDZ90cJT6+2S7D2p1HYo7xaVHTbknb346oBYY34P
 z9+rFeLf4XS+6Kbj4eAriDPzqxvBhUWd3HReTLhXSw/4p1q80lhjU7PhaAwzMM5e779B
 QBFePCswmpeMt9rnMq3oGS57iD0zcnQF5g32NF2OdCOR3vUvR0ptMoWNVvaexooI4by6
 ionsUkIs9FZjF5IGn5/lS1gqbIFGTxRdAW7Apmokl71YOonwEKrALYdWomQJoOVyAqxu
 vwGANpJ+gyrQZVvxPKNdWwWHsZQ3COo8keBn+pGyMx6f/4DVLKHPbh2iI61qTMSditAH kA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32hu1jb7nc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 04:37:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T4WjJC043170
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 04:37:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 32hu5v68cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 04:37:56 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06T4bucn031759
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 04:37:56 GMT
Received: from localhost.localdomain (/67.1.123.207)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 21:37:56 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/1] xfs: Fix Smatch warning in xfs_attr_node_get
Date:   Tue, 28 Jul 2020 21:37:47 -0700
Message-Id: <20200729043747.11164-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007290031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=1 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix warning: variable dereferenced before check 'state' in
xfs_attr_node_get.  If xfs_attr_node_hasname fails, it may return a null
state.  If state is null, do not release paths or derefrence state

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e5ec9ed..38fe0d3 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1422,7 +1422,7 @@ xfs_attr_node_get(
 	 * If not in a transaction, we have to release all the buffers.
 	 */
 out_release:
-	for (i = 0; i < state->path.active; i++) {
+	for (i = 0; i < state && state->path.active; i++) {
 		xfs_trans_brelse(args->trans, state->path.blk[i].bp);
 		state->path.blk[i].bp = NULL;
 	}
-- 
2.7.4

