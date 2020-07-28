Return-Path: <SRS0=dxv4=BH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA219C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 15:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B968A2083B
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 15:48:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H4YtOBWa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgG1PsE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 11:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730817AbgG1PsE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jul 2020 11:48:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1221BC061794
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 08:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=owm66ntvOMM/uqdi202QYiAh0QI/3smNOAiSsIlfIs0=; b=H4YtOBWaYc8NtmSf84Ee+HhZ6u
        cZbiAYe9/x6mV89UmJzap7K4sgYGwFkokfjA6RDn2iUw4wGbZl+sjARWW+mqaSFKnmXxuTUqSypfW
        q8EOU3QLvpQUf/+mwoNt3PXHBeJw8E+YYtJNg9fcghKMsRhfPtGzHchQD3Zh8Y7iQ+p8AYOUqR4L8
        U5szuOwfRFd699KuJTC81FCP0tz9poUCGunUEEKN0TQPN8HOiRXXhSpnKv6EOTWcdnD3V8XVpTLIq
        HM3mYSBKi8DwF4ysIpM6RL5fvrmteutI0OL5g/iLyipyUsMJc1BBUIMrNqwhsil26DdZM3yWr0jpd
        8+hmmL+g==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0RpZ-0004LC-Cy; Tue, 28 Jul 2020 15:47:53 +0000
Date:   Tue, 28 Jul 2020 16:47:53 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Zhengyuan Liu <liuzhengyuang521@gmail.com>,
        linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [Question] About XFS random buffer write performance
Message-ID: <20200728154753.GS23808@casper.infradead.org>
References: <CAOOPZo45E+hVAo9S_2psMJQzrzwmVKo_WjWOM7Zwhm_CS0J3iA@mail.gmail.com>
 <20200728153453.GC3151642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728153453.GC3151642@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 28, 2020 at 08:34:53AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 28, 2020 at 07:34:39PM +0800, Zhengyuan Liu wrote:
> > Hi all,
> > 
> > When doing random buffer write testing I found the bandwidth on EXT4 is much
> > better than XFS under the same environment.
> > The test case ,test result and test environment is as follows:
> > Test case:
> > fio --ioengine=sync --rw=randwrite --iodepth=64 --size=4G --name=test
> > --filename=/mnt/testfile --bs=4k
> > Before doing fio, use dd (if=/dev/zero of=/mnt/testfile bs=1M
> > count=4096) to warm-up the file in the page cache.
> > 
> > Test result (bandwidth):
> >          ext4                   xfs
> >        ~300MB/s       ~120MB/s
> > 
> > Test environment:
> >     Platform:  arm64
> >     Kernel:  v5.7
> >     PAGESIZE:  64K
> >     Memtotal:  16G
> >     Storage: sata ssd(Max bandwidth about 350MB/s)
> >     FS block size: 4K
> > 
> > The  fio "Test result" shows that EXT4 has more than 2x bandwidth compared to
> > XFS, but iostat shows the transfer speed of XFS to SSD is about 300MB/s too.
> > So I debt XFS writing back many non-dirty blocks to SSD while  writing back
> > dirty pages. I tried to read the core writeback code of both
> > filesystem and found
> > XFS will write back blocks which is uptodate (seeing iomap_writepage_map()),
> 
> Ahhh, right, because iomap tracks uptodate separately for each block in
> the page, but only tracks dirty status for the whole page.  Hence if you
> dirty one byte in the 64k page, xfs will write all 64k even though we
> could get away writing 4k like ext4 does.
> 
> Hey Christoph & Matthew: If you're already thinking about changing
> struct iomap_page, should we add the ability to track per-block dirty
> state to reduce the write amplification that Zhengyuan is asking about?
> 
> I'm guessing that between willy's THP series, Dave's iomap chunks
> series, and whatever Christoph may or may not be writing, at least one
> of you might have already implemented this? :)

Well, this is good timing!  I was wondering whether something along
these lines was an important use-case.

I propose we do away with the 'uptodate' bit-array and replace it with an
'writeback' bit-array.  We set the page uptodate bit whenever the reads to
fill the page have completed rather than checking the 'writeback' array.
In page_mkwrite, we fill the writeback bit-array on the grounds that we
have no way to track a block's non-dirtiness and we don't want to scan
each block at writeback time to see if it's been written to.

I'll do this now before the THP series gets reposted.
