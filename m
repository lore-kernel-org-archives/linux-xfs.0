Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD5EC433C1
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Mar 2021 16:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 464C861942
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Mar 2021 16:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhCTQki (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Mar 2021 12:40:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229756AbhCTQkH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 20 Mar 2021 12:40:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 193CD6148E
        for <linux-xfs@vger.kernel.org>; Sat, 20 Mar 2021 16:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616258407;
        bh=BWv1e1vTKc4Bu3/Ieuy4G8Q+8j7MytzYeeLf9DqMHyU=;
        h=Date:From:To:Subject:From;
        b=rbPsnojrxjL9ODP2Lj94ZyC+Qz31A+prVz/SjluNRInGL3gXe+A5M0WrIgvg5CEYw
         Dfz7eafnerGK0ukBmnAW06iNaHwqx2e0WMUZi52sVFAaN06peD2JwnyNyNs9gw8Ga1
         JaObuKARqHdUsfpMAQOptjxDZwWQO57soC+kkAElKPriMoj0OCc4IZqe2d8h7SdxjJ
         biDMG5KShnxsiMVApWrbJiLNWO1ZcXS7jfR9AU3fsuf70pj4b2YpraNcSyVeIIl8yg
         MVHClsOKR3PxK07ULDuwadlWPaZnsyjxCsJfuid+99M37sLn6FpDlW7Ow+nnUcOmtJ
         ao12IfLO2ZC+Q==
Date:   Sat, 20 Mar 2021 09:40:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: only reset incore inode health state flags when
 reclaiming an inode
Message-ID: <20210320164007.GX22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While running some fuzz tests on inode metadata, I noticed that the
filesystem health report (as provided by xfs_spaceman) failed to report
the file corruption even when spaceman was run immediately after running
xfs_scrub to detect the corruption.  That isn't the intended behavior;
one ought to be able to run scrub to detect errors in the ondisk
metadata and be able to access to those reports for some time after the
scrub.

After running the same sequence through an instrumented kernel, I
discovered the reason why -- scrub igets the file, scans it, marks it
sick, and ireleases the inode.  When the VFS lets go of the incore
inode, it moves to RECLAIMABLE state.  If spaceman igets the incore
inode before it moves to RECLAIM state, iget reinitializes the VFS
state, clears the sick and checked masks, and hands back the inode.  At
this point, the caller has the exact same incore inode, but with all the
health state erased.

In other words, we're erasing the incore inode's health state flags when
we've decided NOT to sever the link between the incore inode and the
ondisk inode.  This is wrong, so we need to remove the lines that zero
the fields from xfs_iget_cache_hit.

As a precaution, we add the same lines into xfs_reclaim_inode just after
we sever the link between incore and ondisk inode.  Strictly speaking
this isn't necessary because once an inode has gone through reclaim it
must go through xfs_inode_alloc (which also zeroes the state) and
xfs_iget is careful to check for mismatches between the inode it pulls
out of the radix tree and the one it wants.

Fixes: 6772c1f11206 ("xfs: track metadata health status")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 595bda69b18d..5325fa28d099 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -587,8 +587,6 @@ xfs_iget_cache_hit(
 		ip->i_flags |= XFS_INEW;
 		xfs_inode_clear_reclaim_tag(pag, ip->i_ino);
 		inode->i_state = I_NEW;
-		ip->i_sick = 0;
-		ip->i_checked = 0;
 
 		spin_unlock(&ip->i_flags_lock);
 		spin_unlock(&pag->pag_ici_lock);
@@ -1205,6 +1203,8 @@ xfs_reclaim_inode(
 	spin_lock(&ip->i_flags_lock);
 	ip->i_flags = XFS_IRECLAIM;
 	ip->i_ino = 0;
+	ip->i_sick = 0;
+	ip->i_checked = 0;
 	spin_unlock(&ip->i_flags_lock);
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
