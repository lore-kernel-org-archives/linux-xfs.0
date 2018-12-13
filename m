Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49292 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727707AbeLMOZw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Dec 2018 09:25:52 -0500
Date: Thu, 13 Dec 2018 06:25:49 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] xfs: fixes for v4.20-rc6
Message-ID: <20181213142549.GA6708@infradead.org>
References: <20181208163639.GR24487@magnolia>
 <CAHk-=who9EqvvGaazise-dh7_DH6rLOULWXzysinyAPnHS4B0A@mail.gmail.com>
 <20181211135818.GA29626@infradead.org>
 <20181212181658.GA24487@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181212181658.GA24487@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, david@fromorbit.com, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Wed, Dec 12, 2018 at 10:16:58AM -0800, Darrick J. Wong wrote:
> On Tue, Dec 11, 2018 at 05:58:18AM -0800, Christoph Hellwig wrote:
> > On Sat, Dec 08, 2018 at 11:24:48AM -0800, Linus Torvalds wrote:
> > > Honestly, I really wish you simply wouldn't send me "xfs" fixes that
> > > aren't really xfs-specific at all.
> > > 
> > > All the splice patches (and honestly, I feel some of the iomap ones
> > > too) that have come in through the xfs tree should have been handled
> > > separately as actual VFS patches. Or at least had acks from Al or
> > > something.
> > 
> > iomap came in through the XFS tree originally, and has been very much
> > maintained in combo, even though we now have another user with gfs.
> > 
> > Maybe we just need to make that official in MAINTAINERS?
> 
> Yes, though who should be the official maintainer?  You wrote most of
> the iomap code; do you want to maintain it yourself?  Or have people
> funnel them wherever XFS patches go? :)

Well, the original version is from Dave, although I'm not sure if much
of that code is left.  I think just maintaining it with XFS is a good
idea.  But if we need an explicit maintainer I can do it.
