Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25620C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbiLaBF2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiLaBF1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:05:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10AC1DF10
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:05:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CE10B81DE6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21781C433EF;
        Sat, 31 Dec 2022 01:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448724;
        bh=CnwnnU4y5oIN7jIJL4JAch/MzwrsNkqYAcvtqkLjWC0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O+5rxEV9MfM8hldHb3ypFbolc/ZeUwkScf3EIGjA3SBpx4lZVxb5gWduF963k7QUb
         MqrlWSToyHdv/rat/HRyvFIR+xM83ZBsLs5pCS+IdJwSbRnjZzn/HU2WIcZEYfe3Tn
         z7/D61pQRpr0w5byM7Q4HUaVipdaYCEw/C8ksK48YPr1fm8P2vN3pwU6ezmTkFdzqF
         fuzdHNuwm+TorMfPm+g2ZublPt7Rb6/1V/BD2OAbmjDDyb7KY9/mRlVgSCcdTivMJe
         8sl51gvIO/mVCbwibne8o5XP23zWdAIt6qsZapy/qm6FtUKKGUSzVmiP3U46CUP0s9
         pxXK2H84a3NEw==
Subject: [PATCH 01/20] xfs: move inode copy-on-write predicates to
 xfs_inode.[ch]
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:18 -0800
Message-ID: <167243863844.707335.18204528114075088956.stgit@magnolia>
In-Reply-To: <167243863809.707335.15895322495460356300.stgit@magnolia>
References: <167243863809.707335.15895322495460356300.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move these inode predicate functions to xfs_inode.[ch] since they're not
reflink functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c   |    7 +++++++
 fs/xfs/xfs_inode.h   |    7 +++++++
 fs/xfs/xfs_reflink.h |   10 ----------
 3 files changed, 14 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index af4ac808a0e0..abf8844df017 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3859,3 +3859,10 @@ xfs_inode_alloc_unitsize(
 
 	return XFS_FSB_TO_B(ip->i_mount, blocks);
 }
+
+bool
+xfs_is_always_cow_inode(
+	struct xfs_inode	*ip)
+{
+	return ip->i_mount->m_always_cow && xfs_has_reflink(ip->i_mount);
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index be704174fa4f..926f2d74413c 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -276,6 +276,13 @@ static inline bool xfs_is_metadata_inode(struct xfs_inode *ip)
 		xfs_is_quota_inode(&mp->m_sb, ip->i_ino);
 }
 
+bool xfs_is_always_cow_inode(struct xfs_inode *ip);
+
+static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
+{
+	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
+}
+
 /*
  * Check if an inode has any data in the COW fork.  This might be often false
  * even for inodes with the reflink flag when there is no pending COW operation.
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 65c5dfe17ecf..fb55e4ce49fa 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -6,16 +6,6 @@
 #ifndef __XFS_REFLINK_H
 #define __XFS_REFLINK_H 1
 
-static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
-{
-	return ip->i_mount->m_always_cow && xfs_has_reflink(ip->i_mount);
-}
-
-static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
-{
-	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
-}
-
 extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *irec, bool *shared);
 int xfs_bmap_trim_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,

