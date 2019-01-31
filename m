Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35310 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726368AbfAaJKO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 04:10:14 -0500
Date: Thu, 31 Jan 2019 10:10:11 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/2] Revert "mm: don't reclaim inodes with many attached
 pages"
Message-ID: <20190131091011.GP18811@dhcp22.suse.cz>
References: <20190130041707.27750-1-david@fromorbit.com>
 <20190130041707.27750-2-david@fromorbit.com>
 <25EAF93D-BC63-4409-AF21-F45B2DDF5D66@fb.com>
 <20190131013403.GI4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131013403.GI4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Mason <clm@fb.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Roman Gushchin <guro@fb.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>

On Thu 31-01-19 12:34:03, Dave Chinner wrote:
> On Wed, Jan 30, 2019 at 12:21:07PM +0000, Chris Mason wrote:
> > 
> > 
> > On 29 Jan 2019, at 23:17, Dave Chinner wrote:
> > 
> > > From: Dave Chinner <dchinner@redhat.com>
> > >
> > > This reverts commit a76cf1a474d7dbcd9336b5f5afb0162baa142cf0.
> > >
> > > This change causes serious changes to page cache and inode cache
> > > behaviour and balance, resulting in major performance regressions
> > > when combining worklaods such as large file copies and kernel
> > > compiles.
> > >
> > > https://bugzilla.kernel.org/show_bug.cgi?id=202441
> > 
> > I'm a little confused by the latest comment in the bz:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=202441#c24
> 
> Which says the first patch that changed the shrinker behaviour is
> the underlying cause of the regression.
> 
> > Are these reverts sufficient?
> 
> I think so.
> 
> > Roman beat me to suggesting Rik's followup.  We hit a different problem 
> > in prod with small slabs, and have a lot of instrumentation on Rik's 
> > code helping.
> 
> I think that's just another nasty, expedient hack that doesn't solve
> the underlying problem. Solving the underlying problem does not
> require changing core reclaim algorithms and upsetting a page
> reclaim/shrinker balance that has been stable and worked well for
> just about everyone for years.

I tend to agree with Dave here. Slab pressure balancing is quite subtle
and easy to get wrong. If we want to plug the problem with offline
memcgs then the fix should be targeted at that problem. So maybe we want
to emulate high pressure on offline memcgs only. There might be other
issues to resolve for small caches but let's start with something more
targeted first please.
-- 
Michal Hocko
SUSE Labs
