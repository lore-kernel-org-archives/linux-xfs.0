Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1CD6C00306
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6F692082C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fht9ok1n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391128AbfIEWTR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58966 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391155AbfIEWTN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ9d8049751
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=oHxFGFXoq9+R2zhTTBCydpXteM2zyvFzhK1yxqxhNsA=;
 b=fht9ok1nO3jWzS4cWMdjiweuaj+6dCUMAubaj5wPpwiu0oWnEcrqwgAuRNVEnfkdffO2
 XhEunuAf+H9Cio79kJX1jIY0hY+Bs3pikC/Ocgo9grVN+MuicwZuGUI8JDexcgxyijDL
 46m5x70Jv84JBtTxygtiwCWQuRDPuGCqNTWbT1dKf26FA6ECBtQw/qLCfMzDyinW4n1e
 7iTzKen+Ly3zqjWEj4nlKevgFbweUQ7gxOt9RT9d5ip8VLnOvDhPgQK2wewpZ18Mp848
 U75MBpfArzFgngPEbtEgbXSIBriQ1beVCtdmJ+aoECn3VC6aUBFPRLAyqvfoC/BMn1I3 /A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2uuarc8207-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MIOeb101698
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uu1b946r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:04 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85MJ0PK008890
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:01 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:19:00 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 02/21] xfsprogs: Embed struct xfs_name in xfs_da_args
Date:   Thu,  5 Sep 2019 15:18:36 -0700
Message-Id: <20190905221855.17555-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221855.17555-1-allison.henderson@oracle.com>
References: <20190905221855.17555-1-allison.henderson@oracle.com>
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

This patch embeds an xfs_name in xfs_da_args, replacing the name,
namelen, and flags members.  This helps to clean up the xfs_da_args
structure and make it more uniform with the new xfs_name parameter
being passed around.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c        |  39 +++++++++--------
 libxfs/xfs_attr_leaf.c   | 112 +++++++++++++++++++++++++----------------------
 libxfs/xfs_attr_remote.c |   2 +-
 libxfs/xfs_da_btree.c    |   5 ++-
 libxfs/xfs_da_btree.h    |   4 +-
 libxfs/xfs_dir2.c        |  22 +++++-----
 libxfs/xfs_dir2_block.c  |   6 +--
 libxfs/xfs_dir2_leaf.c   |   6 +--
 libxfs/xfs_dir2_node.c   |   8 ++--
 libxfs/xfs_dir2_sf.c     |  30 ++++++-------
 10 files changed, 120 insertions(+), 114 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index f956c44..f036460 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -70,13 +70,13 @@ xfs_attr_args_init(
 	args->geo = dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	args->dp = dp;
-	args->flags = name->type;
-	args->name = name->name;
-	args->namelen = name->len;
-	if (args->namelen >= MAXNAMELEN)
+	args->name.type = name->type;
+	args->name.name = name->name;
+	args->name.len = name->len;
+	if (args->name.len >= MAXNAMELEN)
 		return -EFAULT;		/* match IRIX behaviour */
 
-	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	args->hashval = xfs_da_hashname(args->name.name, args->name.len);
 	return 0;
 }
 
