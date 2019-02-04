Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46670 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbfBDSe4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 13:34:56 -0500
Date: Mon, 4 Feb 2019 10:34:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/8] xfs_scrub: use datadev parallelization estimates for
 thread count
Message-ID: <20190204183449.GZ5761@magnolia>
References: <154524776457.28646.3004453037075812416.stgit@magnolia>
 <154524779871.28646.8062050192682765855.stgit@magnolia>
 <be364989-b8de-b027-8561-48f7bc53a7fa@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be364989-b8de-b027-8561-48f7bc53a7fa@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 12:31:59PM -0600, Eric Sandeen wrote:
> On 12/19/18 1:29 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > During phases 2-5, xfs_scrub should estimate the level of
> > parallelization possible on the data device to determine the number of
> > threads spawned to scrub filesystem metadata, not just blindly using the
> > number of CPUs.  This avoids flooding non-rotational storage with random
> > reads, which totally destroys performance and makes scrub runtimes
> > higher.
> 
> typo in the changelog?  __disk_heads() /does/ throw all cpus at nonrotational,
> should the above presumably say "rotational storage?"

Er... yes.  Would you mind changing that on its way in, pretty please?

:)

--D

> Otherwise,
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  scrub/phase1.c |   14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> > 
> > 
> > diff --git a/scrub/phase1.c b/scrub/phase1.c
> > index 2113014b..6b472147 100644
> > --- a/scrub/phase1.c
> > +++ b/scrub/phase1.c
> > @@ -109,13 +109,6 @@ _("Must be root to run scrub."));
> >  		return false;
> >  	}
> >  
> > -	ctx->nr_io_threads = nproc;
> > -	if (verbose) {
> > -		fprintf(stdout, _("%s: using %d threads to scrub.\n"),
> > -				ctx->mntpoint, scrub_nproc(ctx));
> > -		fflush(stdout);
> > -	}
> > -
> >  	if (!platform_test_xfs_fd(ctx->mnt_fd)) {
> >  		str_info(ctx, ctx->mntpoint,
> >  _("Does not appear to be an XFS filesystem!"));
> > @@ -193,6 +186,13 @@ _("Unable to find realtime device path."));
> >  		return false;
> >  	}
> >  
> > +	ctx->nr_io_threads = disk_heads(ctx->datadev);
> > +	if (verbose) {
> > +		fprintf(stdout, _("%s: using %d threads to scrub.\n"),
> > +				ctx->mntpoint, scrub_nproc(ctx));
> > +		fflush(stdout);
> > +	}
> > +
> >  	if (ctx->fsinfo.fs_log) {
> >  		ctx->logdev = disk_open(ctx->fsinfo.fs_log);
> >  		if (error) {
> > 
