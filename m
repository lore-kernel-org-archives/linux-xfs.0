Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E20FC46467
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236322AbiLaDLg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiLaDLf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:11:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C03FCD8;
        Fri, 30 Dec 2022 19:11:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5658A61C7A;
        Sat, 31 Dec 2022 03:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9705C433EF;
        Sat, 31 Dec 2022 03:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456292;
        bh=oEf/zdfQhR48NYLAlvHHlJ9PBd0QNd/wjeiAJ8+ka5Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VErj2lI+baO7B9VqF1lAbBTCcJbLnqZX2PLEna5efEr3FZKtgx15FYAiLyKzC8N+H
         TxJVI88Hh0oeVT8Zi33qpY1RyO1c9vvdnTm5Wff1DpKVeE4eoyu6NqxxOBphBLCEM+
         tg6Rzvq8RKvnU0vYooQTxT8s+cxOruR3jvzUs/5dKSBPDDCPg3cBYkZtSaom2XzP5w
         aa2mu2EXQeKXmQhzpaMW/qFACzuD8Nu7LJLAPmed7GS5UKyZC9Q/UVWo7E2aHw3+Zm
         3nMQ6V4dIHDizv++N1lqtDMCARsMORTb/dbzcjRqhCFH7szvtXRw590LNrWaIeFLSS
         HLsTGRfx1sAnw==
Subject: [PATCH 08/12] xfs/122: update for rtbitmap headers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:40 -0800
Message-ID: <167243884050.739029.15010077823493214188.stgit@magnolia>
In-Reply-To: <167243883943.739029.3041109696120604285.stgit@magnolia>
References: <167243883943.739029.3041109696120604285.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 01376180cc..336618cf7a 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -115,6 +115,7 @@ sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12
 sizeof(struct xfs_rmap_key) = 20
 sizeof(struct xfs_rmap_rec) = 24
+sizeof(struct xfs_rtbuf_blkinfo) = 48
 sizeof(struct xfs_rtgroup_geometry) = 128
 sizeof(struct xfs_rtrmap_key) = 24
 sizeof(struct xfs_rtrmap_rec) = 32

