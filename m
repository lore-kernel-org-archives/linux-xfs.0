Return-Path: <SRS0=aQ/b=BI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4AAC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 13:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F14E206D4
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 13:02:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ab1LTwk6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgG2NCw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 09:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgG2NCw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jul 2020 09:02:52 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5CDC061794
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 06:02:52 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id s21so19289453ilk.5
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 06:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AXixw4uXTFX9KMZA6vGWL9eOkUmKci2Bq8L3QnLs9hs=;
        b=ab1LTwk6qii7cjYtJ0hbTjt3fq/WY/CtzeGx4DIz6HGk7LSneGRvxpEPf1K4RmYqEZ
         4mVsUMHz6QLLOLlh9xYb3kwk3XRxcEUhIF3KJOZB2c3w/QrUn1126/o1MJaRrMlEtwDx
         AyxtGUgmKplcqAsNp9/7ayWu9UNvt/NrX/Nk0+xt11YJ3FoQRrTEoNWBoVD7btpRv39I
         chGTxP25DZAM0U7wbYtxCGNs8LH14MrrBcbSZO8Y5IhR9lNKEgw2mNvMR1KuaDTJEUXD
         5w0gz0jdvN9mHotZM89G6pI0EmxyazS23tILureLh37yed0V5A+rtpZRshq/rikdXpiI
         xWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AXixw4uXTFX9KMZA6vGWL9eOkUmKci2Bq8L3QnLs9hs=;
        b=cPp3kpfRFtWM+vaXsHXskrYL8RaIAg1VdQPdiMrX6lAVSpw4tPDJVxJ7xTFik23h0k
         Y3I4lnCLh+R3OfiMhqzdJvWUanUACdHw8qmWVUmjvMT9JBLJIcKXq0z/DP7xpRn9+k2n
         ybWQrUhUj9cpIyQVa9tE/2aDSIiGdhLfl9akfOeWWk/yd/S8TF0qK+lanmnN1iGJspRY
         lsLV/El73wQXqu7kgxxvcIY/dtLqwN2mqW6Oqn02/8TO/+AZ1gS6l8Cgotd8st3OGJFx
         X5bzJQfqXIi/NowLcMaVxTPIKfaTQrMYY8pc4Fi4ccVPV+ybCNc6OiUgxJRzbcNhznle
         L7Nw==
X-Gm-Message-State: AOAM533KIohINqDp+6VQZ2khBoWI01sUTvdNJYdVm7esL+oubImbW/DN
        4UJykHoVqh6hq8KdyNrVxboVdHXMWTmU42SMJ/g=
X-Google-Smtp-Source: ABdhPJwFwBLvzPTDqbS/wQlJ29OMml1sEPD4/4/1fNCtbcEpenqti9kU1DLoIsHsOcx+5ahVB3/bBVfZJD3UwubSzdo=
X-Received: by 2002:a05:6e02:e43:: with SMTP id l3mr32782862ilk.11.1596027771157;
 Wed, 29 Jul 2020 06:02:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAOOPZo45E+hVAo9S_2psMJQzrzwmVKo_WjWOM7Zwhm_CS0J3iA@mail.gmail.com>
 <20200728153453.GC3151642@magnolia> <20200728154753.GS23808@casper.infradead.org>
 <20200729015458.GY2005@dread.disaster.area>
In-Reply-To: <20200729015458.GY2005@dread.disaster.area>
From:   Zhengyuan Liu <liuzhengyuang521@gmail.com>
Date:   Wed, 29 Jul 2020 21:02:39 +0800
Message-ID: <CAOOPZo7ikpJU2xN7+UWekpLe047C4cAMq_fxSWcRhzVqYUL8rA@mail.gmail.com>
Subject: Re: [Question] About XFS random buffer write performance
To:     Dave Chinner <david@fromorbit.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 29, 2020 at 9:55 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Jul 28, 2020 at 04:47:53PM +0100, Matthew Wilcox wrote:
> > On Tue, Jul 28, 2020 at 08:34:53AM -0700, Darrick J. Wong wrote:
> > > On Tue, Jul 28, 2020 at 07:34:39PM +0800, Zhengyuan Liu wrote:
> > > > Hi all,
> > > >
> > > > When doing random buffer write testing I found the bandwidth on EXT4 is much
> > > > better than XFS under the same environment.
> > > > The test case ,test result and test environment is as follows:
> > > > Test case:
> > > > fio --ioengine=sync --rw=randwrite --iodepth=64 --size=4G --name=test
> > > > --filename=/mnt/testfile --bs=4k
> > > > Before doing fio, use dd (if=/dev/zero of=/mnt/testfile bs=1M
> > > > count=4096) to warm-up the file in the page cache.
> > > >
> > > > Test result (bandwidth):
> > > >          ext4                   xfs
> > > >        ~300MB/s       ~120MB/s
> > > >
> > > > Test environment:
> > > >     Platform:  arm64
> > > >     Kernel:  v5.7
> > > >     PAGESIZE:  64K
> > > >     Memtotal:  16G
>
> So it's capturing roughly 2GB of random 4kB writes before it starts
> blocking waiting for writeback.
>
> What happens when you change the size of the file (say 512MB, 1GB,
> 2GB, 8GB, 16GB, etc)? Does this change the result at all?

