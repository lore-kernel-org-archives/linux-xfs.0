Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E2EC433E9
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 14:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E35520665
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 14:30:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GpRLFOog"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgICOag (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 10:30:36 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60295 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729206AbgICO2t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 10:28:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599143328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZdKoRTu7Os5KfgANKus82TxEFDh6Hl0GZbrGay3IVMM=;
        b=GpRLFOogN/1hDlCFc8o6QKsiCJp67SvdW+tBbcPC3MMOhYw4jEgXDpEXSfr3ufHdYtvxz0
        qY6N6d9UFSu/P5pyvFz4s95Zrefd4AKi17KUuRb91FEl+N+pclfW6FvnV+agpJfzZ/vXta
        plsd4XcA3SqIRT3g2I1x8RwtEZOAgac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-vaNC36ZrMAWZgdZBekrgFw-1; Thu, 03 Sep 2020 10:28:46 -0400
X-MC-Unique: vaNC36ZrMAWZgdZBekrgFw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A83C2FD01
        for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2020 14:28:45 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.194.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1B2F10013D9
        for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2020 14:28:44 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: remove typedef xfs_attr_sf_entry_t
Date:   Thu,  3 Sep 2020 16:28:36 +0200
Message-Id: <20200903142839.72710-2-cmaiolino@redhat.com>
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
 fs/xfs/libxfs/xfs_attr_leaf.c |  4 ++--
 fs/xfs/libxfs/xfs_attr_sf.h   | 11 ++++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 305d4bc073370..76d3814f9dc79 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -736,7 +736,7 @@ xfs_attr_shortform_add(
 	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
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
index bb004fb7944a7..c4afb33079184 100644
--- a/fs/xfs/libxfs/xfs_attr_sf.h
+++ b/fs/xfs/libxfs/xfs_attr_sf.h
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
-- 
2.26.2

