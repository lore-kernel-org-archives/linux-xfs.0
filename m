Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44436 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfDDQ4q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Apr 2019 12:56:46 -0400
Date: Thu, 4 Apr 2019 09:56:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 45/36] xfs_scrub: rename confusing structure
Message-ID: <20190404165640.GL15524@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320200330.GI1183@magnolia>
 <34a79955-0121-5a50-dbf9-45c230fea153@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34a79955-0121-5a50-dbf9-45c230fea153@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 04, 2019 at 11:40:53AM -0500, Eric Sandeen wrote:
> On 3/20/19 3:03 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Rename xfs_verify_extent to media_verify_state so that the name more
> > accurately reflects what we're storing in the structure.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hate to do this, but "*ve" made sense for "verify extent" but
> really doesn't for "verify state..."  If the point is clarity, I
> think s/ve/vs/ would be reasonable as well?  It's about 35 instances.

Sure.  I couldn't come up with a synonym for 'state' that starts with
an 'e'. :/

--D

> > ---
> >  scrub/phase6.c |   10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/scrub/phase6.c b/scrub/phase6.c
> > index 5e2b9ee3..2b4f6ff1 100644
> > --- a/scrub/phase6.c
> > +++ b/scrub/phase6.c
> > @@ -35,7 +35,7 @@
> >  
> >  /* Verify disk blocks with GETFSMAP */
> >  
> > -struct xfs_verify_extent {
> > +struct media_verify_state {
> >  	struct read_verify_pool	*rvp_data;
> >  	struct read_verify_pool	*rvp_log;
> >  	struct read_verify_pool	*rvp_realtime;
> > @@ -47,7 +47,7 @@ struct xfs_verify_extent {
> >  static struct read_verify_pool *
> >  xfs_dev_to_pool(
> >  	struct scrub_ctx		*ctx,
> > -	struct xfs_verify_extent	*ve,
> > +	struct media_verify_state	*ve,
> >  	dev_t				dev)
> >  {
> >  	if (dev == ctx->fsinfo.fs_datadev)
> > @@ -348,7 +348,7 @@ xfs_check_rmap_ioerr(
> >  {
> >  	struct fsmap			keys[2];
> >  	char				descr[DESCR_BUFSZ];
> > -	struct xfs_verify_extent	*ve = arg;
> > +	struct media_verify_state	*ve = arg;
> >  	struct bitmap			*tree;
> >  	dev_t				dev;
> >  	bool				moveon;
> > @@ -395,7 +395,7 @@ xfs_check_rmap(
> >  	struct fsmap			*map,
> >  	void				*arg)
> >  {
> > -	struct xfs_verify_extent	*ve = arg;
> > +	struct media_verify_state	*ve = arg;
> >  	struct read_verify_pool		*rvp;
> >  
> >  	rvp = xfs_dev_to_pool(ctx, ve, map->fmr_device);
> > @@ -463,7 +463,7 @@ bool
> >  xfs_scan_blocks(
> >  	struct scrub_ctx		*ctx)
> >  {
> > -	struct xfs_verify_extent	ve = { NULL };
> > +	struct media_verify_state	ve = { NULL };
> >  	bool				moveon;
> >  
> >  	moveon = bitmap_init(&ve.d_bad);
> > 
