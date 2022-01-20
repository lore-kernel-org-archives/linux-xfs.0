Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D01EC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357748AbiATASF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:18:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45704 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344962AbiATAR6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:17:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40BF9B81B2B
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B121C004E1;
        Thu, 20 Jan 2022 00:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637876;
        bh=X5ogbnVjcveGrsscnUsS9u6ZVa/diJ/mSITaysyn854=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g05rrFoDCLZ681in93CBrNja+bKPaVNDvt4dW4XVg1+mhDnIamDK0Hvpa/sMcp1sZ
         795zHjyutpgH/Ud3Z7v+ZK/iUDSV6RTEy2iKOyk02mMMff2RUE4nr3GkQcPaoN4jbm
         pzoUimMx02E5IFYzWInYICkNsUY3MuesZxWyq3ju/zobH4CoDouqu7HWAtSiUxNbsE
         pYbgmgRR/Uxu+eubF8+HBTT49VLv4jbdcgzCnHLluIg6KEEpbcvDNfjaOW4xUKP13J
         zTp0ZAO0o/a+ptmyfgEBzzgVkcbnb69XKlbBwHNs/Cj9kGFrj7hsHaMoryg55snMDx
         hp3fw2gMixgbw==
Subject: [PATCH 06/45] xfs: allow setting and clearing of log incompat feature
 flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:17:55 -0800
Message-ID: <164263787575.860211.5138078235431743876.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 908ce71e54f8265fa909200410d6c50ab9a2d302

Log incompat feature flags in the superblock exist for one purpose: to
protect the contents of a dirty log from replay on a kernel that isn't
prepared to handle those dirty contents.  This means that they can be
cleared if (a) we know the log is clean and (b) we know that there
aren't any other threads in the system that might be setting or relying
upon a log incompat flag.

Therefore, clear the log incompat flags when we've finished recovering
the log, when we're unmounting cleanly, remounting read-only, or
freezing; and provide a function so that subsequent patches can start
using this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 37570cf0..5d8a1291 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -495,6 +495,21 @@ xfs_sb_has_incompat_log_feature(
 	return (sbp->sb_features_log_incompat & feature) != 0;
 }
 
+static inline void
+xfs_sb_remove_incompat_log_features(
+	struct xfs_sb	*sbp)
+{
+	sbp->sb_features_log_incompat &= ~XFS_SB_FEAT_INCOMPAT_LOG_ALL;
+}
+
+static inline void
+xfs_sb_add_incompat_log_features(
+	struct xfs_sb	*sbp,
+	unsigned int	features)
+{
+	sbp->sb_features_log_incompat |= features;
+}
+
 /*
  * V5 superblock specific feature checks
  */

