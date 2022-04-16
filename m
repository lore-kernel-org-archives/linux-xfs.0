Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48303C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Apr 2022 05:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiDPFvs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Apr 2022 01:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiDPFvr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Apr 2022 01:51:47 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D702980B;
        Fri, 15 Apr 2022 22:49:17 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8C5F768AFE; Sat, 16 Apr 2022 07:49:13 +0200 (CEST)
Date:   Sat, 16 Apr 2022 07:49:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: avoid io timeout in case of sync polled dio
Message-ID: <20220416054913.GA7405@lst.de>
References: <20220415034703.2081695-1-ming.lei@redhat.com> <20220415051844.GA22762@lst.de> <YllQVT6n472eUB7+@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YllQVT6n472eUB7+@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 15, 2022 at 07:00:37PM +0800, Ming Lei wrote:
> On Fri, Apr 15, 2022 at 07:18:44AM +0200, Christoph Hellwig wrote:
> > On Fri, Apr 15, 2022 at 11:47:03AM +0800, Ming Lei wrote:
> > > +	/* make sure the bio is issued before polling */
> > > +	if (bio.bi_opf & REQ_POLLED)
> > > +		blk_flush_plug(current->plug, false);
> > 
> > I still think the core code should handle this.  Without that we'd need
> > to export the blk_flush_plug for anything that would want to poll bios
> > from modules, in addition to it generally being a mess.  See a proposed
> 
> So far there isn't such usage yet. dm calls bio_poll() in ->iopoll(),
> and its caller(io_uring) will finish the plug.

Yes.  But not doing this automatically also means you keep easily
forgetting callsites.  For example iomap still does not flush the plug
in your patch.

> > patch for that below.  I'd also split the flush aspect from the poll
> > aspect into two patches.
> > 
> > > +		if (bio.bi_opf & REQ_POLLED)
> > > +			bio_poll(&bio, NULL, 0);
> > > +		else
> > >  			blk_io_schedule();
> > 
> > Instead of this duplicate logic everywhere I'd just make bio_boll
> > call blk_io_schedule for the !REQ_POLLED case and simplify all the
> > callers.
> 
> bio_poll() may be called with rcu read lock held, so I'd suggest to
> not mix the two together.

Ok, makes sense.

> > 
> > > +			if (dio->submit.poll_bio &&
> > > +					(dio->submit.poll_bio->bi_opf &
> > > +						REQ_POLLED))
> > 
> > This indentation looks awfull,normal would be:
> > 
> > 			if (dio->submit.poll_bio &&
> > 			    (dio->submit.poll_bio->bi_opf & REQ_POLLED))
> 
> That follows the indentation style of fs/iomap/direct-io.c for break in
> 'if'.

It doesn't.  Just look at the conditional you replaced for example :)

> > +	/*
> > +	 * We can't plug for synchronously polled submissions, otherwise
> > +	 * bio->bi_cookie won't be set directly after submission, which is the
> > +	 * indicator used by the submitter to check if a bio needs polling.
> > +	 */
> > +	if (plug &&
> > +	    (rq->bio->bi_opf & (REQ_POLLED | REQ_NOWAIT)) != REQ_POLLED)
> >  		blk_add_rq_to_plug(plug, rq);
> >  	else if ((rq->rq_flags & RQF_ELV) ||
> >  		 (rq->mq_hctx->dispatch_busy &&
> 
> It is nothing to do with REQ_NOWAIT. sync polled dio can be marked as
> REQ_NOWAIT by userspace too. If '--nowait=1' is added in the fio
> reproducer, io timeout is triggered too.

True.  So I guess we'll need a new flag to distinguish the cases.
