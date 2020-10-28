Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01866C55179
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 01:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 841B120791
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 01:17:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="psvWXmx/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbgJ2BR3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 21:17:29 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47518 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730069AbgJ2BQG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 21:16:06 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09T1FiZJ095280
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 01:16:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=resent-from :
 resent-date : resent-message-id : resent-to : subject : from : to : cc :
 date : message-id : in-reply-to : references : mime-version : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=dMEyMUSIW2K+KlaaW8RYL84IRpYtJbo0iljZ2E8Y72s=;
 b=psvWXmx/GJJ9iyFOks3ymEUV6zPodWPWm1xyETAo+psgoO+R434v4TN911ses7DATVTm
 jpYgQkEgNwWwbDjDWLVtBEVHVAgQ8yHnqzoATQbfaz4ParmLaS7NoBO8MSRhsCF7lCDv
 xIY/UW/Buy7Uk2vVZKawHrXv531UdRbbYZvPZaAALcokbWBfUgm9HiS2CcA0Y9dGL6lK
 Azjb1OuhacXs5ob8bMCB6wkoU/4VErNKH/MUh9/UiuGXHEW3Ixo6iNmSwqHb5a78mp7W
 +J4DaVTN2n/Wmt47PorapgE9iQmjUQYt81Ge/XdI6CBewt8ZOHt+kzjzSAUnoPrtBWZ5 JA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34c9sb2gre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 01:16:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09T1BN2D112625
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 01:14:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34cx6xw6g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 01:14:04 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09T1E3o6032099
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 01:14:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Oct 2020 18:14:03 -0700
Received: from stbeehive.pdgtm.oraclecorp.com [141.146.118.10]
        by magnolia with IMAP (fetchmail-6.4.2)
        for <djwong@localhost> (single-drop); Tue, 27 Oct 2020 18:10:59 -0700 (PDT)
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 18:10:19 -0700
Subject: [PATCH 1/2] design: document the new inode btree counter feature
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 27 Oct 2020 18:10:18 -0700
Message-ID: <160384741848.1365004.5354796889293226533.stgit@magnolia>
In-Reply-To: <160384741244.1365004.6341029408891306870.stgit@magnolia>
References: <160384741244.1365004.6341029408891306870.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=3
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290004
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Update the ondisk format documentation to discuss the inode btree
counter feature.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |   21 ++++++++++++++++++++
 1 file changed, 21 insertions(+)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 992615d..2e78f56 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -405,6 +405,13 @@ reference counts of AG blocks.  This enables files to share data blocks safely.
 See the section about xref:Reflink_Deduplication[reflink and deduplication] for
 more details.
 
+| +XFS_SB_FEAT_RO_COMPAT_INOBTCNT+ |
+Inode B+tree block counters.  Each allocation group's inode (AGI) header
+tracks the number of blocks in each of the inode B+trees.  This allows us
+to have a slightly higher level of redundancy over the shape of the inode
+btrees, and decreases the amount of time to compute the metadata B+tree
+preallocations at mount time.
+
 |=====
 
 *sb_features_incompat*::
@@ -928,6 +935,10 @@ struct xfs_agi {
 
      __be32              agi_free_root;
      __be32              agi_free_level;
+
+     __be32              agi_iblocks;
+     __be32              agi_fblocks;
+
 }
 ----
 *agi_magicnum*::
@@ -984,6 +995,16 @@ B+tree.
 *agi_free_level*::
 Specifies the number of levels in the free inode B+tree.
 
+*agi_iblocks*::
+The number of blocks in the inode B+tree, including the root.
+This field is zero if the +XFS_SB_FEAT_RO_COMPAT_INOBTCNT+ feature is not
+enabled.
+
+*agi_fblocks*::
+The number of blocks in the free inode B+tree, including the root.
+This field is zero if the +XFS_SB_FEAT_RO_COMPAT_INOBTCNT+ feature is not
+enabled.
+
 [[Inode_Btrees]]
 == Inode B+trees
 

