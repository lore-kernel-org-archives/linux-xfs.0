Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555E4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbiLaBzR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbiLaByv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:54:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5251F1DDDD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:54:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 97952CE19F4
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D977CC433EF;
        Sat, 31 Dec 2022 01:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451686;
        bh=om4+79GL+45ZRqsCK0wB4AkGZWkh1Jrw1QfFPDlns2o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TyO0rb0kDov7C8Jg7jTlALmY2OdrUchrHMKh8gLjJGwo4vA5i6ff0o1/9ELAC7Jh/
         OQQA9fmt0Pt0qH94bVuN4ccsFrQ1S26Q8MiSuJlg0DCoFoh+4FjS73jBSkmx7slK2+
         42hK5vwat+ccTLExj/0Yf47MPE10qmmWg+gpnebo/XJHIpYFTg5cW7tf2wxBOk+rIT
         zRmhtvcpuDaG6cYwd7aeqOEfv5MXaQn2e9p6k3CytRsUzmNPJgT1PsVX4aaL8pT0Xd
         33Nq+hIhEk/kmjo7ho+AwKMj+CZkZUK2akIq8wPW2Deg7wo5QXYKU0KAPs429Nk4gO
         9n8tIzYgXuBaQ==
Subject: [PATCH 26/42] xfs: check that the rtrefcount maxlevels doesn't
 increase when growing fs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:32 -0800
Message-ID: <167243871265.717073.12647043438282202534.stgit@magnolia>
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

The size of filesystem transaction reservations depends on the maximum
height (maxlevels) of the realtime btrees.  Since we don't want a grow
operation to increase the reservation size enough that we'll fail the
minimum log size checks on the next mount, constrain growfs operations
if they would cause an increase in the rt refcount btree maxlevels.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c   |    2 ++
 fs/xfs/xfs_rtalloc.c |    2 ++
 2 files changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 65b44ad8884e..317f0461f490 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -24,6 +24,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtalloc.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
@@ -225,6 +226,7 @@ xfs_growfs_data_private(
 
 		/* Compute new maxlevels for rt btrees. */
 		xfs_rtrmapbt_compute_maxlevels(mp);
+		xfs_rtrefcountbt_compute_maxlevels(mp);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 48c7cc28b7f2..7f1ee9432e71 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1172,6 +1172,7 @@ xfs_growfs_check_rtgeom(
 		fake_mp->m_features |= XFS_FEAT_REALTIME;
 
 	xfs_rtrmapbt_compute_maxlevels(fake_mp);
+	xfs_rtrefcountbt_compute_maxlevels(fake_mp);
 
 	xfs_trans_resv_calc(fake_mp, M_RES(fake_mp));
 	min_logfsbs = xfs_log_calc_minimum_size(fake_mp);
@@ -1474,6 +1475,7 @@ xfs_growfs_rt(
 		 */
 		mp->m_features |= XFS_FEAT_REALTIME;
 		xfs_rtrmapbt_compute_maxlevels(mp);
+		xfs_rtrefcountbt_compute_maxlevels(mp);
 	}
 	if (error)
 		goto out_free;

