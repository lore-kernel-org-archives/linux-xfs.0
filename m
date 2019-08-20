Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E56AC3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 21:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5658220656
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 21:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbfHTVpU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 17:45:20 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50634 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729900AbfHTVpT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 17:45:19 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6DE7D43EBC3;
        Wed, 21 Aug 2019 07:45:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0BvF-0000tu-0o; Wed, 21 Aug 2019 07:44:09 +1000
Date:   Wed, 21 Aug 2019 07:44:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "hch@lst.de" <hch@lst.de>,
        "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190820214408.GG1119@dread.disaster.area>
References: <20190819000831.GX6129@dread.disaster.area>
 <20190819034948.GA14261@lst.de>
 <20190819041132.GA14492@lst.de>
 <20190819042259.GZ6129@dread.disaster.area>
 <20190819042905.GA15613@lst.de>
 <20190819044012.GA15800@lst.de>
 <20190820044135.GC1119@dread.disaster.area>
 <20190820055320.GB27501@lst.de>
 <20190820081325.GA21032@ming.t460p>
 <20190820092424.GB21032@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820092424.GB21032@ming.t460p>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=pMd2aLFakC6OKW4P_fkA:9 a=Ks_RoGRITE5hVPj0:21
        a=N7sAeTi0DA08UszB:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 05:24:25PM +0800, Ming Lei wrote:
> On Tue, Aug 20, 2019 at 04:13:26PM +0800, Ming Lei wrote:
> > On Tue, Aug 20, 2019 at 07:53:20AM +0200, hch@lst.de wrote:
> > > On Tue, Aug 20, 2019 at 02:41:35PM +1000, Dave Chinner wrote:
> > > > > With the following debug patch.  Based on that I think I'll just
> > > > > formally submit the vmalloc switch as we're at -rc5, and then we
> > > > > can restart the unaligned slub allocation drama..
> > > > 
> > > > This still doesn't make sense to me, because the pmem and brd code
> > > > have no aligment limitations in their make_request code - they can
> > > > handle byte adressing and should not have any problem at all with
> > > > 8 byte aligned memory in bios.
> > > > 
> > > > Digging a little furhter, I note that both brd and pmem use
> > > > identical mechanisms to marshall data in and out of bios, so they
> > > > are likely to have the same issue.
> > > > 
> > > > So, brd_make_request() does:
> > > > 
> > > >         bio_for_each_segment(bvec, bio, iter) {
> > > >                 unsigned int len = bvec.bv_len;
> > > >                 int err;
> > > > 
> > > >                 err = brd_do_bvec(brd, bvec.bv_page, len, bvec.bv_offset,
> > > >                                   bio_op(bio), sector);
> > > >                 if (err)
> > > >                         goto io_error;
> > > >                 sector += len >> SECTOR_SHIFT;
> > > >         }
> > > > 
> > > > So, the code behind bio_for_each_segment() splits multi-page bvecs
> > > > into individual pages, which are passed to brd_do_bvec(). An
> > > > unaligned 4kB io traces out as:
> > > > 
> > > >  [  121.295550] p,o,l,s 00000000a77f0146,768,3328,0x7d0048
> > > >  [  121.297635] p,o,l,s 000000006ceca91e,0,768,0x7d004e
> > > > 
> > > > i.e. page		offset	len	sector
> > > > 00000000a77f0146	768	3328	0x7d0048
> > > > 000000006ceca91e	0	768	0x7d004e
> > > > 
> > > > You should be able to guess what the problems are from this.
> > 
> > The problem should be that offset of '768' is passed to bio_add_page().
> 
> It can be quite hard to deal with non-512 aligned sector buffer, since
> one sector buffer may cross two pages, so far one workaround I thought
> of is to not merge such IO buffer into one bvec.
> 
> Verma, could you try the following patch?
> 
> diff --git a/block/bio.c b/block/bio.c
> index 24a496f5d2e2..49deab2ac8c4 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -769,6 +769,9 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
>  	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
>  		return false;
>  
> +	if (off & 511)
> +		return false;

What does this acheive? It only prevents the unaligned segment from
being merged, it doesn't prevent it from being added to a new bvec.

However, the case here is that:

> > > > i.e. page		offset	len	sector
> > > > 00000000a77f0146	768	3328	0x7d0048
> > > > 000000006ceca91e	0	768	0x7d004e

The second page added to the bvec is actually offset alignedr. Hence
the check would do nothing on the first page because the bvec array
is empty (so goes into a new bvec anyway), and the check on the
second page would do nothing an it would merge with first because
the offset is aligned correctly. In both cases, the length of the
segment is not aligned, so that needs to be checked, too.

IOWs, I think the check needs to be in bio_add_page, it needs to
check both the offset and length for alignment, and it needs to grab
the alignment from queue_dma_alignment(), not use a hard coded value
of 511.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
