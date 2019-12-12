Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16434C04E30
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD0DE206C3
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:18:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RHa+yDoq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfLLESL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 23:18:11 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45096 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbfLLESK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Dec 2019 23:18:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4ELp5128863
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=jp+Rr1LHEmYWXio1APmEqAMLSbsNoo+3Cc10/gap1DI=;
 b=RHa+yDoq2+UBH/AIPdAklcUnZkVtGIs1MUxEtr2+MgyzCeuEGVYNAb0HYQRPE6L6aXn9
 xG4EBsDkxMgocKV9zdjpV0787Kl6/OKP4AN2g6GPcw1S6Bk7iqnelI+lEJsGrYkN3bUL
 5lgZcNESeSNUU4LezOSUXtsP9cuC4qv0OywrVtxlSYw36co1vDdkKdVWsTCayo9QTRII
 jVF/8n6RPS5LX2ujVB/R5DrD2iacpcyFiCaxorlbkxM9s/LvStznUQUFBwDCSkZiSgvt
 mNpy/17RHc0YI2bOSSBntuBBnRv6lEoASX8E9bmOeNC8WBkjbx8PBHFPn+9xR5+TMpNz UQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wr4qrre61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4E3QP127131
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wu2fvep6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:09 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBC4I8Kl016207
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:08 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Dec 2019 20:18:08 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 04/14] xfsprogs: Add xfs_has_attr and subroutines
Date:   Wed, 11 Dec 2019 21:17:53 -0700
Message-Id: <20191212041803.14018-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212041803.14018-1-allison.henderson@oracle.com>
References: <20191212041803.14018-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a new functions to check for the existence of
an attribute.  Subroutines are also added to handle the cases
of leaf blocks, nodes or shortform.  Common code that appears
in existing attr add and remove functions have been factored
out to help reduce the appearence of duplicated code.  We will
need these routines later for delayed attributes since delayed
operations cannot return error codes.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c      | 168 ++++++++++++++++++++++++++++++++-----------------
 libxfs/xfs_attr.h      |   1 +
 libxfs/xfs_attr_leaf.c | 110 ++++++++++++++++++++------------
 libxfs/xfs_attr_leaf.h |   3 +
 4 files changed, 183 insertions(+), 99 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 4fe27f1..153888d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -45,6 +45,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -52,6 +53,8 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
+				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 
@@ -309,6 +312,36 @@ xfs_attr_set_args(
 }
 
 /*
+ * Return EEXIST if attr is found, or ENOATTR if not
+ */
+int
+xfs_has_attr(
+	struct xfs_da_args      *args)
+{
+	struct xfs_inode	*dp = args->dp;
+
+	if (!xfs_inode_hasattr(dp))
+		return -ENOATTR;
+
+	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
+		return xfs_attr_sf_findname(args, NULL, NULL);
+	}
+
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+		struct xfs_buf	*bp = NULL;
+		int		error = xfs_attr_leaf_hasname(args, &bp);
+
+		if (bp)
+			xfs_trans_brelse(args->trans, bp);
+
+		return error;
+	}
+
+	return xfs_attr_node_hasname(args, NULL);
+}
+
+/*
  * Remove the attribute specified in @args.
  */
 int
@@ -582,26 +615,20 @@ STATIC int
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
+	retval = xfs_attr_leaf_hasname(args, &bp);
+	if (retval != -ENOATTR && retval != -EEXIST)
+		return retval;
+
 	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
 		xfs_trans_brelse(args->trans, bp);
 		return retval;
