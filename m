Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E73C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 01:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 432DB610A2
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 01:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhIPBaj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 21:30:39 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:39356 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232068AbhIPBai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Sep 2021 21:30:38 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 81048107C09;
        Thu, 16 Sep 2021 11:29:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mQgDE-00CyFO-6q; Thu, 16 Sep 2021 11:29:16 +1000
Date:   Thu, 16 Sep 2021 11:29:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/61] libfrog: create header file for mocked-up kernel
 data structures
Message-ID: <20210916012916.GP2361455@dread.disaster.area>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174721123.350433.6338166230233894732.stgit@magnolia>
 <20210916004646.GO2361455@dread.disaster.area>
 <20210916005821.GC34899@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916005821.GC34899@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=gCINn5aPVK0uTo22BI8A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 15, 2021 at 05:58:21PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 16, 2021 at 10:46:46AM +1000, Dave Chinner wrote:
> > On Wed, Sep 15, 2021 at 04:06:51PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Create a mockups.h for mocked-up versions of kernel data structures to
> > > ease porting of libxfs code.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  include/libxfs.h     |    1 +
> > >  libfrog/Makefile     |    1 +
> > >  libfrog/mockups.h    |   19 +++++++++++++++++++
> > >  libxfs/libxfs_priv.h |    4 +---
> > >  4 files changed, 22 insertions(+), 3 deletions(-)
> > 
> > I don't really like moving this stuff to libfrog. The whole point of
> > libxfs/libxfs_priv.h is to define the kernel wrapper stuff that
> > libxfs needs to compile and should never be seen by anything outside
> > libxfs/...
> 
> How did you handle this in your xfsprogs port?  I /think/ the only
> reason we need the mockups is to handle the perag structure in xfs_ag.h?
> In that case, I guess one could simply omit the stuff below the "kernel
> only structures below this line" line?

I just put an #ifdef __KERNEL__ in the userspace code, like we
have in userspace libxfs/xfs_btree.c for the btree split hand-off
code.

> In that case, can you (or anyone, really) fix libxfs-compare to be smart
> enough to filter out the "#ifdef __KERNEL__" parts of libxfs from the
> diff?

You mean tools/libxfs-diff? I'm not sure that's a simple thing to do
because of the #else cases that go along with define in
xfs_btree.c. Is there really enough noise from libxfs-diff at the
moment that this is actually a problem?

As it is, my longer term plan it to actually properly support things
like spinlocks, atomics, rcu, etc in xfsprogs via pthread and
liburcu wrappers defined in include/<foo.h> that are xfsprogs wide.
At that point, the wrappers in libxfs/libxfs_priv.h then simply
disappear.

I'd prefer we move towards proper support for these primitives
rather than just rearranging how we mock them up...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
