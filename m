Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52378 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753165AbeDRCrk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:47:40 -0400
Subject: [PATCH 08/11] xfs_repair: don't crash if da btree is corrupt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:47:21 -0700
Message-ID: <152401964171.13319.385054209589991590.stgit@magnolia>
In-Reply-To: <152401958920.13319.10756339531174871801.stgit@magnolia>
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In the recursive verify_da_path call chain, we decide to examine the
next upper level if the current entry points past the end of the
entries.  However, we don't check for a node with zero entries (which
should be impossible) so we run right off the end of the da cursor's
level array and crash.  Found by fuzzing hdr.count in xfs/402.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/da_util.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/repair/da_util.c b/repair/da_util.c
index a65652f..bca4060 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -526,6 +526,10 @@ verify_da_path(
 	else
 		geo = mp->m_attr_geo;
 
+	/* No buffer at this level, tree is corrupt. */
+	if (cursor->level[this_level].bp == NULL)
+		return 1;
+
 	/*
 	 * index is currently set to point to the entry that
 	 * should be processed now in this level.
@@ -535,6 +539,10 @@ verify_da_path(
 	btree = M_DIROPS(mp)->node_tree_p(node);
 	M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
 
+	/* No entries in this node?  Tree is corrupt. */
+	if (nodehdr.count == 0)
+		return 1;
+
 	/*
 	 * if this block is out of entries, validate this
 	 * block and move on to the next block.

