Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB0E1E7F14A
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjI0AUG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbjI0ASF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:18:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FE15260
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:39:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47011C433C8;
        Tue, 26 Sep 2023 23:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771585;
        bh=NRifYg+hJnogh2vy8+ZZc6Rvp3MUcvJT/6GXWziJefw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Kuru+vkqlsqHCltqOJ5e52IL15yRZVhe3BDkgRNS8wzoqP1gNrsbQW2sxwHlGscir
         9mTKy9PA5FAYs0FVBWbWtu5e9CH6EnN0Jxy0RcRe+gIRFSh59oVKTz/zZXxQAmI4C9
         weZOKHLfe4gLrqL6uMOnd9UZz0WFdvoUuz/n2N5F1qNx5U+jSZ2nr44LxRSYmMwOcr
         XzYV+Ii0BSQLmxYWnwC6kJbPMCnFHftwa4g4yG25gWpVoacg1B30TlDN3D0Cw2Opqi
         c/L8P6KGKYJSMwmXFbVsTHNXgaqCkeTYahsyO3vW+3U9Az5N9eBaSxjtJz4/uahJfU
         yzH2O5ePKSLTQ==
Date:   Tue, 26 Sep 2023 16:39:44 -0700
Subject: [PATCH 2/5] xfs: check dquot resource timers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577061605.3315644.17495425004699029452.stgit@frogsfrogsfrogs>
In-Reply-To: <169577061571.3315644.2567541587400012629.stgit@frogsfrogsfrogs>
References: <169577061571.3315644.2567541587400012629.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For each dquot resource, ensure either (a) the resource usage is over
the soft limit and there is a nonzero timer; or (b) usage is at or under
the soft limit and the timer is unset.  (a) is redundant with the dquot
buffer verifier, but (b) isn't checked anywhere.

Found by fuzzing xfs/426 and noticing that diskdq.btimer = add didn't
trip any kind of warning for having a timer set even with no limits.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/quota.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 59350cd7a325b..49835d2840b4a 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -117,6 +117,23 @@ xchk_quota_item_bmap(
 	return 0;
 }
 
+/* Complain if a quota timer is incorrectly set. */
+static inline void
+xchk_quota_item_timer(
+	struct xfs_scrub		*sc,
+	xfs_fileoff_t			offset,
+	const struct xfs_dquot_res	*res)
+{
+	if ((res->softlimit && res->count > res->softlimit) ||
+	    (res->hardlimit && res->count > res->hardlimit)) {
+		if (!res->timer)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+	} else {
+		if (res->timer)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+	}
+}
+
 /* Scrub the fields in an individual quota item. */
 STATIC int
 xchk_quota_item(
@@ -224,6 +241,10 @@ xchk_quota_item(
 	    dq->q_rtb.count > dq->q_rtb.hardlimit)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 
+	xchk_quota_item_timer(sc, offset, &dq->q_blk);
+	xchk_quota_item_timer(sc, offset, &dq->q_ino);
+	xchk_quota_item_timer(sc, offset, &dq->q_rtb);
+
 out:
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return -ECANCELED;

