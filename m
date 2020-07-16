Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9229C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 12:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2DC420739
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 12:18:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X03pFpHL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgGPMSy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 08:18:54 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55366 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728094AbgGPMSx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 08:18:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594901932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MVfzauhoxN79SToEkTgESnZ6i3Yigwa/vETQysoFSl4=;
        b=X03pFpHLwStGZGQoP9o1CPlEBNeJFNAbon+cy2PP42xrjJiOVY0jjixF/RCXmxI1TghFlT
        i/52pxPLWYJkX1ZNzbrujscAXTWYJE2OvUScbvJ3Y1buyvmi8aj4FmbNyS5HiwSNQztqAb
        3XnZ2U4bQCPNgE2qCjdoM6vtxEpa5qM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-SfZwE2fjOf2K_hCI59ELhw-1; Thu, 16 Jul 2020 08:18:50 -0400
X-MC-Unique: SfZwE2fjOf2K_hCI59ELhw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB789100AA27
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 12:18:49 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7136579D1D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 12:18:49 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: replace ialloc space res macro with inline helper
Date:   Thu, 16 Jul 2020 08:18:49 -0400
Message-Id: <20200716121849.36661-1-bfoster@redhat.com>
In-Reply-To: <20200715193310.22002-1-bfoster@redhat.com>
References: <20200715193310.22002-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Rewrite the macro as a static inline helper to clean up the logic
and have one less macro.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_space.h | 24 ++++++++++++++++--------
 fs/xfs/xfs_inode.c              |  4 ++--
 fs/xfs/xfs_symlink.c            |  2 +-
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index c6df01a2a158..d08dfc8795c3 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -55,10 +55,18 @@
 	 XFS_DIRENTER_MAX_SPLIT(mp,nl))
 #define	XFS_DIRREMOVE_SPACE_RES(mp)	\
 	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
-#define	XFS_IALLOC_SPACE_RES(mp)	\
-	(M_IGEO(mp)->ialloc_blks + \
-	 ((xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1) * \
-	  (M_IGEO(mp)->inobt_maxlevels - 1)))
+
+static inline int
+xfs_ialloc_space_res(
+	struct xfs_mount	*mp)
+{
+	int			res = M_IGEO(mp)->ialloc_blks;
+
+	res += M_IGEO(mp)->inobt_maxlevels - 1;
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		res += M_IGEO(mp)->inobt_maxlevels - 1;
+	return res;
+}
 
 /*
  * Space reservation values for various transactions.
@@ -71,7 +79,7 @@
 #define	XFS_ATTRSET_SPACE_RES(mp, v)	\
 	(XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) + XFS_B_TO_FSB(mp, v))
 #define	XFS_CREATE_SPACE_RES(mp,nl)	\
-	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
+	(xfs_ialloc_space_res(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define	XFS_DIOSTRAT_SPACE_RES(mp, v)	\
 	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + (v))
 #define	XFS_GROWFS_SPACE_RES(mp)	\
@@ -81,18 +89,18 @@
 #define	XFS_LINK_SPACE_RES(mp,nl)	\
 	XFS_DIRENTER_SPACE_RES(mp,nl)
 #define	XFS_MKDIR_SPACE_RES(mp,nl)	\
-	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
+	(xfs_ialloc_space_res(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define	XFS_QM_DQALLOC_SPACE_RES(mp)	\
 	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + \
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
 #define	XFS_QM_QINOCREATE_SPACE_RES(mp)	\
-	XFS_IALLOC_SPACE_RES(mp)
+	xfs_ialloc_space_res(mp)
 #define	XFS_REMOVE_SPACE_RES(mp)	\
 	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
-	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
+	(xfs_ialloc_space_res(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_sb_version_hasfinobt(&mp->m_sb) ? \
 			M_IGEO(mp)->inobt_maxlevels : 0)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5c07bf491d9f..3420bc595e1b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1195,7 +1195,7 @@ xfs_create(
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-					resblks - XFS_IALLOC_SPACE_RES(mp));
+					resblks - xfs_ialloc_space_res(mp));
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1290,7 +1290,7 @@ xfs_create_tmpfile(
 	if (error)
 		return error;
 
-	resblks = XFS_IALLOC_SPACE_RES(mp);
+	resblks = xfs_ialloc_space_res(mp);
 	tres = &M_RES(mp)->tr_create_tmpfile;
 
 	error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8e88a7ca387e..b0a58cdd4c78 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -243,7 +243,7 @@ xfs_symlink(
 	 */
 	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
-	resblks -= XFS_IALLOC_SPACE_RES(mp);
+	resblks -= xfs_ialloc_space_res(mp);
 	/*
 	 * If the symlink will fit into the inode, write it inline.
 	 */
-- 
2.21.3

