Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3292EC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 14:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A85064F36
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 14:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbhCOOm6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 10:42:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237319AbhCOOlW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 10:41:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615819278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iQo1Jv4ViIAHI9lZM3ec7THrNHx/FuVPnDACyUfkmJs=;
        b=XaQrDWAqDgXGFVFAnrq/T9RfD5AnZHrBJ/OYRfwfUHxYdql5Cc8NITAz+d7BOurgQ/7Wu8
        naJeGizH/97mPRoC6j/MwmLJVMFNJqArR+NNxVgBqrGaXq7gloEE/GqpelLC33DIMVvjAn
        BOpYIryDNPu7N4n9BWmERk3lnMQ6E9Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-EtUV3g-4MQiWWwQzeAK9yw-1; Mon, 15 Mar 2021 10:41:16 -0400
X-MC-Unique: EtUV3g-4MQiWWwQzeAK9yw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F0D0101F004;
        Mon, 15 Mar 2021 14:41:15 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C8C4D620DE;
        Mon, 15 Mar 2021 14:41:14 +0000 (UTC)
Date:   Mon, 15 Mar 2021 10:41:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/45] xfs: async blkdev cache flush
Message-ID: <YE9yCbItv9Q8V0ic@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-6-david@fromorbit.com>
 <87eegq3rja.fsf@garuda>
 <20210308222407.GA3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308222407.GA3419940@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 02:24:07PM -0800, Darrick J. Wong wrote:
> On Mon, Mar 08, 2021 at 03:18:09PM +0530, Chandan Babu R wrote:
> > On 05 Mar 2021 at 10:41, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > >
> > > The new checkpoint caceh flush mechanism requires us to issue an
> > > unconditional cache flush before we start a new checkpoint. We don't
> > > want to block for this if we can help it, and we have a fair chunk
> > > of CPU work to do between starting the checkpoint and issuing the
> > > first journal IO.
> > >
> > > Hence it makes sense to amortise the latency cost of the cache flush
> > > by issuing it asynchronously and then waiting for it only when we
> > > need to issue the first IO in the transaction.
> > >
> > > TO do this, we need async cache flush primitives to submit the cache
> > > flush bio and to wait on it. THe block layer has no such primitives
> > > for filesystems, so roll our own for the moment.
> > >
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_bio_io.c | 36 ++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_linux.h  |  2 ++
> > >  2 files changed, 38 insertions(+)
> > >
> > > diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> > > index 17f36db2f792..668f8bd27b4a 100644
> > > --- a/fs/xfs/xfs_bio_io.c
> > > +++ b/fs/xfs/xfs_bio_io.c
> > > @@ -9,6 +9,42 @@ static inline unsigned int bio_max_vecs(unsigned int count)
> > >  	return bio_max_segs(howmany(count, PAGE_SIZE));
> > >  }
> > >  
> > > +void
> > > +xfs_flush_bdev_async_endio(
> > > +	struct bio	*bio)
> > > +{
> > > +	if (bio->bi_private)
> > > +		complete(bio->bi_private);
> > > +}
> > > +
> > > +/*
> > > + * Submit a request for an async cache flush to run. If the request queue does
> > > + * not require flush operations, just skip it altogether. If the caller needsi
> > > + * to wait for the flush completion at a later point in time, they must supply a
> > > + * valid completion. This will be signalled when the flush completes.  The
> > > + * caller never sees the bio that is issued here.
> > > + */
> > > +void
> > > +xfs_flush_bdev_async(
> > > +	struct bio		*bio,
> > > +	struct block_device	*bdev,
> > > +	struct completion	*done)
> > > +{
> > > +	struct request_queue	*q = bdev->bd_disk->queue;
> > > +
> > > +	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags)) {
> > > +		complete(done);
> > 
> > complete() should be invoked only when "done" has a non-NULL value.
> 
> The only caller always provides a completion.
> 

IMO, if the mechanism (i.e. the helper) accommodates a NULL parameter,
the underlying completion callback should as well..

Brian

> --D
> 
> > > +		return;
> > > +	}
> > 
> > -- 
> > chandan
> 

