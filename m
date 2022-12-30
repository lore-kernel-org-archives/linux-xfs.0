Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F83C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbiLaClc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236171AbiLaClb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:41:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080AF2DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:41:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4D59ECE1A8E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EC1C433EF;
        Sat, 31 Dec 2022 02:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454487;
        bh=Gfb528qmR1QPxoFi0BjY7OD5pFuor8jZpjkLr0UiJ3s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BPC6uzfb4GU3uJ8Fb80v2zh186Ck7puV+nH6tlOWS5azc1ZsExNJNRFTt6OpKOxNo
         jAaf3RR6E1zLxnetPyv0Uf1rWCZXkBO5Uf/roh7fLxxun/NRHxZ7YjOEZeRHQfrrs8
         pWLvM0efdu1UJl+MMRQaIKwNfda1164RX2oepx45bDZOuJFuoCmEP5f3mkaOj1BjGN
         HBbJHVYuLuu5SoZLqkSHR+yLZGqCu8AbLZyMmntMTMFuq2//GAaXqitZxN4/8XsSyL
         eqq0zamkpdkEqr6c6wA5fId735uMVhpHKdkfCs8zN+zwd0PI4z/OKLyjpt2mOjeOxm
         bhgR1JRpp7dzw==
Subject: [PATCH 44/45] mkfs: add headers to realtime summary blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:49 -0800
Message-ID: <167243878938.731133.3080262804421732994.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When the rtgroups feature is enabled, format rtsummary blocks with the
appropriate block headers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index daf0d419bce..846b48ec789 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -953,6 +953,14 @@ rtsummary_init(
 	if (error)
 		fail(_("Block allocation of the realtime summary inode failed"),
 				error);
+
+	if (xfs_has_rtgroups(mp)) {
+		error = init_rtblock_headers(mp->m_rsumip,
+				XFS_B_TO_FSB(mp, mp->m_rsumsize),
+				&xfs_rtsummary_buf_ops, XFS_RTSUMMARY_MAGIC);
+		if (error)
+			fail(_("Initialization of rtsummary failed"), error);
+	}
 }
 
 /*

