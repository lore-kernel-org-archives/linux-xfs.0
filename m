Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E50C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 01:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbiGHB4F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 21:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiGHB4E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 21:56:04 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7918A735A9
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 18:56:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9C80B62C48C
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 11:56:02 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9dDs-00FqlV-HH
        for linux-xfs@vger.kernel.org; Fri, 08 Jul 2022 11:56:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o9dDs-004lDq-GW
        for linux-xfs@vger.kernel.org;
        Fri, 08 Jul 2022 11:56:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] xfs: track log space pinned by the AIL
Date:   Fri,  8 Jul 2022 11:55:55 +1000
Message-Id: <20220708015558.1134330-6-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708015558.1134330-1-david@fromorbit.com>
References: <20220708015558.1134330-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62c78eb2
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=RgO8CyIxsXoA:10 a=20KFwNOVAAAA:8 a=_hL5OsT9ypi7W2MD6eUA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Currently we track space used in the log by grant heads.
These store the reserved space as a physical log location and
combine both space reserved for future use with space already used in
the log in a single variable. The amount of space consumed in the
log is then calculated as the  distance between the log tail and
the grant head.

The problem with tracking the grant head as a physical location
comes from the fact that it tracks both log cycle count and offset
into the log in bytes in a single 64 bit variable. because the cycle
count on disk is a 32 bit number, this also limits the offset into
the log to 32 bits. ANd because that is in bytes, we are limited to
being able to track only 2GB of log space in the grant head.

Hence to support larger physical logs, we need to track used space
differently in the grant head. We no longer use the grant head for
guiding AIL pushing, so the only thing it is now used for is
determining if we've run out of reservation space via the
calculation in xlog_space_left().

What we really need to do is move the grant heads away from tracking
physical space in the log. The issue here is that space consumed in
the log is not directly tracked by the current mechanism - the
space consumed in the log by grant head reservations gets returned
to the free pool by the tail of the log moving forward. i.e. the
space isn't directly tracked or calculated, but the used grant space
gets "freed" as the physical limits of the log are updated without
actually needing to update the grant heads.

Hence to move away from implicit, zero-update log space tracking we
need to explicitly track the amount of physical space the log
actually consumes separately to the in-memory reservations for
operations that will be committed to the journal. Luckily, we
already track the information we need to calculate this in the AIL
itself.

That is, the space currently consumed by the journal is the maximum
LSN that the AIL has seen minus the current log tail. As we update
both of these items dynamically as the head and tail of the log
moves, we always know exactly how much space the journal consumes.

This means that we also know exactly how much space the currently
active reservations require, and exactly how much free space we have
remaining for new reservations to be made. Most importantly, we know
what these spaces are indepedently of the physical locations of
the head and tail of the log.

Hence by separating out the physical space consumed by the journal,
we can now track reservations in the grant heads purely as a byte
count, and the log can be considered full when the tail space +
reservation space exceeds the size of the log. This means we can use
the full 64 bits of grant head space for reservation space,
completely removing the 32 bit byte count limitation on log size
that they impose.

Hence the first step in this conversion is to track and update the
"log tail space" every time the AIL tail or maximum seen LSN
changes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_priv.h    | 1 +
 fs/xfs/xfs_log_recover.c | 2 ++
 fs/xfs/xfs_trans_ail.c   | 8 ++++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 5f4358f18224..8a005cb08a02 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -435,6 +435,7 @@ struct xlog {
 
 	struct xlog_grant_head	l_reserve_head;
 	struct xlog_grant_head	l_write_head;
+	uint64_t		l_tail_space;
 
 	struct xfs_kobj		l_kobj;
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b8e25da876d8..ba2d591a1437 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1213,6 +1213,8 @@ xlog_set_state(
 		log->l_curr_cycle++;
 	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
 	log->l_ailp->ail_max_seen_lsn = be64_to_cpu(rhead->h_lsn);
+	WRITE_ONCE(log->l_tail_space, atomic64_read(&log->l_tail_lsn) -
+						log->l_ailp->ail_max_seen_lsn);
 	xlog_assign_grant_head(&log->l_reserve_head.grant, log->l_curr_cycle,
 					BBTOB(log->l_curr_block));
 	xlog_assign_grant_head(&log->l_write_head.grant, log->l_curr_cycle,
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index f0741c42130a..fd4aa9c4e914 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -728,6 +728,8 @@ xfs_ail_update_tail_lsn(
 	if (!tail_lsn)
 		tail_lsn = ailp->ail_max_seen_lsn;
 
+	WRITE_ONCE(log->l_tail_space,
+			xlog_lsn_sub(log, ailp->ail_max_seen_lsn, tail_lsn));
 	trace_xfs_log_assign_tail_lsn(log, tail_lsn);
 	atomic64_set(&log->l_tail_lsn, tail_lsn);
 }
@@ -735,7 +737,7 @@ xfs_ail_update_tail_lsn(
 /*
  * Callers should pass the the original tail lsn so that we can detect if the
  * tail has moved as a result of the operation that was performed. If the caller
- * needs to force a tail LSN update, it should pass NULLCOMMITLSN to bypass the
+ * needs to force a tail space update, it should pass NULLCOMMITLSN to bypass the
  * "did the tail LSN change?" checks.
  */
 void
@@ -822,8 +824,10 @@ xfs_trans_ail_update_bulk(
 	 * If this is the highest LSN we've seen in the AIL, update the tracking
 	 * so that we know what to set the tail to when the AIL is next emptied.
 	 */
-	if (XFS_LSN_CMP(lsn, ailp->ail_max_seen_lsn) > 0)
+	if (XFS_LSN_CMP(lsn, ailp->ail_max_seen_lsn) > 0) {
 		ailp->ail_max_seen_lsn = lsn;
+		tail_lsn = NULLCOMMITLSN;
+	}
 
 	/*
 	 * If this is the first insert, wake up the push daemon so it can
-- 
2.36.1

