Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35654 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751013AbeELCI1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 22:08:27 -0400
Date: Fri, 11 May 2018 19:08:23 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/10] xfs: one-shot cached buffers
Message-ID: <20180512020823.GA4937@magnolia>
References: <20180511225107.27171-1-david@fromorbit.com>
 <20180511225107.27171-2-david@fromorbit.com>
 <20180512002448.GM11261@magnolia>
 <20180512020606.GA10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180512020606.GA10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Sat, May 12, 2018 at 12:06:06PM +1000, Dave Chinner wrote:
> On Fri, May 11, 2018 at 05:24:48PM -0700, Darrick J. Wong wrote:
> > On Sat, May 12, 2018 at 08:50:58AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > For the new growfs work, we want to ensure that we serialise
> > > secondary superblock updates with other operations (e.g. scrub)
> > > correctly, but we don't want to cache the buffers for long term
> > > reuse. We need cached buffers for serialisation, however.
> > > 
> > > To solve this, introduce a "oneshot" buffer which will be marshalled
> > > through the cache but then released once the last current reference
> > > goes away. If the buffer is already cached, then we ignore the
> > > "one-shot" behaviour and leave the buffer in the state it was prior
> > > to the one-shot command being run. This means we don't perturb
> > > either the working set or existing cached buffer state by a one-shot
> > > operation.
> > > 
> > > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > 
> > Hmm, should the xfs_sb_read_secondary function in "xfs: superblock scrub
> > should use short-lived buffers" be calling this to set a zero lru_ref
> > instead of doing it directly?
> 
> That's not yet merged, is it? I'm guessing that it all depends on
> what order everything gets merged - we can clean up all the loose
> ends once we get everything in?

I... already have a series of cleanups to go in after online repair
lands, so I don't mind tacking more on. 8-)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
