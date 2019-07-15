Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57880 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731731AbfGORtx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 13:49:53 -0400
Date: Mon, 15 Jul 2019 10:49:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC 00/11] iomap: regroup code by functional area
Message-ID: <20190715174944.GC6147@magnolia>
References: <156200051933.1790352.5147420943973755350.stgit@magnolia>
 <20190708184652.GB20670@infradead.org>
 <20190709164952.GT1404256@magnolia>
 <20190709181214.GA31130@infradead.org>
 <20190715164307.GA6176@magnolia>
 <20190715165012.GA32624@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715165012.GA32624@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Jul 15, 2019 at 09:50:13AM -0700, Christoph Hellwig wrote:
> On Mon, Jul 15, 2019 at 09:43:07AM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 09, 2019 at 11:12:14AM -0700, Christoph Hellwig wrote:
> > > I looked over it and while some of the small files seem very tiny
> > > they are reasonably split.
> > > 
> > > What rather annoys me is the page.c/read.c/write.c split.  All these
> > > really belong mostly together, except maybe the super highlevel
> > > write code that then either calls into the buffer_head vs iomap_page
> > > based code.  By keeping them together we can eliminate most of
> > > iomap_internal.h and once the writeback code moves also keep
> > > iomap_page private to that bigger read.c file.
> > 
> > <nod> I think it makes sense to combine them into a single read_write.c
> > file or something.
> 
> page.c or buffered-io.c seems like sensible names to me.

buffered-io.c it is then.

> > >  - some of the copyrights for the small files seem totally wrong.
> > >    e.g. all the swapfile code was written by you, so it should not have
> > >    my or rh copyright notices on it
> > 
> > Will fix the swapfile code.
> 
> Please also look over the other files, a few of them should probably
> be just me (e.g. fiemap) and some have other authors (seek is mostly
> Andreas with a few later bits from me).

<nod> I'll edit the copyrights on fiemap.c.  I'm less sure about making
edits to seek.c because I don't know if Andreas has copyright ownership
or if RH slurped all that up -- the commits are from his @redhat.com
email.  I was about to resend the series so I'll cc him on it.

--D
