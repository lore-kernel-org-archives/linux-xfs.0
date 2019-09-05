Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A14F8C00306
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA5B220825
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QaZ55mxi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391172AbfIEWTL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33052 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388847AbfIEWTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ8bv078096
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=m1VewgX1b4wIxuQ2VeW77DUEgWeTJHDcu+yyiejNifY=;
 b=QaZ55mxi+WuIzhyXQ9sEBy8iasP898BjGO2bnIr3cf/y7J8W+QXRFbElrTftZWh8u4n9
 zBsx0KCX3O0vE84dYrmKPMxOHn88N0kP6gY7kSFyZZyEbF0Xcu2EmPExVE8drHkcwhzd
 qD4DslFN1pyAhQ85RXofgMQKt5ZSpvFvLXTwgnaPllAkSs7lyZNFu/PcoaCU5s+3Wg06
 L75vV49we4D8HH2lQKioaf/hMUjHRYn7+kOejPOmnltOPC3DEiKrKeowL/9Ybn1i0omh
 2dVfd0piLix2dQVo/ZgL2co6ZdufoyKNT47KlasC6PXxaGxlOZq7YbyEkQd+8WaQWZ/t Bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uuaqj02my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ2FP076437
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2utvr4a0s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:04 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x85MIjLn032470
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:18:45 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:18:44 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 04/19] xfs: Add xfs_has_attr and subroutines
Date:   Thu,  5 Sep 2019 15:18:22 -0700
Message-Id: <20190905221837.17388-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221837.17388-1-allison.henderson@oracle.com>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a new functions to check for the existence of
an attribute.  Subroutines are also added to handle the cases
of leaf blocks, nodes or shortform.  Common code that appears
in existing attr add and remove functions have been factored
out to help reduce the appearence of duplicated code.  We will
need these routines later for delayed attributes since delayed
operations cannot return error codes.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 150 +++++++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_attr.h      |   1 +
 fs/xfs/libxfs/xfs_attr_leaf.c |  92 +++++++++++++++++---------
 fs/xfs/libxfs/xfs_attr_leaf.h |   2 +
 4 files changed, 161 insertions(+), 84 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 50e099f..a297857 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -46,6 +46,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
+STATIC int xfs_leaf_has_attr(struct xfs_da_args *args, struct xfs_buf **bp);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -53,6 +54,8 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
+				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 
@@ -309,6 +312,32 @@ xfs_attr_set_args(
 }
 
 /*
+ * Return EEXIST if attr is found, or ENOATTR if not
+ */
+int
+xfs_has_attr(
+	struct xfs_da_args      *args)
+{
+	struct xfs_inode        *dp = args->dp;
+	struct xfs_buf		*bp;
+	int                     error;
+
+	if (!xfs_inode_hasattr(dp)) {
+		error = -ENOATTR;
+	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
+		error = xfs_shortform_has_attr(args, NULL, NULL);
+	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+		error = xfs_leaf_has_attr(args, &bp);
+		xfs_trans_brelse(args->trans, bp);
+	} else {
+		error = xfs_attr_node_hasname(args, NULL);
+	}
+
+	return error;
+}
+
+/*
  * Remove the attribute specified in @args.
  */
 int