@@ -200,7 +200,7 @@ xfs_attr_try_sf_addname(
 	 * Commit the shortform mods, and we're done.
 	 * NOTE: this is also the error path (EEXIST, etc).
 	 */
-	if (!error && (args->flags & ATTR_KERNOTIME) == 0)
+	if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
 		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
@@ -335,7 +335,7 @@ xfs_attr_set(
 	 */
 	if (XFS_IFORK_Q(dp) == 0) {
 		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
-			XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen, valuelen);
+			XFS_ATTR_SF_ENTSIZE_BYNAME(args.name.len, valuelen);
 
 		error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
 		if (error)
@@ -494,10 +494,10 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 	trace_xfs_attr_sf_addname(args);
 
 	retval = xfs_attr_shortform_lookup(args);
-	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
+	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
 		return retval;
 	} else if (retval == -EEXIST) {
-		if (args->flags & ATTR_CREATE)
+		if (args->name.type & ATTR_CREATE)
 			return retval;
 		retval = xfs_attr_shortform_remove(args);
 		if (retval)
@@ -507,15 +507,15 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 		 * that the leaf format add routine won't trip over the attr
 		 * not being around.
 		 */
-		args->flags &= ~ATTR_REPLACE;
+		args->name.type &= ~ATTR_REPLACE;
 	}
 
-	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
+	if (args->name.len >= XFS_ATTR_SF_ENTSIZE_MAX ||
 	    args->valuelen >= XFS_ATTR_SF_ENTSIZE_MAX)
 		return -ENOSPC;
 
 	newsize = XFS_ATTR_SF_TOTSIZE(args->dp);
-	newsize += XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
+	newsize += XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
 
 	forkoff = xfs_attr_shortform_bytesfit(args->dp, newsize);
 	if (!forkoff)
@@ -560,11 +560,11 @@ xfs_attr_leaf_addname(
 	 * the given flags produce an error or call for an atomic rename.
 	 */
 	retval = xfs_attr3_leaf_lookup_int(bp, args);
-	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
+	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
 		xfs_trans_brelse(args->trans, bp);
 		return retval;
 	} else if (retval == -EEXIST) {
-		if (args->flags & ATTR_CREATE) {	/* pure create op */
+		if (args->name.type & ATTR_CREATE) {	/* pure create op */
 			xfs_trans_brelse(args->trans, bp);
 			return retval;
 		}
@@ -784,7 +784,8 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 	}
 	error = xfs_attr3_leaf_getvalue(bp, args);
 	xfs_trans_brelse(args->trans, bp);
-	if (!error && (args->rmtblkno > 0) && !(args->flags & ATTR_KERNOVAL)) {
+	if (!error && (args->rmtblkno > 0) &&
+	    !(args->name.type & ATTR_KERNOVAL)) {
 		error = xfs_attr_rmtval_get(args);
 	}
 	return error;
@@ -835,10 +836,10 @@ restart:
 		goto out;
 	blk = &state->path.blk[ state->path.active-1 ];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
+	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
 		goto out;
 	} else if (retval == -EEXIST) {
-		if (args->flags & ATTR_CREATE)
+		if (args->name.type & ATTR_CREATE)
 			goto out;
 
 		trace_xfs_attr_node_replace(args);
@@ -970,7 +971,7 @@ restart:
 		 * The INCOMPLETE flag means that we will find the "old"
 		 * attr, not the "new" one.
 		 */
-		args->flags |= XFS_ATTR_INCOMPLETE;
+		args->name.type |= XFS_ATTR_INCOMPLETE;
 		state = xfs_da_state_alloc();
 		state->args = args;
 		state->mp = mp;
@@ -1299,7 +1300,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
 		 */
 		retval = xfs_attr3_leaf_getvalue(blk->bp, args);
 		if (!retval && (args->rmtblkno > 0)
-		    && !(args->flags & ATTR_KERNOVAL)) {
+		    && !(args->name.type & ATTR_KERNOVAL)) {
 			retval = xfs_attr_rmtval_get(args);
 		}
 	}
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index b865119..b8136ed 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -567,27 +567,27 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
 #ifdef DEBUG
-		if (sfe->namelen != args->namelen)
+		if (sfe->namelen != args->name.len)
 			continue;
-		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
+		if (memcmp(args->name.name, sfe->nameval, args->name.len) != 0)
 			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
+		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
 			continue;
 		ASSERT(0);
 #endif
 	}
 
 	offset = (char *)sfe - (char *)sf;
-	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
+	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
 	xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
 	sfe = (xfs_attr_sf_entry_t *)((char *)sf + offset);
 
-	sfe->namelen = args->namelen;
+	sfe->namelen = args->name.len;
 	sfe->valuelen = args->valuelen;
-	sfe->flags = XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags);
-	memcpy(sfe->nameval, args->name, args->namelen);
-	memcpy(&sfe->nameval[args->namelen], args->value, args->valuelen);
+	sfe->flags = XFS_ATTR_NSP_ARGS_TO_ONDISK(args->name.type);
+	memcpy(sfe->nameval, args->name.name, args->name.len);
+	memcpy(&sfe->nameval[args->name.len], args->value, args->valuelen);
 	sf->hdr.count++;
 	be16_add_cpu(&sf->hdr.totsize, size);
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_ADATA);
@@ -637,11 +637,11 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
 	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
 					base += size, i++) {
 		size = XFS_ATTR_SF_ENTSIZE(sfe);
-		if (sfe->namelen != args->namelen)
+		if (sfe->namelen != args->name.len)
 			continue;
-		if (memcmp(sfe->nameval, args->name, args->namelen) != 0)
+		if (memcmp(sfe->nameval, args->name.name, args->name.len) != 0)
 			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
+		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
 			continue;
 		break;
 	}
