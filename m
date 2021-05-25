Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 806A7C2B9F8
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 09:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E49561419
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 09:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbhEYJJa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 05:09:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40666 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230511AbhEYJJa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 05:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621933680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aDbbTwcRr5v6bYS+KU6OmvJU1JnCoGIkoyMWX5doibE=;
        b=X1cSX0WPpse5+mVky7JG5mJz92LR5ceadMdbDSCh08wUe/lKenw6ySsKjJ8vDQKO0t3P0k
        3hOzVcvNVFMUnfXJF01WT9q7ZYDY1QrQr4x0RXkiUD55J8lBgJDZB9/lv87bV/YBM1u9Ve
        MexHYXglH5rkOBgXe1N8qnNSKS6nxDU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-ZPqAkDIRPtSEuk1hrF3lcw-1; Tue, 25 May 2021 05:07:59 -0400
X-MC-Unique: ZPqAkDIRPtSEuk1hrF3lcw-1
Received: by mail-wr1-f69.google.com with SMTP id 22-20020adf82960000b02901115ae2f734so14308790wrc.5
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 02:07:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aDbbTwcRr5v6bYS+KU6OmvJU1JnCoGIkoyMWX5doibE=;
        b=CYhibMCV7Jx/5mbh9h0muV5se5Q5ydF6y4Y7kGP/mxWtF/pIERC2vROcZfPmZEwcER
         UEh1AOU1zuktmw11PMkXqwNBpl7e4NoiGtPCC5ZyNvUN8tXU50k/qMA74yABwUYoxYKK
         tJg/gcsQTejSFGPvbSDNpIVo/TZvT4j9b3zLFYi5BNLgoYtF41Mhm/Ut95vlArHVN37l
         W5yzwkiy80ZXNJu9IEbG9IFP1qmgqj+8gTnhH0i4yxagfnosFr8+P7FOxOeiGxie7Nc4
         WqxKzNezXOOIfvOR5dyQAdWlrHGG46LWlDMpCUH/RrfBu9AlCsN3NTUxqIOO/naTGIEQ
         B6tg==
X-Gm-Message-State: AOAM532gXJzJB+mwYKzvqDIENU4GcAjmruIDS4BpQgx2Csi9LgirGUTn
        jcxPIYSOH2ETWTlmaWOAlL5GMNGImWqxhXmIb6Oh7aOSwBQmQkVZWowkZKKsShIhRxhp4TPrRjX
        Nk8mwTmMNj/MUKR4UdriVKE6/vM9Ody4DOvRv
X-Received: by 2002:adf:e589:: with SMTP id l9mr27091288wrm.361.1621933677863;
        Tue, 25 May 2021 02:07:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCbE5LU211WCLqTkDkjWVHvXJl43n1Q6gl700U9gXom60WJFMpL7Fwnlg8ld1lguKHLmp6R3YExoOfJFqrhGQ=
X-Received: by 2002:adf:e589:: with SMTP id l9mr27091268wrm.361.1621933677647;
 Tue, 25 May 2021 02:07:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210517171722.1266878-1-bfoster@redhat.com> <20210517171722.1266878-4-bfoster@redhat.com>
 <20210520232737.GA9675@magnolia> <YKuVymtSYhrDCytP@bfoster> <20210525042035.GE202121@locust>
