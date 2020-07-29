Return-Path: <SRS0=aQ/b=BI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FEC3C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 23:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50F802067D
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 23:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgG2XFL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 19:05:11 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:43489 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726876AbgG2XFK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jul 2020 19:05:10 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id F0C0710D97D;
        Thu, 30 Jul 2020 09:05:05 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k0v8B-0001JY-S5; Thu, 30 Jul 2020 09:05:03 +1000
Date:   Thu, 30 Jul 2020 09:05:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Zhengyuan Liu <liuzhengyuang521@gmail.com>,
        linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [Question] About XFS random buffer write performance
Message-ID: <20200729230503.GA2005@dread.disaster.area>
References: <CAOOPZo45E+hVAo9S_2psMJQzrzwmVKo_WjWOM7Zwhm_CS0J3iA@mail.gmail.com>
 <20200728153453.GC3151642@magnolia>
 <20200728154753.GS23808@casper.infradead.org>
 <20200729015458.GY2005@dread.disaster.area>
 <20200729021231.GV23808@casper.infradead.org>
 <20200729051923.GZ2005@dread.disaster.area>
 <20200729185035.GX23808@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729185035.GX23808@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=47ypV6lSEWvv8tlunWIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 29, 2020 at 07:50:35PM +0100, Matthew Wilcox wrote:
> On Wed, Jul 29, 2020 at 03:19:23PM +1000, Dave Chinner wrote:
> > On Wed, Jul 29, 2020 at 03:12:31AM +0100, Matthew Wilcox wrote:
> > > On Wed, Jul 29, 2020 at 11:54:58AM +1000, Dave Chinner wrote:
> > > > On Tue, Jul 28, 2020 at 04:47:53PM +0100, Matthew Wilcox wrote:
> > > > > I propose we do away with the 'uptodate' bit-array and replace it with an
> > > > > 'writeback' bit-array.  We set the page uptodate bit whenever the reads to
> > > > 
> > > > That's just per-block dirty state tracking. But when we set a single
> > > > bit, we still need to set the page dirty flag.
> > > 
> > > It's not exactly dirty, though.  It's 'present' (ie the opposite
> > > of hole). 
> > 
> > Careful with your terminology. At the page cache level, there is no
> > such thing as a "hole". There is only data and whether the data is
> > up to date or not. The page cache may be *sparsely populated*, but
> > a lack of a page or a range of the page that is not up to date
> > does not imply there is a -hole in the file- at that point.
> 
> That's not entirely true.  The current ->uptodate array does keep
> track of whether an unwritten extent is currently a hole (see
> page_cache_seek_hole_data()).  I don't know how useful that is.

"unwritten extent is currently a hole"

Ummm, by definition, and unwritten extent it *not* a hole in the
file. It's an allocated extent that is marked as containing zeroes.

SEEK_HOLE uses the definition that "any contiguous run of zeros may
be considered a hole" and from that, we present unwritten extents as
"holes" to userspace so they don't have to copy them when doing
sparse file operations. This does not mean what the iomap_page
uptodate array is doing is tracking a "hole" in the page.

What page_cache_seek_hole_data() is doing here is determining
whether the range of the page contains -data- or not. If it is
uptodate, then it contains data. If it is not uptodate, then it
does not contain data, and because it is over an unwritten extent,
that means it *must* contain be zeros and for the purposes of
SEEK_DATA/SEEK_HOLE, that means it is considered a hole.

This is an SEEK_HOLE/SEEK_DATA API implementation detail - it uses
the uptodate state of a page over an unwritten extent to determine
if user data has been initialised over the unwritten extent -in
memory- but that data hasn't yet reached disk. Having initialised
data in memory means the range is classified as data, if there is no
data then it is a hole. IOWs, the uptodate bits tell us whether
there is -valid data in the cache for that range-, not whether the
page range spans a hole in the file.

