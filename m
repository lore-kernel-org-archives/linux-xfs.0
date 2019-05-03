Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60080 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbfECFtW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 May 2019 01:49:22 -0400
Date: Thu, 2 May 2019 22:49:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] mkfs: validate start and end of aligned logs
Message-ID: <20190503054906.GQ5207@magnolia>
References: <20190503035312.GP5207@magnolia>
 <494dcfb7-7ca9-5a95-532c-13d569ccd3da@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494dcfb7-7ca9-5a95-532c-13d569ccd3da@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, May 02, 2019 at 11:12:21PM -0500, Eric Sandeen wrote:
> 
> 
> On 5/2/19 10:53 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Validate that the start and end of the log stay within a single AG if
> > we adjust either end to align to stripe units.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  mkfs/xfs_mkfs.c |   11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 3ca8c9dc..0862621a 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3070,11 +3070,20 @@ align_internal_log(
> >  	if ((cfg->logstart % sunit) != 0)
> >  		cfg->logstart = ((cfg->logstart + (sunit - 1)) / sunit) * sunit;
> >  
> > +	/* if our log start rounds into the next AG we're done */
> > +	if (!xfs_verify_fsbno(mp, cfg->logstart)) {
> > +			fprintf(stderr,
> > +_("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
> > +  "within an allocation group.\n"),
> > +			(long long) cfg->logstart);
> > +		usage();
> > +	}
> > +
> >  	/* round up/down the log size now */
> >  	align_log_size(cfg, sunit);
> >  
> >  	/* check the aligned log still fits in an AG. */
> > -	if (cfg->logblocks > cfg->agsize - XFS_FSB_TO_AGBNO(mp, cfg->logstart)) {
> > +	if (!xfs_verify_fsbno(mp, cfg->logstart + cfg->logblocks - 1)) {
> 
> This used to see if the aligned log size was actually smaller than the AG.
> 
> Your new check just makes sure that the end block doesn't land on metadata,
> right?
> 
> i.e. we could end up with:
> 
> [ AG 0 ][ AG 1 ]
> [    log    ]
> 
> and pass your new test, because the end of the log doesn't stomp on ag
> metadata, even though it goes past the end of the start AG... right?

DOH.  Yes.  Somewhere in there I coded up a FSB_TO_AGNO(logstart) ==
FSB_TO_AGNO(logstart + logblocks - 1) but clearly it fell out.

Derp derp try again tomorrow. :(

--D

> -Eric
> 
> >  		fprintf(stderr,
> >  _("Due to stripe alignment, the internal log size (%lld) is too large.\n"
> >    "Must fit within an allocation group.\n"),
> > 
