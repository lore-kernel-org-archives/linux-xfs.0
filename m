Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195D0C77B75
	for <linux-xfs@archiver.kernel.org>; Mon,  8 May 2023 03:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbjEHDeN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 May 2023 23:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjEHDeM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 May 2023 23:34:12 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3E540FC
        for <linux-xfs@vger.kernel.org>; Sun,  7 May 2023 20:34:10 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-24df4ecdb87so2728905a91.0
        for <linux-xfs@vger.kernel.org>; Sun, 07 May 2023 20:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683516850; x=1686108850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lEevFyokrOmwhuR/0Qt9SCNOvhEPzXryeVji0zrEePs=;
        b=WUePBZSDysWMJLbmsNZgWdEUV2j6PtgBon56Fye3i4NRRj+TDRvskfZE5tyM33CPlt
         iCwZy7u1C+7WHbU8dcae4Pxv0qsX2rv4+lHcP7ipGKbeJdYCrEXnu5Kzuf1FSFaCrSTk
         rtmuULYbvWVRl3D4KY4pGvbO4BTRMXCFAZJ8px0j7ssiomIM2CzIkhl3Gyl/uxETbH7R
         aQ2rSfrgRq5GLpPbdYVy/hLX5xGWihxHH1unf1befN6JmEmIvpJ5z/bGWC8V8Jg8qKRq
         SFZI6ASQfQxn4Hetu17leVDgDDsTDTCrozLSM2xwxS26OliODoeLCE2CFWV7Qm5xb04e
         A24g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683516850; x=1686108850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lEevFyokrOmwhuR/0Qt9SCNOvhEPzXryeVji0zrEePs=;
        b=Hm2KHDqXnJgmP9ckFihR/JzSMaDv+sFpd0zVtkd0+T5SoBHLOGOZEunRByjUw25hnu
         TECU4+N4AtkCiqSM9bwTxQ5IPLUzEounMgRYRXjEXx8JfrlW8EwiBF0cIRn7vX8qj/yT
         St9HMOzP4DNPh3lutfZ5w0NMpRBfeNECna+SREg96T8g3DVqYuB60s+llJS4vfly843J
         DWslY8yDeSqxmt+We7T0jBxueSzj/Q3oivVaDkKa2zdguoSW39tXjEvCRi2WbDX/J4Gn
         8akyXPXMiGy8DozUUwOovdoBICib3MGxvu0Avp2NM1It4mKDj74AGiYWipHipXMF6OPY
         hw3Q==
X-Gm-Message-State: AC+VfDxwIa74N22rp95r/87oPp7I+8hjABpgKAO/NsFBw9J8eZEumuAX
        lS4PCxTS7sYqZsZwALoRnRGxgEVa2whzlHRd1/M=
X-Google-Smtp-Source: ACHHUZ6X9fiKbuAuzW7ys8MteIfFvaG9UDJDtftbwlsEgU13Cl5CoHUn21d52/sp86UeduufwaKn0w==
X-Received: by 2002:a17:90a:b401:b0:23b:2c51:6e7 with SMTP id f1-20020a17090ab40100b0023b2c5106e7mr9428553pjr.21.1683516850142;
        Sun, 07 May 2023 20:34:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id f2-20020a17090a8e8200b0025043a8185dsm3484960pjo.23.2023.05.07.20.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 20:34:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pvrdW-00CgCt-H4; Mon, 08 May 2023 13:34:06 +1000
Date:   Mon, 8 May 2023 13:34:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     yangerkun <yangerkun@huaweicloud.com>
Cc:     djwong@kernel.org, bfoster@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix xfs_buf use-after-free in xfs_buf_item_unpin
Message-ID: <20230508033406.GQ3223426@dread.disaster.area>
References: <20230420033550.339934-1-yangerkun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420033550.339934-1-yangerkun@huaweicloud.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi yangerkun,

Sorry to take so long to get to this, I've been busy with other
stuff and I needed to do some thinking on it first.

