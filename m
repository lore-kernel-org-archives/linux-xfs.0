Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 356F8C3DA6F
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Aug 2023 04:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbjHYEH5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Aug 2023 00:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240980AbjHYEH4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2023 00:07:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65B51BCD
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 21:07:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7535663020
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2023 04:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE689C433C8;
        Fri, 25 Aug 2023 04:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692936473;
        bh=GAwLR5EezNu5bfNPgC6SzQBgRQW2RnFEL3LDpGIIXKo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fy9kaXdUio4b0J28dd+GU6qRZ76+c8E82FPo2gins777fk68DaVGX1eIOQBr0LGmM
         kngAoX9qrHmD9rKZNJXGh02EzcBOS6P0oLLfiXxETIVWs/TrV7yaZmuZYHb39F6B4R
         fZUMorC0vMXoeqkJ9ODNGosHUwoh9HpDC4c7Yfd2azhY0SWx+EDTpGqzGImTy3pSd+
         xzyUzOnffyk6dvMPt9HLCvGPw9WrnJsWSW1hrlyfmCiWCtYkDfiH7anoqWO/6Vpxmj
         8S2NlFzrm7mp9R7j/xcsahILQj5sqgZ1ZCStwXNLWJyjSrtVbQJlpLzREpxHbbGYQF
         ANyWbqoUNZhYA==
Date:   Thu, 24 Aug 2023 21:07:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     chandan.babu@gmail.com, tglx@linutronix.de, peterz@infradead.org,
        ritesh.list@gmail.com, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: fix per-cpu CIL structure aggregation racing
 with dying cpus
Message-ID: <20230825040753.GH17912@frogsfrogsfrogs>
References: <169291927442.219974.9654062191833512358.stgit@frogsfrogsfrogs>
 <169291928016.219974.17814488726880866494.stgit@frogsfrogsfrogs>
 <ZOftYLqVCMSWxmk/@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZOftYLqVCMSWxmk/@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 25, 2023 at 09:53:04AM +1000, Dave Chinner wrote:
> On Thu, Aug 24, 2023 at 04:21:20PM -0700, Darrick J. Wong wrote:
> > @@ -554,6 +560,7 @@ xlog_cil_insert_items(
> >  	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
> >  	int			space_used;
> >  	int			order;
> > +	unsigned int		cpu_nr;
> >  	struct xlog_cil_pcp	*cilpcp;
> >  
> >  	ASSERT(tp);
> > @@ -577,7 +584,12 @@ xlog_cil_insert_items(
> >  	 * can't be scheduled away between split sample/update operations that
> >  	 * are done without outside locking to serialise them.
> >  	 */
> > -	cilpcp = get_cpu_ptr(cil->xc_pcp);
> > +	cpu_nr = get_cpu();
> > +	cilpcp = this_cpu_ptr(cil->xc_pcp);
> > +
> > +	/* Tell the future push that there was work added by this CPU. */
> > +	if (!cpumask_test_cpu(cpu_nr, &ctx->cil_pcpmask))
> > +		cpumask_test_and_set_cpu(cpu_nr, &ctx->cil_pcpmask);
> >  
> >  	/*
> >  	 * We need to take the CIL checkpoint unit reservation on the first
> 
> This code also needs the put_cpu_ptr(cil->xc_pcp) converted to
> put_cpu(), even though they end up doing exactly the same thing.
> 
> Other than that, it looks good. I'll pull this into my test trees
> and give it a run...

Ok, I'll look forward to seeing what happens. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
