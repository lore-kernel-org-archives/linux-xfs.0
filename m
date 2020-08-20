Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C17C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 17:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47A65208A9
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 17:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bk8cpg2o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbgHTRJq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 13:09:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36846 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730421AbgHTRHj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 13:07:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597943257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=g+E6g6wMsWCm5KXTPRoZvRyhBx+9jVq5FcwWRO6dFrE=;
        b=bk8cpg2oxGj6AF/ZMs3ZVMXLWrnQJ0SRO3PvdWtPZ/2RylG6zkINxTOFxJkFow8/+cbhnL
        JSwviX3SXNSY4ihx8KNAwViw5nfh/BsBBK+K69uo0c2HQ6cA9OuvEu3GrQ+eWglWi/GqYx
        YsOYHmD0a37EzcaklDlxikAGIgEzQWY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-9N_pKn18Np2qn2RPJEg6gA-1; Thu, 20 Aug 2020 13:07:35 -0400
X-MC-Unique: 9N_pKn18Np2qn2RPJEg6gA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E80A41074649
        for <linux-xfs@vger.kernel.org>; Thu, 20 Aug 2020 17:07:34 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAF2F5C1CF
        for <linux-xfs@vger.kernel.org>; Thu, 20 Aug 2020 17:07:34 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix off-by-one in inode alloc block reservation calculation
Date:   Thu, 20 Aug 2020 13:07:34 -0400
Message-Id: <20200820170734.200502-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The inode chunk allocation transaction reserves inobt_maxlevels-1
blocks to accommodate a full split of the inode btree. A full split
requires an allocation for every existing level and a new root
block, which means inobt_maxlevels is the worst case block
requirement for a transaction that inserts to the inobt. This can
lead to a transaction block reservation overrun when tmpfile
creation allocates an inode chunk and expands the inobt to its
maximum depth. This problem has been observed in conjunction with
overlayfs, which makes frequent use of tmpfiles internally.

The existing reservation code goes back as far as the Linux git repo
history (v2.6.12). It was likely never observed as a problem because
the traditional file/directory creation transactions also include
worst case block reservation for directory modifications, which most
likely is able to make up for a single block deficiency in the inode
allocation portion of the calculation. tmpfile support is relatively
more recent (v3.15), less heavily used, and only includes the inode
allocation block reservation as tmpfiles aren't linked into the
directory tree on creation.

Fix up the inode alloc block reservation macro and a couple of the
block allocator minleft parameters that enforce an allocation to
leave enough free blocks in the AG for a full inobt split.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c      | 4 ++--
 fs/xfs/libxfs/xfs_trans_space.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index f742a96a2fe1..a6b37db55169 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -688,7 +688,7 @@ xfs_ialloc_ag_alloc(
 		args.minalignslop = igeo->cluster_align - 1;
 
 		/* Allow space for the inode btree to split. */
-		args.minleft = igeo->inobt_maxlevels - 1;
+		args.minleft = igeo->inobt_maxlevels;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 
@@ -736,7 +736,7 @@ xfs_ialloc_ag_alloc(
 		/*
 		 * Allow space for the inode btree to split.
 		 */
-		args.minleft = igeo->inobt_maxlevels - 1;
+		args.minleft = igeo->inobt_maxlevels;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index c6df01a2a158..7ad3659c5d2a 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -58,7 +58,7 @@
 #define	XFS_IALLOC_SPACE_RES(mp)	\
 	(M_IGEO(mp)->ialloc_blks + \
 	 ((xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1) * \
-	  (M_IGEO(mp)->inobt_maxlevels - 1)))
+	  M_IGEO(mp)->inobt_maxlevels))
 
 /*
  * Space reservation values for various transactions.
-- 
2.25.4

