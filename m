Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43059 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750884AbcJUKJO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2016 06:09:14 -0400
Date: Fri, 21 Oct 2016 03:09:11 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: About reflink len = 0 behavior
Message-ID: <20161021100911.GA22612@infradead.org>
References: <bedcb76a-4deb-bc0e-7a50-350a8a8db86f@cn.fujitsu.com>
 <94d643cc-fa49-4b20-b265-55d50af15e47@cn.fujitsu.com>
 <20161020154733.GA5436@vader>
 <20161021030005.GB5257@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161021030005.GB5257@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Omar Sandoval <osandov@osandov.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>, fstests@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>, linux-xfs@vger.kernel.org

On Thu, Oct 20, 2016 at 08:00:05PM -0700, Darrick J. Wong wrote:
> > > > For btrfs, dedupe will just return 0 and check nothing, while for xfs
> > > > len == 0 means to check the whole file length.
> > > > 
> > > > Both makes sense for me, for btrfs len = 0 behavior, it just follows
> > > > read/write functions.
> > > > And I assume xfs follows reflink behavior, when len is not specified,
> > > > then reflink the length of src file.
> 
> Yes.
> 
> > > > But since it's a generic test, we need to unify the behavior.
> > > > 
> > > > So, which one is the standard and which document should we follow for
> > > > such behavior definition?
> 
> <shrug> I suppose since it'll stop deduping at the first non-matching range,
> there's not a lot of point in having "dedupe to wherever is the end of the
> file" feature.
> 
> (Also, if he hasn't already, I'm sure Christoph will point out that we
> shouldn't really go changing the interface after the fact, even if the
> interface was mostly undocumented and afaict not tested by anything like
> xfstests for years...)

Yes, I'd prefer to stick to the btrfs behavior when XFS follow their
existing interface, unlesss said interface is clearly acknodged to be
broken by the original developers.

Now a 0 len as whole file sounds very useful, but I would prefer to get
an explicit buying from the btrfs crowd, and have btrfs implement it
properly first.
