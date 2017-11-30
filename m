Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38196 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750891AbdK3S6h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Nov 2017 13:58:37 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 72EA0883C5
        for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2017 18:58:37 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 588E95C269
        for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2017 18:58:37 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 1/7] xfs: print transaction log reservation on overrun
Date: Thu, 30 Nov 2017 13:58:30 -0500
Message-Id: <20171130185836.18481-2-bfoster@redhat.com>
In-Reply-To: <20171130185836.18481-1-bfoster@redhat.com>
References: <20171130185836.18481-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The transaction dump code displays the content and reservation
consumption of a particular transaction in the event of an overrun.
It currently displays the reservation associated with the
transaction ticket, but not the original reservation attached to the
transaction.

The latter value reflects the original transaction reservation
calculation before additional reservation overhead is assigned, such
as for the CIL context header and potential split region headers.

Update xlog_print_trans() to also print the original transaction
reservation in the event of overrun. This provides a reference point
to identify how much reservation overhead was added to a particular
ticket by xfs_log_calc_unit_res().

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 38d4227895ae..3a37fa1ed25e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2117,7 +2117,9 @@ xlog_print_trans(
 
 	/* dump core transaction and ticket info */
 	xfs_warn(mp, "transaction summary:");
-	xfs_warn(mp, "  flags	= 0x%x", tp->t_flags);
+	xfs_warn(mp, "  log res   = %d", tp->t_log_res);
+	xfs_warn(mp, "  log count = %d", tp->t_log_count);
+	xfs_warn(mp, "  flags     = 0x%x", tp->t_flags);
 
 	xlog_print_tic_res(mp, tp->t_ticket);
 
-- 
2.13.6