@@ -753,6 +780,23 @@ xfs_attr_leaf_addname(
 }
 
 /*
+ * Return EEXIST if attr is found, or ENOATTR if not
+ */
+STATIC int
+xfs_attr_leaf_hasname(
+	struct xfs_da_args      *args,
+	struct xfs_buf		**bp)
+{
+	int                     error = 0;
+
+	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, -1, bp);
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
@@ -772,13 +816,12 @@ xfs_attr_leaf_removename(
 	 * Remove the attribute.
 	 */
 	dp = args->dp;
-	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
-	if (error)
+
+	error = xfs_attr_leaf_hasname(args, &bp);
+	if (error != -ENOATTR && error != -EEXIST)
 		return error;
 
-	error = xfs_attr3_leaf_lookup_int(bp, args);
-	if (error == -ENOATTR) {
+	if (error != -EEXIST) {
 		xfs_trans_brelse(args->trans, bp);
 		return error;
 	}
@@ -816,12 +859,10 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 
 	trace_xfs_attr_leaf_get(args);
 
-	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
-	if (error)
+	error = xfs_attr_leaf_hasname(args, &bp);
+	if (error != -ENOATTR && error != -EEXIST)
 		return error;
 
-	error = xfs_attr3_leaf_lookup_int(bp, args);
 	if (error != -EEXIST)  {
 		xfs_trans_brelse(args->trans, bp);
 		return error;
@@ -831,6 +872,41 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 	return error;
 }
 
+/*
+ * Return EEXIST if attr is found, or ENOATTR if not
+ * statep: If not null is set to point at the found state.  Caller will
+ *         be responsible for freeing the state in this case.
+ */
+STATIC int
+xfs_attr_node_hasname(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	**statep)
+{
+	struct xfs_da_state	*state;
+	int			retval, error;
+
+	state = xfs_da_state_alloc();
+	state->args = args;
+	state->mp = args->dp->i_mount;
+
+	if (statep != NULL)
+		*statep = NULL;
+
+	/*
+	 * Search to see if name exists, and get back a pointer to it.
+	 */
+	error = xfs_da3_node_lookup_int(state, &retval);
+	if (error == 0) {
+		if (statep != NULL)
+			*statep = state;
+		return retval;
+	}
+
+	xfs_da_state_free(state);
+
+	return error;
+}
+
 /*========================================================================
  * External routines when attribute list size > geo->blksize
  *========================================================================*/
@@ -863,20 +939,17 @@ xfs_attr_node_addname(
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
+	retval = xfs_attr_node_hasname(args, &state);
+	if (retval != -ENOATTR)
 		goto out;
+
 	blk = &state->path.blk[ state->path.active-1 ];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
+	if (args->name.type & ATTR_REPLACE) {
 		goto out;
 	} else if (retval == -EEXIST) {
 		if (args->name.type & ATTR_CREATE)
@@ -1078,29 +1151,15 @@ xfs_attr_node_removename(
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
@@ -1195,7 +1254,8 @@ xfs_attr_node_removename(
 	error = 0;
 
 out:
-	xfs_da_state_free(state);
+	if (state)
+		xfs_da_state_free(state);
 	return error;
 }
 
@@ -1317,31 +1377,23 @@ xfs_attr_node_get(xfs_da_args_t *args)
 {
 	xfs_da_state_t *state;
 	xfs_da_state_blk_t *blk;
-	int error, retval;
+	int error;
 	int i;
 
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
-		retval = error;
-		goto out_release;
-	}
-	if (retval != -EEXIST)
+	error = xfs_attr_node_hasname(args, &state);
+	if (error != -EEXIST)
 		goto out_release;
 
 	/*
 	 * Get the value, local or "remote"
 	 */
 	blk = &state->path.blk[state->path.active - 1];
-	retval = xfs_attr3_leaf_getvalue(blk->bp, args);
+	error = xfs_attr3_leaf_getvalue(blk->bp, args);
 
 	/*
 	 * If not in a transaction, we have to release all the buffers.
@@ -1353,7 +1405,7 @@ out_release:
 	}
 
 	xfs_da_state_free(state);
-	return retval;
+	return error;
 }
 
 /* Returns true if the attribute entry name is valid. */
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 44dd07a..3b5dad4 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -150,6 +150,7 @@ int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
 		 unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
+int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 1389970..7511eb1 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -586,18 +586,66 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
 }
 
 /*
+ * Return -EEXIST if attr is found, or -ENOATTR if not
+ * args:  args containing attribute name and namelen
+ * sfep:  If not null, pointer will be set to the last attr entry found on
+	  -EEXIST.  On -ENOATTR pointer is left at the last entry in the list
+ * basep: If not null, pointer is set to the byte offset of the entry in the
+ *	  list on -EEXIST.  On -ENOATTR, pointer is left at the byte offset of
+ *	  the last entry in the list
+ */
+int
+xfs_attr_sf_findname(
+	struct xfs_da_args	 *args,
+	struct xfs_attr_sf_entry **sfep,
+	unsigned int		 *basep)
+{
+	struct xfs_attr_shortform *sf;
+	struct xfs_attr_sf_entry *sfe;
+	unsigned int		base = sizeof(struct xfs_attr_sf_hdr);
+	int			size = 0;
+	int			end;
+	int			i;
+
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
 void
-xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
+xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff)
 {
-	xfs_attr_shortform_t *sf;
-	xfs_attr_sf_entry_t *sfe;
-	int i, offset, size;
-	xfs_mount_t *mp;
-	xfs_inode_t *dp;
-	struct xfs_ifork *ifp;
+	struct xfs_attr_shortform	*sf;
+	struct xfs_attr_sf_entry	*sfe;
+	int				offset, size, error;
+	struct xfs_mount		*mp;
+	struct xfs_inode		*dp;
+	struct xfs_ifork		*ifp;
 
 	trace_xfs_attr_sf_add(args);
 
@@ -608,18 +656,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
 	ifp = dp->i_afp;
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
-	sfe = &sf->list[0];
-	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
-#ifdef DEBUG
-		if (sfe->namelen != args->name.len)
-			continue;
-		if (memcmp(args->name.name, sfe->nameval, args->name.len) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
-			continue;
-		ASSERT(0);
-#endif
-	}
+	error = xfs_attr_sf_findname(args, &sfe, NULL);
+	ASSERT(error != -EEXIST);
 
 	offset = (char *)sfe - (char *)sf;
 	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
@@ -662,35 +700,25 @@ xfs_attr_fork_remove(
  * Remove an attribute from the shortform attribute list structure.
  */
 int
-xfs_attr_shortform_remove(xfs_da_args_t *args)
+xfs_attr_shortform_remove(struct xfs_da_args *args)
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
-	end = sf->hdr.count;
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
+	error = xfs_attr_sf_findname(args, &sfe, &base);
+	if (error != -EEXIST)
+		return error;
+	size = XFS_ATTR_SF_ENTSIZE(sfe);
 
 	/*
 	 * Fix up the attribute fork data, covering the hole
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index 7b74e18..736a9ba 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -39,6 +39,9 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
 			struct xfs_buf **leaf_bp);
 int	xfs_attr_shortform_remove(struct xfs_da_args *args);
+int	xfs_attr_sf_findname(struct xfs_da_args *args,
+			     struct xfs_attr_sf_entry **sfep,
+			     unsigned int *basep);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
 xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
-- 
2.7.4

