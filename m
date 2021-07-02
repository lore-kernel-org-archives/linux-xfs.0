Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6147C11F68
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 09:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA65261416
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 09:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhGBJVH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 05:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbhGBJVH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 05:21:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83024C061762
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jul 2021 02:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AQ/n55taTn8nQwCpJcxALrqYjBxc2AC+Dsg6en/wXaI=; b=DW9Pmq1aPW4+QbLXgkRu9jDKlr
        MlFgSx9ahdE9ySFyrnZu2P5hEjizWjban0AZ7+D6OCaFrQV9WO8eSUYQb1B1MOCfJ/gteVLZFPSin
        DfaMV/PlpHj7XPG/xfyeOuSqSeHvo+qQhOS+g1YuWo7Gz60kAj40LMPXxCezSJN4sXWfFLNO6Urbh
        ExX/8BP1A1N8KrQgqAr6dz6I+2WkHGiExAfiNv76AalTZZ8gp189kCFlsjzxJhIJsUDbj4u7sIX2z
        N0pRgubcOTwL3n1aBYRw++0+EngRFvhxd858DKTopqRoIIHL5RmUvvWy3C/PBRQu3qdQS1lvZYfr4
        fMCktn4Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzFJ7-007YLe-2M; Fri, 02 Jul 2021 09:18:05 +0000
Date:   Fri, 2 Jul 2021 10:17:57 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: attached iclog callbacks in
 xlog_cil_set_ctx_write_state()
Message-ID: <YN7ZxfrWoCjNFv3g@infradead.org>
References: <20210630072108.1752073-1-david@fromorbit.com>
 <20210630072108.1752073-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630072108.1752073-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 30, 2021 at 05:21:07PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have a mechanism to guarantee that the callbacks
> attached to an iclog are owned by the context that attaches them
> until they drop their reference to the iclog via
> xlog_state_release_iclog(), we can attach callbacks to the iclog at
> any time we have an active reference to the iclog.
> 
> xlog_state_get_iclog_space() always guarantees that the commit
> record will fit in the iclog it returns, so we can move this IO
> callback setting to xlog_cil_set_ctx_write_state(), record the
> commit iclog in the context and remove the need for the commit iclog
> to be returned by xlog_write() altogether.
> 
> This, in turn, allows us to move the wakeup for ordered commit
> recrod writes up into xlog_cil_set_ctx_write_state(), too, because

s/recrod/record/

> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -646,11 +646,41 @@ xlog_cil_set_ctx_write_state(
>  	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  
>  	ASSERT(!ctx->commit_lsn);
> +	if (!ctx->start_lsn) {
> +		spin_lock(&cil->xc_push_lock);
>  		ctx->start_lsn = lsn;
> +		spin_unlock(&cil->xc_push_lock);
> +		return;

What does xc_push_lock protect here?  None of the read of
->start_lsn are under xc_push_lock, and this patch moves one of the
two readers to be under l_icloglock.

Also I wonder if the comment about what is done if start_lsn is not
set would be better right above the if instead of on top of the function
so that it stays closer to the code it documents.
