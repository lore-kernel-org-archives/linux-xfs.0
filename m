Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727795AbfGHMPK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jul 2019 08:15:10 -0400
Date: Mon, 8 Jul 2019 08:15:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] mm, memcg: support memory.{min, low} protection in
 cgroup v1
Message-ID: <20190708121459.GB51396@bfoster>
References: <1562310330-16074-1-git-send-email-laoar.shao@gmail.com>
 <20190705090902.GF8231@dhcp22.suse.cz>
 <CALOAHbAw5mmpYJb4KRahsjO-Jd0nx1CE+m0LOkciuL6eJtavzQ@mail.gmail.com>
 <20190705111043.GJ8231@dhcp22.suse.cz>
 <CALOAHbA3PL6-sBqdy-sGKC8J9QGe_vn4-QU8J1HG-Pgn60WFJA@mail.gmail.com>
 <20190705151045.GI37448@bfoster>
 <20190705235222.GE7689@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705235222.GE7689@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Shakeel Butt <shakeelb@google.com>, Yafang Shao <shaoyafang@didiglobal.com>, linux-xfs@vger.kernel.org

On Sat, Jul 06, 2019 at 09:52:22AM +1000, Dave Chinner wrote:
> On Fri, Jul 05, 2019 at 11:10:45AM -0400, Brian Foster wrote:
> > cc linux-xfs
> > 
> > On Fri, Jul 05, 2019 at 10:33:04PM +0800, Yafang Shao wrote:
> > > On Fri, Jul 5, 2019 at 7:10 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > >
> > > > On Fri 05-07-19 17:41:44, Yafang Shao wrote:
> > > > > On Fri, Jul 5, 2019 at 5:09 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > [...]
> > > > > > Why cannot you move over to v2 and have to stick with v1?
> > > > > Because the interfaces between cgroup v1 and cgroup v2 are changed too
> > > > > much, which is unacceptable by our customer.
> > > >
> > > > Could you be more specific about obstacles with respect to interfaces
> > > > please?
> > > >
> > > 
> > > Lots of applications will be changed.
> > > Kubernetes, Docker and some other applications which are using cgroup v1,
> > > that will be a trouble, because they are not maintained by us.
> > > 
> > > > > It may take long time to use cgroup v2 in production envrioment, per
> > > > > my understanding.
> > > > > BTW, the filesystem on our servers is XFS, but the cgroup  v2
> > > > > writeback throttle is not supported on XFS by now, that is beyond my
> > > > > comprehension.
> > > >
> > > > Are you sure? I would be surprised if v1 throttling would work while v2
> > > > wouldn't. As far as I remember it is v2 writeback throttling which
> > > > actually works. The only throttling we have for v1 is reclaim based one
> > > > which is a huge hammer.
> > > > --
> > > 
> > > We did it in cgroup v1 in our kernel.
> > > But the upstream still don't support it in cgroup v2.
> > > So my real question is why upstream can't support such an import file system ?
> > > Do you know which companies  besides facebook are using cgroup v2  in
> > > their product enviroment?
> > > 
> > 
> > I think the original issue with regard to XFS cgroupv2 writeback
> > throttling support was that at the time the XFS patch was proposed,
> > there wasn't any test coverage to prove that the code worked (and the
> > original author never followed up). That has since been resolved and
> > Christoph has recently posted a new patch [1], which appears to have
> > been accepted by the maintainer.
> 
> I don't think the validation issue has been resolved.
> 
> i.e. we still don't have regression tests that ensure it keeps
> working it in future, or that it works correctly in any specific
> distro setting/configuration. The lack of repeatable QoS validation
> infrastructure was the reason I never merged support for this in the
> first place.
> 
> So while the (simple) patch to support it has been merged now,
> there's no guarantee that it will work as expected or continue to do
> so over the long run as nobody upstream or in distro land has a way
> of validating that it is working correctly.
> 
> From that perspective, it is still my opinion that one-off "works
> for me" testing isn't sufficient validation for a QoS feature that
> people will use to implement SLAs with $$$ penalities attached to
> QoS failures....
> 

We do have an fstest to cover the accounting bits (which is what the fs
is responsible for). Christoph also sent a patch[1] to enable that on
XFS. I'm sure there's plenty of room for additional/broader test
coverage, of course...

Brian

[1] https://marc.info/?l=fstests&m=156138385006173&w=2

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
