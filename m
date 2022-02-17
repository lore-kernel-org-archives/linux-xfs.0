Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC34CC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Feb 2022 17:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243699AbiBQRZi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Feb 2022 12:25:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239214AbiBQRZi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Feb 2022 12:25:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 852BC2B1677
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 09:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645118722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fVsKDvpy3vIocTn0eYJ+ZrR52T4MtWnU49WFxgZ+PAg=;
        b=FiD1YPUpyTsi3RHVNI4KNySaN3SRTXfTF8geyeeOecpSK2rRtY9Hs8c7qAmCVSqfaV2xM9
        uFkz3PbkZTZxLWakeI8e9s34PFZyxdZXk530cuvCEDlVXvnWO2XLrbJSQE6XRtNbjowESx
        zy7l4Oeo8B0IwEzy4A1ZTRXVDy6QWMU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-t5hXas6AMDCGzZEbY3tEcg-1; Thu, 17 Feb 2022 12:25:21 -0500
X-MC-Unique: t5hXas6AMDCGzZEbY3tEcg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5218A1091DA1
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 17:25:20 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 106DF2DE6F
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 17:25:19 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC 2/4] xfs: tag reclaimable inodes with pending RCU grace periods as busy
Date:   Thu, 17 Feb 2022 12:25:16 -0500
Message-Id: <20220217172518.3842951-3-bfoster@redhat.com>
In-Reply-To: <20220217172518.3842951-1-bfoster@redhat.com>
References: <20220217172518.3842951-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order to avoid aggressive recycling of in-core xfs_inode objects with
pending grace periods and the subsequent RCU sync stalls involved with
recycling, we must be able to identify them quickly and reliably at
allocation time. Claim a new tag for the in-core inode radix tree and
tag all inodes with a still pending grace period cookie as busy at the
time they are made reclaimable.

Note that it is not necessary to maintain consistency between the tag
and grace period status once the tag is set. The busy tag simply
reflects that the grace period had not expired by the time the inode was
set reclaimable and therefore any reuse of the inode must first poll the
RCU subsystem for subsequent expiration of the grace period. Clear the
tag when the inode is recycled or reclaimed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_icache.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 693896bc690f..245ee0f6670b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -32,6 +32,8 @@
 #define XFS_ICI_RECLAIM_TAG	0
 /* Inode has speculative preallocations (posteof or cow) to clean. */
 #define XFS_ICI_BLOCKGC_TAG	1
+/* inode has pending RCU grace period when set reclaimable  */
+#define XFS_ICI_BUSY_TAG	2
 
 /*
  * The goal for walking incore inodes.  These can correspond with incore inode
@@ -274,7 +276,7 @@ xfs_perag_clear_inode_tag(
 	if (agino != NULLAGINO)
 		radix_tree_tag_clear(&pag->pag_ici_root, agino, tag);
 	else
-		ASSERT(tag == XFS_ICI_RECLAIM_TAG);
+		ASSERT(tag == XFS_ICI_RECLAIM_TAG || tag == XFS_ICI_BUSY_TAG);
 
 	if (tag == XFS_ICI_RECLAIM_TAG)
 		pag->pag_ici_reclaimable--;
@@ -336,6 +338,7 @@ xfs_iget_recycle(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	int			error;
 
 	trace_xfs_iget_recycle(ip);
@@ -392,8 +395,9 @@ xfs_iget_recycle(
 	 */
 	ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
 	ip->i_flags |= XFS_INEW;
-	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
-			XFS_ICI_RECLAIM_TAG);
+
+	xfs_perag_clear_inode_tag(pag, agino, XFS_ICI_BUSY_TAG);
+	xfs_perag_clear_inode_tag(pag, agino, XFS_ICI_RECLAIM_TAG);
 	inode->i_state = I_NEW;
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
@@ -931,6 +935,7 @@ xfs_reclaim_inode(
 	if (!radix_tree_delete(&pag->pag_ici_root,
 				XFS_INO_TO_AGINO(ip->i_mount, ino)))
 		ASSERT(0);
+	xfs_perag_clear_inode_tag(pag, NULLAGINO, XFS_ICI_BUSY_TAG);
 	xfs_perag_clear_inode_tag(pag, NULLAGINO, XFS_ICI_RECLAIM_TAG);
 	spin_unlock(&pag->pag_ici_lock);
 
@@ -1807,6 +1812,7 @@ xfs_inodegc_set_reclaimable(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 
 	if (!xfs_is_shutdown(mp) && ip->i_delayed_blks) {
 		xfs_check_delalloc(ip, XFS_DATA_FORK);
@@ -1821,10 +1827,12 @@ xfs_inodegc_set_reclaimable(
 	trace_xfs_inode_set_reclaimable(ip);
 	if (destroy_gp)
 		ip->i_destroy_gp = destroy_gp;
+	if (!poll_state_synchronize_rcu(ip->i_destroy_gp))
+		xfs_perag_set_inode_tag(pag, agino, XFS_ICI_BUSY_TAG);
+
 	ip->i_flags &= ~(XFS_NEED_INACTIVE | XFS_INACTIVATING);
 	ip->i_flags |= XFS_IRECLAIMABLE;
-	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
-			XFS_ICI_RECLAIM_TAG);
+	xfs_perag_set_inode_tag(pag, agino, XFS_ICI_RECLAIM_TAG);
 
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
-- 
2.31.1

