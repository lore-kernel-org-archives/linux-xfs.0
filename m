Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B6C8C0030B
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63D852070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Elkvujjd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391175AbfIEWTR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33168 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391128AbfIEWTM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ7IW078075
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=ycLl3izdtCd4X0fHghmcgUt3Dsp9wf30600I9+PkUTU=;
 b=Elkvujjd0i6DiAmrlQ/0xvUo083fIZli27o84vcU3GBa8ocKlXH4J/0SZovxHmtNo/hh
 XCmEX4/1IeB4QwS8dg5KB12NkqZZabZ6+NSAFR5PwkeG2vNjOV6YZjRUivmYIkU4cgUL
 EpMU97+20xV49SUUihpW+O4ODv86AYco7cmK1SIN3omX3vWY+U4EOoJKzjqlDIiUjTa/
 OWBNww7UIrpBTpNw0g6765BIEW5+m/IonBi8J4hY6ahXN0xPPYr3Q75fk/AB/4Xo/iuf
 3hm9WhUG+6i87sxnrNm1f6irx5cJVvEh5/SoSl6ZriQuCaBJseTjYQmSocURDydFscjp zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uuaqj02kw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MIe7X123340
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:18:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uthq27uvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:18:45 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85MIi1r008667
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:18:44 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:18:44 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 02/19] xfs: Embed struct xfs_name in xfs_da_args
Date:   Thu,  5 Sep 2019 15:18:20 -0700
Message-Id: <20190905221837.17388-3-allison.henderson@oracle.com>
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

