Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919ADC433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 09:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D5B064F48
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 09:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbhBDJUT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 04:20:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57541 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234663AbhBDJUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 04:20:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612430330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xYlolhjZM08t8KaoBPWonxGPz1pzAllzEz3zjeNQhKk=;
        b=NB9k0yVGoXbMPitH5pVka1IdoLwM7HZ6VdzojoRic6rf4nas9DaMhlhssxwKS1tbCMVgLn
        zh542jnk9uu0uq/VtPClxqnPuwodqCEPMgzuwGliKqVQ7hjqFcUsmGdbDUjRadwYDScnX8
        ozxGz97JcmR59cH3vwUGo8Sm1oM5XhI=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-RW61NZJONLK4oUahsrv32A-1; Thu, 04 Feb 2021 04:18:48 -0500
X-MC-Unique: RW61NZJONLK4oUahsrv32A-1
Received: by mail-pj1-f69.google.com with SMTP id jx12so1661429pjb.3
        for <linux-xfs@vger.kernel.org>; Thu, 04 Feb 2021 01:18:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xYlolhjZM08t8KaoBPWonxGPz1pzAllzEz3zjeNQhKk=;
        b=ZtCqDOADpOm2mVS1d/vpv7SYWEu3oNYt8G2YtRaJb5nFbEh//vDZXaOHI2qS0Wuiqe
         0nerTBWra+gxfvCZ0ubW2cftLa/tyrnRqFteJfYf31YKVRwG/Ei2Ek2mVjYWPgRooyi9
         qsUGBhHpOnV/q2Gu8ej94n9od3ZRveqwN2NeFn+EIbV9D+FiILcpLNRgmITS5LHFl1w4
         hYd88L/jxE9kKZNUtO9o96k0h5Tr4Q5XPsjUceaF5d15jCUK86mCgXDjw5JiKv0+2hUy
         NCepjXC3JSrvRpcwgqhCVMGL2pjKpXJklIycxDziq0DENuGEpB0Hj7l+gMlxz8QyNG+u
         SpiQ==
X-Gm-Message-State: AOAM53121/v37xmc11dKbYcdzui3821mm50k6wsaNPl0r13rfhOaoOnr
        A1V5aFvmRh6QQl3H4FZlndgIAPXFYjJmH3PdxQh214b7c/6mjhrLhg+YRkBiz6sM6kXt4xYeM6C
        0pK6fgKitW2crwIUH1QiB
X-Received: by 2002:a65:6215:: with SMTP id d21mr7900006pgv.367.1612430327812;
        Thu, 04 Feb 2021 01:18:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxzkLJrzOrlhtqCojgGdQ/PoshJjnnVd765NNh0S1SNC+H/HZbnM3F2Jj3pNAhsUh4k0O0esQ==
X-Received: by 2002:a65:6215:: with SMTP id d21mr7899984pgv.367.1612430327464;
        Thu, 04 Feb 2021 01:18:47 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e4sm4172144pjt.38.2021.02.04.01.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 01:18:46 -0800 (PST)
Date:   Thu, 4 Feb 2021 17:18:35 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 6/7] xfs: support shrinking unused space in the last AG
Message-ID: <20210204091835.GA149518@xiangao.remote.csb>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-7-hsiangkao@redhat.com>
 <20210203142337.GB3647012@bfoster>
 <20210203145146.GA935062@xiangao.remote.csb>
 <20210203180126.GH3647012@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210203180126.GH3647012@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 01:01:26PM -0500, Brian Foster wrote:
> On Wed, Feb 03, 2021 at 10:51:46PM +0800, Gao Xiang wrote:

...

> > > 
> > > >  
> > > > -	/* If there are new blocks in the old last AG, extend it. */
> > > > +	/* If there are some blocks in the last AG, resize it. */
> > > >  	if (delta) {
> > > 
> > > This patch added a (nb == mp->m_sb.sb_dblocks) shortcut check at the top
> > > of the function. Should we ever get to this point with delta == 0? (If
> > > not, maybe convert it to an assert just to be safe.)
> > 
> > delta would be changed after xfs_resizefs_init_new_ags() (the original
> > growfs design is that, I don't want to touch the original logic). that
> > is why `delta' reflects the last AG delta now...
> > 
> 
> Oh, I see. Hmm... that's a bit obfuscated and easy to miss. Perhaps the
> new helper should also include the extend_space() call below to do all
> of the AG updates in one place. It's not clear to me if we need to keep
> the growfs perag reservation code where it is. If so, the new helper
> could take a boolean pointer (instead of delta) that it can set to true
> if it had to extend the size of the old last AG because the perag res
> bits don't actually use the delta value. IOW, I think this hunk could
> look something like the following:
> 
> 	bool	resetagres = false;
> 
> 	if (extend)
> 		error = xfs_resizefs_init_new_ags(..., delta, &resetagres);
> 	else
> 		error = xfs_ag_shrink_space(... -delta);
> 	...
> 
> 	if (resetagres) {
> 		<do perag res fixups>
> 	}
> 	...
> 
> Hm?

Not quite sure got your point since xfs_resizefs_init_new_ags() is not
part of the transaction (and no need to). If you mean that the current
codebase needs some refactor to make the whole growfs operation as a
new helper, I could do in the next version, but one thing out there is
there are too many local variables, if we introduce some new helper,
a new struct argument might be needed.

And I have no idea why growfs perag reservation stays at the end of
the function. My own understanding is that if growfs perag reservation
here is somewhat racy since no AGI/AGF lock protection it seems.

Thanks,
Gao Xiang

> 
> Brian

