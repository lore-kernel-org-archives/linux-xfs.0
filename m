Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C74C433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCED5206A5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:59:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HIsgH5cu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgIAJ71 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 05:59:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbgIAJ71 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 05:59:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598954365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8JPTEWbSRYysyTCBKXdxRckEy3Bm2vSPej7nEiqzAY8=;
        b=HIsgH5cuGJDec4SDHEARQm9rK+7zNsyH2myVFkJ4lphQ8JTeAPOn6zdtb2mQY8ZDX6tMMo
        4FYyUaWqXn2lFXIQj6Hl0WItNId2b7lo55FrPjEtVdBAiatNxDVjmfe70PK74LRtzoqOME
        9YsoNpcJS2CXbCI/1qVBoz7Kb5RKTPA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-ywLld_jQMpaNp7Q6KsLfuA-1; Tue, 01 Sep 2020 05:59:23 -0400
X-MC-Unique: ywLld_jQMpaNp7Q6KsLfuA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 979B18014D8
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 09:59:22 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.194.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11FB460C04
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 09:59:21 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH] xfs: add inline helper to convert from data fork to xfs_attr_shortform
Date:   Tue,  1 Sep 2020 11:59:19 +0200
Message-Id: <20200901095919.238598-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks, while working on the attr structs cleanup, I've noticed there
are so many places where we do:

(struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;

So, I thought it would be worth to add another inline function to do
this conversion and remove all these casts.

To achieve this, it will be required to include xfs_inode.h header on
xfs_attr_sf.h, so it can access the xfs_inode definition. Also, if this
patch is an acceptable idea, it will make sense then to keep the
xfs_attr_sf_totsize() function also inside xfs_attr_sf.h (which has been
moved on my series to avoid the additional #include), so, I thought on
sending this RFC patch to get comments if it's a good idea or not, and,
if it is, I'll add this patch to my series before sending it over.

I didn't focus on check if this patch is totally correct (only build
test), since my idea is to gather you guys opinions about having this
new inline function, so don't bother on reviewing the patch itself by
now, only the function name if you guys prefer some other name.

Also, this patch is build on top of my clean up series (V2), not yet
sent to the list, so it won't apply anyway.

Cheers.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c      |  4 ++--
 fs/xfs/libxfs/xfs_attr_leaf.c | 16 ++++++++--------
 fs/xfs/libxfs/xfs_attr_sf.h   |  6 ++++++
 fs/xfs/xfs_attr_list.c        |  2 +-
 4 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ff1fa2ed40ab9..1dccc8b9f31f6 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -525,8 +525,8 @@ xfs_attr_set(
 
 /* total space in use */
 static inline int xfs_attr_sf_totsize(struct xfs_inode *dp) {
-	struct xfs_attr_shortform *sf =
-		(struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
+	struct xfs_attr_shortform *sf = xfs_attr_ifork_to_sf(dp);
+
 	return be16_to_cpu(sf->hdr.totsize);
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index f64ab351b760c..ac92eba8745d6 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -681,7 +681,7 @@ xfs_attr_sf_findname(
 	int			end;
 	int			i;
 
-	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
+	sf = xfs_attr_ifork_to_sf(args->dp);
 	sfe = &sf->list[0];
 	end = sf->hdr.count;
 	for (i = 0; i < end; sfe = xfs_attr_sf_nextentry(sfe),
@@ -728,14 +728,14 @@ xfs_attr_shortform_add(
 
 	ifp = dp->i_afp;
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
-	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
+	sf = xfs_attr_ifork_to_sf(dp);
 	if (xfs_attr_sf_findname(args, &sfe, NULL) == -EEXIST)
 		ASSERT(0);
 
 	offset = (char *)sfe - (char *)sf;
 	size = xfs_attr_sf_entsize_byname(args->namelen, args->valuelen);
 	xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
-	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
+	sf = xfs_attr_ifork_to_sf(dp);
 	sfe = (struct xfs_attr_sf_entry *)((char *)sf + offset);
 
 	sfe->namelen = args->namelen;
@@ -787,7 +787,7 @@ xfs_attr_shortform_remove(
 
 	dp = args->dp;
 	mp = dp->i_mount;
-	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
+	sf = xfs_attr_ifork_to_sf(dp);
 
 	error = xfs_attr_sf_findname(args, &sfe, &base);
 	if (error != -EEXIST)
@@ -846,7 +846,7 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 
 	ifp = args->dp->i_afp;
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
-	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
+	sf = xfs_attr_ifork_to_sf(args->dp);
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = xfs_attr_sf_nextentry(sfe), i++) {
@@ -873,7 +873,7 @@ xfs_attr_shortform_getvalue(
 	int			i;
 
 	ASSERT(args->dp->i_afp->if_flags == XFS_IFINLINE);
-	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
+	sf = xfs_attr_ifork_to_sf(args->dp);
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = xfs_attr_sf_nextentry(sfe), i++) {
@@ -908,7 +908,7 @@ xfs_attr_shortform_to_leaf(
 
 	dp = args->dp;
 	ifp = dp->i_afp;
-	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
+	sf = xfs_attr_ifork_to_sf(dp);
 	size = be16_to_cpu(sf->hdr.totsize);
 	tmpbuffer = kmem_alloc(size, 0);
 	ASSERT(tmpbuffer != NULL);
@@ -1018,7 +1018,7 @@ xfs_attr_shortform_verify(
 
 	ASSERT(ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL);
 	ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
-	sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
+	sfp = xfs_attr_ifork_to_sf(ip);
 	size = ifp->if_bytes;
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
index 540ad3332a9c8..a51aed1dab6c1 100644
--- a/fs/xfs/libxfs/xfs_attr_sf.h
+++ b/fs/xfs/libxfs/xfs_attr_sf.h
@@ -3,6 +3,8 @@
  * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
+
+#include "xfs_inode.h"
 #ifndef __XFS_ATTR_SF_H__
 #define	__XFS_ATTR_SF_H__
 
@@ -47,4 +49,8 @@ xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep) {
 					    xfs_attr_sf_entsize(sfep));
 }
 
+static inline struct xfs_attr_shortform *
+xfs_attr_ifork_to_sf(struct xfs_inode *ino) {
+	return (struct xfs_attr_shortform *)ino->i_afp->if_u1.if_data;
+}
 #endif	/* __XFS_ATTR_SF_H__ */
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 8f8837fe21cf0..7c0ebdeb43567 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -61,7 +61,7 @@ xfs_attr_shortform_list(
 	int				error = 0;
 
 	ASSERT(dp->i_afp != NULL);
-	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
+	sf = xfs_attr_ifork_to_sf(dp);
 	ASSERT(sf != NULL);
 	if (!sf->hdr.count)
 		return 0;
-- 
2.26.2

