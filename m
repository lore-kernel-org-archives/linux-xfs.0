Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49342 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdHaPb5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 11:31:57 -0400
Date: Thu, 31 Aug 2017 08:31:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove experimental tag for reflinks
Message-ID: <20170831153148.GJ3775@magnolia>
References: <20170830145400.3681-1-hch@lst.de>
 <20170831064033.GF3775@magnolia>
 <20170831124321.GA21939@bfoster.bfoster>
 <20170831133019.GA5468@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831133019.GA5468@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>

On Thu, Aug 31, 2017 at 03:30:19PM +0200, Christoph Hellwig wrote:
> On Thu, Aug 31, 2017 at 08:43:21AM -0400, Brian Foster wrote:
> > FWIW, I don't really have a strong opinion. To me, removing experimental
> > means we feel the code has stabilized long enough in principle, there
> > are no significant problems (i.e., corruption/crash vectors) that we are
> > aware of and the feature is complete (full userspace tool support, etc).
> > The in-core extent list thing seems like more of a general problem to me
> 
> Agreed so far.

<nod> Dave?  Eric?  Any perspective you'd like to offer? :)

> > That aside, shouldn't we consider the rmapbt experimental tag first, or
> > at least at the same time? It's been around for slightly longer.
> 
> I've not done much testing on that or have experience with it in general,
> nor do I have a customer with a big QA team beating it hard, so I can't
> really comment on that one.

rmapbt will remain EXPERIMENTAL because I still have more patches to
send to finish the feature for realtime devices.  Speaking of which,
it's now been 53 weeks since the last dump of that, so I'll go do that
now. :P

FWIW I /also/ run rmapbt everywhere and haven't had any trouble with it
since adding the per-AG reservations.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
