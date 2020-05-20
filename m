Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA0EC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7060620829
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgETBOj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:14:39 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:58819 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726178AbgETBOi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:14:38 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id CFEF7D7A31B;
        Wed, 20 May 2020 11:14:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbDJW-0001Q7-BI; Wed, 20 May 2020 11:14:30 +1000
Date:   Wed, 20 May 2020 11:14:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [XFS SUMMIT] Deprecating V4 on-disk format
Message-ID: <20200520011430.GS2040@dread.disaster.area>
References: <20200513023618.GA2040@dread.disaster.area>
 <20200519062338.GH17627@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519062338.GH17627@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=rX3DrgsQOmbXhv9XyLgA:9 a=r_4S-qBi8RMIXnkB:21 a=A6MUwPdZ-W_0Vq8o:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 11:23:38PM -0700, Darrick J. Wong wrote:
> On Wed, May 13, 2020 at 12:36:18PM +1000, Dave Chinner wrote:
> > 
> > Topic: Deprecating V4 On-disk Format
> > 
> > Scope:
> > 	Long term life cycle planning
> > 	Supporting old filesystems with new kernels.
> > 	Unfixable integrity issues in v4 format.
> > 	Reducing feature matrix for testing
> > 
> > Proposal:
> > 
> > The CRC-enabled V5 format has been the upstream default format now
> > since commit 566ebd5ae5fa ("mkfs: default to CRC enabled
> > filesystems") dated May 11 2015 (5 years ago!) and released in
> > xfsprogs v3.2.3. It is the default in all major distros, and has
> > been for some time.
> > 
> > We know that the v4 format has unfixable integrity issues apart from
> > the obvious lack of CRCs and self-describing metadata structures; it
> > has race conditions in log recovery realted to inode creation and
> > other such issues that could only be solved with an on-disk format
> > change of some kind. We are not adding new features to v4 formats,
> > so anyone wanting to use new XFS features must use v5 format
> > filesystems.
> > 
> > We also know that the number of v4 filesysetms in production is
> > slowly decreasing as systems are replaced as part of the natural
> > life cycle of production systems.
> > 
> > All this adds up to the realisation that existing v4 filesystems are
> > effectively in the "Maintenance Mode" era of the software life
> > cycle. The next stage in the life cycle is "Phasing Out" before we
> > drop support for it altogether, also know around here as
> > "deprecated" which is a sign that support will "soon" cease.
> > 
> > I'd like to move the v4 format to the "deprecated" state as a signal
> > to users that it should really not be considered viable for new
> > systems. New systems running modern kernels and userspace should
> > all be using the v5 format, so this mostly only affects existing
> > filesystems.
> > 
> > Note: I am not proposing that we drop support for the v4 format any
> > time soon. What I am proposing is an "end of lifecycle" tag similar
> > to the way we use EXPERIMENTAL to indicate that the functionality is
> > available but we don't recommend it for production systems yet.
> > 
> > Hence what I am proposing is that we introduce a DEPRECATED alert at
> > mount time to inform users that the functionality exists, but it
> > will not be maintained indefinitely into the future. For distros
> > with a ten year support life, this means that a near-future release
> > will pick up the DEPRECATED tag but still support the filesystem for
> > the support life of that release. A "future +1" release may not
> > support the v4 format at all.
> 
> /me regrets that he is frequently failing to clear enough space out of
> his schedule to respond to all of these adequately.  But here goes,
> random thoughts at 23:23. :/
> 
> > Discussion points:
> > 
> > - How practical is this?
> 
> Well, we've killed off old features before... v1 inodes, v2 directories,
> etc.  So clearly this can be done, given enough preparation time.
> 
> And we probably ought to do it, before we start to resemble the ext4
> quota nightmare.

*nod*

> 
> > - What should we have mkfs do when directed to create a v4 format
> >   filesystem?
> 
> It probably ought to print a warning...
> 
> That said, way back when we were arguing with the syzbot people, one of
> us suggested that we hide V4 behind a CONFIG_XFS_DEPRECATED=y option, so
> that people who want to harden their kernel against the unfixable
> structural problems in the V4 format could effectively lose V4 support
> early.  Maybe we should add that for a few years?

That sounds like a good idea - being able to config it out provides
a mechanism to isolate v4 only code paths over time....

> > - How long before we decide to remove v4 support from the upstream
> >   kernel and tools? 5 years after deprecation? 10 years?
> 
> That probably depends a lot on how much our respective employers want to
> keep those old XFSes going.  Some of our customers are about ready to
> certify that they can support their distro defaults changing from ext3
> to XFS v4, but those folks have support contracts that won't terminate
> until whenever the so^Hun goes out.

Well, there's a difference between what a distro that heavily
patches the upstream kernel is willing to support and what upstream
supports. And, realistically, v4 is going to be around for at least
one more major distro release, which means the distro support time
window is still going to be in the order of 15 years.

However, with the way typical enterprise feature policies work, a
feature needs to be deprecated for a major release before it can be
removed.

So, realistically, the deprecation decision is not for the near term
- it's for dropping support in the "current + 2" major release that
nobody is even thinking about yet. i.e. if we don't deprecate it
in the next couple of years, then we'll still need to be
maintaining the v4 filesystem format in upstream for the next 15
years. Which, IMO, is about 10 years too long...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
