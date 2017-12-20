Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:14286 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754066AbdLTDwb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 22:52:31 -0500
Date: Wed, 20 Dec 2017 14:52:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/7] mkfs: support arbitrary conflict specification
Message-ID: <20171220035227.GD4094@dastard>
References: <20171218091158.14537-1-david@fromorbit.com>
 <20171218091158.14537-5-david@fromorbit.com>
 <20171220025346.GL12613@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171220025346.GL12613@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 19, 2017 at 06:53:46PM -0800, Darrick J. Wong wrote:
> On Mon, Dec 18, 2017 at 08:11:55PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently the conflict table is a single dimension, allowing
> > conflicts to be specified in the same option table. however, we
> > have conflicts that span option tables (e.g. sector size) and
> > so we need to encode both the table and the option that conflicts.
> > 
> > Add support for a two dimensional conflict definition and convert
> > all the code over to use it.
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > ---
> >  mkfs/xfs_mkfs.c | 257 ++++++++++++++++++++++++++++----------------------------
> >  1 file changed, 130 insertions(+), 127 deletions(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 7cc5ee2ddb9d..2272700807dc 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -125,7 +125,10 @@ struct opt_params {
> >  		bool		str_seen;
> >  		bool		convert;
> >  		bool		is_power_2;
> > -		int		conflicts[MAX_CONFLICTS];
> > +		struct _conflict {
> > +			struct opt_params	*opts;
> > +			int			subopt;
> > +		}		conflicts[MAX_CONFLICTS];
> >  		long long	minval;
> >  		long long	maxval;
> >  		long long	defaultval;
> > @@ -143,8 +146,8 @@ struct opt_params bopts = {
> >  	},
> >  	.subopt_params = {
> >  		{ .index = B_LOG,
> > -		  .conflicts = { B_SIZE,
> > -				 LAST_CONFLICT },
> > +		  .conflicts = { { &bopts, B_SIZE },
> > +				 { &bopts, LAST_CONFLICT } },
> 
> Hmm.  The LAST_CONFLICT entry doesn't require an *opts pointer, right?
> 
> It feels a little funny to me that the last entry isn't:
> 
> { NULL, LAST_CONFLICT }
> 
> ...since we're not actually doing anything with bopts in that last
> entry, but that might be a matter of taste (aka I punt to sandeen) :)

Doesn't worry me - I put it there as the loop terminates on
LAST_CONFLICT, not on a null opts pointer. Eric - up to you.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
