Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A61CEE49B5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Aug 2023 14:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245648AbjHYOEe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Aug 2023 10:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245745AbjHYOE0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2023 10:04:26 -0400
Received: from out-247.mta1.migadu.com (out-247.mta1.migadu.com [IPv6:2001:41d0:203:375::f7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCD22D59;
        Fri, 25 Aug 2023 07:04:06 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692972229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k/4ZXSLCSyhuRHiUlNViF+vdvrXezEQu+Nm95mQGfD4=;
        b=XN4VKQ0vJWdKOqygAoO6O9s0mfT9sbRl6WKC6PlM4YizrHDbuoZWPHymJ4boioTyhTPsXz
        mzB7w7XoqaVp3khAiC/KVcJAYhLbwQjG/YZ+xeSDe8Sd8K9S+AePqNUb6KBAAuKlTSuaCl
        kFQBsj5S1c42QHrr1w1CZcr0QQo5mJc=
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
Subject: [PATCH 21/29] xfs: return -EAGAIN when bulk memory allocation fails in nowait case
Date:   Fri, 25 Aug 2023 21:54:23 +0800
Message-Id: <20230825135431.1317785-22-hao.xu@linux.dev>
In-Reply-To: <20230825135431.1317785-1-hao.xu@linux.dev>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Rather than wait for a moment and retry, we return -EAGAIN when we fail
to allocate bulk memory in xfs_buf_alloc_pages() in nowait case.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_buf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a6e6e64ff940..eb3cd7702545 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -404,6 +404,11 @@ xfs_buf_alloc_pages(
 		if (filled != last)
 			continue;
 
+		if (nowait) {
+			xfs_buf_free_pages(bp);
+			return -EAGAIN;
+		}
+
 		if (flags & XBF_READ_AHEAD) {
 			xfs_buf_free_pages(bp);
 			return -ENOMEM;
-- 
2.25.1

