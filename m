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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 705EEC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 02:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E7F1206F6
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 02:33:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hWb/oM7f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgG0CdN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jul 2020 22:33:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48576 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgG0CdN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jul 2020 22:33:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06R2VimJ028370
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 02:33:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=UzXI3Noj9pnKJEjFLS36aQ3SARmIU6l3FG44lMV7nh0=;
 b=hWb/oM7fVujLtoEJbLye72SBGR2uGkh1wYSxrp6KX6qxqw3XGR/moaH3ERKbky4V9hv0
 PFt+TsCL7o97m7EWqS5Yny/dZnhR1W90TBJTQPxVAzjFZCZocTYlGls3HyjnDeooljvA
 m9MvoiIEn9CR/jEwvmplsE204ntTgwyDWoGuiTl7ImFeC46TPwwmq0vdA3DUovWaRfNV
 5RfhMZX7n7gYVKyFRSO2I7z/jM7XlvAW5uCADhUULKnN4DUQ0TiOzr8w1HNWBMQhKJ26
 xVEk4Vm0NPCdG+b5ez4byBOmbG3zKhJwbB+yeBskwLLezhS9C7k2KTzRh3hAKRVLYgVU 0g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32gx46j724-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 02:33:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06R2SJ17030670
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 02:33:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32hp3bguq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 02:33:10 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06R2QH8x026102
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 02:26:17 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jul 2020 19:26:17 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/2] xfs: Fix compiler warning in xfs_attr_shortform_add
Date:   Sun, 26 Jul 2020 19:26:08 -0700
Message-Id: <20200727022608.18535-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200727022608.18535-1-allison.henderson@oracle.com>
References: <20200727022608.18535-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=1 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 mlxscore=0 suspectscore=1 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270015
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix compiler warning warning: variable 'error' set but not used in
xfs_attr_shortform_add. error is used only in an ASSERT so only declare
error when DEBUG is set.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index ad7b351..db985b8 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -715,7 +715,10 @@ xfs_attr_shortform_add(
 {
 	struct xfs_attr_shortform	*sf;
 	struct xfs_attr_sf_entry	*sfe;
-	int				offset, size, error;
+	int				offset, size;
+#if DEBUG
+	int				error;
+#endif
 	struct xfs_mount		*mp;
 	struct xfs_inode		*dp;
 	struct xfs_ifork		*ifp;
-- 
2.7.4

