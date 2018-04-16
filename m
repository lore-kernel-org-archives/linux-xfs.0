Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49090 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753961AbeDPI5J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Apr 2018 04:57:09 -0400
Date: Mon, 16 Apr 2018 01:57:07 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fs: xfs: Change return type to vm_fault_t
Message-ID: <20180416085707.GB30363@infradead.org>
References: <20180414200530.GA20184@jordon-HP-15-Notebook-PC>
 <20180414215937.GH5572@dastard>
 <20180414222407.GA15294@bombadil.infradead.org>
 <20180415072121.GA13601@infradead.org>
 <20180415111104.GB25513@bombadil.infradead.org>
 <20180415120426.GA10479@infradead.org>
 <20180415123427.GA11379@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180415123427.GA11379@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Souptick Joarder <jrdr.linux@gmail.com>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

On Sun, Apr 15, 2018 at 05:34:27AM -0700, Matthew Wilcox wrote:
> On Sun, Apr 15, 2018 at 05:04:26AM -0700, Christoph Hellwig wrote:
> > On Sun, Apr 15, 2018 at 04:11:04AM -0700, Matthew Wilcox wrote:
> > > > Please just send one damn patch adding the typedef and the sparse
> > > > annotation and converting everyone over.  Splitting this into five
> > > > gazillion patches that do nothing doesn't help anyone.
> > > 
> > > The XFS one is trivial.  Many of the others are not.
> > 
> > if they arne't trivial you are doing something wrong.  That is you
> > fix bugs that exist independent of the annotation together with the
> > annotation.
> > 
> > Fix all the bugs first, and send them in (including for -stable) and
> > then do the annotations in one big patch.
> 
> They aren't all bugs.  Some of them are just splitting errnos apart
> from return values for typesafety.  The ones that are bugfixes are
> unlikely-to-happen bugs like running out of memory when allocating a
> page table, and returning "we inserted the PTE" instead of "we ran out
> of memory".  More of a QOI issue than an exploitable bug.

Then do all the cleanups first and do the batch rename of the type after
that, same concept.

One patch per functional change, not one change per subsystem, please.