@@ -574,26 +603,17 @@ STATIC int
 xfs_attr_leaf_addname(
 	struct xfs_da_args	*args)
 {
-	struct xfs_inode	*dp;
 	struct xfs_buf		*bp;
 	int			retval, error, forkoff;
+	struct xfs_inode	*dp = args->dp;
 
 	trace_xfs_attr_leaf_addname(args);
 
 	/*
-	 * Read the (only) block in the attribute list in.
-	 */
-	dp = args->dp;
-	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
-	if (error)
-		return error;
-
-	/*
 	 * Look up the given attribute in the leaf block.  Figure out if
 	 * the given flags produce an error or call for an atomic rename.
 	 */
-	retval = xfs_attr3_leaf_lookup_int(bp, args);
+	retval = xfs_leaf_has_attr(args, &bp);
 	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
 		xfs_trans_brelse(args->trans, bp);
 		return retval;
@@ -745,6 +765,25 @@ xfs_attr_leaf_addname(
 }
 
 /*
+ * Return EEXIST if attr is found, or ENOATTR if not
+ */
+STATIC int
+xfs_leaf_has_attr(
+	struct xfs_da_args      *args,
+	struct xfs_buf		**bp)
+{
+	int                     error = 0;
+
+	args->blkno = 0;
+	error = xfs_attr3_leaf_read(args->trans, args->dp,
+			args->blkno, XFS_DABUF_MAP_NOMAPPING, bp);
+	if (error)
+		return error;
+
+	return xfs_attr3_leaf_lookup_int(*bp, args);
+}
+
+/*
  * Remove a name from the leaf attribute list structure
  *
  * This leaf block cannot have a "remote" value, we only call this routine
@@ -764,12 +803,8 @@ xfs_attr_leaf_removename(
 	 * Remove the attribute.
 	 */
 	dp = args->dp;
-	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
-	if (error)
-		return error;
 
-	error = xfs_attr3_leaf_lookup_int(bp, args);
+	error = xfs_leaf_has_attr(args, &bp);
 	if (error == -ENOATTR) {
 		xfs_trans_brelse(args->trans, bp);
 		return error;
@@ -808,12 +843,7 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 
 	trace_xfs_attr_leaf_get(args);
 
-	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
-	if (error)
-		return error;
-
-	error = xfs_attr3_leaf_lookup_int(bp, args);
+	error = xfs_leaf_has_attr(args, &bp);
 	if (error != -EEXIST)  {
 		xfs_trans_brelse(args->trans, bp);
 		return error;
@@ -823,6 +853,43 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 	return error;
 }
 
+/*
+ * Return EEXIST if attr is found, or ENOATTR if not
+ * statep: If not null is set to point at the found state.  Caller will
+ * 	   be responsible for freeing the state in this case.
+ */
+STATIC int
+xfs_attr_node_hasname(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	**statep)
+{
+	struct xfs_da_state	*state;
+	struct xfs_inode	*dp;
+	int			retval, error;
+
+	/*
+	 * Tie a string around our finger to remind us where we are.
+	 */
+	dp = args->dp;
+	state = xfs_da_state_alloc();
+	state->args = args;
+	state->mp = dp->i_mount;
+
+	/*
+	 * Search to see if name exists, and get back a pointer to it.
+	 */
+	error = xfs_da3_node_lookup_int(state, &retval);
+	if (error == 0)
+		error = retval;
+
+	if (statep != NULL)
+		*statep = state;
+	else
+		xfs_da_state_free(state);
+
+	return error;
+}
+
 /*========================================================================
  * External routines when attribute list size > geo->blksize
  *========================================================================*/
@@ -855,17 +922,14 @@ xfs_attr_node_addname(
 	dp = args->dp;
 	mp = dp->i_mount;
 restart:
-	state = xfs_da_state_alloc();
-	state->args = args;
-	state->mp = mp;
-
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	error = xfs_da3_node_lookup_int(state, &retval);
-	if (error)
+	error = xfs_attr_node_hasname(args, &state);
+	if (error == -EEXIST)
 		goto out;
+
 	blk = &state->path.blk[ state->path.active-1 ];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
@@ -1070,29 +1134,15 @@ xfs_attr_node_removename(
 {
 	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
-	struct xfs_inode	*dp;
 	struct xfs_buf		*bp;
 	int			retval, error, forkoff;
+	struct xfs_inode	*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
 
-	/*
-	 * Tie a string around our finger to remind us where we are.
-	 */
-	dp = args->dp;
-	state = xfs_da_state_alloc();
-	state->args = args;
-	state->mp = dp->i_mount;
-
-	/*
-	 * Search to see if name exists, and get back a pointer to it.
-	 */
-	error = xfs_da3_node_lookup_int(state, &retval);
-	if (error || (retval != -EEXIST)) {
-		if (error == 0)
-			error = retval;
+	error = xfs_attr_node_hasname(args, &state);
+	if (error != -EEXIST)
 		goto out;
-	}
 
 	/*
 	 * If there is an out-of-line value, de-allocate the blocks.
@@ -1314,20 +1364,14 @@ xfs_attr_node_get(xfs_da_args_t *args)
 
 	trace_xfs_attr_node_get(args);
 
-	state = xfs_da_state_alloc();
-	state->args = args;
-	state->mp = args->dp->i_mount;
-
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
 	 */
-	error = xfs_da3_node_lookup_int(state, &retval);
-	if (error) {
+	error = xfs_attr_node_hasname(args, &state);
+	if (error != -EEXIST) {
 		retval = error;
 		goto out_release;
 	}
-	if (retval != -EEXIST)
-		goto out_release;
 
 	/*
 	 * Get the value, local or "remote"
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index cedb4e2..fb56d81 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -150,6 +150,7 @@ int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
 		 unsigned char *value, int valuelen);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name);
+int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 07ce320..a501538 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -590,6 +590,53 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
 }
 
 /*
+ * Return EEXIST if attr is found, or ENOATTR if not
+ * args:  args containing attribute name and namelen
+ * sfep:  If not null, pointer will be set to the last attr entry found
+ * basep: If not null, pointer is set to the byte offset of the entry in the
+ *	  list
+ */
+int
+xfs_shortform_has_attr(
+	struct xfs_da_args	 *args,
+	struct xfs_attr_sf_entry **sfep,
+	int			 *basep)
+{
+	struct xfs_attr_shortform *sf;
+	struct xfs_attr_sf_entry *sfe;
+	int			base = sizeof(struct xfs_attr_sf_hdr);
+	int			size = 0;
+	int			end;
+	int			i;
+
+	base = sizeof(struct xfs_attr_sf_hdr);
+	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
+	sfe = &sf->list[0];
+	end = sf->hdr.count;
+	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
+			base += size, i++) {
+		size = XFS_ATTR_SF_ENTSIZE(sfe);
+		if (sfe->namelen != args->name.len)
+			continue;
+		if (memcmp(sfe->nameval, args->name.name, args->name.len) != 0)
+			continue;
+		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
+			continue;
+		break;
+	}
+
+	if (sfep != NULL)
+		*sfep = sfe;
+
+	if (basep != NULL)
+		*basep = base;
+
+	if (i == end)
+		return -ENOATTR;
+	return -EEXIST;
+}
+
+/*
  * Add a name/value pair to the shortform attribute list.
  * Overflow from the inode has already been checked for.
  */
@@ -598,7 +645,7 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
 {
 	xfs_attr_shortform_t *sf;
 	xfs_attr_sf_entry_t *sfe;
-	int i, offset, size;
+	int offset, size, error;
 	xfs_mount_t *mp;
 	xfs_inode_t *dp;
 	struct xfs_ifork *ifp;
@@ -612,18 +659,10 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
 	ifp = dp->i_afp;
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
-	sfe = &sf->list[0];
-	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
+	error = xfs_shortform_has_attr(args, &sfe, NULL);
 #ifdef DEBUG
-		if (sfe->namelen != args->name.len)
-			continue;
-		if (memcmp(args->name.name, sfe->nameval, args->name.len) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
-			continue;
-		ASSERT(0);
+	ASSERT(error != -EEXIST);
 #endif
-	}
 
 	offset = (char *)sfe - (char *)sf;
 	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
@@ -668,33 +707,24 @@ xfs_attr_fork_remove(
 int
 xfs_attr_shortform_remove(xfs_da_args_t *args)
 {
-	xfs_attr_shortform_t *sf;
-	xfs_attr_sf_entry_t *sfe;
-	int base, size=0, end, totsize, i;
-	xfs_mount_t *mp;
-	xfs_inode_t *dp;
+	struct xfs_attr_shortform	*sf;
+	struct xfs_attr_sf_entry	*sfe;
+	int				base, size = 0, end, totsize;
+	struct xfs_mount		*mp;
+	struct xfs_inode		*dp;
+	int				error;
 
 	trace_xfs_attr_sf_remove(args);
 
 	dp = args->dp;
 	mp = dp->i_mount;
-	base = sizeof(xfs_attr_sf_hdr_t);
 	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
-	sfe = &sf->list[0];
 	end = sf->hdr.count;
-	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
-					base += size, i++) {
-		size = XFS_ATTR_SF_ENTSIZE(sfe);
-		if (sfe->namelen != args->name.len)
-			continue;
-		if (memcmp(sfe->nameval, args->name.name, args->name.len) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
-			continue;
-		break;
-	}
-	if (i == end)
-		return -ENOATTR;
+
+	error = xfs_shortform_has_attr(args, &sfe, &base);
+	if (error == -ENOATTR)
+		return error;
+	size = XFS_ATTR_SF_ENTSIZE(sfe);
 
 	/*
 	 * Fix up the attribute fork data, covering the hole
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 536a290..58e9327 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -42,6 +42,8 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
 			struct xfs_buf **leaf_bp);
 int	xfs_attr_shortform_remove(struct xfs_da_args *args);
+int	xfs_shortform_has_attr(struct xfs_da_args *args,
+			       struct xfs_attr_sf_entry **sfep, int *basep);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
 xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
-- 
2.7.4

