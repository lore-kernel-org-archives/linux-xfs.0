Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43668 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725735AbeJAWmg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 18:42:36 -0400
Date: Mon, 1 Oct 2018 09:04:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/6] libxfs: fix xfs_trans_alloc reservation abuse
Message-ID: <20181001160400.GC5872@magnolia>
References: <153809666117.32548.6836488790026631787.stgit@magnolia>
 <153809668914.32548.55544268146936270.stgit@magnolia>
 <20180929223131.GI31060@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180929223131.GI31060@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Sun, Sep 30, 2018 at 08:31:31AM +1000, Dave Chinner wrote:
> On Thu, Sep 27, 2018 at 06:04:49PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Various xfsprogs tools have been abusing the transaction reservation
> > system by allocating the transaction with zero reservation.  This has
> > always worked in the past because userspace transactions do not require
> > reservations.  However, once we merge deferred ops into the transaction
> > structure, we will need to use a permanent reservation type to set up
> > any transaction that can roll.  tr_itruncate has all we need, so use
> > that as the reservation dummy.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  mkfs/proto.c    |   19 +++++++++----------
> >  mkfs/xfs_mkfs.c |    4 ++--
> >  repair/phase5.c |    4 ++--
> >  repair/phase6.c |   20 ++++++++------------
> >  repair/rmap.c   |    7 +++----
> >  5 files changed, 24 insertions(+), 30 deletions(-)
> > 
> > 
> > diff --git a/mkfs/proto.c b/mkfs/proto.c
> > index 07d019d6..9da0587e 100644
> > --- a/mkfs/proto.c
> > +++ b/mkfs/proto.c
> > @@ -123,9 +123,8 @@ getres(
> >  	uint		r;
> >  
> >  	for (i = 0, r = MKFS_BLOCKRES(blocks); r >= blocks; r--) {
> > -		struct xfs_trans_res    tres = {0};
> > -
> > -		i = -libxfs_trans_alloc(mp, &tres, r, 0, 0, &tp);
> > +		i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
> 
> I'm wondering if this should explicitly call out that it's a dummy
> reservation rather than using the itruncate reservation? e.g. these
> places use:
> 
> 	i = -libxfs_trans_alloc_perm(mp, blks, rtblks, flags, &tp);
> 
> And the implementation of this function then goes and uses the
> itruncate reservation with a comment explaining what thay is used
> 
> (open to a better name - "dummy" doesn't seem right - perm, rolling,
> deferred, etc all seem appropriate to indicate that it's an
> allocation for a permanent transaction type for rolling/defered
> transactions).

I don't necessarily like the long name, but
"libxfs_trans_alloc_rollable" seems the most descriptive to me.

I do like using a helper instead of opencoding tr_itruncate
everywhere.

--D

> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