On Thu, Apr 20, 2023 at 11:35:50AM +0800, yangerkun wrote:
> From: yangerkun <yangerkun@huawei.com>
> 
> commit 84d8949e7707 ("xfs: hold buffer across unpin and potential
> shutdown processing") describle a use-after-free bug show as follow.
> Call xfs_buf_hold before dec b_pin_count can forbid the problem.
> 
>    +-----------------------------+--------------------------------+
>      xlog_ioend_work             | xfsaild
>      ...                         |  xfs_buf_delwri_submit_buffers
>       xfs_buf_item_unpin         |
>        dec &bip->bli_refcount    |
>        dec &bp->b_pin_count      |
>                                  |  // check unpin and go on
>                                  |  __xfs_buf_submit
>                                  |  xfs_buf_ioend_fail // shutdown
>                                  |  xfs_buf_ioend
>                                  |  xfs_buf_relse
>                                  |  xfs_buf_free(bp)
>        xfs_buf_lock(bp) // UAF   |
> 
> However with the patch, we still get a UAF with shutdown:
> 
>    +-----------------------------+--------------------------------+
>      xlog_ioend_work             |  xlog_cil_push_work // now shutdown
>      ...                         |   xlog_cil_committed
>       xfs_buf_item_unpin         |    ...
>       // bli_refcount = 2        |
>       dec bli_refcount // 1      |    xfs_buf_item_unpin
>                                  |    dec bli_refcount // 0,will free
>                                  |    xfs_buf_ioend_fail // free bp
>       dec b_pin_count // UAF     |

Ok, so the race condition here is that we have two callers racing to
run xlog_cil_committed(). We have xlog_ioend_work() doing the
shutdown callbacks for checkpoint contexts that have been aborted
after submission, and xlog_cil_push_work aborting a checkpoint
context before it has been submitted.

> xlog_cil_push_work will call xlog_cil_committed once we meet some error
> like shutdown, and then call xfs_buf_item_unpin with 'remove' equals 1.
> xlog_ioend_work can happened same time which trigger xfs_buf_item_unpin
> too, and then bli_refcount will down to zero which trigger
> xfs_buf_ioend_fail that free the xfs_buf, so the UAF can trigger.
> 
> Fix it by call xfs_buf_hold before dec bli_refcount, and release the
> hold once we actually do not need it.

Ok, that works.

However, adding an unconditional buffer reference to each unpin call
so that we can safely reference the buffer after we're released the
BLI indicates that the BLI buffer reference is not guaranteeing
buffer existence once the bli reference for the current pin the bli
holds.

Which means that we need a buffer reference per pin count that is
added. We can then hold that buffer reference in the unpin
processing until we don't need it anymore, and we cover all the
known cases (and any unknown cases) without needing special case
code?

Say, something like the (untested) patch I've attached below?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: buffer pins need to hold a buffer reference

From: Dave Chinner <dchinner@redhat.com>

When a buffer is unpinned by xfs_buf_item_unpin(), we need to access
the buffer after we've dropped the buffer log item reference count.
This opens a window where we can have two racing unpins for the
buffer item (e.g. shutdown checkpoint context callback processing
racing with journal IO iclog completion processing) and both attempt
to access the buffer after dropping the BLI reference count.  If we
are unlucky, the "BLI freed" context wins the race and frees the
buffer before the "BLI still active" case checks the buffer pin
count.

This results in a use after free that can only be triggered
in active filesystem shutdown situations.

To fix this, we need to ensure that buffer existence extends beyond
the BLI reference count checks and until the unpin processing is
complete. This implies that a buffer pin operation must also take a
buffer reference to ensure that the buffer cannot be freed until the
buffer unpin processing is complete.

Reported-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 88 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 65 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index df7322ed73fa..b2d211730fd2 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -452,10 +452,18 @@ xfs_buf_item_format(
  * This is called to pin the buffer associated with the buf log item in memory
  * so it cannot be written out.
  *
- * We also always take a reference to the buffer log item here so that the bli
- * is held while the item is pinned in memory. This means that we can
- * unconditionally drop the reference count a transaction holds when the
- * transaction is completed.
+ * We take a reference to the buffer log item here so that the BLI life cycle
+ * extends at least until the buffer is unpinned via xfs_buf_item_unpin() and
+ * inserted into the AIL.
+ *
+ * We also need to take a reference to the buffer itself as the BLI unpin
+ * processing requires accessing the buffer after the BLI has dropped the final
+ * BLI reference. See xfs_buf_item_unpin() for an explanation.
+ * If unpins race to drop the final BLI reference and only the
+ * BLI owns a reference to the buffer, then the loser of the race can have the
+ * buffer fgreed from under it (e.g. on shutdown). Taking a buffer reference per
+ * pin count ensures the life cycle of the buffer extends for as
+ * long as we hold the buffer pin reference in xfs_buf_item_unpin().
  */
 STATIC void
 xfs_buf_item_pin(
@@ -470,13 +478,30 @@ xfs_buf_item_pin(
 
 	trace_xfs_buf_item_pin(bip);
 
+	xfs_buf_hold(bip->bli_buf);
 	atomic_inc(&bip->bli_refcount);
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
 /*
- * This is called to unpin the buffer associated with the buf log item which
- * was previously pinned with a call to xfs_buf_item_pin().
+ * This is called to unpin the buffer associated with the buf log item which was
+ * previously pinned with a call to xfs_buf_item_pin().  We enter this function
+ * with a buffer pin count, a buffer reference and a BLI reference.
+ *
+ * We must drop the BLI reference before we unpin the buffer because the AIL
+ * doesn't acquire a BLI reference whenever it accesses it. Therefore if the
+ * refcount drops to zero, the bli could still be AIL resident and the buffer
+ * submitted for I/O at any point before we return. This can result in IO
+ * completion freeing the buffer while we are still trying to access it here.
+ * This race condition can also occur in shutdown situations where we abort and
+ * unpin buffers from contexts other that journal IO completion.
+ *
+ * Hence we have to hold a buffer reference per pin count to ensure that the
+ * buffer cannot be freed until we have finished processing the unpin operation.
+ * The reference is taken in xfs_buf_item_pin(), and we must hold it until we
+ * are done processing the buffer state. In the case of an abort (remove =
+ * true) then we re-use the current pin reference as the IO reference we hand
+ * off to IO failure handling.
  */
 STATIC void
 xfs_buf_item_unpin(
@@ -493,24 +518,18 @@ xfs_buf_item_unpin(
 
 	trace_xfs_buf_item_unpin(bip);
 
-	/*
-	 * Drop the bli ref associated with the pin and grab the hold required
-	 * for the I/O simulation failure in the abort case. We have to do this
-	 * before the pin count drops because the AIL doesn't acquire a bli
-	 * reference. Therefore if the refcount drops to zero, the bli could
-	 * still be AIL resident and the buffer submitted for I/O (and freed on
-	 * completion) at any point before we return. This can be removed once
-	 * the AIL properly holds a reference on the bli.
-	 */
 	freed = atomic_dec_and_test(&bip->bli_refcount);
-	if (freed && !stale && remove)
-		xfs_buf_hold(bp);
 	if (atomic_dec_and_test(&bp->b_pin_count))
 		wake_up_all(&bp->b_waiters);
 
-	 /* nothing to do but drop the pin count if the bli is active */
-	if (!freed)
+	 /*
+	  * Nothing to do but drop the buffer pin reference if the BLI is
+	  * still active
+	  */
+	if (!freed) {
+		xfs_buf_rele(bp);
 		return;
+	}
 
 	if (stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
@@ -522,6 +541,15 @@ xfs_buf_item_unpin(
 
 		trace_xfs_buf_item_unpin_stale(bip);
 
+		/*
+		 * The buffer has been locked and referenced since it was marked
+		 * stale so we own both lock and reference exclusively here. We
+		 * do not need the pin reference any more, so drop it now so
+		 * that we only have one reference to drop once item completion
+		 * processing is complete.
+		 */
+		xfs_buf_rele(bp);
+
 		/*
 		 * If we get called here because of an IO error, we may or may
 		 * not have the item on the AIL. xfs_trans_ail_delete() will
@@ -538,16 +566,30 @@ xfs_buf_item_unpin(
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
-	} else if (remove) {
+		return;
+	}
+
+	if (remove) {
 		/*
-		 * The buffer must be locked and held by the caller to simulate
-		 * an async I/O failure. We acquired the hold for this case
-		 * before the buffer was unpinned.
+		 * We need to simulate an async IO failures here to ensure that
+		 * the correct error completion is run on this buffer. This
+		 * requires a reference to the buffer and for the buffer to be
+		 * locked. We can safely pass ownership of the pin reference to
+		 * the IO to ensure that nothing can free the buffer while we
+		 * wait for the lock and then run the IO failure completion.
 		 */
 		xfs_buf_lock(bp);
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioend_fail(bp);
+		return;
 	}
+
+	/*
+	 * BLI has no more active references - it will be moved to the AIL to
+	 * manage the remaining BLI/buffer life cycle. There is nothing left for
+	 * us to do here so drop the pin reference to the buffer.
+	 */
+	xfs_buf_rele(bp);
 }
 
 STATIC uint
