Return-Path: <SRS0=aQ/b=BI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 460B7C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 01:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25AFA22CB1
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 01:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbgG2BzL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 21:55:11 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:47851 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728401AbgG2BzL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jul 2020 21:55:11 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 84B3D10676C;
        Wed, 29 Jul 2020 11:55:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k0bJ5-0002DA-0I; Wed, 29 Jul 2020 11:54:59 +1000
Date:   Wed, 29 Jul 2020 11:54:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Zhengyuan Liu <liuzhengyuang521@gmail.com>,
        linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [Question] About XFS random buffer write performance
Message-ID: <20200729015458.GY2005@dread.disaster.area>
References: <CAOOPZo45E+hVAo9S_2psMJQzrzwmVKo_WjWOM7Zwhm_CS0J3iA@mail.gmail.com>
 <20200728153453.GC3151642@magnolia>
 <20200728154753.GS23808@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728154753.GS23808@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=54W2vMxcrCYB_z3ejGAA:9 a=bV3nX3049HCpF6Oh:21 a=NQJUQbIoccpt3rAq:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 28, 2020 at 04:47:53PM +0100, Matthew Wilcox wrote:
> On Tue, Jul 28, 2020 at 08:34:53AM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 28, 2020 at 07:34:39PM +0800, Zhengyuan Liu wrote:
> > > Hi all,
> > > 
> > > When doing random buffer write testing I found the bandwidth on EXT4 is much
> > > better than XFS under the same environment.
> > > The test case ,test result and test environment is as follows:
> > > Test case:
> > > fio --ioengine=sync --rw=randwrite --iodepth=64 --size=4G --name=test
> > > --filename=/mnt/testfile --bs=4k
> > > Before doing fio, use dd (if=/dev/zero of=/mnt/testfile bs=1M
> > > count=4096) to warm-up the file in the page cache.
> > > 
> > > Test result (bandwidth):
> > >          ext4                   xfs
> > >        ~300MB/s       ~120MB/s
> > > 
> > > Test environment:
> > >     Platform:  arm64
> > >     Kernel:  v5.7
> > >     PAGESIZE:  64K
> > >     Memtotal:  16G

So it's capturing roughly 2GB of random 4kB writes before it starts
blocking waiting for writeback.

What happens when you change the size of the file (say 512MB, 1GB,
2GB, 8GB, 16GB, etc)? Does this change the result at all?

i.e. are we just looking at a specific behaviour triggered by the
specific data set size?  I would suspect that the larger the file,
the greater the performance differential as XFS will drive the SSD
to be bandwidth bound before ext4, and that if you have a faster SSd
(e.g. nvme on pcie 4x) there would be a much smaller difference as
the workload won't end up IO bandwidth bound....

I also suspect that you'll get a different result running on spinning
disks. i.e., it is likely that you'll get the oppposite result (i.e
XFS is faster than ext4) because each 64kB page write IO from XFS
captures multiple 4KB user writes and so results in fewer seeks than
ext4 doing individual 4kB IOs.

> > >     Storage: sata ssd(Max bandwidth about 350MB/s)
> > >     FS block size: 4K
> > > 
> > > The  fio "Test result" shows that EXT4 has more than 2x bandwidth compared to
> > > XFS, but iostat shows the transfer speed of XFS to SSD is about 300MB/s too.
> > > So I debt XFS writing back many non-dirty blocks to SSD while  writing back
> > > dirty pages. I tried to read the core writeback code of both
> > > filesystem and found
> > > XFS will write back blocks which is uptodate (seeing iomap_writepage_map()),
> > 
> > Ahhh, right, because iomap tracks uptodate separately for each block in
> > the page, but only tracks dirty status for the whole page.  Hence if you
> > dirty one byte in the 64k page, xfs will write all 64k even though we
> > could get away writing 4k like ext4 does.

Right, iomap intentionally went to a page granularity IO model for
page cache IO, because that's what the page cache uses and largely
gets rid of the need for tracking per-block page state.

> > Hey Christoph & Matthew: If you're already thinking about changing
> > struct iomap_page, should we add the ability to track per-block dirty
> > state to reduce the write amplification that Zhengyuan is asking about?
> > 
> > I'm guessing that between willy's THP series, Dave's iomap chunks
> > series, and whatever Christoph may or may not be writing, at least one
> > of you might have already implemented this? :)
> 
> Well, this is good timing!  I was wondering whether something along
> these lines was an important use-case.
> 
> I propose we do away with the 'uptodate' bit-array and replace it with an
> 'writeback' bit-array.  We set the page uptodate bit whenever the reads to

That's just per-block dirty state tracking. But when we set a single
bit, we still need to set the page dirty flag.


> fill the page have completed rather than checking the 'writeback' array.
> In page_mkwrite, we fill the writeback bit-array on the grounds that we
> have no way to track a block's non-dirtiness and we don't want to scan
> each block at writeback time to see if it's been written to.

You're talking about mmap() access to the file here, not
read/write() syscall access. If page_mkwrite() sets all the
blocks in a page as "needing writeback", how is that different in
any way to just using a single dirty bit? So why wouldn't we just do
this in iomap_set_page_dirty()?

The only place we wouldn't want to set the entire page dirty is
the call from __iomap_write_end() which knows the exact range of the
page that was dirtied. In which case, iomap_set_page_dirty_range()
would be appropriate, right? i.e. we still have to do all the same
page/page cache/inode dirtying, but only that would set a sub-page
range of dirty bits in the iomap_page?

/me doesn't see the point of calling dirty tracking "writeback bits"
when "writeback" is a specific page state that comes between the
"dirty" and "clean" states...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
