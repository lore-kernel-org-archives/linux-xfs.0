Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E9DC433FE
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Apr 2022 09:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiDPJGW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Apr 2022 05:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiDPJGW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Apr 2022 05:06:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C94041066E9
        for <linux-xfs@vger.kernel.org>; Sat, 16 Apr 2022 02:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650099829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+F3IclGpN6LG2HX4GRtWaYgRDtghcyGDVhwRl4OE650=;
        b=bKWgCSt37rZlOvFhcKlCYTB2j/LYT+xaM/1NOYOrBZjHF87wAb0188sJrZX8T2txrF8QoI
        5k+HdEkd6DgdDBTn6v+wgfou7Ep57hFVgFEiCeb3DX1OFECJ4bF7h4hVzsnkjPa+k8XxVD
        1+oEjeK/X/C+RJIZwSKxtIc4jUfzqz0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-nSxqUU0bPB-XJ4TIJrd2Sg-1; Sat, 16 Apr 2022 05:03:46 -0400
X-MC-Unique: nSxqUU0bPB-XJ4TIJrd2Sg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10F80185A79C;
        Sat, 16 Apr 2022 09:03:46 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 77813145D392;
        Sat, 16 Apr 2022 09:03:40 +0000 (UTC)
Date:   Sat, 16 Apr 2022 17:03:35 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: avoid io timeout in case of sync polled dio
Message-ID: <YlqGZ7W9rg0eNt9A@T590>
References: <20220415034703.2081695-1-ming.lei@redhat.com>
 <20220415051844.GA22762@lst.de>
 <YllQVT6n472eUB7+@T590>
 <20220416054913.GA7405@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220416054913.GA7405@lst.de>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 16, 2022 at 07:49:13AM +0200, Christoph Hellwig wrote:
> On Fri, Apr 15, 2022 at 07:00:37PM +0800, Ming Lei wrote:
> > On Fri, Apr 15, 2022 at 07:18:44AM +0200, Christoph Hellwig wrote:
> > > On Fri, Apr 15, 2022 at 11:47:03AM +0800, Ming Lei wrote:
> > > > +	/* make sure the bio is issued before polling */
> > > > +	if (bio.bi_opf & REQ_POLLED)
> > > > +		blk_flush_plug(current->plug, false);
> > > 
> > > I still think the core code should handle this.  Without that we'd need
> > > to export the blk_flush_plug for anything that would want to poll bios
> > > from modules, in addition to it generally being a mess.  See a proposed
> > 
> > So far there isn't such usage yet. dm calls bio_poll() in ->iopoll(),
> > and its caller(io_uring) will finish the plug.
> 
> Yes.  But not doing this automatically also means you keep easily
> forgetting callsites.  For example iomap still does not flush the plug
> in your patch.

It is reasonable for flush user(usually submission) to be responsible
for finishing/flushing plug.

iomap is one good example to show this point, since it does flush the plug
before call bio_poll(), see __iomap_dio_rw().

> 
> > > patch for that below.  I'd also split the flush aspect from the poll
> > > aspect into two patches.
> > > 
> > > > +		if (bio.bi_opf & REQ_POLLED)
> > > > +			bio_poll(&bio, NULL, 0);
> > > > +		else
> > > >  			blk_io_schedule();
> > > 
> > > Instead of this duplicate logic everywhere I'd just make bio_boll
> > > call blk_io_schedule for the !REQ_POLLED case and simplify all the
> > > callers.
> > 
> > bio_poll() may be called with rcu read lock held, so I'd suggest to
> > not mix the two together.
> 
> Ok, makes sense.
> 
> > > 
> > > > +			if (dio->submit.poll_bio &&
> > > > +					(dio->submit.poll_bio->bi_opf &
> > > > +						REQ_POLLED))
> > > 
> > > This indentation looks awfull,normal would be:
> > > 
> > > 			if (dio->submit.poll_bio &&
> > > 			    (dio->submit.poll_bio->bi_opf & REQ_POLLED))
> > 
> > That follows the indentation style of fs/iomap/direct-io.c for break in
> > 'if'.
> 
> It doesn't.  Just look at the conditional you replaced for example :)

OK, I will change to your style.

> 
> > > +	/*
> > > +	 * We can't plug for synchronously polled submissions, otherwise
> > > +	 * bio->bi_cookie won't be set directly after submission, which is the
> > > +	 * indicator used by the submitter to check if a bio needs polling.
> > > +	 */
> > > +	if (plug &&
> > > +	    (rq->bio->bi_opf & (REQ_POLLED | REQ_NOWAIT)) != REQ_POLLED)
> > >  		blk_add_rq_to_plug(plug, rq);
> > >  	else if ((rq->rq_flags & RQF_ELV) ||
> > >  		 (rq->mq_hctx->dispatch_busy &&
> > 
> > It is nothing to do with REQ_NOWAIT. sync polled dio can be marked as
> > REQ_NOWAIT by userspace too. If '--nowait=1' is added in the fio
> > reproducer, io timeout is triggered too.
> 
> True.  So I guess we'll need a new flag to distinguish the cases.

If there will be more such kind of poll usage in kernel, I think it is fine
to add the flag, but so far all the three aren't used very often.


Thanks,
Ming

