Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C04C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 12:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 984D6613E9
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 12:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhELMYS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 08:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbhELMYR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 08:24:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF405C061574
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 05:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LYUeXs40wGCt0fvfIgNaXvEQFNA20kavyCcReLm/v84=; b=Kuzz7WmKvuN6FreQHFEgAC5p22
        vrg8zjRnZTF+3WUJVAv1lFHF8UTvkxWYs7ZAyMRsKRa75SQd7jZgVb4ohZD/ONIz+0aJwdwjEwp3a
        9xSccc/LDLl8u7wAc6l+fKM9DnFyQ5GkwHq5qh4lJ3iuOfxNHBgZhQl3kAiyG/CtgLmZBX19PgOpz
        jFcxKIYmEyUfkN6iQCvX74bqodF/I3O3qLwr66WN7cjhN+wzjwB54PJnZ24eDiPpxpLUWCgQTYyDc
        plXiWBzn0DQEkEBeBeI0Dh5W5/dZIZlXkVuk2+tYaUNmw0rb0aQJDxeVsd/ngk2ysbbPDVEJLHqvm
        cpTueTLQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lgnt3-008Fs0-4f; Wed, 12 May 2021 12:22:54 +0000
Date:   Wed, 12 May 2021 13:22:49 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: hold buffer across unpin and potential shutdown
 processing
Message-ID: <YJvImeri0qEQtPJ1@infradead.org>
References: <20210511135257.878743-1-bfoster@redhat.com>
 <20210511135257.878743-2-bfoster@redhat.com>
 <20210512015244.GW8582@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512015244.GW8582@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 11, 2021 at 06:52:44PM -0700, Darrick J. Wong wrote:
> > is unpinned if the associated item has been aborted and will require
> > a simulated I/O failure. The hold is already required for the
> > simulated I/O failure, so the ordering simply guarantees the unpin
> > handler access to the buffer before it is unpinned and thus
> > processed by the AIL. This particular ordering is required so long
> > as the AIL does not acquire a reference on the bli, which is the
> > long term solution to this problem.
> 
> Are you working on that too, or are we just going to let that lie for
> the time being? :)

Wouldn't that be as simple as something like the untested patch below?


diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index fb69879e4b2b..07e08713ecd4 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -471,6 +471,7 @@ xfs_buf_item_pin(
 	trace_xfs_buf_item_pin(bip);
 
 	atomic_inc(&bip->bli_refcount);
+	xfs_buf_hold(bip->bli_buf);
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
@@ -552,14 +553,15 @@ xfs_buf_item_unpin(
 		xfs_buf_relse(bp);
 	} else if (freed && remove) {
 		/*
-		 * The buffer must be locked and held by the caller to simulate
-		 * an async I/O failure.
+		 * The buffer must be locked to simulate an async I/O failure.
+		 * xfs_buf_ioend_fail will drop our buffer reference.
 		 */
 		xfs_buf_lock(bp);
-		xfs_buf_hold(bp);
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioend_fail(bp);
+		return;
 	}
+	xfs_buf_rele(bp);
 }
 
 STATIC uint
