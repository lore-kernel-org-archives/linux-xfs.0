Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755205AbcK3WdQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Nov 2016 17:33:16 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6E9026A6D0
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2016 22:33:16 +0000 (UTC)
Received: from Liberator.example.com (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uAUMXFBf001805
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2016 17:33:16 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: ignore leaf attr ichdr.count in verifier during log
 replay
Message-ID: <596737a3-fbf8-8712-422c-4705ce36deae@redhat.com>
Date: Wed, 30 Nov 2016 16:33:15 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

When we create a new attribute, we first create a shortform
attribute, and try to fit the new attribute into it.
If that fails, we copy the (empty) attribute into a leaf attribute,
and do the copy again.  Thus there can be a transient state where
we have an empty leaf attribute.

If we encounter this during log replay, the verifier will fail.
So add a test to ignore this part of the leaf attr verification
during log replay.

Thanks as usual to dchinner for spotting the problem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 8ea91f3..2852521 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -253,6 +253,7 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_attr_leafblock *leaf = bp->b_addr;
+	struct xfs_perag *pag = bp->b_pag;
 	struct xfs_attr3_icleaf_hdr ichdr;
 
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
@@ -273,7 +274,12 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
 		if (ichdr.magic != XFS_ATTR_LEAF_MAGIC)
 			return false;
 	}
-	if (ichdr.count == 0)
+	/*
+	 * In recovery there is a transient state where count == 0 is valid
+	 * because we may have transitioned an empty shortform attr to a leaf
+	 * if the attr didn't fit in shortform.
+	 */
+	if (pag && pag->pagf_init && ichdr.count == 0)
 		return false;
 
 	/* XXX: need to range check rest of attr header values */
