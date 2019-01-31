Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47696 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728423AbfAaS5U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 13:57:20 -0500
From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 1/2] Revert "mm: don't reclaim inodes with many attached
 pages"
Date: Thu, 31 Jan 2019 18:57:10 +0000
Message-ID: <20190131185704.GA8755@castle.DHCP.thefacebook.com>
References: <20190130041707.27750-1-david@fromorbit.com>
 <20190130041707.27750-2-david@fromorbit.com>
 <25EAF93D-BC63-4409-AF21-F45B2DDF5D66@fb.com> <20190131013403.GI4205@dastard>
 <20190131091011.GP18811@dhcp22.suse.cz>
In-Reply-To: <20190131091011.GP18811@dhcp22.suse.cz>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E840709697C48B40B7F55D8803373219@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <clm@fb.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>

On Thu, Jan 31, 2019 at 10:10:11AM +0100, Michal Hocko wrote:
> On Thu 31-01-19 12:34:03, Dave Chinner wrote:
> > On Wed, Jan 30, 2019 at 12:21:07PM +0000, Chris Mason wrote:
> > >=20
> > >=20
> > > On 29 Jan 2019, at 23:17, Dave Chinner wrote:
> > >=20
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > >
> > > > This reverts commit a76cf1a474d7dbcd9336b5f5afb0162baa142cf0.
> > > >
> > > > This change causes serious changes to page cache and inode cache
> > > > behaviour and balance, resulting in major performance regressions
> > > > when combining worklaods such as large file copies and kernel
> > > > compiles.
> > > >
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=3D202441
> > >=20
> > > I'm a little confused by the latest comment in the bz:
> > >=20
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D202441#c24
> >=20
> > Which says the first patch that changed the shrinker behaviour is
> > the underlying cause of the regression.
> >=20
> > > Are these reverts sufficient?
> >=20
> > I think so.
> >=20
> > > Roman beat me to suggesting Rik's followup.  We hit a different probl=
em=20
> > > in prod with small slabs, and have a lot of instrumentation on Rik's=
=20
> > > code helping.
> >=20
> > I think that's just another nasty, expedient hack that doesn't solve
> > the underlying problem. Solving the underlying problem does not
> > require changing core reclaim algorithms and upsetting a page
> > reclaim/shrinker balance that has been stable and worked well for
> > just about everyone for years.
>=20
> I tend to agree with Dave here. Slab pressure balancing is quite subtle
> and easy to get wrong. If we want to plug the problem with offline
> memcgs then the fix should be targeted at that problem. So maybe we want
> to emulate high pressure on offline memcgs only. There might be other
> issues to resolve for small caches but let's start with something more
> targeted first please.

First, the path proposed by Dave is not regression-safe too. A slab object
can be used by other cgroups as well, so creating an artificial pressure on
the dying cgroup might perfectly affect the rest of the system. We do repar=
ent
slab lists on offlining, so there is even no easy way to iterate over them.
Also, creating an artifical pressure will create unnecessary CPU load.

So I'd really prefer to make the "natural" memory pressure to be applied
in a way, that doesn't leave any stalled objects behind.

Second, the code around slab pressure is not "worked well for years": as I =
can
see the latest major change was made about a year ago by Josef Bacik
(9092c71bb724 "mm: use sc->priority for slab shrink targets").

The existing balance, even if it works perfectly for some cases, isn't some=
thing
set in stone. We're really under-scanning small cgroups, and I strongly bel=
ieve
that what Rik is proposing is a right thing to do. If we don't scan objects
in small cgroups unless we have really strong memory pressure, we're basica=
lly
wasting memory.

And it really makes no sense to reclaim inodes with tons of attached pageca=
che
as easy as "empty" inodes. At the end, all we need is to free some memory, =
and
treating a sub-page object equal to many thousands page object is just stra=
nge.
If it's simple "wrong" and I do miss something, please, explain. Maybe we n=
eed
something more complicated than in my patch, but saying that existing code =
is
just perfect and can't be touched at all makes no sense to me.

So, assuming all this, can we, please, first check if Rik's patch is addres=
sing
the regression?

Thanks!
