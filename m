Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E98EC35247
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC30921582
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:46:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qcB2EuPD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgBEAqi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:46:38 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45208 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbgBEAqi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:46:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150dOKh123807;
        Wed, 5 Feb 2020 00:46:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=U63uJNXBMpQY1GkVGlBWoEQsNY2eR9MA/ljxef1JK+U=;
 b=qcB2EuPD5aL5nOo7lWKW6crMQIZw/+9xb9iRaCfwIEN5A32EE+b2Icvs5rIq3547rhCe
 KD/uBEzBITKa+5i2DCmZJQOtdaRGsah+and+Kg/k34FsxFS4JhYeuUtrWSijpZoRfU9B
 4mCehmSvd2KB4+J0LTE5e+5S38X4unbtt533K6VOfdpT4yQwoDncicqdoL9SZee1kt0M
 hcg2aX5loesFsftjJaLOWsvbPJLctxI7pD6SK4wOXCuqrlPaqtsf6kA4P0xT3Tb8bhAe
 XO8cYu9rv+OK1mupxsC/YbS9zXoaDFloQy5oB5TuxOw1z5qZn9iBzLxkSLJCLU/ys37Q Kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xykbp00hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:46:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150dhXU115027;
        Wed, 5 Feb 2020 00:46:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xykc30xb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:46:35 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0150kZKw011111;
        Wed, 5 Feb 2020 00:46:35 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:46:35 -0800
Subject: [PATCH 4/4] xfs_repair: don't corrupt a attr fork da3 node when
 clearing forw/back
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 04 Feb 2020 16:46:34 -0800
Message-ID: <158086359417.2079557.4428155306169446299.stgit@magnolia>
In-Reply-To: <158086356778.2079557.17601708483399404544.stgit@magnolia>
References: <158086356778.2079557.17601708483399404544.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050001
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
 repair/attr_repair.c |  181 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 117 insertions(+), 64 deletions(-)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 7b26df33..535fcfbb 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -952,6 +952,106 @@ _("wrong FS UUID, inode %" PRIu64 " attr block %" PRIu64 "\n"),
 	return 0;
 }
 
+static int
+process_longform_leaf_root(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_dinode	*dip,
+	struct blkmap		*blkmap,
+	int			*repair,
+	struct xfs_buf		*bp)
+{
+	struct xfs_attr3_icleaf_hdr leafhdr;
+	xfs_dahash_t		next_hashval;
+	int			badness;
+	int			repairlinks = 0;
+
+	/*
+	 * check sibling pointers in leaf block or root block 0 before
+	 * we have to release the btree block
+	 */
+	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, bp->b_addr);
+	if (leafhdr.forw != 0 || leafhdr.back != 0)  {
+		if (!no_modify)  {
+			do_warn(
+_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
+				ino);
+			repairlinks = 1;
+			leafhdr.forw = 0;
+			leafhdr.back = 0;
+			xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo, bp->b_addr,
+					&leafhdr);
+		} else  {
+			do_warn(
+_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
+		}
+	}
+
+	badness = process_leaf_attr_block(mp, bp->b_addr, 0, ino, blkmap, 0,
+			&next_hashval, repair);
+	if (badness) {
+		*repair = 0;
+		/* the block is bad.  lose the attribute fork. */
+		libxfs_putbuf(bp);
+		return 1;
+	}
+
+	*repair = *repair || repairlinks;
+
+	if (*repair && !no_modify)
+		libxfs_writebuf(bp, 0);
+	else
+		libxfs_putbuf(bp);
+
+	return 0;
+}
+
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
+	libxfs_da3_node_hdr_from_disk(mp, &da3_hdr, bp->b_addr);
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
@@ -963,19 +1063,15 @@ _("wrong FS UUID, inode %" PRIu64 " attr block %" PRIu64 "\n"),
  */
 static int
 process_longform_attr(
-	xfs_mount_t	*mp,
-	xfs_ino_t	ino,
-	xfs_dinode_t	*dip,
-	blkmap_t	*blkmap,
-	int		*repair)	/* out - 1 if something was fixed */
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_dinode	*dip,
+	struct blkmap		*blkmap,
+	int			*repair) /* out - 1 if something was fixed */
 {
-	xfs_attr_leafblock_t	*leaf;
-	xfs_fsblock_t	bno;
-	xfs_buf_t	*bp;
-	xfs_dahash_t	next_hashval;
-	int		repairlinks = 0;
-	struct xfs_attr3_icleaf_hdr leafhdr;
-	int		error;
+	xfs_fsblock_t		bno;
+	struct xfs_buf		*bp;
+	struct xfs_da_blkinfo	*info;
 
 	*repair = 0;
 
@@ -1015,74 +1111,31 @@ process_longform_attr(
 		return 1;
 	}
 
-	/* verify leaf block */
-	leaf = bp->b_addr;
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
-
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
 	 * extent format or btree format attribute fork.
 	 */
-	switch (leafhdr.magic) {
+	info = bp->b_addr;
+	switch (be16_to_cpu(info->magic)) {
 	case XFS_ATTR_LEAF_MAGIC:	/* leaf-form attribute */
 	case XFS_ATTR3_LEAF_MAGIC:
-		if (process_leaf_attr_block(mp, leaf, 0, ino, blkmap,
-				0, &next_hashval, repair)) {
-			*repair = 0;
-			/* the block is bad.  lose the attribute fork. */
-			libxfs_putbuf(bp);
-			return(1);
-		}
-		*repair = *repair || repairlinks;
-		break;
-
+		return process_longform_leaf_root(mp, ino, dip, blkmap, repair,
+				bp);
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
-			be16_to_cpu(leaf->hdr.info.magic), ino);
+			be16_to_cpu(info->magic), ino);
 		libxfs_putbuf(bp);
 		*repair = 0;
-		return(1);
+		return 1;
 	}
 
-	if (*repair && !no_modify)
-		libxfs_writebuf(bp, 0);
-	else
-		libxfs_putbuf(bp);
-
-	return(0);  /* repair may be set */
+	return 0; /* should never get here */
 }
 
 

