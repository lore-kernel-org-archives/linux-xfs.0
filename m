Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DF6C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Mar 2023 20:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjCIUOd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Mar 2023 15:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjCIUOc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Mar 2023 15:14:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93D2E252D
        for <linux-xfs@vger.kernel.org>; Thu,  9 Mar 2023 12:14:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76F2C61CC3
        for <linux-xfs@vger.kernel.org>; Thu,  9 Mar 2023 20:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5B1C433EF;
        Thu,  9 Mar 2023 20:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678392870;
        bh=oJ5mZgwHa3Fp3JqNAfTM16Hrg2VSgufvX9h+R7jLvCQ=;
        h=Date:From:To:Cc:Subject:From;
        b=lpXfoe3XBHs46WeZpdYRrfyvrR/ACW7SOuRbIt0O2eVoQk8uWLX2JgqSeXAsdBzSr
         YIYWG+bpKhx2NezymZF92o3R5ZYhOA8rQo81N+xy7ox3CRazxrFKUrsWlcVPcvcIu3
         hHeIo0wzv1ltAOL3+/fLUT+evhRKmOPWBVGCdOK6tEprRXni6BLRZLpOJNOLGi2K9i
         bAlVx21ow7qiBY83oyGloNJwm5BQlfAFehj0qi2q7gElJ6/wOUA4WuF9Q9Q77wldMj
         kzDLvsbw+uLvRFU6yKkGrpEbNjFq5oj8WNUQH9dtbN06Lunp13qLidm3wpVnzXxsQx
         vopksgMtt2Umw==
Date:   Thu, 9 Mar 2023 12:14:30 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: try to idiot-proof the allocators
Message-ID: <20230309201430.GE1637786@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In porting his development branch to 6.3-rc1, yours truly has
repeatedly screwed up the args->pag being fed to the xfs_alloc_vextent*
functions.  Add some debugging assertions to test the preconditions
required of the callers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b58e8e2daa72..e0c3527de6e4 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3410,6 +3410,9 @@ xfs_alloc_vextent_this_ag(
 	xfs_agnumber_t		minimum_agno;
 	int			error;
 
+	ASSERT(args->pag != NULL);
+	ASSERT(args->pag->pag_agno == agno);
+
 	args->agno = agno;
 	args->agbno = 0;
 	error = xfs_alloc_vextent_check_args(args, XFS_AGB_TO_FSB(mp, agno, 0),
@@ -3525,6 +3528,8 @@ xfs_alloc_vextent_start_ag(
 	bool			bump_rotor = false;
 	int			error;
 
+	ASSERT(args->pag == NULL);
+
 	args->agno = NULLAGNUMBER;
 	args->agbno = NULLAGBLOCK;
 	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
@@ -3573,6 +3578,8 @@ xfs_alloc_vextent_first_ag(
 	xfs_agnumber_t		start_agno;
 	int			error;
 
+	ASSERT(args->pag == NULL);
+
 	args->agno = NULLAGNUMBER;
 	args->agbno = NULLAGBLOCK;
 	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
@@ -3601,6 +3608,9 @@ xfs_alloc_vextent_exact_bno(
 	xfs_agnumber_t		minimum_agno;
 	int			error;
 
+	ASSERT(args->pag != NULL);
+	ASSERT(args->pag->pag_agno == XFS_FSB_TO_AGNO(mp, target));
+
 	args->agno = XFS_FSB_TO_AGNO(mp, target);
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
 	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
@@ -3633,6 +3643,9 @@ xfs_alloc_vextent_near_bno(
 	bool			needs_perag = args->pag == NULL;
 	int			error;
 
+	if (!needs_perag)
+		ASSERT(args->pag->pag_agno == XFS_FSB_TO_AGNO(mp, target));
+
 	args->agno = XFS_FSB_TO_AGNO(mp, target);
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
 	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
