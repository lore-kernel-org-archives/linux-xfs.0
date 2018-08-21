Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:18222 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726814AbeHVC7I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Aug 2018 22:59:08 -0400
Date: Wed, 22 Aug 2018 09:36:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/10] xfs: convert mount flags to features
Message-ID: <20180821233652.GM31495@dastard>
References: <20180820044851.414-1-david@fromorbit.com>
 <20180820044851.414-5-david@fromorbit.com>
 <20180821132203.GC15030@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180821132203.GC15030@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 21, 2018 at 09:22:04AM -0400, Brian Foster wrote:
> On Mon, Aug 20, 2018 at 02:48:45PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Replace m_flags feature checks with xfs_has_<feature>() calls and
> > rework the setup code to set flags in m_features.
> > 
> > Fallout is that there are some attr2/noattr2 changes - there's no
> > longer separate feature flags for the attr2 superblock and attr2
> > mount options - they both set the same flag. Hence we use the
> > noattr2 feature to trigger turning off attr2 at mount time - it
> > doesn't matter if it is the mount option or the sb feature that set
> > it, specifying noattr2 will turn off attr2 for the current mount and
> > clear it from the sb feature set.
> > 
> > [Discuss: Might be worth moving the attr2 changes into a separate
> > patch so it's clear what changes are being made.]
> > 
> 
> Yeah, a separate patch to condense the attr bits might be a good idea.

ok.

> It also looks like some iosize feature changes crept in here that should
> have been in a previous patch..?

No change, just a small reformats of the logic to use
common stacked if/else if/else rather than nested if/ternary
constructs. I can split it into another patch if you really want.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
