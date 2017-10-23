Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35451 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdJWGge (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 02:36:34 -0400
Date: Sun, 22 Oct 2017 23:36:30 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 4/4] lockdep: Assign a lock_class per gendisk used for
 wait_for_completion()
Message-ID: <20171023063630.GA21280@infradead.org>
References: <1508392531-11284-1-git-send-email-byungchul.park@lge.com>
 <1508396607-25362-1-git-send-email-byungchul.park@lge.com>
 <1508396607-25362-5-git-send-email-byungchul.park@lge.com>
 <20171020144451.GA16793@infradead.org>
 <20171022235334.GH3310@X58A-UD3R>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171022235334.GH3310@X58A-UD3R>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Byungchul Park <byungchul.park@lge.com>
Cc: Christoph Hellwig <hch@infradead.org>, peterz@infradead.org, mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org, johannes.berg@intel.com, oleg@redhat.com, amir73il@gmail.com, david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, idryomov@gmail.com, kernel-team@lge.com

On Mon, Oct 23, 2017 at 08:53:35AM +0900, Byungchul Park wrote:
> On Fri, Oct 20, 2017 at 07:44:51AM -0700, Christoph Hellwig wrote:
> > The Subject prefix for this should be "block:".
> > 
> > > @@ -945,7 +945,7 @@ int submit_bio_wait(struct bio *bio)
> > >  {
> > >  	struct submit_bio_ret ret;
> > >  
> > > -	init_completion(&ret.event);
> > > +	init_completion_with_map(&ret.event, &bio->bi_disk->lockdep_map);
> > 
> > FYI, I have an outstanding patch to simplify this a lot, which
> > switches this to DECLARE_COMPLETION_ONSTACK.  I can delay this or let
> > you pick it up with your series, but we'll need a variant of
> > DECLARE_COMPLETION_ONSTACK with the lockdep annotations.
> 
> Hello,
> 
> I'm sorry for late.
> 
> I think your patch makes block code simpler and better. I like it.
> 
> But, I just wonder if it's related to my series.

Because it shows that we also need a version of DECLARE_COMPLETION_ONSTACK
the gets passed an explicit lockdep map.  And because if it was merged
through a different tree it would create a conflict.

> Is it proper to add
> your patch into my series?

Sure.
