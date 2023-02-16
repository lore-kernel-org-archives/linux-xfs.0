Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B646BC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjBPU6f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjBPU6f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:58:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A38452894
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:58:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33791B82962
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD56C433D2;
        Thu, 16 Feb 2023 20:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581108;
        bh=QjCPbFO9hWHc2w+9tZvZDkdWlFLPtNvu2yd7XprUtYA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ntZyC7jwYAfPFWCw0Q+FUeCqUJndTHDZa9MWXPjQI5HgpqzTqZXJuWVEDaJoNUsAW
         rS2wvuJYcosxH5GoxLafuLceI7xyQ/OX8inlRH83O/7gnkl+iTMHf5qsIcR+ZGcxUf
         ocszAdesVIqV1ESP1fbH6pqePbBGktMYg1KtJnGv35KnltF2Q2uDYfVOR/PpBbuQuE
         wxl4ENH8ahT+wYfTKcYPZ5a2cBsltv8jp5Y/+gjvVeIcHd9yt6LGCBEL0YH/GvtC1n
         mGujmDzgbvIg/vzjaAPJ6VsA3XF4ju28g32wDkp9QQSpm1dTN8BU271mbAgp3GJpz7
         47+5HdXq4Y/eg==
Date:   Thu, 16 Feb 2023 12:58:27 -0800
Subject: [PATCH 19/25] xfsprogs: drop compatibility minimum log size
 computations for reflink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879161.3476112.12858146976098748353.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: c14b8c08a1dff8019bc4cd1674c5d5bd4248a1e5

Having established that we can reduce the minimum log size computation
for filesystems with parent pointers or any newer feature, we should
also drop the compat minlogsize code that we added when we reduced the
transaction reservation size for rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_log_rlimit.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
index 6ecb9ad5..59605f0d 100644
--- a/libxfs/xfs_log_rlimit.c
+++ b/libxfs/xfs_log_rlimit.c
@@ -91,6 +91,16 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * drops the oversized minimum log size computation introduced by the
+	 * original reflink code.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to

