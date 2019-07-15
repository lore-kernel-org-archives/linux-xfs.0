Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44454 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729941AbfGOQuN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 12:50:13 -0400
Date: Mon, 15 Jul 2019 09:50:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 00/11] iomap: regroup code by functional area
Message-ID: <20190715165012.GA32624@infradead.org>
References: <156200051933.1790352.5147420943973755350.stgit@magnolia>
 <20190708184652.GB20670@infradead.org>
 <20190709164952.GT1404256@magnolia>
 <20190709181214.GA31130@infradead.org>
 <20190715164307.GA6176@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715164307.GA6176@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Jul 15, 2019 at 09:43:07AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 09, 2019 at 11:12:14AM -0700, Christoph Hellwig wrote:
> > I looked over it and while some of the small files seem very tiny
> > they are reasonably split.
> > 
> > What rather annoys me is the page.c/read.c/write.c split.  All these
> > really belong mostly together, except maybe the super highlevel
> > write code that then either calls into the buffer_head vs iomap_page
> > based code.  By keeping them together we can eliminate most of
> > iomap_internal.h and once the writeback code moves also keep
> > iomap_page private to that bigger read.c file.
> 
> <nod> I think it makes sense to combine them into a single read_write.c
> file or something.

page.c or buffered-io.c seems like sensible names to me.

> >  - some of the copyrights for the small files seem totally wrong.
> >    e.g. all the swapfile code was written by you, so it should not have
> >    my or rh copyright notices on it
> 
> Will fix the swapfile code.

Please also look over the other files, a few of them should probably
be just me (e.g. fiemap) and some have other authors (seek is mostly
Andreas with a few later bits from me).
