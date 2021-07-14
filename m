Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE436C12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 21:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99AE06101D
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 21:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbhGNVie (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 17:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229657AbhGNVie (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 17:38:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A5B6613AB;
        Wed, 14 Jul 2021 21:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626298542;
        bh=GX6Wd8q1m2ux0KAI6LHyotHI/ysf2WDiV9oGdocSIl0=;
        h=Date:From:To:Cc:Subject:From;
        b=VWYTKoon9BDBg8yX4wPUvik9GteV+8MELFegEBdef6AP2QVSjvnu6dyr/uPlM1bFi
         /O64fCBZpt3Pf1rP5i0fSlAZX+s5JlEdeWRCXki4TtK5xpYiS3zm0rHSTfq/7gA6iP
         7UxA+hwJbQy4SzPgHPNRQd3viR5myFKGZcupk6B++8tjqwd72WtUR7Zo0H3E+x2kbZ
         pEfk6HJxy5hN6WN5h1K8tGuwbDG2U42aDY9ph5Pu282dMZeSeZSS3mAQuvOujnXsHk
         QmX5OLsbrra8FV9dajZoQLeFQ2T85NzJOsLyx1fLT5PggGb2DHmKLCxxige5APLb20
         waA+A5su5k89Q==
Date:   Wed, 14 Jul 2021 14:35:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: detect misaligned rtinherit directory extent size hints
Message-ID: <20210714213542.GK22402@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we encounter a directory that has been configured to pass on an
extent size hint to a new realtime file and the hint isn't an integer
multiple of the rt extent size, we should flag the hint for
administrative review because that is a misconfiguration (that other
parts of the kernel will fix automatically).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 61f90b2c9430..76fbc7ca4cec 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -73,11 +73,25 @@ xchk_inode_extsize(
 	uint16_t		flags)
 {
 	xfs_failaddr_t		fa;
+	uint32_t		value = be32_to_cpu(dip->di_extsize);
 
-	fa = xfs_inode_validate_extsize(sc->mp, be32_to_cpu(dip->di_extsize),
-			mode, flags);
+	fa = xfs_inode_validate_extsize(sc->mp, value, mode, flags);
 	if (fa)
 		xchk_ino_set_corrupt(sc, ino);
+
+	/*
+	 * XFS allows a sysadmin to change the rt extent size when adding a rt
+	 * section to a filesystem after formatting.  If there are any
+	 * directories with extszinherit and rtinherit set, the hint could
+	 * become misaligned with the new rextsize.  The verifier doesn't check
+	 * this, because we allow rtinherit directories even without an rt
+	 * device.  Flag this as an administrative warning since we will clean
+	 * this up eventually.
+	 */
+	if ((flags & XFS_DIFLAG_RTINHERIT) &&
+	    (flags & XFS_DIFLAG_EXTSZINHERIT) &&
+	    value % sc->mp->m_sb.sb_rextsize > 0)
+		xchk_ino_set_warning(sc, ino);
 }
 
 /*
