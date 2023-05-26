Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 644FFC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbjEZApq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjEZApo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:45:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23DB19C
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:45:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C05E616EF
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88804C433EF;
        Fri, 26 May 2023 00:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061935;
        bh=E1FwKvvLhrOVdLvMFEz4VpLAqJ6EfFeVKRkHC9EDiTE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=tvLOcgwifvEH/LNNvtwSpratJfL21pltSlyCb1n/5TdYCwrYzlWPITi5aUIJ/Z0Rp
         1nhSRQxXCkKhdhh6umRi1R/HO4FilpCvYwha8ac9dwdaEA7FEaUhcch1olFZH9mm60
         reiN8H4e2oitrHYsQJYkN6rUKdrzMdWc/fkLem23vsKfLklIMj53nzEXIiuffA/bY0
         X+Di0w1DJ1D4F8+dlq8hMNjlpcjxI3woN+0qwF1exOth115A4+w/NoOGUgQ+7TITQv
         7JBroafjqVFcGX8zz39s//tny9lI+5/LJujL5KJKb2EGPgXRuMVxDoerVF/ZwmF5of
         pNkd++DczE4BQ==
Date:   Thu, 25 May 2023 17:45:35 -0700
Subject: [PATCH 1/6] xfs: force all buffers to be written during btree bulk
 load
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506056076.3728458.7329874829310609452.stgit@frogsfrogsfrogs>
In-Reply-To: <168506056054.3728458.14583795170430652277.stgit@frogsfrogsfrogs>
References: <168506056054.3728458.14583795170430652277.stgit@frogsfrogsfrogs>
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

To fix this, create a new function that waits for the buffer to be
removed from any other delwri lists before adding the buffer to the
caller's delwri list.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree_staging.c |    4 +---
 fs/xfs/xfs_buf.c                  |   31 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf.h                  |    1 +
 3 files changed, 33 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index dd75e208b543..29e3f8ccb185 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
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
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b31e6d09a056..2a1a641c2b87 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2112,6 +2112,37 @@ xfs_buf_delwri_queue(
 	return true;
 }
 
+/*
+ * Queue a buffer to this delwri list as part of a data integrity operation.
+ * If the buffer is on any other delwri list, we'll wait for that to clear
+ * so that the caller can submit the buffer for IO and wait for the result.
+ * Callers must ensure the buffer is not already on the list.
+ */
+void
+xfs_buf_delwri_queue_here(
+	struct xfs_buf		*bp,
+	struct list_head	*buffer_list)
+{
+	/*
+	 * We need this buffer to end up on the /caller's/ delwri list, not any
+	 * old list.  This can happen if the buffer is marked stale (which
+	 * clears DELWRI_Q) after the AIL queues the buffer to its list but
+	 * before the AIL has a chance to submit the list.
+	 */
+	while (!list_empty(&bp->b_list)) {
+		xfs_buf_unlock(bp);
+		delay(1);
+		xfs_buf_lock(bp);
+	}
+
+	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
+
+	/* This buffer is uptodate; don't let it get reread. */
+	bp->b_flags |= XBF_DONE;
+
+	xfs_buf_delwri_queue(bp, buffer_list);
+}
+
 /*
  * Compare function is more complex than it needs to be because
  * the return value is only 32 bits and we are doing comparisons
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index d6e8c3bab9f6..467ddb2e2f0d 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -315,6 +315,7 @@ extern void xfs_buf_stale(struct xfs_buf *bp);
 /* Delayed Write Buffer Routines */
 extern void xfs_buf_delwri_cancel(struct list_head *);
 extern bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
+void xfs_buf_delwri_queue_here(struct xfs_buf *bp, struct list_head *bl);
 extern int xfs_buf_delwri_submit(struct list_head *);
 extern int xfs_buf_delwri_submit_nowait(struct list_head *);
 extern int xfs_buf_delwri_pushbuf(struct xfs_buf *, struct list_head *);

