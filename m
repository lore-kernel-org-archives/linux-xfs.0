Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1395DC2D0DB
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 18:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE32F20658
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 18:15:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VDEx2ZNc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgA3SPS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 13:15:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36856 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728610AbgA3SPS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 13:15:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00UIDT3I102841;
        Thu, 30 Jan 2020 18:15:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=62dWQq+nGO+TmwnM1T27wnlI+zmx6AjE096PwrckVZA=;
 b=VDEx2ZNc+6ah8pbXVI1IvzLNEbL+PYwLcfjh6+qspmRrP2yM61NlGoMvIf0WUsgdWxy/
 RJsJxoFF0LKxoqj9N7i+3o1OFP72XDX2pEgeT0q86pIWBSTJxlONqhgNwzP/St+98Ynp
 Uedt693DT1tXfruPWuTC8VFX9Qef/Lzh3jAGR1+Zw3WvLvHIdOWS8xiDJJAGmqxYtc+P
 UpBEqADl509OG/JusgOUU0o/Ce4Xo2mBWJlgg3V0ZhFcspI4N2rCYDX5h3z3Xb/5UzRS
 /NFEh7e+aJX7XVUPq2wyQSuRw5xopfGnWwtCxt6zwZorhxEux2vFLKNFJ4ZRorh+nnFb Lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xrearnre9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 18:15:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00UIEPuU024435;
        Thu, 30 Jan 2020 18:15:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xuemwwgfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 18:15:15 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00UIFDJ3024182;
        Thu, 30 Jan 2020 18:15:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jan 2020 10:15:12 -0800
Date:   Thu, 30 Jan 2020 10:15:12 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/8] xfs_repair: don't corrupt a attr fork da3 node when
 clearing forw/back
Message-ID: <20200130181512.GZ3447196@magnolia>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157982499185.2765410.18206322669640988643.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001300127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001300127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In process_longform_attr, we enforce that the root block of the
attribute index must have both forw or back pointers set to zero.
Unfortunately, the code that nulls out the pointers is not aware that
the root block could be in da3 node format.

This leads to corruption of da3 root node blocks because the functions
that convert attr3 leaf headers to and from the ondisk structures
perform some interpretation of firstused on what they think is an attr1
leaf block.

Found by using xfs/402 to fuzz hdr.info.hdr.forw.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/attr_repair.c |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 9a44f610..9d2a40f7 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -952,6 +952,33 @@ _("wrong FS UUID, inode %" PRIu64 " attr block %" PRIu64 "\n"),
 	return 0;
 }
 
+/*
+ * Zap the forw/back links in an attribute block.  Be careful, because the
+ * root block could be an attr leaf block or a da node block.
+ */
+static inline void
+clear_attr_forw_back(
+	struct xfs_buf			*bp,
+	struct xfs_attr3_icleaf_hdr	*leafhdr)
+{
+	struct xfs_mount		*mp = bp->b_mount;
+
+	if (leafhdr->magic == XFS_DA_NODE_MAGIC ||
+	    leafhdr->magic == XFS_DA3_NODE_MAGIC) {
+		struct xfs_da3_icnode_hdr	da3_hdr;
+
+		xfs_da3_node_hdr_from_disk(mp, &da3_hdr, bp->b_addr);
+		da3_hdr.forw = 0;
+		da3_hdr.back = 0;
+		xfs_da3_node_hdr_to_disk(mp, bp->b_addr, &da3_hdr);
+		return;
+	}
+
+	leafhdr->forw = 0;
+	leafhdr->back = 0;
+	xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo, bp->b_addr, leafhdr);
+}
+
 /*
  * Start processing for a leaf or fuller btree.
  * A leaf directory is one where the attribute fork is too big for
@@ -1028,10 +1055,7 @@ process_longform_attr(
 	_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
 				ino);
 			repairlinks = 1;
-			leafhdr.forw = 0;
-			leafhdr.back = 0;
-			xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo,
-						   leaf, &leafhdr);
+			clear_attr_forw_back(bp, &leafhdr);
 		} else  {
 			do_warn(
 	_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
