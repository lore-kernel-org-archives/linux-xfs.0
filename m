Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF6DC433E9
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A40865016
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhCEFM1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 00:12:27 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:55931 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229608AbhCEFMD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 00:12:03 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 65D0762F7D
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 16:11:51 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kg-00FboZ-Nn
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:50 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kg-000lZc-G7
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 18/45] xfs: reduce debug overhead of dir leaf/node checks
Date:   Fri,  5 Mar 2021 16:11:16 +1100
Message-Id: <20210305051143.182133-19-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210305051143.182133-1-david@fromorbit.com>
References: <20210305051143.182133-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=es5hYbETAauG9ijk2hQA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

On debug kernels, we call xfs_dir3_leaf_check_int() multiple times
on every directory modification. The robust hash ordering checks it
does on every entry in the leaf on every call results in a massive
CPU overhead which slows down debug kernels by a large amount.

We use xfs_dir3_leaf_check_int() for the verifiers as well, so we
can't just gut the function to reduce overhead. What we can do,
however, is reduce the work it does when it is called from the
debug interfaces, just leaving the high level checks in place and
leaving the robust validation to the verifiers. This means the debug
checks will catch gross errors, but subtle bugs might not be caught
until a verifier is run.

It is easy enough to restore the existing debug behaviour if the
developer needs it (just change a call parameter in the debug code),
but overwise the overhead makes testing large directory block sizes
on debug kernels very slow.

Profile at an unlink rate of ~80k file/s on a 64k block size
filesystem before the patch:

  40.30%  [kernel]  [k] xfs_dir3_leaf_check_int
  10.98%  [kernel]  [k] __xfs_dir3_data_check
   8.10%  [kernel]  [k] xfs_verify_dir_ino
   4.42%  [kernel]  [k] memcpy
   2.22%  [kernel]  [k] xfs_dir2_data_get_ftype
   1.52%  [kernel]  [k] do_raw_spin_lock

Profile after, at an unlink rate of ~125k files/s (+50% improvement)
has largely dropped the leaf verification debug overhead out of the
profile.

  16.53%  [kernel]  [k] __xfs_dir3_data_check
  12.53%  [kernel]  [k] xfs_verify_dir_ino
   7.97%  [kernel]  [k] memcpy
   3.36%  [kernel]  [k] xfs_dir2_data_get_ftype
   2.86%  [kernel]  [k] __pv_queued_spin_lock_slowpath

Create shows a similar change in profile and a +25% improvement in
performance.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_leaf.c | 10 +++++++---
 fs/xfs/libxfs/xfs_dir2_node.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_priv.h |  3 ++-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 95d2a3f92d75..ccd8d0aa62b8 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -113,7 +113,7 @@ xfs_dir3_leaf1_check(
 	} else if (leafhdr.magic != XFS_DIR2_LEAF1_MAGIC)
 		return __this_address;
 
-	return xfs_dir3_leaf_check_int(dp->i_mount, &leafhdr, leaf);
+	return xfs_dir3_leaf_check_int(dp->i_mount, &leafhdr, leaf, false);
 }
 
 static inline void
@@ -139,7 +139,8 @@ xfs_failaddr_t
 xfs_dir3_leaf_check_int(
 	struct xfs_mount		*mp,
 	struct xfs_dir3_icleaf_hdr	*hdr,
-	struct xfs_dir2_leaf		*leaf)
+	struct xfs_dir2_leaf		*leaf,
+	bool				expensive_checking)
 {
 	struct xfs_da_geometry		*geo = mp->m_dir_geo;
 	xfs_dir2_leaf_tail_t		*ltp;
@@ -162,6 +163,9 @@ xfs_dir3_leaf_check_int(
 	    (char *)&hdr->ents[hdr->count] > (char *)xfs_dir2_leaf_bests_p(ltp))
 		return __this_address;
 
+	if (!expensive_checking)
+		return NULL;
+
 	/* Check hash value order, count stale entries.  */
 	for (i = stale = 0; i < hdr->count; i++) {
 		if (i + 1 < hdr->count) {
@@ -195,7 +199,7 @@ xfs_dir3_leaf_verify(
 		return fa;
 
 	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, bp->b_addr);
-	return xfs_dir3_leaf_check_int(mp, &leafhdr, bp->b_addr);
+	return xfs_dir3_leaf_check_int(mp, &leafhdr, bp->b_addr, true);
 }
 
 static void
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 5d51265d29d6..80a64117b460 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -73,7 +73,7 @@ xfs_dir3_leafn_check(
 	} else if (leafhdr.magic != XFS_DIR2_LEAFN_MAGIC)
 		return __this_address;
 
-	return xfs_dir3_leaf_check_int(dp->i_mount, &leafhdr, leaf);
+	return xfs_dir3_leaf_check_int(dp->i_mount, &leafhdr, leaf, false);
 }
 
 static inline void
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 44c6a77cba05..94943ce49cab 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -127,7 +127,8 @@ xfs_dir3_leaf_find_entry(struct xfs_dir3_icleaf_hdr *leafhdr,
 extern int xfs_dir2_node_to_leaf(struct xfs_da_state *state);
 
 extern xfs_failaddr_t xfs_dir3_leaf_check_int(struct xfs_mount *mp,
-		struct xfs_dir3_icleaf_hdr *hdr, struct xfs_dir2_leaf *leaf);
+		struct xfs_dir3_icleaf_hdr *hdr, struct xfs_dir2_leaf *leaf,
+		bool expensive_checks);
 
 /* xfs_dir2_node.c */
 void xfs_dir2_free_hdr_from_disk(struct xfs_mount *mp,
-- 
2.28.0

