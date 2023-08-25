Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D74CEE49B2
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Aug 2023 14:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245632AbjHYOEe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Aug 2023 10:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245644AbjHYOEL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2023 10:04:11 -0400
Received: from out-243.mta1.migadu.com (out-243.mta1.migadu.com [IPv6:2001:41d0:203:375::f3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DEC213D;
        Fri, 25 Aug 2023 07:03:39 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692972199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oO47LbY0b5fVyG7D8YYQFkwRO57XM5uT3mfj/DxMSkA=;
        b=j1kjownAAX9hJfB2BxApQkooYMrevfaPLxvPystRVIJaNfbMrYunmfkjCazr0ChWhlvVjY
        lRX7+a9ciN0hwgjNK4X5Fb69aObVTB6DVFK6AZND7C0g5qPAW+vA7D+a0HhCiOEWDX9QRj
        DdPtV8aYlp/xMHVmKP0gIoyMuJWp9/M=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-cachefs@redhat.com,
        ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org,
        devel@lists.orangefs.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mtd@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 19/29] xfs: support nowait memory allocation in _xfs_buf_alloc()
Date:   Fri, 25 Aug 2023 21:54:21 +0800
Message-Id: <20230825135431.1317785-20-hao.xu@linux.dev>
In-Reply-To: <20230825135431.1317785-1-hao.xu@linux.dev>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Choose different gfp flags to support nowait memory allocation in
_xfs_buf_alloc().

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_buf.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9f84bc3b802c..8b800ce28996 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -220,9 +220,14 @@ _xfs_buf_alloc(
 	struct xfs_buf		*bp;
 	int			error;
 	int			i;
+	bool			nowait = flags & XBF_NOWAIT;
+	gfp_t			gfp_flags = GFP_NOFS |
+					    (nowait ? 0 : __GFP_NOFAIL);
 
 	*bpp = NULL;
-	bp = kmem_cache_zalloc(xfs_buf_cache, GFP_NOFS | __GFP_NOFAIL);
+	bp = kmem_cache_zalloc(xfs_buf_cache, gfp_flags);
+	if (!bp)
+		return -EAGAIN;
 
 	/*
 	 * We don't want certain flags to appear in b_flags unless they are
-- 
2.25.1

