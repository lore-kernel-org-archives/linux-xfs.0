Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 576CEC43334
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Jul 2022 00:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiGAAMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jun 2022 20:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiGAAME (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jun 2022 20:12:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E316564CA
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jun 2022 17:12:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EC6BB815E0
        for <linux-xfs@vger.kernel.org>; Fri,  1 Jul 2022 00:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A501BC34115;
        Fri,  1 Jul 2022 00:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656634321;
        bh=yp5n/FOKo3mEWERvgMjyk8JrUNRPNBLJbeQZSyb+XsQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IMGZ84wHBUyZi2dViBjz+cg9rbm2xlwgIQrUXGA7GH0CiwC9YbsREsoeVO0MsTWSa
         mqUeUKWWz/hq2t4W/w6Z8/wZJqGhx9RGxR2cCiEZNEdu5W6u2j+3LOAzuozPN4xcUk
         GrjmcQPO9C/YQOIC6FVdrAqdWCON5W/0X+UXecOWE+YGTZbm5tcC/pwgdLyvCtfuJd
         kMutAolHqLvnvAWqFzZzYQ03A8rf+cMSb1eQ0aVY7WYqZGJo431HxRexqYWGHgLKX5
         GtXcvgTc6YToc+yAVzZ5ZzekRfk7MlejoegwXUbcnIlHsFvzni2MmwEvjuV4ddk/CW
         ly2ysMk8EBhJQ==
Date:   Thu, 30 Jun 2022 17:12:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/6] xfs_repair: clear DIFLAG2_NREXT64 when filesystem
 doesn't support nrext64
Message-ID: <Yr470cSmZ2+gvSdz@magnolia>
References: <165644935451.1089996.13716062701488693755.stgit@magnolia>
 <165644936573.1089996.11135224585697421312.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644936573.1089996.11135224585697421312.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clear the nrext64 inode flag if the filesystem doesn't have the nrext64
feature enabled in the superblock.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: remove unnecessary clearing of extent counters, we reset them anyway
---
 repair/dinode.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/repair/dinode.c b/repair/dinode.c
index 00de31fb..7610cd45 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2690,6 +2690,19 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			}
 		}
 
+		if (xfs_dinode_has_large_extent_counts(dino) &&
+		    !xfs_has_large_extent_counts(mp)) {
+			if (!uncertain) {
+				do_warn(
+	_("inode %" PRIu64 " is marked large extent counts but file system does not support large extent counts\n"),
+					lino);
+			}
+			flags2 &= ~XFS_DIFLAG2_NREXT64;
+
+			if (!no_modify)
+				*dirty = 1;
+		}
+
 		if (!verify_mode && flags2 != be64_to_cpu(dino->di_flags2)) {
 			if (!no_modify) {
 				do_warn(_("fixing bad flags2.\n"));
