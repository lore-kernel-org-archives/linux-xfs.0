Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA67C3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 23:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FC22206B6
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 23:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfHTXye (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 19:54:34 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55849 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbfHTXye (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 19:54:34 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1F28A43E4DC;
        Wed, 21 Aug 2019 09:54:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0DwI-0001eZ-LB; Wed, 21 Aug 2019 09:53:22 +1000
Date:   Wed, 21 Aug 2019 09:53:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc:     "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190820235322.GJ1119@dread.disaster.area>
References: <20190819041132.GA14492@lst.de>
 <20190819042259.GZ6129@dread.disaster.area>
 <20190819042905.GA15613@lst.de>
 <20190819044012.GA15800@lst.de>
 <20190820044135.GC1119@dread.disaster.area>
 <20190820055320.GB27501@lst.de>
 <20190820081325.GA21032@ming.t460p>
 <20190820092424.GB21032@ming.t460p>
 <20190820214408.GG1119@dread.disaster.area>
 <85bde038615a6a82d79708fd04944671ca8580c5.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85bde038615a6a82d79708fd04944671ca8580c5.camel@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=Xv0y9uns91YydaQQMxwA:9 a=-ec80IMEu3Jzm-bp:21
        a=6fXaY66gyORZkQyz:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 10:08:38PM +0000, Verma, Vishal L wrote:
> On Wed, 2019-08-21 at 07:44 +1000, Dave Chinner wrote:
> > 
> > However, the case here is that:
> > 
> > > > > > i.e. page		offset	len	sector
> > > > > > 00000000a77f0146	768	3328	0x7d0048
> > > > > > 000000006ceca91e	0	768	0x7d004e
> > 
> > The second page added to the bvec is actually offset alignedr. Hence
> > the check would do nothing on the first page because the bvec array
> > is empty (so goes into a new bvec anyway), and the check on the
> > second page would do nothing an it would merge with first because
> > the offset is aligned correctly. In both cases, the length of the
> > segment is not aligned, so that needs to be checked, too.
> > 
> > IOWs, I think the check needs to be in bio_add_page, it needs to
> > check both the offset and length for alignment, and it needs to grab
> > the alignment from queue_dma_alignment(), not use a hard coded value
> > of 511.
> > 
> So something like this?
> 
> diff --git a/block/bio.c b/block/bio.c
> index 299a0e7651ec..80f449d23e5a 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -822,8 +822,12 @@ EXPORT_SYMBOL_GPL(__bio_add_page);
>  int bio_add_page(struct bio *bio, struct page *page,
>                  unsigned int len, unsigned int offset)
>  {
> +       struct request_queue *q = bio->bi_disk->queue;
>         bool same_page = false;
>  
> +       if (offset & queue_dma_alignment(q) || len & queue_dma_alignment(q))
> +               return 0;
> +
>         if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
>                 if (bio_full(bio, len))
>                         return 0;
> 
> I tried this, but the 'mount' just hangs - which looks like it might be
> due to xfs_rw_bdev() doing:
> 
>   while (bio_add_page(bio, page, len, off) != len) {

That's the return of zero that causes the loop to make no progress.
i.e. a return of 0 means "won't fit in bio, allocate a new bio
and try again". It's not an error return, so always returning zero
will eventually chew up all your memory allocating bios it
doesn't use, because submit_bio() doesn't return errors on chained
bios until the final bio in the chain is completed.

Add a bio_add_page_checked() function that does exactly the same
this as bio_add_page(), but add the

	if (WARN_ON_ONCE((offset | len) & queue_dma_alignment(q)))
		return -EIO;

to it and change the xfs code to:

	while ((len = bio_add_page_checked(bio, page, len, off)) != len) {
		if (len < 0) {
			/*
			 * submit the bio to wait on the rest of the
			 * chain to complete, then return an error.
			 * This is a really shitty failure on write, as we
			 * will have just done a partial write and
			 * effectively corrupted something on disk.
			 */
			submit_bio_wait(bio);
			return len;
		}
		....
	}

We probably should change all the XFS calls to bio_add_page to
bio_add_page_checked() while we are at it, because we have the
same alignment problem through xfs_buf.c and, potentially, on iclogs
via xfs_log.c as iclogs are allocated with kmem_alloc_large(), too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
