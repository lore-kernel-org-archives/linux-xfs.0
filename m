Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30827C07E9A
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jul 2021 00:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ABD1606A5
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jul 2021 00:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbhGMAyz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jul 2021 20:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233545AbhGMAyz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jul 2021 20:54:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F29C6100C;
        Tue, 13 Jul 2021 00:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626137526;
        bh=LQQxY4zyJZgUbdVMqfQ4Myv3S5iZEArf3Nt/GqJqsUw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m27b618LxdkQNqTbZ+a/fL8Ho0TXXr+jK2ogj6ewBYFzrO+eJMoF1uciG96R94T9Z
         pXFtw7A8lSQov/1hoIA2AAn/rhz86Mgf2V7u7pvzYFxLJdKkgtsEgJag7kMWwpAL8X
         g76whFmpApXaakRfrkRRagqeFRaFicVCym2Rn9p6SdrD6yRDVe1s575h2xlH1Xyh04
         2suw0EUUEr3KJsVS8bV2WrFYcxGouxaLMxz/nyQd7+JZUyv5rdfg45JFaxofuWd0/t
         l/yrtaRtFfs4SggHJtgl/UHv1j4in8tMv9CeyflnRpdCSaTkuhpJjIjf4Sabc3w+k0
         8EuaqrzfiZlpA==
Date:   Mon, 12 Jul 2021 17:52:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: attached iclog callbacks in
 xlog_cil_set_ctx_write_state()
Message-ID: <20210713005205.GA22402@magnolia>
References: <20210630072108.1752073-1-david@fromorbit.com>
 <20210630072108.1752073-5-david@fromorbit.com>
 <YN7ZxfrWoCjNFv3g@infradead.org>
 <20210705054919.GM664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705054919.GM664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 05, 2021 at 03:49:19PM +1000, Dave Chinner wrote:
> On Fri, Jul 02, 2021 at 10:17:57AM +0100, Christoph Hellwig wrote:
> > On Wed, Jun 30, 2021 at 05:21:07PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Now that we have a mechanism to guarantee that the callbacks
> > > attached to an iclog are owned by the context that attaches them
> > > until they drop their reference to the iclog via
> > > xlog_state_release_iclog(), we can attach callbacks to the iclog at
> > > any time we have an active reference to the iclog.
> > > 
> > > xlog_state_get_iclog_space() always guarantees that the commit
> > > record will fit in the iclog it returns, so we can move this IO
> > > callback setting to xlog_cil_set_ctx_write_state(), record the
> > > commit iclog in the context and remove the need for the commit iclog
> > > to be returned by xlog_write() altogether.
> > > 
> > > This, in turn, allows us to move the wakeup for ordered commit
> > > recrod writes up into xlog_cil_set_ctx_write_state(), too, because
> > 
> > s/recrod/record/
> > 
> > > --- a/fs/xfs/xfs_log_cil.c
> > > +++ b/fs/xfs/xfs_log_cil.c
> > > @@ -646,11 +646,41 @@ xlog_cil_set_ctx_write_state(
> > >  	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> > >  
> > >  	ASSERT(!ctx->commit_lsn);
> > > +	if (!ctx->start_lsn) {
> > > +		spin_lock(&cil->xc_push_lock);
> > >  		ctx->start_lsn = lsn;
> > > +		spin_unlock(&cil->xc_push_lock);
> > > +		return;
> > 
> > What does xc_push_lock protect here?  None of the read of
> > ->start_lsn are under xc_push_lock, and this patch moves one of the
> > two readers to be under l_icloglock.
> 
> For this patch - nothing. It just maintains the consistency
> introduced in the previous patch of doing the CIL context updates
> under the xc_push_lock. I did that in the previous patch for
> simplicity: the next patch adds the start record ordering which,
> like the commit record ordering, needs to set ctx->start_lsn and run
> the waiter wakeup under the xc_push_lock.
> 
> > Also I wonder if the comment about what is done if start_lsn is not
> > set would be better right above the if instead of on top of the function
> > so that it stays closer to the code it documents.
> 
> I think it's better to document calling conventions at the top of
> the function, rather than having to read the implementation of the
> function to determine how it is supposed to be called. i.e. we
> expect two calls to this function per CIL checkpoint - the first for
> the start record ordering, the second for the commit record
> ordering...

For calling conventions, I totally agree.  It's a lot easier to figure
out a function's preconditions if they're listed in the function comment
and not buried in the body.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
