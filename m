Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F492C3A589
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 02:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A53922DA7
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 02:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfHUCT5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 22:19:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45847 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfHUCT4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Aug 2019 22:19:56 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CCC0C3082A8D;
        Wed, 21 Aug 2019 02:19:56 +0000 (UTC)
Received: from ming.t460p (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DAB5957A7;
        Wed, 21 Aug 2019 02:19:49 +0000 (UTC)
Date:   Wed, 21 Aug 2019 10:19:44 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc:     "david@fromorbit.com" <david@fromorbit.com>,
        "hch@lst.de" <hch@lst.de>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190821021942.GB24167@ming.t460p>
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
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 21 Aug 2019 02:19:56 +0000 (UTC)
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

bio->bi_disk or bio->bi_disk->queue may not be available in bio_add_page().

And 'len' has to be aligned with logical block size of the disk on which fs is
mounted, which info is obviously available for fs.

So the following code is really buggy:

xfs_rw_bdev():

+               struct page     *page = kmem_to_page(data);
+               unsigned int    off = offset_in_page(data);
+               unsigned int    len = min_t(unsigned, left, PAGE_SIZE - off);
+
+               while (bio_add_page(bio, page, len, off) != len) {


Thanks,
Ming
