Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754146AbdGJN2B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jul 2017 09:28:01 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 79713C04B31B
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2017 13:28:01 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54804785E0
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2017 13:28:01 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 2/6] xfs: always verify the log tail during recovery
Date: Mon, 10 Jul 2017 09:27:56 -0400
Message-Id: <20170710132800.19506-3-bfoster@redhat.com>
In-Reply-To: <20170710132800.19506-1-bfoster@redhat.com>
References: <20170710132800.19506-1-bfoster@redhat.com>
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
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a388a84..72c12b1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1183,31 +1183,11 @@ xlog_verify_head(
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
+	if (error)
+		return error;
 
-	return error;
+	return xlog_verify_tail(log, *head_blk, *tail_blk);
 }
 
 /*
-- 
2.9.4

