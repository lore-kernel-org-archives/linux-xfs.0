Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41704 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfF1W17 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 18:27:59 -0400
Date: Fri, 28 Jun 2019 22:27:56 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 11/12] iomap: move the xfs writeback code to iomap.c
Message-ID: <20190628222756.GM19023@42.do-not-panic.com>
References: <20190624055253.31183-1-hch@lst.de>
 <20190624055253.31183-12-hch@lst.de>
 <20190624234304.GD7777@dread.disaster.area>
 <20190625101020.GI1462@lst.de>
 <20190628004542.GJ7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628004542.GJ7777@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Brendan Higgins <brendanhiggins@google.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jun 28, 2019 at 10:45:42AM +1000, Dave Chinner wrote:
> On Tue, Jun 25, 2019 at 12:10:20PM +0200, Christoph Hellwig wrote:
> > On Tue, Jun 25, 2019 at 09:43:04AM +1000, Dave Chinner wrote:
> > > I'm a little concerned this is going to limit what we can do
> > > with the XFS IO path because now we can't change this code without
> > > considering the direct impact on other filesystems. The QA burden of
> > > changing the XFS writeback code goes through the roof with this
> > > change (i.e. we can break multiple filesystems, not just XFS).
> > 
> > Going through the roof is a little exaggerated.
> 
> You've already mentioned two new users you want to add. I don't even
> have zone capable hardware here to test one of the users you are
> indicating will use this code, and I suspect that very few people
> do.  That's a non-trivial increase in testing requirements for
> filesystem developers and distro QA departments who will want to
> change and/or validate this code path.

A side topic here:

Looking towards the future of prosects here with regards to helping QA
and developers with more confidence in API changes (kunit is one
prospect we're evaluating)...

If... we could somehow... codify what XFS *requires* from the API
precisely...  would that help alleviate concerns or bring confidence in
the prospect of sharing code?

Or is it simply an *impossibility* to address these concerns in question by
codifying tests for the promised API?

Ie, are the concerns something which could be addressed with strict
testing on adherence to an API, or are the concerns *unknown* side
dependencies which could not possibly be codified?

As an example of the extent possible to codify API promise (although
I beleive it was unintentional at first), see:

http://lkml.kernel.org/r/20190626021744.GU19023@42.do-not-panic.com

  Luis
