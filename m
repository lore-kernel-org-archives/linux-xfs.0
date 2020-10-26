Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DF4C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7329820872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:37:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sg+7X4bl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407209AbgJZXhV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:37:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38390 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407207AbgJZXhU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:37:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNP1Gm157959;
        Mon, 26 Oct 2020 23:37:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=o0rs+idSTeN/8vCzlAiJNr5sc7hhyJW0FeiqDHk8R7w=;
 b=Sg+7X4bls+yToqm15051YtVhCQDjpYDPzdGov7yQ6wWKCvprMI+FRrzHd7YYnqds0whp
 IFdWpb/AnBaDQJSONuRUKxGzqnIUbTKeDLlL22Bhqg+7dZ+7qkIoURyyvM1JNXcoXXM4
 fLcprhG5cum3Zrv6nr4733WH+DmyFCbbU0uEUkktq+dyx6CSTgfWUtnGe69cVlE5r8qN
 kOtRMhxlIGhQ3ybS9VzSSrHG/whBTtFwh4+UIl87bs0fku38Xwt15pMPkjZCG6oHF4H7
 Vm8r/+K6wQi2l9OJNU+D2OLk8SR+Bl6LJSJwVrbwIxNbzA165Zlp8DL4v/6jS3fCHSRl tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:37:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQE3Z032468;
        Mon, 26 Oct 2020 23:37:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34cx1q2ctc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:37:12 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNbBn8029882;
        Mon, 26 Oct 2020 23:37:11 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:37:11 -0700
Subject: [PATCH 02/21] xfs: Remove typedef xfs_attr_shortform_t
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:37:10 -0700
Message-ID: <160375543016.882906.12015749733580450608.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=2 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=2
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cmaiolino@redhat.com>

Source kernel commit: 47e6cc100054c8c6b809e25c286a2fd82e82bcb7

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/attrshort.c         |   18 +++++++++---------
 db/check.c             |    4 ++--
 db/inode.c             |    4 ++--
 db/metadump.c          |    4 ++--
 libxfs/xfs_attr_leaf.c |   16 ++++++++--------
 libxfs/xfs_da_format.h |    4 ++--
 repair/attr_repair.c   |    8 ++++----
 repair/dinode.c        |    6 +++---
 8 files changed, 32 insertions(+), 32 deletions(-)


diff --git a/db/attrshort.c b/db/attrshort.c
index 15532a062caa..5746c66a62e0 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -18,7 +18,7 @@ static int	attr_sf_entry_value_offset(void *obj, int startoff, int idx);
 static int	attr_shortform_list_count(void *obj, int startoff);
 static int	attr_shortform_list_offset(void *obj, int startoff, int idx);
 
