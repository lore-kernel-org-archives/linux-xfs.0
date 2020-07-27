Return-Path: <SRS0=NLen=BG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B62C433E3
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 02:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65B04206F6
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 02:26:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bkf0Ni0b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgG0C0V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jul 2020 22:26:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45498 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgG0C0U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jul 2020 22:26:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06R2NIKG009155
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 02:26:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=lDZJFMvU2WELNcG3dc03A7H1uDQgeyMurvUoAwrgIcM=;
 b=bkf0Ni0bMH2XViyiiVHf4kt9uY97YjQJaxaN+1m7J+4Eg7G3kjm5UDoUBv2RN4Azdfue
 B4Jk88BBG5XPeCDlUR7odDYFvuZQnHkJiCzlxXMf3cvN9hMALUWpe+zOrxwPlUI4XO6o
 iAHrqgtJ6Dn67G+suNYLP2G74vU2SncTUPCcxrUaQkJzkE4U4QF4LYbj0DdFq4T3N3eH
 hkURMAKpFrXx7jl5XM6JU24Z+1Wj5bTGcXnwdm3oWnY6xGcpLrHS1kMCOnLAlefd9fbJ
 /05lpQ6UwJmU42rs4CEqkkRm+j7bXoM0fT1J9NORvZ3VT9CtZUNrRQZ9Q2pyC7T0POsF Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32gx46j6uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 02:26:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06R2OKvQ011247
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 02:26:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32hp3bg74v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 02:26:18 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06R2QH6p010663
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 02:26:17 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jul 2020 19:26:17 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/2] xfs: Fix compiler warning in xfs_attr_node_removename_setup
Date:   Sun, 26 Jul 2020 19:26:07 -0700
Message-Id: <20200727022608.18535-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200727022608.18535-1-allison.henderson@oracle.com>
References: <20200727022608.18535-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=1 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 mlxscore=0 suspectscore=1 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix compiler warning for variable 'blk' set but not used in
xfs_attr_node_removename_setup.  blk is used only in an ASSERT so only
declare blk when DEBUG is set.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d4583a0..5168d32 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1174,7 +1174,9 @@ int xfs_attr_node_removename_setup(
 	struct xfs_da_state	**state)
 {
 	int			error;
+#ifdef DEBUG
 	struct xfs_da_state_blk	*blk;
+#endif
 
 	error = xfs_attr_node_hasname(args, state);
 	if (error != -EEXIST)
-- 
2.7.4

