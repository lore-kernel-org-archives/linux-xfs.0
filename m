Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:11875 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1031044AbeBNVWc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 16:22:32 -0500
Date: Thu, 15 Feb 2018 08:22:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: skip xfs_check in _check_xfs_filesystem
Message-ID: <20180214212228.GG7000@dastard>
References: <151803835881.19313.17455678207236452557.stgit@magnolia>
 <151803837117.19313.3481001926133028039.stgit@magnolia>
 <20180208125152.GE18267@eguan.usersys.redhat.com>
 <62eff3f5-b4fe-3c98-1cd2-c5b2b4ca4c70@sandeen.net>
 <20180214170254.GK5217@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180214170254.GK5217@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Feb 14, 2018 at 09:02:54AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 14, 2018 at 10:34:09AM -0600, Eric Sandeen wrote:
> > On 2/8/18 6:51 AM, Eryu Guan wrote:
> > > On Wed, Feb 07, 2018 at 01:19:31PM -0800, Darrick J. Wong wrote:
> > >> From: Darrick J. Wong <darrick.wong@oracle.com>
> > >>
> > >> xfs_check has been long obsolete, so stop running it automatically
> > >> after every test.  Tests that explicitly want xfs_check can call it
> > >> via _scratch_xfs_check or _xfs_check; that part doesn't go away.
> > >>
> > >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > I'd like to see an ACK on this from XFS community.
> > 
> > So, I thought we still had a local implementation of xfs_check-via-xfs_db
> > in xfstests as an intentional validation against xfs_repair:
> > 
> > +# xfs_check script is planned to be deprecated. But, we want to
> > +# be able to invoke "xfs_check" behavior in xfstests in order to
> > +# maintain the current verification levels.
> > +_xfs_check()
> > 
> > IOWS, "xfs_check is obsolete" is true for users/admins, but I thought
> > we were keeping it alive as a developer tool for now, and that it had
> > a place in xfstests.  No?
> > 
> > (But if it /is/ removed, wouldn't you kill off the _xfs_check() function as
> > well, to truly nuke it from orbit?)
> > 
> > Anyway, I don't think I understand the justification for this change;
> > it was explicitly kept alive in xfstests since commit 
> > 
> > 	187bccd xfstests: Remove dependence of xfs_check script
> > 
> > and "xfs_check is obsolete for admins" doesn't seem to be sufficient rationale.
> > 
> > What do we gain or lose by removing this from _check_xfs_filesystem?
> 
> xfs_check likes to consume memory, which means that it consistently runs
> out and segfaults when I run xfstests on a 1k block configuration.  It's
> also slow if the fs is really fragmented (which some of the reflink
> tests set up), so I figured I'd kill both birds with one patch by
> removing auto-xfscheck.

I don't see it run out of memory on my 1p, 1GB RAM, 1k block size
test VM, running on 10GB test, 20GB scratch devices....

> We /could/ leave it as a check against xfs_repair, but at this point we
> have three different fsck(ish) tools and maybe it's just time to get rid
> of check.  Consider that blockget didn't even support v5 filesystems
> until October 2015[1], which was ~2 years after v5 support landed in
> repair -- that convinced me (at the time) that nobody really cared about
> xfs_check anymore.

Actually, that was more a result of the developer who was doing all
the v5 work being made the as maintainer half way thru it's
experimental stage and that meant time to work on the non-critical
pieces of v5 support were pretty severely curtailed. i.e. it wasn't
because we never intended to support this, just resources and
priorities changed drastically around that time.

Once we get scrub doing everything check does and have some
confidence that it's working correctly, then we can remove the db
based check code. Right now we still rely on it to cross check
repair and scrub is about to drive a bunch of new changes to th
erepair code to fix up stuff it doesn't detect.  Once we've got to
the point that repair and scrub to the same level and have a bit
more confidence in the scrub code, then we can think about retiring
the db-based check code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