-#define	OFF(f)	bitize(offsetof(xfs_attr_shortform_t, f))
+#define	OFF(f)	bitize(offsetof(struct xfs_attr_shortform, f))
 const field_t	attr_shortform_flds[] = {
 	{ "hdr", FLDT_ATTR_SF_HDR, OI(OFF(hdr)), C1, 0, TYP_NONE },
 	{ "list", FLDT_ATTR_SF_ENTRY, attr_shortform_list_offset,
@@ -71,10 +71,10 @@ attr_sf_entry_size(
 {
 	struct xfs_attr_sf_entry	*e;
 	int			i;
-	xfs_attr_shortform_t	*sf;
+	struct xfs_attr_shortform	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = (xfs_attr_shortform_t *)((char *)obj + byteize(startoff));
+	sf = (struct xfs_attr_shortform *)((char *)obj + byteize(startoff));
 	e = &sf->list[0];
 	for (i = 0; i < idx; i++)
 		e = XFS_ATTR_SF_NEXTENTRY(e);
@@ -113,10 +113,10 @@ attr_shortform_list_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_attr_shortform_t	*sf;
+	struct xfs_attr_shortform	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = (xfs_attr_shortform_t *)((char *)obj + byteize(startoff));
+	sf = (struct xfs_attr_shortform *)((char *)obj + byteize(startoff));
 	return sf->hdr.count;
 }
 
@@ -128,10 +128,10 @@ attr_shortform_list_offset(
 {
 	struct xfs_attr_sf_entry	*e;
 	int			i;
-	xfs_attr_shortform_t	*sf;
+	struct xfs_attr_shortform	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = (xfs_attr_shortform_t *)((char *)obj + byteize(startoff));
+	sf = (struct xfs_attr_shortform *)((char *)obj + byteize(startoff));
 	e = &sf->list[0];
 	for (i = 0; i < idx; i++)
 		e = XFS_ATTR_SF_NEXTENTRY(e);
@@ -147,11 +147,11 @@ attrshort_size(
 {
 	struct xfs_attr_sf_entry	*e;
 	int			i;
-	xfs_attr_shortform_t	*sf;
+	struct xfs_attr_shortform	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(idx == 0);
-	sf = (xfs_attr_shortform_t *)((char *)obj + byteize(startoff));
+	sf = (struct xfs_attr_shortform *)((char *)obj + byteize(startoff));
 	e = &sf->list[0];
 	for (i = 0; i < sf->hdr.count; i++)
 		e = XFS_ATTR_SF_NEXTENTRY(e);
diff --git a/db/check.c b/db/check.c
index 5aede6cca15c..0696542a60bb 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3046,7 +3046,7 @@ process_lclinode(
 	blkmap_t		**blkmapp,
 	int			whichfork)
 {
-	xfs_attr_shortform_t	*asf;
+	struct xfs_attr_shortform	*asf;
 	xfs_fsblock_t		bno;
 
 	bno = XFS_INO_TO_FSB(mp, id->ino);
@@ -3059,7 +3059,7 @@ process_lclinode(
 		error++;
 	}
 	else if (whichfork == XFS_ATTR_FORK) {
-		asf = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
+		asf = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
 		if (be16_to_cpu(asf->hdr.totsize) > XFS_DFORK_ASIZE(dip, mp)) {
 			if (!sflag || id->ilist || CHECK_BLIST(bno))
 				dbprintf(_("local inode %lld attr is too large "
diff --git a/db/inode.c b/db/inode.c
index f0e08ebf5ad9..94eaa91d68af 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -327,7 +327,7 @@ inode_a_size(
 	int			startoff,
 	int			idx)
 {
-	xfs_attr_shortform_t	*asf;
+	struct xfs_attr_shortform	*asf;
 	xfs_dinode_t		*dip;
 
 	ASSERT(startoff == 0);
@@ -335,7 +335,7 @@ inode_a_size(
 	dip = obj;
 	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_LOCAL:
-		asf = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
+		asf = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
 		return bitize(be16_to_cpu(asf->hdr.totsize));
 	case XFS_DINODE_FMT_EXTENTS:
 		return (int)be16_to_cpu(dip->di_anextents) *
diff --git a/db/metadump.c b/db/metadump.c
index 12a5cba7616d..468235cc94b1 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1370,12 +1370,12 @@ process_sf_attr(
 	 * values with 'v' (to see a valid string length, as opposed to NULLs)
 	 */
 
-	xfs_attr_shortform_t	*asfp;
+	struct xfs_attr_shortform	*asfp;
 	struct xfs_attr_sf_entry	*asfep;
 	int			ino_attr_size;
 	int			i;
 
-	asfp = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
+	asfp = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
 	if (asfp->hdr.count == 0)
 		return;
 
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 0ed5297ed357..a14cdbda1d70 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -725,14 +725,14 @@ xfs_attr_shortform_add(
 
 	ifp = dp->i_afp;
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
-	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
+	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	if (xfs_attr_sf_findname(args, &sfe, NULL) == -EEXIST)
 		ASSERT(0);
 
 	offset = (char *)sfe - (char *)sf;
 	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
 	xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
-	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
+	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	sfe = (struct xfs_attr_sf_entry *)((char *)sf + offset);
 
 	sfe->namelen = args->namelen;
@@ -784,7 +784,7 @@ xfs_attr_shortform_remove(
 
 	dp = args->dp;
 	mp = dp->i_mount;
-	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
+	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
 
 	error = xfs_attr_sf_findname(args, &sfe, &base);
 	if (error != -EEXIST)
@@ -834,7 +834,7 @@ xfs_attr_shortform_remove(
 int
 xfs_attr_shortform_lookup(xfs_da_args_t *args)
 {
-	xfs_attr_shortform_t *sf;
+	struct xfs_attr_shortform *sf;
 	struct xfs_attr_sf_entry *sfe;
 	int i;
 	struct xfs_ifork *ifp;
@@ -843,7 +843,7 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 
 	ifp = args->dp->i_afp;
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
-	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
+	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
@@ -870,7 +870,7 @@ xfs_attr_shortform_getvalue(
 	int			i;
 
 	ASSERT(args->dp->i_afp->if_flags == XFS_IFINLINE);
-	sf = (xfs_attr_shortform_t *)args->dp->i_afp->if_u1.if_data;
+	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
@@ -905,12 +905,12 @@ xfs_attr_shortform_to_leaf(
 
 	dp = args->dp;
 	ifp = dp->i_afp;
-	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
+	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	size = be16_to_cpu(sf->hdr.totsize);
 	tmpbuffer = kmem_alloc(size, 0);
 	ASSERT(tmpbuffer != NULL);
 	memcpy(tmpbuffer, ifp->if_u1.if_data, size);
-	sf = (xfs_attr_shortform_t *)tmpbuffer;
+	sf = (struct xfs_attr_shortform *)tmpbuffer;
 
 	xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
 	xfs_bmap_local_to_extents_empty(args->trans, dp, XFS_ATTR_FORK);
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 059ac108b1b3..e708b714bf99 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -579,7 +579,7 @@ xfs_dir2_block_leaf_p(struct xfs_dir2_block_tail *btp)
 /*
  * Entries are packed toward the top as tight as possible.
  */
-typedef struct xfs_attr_shortform {
+struct xfs_attr_shortform {
 	struct xfs_attr_sf_hdr {	/* constant-structure header block */
 		__be16	totsize;	/* total bytes in shortform list */
 		__u8	count;	/* count of active entries */
@@ -591,7 +591,7 @@ typedef struct xfs_attr_shortform {
 		uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
 		uint8_t nameval[1];	/* name & value bytes concatenated */
 	} list[1];			/* variable sized array */
-} xfs_attr_shortform_t;
+};
 
 typedef struct xfs_attr_leaf_map {	/* RLE map of free bytes */
 	__be16	base;			  /* base of free region */
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index d2410c76c1fd..e0580141c479 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -210,14 +210,14 @@ process_shortform_attr(
 	xfs_dinode_t	*dip,
 	int		*repair)
 {
-	xfs_attr_shortform_t	*asf;
+	struct xfs_attr_shortform	*asf;
 	struct xfs_attr_sf_entry	*currententry, *nextentry, *tempentry;
 	int			i, junkit;
 	int			currentsize, remainingspace;
 
 	*repair = 0;
 
-	asf = (xfs_attr_shortform_t *) XFS_DFORK_APTR(dip);
+	asf = (struct xfs_attr_shortform *) XFS_DFORK_APTR(dip);
 
 	/* Assumption: hdr.totsize is less than a leaf block and was checked
 	 * by lclinode for valid sizes. Check the count though.
@@ -1212,9 +1212,9 @@ process_attributes(
 	int		err;
 	__u8		aformat = dip->di_aformat;
 #ifdef DEBUG
-	xfs_attr_shortform_t *asf;
+	struct xfs_attr_shortform *asf;
 
-	asf = (xfs_attr_shortform_t *) XFS_DFORK_APTR(dip);
+	asf = (struct xfs_attr_shortform *) XFS_DFORK_APTR(dip);
 #endif
 
 	if (aformat == XFS_DINODE_FMT_LOCAL) {
diff --git a/repair/dinode.c b/repair/dinode.c
index 16f52c38a43a..076fc34bfb1c 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -92,7 +92,7 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 	 */
 
 	if (!no_modify) {
-		xfs_attr_shortform_t *asf = (xfs_attr_shortform_t *)
+		struct xfs_attr_shortform *asf = (struct xfs_attr_shortform *)
 				XFS_DFORK_APTR(dino);
 		asf->hdr.totsize = cpu_to_be16(sizeof(xfs_attr_sf_hdr_t));
 		asf->hdr.count = 0;
@@ -977,7 +977,7 @@ process_lclinode(
 	xfs_dinode_t		*dip,
 	int			whichfork)
 {
-	xfs_attr_shortform_t	*asf;
+	struct xfs_attr_shortform	*asf;
 	xfs_ino_t		lino;
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
@@ -989,7 +989,7 @@ process_lclinode(
 			XFS_DFORK_DSIZE(dip, mp));
 		return(1);
 	} else if (whichfork == XFS_ATTR_FORK) {
-		asf = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
+		asf = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
 		if (be16_to_cpu(asf->hdr.totsize) > XFS_DFORK_ASIZE(dip, mp)) {
 			do_warn(
 	_("local inode %" PRIu64 " attr fork too large (size %d, max = %zu)\n"),

