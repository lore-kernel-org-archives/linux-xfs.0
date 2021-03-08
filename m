Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24655C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 22:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D40C96523D
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 22:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhCHWY0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 17:24:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229627AbhCHWYI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 17:24:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 632A564F91;
        Mon,  8 Mar 2021 22:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615242248;
        bh=9qYp8268oc81f4sNjOca9rjZtlWH8Q6mMeNScQEctRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LpGlQwF52C79v/9ZPTiPRTaJ0lMogr9qIriwokk7whMxvQo+dAeYROgx9BxnDST3V
         SowkHwzCG7Hd8AL54VQhvKC0e1aCbR99gEyLOU/78sLOPA5RLAbpgvB7YEe95Srnm0
         kUQWLTgLB5F+NGbqpwP8xSo3dFV3I9h+Q1QnMqvfwLKcGVGd4s8g1vojfnifPdGRe2
         ru10XHRi9YGmbRKur8F1FRPBy5GIznTBJiSIMsM6uxJAyfFeKX8ObAYihTj5qJrH2F
         +Wr5yE18F+6pV1Vv+sAd/q9jsR3ikmslpesVkjrZwNFpsglgvaacL7azNF0Y0MieYz
         kLXP/vU0UjNcQ==
Date:   Mon, 8 Mar 2021 14:24:07 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/45] xfs: async blkdev cache flush
Message-ID: <20210308222407.GA3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-6-david@fromorbit.com>
 <87eegq3rja.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eegq3rja.fsf@garuda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 03:18:09PM +0530, Chandan Babu R wrote:
> On 05 Mar 2021 at 10:41, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > The new checkpoint caceh flush mechanism requires us to issue an
> > unconditional cache flush before we start a new checkpoint. We don't
> > want to block for this if we can help it, and we have a fair chunk
> > of CPU work to do between starting the checkpoint and issuing the
> > first journal IO.
> >
> > Hence it makes sense to amortise the latency cost of the cache flush
> > by issuing it asynchronously and then waiting for it only when we
> > need to issue the first IO in the transaction.
> >
> > TO do this, we need async cache flush primitives to submit the cache
> > flush bio and to wait on it. THe block layer has no such primitives
> > for filesystems, so roll our own for the moment.
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_bio_io.c | 36 ++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_linux.h  |  2 ++
> >  2 files changed, 38 insertions(+)
> >
> > diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> > index 17f36db2f792..668f8bd27b4a 100644
> > --- a/fs/xfs/xfs_bio_io.c
> > +++ b/fs/xfs/xfs_bio_io.c
> > @@ -9,6 +9,42 @@ static inline unsigned int bio_max_vecs(unsigned int count)
> >  	return bio_max_segs(howmany(count, PAGE_SIZE));
> >  }
> >  
> > +void
> > +xfs_flush_bdev_async_endio(
> > +	struct bio	*bio)
> > +{
> > +	if (bio->bi_private)
> > +		complete(bio->bi_private);
> > +}
> > +
> > +/*
> > + * Submit a request for an async cache flush to run. If the request queue does
> > + * not require flush operations, just skip it altogether. If the caller needsi
> > + * to wait for the flush completion at a later point in time, they must supply a
> > + * valid completion. This will be signalled when the flush completes.  The
> > + * caller never sees the bio that is issued here.
> > + */
> > +void
> > +xfs_flush_bdev_async(
> > +	struct bio		*bio,
> > +	struct block_device	*bdev,
> > +	struct completion	*done)
> > +{
> > +	struct request_queue	*q = bdev->bd_disk->queue;
> > +
> > +	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags)) {
> > +		complete(done);
> 
> complete() should be invoked only when "done" has a non-NULL value.

The only caller always provides a completion.

--D

> > +		return;
> > +	}
> 
> -- 
> chandan
