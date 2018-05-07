Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:38434 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750934AbeEGQNo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 12:13:44 -0400
Received: by mail-it0-f66.google.com with SMTP id q4-v6so12494506ite.3
        for <linux-xfs@vger.kernel.org>; Mon, 07 May 2018 09:13:44 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] blk-wbt: account any writing command as a write
Date: Mon,  7 May 2018 10:13:33 -0600
Message-Id: <1525709615-14395-3-git-send-email-axboe@kernel.dk>
In-Reply-To: <1525709615-14395-1-git-send-email-axboe@kernel.dk>
References: <1525709615-14395-1-git-send-email-axboe@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: dchinner@redhat.com, hch@lst.de, Jens Axboe <axboe@kernel.dk>

We currently special case WRITE and FLUSH, but we should really
just include any command with the write bit set. This ensures
that we account DISCARD.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-wbt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index f92fc84b5e2c..3e34b41bcefc 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -701,7 +701,7 @@ static int wbt_data_dir(const struct request *rq)
 
 	if (op == REQ_OP_READ)
 		return READ;
-	else if (op == REQ_OP_WRITE || op == REQ_OP_FLUSH)
+	else if (op_is_write(op))
 		return WRITE;
 
 	/* don't account */
-- 
2.7.4

