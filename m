Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3EC3C63793
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B88AA61279
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhGVGeY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 02:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhGVGeX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 02:34:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D059C061575
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jul 2021 00:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gr67rGHRhFdtMPN1v7mefZw4yiZeG4bVzyLnYkFW6aM=; b=AQX8E18hxAKn7+LYo7m2/nhhBw
        apMxayWoeyxAgjprTWcZ98ATwYTcZdkv+XKShX95Akbx1NCMA2HS6ATzNxNW+rrgrs2lNfrJEhTqz
        Z8XRMd9ON2UmITPUJYPi9iWpKHLTj8nYlrzr4HwbsDDjmL3YjIvT7TjIB6+2SR7rTahfuoR04c75W
        BCR61Pr55GZIKh24bfTkpkg0UOIdU0D/4R7kQrzvy+2H9FvxTzOGEZ/rSYEVXryh4xRHsIhi9VbZv
        9f0/z7K0Gv6MGuQ+9aly4k/RbXxK8FyqlK0qxPiQ5UD2Xkl9actWcbKIRDphd1Vk12Kyxcj0+ECgl
        MiySIWGA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6Sue-009zIh-Ow; Thu, 22 Jul 2021 07:14:37 +0000
Date:   Thu, 22 Jul 2021 08:14:32 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: log forces imply data device cache flushes
Message-ID: <YPka2FRJAC38RbU+@infradead.org>
References: <20210722015335.3063274-1-david@fromorbit.com>
 <20210722015335.3063274-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722015335.3063274-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 11:53:34AM +1000, Dave Chinner wrote:
> +static inline int
> +xlog_force_iclog(
> +	struct xlog_in_core	*iclog)
> +{
> +	atomic_inc(&iclog->ic_refcnt);
> +	iclog->ic_flags |= XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA;
> +	if (iclog->ic_state == XLOG_STATE_ACTIVE)
> +		xlog_state_switch_iclogs(iclog->ic_log, iclog, 0);
> +	return xlog_state_release_iclog(iclog->ic_log, iclog, 0);
> +}

This also combines code move with technical changes.  At least it is
small enough to be reviewable.

>  out_err:
> -	if (error)
> -		xfs_alert(mp, "%s: unmount record failed", __func__);
> -
>  

> +	if (error)
> +		xfs_alert(mp, "%s: unmount record failed", __func__);
> +
>  }

This now doesn't print an error when the log reservation or log write
fails, but only one when the log force fails.  Also there i a spurious
empty line at the end.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
