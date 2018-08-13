Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:12447 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725849AbeHMF0w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Aug 2018 01:26:52 -0400
Date: Mon, 13 Aug 2018 12:46:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/14] xfs: repair free space btrees
Message-ID: <20180813024640.GB31495@dastard>
References: <20180807233458.GH30972@magnolia>
 <20180808122953.GB2819@bfoster>
 <20180808224232.GJ30972@magnolia>
 <20180809120027.GC21030@bfoster>
 <20180809155959.GK30972@magnolia>
 <20180810103351.GA27330@bfoster>
 <20180810153944.GC15083@magnolia>
 <20180810190740.GA27589@bfoster>
 <20180810193651.GE15083@magnolia>
 <20180811125049.GA35189@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180811125049.GA35189@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, allison.henderson@oracle.com

On Sat, Aug 11, 2018 at 08:50:49AM -0400, Brian Foster wrote:
> On Fri, Aug 10, 2018 at 12:36:51PM -0700, Darrick J. Wong wrote:
> > Technically we're not supposed to have flag days, but otoh this is a
> > xfs-only ioctl for a feature that's still experimental, so perhaps it's
> > not crucial to maintain compatibility with old kernels where the feature
> > is incomplete and experimental?
> > 
> 
> In my mind, I kind of take the experimental status as all bits/interface
> may explode and are otherwise subject to change or disappear. Perhaps
> others feel differently, it does seem we've kind of hinted towards the
> contrary recently with respect to the per-inode dax bits and then now in
> this discussion, but IMO that's kind of an inherent risk of doing
> incremental work on complex features upstream.

I've always considered that the experimental tag covers the
user/ioctl interfaces as much as it does the functionality and
on-disk format. i.e. like the on-disk format, the ioctl interfaces
are subject to change until we clear the exp. tag, at which point
they are essentially fixed forever. We /try/ not to have to change
them after the initial merge, but sometimes we screw up and need to
fix them before we commit to long term support.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