I tested other file size as you wanted above and this is the result:
    Size        XFS         EXT4
    512M    1.5GB/s      1GB/s
    1G        1.5GB/s      1GB/s
    2G        1.4GB/s      800MB/s
    4G        120MB/s     290MB/s
    8G        60MB/s       280MB/s
For file size smaller than 2G, it is basically pure memory operation.
For file size bigger than 4G, the write amplification is more obvious, but
not always,if the file size exceeds the memory size we need to
reallocate page cache (e.g. I found the bandwidth was about 140BM/s
if I set the file size to be 16G).

> i.e. are we just looking at a specific behaviour triggered by the
> specific data set size?  I would suspect that the larger the file,
> the greater the performance differential as XFS will drive the SSD
> to be bandwidth bound before ext4, and that if you have a faster SSd
> (e.g. nvme on pcie 4x) there would be a much smaller difference as
> the workload won't end up IO bandwidth bound....
>
> I also suspect that you'll get a different result running on spinning
> disks. i.e., it is likely that you'll get the oppposite result (i.e
> XFS is faster than ext4) because each 64kB page write IO from XFS
> captures multiple 4KB user writes and so results in fewer seeks than
> ext4 doing individual 4kB IOs.

No obvious difference found when I tested a 4GB-file on the spinning
disk, both got about 8MB/s, although I agree with you that XFS should
be faster than ext4. Maybe there is something wrong with me.

I also did the same test on a Intel pcie-nvme  card which has a max
bandwidth about 2GB/s:
                    fio-bandwidth     nvme-bandwidth    cpu-usage
    XFS             600MB/s              1.8GB/s                 35%
    EXT4            850MB/s              850MB/s              100%
So the write amplification is always there, even though it may not
reach the bandwidth bound of a faster SSD, but the bandwidth it
wasted isn't something we expected.

>
> > > >     Storage: sata ssd(Max bandwidth about 350MB/s)
> > > >     FS block size: 4K
> > > >
> > > > The  fio "Test result" shows that EXT4 has more than 2x bandwidth compared to
> > > > XFS, but iostat shows the transfer speed of XFS to SSD is about 300MB/s too.
> > > > So I debt XFS writing back many non-dirty blocks to SSD while  writing back
> > > > dirty pages. I tried to read the core writeback code of both
> > > > filesystem and found
> > > > XFS will write back blocks which is uptodate (seeing iomap_writepage_map()),
> > >
> > > Ahhh, right, because iomap tracks uptodate separately for each block in
> > > the page, but only tracks dirty status for the whole page.  Hence if you
> > > dirty one byte in the 64k page, xfs will write all 64k even though we
> > > could get away writing 4k like ext4 does.
>
> Right, iomap intentionally went to a page granularity IO model for
> page cache IO, because that's what the page cache uses and largely
> gets rid of the need for tracking per-block page state.
>
> > > Hey Christoph & Matthew: If you're already thinking about changing
> > > struct iomap_page, should we add the ability to track per-block dirty
> > > state to reduce the write amplification that Zhengyuan is asking about?
> > >
> > > I'm guessing that between willy's THP series, Dave's iomap chunks
> > > series, and whatever Christoph may or may not be writing, at least one
> > > of you might have already implemented this? :)
> >
> > Well, this is good timing!  I was wondering whether something along
> > these lines was an important use-case.
> >
> > I propose we do away with the 'uptodate' bit-array and replace it with an
> > 'writeback' bit-array.  We set the page uptodate bit whenever the reads to
>
> That's just per-block dirty state tracking. But when we set a single
> bit, we still need to set the page dirty flag.
>
>
> > fill the page have completed rather than checking the 'writeback' array.
> > In page_mkwrite, we fill the writeback bit-array on the grounds that we
> > have no way to track a block's non-dirtiness and we don't want to scan
> > each block at writeback time to see if it's been written to.
>
> You're talking about mmap() access to the file here, not
> read/write() syscall access. If page_mkwrite() sets all the
> blocks in a page as "needing writeback", how is that different in
> any way to just using a single dirty bit? So why wouldn't we just do
> this in iomap_set_page_dirty()?
>
> The only place we wouldn't want to set the entire page dirty is
> the call from __iomap_write_end() which knows the exact range of the
> page that was dirtied. In which case, iomap_set_page_dirty_range()
> would be appropriate, right? i.e. we still have to do all the same
> page/page cache/inode dirtying, but only that would set a sub-page
> range of dirty bits in the iomap_page?
>
> /me doesn't see the point of calling dirty tracking "writeback bits"
> when "writeback" is a specific page state that comes between the
> "dirty" and "clean" states...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
