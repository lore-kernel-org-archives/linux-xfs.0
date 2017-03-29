Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:2559 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752656AbdC2WlT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2017 18:41:19 -0400
Date: Thu, 30 Mar 2017 09:41:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: move the inline directory verifiers
Message-ID: <20170329224110.GL17542@dastard>
References: <20170327230315.GB4864@birch.djwong.org>
 <20170328125104.GA4100@bfoster.bfoster>
 <20170328150047.GB4874@birch.djwong.org>
 <20170328151105.GC4100@bfoster.bfoster>
 <20170328172444.GE4100@bfoster.bfoster>
 <20170329182156.GC4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170329182156.GC4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 29, 2017 at 11:21:57AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 28, 2017 at 01:24:44PM -0400, Brian Foster wrote:
> > On Tue, Mar 28, 2017 at 11:11:05AM -0400, Brian Foster wrote:
> > > On Tue, Mar 28, 2017 at 08:00:47AM -0700, Darrick J. Wong wrote:
> > > > On Tue, Mar 28, 2017 at 08:51:05AM -0400, Brian Foster wrote:
> > > > > On Mon, Mar 27, 2017 at 04:03:15PM -0700, Darrick J. Wong wrote:
> > > > > > The inline directory verifiers should be called on the inode fork data,
> > > > > > which means after iformat_local on the read side, and prior to
> > > > > > ifork_flush on the write side.  This makes the fork verifier more
> > > > > > consistent with the way buffer verifiers work -- i.e. they will operate
> > > > > > on the memory buffer that the code will be reading and writing directly.
> > > > > > 
> > > > > > Also revise the verifier function to return -EFSCORRUPTED so that we
> > > > > > don't flood the logs with corruption messages and assert notices.
> > > > > > 
> > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > ---
> > > > > > v2: get the inode d_ops the proper way
> > > > > > ---
> > > > > 
> > > > > What does this apply against?
> > > > 
> > > > It ought to apply against the previous inline dir verifier patch.
> > > > 
> > > 
> > > Hm, doesn't apply against [1] for me. Care to just repost these as a
> > > series if the dependent code hasn't been merged yet?
> > > 
> > > Brian
> > > 
> > > [1] https://patchwork.kernel.org/patch/9626859/
> > > 
> > 
> > I lost track of the fact that the first patch went into -rc and thus
> > confused myself over where this should apply. This applies to 4.11.0-rc4
> > and looks fine to me:
> 
> Does anyone have a problem if I send this to Linus for 4.11-rc5?
> I'd rather atone for my sins sooner than later. :)

There's no urgency required here - it's just a cleanup patch. The
code in the tree works fine, so why risk adding regressions
at a late stage? Just add it to the for-next queue and let it soak
until the merge window.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
