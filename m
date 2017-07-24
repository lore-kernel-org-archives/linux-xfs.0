Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932195AbdGXSgx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Jul 2017 14:36:53 -0400
Date: Mon, 24 Jul 2017 14:36:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: consolidate local format inode fork verifiers
Message-ID: <20170724183651.GA12942@bfoster.bfoster>
References: <20170719160318.GP4224@magnolia>
 <20170720022602.GR17762@dastard>
 <20170720055057.GQ4224@magnolia>
 <20170720224934.GW17762@dastard>
 <20170721135405.GB44069@bfoster.bfoster>
 <20170721230058.GY17762@dastard>
 <20170722122944.GA4783@bfoster.bfoster>
 <20170724052638.GD17762@dastard>
 <20170724130752.GA11537@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170724130752.GA11537@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Mon, Jul 24, 2017 at 09:07:52AM -0400, Brian Foster wrote:
> On Mon, Jul 24, 2017 at 03:26:38PM +1000, Dave Chinner wrote:
> > On Sat, Jul 22, 2017 at 08:29:44AM -0400, Brian Foster wrote:
> > > On Sat, Jul 22, 2017 at 09:00:58AM +1000, Dave Chinner wrote:
> > > > On Fri, Jul 21, 2017 at 09:54:05AM -0400, Brian Foster wrote:
> > > > > On Fri, Jul 21, 2017 at 08:49:34AM +1000, Dave Chinner wrote:
...
> 
> [1] A simple test that we can do at the moment is to compare a
> production xfs.ko with one with asserts enabled. My local for-next
> branch builds a module of 40104000 bytes without XFS_WARN and 40540208
> bytes with XFS_WARN enabled. That makes for a difference of ~425k and
> roughly a 1% code size increase (accounting for ~1750 asserts and
> supporting code).
> 

FWIW, the huge size here didn't register to me until Darrick mentioned
it on irc. I'm guessing I have a bunch of debug enabled in my kernel
config (that I don't really want to disable right now). If I strip the
resulting module binaries, I end up with 1076736 bytes vs. 1210624 bytes
(for a 130kb delta and ~12% increase), which I'm guessing is a more
accurate assessment.

Brian

> [2] We may not want to use ASSERT() here, but perhaps define a new
> variant to omit the stack trace and otherwise customize to a verifier
> report.
> 
> > Cheers,
> > 
> > Dave.
> > 
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
