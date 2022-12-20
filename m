Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E52AC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 00:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiLTAFR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 19:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiLTAFQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 19:05:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B836E63A6
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 16:05:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54241611BC
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 00:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FE7C433D2;
        Tue, 20 Dec 2022 00:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671494714;
        bh=zc4L0DeigfaSG4iPy19l3vxtcNO6pE+AQ2x5oJC7ngg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WDePgkKVNkkDJ7BQEM6DDUvix5jFkACLENQaCA3BYLyKGwHyRg0oIfqkH2rQ5zQgI
         igTCl7Zc6dRhW1tgSo0lS3Az+u3aL29EXPuyn6g1dTrVLytvdb+VAtBRQsES0c6ay5
         CVC+Hqd9I+Mc2GW+8fr1l+gDRG6qC0sD7fn964d5S+xkdNXfkPpR0iYtPi7GgC+UUy
         TjV5I0j4qT72ZLjksx6NJl/Wa3oppR5HgFfYvJpvyy4kFapevkplDUXIZwcnsAAab7
         6btI0KeEiROjsPvRPC+TFS11qPqo2PCUgNwV+ROn+fNzqu4t+b3uveIuD2T3/uw/ar
         UXSOFB4yhwmtQ==
Subject: [PATCH 3/4] xfs: make xfs_iomap_page_ops static
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 19 Dec 2022 16:05:14 -0800
Message-ID: <167149471429.336919.12382220831144249809.stgit@magnolia>
In-Reply-To: <167149469744.336919.13748690081866673267.stgit@magnolia>
References: <167149469744.336919.13748690081866673267.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Shut up the sparse warnings about this variable that isn't referenced
anywhere else.

Fixes: cd89a0950c40 ("xfs: use iomap_valid method to detect stale cached iomaps")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 669c1bc5c3a7..fc1946f80a4a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -83,7 +83,7 @@ xfs_iomap_valid(
 	return true;
 }
 
-const struct iomap_page_ops xfs_iomap_page_ops = {
+static const struct iomap_page_ops xfs_iomap_page_ops = {
 	.iomap_valid		= xfs_iomap_valid,
 };
 

