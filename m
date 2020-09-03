Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00820C433E2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 14:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACE43208B3
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 14:30:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fUNGPyXI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgICOaL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 10:30:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729255AbgICO2v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 10:28:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599143329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6aC+It/BZ1YXysfciRX0pP1wU+nD1lMp89LAkLBCrUQ=;
        b=fUNGPyXIprQ9TvFSkEESamMFKbDGJMETqLACz0nV9Gt4iOhWQMvX36nCEfsObQyveTvcZk
        gkCP11w0oa7V5jJgoAMF8VK2FkXLa9a6qossfGfwhUdHPkYK0xvg+M6lVJy/iEyukDaFVe
        iqyvZMNFxs4hOc9olO81x/cxMCj1OCE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-Q4og_KeNPjmGOrkUhMWHqA-1; Thu, 03 Sep 2020 10:28:47 -0400
X-MC-Unique: Q4og_KeNPjmGOrkUhMWHqA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E389781F00B
        for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2020 14:28:46 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.194.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E5C11002D40
        for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2020 14:28:46 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: Remove typedef xfs_attr_shortform_t
Date:   Thu,  3 Sep 2020 16:28:37 +0200
Message-Id: <20200903142839.72710-3-cmaiolino@redhat.com>
In-Reply-To: <20200903142839.72710-1-cmaiolino@redhat.com>
References: <20200903142839.72710-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 16 ++++++++--------
 fs/xfs/libxfs/xfs_da_format.h |  4 ++--
 fs/xfs/xfs_attr_list.c        |  2 +-
 fs/xfs/xfs_ondisk.h           | 12 ++++++------
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 76d3814f9dc79..d920183b08a99 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -728,14 +728,14 @@ xfs_attr_shortform_add(
 
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
@@ -787,7 +787,7 @@ xfs_attr_shortform_remove(
 
 	dp = args->dp;
 	mp = dp->i_mount;
-	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
+	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
 
 	error = xfs_attr_sf_findname(args, &sfe, &base);
 	if (error != -EEXIST)
@@ -837,7 +837,7 @@ xfs_attr_shortform_remove(
 int
 xfs_attr_shortform_lookup(xfs_da_args_t *args)
 {
-	xfs_attr_shortform_t *sf;
+	struct xfs_attr_shortform *sf;
 	struct xfs_attr_sf_entry *sfe;
 	int i;
 	struct xfs_ifork *ifp;
@@ -846,7 +846,7 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 
 	ifp = args->dp->i_afp;
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
-	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
+	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
@@ -873,7 +873,7 @@ xfs_attr_shortform_getvalue(
 	int			i;
 
 	ASSERT(args->dp->i_afp->if_flags == XFS_IFINLINE);
-	sf = (xfs_attr_shortform_t *)args->dp->i_afp->if_u1.if_data;
+	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
@@ -908,12 +908,12 @@ xfs_attr_shortform_to_leaf(
 
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
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 059ac108b1b39..e708b714bf99d 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
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
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 50f922cad91a4..4eb1d6faecfb2 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -61,7 +61,7 @@ xfs_attr_shortform_list(
 	int				error = 0;
 
 	ASSERT(dp->i_afp != NULL);
-	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
+	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
 	ASSERT(sf != NULL);
 	if (!sf->hdr.count)
 		return 0;
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 5f04d8a5ab2a9..ad51c8eb447b1 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -84,12 +84,12 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, namelen,	8);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, name,	9);
 	XFS_CHECK_STRUCT_SIZE(xfs_attr_leafblock_t,		40);
-	XFS_CHECK_OFFSET(xfs_attr_shortform_t, hdr.totsize,	0);
-	XFS_CHECK_OFFSET(xfs_attr_shortform_t, hdr.count,	2);
-	XFS_CHECK_OFFSET(xfs_attr_shortform_t, list[0].namelen,	4);
-	XFS_CHECK_OFFSET(xfs_attr_shortform_t, list[0].valuelen, 5);
-	XFS_CHECK_OFFSET(xfs_attr_shortform_t, list[0].flags,	6);
-	XFS_CHECK_OFFSET(xfs_attr_shortform_t, list[0].nameval,	7);
+	XFS_CHECK_OFFSET(struct xfs_attr_shortform, hdr.totsize, 0);
+	XFS_CHECK_OFFSET(struct xfs_attr_shortform, hdr.count,	 2);
+	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].namelen,	4);
+	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].valuelen,	5);
+	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].flags,	6);
+	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].nameval,	7);
 	XFS_CHECK_STRUCT_SIZE(xfs_da_blkinfo_t,			12);
 	XFS_CHECK_STRUCT_SIZE(xfs_da_intnode_t,			16);
 	XFS_CHECK_STRUCT_SIZE(xfs_da_node_entry_t,		8);
-- 
2.26.2

