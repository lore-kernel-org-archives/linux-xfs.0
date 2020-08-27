Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8B2C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 09:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9588422B40
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 09:24:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hBuQoGgT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgH0JY2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 05:24:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728432AbgH0JY1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 05:24:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598520265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CDmYAhtLMVc6wY1qlK3MdpQAd09vbCWOICTrfrMkP4A=;
        b=hBuQoGgTJkW7b29i3/8o03gEGy/m/kUHJECMUe9XdjyY5oQ/yaTNzwhdCLFcYt5ZBYu0se
        IQLj6jYLuJttUQgeAuBcVnwRJsqmNmR2z/oLhdpTgC0SKhEaOPbuZpcTKvuPri0Z48UQ4j
        xYNg4Rxq48W3pM3JfW03ZDHEkRVSxSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-UtK4mrznMB6ROHmvUSI4wQ-1; Thu, 27 Aug 2020 05:24:23 -0400
X-MC-Unique: UtK4mrznMB6ROHmvUSI4wQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A67D1DE04
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 09:24:22 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.195.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4AA1757DC
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 09:24:21 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V3] xfs: Remove kmem_zalloc_large()
Date:   Thu, 27 Aug 2020 11:24:17 +0200
Message-Id: <20200827092417.7973-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch aims to replace kmem_zalloc_large() with global kernel memory
API. So, all its callers are now using kvzalloc() directly, so kmalloc()
fallsback to vmalloc() automatically.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---

Changelog:

	V2:
		Remove __GFP_RETRY_MAYFAIL from the kvzalloc() calls
	V3:
		Remove extra newline

 fs/xfs/kmem.h          | 6 ------
 fs/xfs/scrub/symlink.c | 2 +-
 fs/xfs/xfs_acl.c       | 2 +-
 fs/xfs/xfs_ioctl.c     | 4 ++--
 fs/xfs/xfs_rtalloc.c   | 2 +-
 5 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index fb1d066770723..38007117697ef 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -71,12 +71,6 @@ kmem_zalloc(size_t size, xfs_km_flags_t flags)
 	return kmem_alloc(size, flags | KM_ZERO);
 }
 
-static inline void *
-kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
-{
-	return kmem_alloc_large(size, flags | KM_ZERO);
-}
-
 /*
  * Zone interfaces
  */
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 5641ae512c9ef..c08be5ede0661 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -22,7 +22,7 @@ xchk_setup_symlink(
 	struct xfs_inode	*ip)
 {
 	/* Allocate the buffer without the inode lock held. */
-	sc->buf = kmem_zalloc_large(XFS_SYMLINK_MAXLEN + 1, 0);
+	sc->buf = kvzalloc(XFS_SYMLINK_MAXLEN + 1, GFP_KERNEL);
 	if (!sc->buf)
 		return -ENOMEM;
 
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index d4c687b5cd067..c544951a0c07f 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -192,7 +192,7 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 
 	if (acl) {
 		args.valuelen = XFS_ACL_SIZE(acl->a_count);
-		args.value = kmem_zalloc_large(args.valuelen, 0);
+		args.value = kvzalloc(args.valuelen, GFP_KERNEL);
 		if (!args.value)
 			return -ENOMEM;
 		xfs_acl_to_disk(args.value, acl);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6f22a66777cd0..4428b893f8372 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -404,7 +404,7 @@ xfs_ioc_attr_list(
 	     context.cursor.offset))
 		return -EINVAL;
 
-	buffer = kmem_zalloc_large(bufsize, 0);
+	buffer = kvzalloc(bufsize, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -1690,7 +1690,7 @@ xfs_ioc_getbmap(
 	if (bmx.bmv_count > ULONG_MAX / recsize)
 		return -ENOMEM;
 
-	buf = kmem_zalloc_large(bmx.bmv_count * sizeof(*buf), 0);
+	buf = kvzalloc(bmx.bmv_count * sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6209e7b6b895b..0558f92ecdb83 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -862,7 +862,7 @@ xfs_alloc_rsum_cache(
 	 * lower bound on the minimum level with any free extents. We can
 	 * continue without the cache if it couldn't be allocated.
 	 */
-	mp->m_rsum_cache = kmem_zalloc_large(rbmblocks, 0);
+	mp->m_rsum_cache = kvzalloc(rbmblocks, GFP_KERNEL);
 	if (!mp->m_rsum_cache)
 		xfs_warn(mp, "could not allocate realtime summary cache");
 }
-- 
2.26.2

