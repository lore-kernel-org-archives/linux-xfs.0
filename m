Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41521 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725762AbeICEg1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Sep 2018 00:36:27 -0400
Date: Mon, 3 Sep 2018 10:18:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 1/3] xfs: don't unlock invalidated buf on aborted tx
 commit
Message-ID: <20180903001848.GL5631@dastard>
References: <20180829172634.57981-1-bfoster@redhat.com>
 <20180829172634.57981-2-bfoster@redhat.com>
 <20180831072437.GA7079@infradead.org>
 <20180831132119.GB39825@bfoster>
 <20180901110502.GA29326@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180901110502.GA29326@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Sat, Sep 01, 2018 at 04:05:02AM -0700, Christoph Hellwig wrote:
> On Fri, Aug 31, 2018 at 09:21:19AM -0400, Brian Foster wrote:
> > > > +	} else if (stale) {
> > > > +		/*
> > > > +		 * Stale buffers remain locked until final unpin unless the bli
> > > > +		 * was freed in the branch above. A freed stale bli implies an
> > > > +		 * abort because buffer invalidation dirties the bli and
> > > > +		 * transaction.
> > > > +		 */
> > > > +		ASSERT(!freed);
> > > 
> > > This assert doesn't make sense as we're already in the else statement
> > > of the 'if (freed) check.
> > > 
> > 
> > It was intended to be defensive. I actually considered 'else if (freed
> > && stale)' so the code was more clear, but settled on this (which is
> > eventually replaced).
> 
> I see you've resend it, but I still object to an ASSERT(!freed) in
> an
> 
> 	if (freed) {
> 		..
> 	} else if (stale) {
> 		ASSEET(!freed);
> 	}
> 
> statement.  This isn't defensive but just bogus logic.

I'll drop it on commit.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
