Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02AC0EE49BD
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Aug 2023 14:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245637AbjHYOGK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Aug 2023 10:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343525AbjHYOF4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2023 10:05:56 -0400
Received: from out-242.mta1.migadu.com (out-242.mta1.migadu.com [95.215.58.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDDA213B
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2023 07:05:31 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692972248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZAHRQkTlH3B9Ayy3ByDVW6IFO8x4JKviNIiMKvNnRxw=;
        b=rqq9t63T1b93nHdvHPb4iPnifbVgNhCPhaGA0/+lVUtdq72oLevGN3oePkSOWgj4tFeMJO
        883BuPqR+igY5LuYYZDHjdap5mSmKgc54EL0giqHkQRTPmks0t1/1oKfHQU1t1pMyd2ThX
        7baCMPgFPzeqpA42kG/A+w1RFMlPw/c=
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
Subject: [PATCH 22/29] xfs: comment page allocation for nowait case in xfs_buf_find_insert()
Date:   Fri, 25 Aug 2023 21:54:24 +0800
Message-Id: <20230825135431.1317785-23-hao.xu@linux.dev>
In-Reply-To: <20230825135431.1317785-1-hao.xu@linux.dev>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add comments for page allocation in nowait case in xfs_buf_find_insert()

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_buf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index eb3cd7702545..57bdc4c5dde1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -633,6 +633,8 @@ xfs_buf_find_insert(
 	 * allocate the memory from the heap to minimise memory usage. If we
 	 * can't get heap memory for these small buffers, we fall back to using
 	 * the page allocator.
+	 * xfs_buf_alloc_kmem may return -EAGAIN, let's not return it but turn
+	 * to page allocator as well.
 	 */
 	if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
 	    xfs_buf_alloc_kmem(new_bp, flags) < 0) {
-- 
2.25.1

