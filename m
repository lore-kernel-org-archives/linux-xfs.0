Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BC9C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjDFTbx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236270AbjDFTbw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:31:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3094ED2
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:31:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DA4E64B84
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DB3C433D2;
        Thu,  6 Apr 2023 19:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809510;
        bh=Dcsl0y3nUkmAw/pkVq7LdIFcYsBflNIKtKOQj5pEfQg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hCKlqZNx6apLzJXndnSLrWZDe3RnQ5gr0mdbFZKYLkjC+XSWq75iM5ntL74of2GT2
         RxTU/iSsCCzO5cPoabL0woNDrTjbD1DRTKcYYuVxfJaS0GNSMwboaIC3nZvx7h05/g
         3DcpTa0VBU5MUcBzBHbmfcI2AkH7iDSwg7bCZ55jgmE45MQE+My1xnzswo7rrDH7Jo
         HxMtURYtKulEBCX5ekZZNP3bExeevSexFasT9AKnGYlNydaD9sv7aBeM+tyRDySyzN
         EvYsmsJUD1JqHCjGSwtkCEt/UnvUQqsPNckSbGNs4ZtbGnkU+LB2E73zBhpjgWHnkB
         bWpbTjhohk9yQ==
Date:   Thu, 06 Apr 2023 12:31:50 -0700
Subject: [PATCH 01/32] xfsprogs: Increase XFS_DEFER_OPS_NR_INODES to 5
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827571.616793.46028655914667874.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
References: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: e9dc6a1e293b7e3843cd3868603801a1af2704c3

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 libxfs/libxfs_priv.h |    1 +
 libxfs/xfs_defer.c   |   28 ++++++++++++++++++++++++++--
 libxfs/xfs_defer.h   |    8 +++++++-
 3 files changed, 34 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index e5f37df28..98966f584 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -478,6 +478,7 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 	__mode = __mode; /* no set-but-unused warning */	\
 })
 #define xfs_lock_two_inodes(ip0,mode0,ip1,mode1)	((void) 0)
+#define xfs_lock_inodes(ips,num_ips,mode)		((void) 0)
 
 /* space allocation */
 #define XFS_EXTENT_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index c4f0269d6..415fcaf56 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -815,13 +815,37 @@ xfs_defer_ops_continue(
 	struct xfs_trans		*tp,
 	struct xfs_defer_resources	*dres)
 {
-	unsigned int			i;
+	unsigned int			i, j;
+	struct xfs_inode		*sips[XFS_DEFER_OPS_NR_INODES];
+	struct xfs_inode		*temp;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock the captured resources to the new transaction. */
-	if (dfc->dfc_held.dr_inos == 2)
+	if (dfc->dfc_held.dr_inos > 2) {
+		/*
+		 * Renames with parent pointer updates can lock up to 5 inodes,
+		 * sorted by their inode number.  So we need to make sure they
+		 * are relocked in the same way.
+		 */
+		memset(sips, 0, sizeof(sips));
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++)
+			sips[i] = dfc->dfc_held.dr_ip[i];
+
+		/* Bubble sort of at most 5 inodes */
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
+			for (j = 1; j < dfc->dfc_held.dr_inos; j++) {
+				if (sips[j]->i_ino < sips[j-1]->i_ino) {
+					temp = sips[j];
+					sips[j] = sips[j-1];
+					sips[j-1] = temp;
+				}
+			}
+		}
+
+		xfs_lock_inodes(sips, dfc->dfc_held.dr_inos, XFS_ILOCK_EXCL);
+	} else if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 114a3a493..fdf6941f8 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -70,7 +70,13 @@ extern const struct xfs_defer_op_type xfs_attr_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with deferred ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */

