Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7842CC2BB3F
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Nov 2023 18:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbjKTSbt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjKTSbs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 13:31:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74032C4
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2023 10:31:45 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CC3C433C9;
        Mon, 20 Nov 2023 18:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700505105;
        bh=ML45LT19vOJjbCYI9gw1n0kSqKngdZuIE6GiaOeyCVw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q2t6/Zf/186MSYKuOkPWs1pJ2qmVVU+SL6uCm3DgnSRKp40l3k9qZiZJyZ8Le0XvT
         kqV+RwlXeoSyT4C2kzIzDqyo5RvtliOfF7dDxTlGARM5riCe166C3/YZMdb/aRAA6v
         3IsaL2VVNwCCBm+cVUJMvHO/K24bs+fS94sQ5253yG/zAAz66d4fnyVunSNWC0Jqm8
         eDJIXQ9Jx51DcnHNk+8lLioTm5Un0eJR5gzUaDb4O75NCdAKiJ5bPZ+uhhM/7RXeKs
         yF1PI1JTG21TxSdyq0pqMiXbGk33pequ6a1Gub80yNWEVsDpj8pS6p7cJJlWv9r7e2
         nmoVAnpzOEdag==
Subject: [PATCH 2/2] xfs: dquot recovery does not validate the recovered dquot
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org, chandanbabu@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 20 Nov 2023 10:31:44 -0800
Message-ID: <170050510455.475996.9499832219704912265.stgit@frogsfrogsfrogs>
In-Reply-To: <170050509316.475996.582959032103929936.stgit@frogsfrogsfrogs>
References: <170050509316.475996.582959032103929936.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're recovering ondisk quota records from the log, we need to
validate the recovered buffer contents before writing them to disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_dquot_item_recover.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index db2cb5e4197b..2c2720ce6923 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -19,6 +19,7 @@
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_error.h"
 
 STATIC void
 xlog_recover_dquot_ra_pass2(
@@ -152,6 +153,19 @@ xlog_recover_dquot_commit_pass2(
 				 XFS_DQUOT_CRC_OFF);
 	}
 
+	/* Validate the recovered dquot. */
+	fa = xfs_dqblk_verify(log->l_mp, dqb, dq_f->qlf_id);
+	if (fa) {
+		XFS_CORRUPTION_ERROR("Bad dquot after recovery",
+				XFS_ERRLEVEL_LOW, mp, dqb,
+				sizeof(struct xfs_dqblk));
+		xfs_alert(mp,
+ "Metadata corruption detected at %pS, dquot 0x%x",
+				fa, dq_f->qlf_id);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+
 	ASSERT(dq_f->qlf_size == 2);
 	ASSERT(bp->b_mount == mp);
 	bp->b_flags |= _XBF_LOGRECOVERY;

