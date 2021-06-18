Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B25C48BE8
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 14:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA03E61222
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 14:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhFRO0g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 10:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbhFRO0g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 10:26:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4427C061574
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 07:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yNx9Xi9EyXZy0KdJ79QeJo9fRSL9efwGYdU9ENaaz9A=; b=JhfiAPXkvWraoXXCO/fNCQLp8k
        ADZwDDQ2aOrxlnUJ77QK3SHZuEZyKi+mBhl7L2qxClZCxJHdYGkfCyYHZey02v6I+DAOvdzHTg0yn
        zjW9oUQvPaamEpRMOFhHrYK1X/3wl+ubfZ+DzGGL8OuifsYvhalYMGpi2j5KUEvhhS0/Krg2L5/Qw
        l04s2Yy8HFeBnMOIRfZLQQlaXrkjosVWvBIhv/OQygdw+XuNIgzjTcKorhIn6SEWV0Db2FzeN4h3+
        w3tEE0gGmzV4jHkbemvW6hi1B0J7vGfoGJVUhxGiRRNMzXE9BOc/JC8bqllMJGlMmTOhAxlmDSijP
        ZCkLKAhA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luFPZ-00AM0m-Vc; Fri, 18 Jun 2021 14:24:03 +0000
Date:   Fri, 18 Jun 2021 15:23:57 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: pass a CIL context to xlog_write()
Message-ID: <YMysfdbP19Z7nuYL@infradead.org>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617082617.971602-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	/*
> +	 * If we have a CIL context, record the LSN of the iclog we were just
> +	 * granted space to start writing into. If the context doesn't have
> +	 * a start_lsn recorded, then this iclog will contain the start record
> +	 * for the checkpoint. Otherwise this write contains the commit record
> +	 * for the checkpoint.
> +	 */
> +	if (ctx) {
> +		spin_lock(&ctx->cil->xc_push_lock);
> +		if (!ctx->start_lsn)
> +			ctx->start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +		else
> +			ctx->commit_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +		spin_unlock(&ctx->cil->xc_push_lock);
> +	}

I have to say that having this cil_ctx specific logic that somehow
reverse eingeer what the callers is doing here seems pretty awkware.
To me the logical interface would be to pass a function pointer and
private data except for the performance penalty of indirect calls.

But to make this somewhat bearable I think you should start with the
above block as a helper implemented in xfs_log_cil.c.
