Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA561C4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C182613AC
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhFBW0L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhFBW0L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 18:26:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 757EB6138C;
        Wed,  2 Jun 2021 22:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622672667;
        bh=ncD6p2L9NvxIfelnEZ/3UWGJiSHhXATaEO1+PF2nN9I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mci1CRDXF2VLUIwSrIn6XPTYioipIzsZgojJtZArN1MugJ4qstubXftM37qPvnPgX
         DZJYiDa3OnwwFxYkr2Y+XTR8DWYHN+Qdow2nLHvaOa1NrfNs7kxnwjofs1/pMGVptG
         YZgB0zs0Nce/pP1JGE8FFr/8nZytY4lS9g7vSuGBhULNgUAlo57TWy4fhko8/+SOkx
         aaOfL+a5mc8Ty232C6z9wgQmLPeM5dQsUivMCfA4qB25ziYEOsGmJeCz02q7if7QBK
         SQ5wZEbLJ65XgJUFmanqMIvRjTt/dSLKs3Z+m/eiJEmsbRsmTMYaNg9/ozMLnvQ9+t
         fl6+qAorB5J5g==
Date:   Wed, 2 Jun 2021 15:24:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/39] xfs: pass lv chain length into xlog_write()
Message-ID: <20210602222427.GN26380@locust>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-21-david@fromorbit.com>
 <20210527172027.GL202144@locust>
 <20210602221852.GV664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602221852.GV664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 08:18:52AM +1000, Dave Chinner wrote:
> On Thu, May 27, 2021 at 10:20:27AM -0700, Darrick J. Wong wrote:
> > On Wed, May 19, 2021 at 10:12:58PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The caller of xlog_write() usually has a close accounting of the
> > > aggregated vector length contained in the log vector chain passed to
> > > xlog_write(). There is no need to iterate the chain to calculate he
> > > length of the data in xlog_write_calculate_len() if the caller is
> > > already iterating that chain to build it.
> > > 
> > > Passing in the vector length avoids doing an extra chain iteration,
> > > which can be a significant amount of work given that large CIL
> > > commits can have hundreds of thousands of vectors attached to the
> > > chain.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ....
> > > @@ -849,6 +850,10 @@ xlog_cil_push_work(
> > >  		lv = item->li_lv;
> > >  		item->li_lv = NULL;
> > >  		num_iovecs += lv->lv_niovecs;
> > > +
> > > +		/* we don't write ordered log vectors */
> > > +		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
> > > +			num_bytes += lv->lv_bytes;
> > >  	}
> > >  
> > >  	/*
> > > @@ -887,6 +892,8 @@ xlog_cil_push_work(
> > >  	 * transaction header here as it is not accounted for in xlog_write().
> > >  	 */
> > >  	xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
> > > +	num_iovecs += lvhdr.lv_niovecs;
> > 
> > I have the same question that Brian had last time, which is: What's the
> > point of updating num_iovecs here?  It's not used after
> > xlog_cil_build_trans_hdr, either here or at the end of the patchset.
> > 
> > Is the idea that num_{iovecs,bytes} will always reflect everything
> > in the cil context chain that's about to be passed to xlog_write?
> 
> I left it there because I did want to keep the two variables up to
> date for future use. i.e. I didn't want to leave a landmine later
> down the track if I need to use num_iovecs in future changes. I've
> also used it a few times for temporary debugging code, so I'd
> prefer to keep it even though it isn't used.
> 
> But if "not used" is the only reason for people not giving rvbs,
> then I can remove it...

...or feed it to a tracepoint, if you find it useful for debugging the
size of log writes?  <shrug>

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
