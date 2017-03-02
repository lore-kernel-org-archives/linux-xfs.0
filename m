Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36530 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753053AbdCBPqj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Mar 2017 10:46:39 -0500
From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH 2/2] xfs: back off from kmem_zalloc_greedy if the task is killed
Date: Thu,  2 Mar 2017 16:45:41 +0100
Message-Id: <20170302154541.16155-2-mhocko@kernel.org>
In-Reply-To: <20170302154541.16155-1-mhocko@kernel.org>
References: <20170302153002.GG3213@bfoster.bfoster>
 <20170302154541.16155-1-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Xiong Zhou <xzhou@redhat.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Michal Hocko <mhocko@suse.com>

From: Michal Hocko <mhocko@suse.com>

It doesn't really make much sense to retry vmalloc request if the
current task is killed. We should rather bail out as soon as possible
and let it RIP as soon as possible. The current implementation of
vmalloc will fail anyway.

Suggested-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 fs/xfs/kmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index ee95f5c6db45..01c52567a4ff 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -34,7 +34,7 @@ kmem_zalloc_greedy(size_t *size, size_t minsize, size_t maxsize)
 	size_t		kmsize = maxsize;
 
 	while (!(ptr = vzalloc(kmsize))) {
-		if (kmsize == minsize)
+		if (kmsize == minsize || fatal_signal_pending(current))
 			break;
 		if ((kmsize >>= 1) <= minsize)
 			kmsize = minsize;
-- 
2.11.0

