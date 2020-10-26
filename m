Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3C5C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CC92206FB
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:39:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zk4ZQchI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407314AbgJZXjc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:39:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57976 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407284AbgJZXjc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:39:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPmrZ165230;
        Mon, 26 Oct 2020 23:37:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Zef20BADGBY2clK5XfONS5OynKV7USSssmbAhdLK5v0=;
 b=Zk4ZQchIiss8hXLM3PTuJrSavEUJ2Wk2AQndVztQmVWz+MyvzwlNbZ7E6XdY2n4Rr6CP
 /+tooT72GlWjyKQZWZOW1BK6VLr4/eZTcT6qhDGPoOHl4FOg0BNF6qUvPGMpQAdpwGjj
 a480+xDJrnztk24B58yJpb7F7lcaaWqObRrVRp02HR6X9f3NdwTUsRar/Vo1BSKGpC83
 NdhbsBqjIh0GQtYjhHPQybOnhOBfsi1UCnrXbEUDpIdvOSXOsUSRcWZQ7hLmiB/erYXV
 vDUwxmD7U5EuCqSvbUV7d+KlNKPS7X0EF2sQeIIRdKGma8Y10cjWwKQKXMfNWsc9ck2T OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm3vuve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:37:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPGKn120983;
        Mon, 26 Oct 2020 23:37:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34cx6va752-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:37:05 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNb5Fc006599;
        Mon, 26 Oct 2020 23:37:05 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:37:04 -0700
Subject: [PATCH 01/21] xfs: remove typedef xfs_attr_sf_entry_t
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:37:03 -0700
Message-ID: <160375542383.882906.11557101490927759593.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cmaiolino@redhat.com>

Source kernel commit: 6337c84466c250d5da797bc5d6941c501d500e48

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/attrshort.c         |   20 ++++++++++----------
 db/metadump.c          |    4 ++--
 libxfs/xfs_attr_leaf.c |    4 ++--
 libxfs/xfs_attr_sf.h   |   11 ++++++-----
 repair/attr_repair.c   |    8 ++++----
 5 files changed, 24 insertions(+), 23 deletions(-)


diff --git a/db/attrshort.c b/db/attrshort.c
index 90c95dd44128..15532a062caa 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -33,7 +33,7 @@ const field_t	attr_sf_hdr_flds[] = {
 	{ NULL }
 };
 
-#define	EOFF(f)	bitize(offsetof(xfs_attr_sf_entry_t, f))
+#define	EOFF(f)	bitize(offsetof(struct xfs_attr_sf_entry, f))
 const field_t	attr_sf_entry_flds[] = {
 	{ "namelen", FLDT_UINT8D, OI(EOFF(namelen)), C1, 0, TYP_NONE },
 	{ "valuelen", FLDT_UINT8D, OI(EOFF(valuelen)), C1, 0, TYP_NONE },
@@ -56,10 +56,10 @@ attr_sf_entry_name_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_attr_sf_entry_t	*e;
+	struct xfs_attr_sf_entry	*e;
 
 	ASSERT(bitoffs(startoff) == 0);
-	e = (xfs_attr_sf_entry_t *)((char *)obj + byteize(startoff));
+	e = (struct xfs_attr_sf_entry *)((char *)obj + byteize(startoff));
 	return e->namelen;
 }
 
@@ -69,7 +69,7 @@ attr_sf_entry_size(
 	int			startoff,
 	int			idx)
 {
-	xfs_attr_sf_entry_t	*e;
+	struct xfs_attr_sf_entry	*e;
 	int			i;
 	xfs_attr_shortform_t	*sf;
 
@@ -86,10 +86,10 @@ attr_sf_entry_value_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_attr_sf_entry_t	*e;
+	struct xfs_attr_sf_entry	*e;
 
 	ASSERT(bitoffs(startoff) == 0);
-	e = (xfs_attr_sf_entry_t *)((char *)obj + byteize(startoff));
+	e = (struct xfs_attr_sf_entry *)((char *)obj + byteize(startoff));
 	return e->valuelen;
 }
 
@@ -100,11 +100,11 @@ attr_sf_entry_value_offset(
 	int			startoff,
 	int			idx)
 {
-	xfs_attr_sf_entry_t	*e;
+	struct xfs_attr_sf_entry	*e;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(idx == 0);
-	e = (xfs_attr_sf_entry_t *)((char *)obj + byteize(startoff));
+	e = (struct xfs_attr_sf_entry *)((char *)obj + byteize(startoff));
 	return bitize((int)((char *)&e->nameval[e->namelen] - (char *)e));
 }
 
