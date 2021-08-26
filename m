Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A694DC4320E
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 17:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EBCC6103C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 17:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243224AbhHZRbL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Aug 2021 13:31:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230145AbhHZRbG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Aug 2021 13:31:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629999015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dYe8fDNOBrNQCWfa+DxnOtTefBsw1JXk3dpvdS9PoAQ=;
        b=h9ayOMO7NH787GxT6LeL0OArgEhC/cKfzXu4Gj9PXxeKtyoEsvUgUxs+19aZQ3F7SQUrf2
        puK7O8Egvu95nZN4a738ge5+My4pRzKglRN2lSHCS9SLzIggt3HKKCikrYqSc0DtE4PKkV
        1/a5VMjoo+iuaVDBkiyLtmDAKd5BAhc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-6jGcuBuoNReklyMCbgc2Eg-1; Thu, 26 Aug 2021 13:30:14 -0400
X-MC-Unique: 6jGcuBuoNReklyMCbgc2Eg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FC77839922
        for <linux-xfs@vger.kernel.org>; Thu, 26 Aug 2021 17:30:13 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.10.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CCAD100238C
        for <linux-xfs@vger.kernel.org>; Thu, 26 Aug 2021 17:30:13 +0000 (UTC)
From:   Bill O'Donnell <bodonnel@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: dax: facilitate EXPERIMENTAL warning for dax=inode case
Date:   Thu, 26 Aug 2021 12:30:12 -0500
Message-Id: <20210826173012.273932-1-bodonnel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When dax-mode was tri-stated by adding dax=inode case, the EXPERIMENTAL
warning on mount was missed for the case. Add logic to handle the
warning similar to that of the 'dax=always' case.

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
 fs/xfs/xfs_mount.h | 2 ++
 fs/xfs/xfs_super.c | 8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e091f3b3fa15..c9243a1b8d05 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -277,6 +277,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 
 /* Mount features */
+#define XFS_FEAT_DAX_INODE	(1ULL << 47)	/* DAX enabled */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
 #define XFS_FEAT_NOALIGN	(1ULL << 49)	/* ignore alignment */
 #define XFS_FEAT_ALLOCSIZE	(1ULL << 50)	/* user specified allocation size */
@@ -359,6 +360,7 @@ __XFS_HAS_FEAT(swalloc, SWALLOC)
 __XFS_HAS_FEAT(filestreams, FILESTREAMS)
 __XFS_HAS_FEAT(dax_always, DAX_ALWAYS)
 __XFS_HAS_FEAT(dax_never, DAX_NEVER)
+__XFS_HAS_FEAT(dax_inode, DAX_INODE)
 __XFS_HAS_FEAT(norecovery, NORECOVERY)
 __XFS_HAS_FEAT(nouuid, NOUUID)
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5e73ac78bf2f..f73f3687f0a8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -84,15 +84,16 @@ xfs_mount_set_dax_mode(
 {
 	switch (mode) {
 	case XFS_DAX_INODE:
+		mp->m_features |= XFS_FEAT_DAX_INODE;
 		mp->m_features &= ~(XFS_FEAT_DAX_ALWAYS | XFS_FEAT_DAX_NEVER);
 		break;
 	case XFS_DAX_ALWAYS:
 		mp->m_features |= XFS_FEAT_DAX_ALWAYS;
-		mp->m_features &= ~XFS_FEAT_DAX_NEVER;
+		mp->m_features &= ~(XFS_FEAT_DAX_NEVER | XFS_FEAT_DAX_INODE);
 		break;
 	case XFS_DAX_NEVER:
 		mp->m_features |= XFS_FEAT_DAX_NEVER;
-		mp->m_features &= ~XFS_FEAT_DAX_ALWAYS;
+		mp->m_features &= ~(XFS_FEAT_DAX_ALWAYS | XFS_FEAT_DAX_INODE);
 		break;
 	}
 }
@@ -189,6 +190,7 @@ xfs_fs_show_options(
 		{ XFS_FEAT_LARGE_IOSIZE,	",largeio" },
 		{ XFS_FEAT_DAX_ALWAYS,		",dax=always" },
 		{ XFS_FEAT_DAX_NEVER,		",dax=never" },
+		{ XFS_FEAT_DAX_INODE,		",dax=inode" },
 		{ 0, NULL }
 	};
 	struct xfs_mount	*mp = XFS_M(root->d_sb);
@@ -1584,7 +1586,7 @@ xfs_fs_fill_super(
 	if (xfs_has_crc(mp))
 		sb->s_flags |= SB_I_VERSION;
 
-	if (xfs_has_dax_always(mp)) {
+	if (xfs_has_dax_always(mp) || xfs_has_dax_inode(mp)) {
 		bool rtdev_is_dax = false, datadev_is_dax;
 
 		xfs_warn(mp,
-- 
2.31.1

