Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56668 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751336AbeAZALz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 19:11:55 -0500
Date: Thu, 25 Jan 2018 16:11:50 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/5] xfs/24[356]: checking cow fork bmap requires
 CONFIG_XFS_DEBUG=y
Message-ID: <20180126001150.GE9359@magnolia>
References: <151683799705.17051.9987269343206294671.stgit@magnolia>
 <151683802170.17051.13989603221322920472.stgit@magnolia>
 <20180125081753.GH18267@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180125081753.GH18267@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Jan 25, 2018 at 04:17:53PM +0800, Eryu Guan wrote:
> On Wed, Jan 24, 2018 at 03:53:41PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > These tests requires XFS debugging functionality, so test for that.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/243 |    2 ++
> >  tests/xfs/245 |    2 ++
> >  tests/xfs/246 |    2 ++
> >  3 files changed, 6 insertions(+)
> > 
> > 
> > diff --git a/tests/xfs/243 b/tests/xfs/243
> > index 0bb69c4..1e6ab5a 100755
> > --- a/tests/xfs/243
> > +++ b/tests/xfs/243
> > @@ -49,10 +49,12 @@ _cleanup()
> >  . ./common/rc
> >  . ./common/filter
> >  . ./common/reflink
> > +. ./common/xfs
> 
> This file should be included already by common/rc based on $FSTYP, no
> need to source it again in test. I'd remove it from all three tests on
> commit.

Ok.  Sorry I missed that subtlety.

--D

> Thanks,
> Eryu