In-Reply-To: <20210525042035.GE202121@locust>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Tue, 25 May 2021 11:07:46 +0200
Message-ID: <CAHc6FU5LkhX+jkp+RyR2Ogsu2EPB3=wPA2+mmCdc3jGCMkHBag@mail.gmail.com>
Subject: Re: [PATCH RFC v3 3/3] iomap: bound ioend size to 4096 pages
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 25, 2021 at 6:20 AM Darrick J. Wong <djwong@kernel.org> wrote:
> On Mon, May 24, 2021 at 08:02:18AM -0400, Brian Foster wrote:
> > On Thu, May 20, 2021 at 04:27:37PM -0700, Darrick J. Wong wrote:
> > > On Mon, May 17, 2021 at 01:17:22PM -0400, Brian Foster wrote:
> > > > The iomap writeback infrastructure is currently able to construct
> > > > extremely large bio chains (tens of GBs) associated with a single
> > > > ioend. This consolidation provides no significant value as bio
> > > > chains increase beyond a reasonable minimum size. On the other hand,
> > > > this does hold significant numbers of pages in the writeback
> > > > state across an unnecessarily large number of bios because the ioend
> > > > is not processed for completion until the final bio in the chain
> > > > completes. Cap an individual ioend to a reasonable size of 4096
> > > > pages (16MB with 4k pages) to avoid this condition.
> > > >
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >  fs/iomap/buffered-io.c |  6 ++++--
> > > >  include/linux/iomap.h  | 26 ++++++++++++++++++++++++++
> > > >  2 files changed, 30 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > > > index 642422775e4e..f2890ee434d0 100644
> > > > --- a/fs/iomap/buffered-io.c
> > > > +++ b/fs/iomap/buffered-io.c
> > > > @@ -1269,7 +1269,7 @@ iomap_chain_bio(struct bio *prev)
> > > >
> > > >  static bool
> > > >  iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t offset,
> > > > -         sector_t sector)
> > > > +         unsigned len, sector_t sector)
> > > >  {
> > > >   if ((wpc->iomap.flags & IOMAP_F_SHARED) !=
> > > >       (wpc->ioend->io_flags & IOMAP_F_SHARED))
> > > > @@ -1280,6 +1280,8 @@ iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t offset,
> > > >           return false;
> > > >   if (sector != bio_end_sector(wpc->ioend->io_bio))
> > > >           return false;
> > > > + if (wpc->ioend->io_size + len > IOEND_MAX_IOSIZE)
> > > > +         return false;
> > > >   return true;
> > > >  }
> > > >
> > > > @@ -1297,7 +1299,7 @@ iomap_add_to_ioend(struct inode *inode, loff_t offset, struct page *page,
> > > >   unsigned poff = offset & (PAGE_SIZE - 1);
> > > >   bool merged, same_page = false;
> > > >
> > > > - if (!wpc->ioend || !iomap_can_add_to_ioend(wpc, offset, sector)) {
> > > > + if (!wpc->ioend || !iomap_can_add_to_ioend(wpc, offset, len, sector)) {
> > > >           if (wpc->ioend)
> > > >                   list_add(&wpc->ioend->io_list, iolist);
> > > >           wpc->ioend = iomap_alloc_ioend(inode, wpc, offset, sector, wbc);
> > > > diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> > > > index 07f3f4e69084..89b15cc236d5 100644
> > > > --- a/include/linux/iomap.h
> > > > +++ b/include/linux/iomap.h
> > > > @@ -203,6 +203,32 @@ struct iomap_ioend {
> > > >   struct bio              io_inline_bio;  /* MUST BE LAST! */
> > > >  };
> > > >
> > > > +/*
> > > > + * Maximum ioend IO size is used to prevent ioends from becoming unbound in
> > > > + * size. bios can reach 4GB in size if pages are contiguous, and bio chains are
> > > > + * effectively unbound in length. Hence the only limits on the size of the bio
> > > > + * chain is the contiguity of the extent on disk and the length of the run of
> > > > + * sequential dirty pages in the page cache. This can be tens of GBs of physical
> > > > + * extents and if memory is large enough, tens of millions of dirty pages.
> > > > + * Locking them all under writeback until the final bio in the chain is
> > > > + * submitted and completed locks all those pages for the legnth of time it takes
> > >
> > > s/legnth/length/
> > >
> >
> > Fixed.
> >
> > > > + * to write those many, many GBs of data to storage.
> > > > + *
> > > > + * Background writeback caps any single writepages call to half the device
> > > > + * bandwidth to ensure fairness and prevent any one dirty inode causing
> > > > + * writeback starvation. fsync() and other WB_SYNC_ALL writebacks have no such
> > > > + * cap on wbc->nr_pages, and that's where the above massive bio chain lengths
> > > > + * come from. We want large IOs to reach the storage, but we need to limit
> > > > + * completion latencies, hence we need to control the maximum IO size we
> > > > + * dispatch to the storage stack.
> > > > + *
> > > > + * We don't really have to care about the extra IO completion overhead here
> > > > + * because iomap has contiguous IO completion merging. If the device can sustain
> > >
> > > Assuming you're referring to iomap_finish_ioends, only XFS employs the
> > > ioend completion merging, and only for ioends where it decides to
> > > override the default bi_end_io.  iomap on its own never calls
> > > iomap_ioend_try_merge.
> > >
> > > This patch establishes a maximum ioend size of 4096 pages so that we
> > > don't trip the lockup watchdog while clearing pagewriteback and also so
> > > that we don't pin a large number of pages while constructing a big chain
> > > of bios.  On gfs2 and zonefs, each ioend completion will now have to
> > > clear up to 4096 pages from whatever context bio_endio is called.
> > >
> > > For XFS it's a more complicated -- XFS already overrode the bio handler
> > > for ioends that required further metadata updates (e.g. unwritten
> > > conversion, eof extension, or cow) so that it could combine ioends when
> > > possible.  XFS wants to combine ioends to amortize the cost of getting
> > > the ILOCK and running transactions over a larger number of pages.
> > >
> > > So I guess I see how the two changes dovetail nicely for XFS -- iomap
> > > issues smaller write bios, and the xfs ioend worker can recombine
> > > however many bios complete before the worker runs.  As a bonus, we don't
> > > have to worry about situations like the device driver completing so many
> > > bios from a single invocation of a bottom half handler that we run afoul
> > > of the soft lockup timer.
> > >
> > > Is that a correct understanding of how the two changes intersect with
> > > each other?  TBH I was expecting the two thresholds to be closer in
> > > value.
> > >
> >
> > I think so. That's interesting because my inclination was to make them
> > farther apart (or more specifically, increase the threshold in this
> > patch and leave the previous). The primary goal of this series was to
> > address the soft lockup warning problem, hence the thresholds on earlier
> > versions started at rather conservative values. I think both values have
> > been reasonably justified in being reduced, though this patch has a more
> > broad impact than the previous in that it changes behavior for all iomap
> > based fs'. Of course that's something that could also be addressed with
> > a more dynamic tunable..
>
> <shrug> I think I'm comfortable starting with 256 for xfs to bump an
> ioend to a workqueue, and 4096 pages as the limit for an iomap ioend.
> If people demonstrate a need to smart-tune or manual-tune we can always
> add one later.
>
> Though I guess I did kind of wonder if maybe a better limit for iomap
> would be max_hw_sectors?  Since that's the maximum size of an IO that
> the kernel will for that device?
>
> (Hm, maybe not; my computers all have it set to 1280k, which is a
> pathetic 20 pages on a 64k-page system.)
>
> > > The other two users of iomap for buffered io (gfs2 and zonefs) don't
> > > have a means to defer and combine ioends like xfs does.  Do you think
> > > they should?  I think it's still possible to trip the softlockup there.
> > >
> >
> > I'm not sure. We'd probably want some feedback from developers of
> > filesystems other than XFS before incorporating a change like this. The
> > first patch in the series more just provides some infrastructure for
> > other filesystems to avoid the problem as they see fit.
>
> Hmm.  Any input from the two other users of iomap buffered IO?  Who are
> now directly in the to: list? :D
>
> Catch-up TLDR: we're evaluating a proposal to limit the length of an
> iomap writeback ioend to 4096 pages so that we don't trip the hangcheck
> warning while clearing pagewriteback if the ioend completion happens to
> run in softirq context (e.g. nvme completion).

That's fine for gfs2. Due to the way our allocator works, our extents
typically are at most 509 blocks long (< 2 MB), which already limits
the maximum size. We have plans for fixing that, but even then, any
somewhat sane limit should do.

Thanks,
Andreas

