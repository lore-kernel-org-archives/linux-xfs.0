Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:53355 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751284AbdDAXRq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Apr 2017 19:17:46 -0400
Date: Sun, 2 Apr 2017 09:17:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: move the inline directory verifiers
Message-ID: <20170401231743.GX23007@dastard>
References: <20170328150047.GB4874@birch.djwong.org>
 <20170328151105.GC4100@bfoster.bfoster>
 <20170328172444.GE4100@bfoster.bfoster>
 <20170329182156.GC4864@birch.djwong.org>
 <20170329224110.GL17542@dastard>
 <20170331160743.GB3255@infradead.org>
 <20170331162431.GF4864@birch.djwong.org>
 <20170331162817.GA8971@infradead.org>
 <20170331163836.GG4864@birch.djwong.org>
 <20170331164001.GA23577@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170331164001.GA23577@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 31, 2017 at 09:40:01AM -0700, Christoph Hellwig wrote:
> On Fri, Mar 31, 2017 at 09:38:36AM -0700, Darrick J. Wong wrote:
> > On Fri, Mar 31, 2017 at 09:28:17AM -0700, Christoph Hellwig wrote:
> > > On Fri, Mar 31, 2017 at 09:24:31AM -0700, Darrick J. Wong wrote:
> > > > I think xfs/348 causes -rc4 to fall over if CONFIG_XFS_DEBUG=y due to
> > > > the XFS_WANT_CORRUPTED_RETURNs that shouldn't be there.
> > > 
> > > Yes, that's the one.  How are we going to fix that for -rc5?
> > 
> > This patch fixes all the thinkos in the original patch, so I was just
> > going to send it to Linus for rc5, but decided to poll the ML to see if
> > anyone had an objection to that.
> 
> That's what I thought and was surprised by the reply from Dave..

There's no mention that it fixes a bug, regression or anything else
like that in the commit message. AFAICT from the description, it's
just a cleanup to match how the rest of the checking code is
structured with better error reporting.

Perhaps the commit message needs more work, because I can't tell you
what bug this is fixing from it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
