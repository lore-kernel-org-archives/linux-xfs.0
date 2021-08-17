Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FEDC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:43:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC4296102A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhHQXoC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:44:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236443AbhHQXn5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:43:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E585A604AC;
        Tue, 17 Aug 2021 23:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629243804;
        bh=OOhKPkTtVYTidv9rTwWJX7bGbJ0FuDdbuaQthW5T9To=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kotfSakL6aadPVnEgVjCvs90MEzJtqGaCJE4eLL+YEKkd7lFn868GPCchnUro3Hkh
         tYnGmPY1/NuWEd+A0BeTwvm4GzbxyArsdhUci1XTI/Dihk7opMT/3B6ZDDxpgbg0Au
         8ButZUcGBE2qZ/fhyaHyuUUwUKgKnD2ibPsVVjbnXTprekKJkn/XhxWio7PO/C7MWp
         89VsLDPQUyMdZWMMlqSo+R5ZYdmr2sPClbfCID3hHTCpkEUkds4pQnnuXU1FM1rYX5
         JKdU5lzT9GaemyBc5M79dsC0V+ZylXTEE6BBTW3y7fGd1cvEHq72doumpTwY7NyOZR
         PrHOFczMpV6gQ==
Subject: [PATCH 13/15] xfs: standardize remaining xfs_buf length tracepoints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 17 Aug 2021 16:43:23 -0700
Message-ID: <162924380364.761813.15066686718183338281.stgit@magnolia>
In-Reply-To: <162924373176.761813.10896002154570305865.stgit@magnolia>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For the remaining xfs_buf tracepoints, convert all the tags to
xfs_daddr_t units and retag them 'daddrcount' to match everything else.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trace.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 474fdaffdccf..3b53fd681ce7 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -397,7 +397,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__entry->flags = bp->b_flags;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d daddr 0x%llx nblks 0x%x hold %d pincount %d "
+	TP_printk("dev %d:%d daddr 0x%llx daddrcount 0x%x hold %d pincount %d "
 		  "lock %d flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
@@ -448,7 +448,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_daddr_t, bno)
-		__field(size_t, buffer_length)
+		__field(unsigned int, length)
 		__field(int, hold)
 		__field(int, pincount)
 		__field(unsigned, lockval)
@@ -458,18 +458,18 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 	TP_fast_assign(
 		__entry->dev = bp->b_target->bt_dev;
 		__entry->bno = bp->b_bn;
-		__entry->buffer_length = BBTOB(bp->b_length);
+		__entry->length = bp->b_length;
 		__entry->flags = flags;
 		__entry->hold = atomic_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d daddr 0x%llx len 0x%zx hold %d pincount %d "
+	TP_printk("dev %d:%d daddr 0x%llx daddrcount 0x%x hold %d pincount %d "
 		  "lock %d flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
-		  __entry->buffer_length,
+		  __entry->length,
 		  __entry->hold,
 		  __entry->pincount,
 		  __entry->lockval,
@@ -491,7 +491,7 @@ TRACE_EVENT(xfs_buf_ioerror,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_daddr_t, bno)
-		__field(size_t, buffer_length)
+		__field(unsigned int, length)
 		__field(unsigned, flags)
 		__field(int, hold)
 		__field(int, pincount)
@@ -502,7 +502,7 @@ TRACE_EVENT(xfs_buf_ioerror,
 	TP_fast_assign(
 		__entry->dev = bp->b_target->bt_dev;
 		__entry->bno = bp->b_bn;
-		__entry->buffer_length = BBTOB(bp->b_length);
+		__entry->length = bp->b_length;
 		__entry->hold = atomic_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
@@ -510,11 +510,11 @@ TRACE_EVENT(xfs_buf_ioerror,
 		__entry->flags = bp->b_flags;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d daddr 0x%llx len 0x%zx hold %d pincount %d "
+	TP_printk("dev %d:%d daddr 0x%llx daddrcount 0x%x hold %d pincount %d "
 		  "lock %d error %d flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
-		  __entry->buffer_length,
+		  __entry->length,
 		  __entry->hold,
 		  __entry->pincount,
 		  __entry->lockval,
@@ -529,7 +529,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_daddr_t, buf_bno)
-		__field(size_t, buf_len)
+		__field(unsigned int, buf_len)
 		__field(int, buf_hold)
 		__field(int, buf_pincount)
 		__field(int, buf_lockval)
@@ -545,14 +545,14 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 		__entry->bli_recur = bip->bli_recur;
 		__entry->bli_refcount = atomic_read(&bip->bli_refcount);
 		__entry->buf_bno = bip->bli_buf->b_bn;
-		__entry->buf_len = BBTOB(bip->bli_buf->b_length);
+		__entry->buf_len = bip->bli_buf->b_length;
 		__entry->buf_flags = bip->bli_buf->b_flags;
 		__entry->buf_hold = atomic_read(&bip->bli_buf->b_hold);
 		__entry->buf_pincount = atomic_read(&bip->bli_buf->b_pin_count);
 		__entry->buf_lockval = bip->bli_buf->b_sema.count;
 		__entry->li_flags = bip->bli_item.li_flags;
 	),
-	TP_printk("dev %d:%d daddr 0x%llx len 0x%zx hold %d pincount %d "
+	TP_printk("dev %d:%d daddr 0x%llx daddrcount 0x%x hold %d pincount %d "
 		  "lock %d flags %s recur %d refcount %d bliflags %s "
 		  "liflags %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),