@@ -704,11 +704,11 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
-		if (sfe->namelen != args->namelen)
+		if (sfe->namelen != args->name.len)
 			continue;
-		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
+		if (memcmp(args->name.name, sfe->nameval, args->name.len) != 0)
 			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
+		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
 			continue;
 		return -EEXIST;
 	}
@@ -731,13 +731,13 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
-		if (sfe->namelen != args->namelen)
+		if (sfe->namelen != args->name.len)
 			continue;
-		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
+		if (memcmp(args->name.name, sfe->nameval, args->name.len) != 0)
 			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
+		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
 			continue;
-		if (args->flags & ATTR_KERNOVAL) {
+		if (args->name.type & ATTR_KERNOVAL) {
 			args->valuelen = sfe->valuelen;
 			return -EEXIST;
 		}
@@ -746,7 +746,7 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
 			return -ERANGE;
 		}
 		args->valuelen = sfe->valuelen;
-		memcpy(args->value, &sfe->nameval[args->namelen],
+		memcpy(args->value, &sfe->nameval[args->name.len],
 						    args->valuelen);
 		return -EEXIST;
 	}
@@ -821,13 +821,13 @@ xfs_attr_shortform_to_leaf(
 
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count; i++) {
-		nargs.name = sfe->nameval;
-		nargs.namelen = sfe->namelen;
-		nargs.value = &sfe->nameval[nargs.namelen];
+		nargs.name.name = sfe->nameval;
+		nargs.name.len = sfe->namelen;
+		nargs.value = &sfe->nameval[nargs.name.len];
 		nargs.valuelen = sfe->valuelen;
 		nargs.hashval = xfs_da_hashname(sfe->nameval,
 						sfe->namelen);
-		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(sfe->flags);
+		nargs.name.type = XFS_ATTR_NSP_ONDISK_TO_ARGS(sfe->flags);
 		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error == -ENOATTR);
 		error = xfs_attr3_leaf_add(bp, &nargs);
@@ -1028,12 +1028,12 @@ xfs_attr3_leaf_to_shortform(
 			continue;
 		ASSERT(entry->flags & XFS_ATTR_LOCAL);
 		name_loc = xfs_attr3_leaf_name_local(leaf, i);
-		nargs.name = name_loc->nameval;
-		nargs.namelen = name_loc->namelen;
-		nargs.value = &name_loc->nameval[nargs.namelen];
+		nargs.name.name = name_loc->nameval;
+		nargs.name.len = name_loc->namelen;
+		nargs.value = &name_loc->nameval[nargs.name.len];
 		nargs.valuelen = be16_to_cpu(name_loc->valuelen);
 		nargs.hashval = be32_to_cpu(entry->hashval);
-		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(entry->flags);
+		nargs.name.type = XFS_ATTR_NSP_ONDISK_TO_ARGS(entry->flags);
 		xfs_attr_shortform_add(&nargs, forkoff);
 	}
 	error = 0;
@@ -1361,7 +1361,7 @@ xfs_attr3_leaf_add_work(
 				     ichdr->freemap[mapindex].size);
 	entry->hashval = cpu_to_be32(args->hashval);
 	entry->flags = tmp ? XFS_ATTR_LOCAL : 0;
