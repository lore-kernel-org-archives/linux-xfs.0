Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55596 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387900AbeGTRIa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jul 2018 13:08:30 -0400
Date: Fri, 20 Jul 2018 09:19:23 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mkfs: avoid divide-by-zero when hardware reports optimal
 i/o size as 0
Message-ID: <20180720161923.GO4813@magnolia>
References: <6f62dbc6-f516-e8b5-1f08-6be227a61219@suse.com>
 <20180720155529.qw7nthesfu6xu7ie@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180720155529.qw7nthesfu6xu7ie@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Mahoney <jeffm@suse.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>

On Fri, Jul 20, 2018 at 05:55:29PM +0200, Carlos Maiolino wrote:
> On Thu, Jul 19, 2018 at 05:23:22PM -0400, Jeff Mahoney wrote:
> > Commit 051b4e37f5e (mkfs: factor AG alignment) factored out the
> > AG alignment code into a separate function.  It got rid of
> > redundant checks for dswidth != 0 since calc_stripe_factors was
> > supposed to guarantee that if dsunit is non-zero dswidth will be
> > as well.  Unfortunately, there's hardware out there that reports its
> > optimal i/o size as larger than the maximum i/o size, which the kernel
> > treats as broken and zeros out the optimal i/o size.  We'll accept
> > the multi-sector dsunit but have a zero dswidth and hit a divide-by-zero
> > in align_ag_geometry.
> > 
> > To resolve this we can check the topology before consuming it, default
> > to using the stripe unit as the stripe width, and warn the user about it.
> > 
> 
> I wonder if this shouldn't go into blkid_get_topology since something is wrong
> with the information reported by the storage.

If the storage gives us crap geometry information we don't have to use
it.  Keep the message that we autodetected nonsense and are dropping it;
the sysadmin can always re-run mkfs with sensible dsunit/dswidth.

> And require a force_overwrite to continue, at this point, something looks quite
> wrong in the storage, and I think this is the last 'resource' a sysadmin will
> have to notice this before making the FS, and start using it, so, maybe requiring
> force_overwrite would bring more attention.

I prefer reserving -f for "This is about to destroy something and can't
be undone", not "This auto-optimization is screwed up, continue? (y/N)"

--D

> > Fixes: 051b4e37f5e (mkfs: factor AG alignment)
> > Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> > ---
> >  mkfs/xfs_mkfs.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index a135e06e..35542e57 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -2295,6 +2295,12 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
> >  	if (!dsunit) {
> >  		dsunit = ft->dsunit;
> >  		dswidth = ft->dswidth;
> > +		if (dsunit && dswidth == 0) {
> > +			fprintf(stderr,
> > +_("%s: Volume reports stripe unit of %d bytes but stripe width of 0.  Using stripe width of %d bytes, which may not be optimal.\n"),
> > +				progname, dsunit << 9, dsunit << 9);
> > +			dswidth = dsunit;
> > +		}
> >  		use_dev = true;
> >  	} else {
> >  		/* check and warn is alignment is sub-optimal */
> > -- 
> > 2.16.4
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
