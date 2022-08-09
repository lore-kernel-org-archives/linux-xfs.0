Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9F9C19F2D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 22:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiHIW4V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 18:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiHIW4U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 18:56:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E7B60531
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 15:56:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41CDEB81A0A
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 22:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5589C433D6;
        Tue,  9 Aug 2022 22:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660085777;
        bh=rDBMCD0frbeeewm+vGPL6nGv86fepSIlTqBGarD+9Ic=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l5onreUp4aTSIr7Qy3vkUaDkVU+CuPJRd7rviR/E2NQAooPwi2N5KFJafJ3gAZhbn
         G+yNlWNYyy4w5fNoaU958jtkWlzvLsrPPpKAiZF253NTcLW/Zl1MO/M1TjpImtc1He
         kcnpa+VDRb9DJJkOqpsvO4ceLDdF1YWxQZBzz4krm6fbFU5Kht5VcptKYSbzB8hwYv
         pkUvAH22hhzQ5PIv6Js7ig1kk9HwgHZHnvJ8z7Xe1+F/eEhbP6gE01qMqrMa8XHbM2
         v4iL5MQ6Y+2b5tM97pJBDOVlLX4iFJQ0mEqWpsVYbUkMUdFxOT2uCtmI47y8Mjn8Q8
         DqT71nHq+nofg==
Date:   Tue, 9 Aug 2022 15:56:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH 20/18] xfs: drop compatibility minimum log size
 computations for reflink
Message-ID: <YvLmEP3I2sH+Cm2+@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804194013.99237-1-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Having established that we can reduce the minimum log size computation
for filesystems with parent pointers or any newer feature, we should
also drop the compat minlogsize code that we added when we reduced the
transaction reservation size for rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_rlimit.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index cc4837b948b1..c6b098d12f65 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
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
