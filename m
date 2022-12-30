Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB5E7C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbiLaAFO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235435AbiLaAFN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:05:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0961E3C3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:05:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AA1761CBF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BA9C433EF;
        Sat, 31 Dec 2022 00:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445112;
        bh=TL56CYLK4DvgDVfNqbMErVeO4A/fXq3uV/BKf9opWpM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CAAwvI+0/X0UpxVDpmnKG99ztdL3clrxYKj89exv9GPjM8zvMSd1wl+mEbSpBCmG+
         pbG5lSq2eljSn0DnSD/xCayo9yHLGugDSo++zsQcdiTr89hCmBLERTSFZDW0F0GifZ
         JLURjCwHPQX2OL3Hrs0NlIGDUQIUeV60VzKu6m3nDRxQsRILmuwbpw84kFFTllUaX0
         lBH/ke8s+zyIlReFeXOVigKsScmo49z6cX9u3Sy64kKLdCPMMZSDRQY60Yg+9eyOJm
         sfK7iJRyVlRm+11b6SrCwjShNc7nrtB7RxBpgd4hKf4Zz1u9efsb/Jkdw6UNwnHXEb
         s7obxIUb6t/7w==
Subject: [PATCH 1/5] xfs: force all buffers to be written during btree bulk
 load
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:19 -0800
Message-ID: <167243863918.707598.10220298459269094461.stgit@magnolia>
In-Reply-To: <167243863904.707598.12385476439101029022.stgit@magnolia>
References: <167243863904.707598.12385476439101029022.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While stress-testing online repair of btrees, I noticed periodic
assertion failures from the buffer cache about buffer readers
encountering buffers with DELWRI_Q set, even though the btree bulk load
had already committed and the buffer itself wasn't on any delwri list.

I traced this to a misunderstanding of how the delwri lists work,
particularly with regards to the AIL's buffer list.  If a buffer is
logged and committed, the buffer can end up on that AIL buffer list.  If
btree repairs are run twice in rapid succession, it's possible that the
first repair will invalidate the buffer and free it before the next time
the AIL wakes up.  This clears DELWRI_Q from the buffer state.

If the second repair allocates the same block, it will then recycle the
buffer to start writing the new btree block.  Meanwhile, if the AIL
wakes up and walks the buffer list, it will ignore the buffer because it
can't lock it, and go back to sleep.

When the second repair calls delwri_queue to put the buffer on the
list of buffers to write before committing the new btree, it will set
DELWRI_Q again, but since the buffer hasn't been removed from the AIL's
buffer list, it won't add it to the bulkload buffer's list.

This is incorrect, because the bulkload caller relies on delwri_submit
to ensure that all the buffers have been sent to disk /before/
committing the new btree root pointer.  This ordering requirement is
required for data consistency.

Worse, the AIL won't clear DELWRI_Q from the buffer when it does finally
drop it, so the next thread to walk through the btree will trip over a
debug assertion on that flag.

To fix this, create a new thread that waits for the buffer to be removed
from any other delwri lists before adding the buffer to the caller's
delwri list.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_io.h         |   11 +++++++++++
 libxfs/xfs_btree_staging.c |    4 +---
 2 files changed, 12 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index fae86427201..4ffe788d446 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -243,6 +243,17 @@ xfs_buf_delwri_queue(struct xfs_buf *bp, struct list_head *buffer_list)
 	return true;
 }
 
+static inline void
+xfs_buf_delwri_queue_here(struct xfs_buf *bp, struct list_head *buffer_list)
+{
+	ASSERT(list_empty(&bp->b_list));
+
+	/* This buffer is uptodate; don't let it get reread. */
+	libxfs_buf_mark_dirty(bp);
+
+	xfs_buf_delwri_queue(bp, buffer_list);
+}
+
 int xfs_buf_delwri_submit(struct list_head *buffer_list);
 void xfs_buf_delwri_cancel(struct list_head *list);
 
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index a6a90791668..baf7f422603 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -342,9 +342,7 @@ xfs_btree_bload_drop_buf(
 	if (*bpp == NULL)
 		return;
 
-	if (!xfs_buf_delwri_queue(*bpp, buffers_list))
-		ASSERT(0);
-
+	xfs_buf_delwri_queue_here(*bpp, buffers_list);
 	xfs_buf_relse(*bpp);
 	*bpp = NULL;
 }

