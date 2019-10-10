Return-Path: <SRS0=apCn=YD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69759C4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 07:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D57C218AC
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 07:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733122AbfJJHiJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Oct 2019 03:38:09 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34031 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733056AbfJJHa1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Oct 2019 03:30:27 -0400
Received: from dread.disaster.area (pa49-195-199-207.pa.nsw.optusnet.com.au [49.195.199.207])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F270743E930;
        Thu, 10 Oct 2019 18:30:21 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iIStw-0001K4-Iw; Thu, 10 Oct 2019 18:30:20 +1100
Date:   Thu, 10 Oct 2019 18:30:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>,
        linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org, rgoldwyn@suse.de,
        gujx@cn.fujitsu.com, qi.fuli@fujitsu.com, caoj.fnst@cn.fujitsu.com
Subject: Re: [RFC PATCH 0/7] xfs: add reflink & dedupe support for fsdax.
Message-ID: <20191010073020.GI16973@dread.disaster.area>
References: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
 <20191009063144.GA4300@infradead.org>
 <20191009171152.GF13108@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009171152.GF13108@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=U3CgBz6+VuTzJ8lMfNbwVQ==:117 a=U3CgBz6+VuTzJ8lMfNbwVQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=7-415B0cAAAA:8 a=KLqftw6RVRZ3hi40DLEA:9 a=oZXh2kF1ifLAk1_0:21
        a=fGh-JakunK8VnCng:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 10:11:52AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 08, 2019 at 11:31:44PM -0700, Christoph Hellwig wrote:
> > Btw, I just had a chat with Dan last week on this.  And he pointed out
> > that while this series deals with the read/write path issues of 
> > reflink on DAX it doesn't deal with the mmap side issue that
> > page->mapping and page->index can point back to exactly one file.
> > 
> > I think we want a few xfstests that reflink a file and then use the
> > different links using mmap, as that should blow up pretty reliably.
> 
> Hmm, you're right, we don't actually have a test that checks the
> behavior of mwriting all copies of a shared block.  Ok, I'll go write
> one.

I've pointed this problem out to everyone who has asked me "what do
we need to do to support reflink on DAX". I've even walked a couple
of people right through the problem that needs to be solved and
discussed the potential solutions to it.

Problems that I think need addressing:

	- device dax and filesystem dax have fundamentally different
	  needs in this space, so they need to be separated and not
	  try to use the same solution.
	- dax_lock_entry() being used as a substitute for
	  page_lock() but it not being held on the page itself means
	  it can't be extended to serialise access to the page
	  across multiple mappings that are unaware of each other
	- dax_lock_page/dax_unlock_page interface for hardware
	  memory errors needs to report to the
	  filesystem for processing and repair, not assume the page
	  is user data and killing processes is the only possible
	  recovery mechanism.
	- dax_associate_entry/dax_disassociate_entry can only work
	  for a 1:1 page:mapping,index relationship. It needs to go
	  away and be replaced by a mechanism that allows
	  tracking multiple page mapping/index/state tuples. This
	  has much wider use than DAX (e.g. sharing page cache pages
	  between reflinked files)

I've proposed shadow pages (based on a concept from Matethw Wilcox)
for each read-only reflink mapping with the real physical page being
owned by the filesystem and indexed by LBA in the filesystem buffer
cache. This would be based on whether the extent in the file the
page is mapped from has multiple references to it.

i.e. When a new page mapping occurs in a shared extent, we add the
page to the buffer cache (i.e. point a struct xfs_buf at it)i if it
isn't already present, then allocate a shadow page, point it at the
master, set it up with the new mapping,index tuple and add it to the
mapping tree. Then we can treat it as a unique page even though it
points to the read-only master page.

When the page get's COWed, we toss away the shadow page and the
master can be reclaimed with the reference count goes to zero or the
extent is no longer shared.  Think of it kind of like the way we
multiply reference the zero page for holes in mmap()d dax regions,
except we can have millions of them and they are found by physical
buffer cache index lookups. 

This works for both DAX and non-DAX sharing of read-only shared
filesytsem pages. i.e. it would form the basis of single-copy
read-only page cache pages for reflinked files.

There was quite a bit of talk at LSFMM 2018 about having a linked
list of mapping structures hanging off a struct page, one for each
mapping that references the page. Operations would then have to walk
all mappings that reference the page. This was useful to other
subsystems (HMM?) for some purpose I forget, but I'm not sure it's
particularly useful by itself for non-dax reflink purposes - I
suspect the filesystem would still need to track such pages itself
in it's buffer cache so it can find the cached page to link new
reflink copies to the same page...

ISTR a couple of other solutions were thrown around, but I don't
think anyone came up with a simple solution...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
