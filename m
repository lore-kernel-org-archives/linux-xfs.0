Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C60CEED61A
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Sep 2023 18:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbjIOSmB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Sep 2023 14:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236864AbjIOSlq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2023 14:41:46 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050:0:465::102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926A64232;
        Fri, 15 Sep 2023 11:40:19 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4RnNK30KtMz9scy;
        Fri, 15 Sep 2023 20:39:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
        s=MBO0001; t=1694803191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yBandIomLcSEx0nPSvrcvRyAh/l4Pv1QDX49YB+LVO8=;
        b=mYMhQTCPSuTWWpI2a7DZoXA2b4Z2aKNhpG6QuCtm6/2AiRPlUnh5ztr81m0prSgYeB5R2N
        Ubm+xxqIg8F/FN+j3+bmMvc3lFgXMlwoMTJVlrwlxDrqWuSm2qLZyxjNlwSHqn/pZs5Wqv
        4Ex7wSgqjRITqAxHX5nWM2terZrh1tp/A7U7RddsO8AguL/6WxFiG+uPzAnJusn8ziCa9d
        SQjJDxzA7meuf23dlFCDvgDHn4S9+cb3doEld4C/rY7esq1tecmimNp0kyvrO1IowB0WOO
        pbte7nFfRvCr28HTfjEYrVOMsJlaYLN0vE+DazB0umhH//atGpqlgDbXCGO0mg==
From:   Pankaj Raghav <kernel@pankajraghav.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     p.raghav@samsung.com, david@fromorbit.com, da.gomez@samsung.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        willy@infradead.org, djwong@kernel.org, linux-mm@kvack.org,
        chandan.babu@oracle.com, mcgrof@kernel.org, gost.dev@samsung.com,
        Dave Chinner <dchinner@redhat.com>
Subject: [RFC 21/23] xfs: expose block size in stat
Date:   Fri, 15 Sep 2023 20:38:46 +0200
Message-Id: <20230915183848.1018717-22-kernel@pankajraghav.com>
In-Reply-To: <20230915183848.1018717-1-kernel@pankajraghav.com>
References: <20230915183848.1018717-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

For block size larger than page size, the unit of efficient IO is
the block size, not the page size. Leaving stat() to report
PAGE_SIZE as the block size causes test programs like fsx to issue
illegal ranges for operations that require block size alignment
(e.g. fallocate() insert range). Hence update the preferred IO size
to reflect the block size in this case.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[mcgrof: forward rebase in consideration for commit
dd2d535e3fb29d ("xfs: cleanup calculating the stat optimal I/O size")]
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/xfs_iops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2ededd3f6b8c..080a79a81c46 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -515,6 +515,8 @@ xfs_stat_blksize(
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	unsigned long	default_size = max_t(unsigned long, PAGE_SIZE,
+					     mp->m_sb.sb_blocksize);
 
 	/*
 	 * If the file blocks are being allocated from a realtime volume, then
@@ -543,7 +545,7 @@ xfs_stat_blksize(
 			return 1U << mp->m_allocsize_log;
 	}
 
-	return PAGE_SIZE;
+	return default_size;
 }
 
 STATIC int
-- 
2.40.1

