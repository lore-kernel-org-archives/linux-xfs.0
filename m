Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A711C3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 07:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2200722DCC
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 07:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbfHTHps (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 03:45:48 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43574 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726049AbfHTHps (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 03:45:48 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1B72143D5AA;
        Tue, 20 Aug 2019 17:45:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hzyom-0003xG-Lj; Tue, 20 Aug 2019 17:44:36 +1000
Date:   Tue, 20 Aug 2019 17:44:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "hch@lst.de" <hch@lst.de>
Cc:     "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190820074436.GD1119@dread.disaster.area>
References: <20190818074140.GA18648@lst.de>
 <20190818173426.GA32311@lst.de>
 <20190819000831.GX6129@dread.disaster.area>
 <20190819034948.GA14261@lst.de>
 <20190819041132.GA14492@lst.de>
 <20190819042259.GZ6129@dread.disaster.area>
 <20190819042905.GA15613@lst.de>
 <20190819044012.GA15800@lst.de>
 <20190820044135.GC1119@dread.disaster.area>
 <20190820055320.GB27501@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820055320.GB27501@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=GkOCTHbDHqshCKWEzgMA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 07:53:20AM +0200, hch@lst.de wrote:
> On Tue, Aug 20, 2019 at 02:41:35PM +1000, Dave Chinner wrote:
> > > With the following debug patch.  Based on that I think I'll just
> > > formally submit the vmalloc switch as we're at -rc5, and then we
> > > can restart the unaligned slub allocation drama..
> > 
> > This still doesn't make sense to me, because the pmem and brd code
> > have no aligment limitations in their make_request code - they can
> > handle byte adressing and should not have any problem at all with
> > 8 byte aligned memory in bios.
> > 
> > Digging a little furhter, I note that both brd and pmem use
> > identical mechanisms to marshall data in and out of bios, so they
> > are likely to have the same issue.
> > 
> > So, brd_make_request() does:
> > 
> >         bio_for_each_segment(bvec, bio, iter) {
> >                 unsigned int len = bvec.bv_len;
> >                 int err;
> > 
> >                 err = brd_do_bvec(brd, bvec.bv_page, len, bvec.bv_offset,
> >                                   bio_op(bio), sector);
> >                 if (err)
> >                         goto io_error;
> >                 sector += len >> SECTOR_SHIFT;
> >         }
> > 
> > So, the code behind bio_for_each_segment() splits multi-page bvecs
> > into individual pages, which are passed to brd_do_bvec(). An
> > unaligned 4kB io traces out as:
> > 
> >  [  121.295550] p,o,l,s 00000000a77f0146,768,3328,0x7d0048
> >  [  121.297635] p,o,l,s 000000006ceca91e,0,768,0x7d004e
> > 
> > i.e. page		offset	len	sector
> > 00000000a77f0146	768	3328	0x7d0048
> > 000000006ceca91e	0	768	0x7d004e
> > 
> > You should be able to guess what the problems are from this.
> > 
> > Both pmem and brd are _sector_ based. We've done a partial sector
> > copy on the first bvec, then the second bvec has started the copy
> > from the wrong offset into the sector we've done a partial copy
> > from.
> > 
> > IOWs, no error is reported when the bvec buffer isn't sector
> > aligned, no error is reported when the length of data to copy was
> > not a multiple of sector size, and no error was reported when we
> > copied the same partial sector twice.
> 
> Yes.  I think bio_for_each_segment is buggy here, as it should not
> blindly split by pages.  CcingMing as he wrote much of this code.  I'll
> also dig into fixing it, but I just arrived in Japan and might be a
> little jetlagged.
> 
> > There's nothing quite like being repeatedly bitten by the same
> > misalignment bug because there's no validation in the infrastructure
> > that could catch it immediately and throw a useful warning/error
> > message.
> 
> The xen block driver doesn't use bio_for_each_segment, so it isn't
> exactly the same but a very related issue. 

Both stem from the fact that nothing in the block layer validates
memory alignment constraints. Xenblk, pmem and brd all return 511 to
queue_dma_alignment(), and all break when passed memory that isn't
aligned to 512 bytes.  There aren't even debug options we can turn
on that would tell use this is happening. Instead, we start with
data corruption and have to work backwards to find the needle in the
haystack from there. EIO and a WARN_ONCE would be a massive
improvement here....

> Maybe until we sort
> all this mess out we just need to depend on !SLUB_DEBUG for XFS?

SLUB_DEBUG=y by itself doesn't cause problems - I run that
all the time because otherwise there's no /proc/slabinfo with slub.

I used KASAN to get the above alignment behaviour - it's
SLUB_DEBUG_ON=y that perturbs the alignment, and I think the same
thing can happen with SLAB_DEBUG=y, so there's several dependencies
we'd have to add here.

Is there any way we can pass kmalloc a "use aligned heap" GFP flag
so that it allocates from the -rcl slabs to guarantee alignment
rather than the standard slabs that change alignment with config
options?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
