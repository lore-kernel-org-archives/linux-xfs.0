Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4328C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93760206FB
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:39:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O92H3dQF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407312AbgJZXjZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:39:25 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46462 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407284AbgJZXjY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:39:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPADt177077;
        Mon, 26 Oct 2020 23:37:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ErNuYLt7zTsL1kGchUwHT2gU2CXced4GJ8cY2V5d3P4=;
 b=O92H3dQFPAS6NteWfLxuhvYXM0e92FDv40pn2k8T8V6LNhLlo3B+dRmwExydL0Na/2Zr
 K5LYqz/sfnB36m9R/r8NbTUAkhYlTv47e+t/PPlHyb2bzzbs8K9ttNVMBJ3KW6thr52+
 g4p0CrB45BLfzhErexMZqPKSyBZPKkvs5vdH5GSOYKeGIK5Ue+Spvos3lWFAzvOoBVql
 dUmSUK1c0w5dgGMB6/oAJb+6loKv28NqlNt/ix/cLfu/N0gzBtuVpitFhOXF1BV/dMiZ
 tah43xFzkG0CZ62Mq8q31JSADEplOIjiu90X/YrqAoMNGeP9UjJE2T1lcjHhKo1pPLYU Nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9saqd91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:37:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxHF110443;
        Mon, 26 Oct 2020 23:37:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx5wftdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:37:19 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNbHoH006618;
        Mon, 26 Oct 2020 23:37:17 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:37:17 -0700
Subject: [PATCH 03/21] xfs: Use variable-size array for nameval in
 xfs_attr_sf_entry
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:37:16 -0700
Message-ID: <160375543655.882906.15645526128840453026.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cmaiolino@redhat.com>

Source kernel commit: c418dbc9805dbd215586454f0c5729333219aa63

nameval is a variable-size array, so, define it as it, and remove all
the -1 magic number subtractions

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr_leaf.c |    7 +++----
 libxfs/xfs_attr_sf.h   |    4 ++--
 libxfs/xfs_da_format.h |    2 +-
 3 files changed, 6 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index a14cdbda1d70..77cd19fd228a 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -989,9 +989,8 @@ xfs_attr_shortform_allfit(
 			return 0;
 		if (be16_to_cpu(name_loc->valuelen) >= XFS_ATTR_SF_ENTSIZE_MAX)
 			return 0;
-		bytes += sizeof(struct xfs_attr_sf_entry) - 1
-				+ name_loc->namelen
-				+ be16_to_cpu(name_loc->valuelen);
+		bytes += XFS_ATTR_SF_ENTSIZE_BYNAME(name_loc->namelen,
+					be16_to_cpu(name_loc->valuelen));
 	}
 	if ((dp->i_mount->m_flags & XFS_MOUNT_ATTR2) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
@@ -1036,7 +1035,7 @@ xfs_attr_shortform_verify(
 		 * xfs_attr_sf_entry is defined with a 1-byte variable
 		 * array at the end, so we must subtract that off.
 		 */
-		if (((char *)sfep + sizeof(*sfep) - 1) >= endp)
+		if (((char *)sfep + sizeof(*sfep)) >= endp)
 			return __this_address;
 
 		/* Don't allow names with known bad length. */
diff --git a/libxfs/xfs_attr_sf.h b/libxfs/xfs_attr_sf.h
index c4afb3307918..29934103ce55 100644
--- a/libxfs/xfs_attr_sf.h
+++ b/libxfs/xfs_attr_sf.h
@@ -27,11 +27,11 @@ typedef struct xfs_attr_sf_sort {
 } xfs_attr_sf_sort_t;
 
 #define XFS_ATTR_SF_ENTSIZE_BYNAME(nlen,vlen)	/* space name/value uses */ \
-	(((int)sizeof(struct xfs_attr_sf_entry)-1 + (nlen)+(vlen)))
+	((sizeof(struct xfs_attr_sf_entry) + (nlen) + (vlen)))
 #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
 	((1 << (NBBY*(int)sizeof(uint8_t))) - 1)
 #define XFS_ATTR_SF_ENTSIZE(sfep)		/* space an entry uses */ \
-	((int)sizeof(struct xfs_attr_sf_entry)-1 + \
+	((int)sizeof(struct xfs_attr_sf_entry) + \
 		(sfep)->namelen+(sfep)->valuelen)
 #define XFS_ATTR_SF_NEXTENTRY(sfep)		/* next entry in struct */ \
 	((struct xfs_attr_sf_entry *)((char *)(sfep) + \
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index e708b714bf99..b40a4e80f5ee 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -589,7 +589,7 @@ struct xfs_attr_shortform {
 		uint8_t namelen;	/* actual length of name (no NULL) */
 		uint8_t valuelen;	/* actual length of value (no NULL) */
 		uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
-		uint8_t nameval[1];	/* name & value bytes concatenated */
+		uint8_t nameval[];	/* name & value bytes concatenated */
 	} list[1];			/* variable sized array */
 };
 

