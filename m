Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB33C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Mar 2022 13:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347142AbiCHNxW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Mar 2022 08:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiCHNxU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Mar 2022 08:53:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7647B49925
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 05:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+zVXBTBdveZ/XJZGJpDyyxX/wAXvj7kPW9IYoxlllIE=; b=qE6OBq879u+Hihx5OixWMUwOME
        9/m8H90wn70eN0lCsyjlNQ52cbLkQuhGcp9gRKpeHerb5zAy/qrGFp19KMY2Mw1Q6j451yKy9VASf
        MKiXHo1EnIsZWvda6EV94SahjONdGwfYFgxISz0zneN/pARwTfVEm4P572pF9qDPqDIBYvtoiI0oW
        rkuq7dfuWjNCT4yf43FK2kPJOe/9MjLDbGgY4CeotCza+2XZc8AtMHDQzchiclg5o9ZkEb4kIvupg
        q5ul9w5byzivhk6Iry5BOMpyn4Y61Y/tfFpI4Uydve8UXkmHY2N5wBbMPPen0iT6MKmKzBJ4QdgoY
        JVjoNqag==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRaGE-00GDFG-DZ; Tue, 08 Mar 2022 13:52:22 +0000
Date:   Tue, 8 Mar 2022 13:52:22 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/3 v2] xfs: async CIL flushes need pending pushes to be
 made stable
Message-ID: <Yidflh4x+56HrSFn@casper.infradead.org>
References: <20220307053252.2534616-1-david@fromorbit.com>
 <20220307231857.GR59715@dread.disaster.area>
 <20220308061208.GB661808@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308061208.GB661808@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 08, 2022 at 05:12:08PM +1100, Dave Chinner wrote:
> The fix is two-fold - first we should always set the
> cil->xc_push_commit_stable when xlog_cil_flush() is called,
> regardless of whether there is already a pending push or not.
> 
> Second, if the CIL is empty, we should trigger an iclog flush to
> ensure that all the iclogs of the last checkpoint have actually been
> submitted to disk as that checkpoint may not have been run under
> stable completion constraints.
> 
> Reported-by: Matthew Wilcox <willy@infradead.org>
> Fixes: 0020a190cf3e ("xfs: AIL needs asynchronous CIL forcing")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
> Version 2:
> - if the CIL is empty we need to push on the iclogs to ensure that
>   the previous CIL flush did actually make it to stable storage.
>   This closes a race condition where the AIL doesn't actually
>   trigger the last CIL push and so the CIL is already empty by the
>   time it tries to flush it to unpin pinned items.
> 
> Note: this is against the XFS CIL scalability patchset. The
> XLOG_CIL_EMPTY check on a mainline kernel will be:
> 
> 	if (list_empty(&log->l_cilp->xc_cil))
> 		xfs_log_force(log->l_mp, 0);

This is it.  100 runs of g/530 all completed in 2 or 3 seconds.  Thanks!

Tested-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Just to be clear, my testing was done on b08968f196d4 (in Linus' tree),
plus my fs-folio patches, plus patches 1-3 from this series, plus this
(whitespace damaged):

+++ b/fs/xfs/xfs_log_cil.c
@@ -1243,18 +1243,27 @@ xlog_cil_push_now(
        if (!async)
                flush_workqueue(cil->xc_push_wq);

+       spin_lock(&cil->xc_push_lock);
+
+       /*
+        * If this is an async flush request, we always need to set the
+        * xc_push_commit_stable flag even if something else has already queued
+        * a push. The flush caller is asking for the CIL to be on stable
+        * storage when the next push completes, so regardless of who has queued
+        * the push, the flush requires stable semantics from it.
+        */
+       cil->xc_push_commit_stable = async;
+
        /*
         * If the CIL is empty or we've already pushed the sequence then
-        * there's no work we need to do.
+        * there's no more work that we need to do.
         */
-       spin_lock(&cil->xc_push_lock);
        if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
                spin_unlock(&cil->xc_push_lock);
                return;
        }

        cil->xc_push_seq = push_seq;
-       cil->xc_push_commit_stable = async;
        queue_work(cil->xc_push_wq, &cil->xc_ctx->push_work);
        spin_unlock(&cil->xc_push_lock);
 }
@@ -1352,6 +1361,8 @@ xlog_cil_flush(

        trace_xfs_log_force(log->l_mp, seq, _RET_IP_);
        xlog_cil_push_now(log, seq, true);
+        if (list_empty(&log->l_cilp->xc_cil))
+                xfs_log_force(log->l_mp, 0);
 }

 /*

