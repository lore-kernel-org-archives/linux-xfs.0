Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D6F0C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbiLaB4y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235949AbiLaB4x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:56:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0841C430
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:56:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07A9161C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EAFC433D2;
        Sat, 31 Dec 2022 01:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451811;
        bh=P1MBvR8Ig3ZbN/D1yJEWZqJp27h0H59cU9Ks1EOyRM0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CDcO6eNPUNcgwfyDOnuU7/LpYQ6GhqCKv1U1w53E2fTVhzIHWdemmoWIP4BU5gqrM
         sGJhj+PE/cdGqyKDd7KA5EHY9wrYAxbY1th0xk6yF27K4HiUSzeMHEZE7qTwWLKPoS
         8KffuQNgpZBtJcFGbDcgezu+RlM6Z/5kv5U3qLPsgJ1w2pCE+/EsbHg0ws3PnZfjRP
         HVFoSVvr9UaxbjwhP6WuCNKiSo+tzyMl5kfzacA1df5hky3Mqo1a8DrgHkMDEsvNZL
         fuexlcHA1EFdxCGncsz4oBq94iVN+xYPpK/a0KURfPNXR7XyuGkX3Gu7RVvAsGDUz3
         iNWpY2havgZfA==
Subject: [PATCH 34/42] xfs: detect and repair misaligned rtinherit directory
 cowextsize hints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:33 -0800
Message-ID: <167243871379.717073.9331036711596389250.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we encounter a directory that has been configured to pass on a CoW
extent size hint to a new realtime file and the hint isn't an integer
multiple of the rt extent size, we should flag the hint for
administrative review and/or turn it off because that is a
misconfiguration.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode.c        |   26 +++++++++++++++++---------
 fs/xfs/scrub/inode_repair.c |   15 +++++++++++++++
 2 files changed, 32 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index be9739035226..6a37973823d2 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -229,12 +229,7 @@ xchk_inode_extsize(
 		xchk_ino_set_warning(sc, ino);
 }
 
-/*
- * Validate di_cowextsize hint.
- *
- * The rules are documented at xfs_ioctl_setattr_check_cowextsize().
- * These functions must be kept in sync with each other.
- */
+/* Validate di_cowextsize hint. */
 STATIC void
 xchk_inode_cowextsize(
 	struct xfs_scrub	*sc,
@@ -245,12 +240,25 @@ xchk_inode_cowextsize(
 	uint64_t		flags2)
 {
 	xfs_failaddr_t		fa;
+	uint32_t		value = be32_to_cpu(dip->di_cowextsize);
 
-	fa = xfs_inode_validate_cowextsize(sc->mp,
-			be32_to_cpu(dip->di_cowextsize), mode, flags,
-			flags2);
+	fa = xfs_inode_validate_cowextsize(sc->mp, value, mode, flags, flags2);
 	if (fa)
 		xchk_ino_set_corrupt(sc, ino);
+
+	/*
+	 * XFS allows a sysadmin to change the rt extent size when adding a rt
+	 * section to a filesystem after formatting.  If there are any
+	 * directories with cowextsize and rtinherit set, the hint could become
+	 * misaligned with the new rextsize.  The verifier doesn't check this,
+	 * because we allow rtinherit directories even without an rt device.
+	 * Flag this as an administrative warning since we will clean this up
+	 * eventually.
+	 */
+	if ((flags & XFS_DIFLAG_RTINHERIT) &&
+	    (flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+	    value % sc->mp->m_sb.sb_rextsize > 0)
+		xchk_ino_set_warning(sc, ino);
 }
 
 /* Make sure the di_flags make sense for the inode. */
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 9f946406cfa0..3ce9ac5b0fc4 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1572,6 +1572,20 @@ xrep_inode_extsize(
 	}
 }
 
+/* Fix COW extent size hint problems. */
+STATIC void
+xrep_inode_cowextsize(
+	struct xfs_scrub	*sc)
+{
+	/* Fix misaligned CoW extent size hints on a directory. */
+	if ((sc->ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+	    (sc->ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+	    sc->ip->i_extsize % sc->mp->m_sb.sb_rextsize > 0) {
+		sc->ip->i_cowextsize = 0;
+		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
+	}
+}
+
 /* Fix any irregularities in an inode that the verifiers don't catch. */
 STATIC int
 xrep_inode_problems(
@@ -1587,6 +1601,7 @@ xrep_inode_problems(
 	xrep_inode_ids(sc);
 	xrep_inode_size(sc);
 	xrep_inode_extsize(sc);
+	xrep_inode_cowextsize(sc);
 
 	trace_xrep_inode_fixed(sc);
 	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);

