Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DE4C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAAE020936
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:04:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KCFOGdaF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgHaNEp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:04:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39853 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726312AbgHaNEg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 09:04:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598879074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VekAInan0sdb8GXYjaGmX1anZt3jP+8mUaMoBjkB9fo=;
        b=KCFOGdaFTAZJMopmfpTgFf9KdaoP5x2tEdPy8Lz9/IbMv3cuad5ClPjflfef8ZQ2muJN3N
        lKRezGtSEVhOrkfML+eVKqSAFg24G2/il+9cmmL2Kwk8eKFR2NIWXY07vh6fSY9tpEqDf+
        xmEav9yjS3tEtiMuheWsSDhBmE2csNw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-kGWpqUBVMz-m3_BQ5x0QLg-1; Mon, 31 Aug 2020 09:04:32 -0400
X-MC-Unique: kGWpqUBVMz-m3_BQ5x0QLg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBFFA1007278
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 13:04:31 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 510CF5D9D5
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 13:04:31 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: remove typedef xfs_attr_sf_entry_t
Date:   Mon, 31 Aug 2020 15:04:22 +0200
Message-Id: <20200831130423.136509-4-cmaiolino@redhat.com>
In-Reply-To: <20200831130423.136509-1-cmaiolino@redhat.com>
References: <20200831130423.136509-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |  4 ++--
 fs/xfs/libxfs/xfs_attr_sf.h   | 14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index a8a4e21d19726..bcc76ff298646 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -736,7 +736,7 @@ xfs_attr_shortform_add(
 	size = xfs_attr_sf_entsize_byname(args->namelen, args->valuelen);
 	xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
-	sfe = (xfs_attr_sf_entry_t *)((char *)sf + offset);
+	sfe = (struct xfs_attr_sf_entry *)((char *)sf + offset);
 
 	sfe->namelen = args->namelen;
 	sfe->valuelen = args->valuelen;
@@ -838,7 +838,7 @@ int
 xfs_attr_shortform_lookup(xfs_da_args_t *args)
 {
 	xfs_attr_shortform_t *sf;
-	xfs_attr_sf_entry_t *sfe;
+	struct xfs_attr_sf_entry *sfe;
 	int i;
 	struct xfs_ifork *ifp;
 
diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
index 48906c5196505..6b09a010940ea 100644
--- a/fs/xfs/libxfs/xfs_attr_sf.h
+++ b/fs/xfs/libxfs/xfs_attr_sf.h
@@ -13,7 +13,6 @@
  * to fit into the literal area of the inode.
  */
 typedef struct xfs_attr_sf_hdr xfs_attr_sf_hdr_t;
-typedef struct xfs_attr_sf_entry xfs_attr_sf_entry_t;
 
 /*
  * We generate this then sort it, attr_list() must return things in hash-order.
@@ -31,17 +30,18 @@ typedef struct xfs_attr_sf_sort {
 	(1 << (NBBY*(int)sizeof(uint8_t)))
 
 static inline int xfs_attr_sf_entsize_byname(uint8_t nlen, uint8_t vlen) {
-	return sizeof(xfs_attr_sf_entry_t) + nlen + vlen;
+	return sizeof(struct xfs_attr_sf_entry) + nlen + vlen;
 }
 
 /* space an entry uses */
-static inline int xfs_attr_sf_entsize(xfs_attr_sf_entry_t *sfep) {
-	return sizeof(xfs_attr_sf_entry_t) + sfep->namelen + sfep->valuelen;
+static inline int xfs_attr_sf_entsize(struct xfs_attr_sf_entry *sfep) {
+	return sizeof(struct xfs_attr_sf_entry) +
+		sfep->namelen + sfep->valuelen;
 }
 
-static inline xfs_attr_sf_entry_t *
-xfs_attr_sf_nextentry(xfs_attr_sf_entry_t *sfep) {
-	return (xfs_attr_sf_entry_t *)((char *)(sfep) +
+static inline struct xfs_attr_sf_entry *
+xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep) {
+	return (struct xfs_attr_sf_entry *)((char *)(sfep) +
 				       xfs_attr_sf_entsize(sfep));
 }
 #endif	/* __XFS_ATTR_SF_H__ */
-- 
2.26.2