> > I'm still not sure what "present" is supposed to mean, though,
> > because it seems no different to "up to date". The data is present
> > once it's been read into the page, calling page_mkwrite() on the
> > page doesn't change that at all.
> 
> I had a bit of a misunderstanding.  Let's discard that proposal
> and discuss what we want to optimise for, ignoring THPs.  We don't
> need to track any per-block state, of course.  We could implement
> __iomap_write_begin() by reading in the entire page (skipping the last
> few blocks if they lie outside i_size, of course) and then marking the
> entire page Uptodate.

__iomap_write_begin() already does read-around for sub-page writes.
And, if necessary, it does zeroing of unwritten extents, newly
allocated ranges and ranges beyond EOF and marks them uptodate
appropriately.

> Buffer heads track several bits of information about each block:
>  - Uptodate (contents of cache at least as recent as storage)
>  - Dirty (contents of cache more recent than storage)
>  - ... er, I think all the rest are irrelevant for iomap


Yes, it is. And we optimised out the dirty tracking by just using
the single dirty bit in the page.

> I think I just talked myself into what you were arguing for -- that we
> change the ->uptodate bit array into a ->dirty bit array.
> 
> That implies that we lose the current optimisation that we can write at
> a blocksize alignment into the page cache and not read from storage.

iomap does not do that. It always reads the entire page in, even for
block aligned sub-page writes. IIRC, we even allocate on page
granularity for sub-page block size filesystems so taht we fill
holes and can do full page writes in writeback because this tends to
significantly reduce worst case file fragmentation for random sparse
writes...

> I'm personally fine with that; most workloads don't care if you read
> extra bytes from storage (hence readahead), but writing unnecessarily
> to storage (particularly flash) is bad.

Modern really SSDs don't care about runs of zeros being written.
They compress and/or deduplicate such things on the fly as part of
their internal write-amplification reduction strategies. Pretty much
all SSDs on the market these days - consumer or enterprise - do this
sort of thing in their FTLs and so writing more than the exact
changed data really doesn't make a difference.

Indeed, if we were to write in flash page sized chunks, we'd be
doing the SSDs a major favour because then they don't have to do
sub-page defragmentation to be able to erase blocks and continue
writing. If you look at where interfaces like Micron's HSE stuff is
going, that's all based around optimising writes to only be done at
erase block granularity and all the copy-on-write stuff is done up
in the application running on the host...

So optimising for small writes on modern SSDs is really only about
minimising the data transfer bandwidth required for lots and lots of
small sub page writes. That's what this specific test showed; XFS
ran of out IO bandwidth before ext4 did. Put it SSD on a pcie
interface that has bandwidth to burn, and it's likely a very
different story...

> Or we keep two bits per block.  The implementation would be a little icky,
> but it could be done.
> 
> I like the idea of getting rid of partially uptodate pages.  I've never
> really understood the concept.  For me, a partially dirty page makes a
> lot more sense than a partially uptodate page.  Perhaps I'm just weird.

I think we ended up with partially uptodate tracking because it was
a direct translation of the bufferhead uptodate tracking. Similarly
we have read and write io counts which translated from bufferhead
sub-page IO tracking to determine when to process IO completion.

I agree, I don't think we need the uptodate tracking anymore because
we do IO in full pages already. As for sub page dirtying, I'd need
to see the implementation and the numbers before deciding on that...

The other thing to consider is that some filesytems still use
bufferheads with iomap (e.g. gfs2) and so we might be completely
missing something here w.r.t. partially up to date state. That will
need careful audit, too.

> Speaking of weird, I don't understand why an unwritten extent queries
> the uptodate bits.  Maybe that's a buffer_head thing and we can just
> ignore it -- iomap doesn't have such a thing as a !uptodate page any
> more.

It's a direct translation of the code as it existed when partially
uptodate pages could exist in the cache. The page cache seek
hole/data code is not iomap specific, and so filesystems that use
those helpers may well have partially up to date pages.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
