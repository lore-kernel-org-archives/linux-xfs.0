Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57711C07E9C
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 06:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38E8261164
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 06:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238117AbhGNGh1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 02:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238053AbhGNGh0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 02:37:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD30C06175F
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jul 2021 23:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=s6jcUI5jK6yJXpqce6s6x2BfKBMm648VDH6ignyf7Vw=; b=EOzEVmT+rq0Z2GJv+6os8OY6Md
        Wkq4naAMtoNuwxGofQGuOVO0HMJW9GiQmM4zGvMrjc+oIG/XGs35hbmimz1rCaGnLEODfYBX9o2Za
        mZ71DyFUtKvp18DSkalLheDRShxyVlJWpFVbiZXEVlkr1A7CE9S7pBscoVxEVzdx6H69Oe7auZXQG
        AI/Son1LSJ4C5OOGvameHWTtbPyldLMqCNjgTo9EJvK0Gmcn1fbztHG6a+PfN0rMQa7UwyWPUc4mO
        J06RJMIfJ1eH8H7KXF8oAtsYYXLetIRZ+WcH8BNUvUbrdRTBKDL3WmaE5s559S/fheqbXtcq7A5xe
        bls/OXgQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3YT2-001vSP-6Y; Wed, 14 Jul 2021 06:34:15 +0000
Date:   Wed, 14 Jul 2021 07:34:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: order CIL checkpoint start records
Message-ID: <YO6FWFxwFyWQ5BhG@infradead.org>
References: <20210714033656.2621741-1-david@fromorbit.com>
 <20210714033656.2621741-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714033656.2621741-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 01:36:56PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because log recovery depends on strictly ordered start records as
> well as strictly ordered commit records.
> 
> This is a zero day bug in the way XFS writes pipelined transactions
> to the journal which is exposed by fixing the zero day bug that
> prevents the CIL from pipelining checkpoints. This re-introduces
> explicit concurrent commits back into the on-disk journal and hence
> out of order start records.
> 
> The XFS journal commit code has never ordered start records and we
> have relied on strict commit record ordering for correct recovery
> ordering of concurrently written transactions. Unfortunately, root
> cause analysis uncovered the fact that log recovery uses the LSN of
> the start record for transaction commit processing. Hence, whilst
> the commits are processed in strict order by recovery, the LSNs
> associated with the commits can be out of order and so recovery may
> stamp incorrect LSNs into objects and/or misorder intents in the AIL
> for later processing. This can result in log recovery failures
> and/or on disk corruption, sometimes silent.
> 
> Because this is a long standing log recovery issue, we can't just
> fix log recovery and call it good. This still leaves older kernels
> susceptible to recovery failures and corruption when replaying a log
> from a kernel that pipelines checkpoints. There is also the issue
> that in-memory ordering for AIL pushing and data integrity
> operations are based on checkpoint start LSNs, and if the start LSN
> is incorrect in the journal, it is also incorrect in memory.
> 
> Hence there's really only one choice for fixing this zero-day bug:
> we need to strictly order checkpoint start records in ascending
> sequence order in the log, the same way we already strictly order
> commit records.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I can't say I like the overloading of a mostly trivial function
with the record enum.  I think just two separate helpers would
be much more obvious.

But technically this looks fine.
