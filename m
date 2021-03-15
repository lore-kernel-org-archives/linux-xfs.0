Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E357C433E9
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 16:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AA9464F35
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 16:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbhCOQdG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 12:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232631AbhCOQce (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Mar 2021 12:32:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E6C564E42;
        Mon, 15 Mar 2021 16:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615825953;
        bh=N4rm8anUmYwXggjKvkbZBGcUJu7+jojZE7sJU4KkziY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TAVxv7JwRp6M0Nip93gMMJkA80DvTL/8Q5GkM7MBD5hdCM9al8tqlXb8RFZ8gWP3c
         R5Nun02R8gwQjw/x06Urjfx8pLoVTQNWDIQLZ5xznlc2PQULQbynYLa+vc+RaHJneN
         EBNmqnodcgMdUkRhTI8S37NJLNuSc2JEPrHbwArjzHkusft2KwhcVInlCAoSyxX5DR
         pozFjVvATiGO32+yMA3KIAbnopLTfBgynWuSL31OZXOPlQiNVqnGAqm7AJ3jQDnXmH
         1YHQRFpI1rwnBWBA0GxaKNYzwf80Rop5rqg5+6bWGlDAdeVG5vr6EA9ckC/3IbTcWz
         99luAZqtSlkZQ==
Date:   Mon, 15 Mar 2021 09:32:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/45] xfs: async blkdev cache flush
Message-ID: <20210315163222.GC22100@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-6-david@fromorbit.com>
 <87eegq3rja.fsf@garuda>
 <20210308222407.GA3419940@magnolia>
 <YE9yCbItv9Q8V0ic@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE9yCbItv9Q8V0ic@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 15, 2021 at 10:41:13AM -0400, Brian Foster wrote:
> On Mon, Mar 08, 2021 at 02:24:07PM -0800, Darrick J. Wong wrote:
> > On Mon, Mar 08, 2021 at 03:18:09PM +0530, Chandan Babu R wrote:
> > > On 05 Mar 2021 at 10:41, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > >
> > > > The new checkpoint caceh flush mechanism requires us to issue an
> > > > unconditional cache flush before we start a new checkpoint. We don't
> > > > want to block for this if we can help it, and we have a fair chunk
> > > > of CPU work to do between starting the checkpoint and issuing the
> > > > first journal IO.
> > > >
> > > > Hence it makes sense to amortise the latency cost of the cache flush
> > > > by issuing it asynchronously and then waiting for it only when we
> > > > need to issue the first IO in the transaction.
> > > >
> > > > TO do this, we need async cache flush primitives to submit the cache
> > > > flush bio and to wait on it. THe block layer has no such primitives
> > > > for filesystems, so roll our own for the moment.
> > > >
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_bio_io.c | 36 ++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/xfs_linux.h  |  2 ++
> > > >  2 files changed, 38 insertions(+)
> > > >
> > > > diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> > > > index 17f36db2f792..668f8bd27b4a 100644
> > > > --- a/fs/xfs/xfs_bio_io.c
> > > > +++ b/fs/xfs/xfs_bio_io.c
> > > > @@ -9,6 +9,42 @@ static inline unsigned int bio_max_vecs(unsigned int count)
> > > >  	return bio_max_segs(howmany(count, PAGE_SIZE));
> > > >  }
> > > >  
> > > > +void
> > > > +xfs_flush_bdev_async_endio(
> > > > +	struct bio	*bio)
> > > > +{
> > > > +	if (bio->bi_private)
> > > > +		complete(bio->bi_private);
> > > > +}
> > > > +
> > > > +/*
> > > > + * Submit a request for an async cache flush to run. If the request queue does
> > > > + * not require flush operations, just skip it altogether. If the caller needsi
> > > > + * to wait for the flush completion at a later point in time, they must supply a
> > > > + * valid completion. This will be signalled when the flush completes.  The
> > > > + * caller never sees the bio that is issued here.
> > > > + */
> > > > +void
> > > > +xfs_flush_bdev_async(
> > > > +	struct bio		*bio,
> > > > +	struct block_device	*bdev,
> > > > +	struct completion	*done)
> > > > +{
> > > > +	struct request_queue	*q = bdev->bd_disk->queue;
> > > > +
> > > > +	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags)) {
> > > > +		complete(done);
> > > 
> > > complete() should be invoked only when "done" has a non-NULL value.
> > 
> > The only caller always provides a completion.
> > 
> 
> IMO, if the mechanism (i.e. the helper) accommodates a NULL parameter,
> the underlying completion callback should as well..

Yes, I agree with that principle.  However, the use case for !done isn't
clear ot me -- what is the point of issuing a flush and not waiting for
the results?

Can PREFLUSHes generate IO errors?  And if they do, why don't we return
the error to the caller?

--D

> Brian
> 
> > --D
> > 
> > > > +		return;
> > > > +	}
> > > 
> > > -- 
> > > chandan
> > 
> 