@@ -126,7 +126,7 @@ attr_shortform_list_offset(
 	int			startoff,
 	int			idx)
 {
-	xfs_attr_sf_entry_t	*e;
+	struct xfs_attr_sf_entry	*e;
 	int			i;
 	xfs_attr_shortform_t	*sf;
 
@@ -145,7 +145,7 @@ attrshort_size(
 	int			startoff,
 	int			idx)
 {
-	xfs_attr_sf_entry_t	*e;
+	struct xfs_attr_sf_entry	*e;
 	int			i;
 	xfs_attr_shortform_t	*sf;
 
diff --git a/db/metadump.c b/db/metadump.c
index e5cb3aa57ade..12a5cba7616d 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1371,7 +1371,7 @@ process_sf_attr(
 	 */
 
 	xfs_attr_shortform_t	*asfp;
-	xfs_attr_sf_entry_t	*asfep;
+	struct xfs_attr_sf_entry	*asfep;
 	int			ino_attr_size;
 	int			i;
 
@@ -1413,7 +1413,7 @@ process_sf_attr(
 			       asfep->valuelen);
 		}
 
-		asfep = (xfs_attr_sf_entry_t *)((char *)asfep +
+		asfep = (struct xfs_attr_sf_entry *)((char *)asfep +
 				XFS_ATTR_SF_ENTSIZE(asfep));
 	}
 
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 269efb7a5a5c..0ed5297ed357 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -733,7 +733,7 @@ xfs_attr_shortform_add(
 	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
 	xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
-	sfe = (xfs_attr_sf_entry_t *)((char *)sf + offset);
+	sfe = (struct xfs_attr_sf_entry *)((char *)sf + offset);
 
 	sfe->namelen = args->namelen;
 	sfe->valuelen = args->valuelen;
@@ -835,7 +835,7 @@ int
 xfs_attr_shortform_lookup(xfs_da_args_t *args)
 {
 	xfs_attr_shortform_t *sf;
-	xfs_attr_sf_entry_t *sfe;
+	struct xfs_attr_sf_entry *sfe;
 	int i;
 	struct xfs_ifork *ifp;
 
diff --git a/libxfs/xfs_attr_sf.h b/libxfs/xfs_attr_sf.h
index bb004fb7944a..c4afb3307918 100644
--- a/libxfs/xfs_attr_sf.h
+++ b/libxfs/xfs_attr_sf.h
@@ -13,7 +13,6 @@
  * to fit into the literal area of the inode.
  */
 typedef struct xfs_attr_sf_hdr xfs_attr_sf_hdr_t;
-typedef struct xfs_attr_sf_entry xfs_attr_sf_entry_t;
 
 /*
  * We generate this then sort it, attr_list() must return things in hash-order.
@@ -28,15 +27,17 @@ typedef struct xfs_attr_sf_sort {
 } xfs_attr_sf_sort_t;
 
 #define XFS_ATTR_SF_ENTSIZE_BYNAME(nlen,vlen)	/* space name/value uses */ \
-	(((int)sizeof(xfs_attr_sf_entry_t)-1 + (nlen)+(vlen)))
+	(((int)sizeof(struct xfs_attr_sf_entry)-1 + (nlen)+(vlen)))
 #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
 	((1 << (NBBY*(int)sizeof(uint8_t))) - 1)
 #define XFS_ATTR_SF_ENTSIZE(sfep)		/* space an entry uses */ \
-	((int)sizeof(xfs_attr_sf_entry_t)-1 + (sfep)->namelen+(sfep)->valuelen)
+	((int)sizeof(struct xfs_attr_sf_entry)-1 + \
+		(sfep)->namelen+(sfep)->valuelen)
 #define XFS_ATTR_SF_NEXTENTRY(sfep)		/* next entry in struct */ \
-	((xfs_attr_sf_entry_t *)((char *)(sfep) + XFS_ATTR_SF_ENTSIZE(sfep)))
+	((struct xfs_attr_sf_entry *)((char *)(sfep) + \
+		XFS_ATTR_SF_ENTSIZE(sfep)))
 #define XFS_ATTR_SF_TOTSIZE(dp)			/* total space in use */ \
-	(be16_to_cpu(((xfs_attr_shortform_t *)	\
+	(be16_to_cpu(((struct xfs_attr_shortform *)	\
 		((dp)->i_afp->if_u1.if_data))->hdr.totsize))
 
 #endif	/* __XFS_ATTR_SF_H__ */
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index d92909e1c831..d2410c76c1fd 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -211,7 +211,7 @@ process_shortform_attr(
 	int		*repair)
 {
 	xfs_attr_shortform_t	*asf;
-	xfs_attr_sf_entry_t	*currententry, *nextentry, *tempentry;
+	struct xfs_attr_sf_entry	*currententry, *nextentry, *tempentry;
 	int			i, junkit;
 	int			currentsize, remainingspace;
 
@@ -250,7 +250,7 @@ process_shortform_attr(
 		junkit = 0;
 
 		/* don't go off the end if the hdr.count was off */
-		if ((currentsize + (sizeof(xfs_attr_sf_entry_t) - 1)) >
+		if ((currentsize + (sizeof(struct xfs_attr_sf_entry) - 1)) >
 						be16_to_cpu(asf->hdr.totsize))
 			break; /* get out and reset count and totSize */
 
@@ -322,7 +322,7 @@ process_shortform_attr(
 				do_warn(
 	_("removing attribute entry %d for inode %" PRIu64 "\n"),
 					i, ino);
-				tempentry = (xfs_attr_sf_entry_t *)
+				tempentry = (struct xfs_attr_sf_entry *)
 					((intptr_t) currententry +
 					 XFS_ATTR_SF_ENTSIZE(currententry));
 				memmove(currententry,tempentry,remainingspace);
@@ -338,7 +338,7 @@ process_shortform_attr(
 		}
 
 		/* Let's get ready for the next entry... */
-		nextentry = (xfs_attr_sf_entry_t *)((intptr_t) nextentry +
+		nextentry = (struct xfs_attr_sf_entry *)((intptr_t) nextentry +
 			 		XFS_ATTR_SF_ENTSIZE(currententry));
 		currentsize = currentsize + XFS_ATTR_SF_ENTSIZE(currententry);
 

