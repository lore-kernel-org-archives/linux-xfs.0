Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0BBC33CB3
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 18:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0605C21734
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 18:48:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ro/17GJ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731548AbgA3SsY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 13:48:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37186 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731542AbgA3SsX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 13:48:23 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00UImIi7131603;
        Thu, 30 Jan 2020 18:48:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=fM0n7eMRf6Wk1Gks8eQ8wmvT3srsep5naVKxATvxCOs=;
 b=ro/17GJ0gR+jhDj2wePi1gWaSIx388XXdVPKoX6w15zpRbWW5qNgMQVKkKFv49u4j3oo
 3019YG8UmaGaAtGAcBI70L0tR2QiHOufyc3r/e4dWqwPgyU7GQQYBM/GR6suW+oBKrEY
 E0e10w4o4atdI0RHbQNtf1GQZXhG9DPVGn+T6lS29oJ6fZrgKDq6CXHe5rf9dGL+MaiG
 7XjFR0/VD065yhYZA6YjeeFwZSp5SjEsRWfPCYtkP9rl0/Qeysj9mCYxqSabXWaS4XE9
 SG/41jXargtZYqiY16Qs9M8dcClFcj+XwUd9lkqq6k5zAHQC33lHFudzLyKVuEbLC5Nv BA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xrearnwu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 18:48:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00UIiG8s195368;
        Thu, 30 Jan 2020 18:46:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xuc30mwau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 18:46:11 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00UIk7Y4030994;
        Thu, 30 Jan 2020 18:46:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jan 2020 10:46:07 -0800
Date:   Thu, 30 Jan 2020 10:46:06 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 11/8] xfs_repair: don't corrupt a attr fork da3 node when
 clearing forw/back
Message-ID: <20200130184606.GC3447196@magnolia>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <20200130181512.GZ3447196@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130181512.GZ3447196@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001300128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001300129
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
v2: split the da node code into a separate function since that code path
exits out the bottom of the case statement.
---
 repair/attr_repair.c |   98 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 68 insertions(+), 30 deletions(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 9a44f610..8b66a06d 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -952,6 +952,52 @@ _("wrong FS UUID, inode %" PRIu64 " attr block %" PRIu64 "\n"),
 	return 0;
 }
 
+static int
+process_longform_da_root(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_dinode	*dip,
+	struct blkmap		*blkmap,
+	int			*repair,
+	struct xfs_buf		*bp)
+{
+	struct xfs_da3_icnode_hdr	da3_hdr;
+	int			repairlinks = 0;
+	int			error;
+
+	xfs_da3_node_hdr_from_disk(mp, &da3_hdr, bp->b_addr);
+	/*
+	 * check sibling pointers in leaf block or root block 0 before
+	 * we have to release the btree block
+	 */
+	if (da3_hdr.forw != 0 || da3_hdr.back != 0)  {
+		if (!no_modify)  {
+			do_warn(
+_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
+				ino);
+
+			repairlinks = 1;
+			da3_hdr.forw = 0;
+			da3_hdr.back = 0;
+			xfs_da3_node_hdr_to_disk(mp, bp->b_addr, &da3_hdr);
+		} else  {
+			do_warn(
+_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
+		}
+	}
+
+	/* must do this now, to release block 0 before the traversal */
+	if ((*repair || repairlinks) && !no_modify) {
+		*repair = 1;
+		libxfs_writebuf(bp, 0);
+	} else
+		libxfs_putbuf(bp);
+	error = process_node_attr(mp, ino, dip, blkmap); /* + repair */
+	if (error)
+		*repair = 0;
+	return error;
+}
+
 /*
  * Start processing for a leaf or fuller btree.
  * A leaf directory is one where the attribute fork is too big for
@@ -975,7 +1021,6 @@ process_longform_attr(
 	xfs_dahash_t	next_hashval;
 	int		repairlinks = 0;
 	struct xfs_attr3_icleaf_hdr leafhdr;
-	int		error;
 
 	*repair = 0;
 
@@ -1019,25 +1064,6 @@ process_longform_attr(
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 
-	/* check sibling pointers in leaf block or root block 0 before
-	* we have to release the btree block
-	*/
-	if (leafhdr.forw != 0 || leafhdr.back != 0)  {
-		if (!no_modify)  {
-			do_warn(
-	_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
-				ino);
-			repairlinks = 1;
-			leafhdr.forw = 0;
-			leafhdr.back = 0;
-			xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo,
-						   leaf, &leafhdr);
-		} else  {
-			do_warn(
-	_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
-		}
-	}
-
 	/*
 	 * use magic number to tell us what type of attribute this is.
 	 * it's possible to have a node or leaf attribute in either an
@@ -1046,6 +1072,26 @@ process_longform_attr(
 	switch (leafhdr.magic) {
 	case XFS_ATTR_LEAF_MAGIC:	/* leaf-form attribute */
 	case XFS_ATTR3_LEAF_MAGIC:
+		/*
+		 * check sibling pointers in leaf block or root block 0 before
+		 * we have to release the btree block
+		 */
+		if (leafhdr.forw != 0 || leafhdr.back != 0)  {
+			if (!no_modify)  {
+				do_warn(
+	_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
+					ino);
+				repairlinks = 1;
+				leafhdr.forw = 0;
+				leafhdr.back = 0;
+				xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo,
+						leaf, &leafhdr);
+			} else  {
+				do_warn(
+	_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
+			}
+		}
+
 		if (process_leaf_attr_block(mp, leaf, 0, ino, blkmap,
 				0, &next_hashval, repair)) {
 			*repair = 0;
@@ -1058,16 +1104,8 @@ process_longform_attr(
 
 	case XFS_DA_NODE_MAGIC:		/* btree-form attribute */
 	case XFS_DA3_NODE_MAGIC:
-		/* must do this now, to release block 0 before the traversal */
-		if ((*repair || repairlinks) && !no_modify) {
-			*repair = 1;
-			libxfs_writebuf(bp, 0);
-		} else
-			libxfs_putbuf(bp);
-		error = process_node_attr(mp, ino, dip, blkmap); /* + repair */
-		if (error)
-			*repair = 0;
-		return error;
+		return process_longform_da_root(mp, ino, dip, blkmap, repair,
+				bp);
 	default:
 		do_warn(
 	_("bad attribute leaf magic # %#x for dir ino %" PRIu64 "\n"),