-	entry->flags |= XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags);
+	entry->flags |= XFS_ATTR_NSP_ARGS_TO_ONDISK(args->name.type);
 	if (args->op_flags & XFS_DA_OP_RENAME) {
 		entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
@@ -1385,15 +1385,16 @@ xfs_attr3_leaf_add_work(
 	 */
 	if (entry->flags & XFS_ATTR_LOCAL) {
 		name_loc = xfs_attr3_leaf_name_local(leaf, args->index);
-		name_loc->namelen = args->namelen;
+		name_loc->namelen = args->name.len;
 		name_loc->valuelen = cpu_to_be16(args->valuelen);
-		memcpy((char *)name_loc->nameval, args->name, args->namelen);
-		memcpy((char *)&name_loc->nameval[args->namelen], args->value,
+		memcpy((char *)name_loc->nameval, args->name.name,
+		       args->name.len);
+		memcpy((char *)&name_loc->nameval[args->name.len], args->value,
 				   be16_to_cpu(name_loc->valuelen));
 	} else {
 		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
-		name_rmt->namelen = args->namelen;
-		memcpy((char *)name_rmt->name, args->name, args->namelen);
+		name_rmt->namelen = args->name.len;
+		memcpy((char *)name_rmt->name, args->name.name, args->name.len);
 		entry->flags |= XFS_ATTR_INCOMPLETE;
 		/* just in case */
 		name_rmt->valuelen = 0;
@@ -2306,29 +2307,31 @@ xfs_attr3_leaf_lookup_int(
 		 * If we are looking for INCOMPLETE entries, show only those.
 		 * If we are looking for complete entries, show only those.
 		 */
-		if ((args->flags & XFS_ATTR_INCOMPLETE) !=
+		if ((args->name.type & XFS_ATTR_INCOMPLETE) !=
 		    (entry->flags & XFS_ATTR_INCOMPLETE)) {
 			continue;
 		}
 		if (entry->flags & XFS_ATTR_LOCAL) {
 			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
-			if (name_loc->namelen != args->namelen)
+			if (name_loc->namelen != args->name.len)
 				continue;
-			if (memcmp(args->name, name_loc->nameval,
-							args->namelen) != 0)
+			if (memcmp(args->name.name, name_loc->nameval,
+							args->name.len) != 0)
 				continue;
-			if (!xfs_attr_namesp_match(args->flags, entry->flags))
+			if (!xfs_attr_namesp_match(args->name.type,
+						   entry->flags))
 				continue;
 			args->index = probe;
 			return -EEXIST;
 		} else {
 			name_rmt = xfs_attr3_leaf_name_remote(leaf, probe);
-			if (name_rmt->namelen != args->namelen)
+			if (name_rmt->namelen != args->name.len)
 				continue;
-			if (memcmp(args->name, name_rmt->name,
-							args->namelen) != 0)
+			if (memcmp(args->name.name, name_rmt->name,
+							args->name.len) != 0)
 				continue;
-			if (!xfs_attr_namesp_match(args->flags, entry->flags))
+			if (!xfs_attr_namesp_match(args->name.type,
+						   entry->flags))
 				continue;
 			args->index = probe;
 			args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
@@ -2367,10 +2370,11 @@ xfs_attr3_leaf_getvalue(
 	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
 	if (entry->flags & XFS_ATTR_LOCAL) {
 		name_loc = xfs_attr3_leaf_name_local(leaf, args->index);
-		ASSERT(name_loc->namelen == args->namelen);
-		ASSERT(memcmp(args->name, name_loc->nameval, args->namelen) == 0);
+		ASSERT(name_loc->namelen == args->name.len);
+		ASSERT(memcmp(args->name.name, name_loc->nameval,
+			      args->name.len) == 0);
 		valuelen = be16_to_cpu(name_loc->valuelen);
-		if (args->flags & ATTR_KERNOVAL) {
+		if (args->name.type & ATTR_KERNOVAL) {
 			args->valuelen = valuelen;
 			return 0;
 		}
@@ -2379,16 +2383,18 @@ xfs_attr3_leaf_getvalue(
 			return -ERANGE;
 		}
 		args->valuelen = valuelen;
-		memcpy(args->value, &name_loc->nameval[args->namelen], valuelen);
+		memcpy(args->value, &name_loc->nameval[args->name.len],
+		       valuelen);
 	} else {
 		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
-		ASSERT(name_rmt->namelen == args->namelen);
-		ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
+		ASSERT(name_rmt->namelen == args->name.len);
+		ASSERT(memcmp(args->name.name, name_rmt->name,
+			      args->name.len) == 0);
 		args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
 		args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
 		args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
 						       args->rmtvaluelen);
-		if (args->flags & ATTR_KERNOVAL) {
+		if (args->name.type & ATTR_KERNOVAL) {
 			args->valuelen = args->rmtvaluelen;
 			return 0;
 		}
@@ -2609,7 +2615,7 @@ xfs_attr_leaf_newentsize(
 {
 	int			size;
 
-	size = xfs_attr_leaf_entsize_local(args->namelen, args->valuelen);
+	size = xfs_attr_leaf_entsize_local(args->name.len, args->valuelen);
 	if (size < xfs_attr_leaf_entsize_local_max(args->geo->blksize)) {
 		if (local)
 			*local = 1;
@@ -2617,7 +2623,7 @@ xfs_attr_leaf_newentsize(
 	}
 	if (local)
 		*local = 0;
-	return xfs_attr_leaf_entsize_remote(args->namelen);
+	return xfs_attr_leaf_entsize_remote(args->name.len);
 }
 
 
@@ -2671,8 +2677,8 @@ xfs_attr3_leaf_clearflag(
 		name = (char *)name_rmt->name;
 	}
 	ASSERT(be32_to_cpu(entry->hashval) == args->hashval);
-	ASSERT(namelen == args->namelen);
-	ASSERT(memcmp(name, args->name, namelen) == 0);
+	ASSERT(namelen == args->name.len);
+	ASSERT(memcmp(name, args->name.name, namelen) == 0);
 #endif /* DEBUG */
 
 	entry->flags &= ~XFS_ATTR_INCOMPLETE;
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 9c58834..f67509b 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -375,7 +375,7 @@ xfs_attr_rmtval_get(
 
 	trace_xfs_attr_rmtval_get(args);
 
-	ASSERT(!(args->flags & ATTR_KERNOVAL));
+	ASSERT(!(args->name.type & ATTR_KERNOVAL));
 	ASSERT(args->rmtvaluelen == args->valuelen);
 
 	valuelen = args->rmtvaluelen;
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 34e4ed7..f8e0432 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2037,8 +2037,9 @@ xfs_da_compname(
 	const unsigned char *name,
 	int		len)
 {
-	return (args->namelen == len && memcmp(args->name, name, len) == 0) ?
-					XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
+	return (args->name.len == len &&
+		memcmp(args->name.name, name, len) == 0) ? XFS_CMP_EXACT :
+		XFS_CMP_DIFFERENT;
 }
 
 static xfs_dahash_t
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 84dd865..eb3eb95 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -47,12 +47,10 @@ enum xfs_dacmp {
  */
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
-	const uint8_t		*name;		/* string (maybe not NULL terminated) */
-	int		namelen;	/* length of string (maybe no NULL) */
+	struct xfs_name	name;		/* name, length and argument  flags*/
 	uint8_t		filetype;	/* filetype of inode for directories */
 	uint8_t		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
-	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
 	xfs_dahash_t	hashval;	/* hash value of name */
 	xfs_ino_t	inumber;	/* input/output inode number */
 	struct xfs_inode *dp;		/* directory inode to manipulate */
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 0df5dd2..fbfe72a 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -72,14 +72,14 @@ xfs_ascii_ci_compname(
 	enum xfs_dacmp	result;
 	int		i;
 
-	if (args->namelen != len)
+	if (args->name.len != len)
 		return XFS_CMP_DIFFERENT;
 
 	result = XFS_CMP_EXACT;
 	for (i = 0; i < len; i++) {
-		if (args->name[i] == name[i])
+		if (args->name.name[i] == name[i])
 			continue;
-		if (tolower(args->name[i]) != tolower(name[i]))
+		if (tolower(args->name.name[i]) != tolower(name[i]))
 			return XFS_CMP_DIFFERENT;
 		result = XFS_CMP_CASE;
 	}
@@ -257,8 +257,8 @@ xfs_dir_createname(
 		return -ENOMEM;
 
 	args->geo = dp->i_mount->m_dir_geo;
-	args->name = name->name;
-	args->namelen = name->len;
+	args->name.name = name->name;
+	args->name.len = name->len;
 	args->filetype = name->type;
 	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->inumber = inum;
@@ -353,8 +353,8 @@ xfs_dir_lookup(
 	 */
 	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
 	args->geo = dp->i_mount->m_dir_geo;
-	args->name = name->name;
-	args->namelen = name->len;
+	args->name.name = name->name;
+	args->name.len = name->len;
 	args->filetype = name->type;
 	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->dp = dp;
@@ -425,8 +425,8 @@ xfs_dir_removename(
 		return -ENOMEM;
 
 	args->geo = dp->i_mount->m_dir_geo;
-	args->name = name->name;
-	args->namelen = name->len;
+	args->name.name = name->name;
+	args->name.len = name->len;
 	args->filetype = name->type;
 	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->inumber = ino;
@@ -486,8 +486,8 @@ xfs_dir_replace(
 		return -ENOMEM;
 
 	args->geo = dp->i_mount->m_dir_geo;
-	args->name = name->name;
-	args->namelen = name->len;
+	args->name.name = name->name;
+	args->name.len = name->len;
 	args->filetype = name->type;
 	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->inumber = inum;
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 975dd68..048fce7 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -352,7 +352,7 @@ xfs_dir2_block_addname(
 	if (error)
 		return error;
 
-	len = dp->d_ops->data_entsize(args->namelen);
+	len = dp->d_ops->data_entsize(args->name.len);
 
 	/*
 	 * Set up pointers to parts of the block.
@@ -536,8 +536,8 @@ xfs_dir2_block_addname(
 	 * Create the new data entry.
 	 */
 	dep->inumber = cpu_to_be64(args->inumber);
-	dep->namelen = args->namelen;
-	memcpy(dep->name, args->name, args->namelen);
+	dep->namelen = args->name.len;
+	memcpy(dep->name, args->name.name, args->name.len);
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index ff4a04e..6bf063c 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -608,7 +608,7 @@ xfs_dir2_leaf_addname(
 	ents = dp->d_ops->leaf_ents_p(leaf);
 	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
-	length = dp->d_ops->data_entsize(args->namelen);
+	length = dp->d_ops->data_entsize(args->name.len);
 
 	/*
 	 * See if there are any entries with the same hash value
@@ -811,8 +811,8 @@ xfs_dir2_leaf_addname(
 	 */
 	dep = (xfs_dir2_data_entry_t *)dup;
 	dep->inumber = cpu_to_be64(args->inumber);
-	dep->namelen = args->namelen;
-	memcpy(dep->name, args->name, dep->namelen);
+	dep->namelen = args->name.len;
+	memcpy(dep->name, args->name.name, dep->namelen);
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 932155b..f644495 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -603,7 +603,7 @@ xfs_dir2_leafn_lookup_for_addname(
 		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
 		       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
 	}
-	length = dp->d_ops->data_entsize(args->namelen);
+	length = dp->d_ops->data_entsize(args->name.len);
 	/*
 	 * Loop over leaf entries with the right hash value.
 	 */
@@ -1714,7 +1714,7 @@ xfs_dir2_node_addname_int(
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
-	length = dp->d_ops->data_entsize(args->namelen);
+	length = dp->d_ops->data_entsize(args->name.len);
 	/*
 	 * If we came in with a freespace block that means that lookup
 	 * found an entry with our hash value.  This is the freespace
@@ -2016,8 +2016,8 @@ xfs_dir2_node_addname_int(
 	 */
 	dep = (xfs_dir2_data_entry_t *)dup;
 	dep->inumber = cpu_to_be64(args->inumber);
-	dep->namelen = args->namelen;
-	memcpy(dep->name, args->name, dep->namelen);
+	dep->namelen = args->name.len;
+	memcpy(dep->name, args->name.name, dep->namelen);
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 0360c96..9292c40 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -291,7 +291,7 @@ xfs_dir2_sf_addname(
 	/*
 	 * Compute entry (and change in) size.
 	 */
-	incr_isize = dp->d_ops->sf_entsize(sfp, args->namelen);
+	incr_isize = dp->d_ops->sf_entsize(sfp, args->name.len);
 	objchange = 0;
 
 	/*
@@ -375,7 +375,7 @@ xfs_dir2_sf_addname_easy(
 	/*
 	 * Grow the in-inode space.
 	 */
-	xfs_idata_realloc(dp, dp->d_ops->sf_entsize(sfp, args->namelen),
+	xfs_idata_realloc(dp, dp->d_ops->sf_entsize(sfp, args->name.len),
 			  XFS_DATA_FORK);
 	/*
 	 * Need to set up again due to realloc of the inode data.
@@ -385,9 +385,9 @@ xfs_dir2_sf_addname_easy(
 	/*
 	 * Fill in the new entry.
 	 */
-	sfep->namelen = args->namelen;
+	sfep->namelen = args->name.len;
 	xfs_dir2_sf_put_offset(sfep, offset);
-	memcpy(sfep->name, args->name, sfep->namelen);
+	memcpy(sfep->name, args->name.name, sfep->namelen);
 	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
 	dp->d_ops->sf_put_ftype(sfep, args->filetype);
 
@@ -446,7 +446,7 @@ xfs_dir2_sf_addname_hard(
 	 */
 	for (offset = dp->d_ops->data_first_offset,
 	      oldsfep = xfs_dir2_sf_firstentry(oldsfp),
-	      add_datasize = dp->d_ops->data_entsize(args->namelen),
+	      add_datasize = dp->d_ops->data_entsize(args->name.len),
 	      eof = (char *)oldsfep == &buf[old_isize];
 	     !eof;
 	     offset = new_offset + dp->d_ops->data_entsize(oldsfep->namelen),
@@ -476,9 +476,9 @@ xfs_dir2_sf_addname_hard(
 	/*
 	 * Fill in the new entry, and update the header counts.
 	 */
-	sfep->namelen = args->namelen;
+	sfep->namelen = args->name.len;
 	xfs_dir2_sf_put_offset(sfep, offset);
-	memcpy(sfep->name, args->name, sfep->namelen);
+	memcpy(sfep->name, args->name.name, sfep->namelen);
 	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
 	dp->d_ops->sf_put_ftype(sfep, args->filetype);
 	sfp->count++;
@@ -522,7 +522,7 @@ xfs_dir2_sf_addname_pick(
 	dp = args->dp;
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	size = dp->d_ops->data_entsize(args->namelen);
+	size = dp->d_ops->data_entsize(args->name.len);
 	offset = dp->d_ops->data_first_offset;
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	holefit = 0;
@@ -807,7 +807,7 @@ xfs_dir2_sf_lookup(
 	/*
 	 * Special case for .
 	 */
-	if (args->namelen == 1 && args->name[0] == '.') {
+	if (args->name.len == 1 && args->name.name[0] == '.') {
 		args->inumber = dp->i_ino;
 		args->cmpresult = XFS_CMP_EXACT;
 		args->filetype = XFS_DIR3_FT_DIR;
@@ -816,8 +816,8 @@ xfs_dir2_sf_lookup(
 	/*
 	 * Special case for ..
 	 */
-	if (args->namelen == 2 &&
-	    args->name[0] == '.' && args->name[1] == '.') {
+	if (args->name.len == 2 &&
+	    args->name.name[0] == '.' && args->name.name[1] == '.') {
 		args->inumber = dp->d_ops->sf_get_parent_ino(sfp);
 		args->cmpresult = XFS_CMP_EXACT;
 		args->filetype = XFS_DIR3_FT_DIR;
@@ -912,7 +912,7 @@ xfs_dir2_sf_removename(
 	 * Calculate sizes.
 	 */
 	byteoff = (int)((char *)sfep - (char *)sfp);
-	entsize = dp->d_ops->sf_entsize(sfp, args->namelen);
+	entsize = dp->d_ops->sf_entsize(sfp, args->name.len);
 	newsize = oldsize - entsize;
 	/*
 	 * Copy the part if any after the removed entry, sliding it down.
@@ -1002,12 +1002,12 @@ xfs_dir2_sf_replace(
 	} else
 		i8elevated = 0;
 
-	ASSERT(args->namelen != 1 || args->name[0] != '.');
+	ASSERT(args->name.len != 1 || args->name.name[0] != '.');
 	/*
 	 * Replace ..'s entry.
 	 */
-	if (args->namelen == 2 &&
-	    args->name[0] == '.' && args->name[1] == '.') {
+	if (args->name.len == 2 &&
+	    args->name.name[0] == '.' && args->name.name[1] == '.') {
 		ino = dp->d_ops->sf_get_parent_ino(sfp);
 		ASSERT(args->inumber != ino);
 		dp->d_ops->sf_put_parent_ino(sfp, args->inumber);
-- 
2.7.4

