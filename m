Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0265CC3A59E
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 00:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD75C21848
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 00:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfHVAcm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 20:32:42 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46810 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727038AbfHVAcm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Aug 2019 20:32:42 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F312143D96E;
        Thu, 22 Aug 2019 10:32:39 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0b0m-0004TW-1I; Thu, 22 Aug 2019 10:31:32 +1000
Date:   Thu, 22 Aug 2019 10:31:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: add kmem_alloc_io()
Message-ID: <20190822003131.GR1119@dread.disaster.area>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-3-david@fromorbit.com>
 <20190821232440.GB24904@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821232440.GB24904@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=0GnI0VYItIVuTeV953gA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 21, 2019 at 04:24:40PM -0700, Christoph Hellwig wrote:
> > +
> > +/*
> > + * __vmalloc() will allocate data pages and auxillary structures (e.g.
> > + * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context here. Hence
> > + * we need to tell memory reclaim that we are in such a context via
> > + * PF_MEMALLOC_NOFS to prevent memory reclaim re-entering the filesystem here
> > + * and potentially deadlocking.
> > + */
> 
> Btw, I think we should eventually kill off KM_NOFS and just use
> PF_MEMALLOC_NOFS in XFS, as the interface makes so much more sense.
> But that's something for the future.

Yeah, and it's not quite as simple as just using PF_MEMALLOC_NOFS
at high levels - we'll still need to annotate callers that use KM_NOFS
to avoid lockdep false positives. i.e. any code that can be called from
GFP_KERNEL and reclaim context will throw false positives from
lockdep if we don't annotate tehm correctly....

> > +/*
> > + * Same as kmem_alloc_large, except we guarantee a 512 byte aligned buffer is
> > + * returned. vmalloc always returns an aligned region.
> > + */
> > +void *
> > +kmem_alloc_io(size_t size, xfs_km_flags_t flags)
> > +{
> > +	void	*ptr;
> > +
> > +	trace_kmem_alloc_io(size, flags, _RET_IP_);
> > +
> > +	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> > +	if (ptr) {
> > +		if (!((long)ptr & 511))
> 
> Please use unsigned long (or uintptr_t if you want to be fancy),
> and (SECTOR_SIZE - 1).

Already changed it to uintptr_t when I did...

> 
> As said elsewhere if we want to be fancy we should probably pass a
> request queue or something pointing to it.

.... this. Well, not exactly this - I pass in the alignment required
as an int, and the callers get it from the request queue....

> But then again I don't think
> it really matters much, it would save us the reallocation with slub debug
> for a bunch of scsi adapters that support dword aligned I/O.  But last
> least the interface would be a little more obvious.

Yup, just smoke testing it now before I resend.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
