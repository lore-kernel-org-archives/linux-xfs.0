Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48934 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751456AbdAITao (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 14:30:44 -0500
Date: Mon, 9 Jan 2017 11:30:38 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/7] reflink: fix quota tests to work properly
Message-ID: <20170109193038.GA14033@birch.djwong.org>
References: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
 <148357830178.7677.13949115107817848755.stgit@birch.djwong.org>
 <20170109085514.GZ1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170109085514.GZ1859@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Jan 09, 2017 at 04:55:14PM +0800, Eryu Guan wrote:
> On Wed, Jan 04, 2017 at 05:05:01PM -0800, Darrick J. Wong wrote:
> > Fix the reflink quota tests to su to the fsgqa user so that we actually
> > test enforcement of quotas.  Seems that XFS enforces user quotas even
> > if root is writing to a user file, whereas everything else lets root
> > writes through.  Also clean up some of the variable usage and
> > _require_user.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: Refactor the quota block reporting into a helper function and
> > port all the existing tests.  Fix "fsgqa"/$qa_user usage too.
> > ---
> >  common/quota          |   10 ++++++++++
> >  tests/generic/305     |   22 ++++++++++------------
> >  tests/generic/305.out |   30 +++++++++++++++---------------
> >  tests/generic/326     |   22 ++++++++++------------
> >  tests/generic/326.out |   30 +++++++++++++++---------------
> >  tests/generic/327     |   19 +++++++++----------
> >  tests/generic/327.out |   12 ++++++------
> >  tests/generic/328     |   29 ++++++++++++++---------------
> >  tests/generic/328.out |   28 ++++++++++++++--------------
> >  tests/xfs/213         |   22 ++++++++++------------
> >  tests/xfs/213.out     |   30 +++++++++++++++---------------
> >  tests/xfs/214         |   22 ++++++++++------------
> >  tests/xfs/214.out     |   30 +++++++++++++++---------------
> >  13 files changed, 153 insertions(+), 153 deletions(-)
> > 
> > 
> > diff --git a/common/quota b/common/quota
> > index d4ae861..5c6e680 100644
> > --- a/common/quota
> > +++ b/common/quota
> > @@ -302,5 +302,15 @@ _check_quota_usage()
> >  	}
> >  }
> >  
> > +# Report the block usage of root, $qa_user, and nobody
> > +_report_quota_blocks() {
> > +	repquota $SCRATCH_MNT | egrep "^($qa_user|root|nobody)" | awk '{print $1, $3, $4, $5}'
> > +}
> > +
> > +# Report the inode usage of root, $qa_user, and nobody
> > +_report_quota_inodes() {
> > +	repquota $SCRATCH_MNT | egrep "^($qa_user|root|nobody)" | awk '{print $1, $6, $7, $8}'
> > +}
> > +
> 
> Name them as _scratch_report_quota_blocks|inodes ? Since they're
> assuming mount point is SCRATCH_MNT. Or take the mount point as the
> first argument?

Ok, changed to require a mountpoint as a first arg.

--D

> 
> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