This patch embeds an xfs_name in xfs_da_args, replacing the name,
namelen, and flags members.  This helps to clean up the xfs_da_args
structure and make it more uniform with the new xfs_name parameter
being passed around.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        |  34 ++++++-------
 fs/xfs/libxfs/xfs_attr_leaf.c   | 106 +++++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_attr_remote.c |   2 +-
 fs/xfs/libxfs/xfs_da_btree.c    |   5 +-
 fs/xfs/libxfs/xfs_da_btree.h    |   4 +-
 fs/xfs/libxfs/xfs_dir2.c        |  22 ++++-----
 fs/xfs/libxfs/xfs_dir2_block.c  |   6 +--
 fs/xfs/libxfs/xfs_dir2_leaf.c   |   6 +--
 fs/xfs/libxfs/xfs_dir2_node.c   |   8 +--
 fs/xfs/libxfs/xfs_dir2_sf.c     |  30 ++++++------
 fs/xfs/scrub/attr.c             |  12 ++---
 fs/xfs/xfs_trace.h              |  20 ++++----
 12 files changed, 130 insertions(+), 125 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d0308d6..50e099f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -71,13 +71,13 @@ xfs_attr_args_init(
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
 
@@ -234,7 +234,7 @@ xfs_attr_try_sf_addname(
 	 * Commit the shortform mods, and we're done.
 	 * NOTE: this is also the error path (EEXIST, etc).
 	 */
-	if (!error && (args->flags & ATTR_KERNOTIME) == 0)
+	if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
 		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
@@ -369,7 +369,7 @@ xfs_attr_set(
 	 */
 	if (XFS_IFORK_Q(dp) == 0) {
 		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
-			XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen, valuelen);
+			XFS_ATTR_SF_ENTSIZE_BYNAME(args.name.len, valuelen);
 
 		error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
 		if (error)
@@ -528,10 +528,10 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
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
@@ -541,15 +541,15 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
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
@@ -594,11 +594,11 @@ xfs_attr_leaf_addname(
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
@@ -868,10 +868,10 @@ xfs_attr_node_addname(
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
@@ -1003,7 +1003,7 @@ xfs_attr_node_addname(
 		 * The INCOMPLETE flag means that we will find the "old"
 		 * attr, not the "new" one.
 		 */
-		args->flags |= XFS_ATTR_INCOMPLETE;
+		args->name.type |= XFS_ATTR_INCOMPLETE;
 		state = xfs_da_state_alloc();
 		state->args = args;
 		state->mp = mp;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b9f0196..07ce320 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -402,7 +402,7 @@ xfs_attr_copy_value(
 	/*
 	 * No copy if all we have to do is get the length
 	 */
-	if (args->flags & ATTR_KERNOVAL) {
+	if (args->name.type & ATTR_KERNOVAL) {
 		args->valuelen = valuelen;
 		return 0;
 	}
@@ -615,27 +615,27 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
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
@@ -685,11 +685,11 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
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
@@ -752,11 +752,11 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
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
@@ -783,13 +783,13 @@ xfs_attr_shortform_getvalue(
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
-		return xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
+		return xfs_attr_copy_value(args, &sfe->nameval[args->name.len],
 						sfe->valuelen);
 	}
 	return -ENOATTR;
@@ -863,13 +863,13 @@ xfs_attr_shortform_to_leaf(
 
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
@@ -1070,12 +1070,12 @@ xfs_attr3_leaf_to_shortform(
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
@@ -1403,7 +1403,7 @@ xfs_attr3_leaf_add_work(
 				     ichdr->freemap[mapindex].size);
 	entry->hashval = cpu_to_be32(args->hashval);
 	entry->flags = tmp ? XFS_ATTR_LOCAL : 0;
-	entry->flags |= XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags);
+	entry->flags |= XFS_ATTR_NSP_ARGS_TO_ONDISK(args->name.type);
 	if (args->op_flags & XFS_DA_OP_RENAME) {
 		entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
@@ -1427,15 +1427,16 @@ xfs_attr3_leaf_add_work(
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
@@ -2348,29 +2349,31 @@ xfs_attr3_leaf_lookup_int(
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
@@ -2412,16 +2415,17 @@ xfs_attr3_leaf_getvalue(
 	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
 	if (entry->flags & XFS_ATTR_LOCAL) {
 		name_loc = xfs_attr3_leaf_name_local(leaf, args->index);
-		ASSERT(name_loc->namelen == args->namelen);
-		ASSERT(memcmp(args->name, name_loc->nameval, args->namelen) == 0);
+		ASSERT(name_loc->namelen == args->name.len);
+		ASSERT(memcmp(args->name.name, name_loc->nameval,
+			      args->name.len) == 0);
 		return xfs_attr_copy_value(args,
-					&name_loc->nameval[args->namelen],
+					&name_loc->nameval[args->name.len],
 					be16_to_cpu(name_loc->valuelen));
 	}
 
 	name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
-	ASSERT(name_rmt->namelen == args->namelen);
-	ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
+	ASSERT(name_rmt->namelen == args->name.len);
+	ASSERT(memcmp(args->name.name, name_rmt->name, args->name.len) == 0);
 	args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
 	args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
 	args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
@@ -2637,7 +2641,7 @@ xfs_attr_leaf_newentsize(
 {
 	int			size;
 
-	size = xfs_attr_leaf_entsize_local(args->namelen, args->valuelen);
+	size = xfs_attr_leaf_entsize_local(args->name.len, args->valuelen);
 	if (size < xfs_attr_leaf_entsize_local_max(args->geo->blksize)) {
 		if (local)
 			*local = 1;
@@ -2645,7 +2649,7 @@ xfs_attr_leaf_newentsize(
 	}
 	if (local)
 		*local = 0;
-	return xfs_attr_leaf_entsize_remote(args->namelen);
+	return xfs_attr_leaf_entsize_remote(args->name.len);
 }
 
 
@@ -2699,8 +2703,8 @@ xfs_attr3_leaf_clearflag(
 		name = (char *)name_rmt->name;
 	}
 	ASSERT(be32_to_cpu(entry->hashval) == args->hashval);
-	ASSERT(namelen == args->namelen);
-	ASSERT(memcmp(name, args->name, namelen) == 0);
+	ASSERT(namelen == args->name.len);
+	ASSERT(memcmp(name, args->name.name, namelen) == 0);
 #endif /* DEBUG */
 
 	entry->flags &= ~XFS_ATTR_INCOMPLETE;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 3e39b7d..db9247a 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -379,7 +379,7 @@ xfs_attr_rmtval_get(
 
 	trace_xfs_attr_rmtval_get(args);
 
-	ASSERT(!(args->flags & ATTR_KERNOVAL));
+	ASSERT(!(args->name.type & ATTR_KERNOVAL));
 	ASSERT(args->rmtvaluelen == args->valuelen);
 
 	valuelen = args->rmtvaluelen;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 4fd1223..129ec09 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2040,8 +2040,9 @@ xfs_da_compname(
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
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ae0bbd2..bed4f40 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
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
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 867c5de..e8d6721 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -74,14 +74,14 @@ xfs_ascii_ci_compname(
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
@@ -259,8 +259,8 @@ xfs_dir_createname(
 		return -ENOMEM;
 
 	args->geo = dp->i_mount->m_dir_geo;
-	args->name = name->name;
-	args->namelen = name->len;
+	args->name.name = name->name;
+	args->name.len = name->len;
 	args->filetype = name->type;
 	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->inumber = inum;
@@ -355,8 +355,8 @@ xfs_dir_lookup(
 	 */
 	args = kmem_zalloc(sizeof(*args), KM_NOFS);
 	args->geo = dp->i_mount->m_dir_geo;
-	args->name = name->name;
-	args->namelen = name->len;
+	args->name.name = name->name;
+	args->name.len = name->len;
 	args->filetype = name->type;
 	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->dp = dp;
@@ -427,8 +427,8 @@ xfs_dir_removename(
 		return -ENOMEM;
 
 	args->geo = dp->i_mount->m_dir_geo;
-	args->name = name->name;
-	args->namelen = name->len;
+	args->name.name = name->name;
+	args->name.len = name->len;
 	args->filetype = name->type;
 	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->inumber = ino;
@@ -488,8 +488,8 @@ xfs_dir_replace(
 		return -ENOMEM;
 
 	args->geo = dp->i_mount->m_dir_geo;
-	args->name = name->name;
-	args->namelen = name->len;
+	args->name.name = name->name;
+	args->name.len = name->len;
 	args->filetype = name->type;
 	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->inumber = inum;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 9595ced..94269b9 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -355,7 +355,7 @@ xfs_dir2_block_addname(
 	if (error)
 		return error;
 
-	len = dp->d_ops->data_entsize(args->namelen);
+	len = dp->d_ops->data_entsize(args->name.len);
 
 	/*
 	 * Set up pointers to parts of the block.
@@ -539,8 +539,8 @@ xfs_dir2_block_addname(
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
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index a53e458..b7046e2 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -610,7 +610,7 @@ xfs_dir2_leaf_addname(
 	ents = dp->d_ops->leaf_ents_p(leaf);
 	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
-	length = dp->d_ops->data_entsize(args->namelen);
+	length = dp->d_ops->data_entsize(args->name.len);
 
 	/*
 	 * See if there are any entries with the same hash value
@@ -813,8 +813,8 @@ xfs_dir2_leaf_addname(
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
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 705c4f5..8bbd742 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -604,7 +604,7 @@ xfs_dir2_leafn_lookup_for_addname(
 		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
 		       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
 	}
-	length = dp->d_ops->data_entsize(args->namelen);
+	length = dp->d_ops->data_entsize(args->name.len);
 	/*
 	 * Loop over leaf entries with the right hash value.
 	 */
@@ -1869,7 +1869,7 @@ xfs_dir2_node_addname_int(
 	__be16			*tagp;		/* data entry tag pointer */
 	__be16			*bests;
 
-	length = dp->d_ops->data_entsize(args->namelen);
+	length = dp->d_ops->data_entsize(args->name.len);
 	error = xfs_dir2_node_find_freeblk(args, fblk, &dbno, &fbp, &findex,
 					   length);
 	if (error)
@@ -1924,8 +1924,8 @@ xfs_dir2_node_addname_int(
 	/* Fill in the new entry and log it. */
 	dep = (xfs_dir2_data_entry_t *)dup;
 	dep->inumber = cpu_to_be64(args->inumber);
-	dep->namelen = args->namelen;
-	memcpy(dep->name, args->name, dep->namelen);
+	dep->namelen = args->name.len;
+	memcpy(dep->name, args->name.name, dep->namelen);
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 85f14fc..fdc1431 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
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
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 0edc7f8..42f7c07 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -147,17 +147,17 @@ xchk_xattr_listent(
 		return;
 	}
 
-	args.flags = ATTR_KERNOTIME;
+	args.name.type = ATTR_KERNOTIME;
 	if (flags & XFS_ATTR_ROOT)
-		args.flags |= ATTR_ROOT;
+		args.name.type |= ATTR_ROOT;
 	else if (flags & XFS_ATTR_SECURE)
-		args.flags |= ATTR_SECURE;
+		args.name.type |= ATTR_SECURE;
 	args.geo = context->dp->i_mount->m_attr_geo;
 	args.whichfork = XFS_ATTR_FORK;
 	args.dp = context->dp;
-	args.name = name;
-	args.namelen = namelen;
-	args.hashval = xfs_da_hashname(args.name, args.namelen);
+	args.name.name = name;
+	args.name.len = namelen;
+	args.hashval = xfs_da_hashname(args.name.name, args.name.len);
 	args.trans = context->tp;
 	args.value = xchk_xattr_valuebuf(sx->sc);
 	args.valuelen = valuelen;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index eaae275..e0f524d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1669,7 +1669,7 @@ DECLARE_EVENT_CLASS(xfs_da_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
-		__dynamic_array(char, name, args->namelen)
+		__dynamic_array(char, name, args->name.len)
 		__field(int, namelen)
 		__field(xfs_dahash_t, hashval)
 		__field(xfs_ino_t, inumber)
@@ -1678,9 +1678,10 @@ DECLARE_EVENT_CLASS(xfs_da_class,
 	TP_fast_assign(
 		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
 		__entry->ino = args->dp->i_ino;
-		if (args->namelen)
-			memcpy(__get_str(name), args->name, args->namelen);
-		__entry->namelen = args->namelen;
+		if (args->name.len)
+			memcpy(__get_str(name), args->name.name,
+			       args->name.len);
+		__entry->namelen = args->name.len;
 		__entry->hashval = args->hashval;
 		__entry->inumber = args->inumber;
 		__entry->op_flags = args->op_flags;
@@ -1733,7 +1734,7 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
-		__dynamic_array(char, name, args->namelen)
+		__dynamic_array(char, name, args->name.len)
 		__field(int, namelen)
 		__field(int, valuelen)
 		__field(xfs_dahash_t, hashval)
@@ -1743,12 +1744,13 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 	TP_fast_assign(
 		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
 		__entry->ino = args->dp->i_ino;
-		if (args->namelen)
-			memcpy(__get_str(name), args->name, args->namelen);
-		__entry->namelen = args->namelen;
+		if (args->name.len)
+			memcpy(__get_str(name), args->name.name,
+			       args->name.len);
+		__entry->namelen = args->name.len;
 		__entry->valuelen = args->valuelen;
 		__entry->hashval = args->hashval;
-		__entry->flags = args->flags;
+		__entry->flags = args->name.type;
 		__entry->op_flags = args->op_flags;
 	),
 	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d valuelen %d "
-- 
2.7.4

