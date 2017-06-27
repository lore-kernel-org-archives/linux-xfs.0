Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33258 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751827AbdF0Oki (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jun 2017 10:40:38 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2DDFD7C838
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2017 14:40:38 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FE5A84430
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2017 14:40:38 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/4] xfs: always verify the log tail during recovery
Date: Tue, 27 Jun 2017 10:40:34 -0400
Message-Id: <1498574436-57561-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1498574436-57561-1-git-send-email-bfoster@redhat.com>
References: <1498574436-57561-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Log tail verification currently only occurs when torn writes are
detected at the head of the log. This was introduced because a
change in the head block due to torn writes can lead to a change in
the tail block (each log record header references the current tail)
and the tail block should be verified before log recovery proceeds.

Tail corruption is possible outside of torn write scenarios,
however. For example, partial log writes can be detected and cleared
during the initial head/tail block discovery process. If the partial
write coincides with a tail overwrite, the log tail is corrupted and
recovery fails.

To facilitate correct handling of log tail overwites, update log
recovery to always perform tail verification. This is necessary to
detect potential tail overwrite conditions when torn writes may not
have occurred. This changes normal (i.e., no torn writes) recovery
behavior slightly to detect and return CRC related errors near the
tail before actual recovery starts.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9efcd12..269d5f9 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1183,31 +1183,9 @@ xlog_verify_head(
 			ASSERT(0);
 			return 0;
 		}
-
-		/*
-		 * Now verify the tail based on the updated head. This is
-		 * required because the torn writes trimmed from the head could
-		 * have been written over the tail of a previous record. Return
-		 * any errors since recovery cannot proceed if the tail is
-		 * corrupt.
-		 *
-		 * XXX: This leaves a gap in truly robust protection from torn
-		 * writes in the log. If the head is behind the tail, the tail
-		 * pushes forward to create some space and then a crash occurs
-		 * causing the writes into the previous record's tail region to
-		 * tear, log recovery isn't able to recover.
-		 *
-		 * How likely is this to occur? If possible, can we do something
-		 * more intelligent here? Is it safe to push the tail forward if
-		 * we can determine that the tail is within the range of the
-		 * torn write (e.g., the kernel can only overwrite the tail if
-		 * it has actually been pushed forward)? Alternatively, could we
-		 * somehow prevent this condition at runtime?
-		 */
-		error = xlog_verify_tail(log, *head_blk, *tail_blk);
 	}
 
-	return error;
+	return xlog_verify_tail(log, *head_blk, *tail_blk);
 }
 
 /*
-- 
2.7.5

