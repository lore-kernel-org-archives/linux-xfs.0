Return-Path: <SRS0=Wl19=BE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B067AC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 23:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ADEB20663
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 23:03:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EhsqlCRO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgGYXDM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jul 2020 19:03:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45180 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgGYXDL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jul 2020 19:03:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06PN3Btf132251
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 23:03:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=wfAbSENhna/Y4wbvkXMUZZTopQigsulidtVyov51xi4=;
 b=EhsqlCRO50ud3u+bHPEY/UyY8CNqbVfMFtaa0OUXQg0Z8VEmep45/eEdGDGruQ+6rrhd
 fo15SVenCaQH2uwtXYdiWQiqHO50B96eoeLM6ne7ExwqD4GxAYwgWpd6oOEXqgQ9ML9E
 eXFyR/gcCW9ulYCv0VcJoTA34wMyxFiA+y4nR2BgYKGahthX4oKJxOanXKWSw+0x3CAl
 FZYUXeStxASEDhDPwmk5UpeQ1v6iOwrr7Y3oMBYePyESqi9cV0L5QJq7aQJ5asIRJGsm
 Mbg0WpJn21esUFXxT2oRQvVKtpqd0eYegyiHWzpVndEkJmbItgn4i4R4CeMdcXFUgQ5B LA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32gc5qsu1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 23:03:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06PMwH2F056221
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 23:01:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32gj35hbmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 23:01:09 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06PN18QC006867
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 23:01:09 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 16:01:08 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: Fix compiler warning in xfs_attr_node_removename_setup
Date:   Sat, 25 Jul 2020 16:01:01 -0700
Message-Id: <20200725230102.22192-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200725230102.22192-1-allison.henderson@oracle.com>
References: <20200725230102.22192-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=1 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250191
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250191
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix compiler warning for variable 'blk' set but not used in
xfs_attr_node_removename_setup

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d4583a0..4ef0020 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1181,8 +1181,11 @@ int xfs_attr_node_removename_setup(
 		return error;
 
 	blk = &(*state)->path.blk[(*state)->path.active - 1];
-	ASSERT(blk->bp != NULL);
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	if (blk->bp == NULL)
+		return -EFSCORRUPTED;
+
+	if (blk->magic != XFS_ATTR_LEAF_MAGIC)
+		return -EFSCORRUPTED;
 
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_leaf_mark_incomplete(args, *state);
-- 
2.7.4

