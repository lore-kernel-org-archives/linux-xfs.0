Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BABFC433E7
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 14:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2200920767
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 14:43:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kj7J2SZD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgIBOmn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 10:42:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42415 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728039AbgIBOlb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 10:41:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599057682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1tzGIhCL0GiBf8ctBMYrXpURCjQ/pY9ip7QFIqW5DK8=;
        b=Kj7J2SZDvAXHpsAW/z8InJWR/K7LU/2+TViplfpOAtFK8irpwg5mIIzz2JDMrun9oYnKgi
        i/jBSsqIvmqTsD5gdIdl/Llud0Ue5rL6WG2RUkporZ2WW/Q0iErQYHanMKqvKhpiISpjDn
        8FsC9o74dbHCqJ0UWT8abr/zAneR+Uw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-qo1zamoBPTCJJr6qTDiAQA-1; Wed, 02 Sep 2020 10:41:19 -0400
X-MC-Unique: qo1zamoBPTCJJr6qTDiAQA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21BD618BFEC2
        for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2020 14:41:19 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.195.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B49E7EEAC
        for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2020 14:41:18 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V2 4/4] xfs: Convert xfs_attr_sf macros to inline functions
Date:   Wed,  2 Sep 2020 16:40:59 +0200
Message-Id: <20200902144059.284726-5-cmaiolino@redhat.com>
In-Reply-To: <20200902144059.284726-1-cmaiolino@redhat.com>
References: <20200902144059.284726-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_attr_sf_totsize() requires access to xfs_inode structure, so, once
xfs_attr_shortform_addname() is its only user, move it to xfs_attr.c
instead of playing with more #includes.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

	V2:
	 - keep macro comments above inline functions
	 - Use struct_size() on xfs_attr_sf_entsize()

 fs/xfs/libxfs/xfs_attr.c      | 13 ++++++++++---
 fs/xfs/libxfs/xfs_attr_leaf.c | 16 ++++++++--------
 fs/xfs/libxfs/xfs_attr_sf.h   | 28 +++++++++++++++++-----------
 fs/xfs/xfs_attr_list.c        |  4 ++--
 4 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 2e055c079f397..ff1fa2ed40ab9 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -428,7 +428,7 @@ xfs_attr_set(
 		 */
 		if (XFS_IFORK_Q(dp) == 0) {
 			int sf_size = sizeof(struct xfs_attr_sf_hdr) +
-				XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen,
+				xfs_attr_sf_entsize_byname(args->namelen,
 						args->valuelen);
 
 			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
@@ -523,6 +523,13 @@ xfs_attr_set(
  * External routines when attribute list is inside the inode
  *========================================================================*/
 
+/* total space in use */
+static inline int xfs_attr_sf_totsize(struct xfs_inode *dp) {
+	struct xfs_attr_shortform *sf =
+		(struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
+	return be16_to_cpu(sf->hdr.totsize);
+}
+
 /*
  * Add a name to the shortform attribute list structure
  * This is the external routine.
@@ -555,8 +562,8 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 	    args->valuelen >= XFS_ATTR_SF_ENTSIZE_MAX)
 		return -ENOSPC;
 
-	newsize = XFS_ATTR_SF_TOTSIZE(args->dp);
-	newsize += XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
+	newsize = xfs_attr_sf_totsize(args->dp);
+	newsize += xfs_attr_sf_entsize_byname(args->namelen, args->valuelen);
 
 	forkoff = xfs_attr_shortform_bytesfit(args->dp, newsize);
 	if (!forkoff)
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 89193871e6a7f..f64ab351b760c 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -684,9 +684,9 @@ xfs_attr_sf_findname(
 	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
 	sfe = &sf->list[0];
 	end = sf->hdr.count;
-	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
+	for (i = 0; i < end; sfe = xfs_attr_sf_nextentry(sfe),
 			     base += size, i++) {
-		size = XFS_ATTR_SF_ENTSIZE(sfe);
+		size = xfs_attr_sf_entsize(sfe);
 		if (!xfs_attr_match(args, sfe->namelen, sfe->nameval,
 				    sfe->flags))
 			continue;
@@ -733,7 +733,7 @@ xfs_attr_shortform_add(
 		ASSERT(0);
 
 	offset = (char *)sfe - (char *)sf;
-	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
+	size = xfs_attr_sf_entsize_byname(args->namelen, args->valuelen);
 	xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
 	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	sfe = (struct xfs_attr_sf_entry *)((char *)sf + offset);
@@ -792,7 +792,7 @@ xfs_attr_shortform_remove(
 	error = xfs_attr_sf_findname(args, &sfe, &base);
 	if (error != -EEXIST)
 		return error;
-	size = XFS_ATTR_SF_ENTSIZE(sfe);
+	size = xfs_attr_sf_entsize(sfe);
 
 	/*
 	 * Fix up the attribute fork data, covering the hole
@@ -849,7 +849,7 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
-				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
+				sfe = xfs_attr_sf_nextentry(sfe), i++) {
 		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
 				sfe->flags))
 			return -EEXIST;
@@ -876,7 +876,7 @@ xfs_attr_shortform_getvalue(
 	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
-				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
+				sfe = xfs_attr_sf_nextentry(sfe), i++) {
 		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
 				sfe->flags))
 			return xfs_attr_copy_value(args,
@@ -951,7 +951,7 @@ xfs_attr_shortform_to_leaf(
 		ASSERT(error != -ENOSPC);
 		if (error)
 			goto out;
-		sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
+		sfe = xfs_attr_sf_nextentry(sfe);
 	}
 	error = 0;
 	*leaf_bp = bp;
@@ -1049,7 +1049,7 @@ xfs_attr_shortform_verify(
 		 * within the data buffer.  The next entry starts after the
 		 * name component, so nextentry is an acceptable test.
 		 */
-		next_sfep = XFS_ATTR_SF_NEXTENTRY(sfep);
+		next_sfep = xfs_attr_sf_nextentry(sfep);
 		if ((char *)next_sfep > endp)
 			return __this_address;
 
diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
index f608a2966d7f8..0d761306da965 100644
--- a/fs/xfs/libxfs/xfs_attr_sf.h
+++ b/fs/xfs/libxfs/xfs_attr_sf.h
@@ -26,18 +26,24 @@ typedef struct xfs_attr_sf_sort {
 	unsigned char	*name;		/* name value, pointer into buffer */
 } xfs_attr_sf_sort_t;
 
-#define XFS_ATTR_SF_ENTSIZE_BYNAME(nlen,vlen)	/* space name/value uses */ \
-	(((int)sizeof(struct xfs_attr_sf_entry) + (nlen)+(vlen)))
 #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
 	((1 << (NBBY*(int)sizeof(uint8_t))) - 1)
-#define XFS_ATTR_SF_ENTSIZE(sfep)		/* space an entry uses */ \
-	((int)sizeof(struct xfs_attr_sf_entry) + \
-		(sfep)->namelen+(sfep)->valuelen)
-#define XFS_ATTR_SF_NEXTENTRY(sfep)		/* next entry in struct */ \
-	((struct xfs_attr_sf_entry *)((char *)(sfep) + \
-		XFS_ATTR_SF_ENTSIZE(sfep)))
-#define XFS_ATTR_SF_TOTSIZE(dp)			/* total space in use */ \
-	(be16_to_cpu(((struct xfs_attr_shortform *)	\
-		((dp)->i_afp->if_u1.if_data))->hdr.totsize))
+
+/* space name/value uses */
+static inline int xfs_attr_sf_entsize_byname(uint8_t nlen, uint8_t vlen) {
+	return sizeof(struct xfs_attr_sf_entry) + nlen + vlen;
+}
+
+/* space an entry uses */
+static inline int xfs_attr_sf_entsize(struct xfs_attr_sf_entry *sfep) {
+	return struct_size(sfep, nameval, sfep->namelen + sfep->valuelen);
+}
+
+/* next entry in struct */
+static inline struct xfs_attr_sf_entry *
+xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep) {
+	return (struct xfs_attr_sf_entry *)((char *)(sfep) +
+					    xfs_attr_sf_entsize(sfep));
+}
 
 #endif	/* __XFS_ATTR_SF_H__ */
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 4eb1d6faecfb2..8f8837fe21cf0 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -96,7 +96,7 @@ xfs_attr_shortform_list(
 			 */
 			if (context->seen_enough)
 				break;
-			sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
+			sfe = xfs_attr_sf_nextentry(sfe);
 		}
 		trace_xfs_attr_list_sf_all(context);
 		return 0;
@@ -136,7 +136,7 @@ xfs_attr_shortform_list(
 		/* These are bytes, and both on-disk, don't endian-flip */
 		sbp->valuelen = sfe->valuelen;
 		sbp->flags = sfe->flags;
-		sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
+		sfe = xfs_attr_sf_nextentry(sfe);
 		sbp++;
 		nsbuf++;
 	}
-- 
2.26.2

