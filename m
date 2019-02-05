Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52200 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfBECXW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 21:23:22 -0500
Date: Mon, 4 Feb 2019 18:23:15 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/8] xfs_scrub: use data/rtdev parallelization estimates
 for the read-verify pool
Message-ID: <20190205022315.GH7991@magnolia>
References: <154524776457.28646.3004453037075812416.stgit@magnolia>
 <154524780496.28646.2648041743792188824.stgit@magnolia>
 <9a284f93-3a17-a2e4-f347-562d23a52388@sandeen.net>
 <20190204183855.GA7991@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204183855.GA7991@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 10:38:55AM -0800, Darrick J. Wong wrote:
> On Mon, Feb 04, 2019 at 12:35:00PM -0600, Eric Sandeen wrote:
> > On 12/19/18 1:30 PM, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Since we use the same read-verify pool object to dispatch file data read
> > > requests for both the data device and the realtime device, we should
> > > create enough IO threads to handle the estimated parallelization of both
> > > devices, not just the data device.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > So if rtdev is on SSD and datadev is on a rotational device, won't we
> > possibly still Launch All Threads at the rotational device for this
> > case, and won't that still hurt?  I'm not sure it works to lump these
> > together, does it?  (I also don't know if it can be done another way...)
> 
> Hmm.  I think we /could/ have separate readverify pools for data and rt
> devices.  Let me look into that...

...yes, the readverify pool code needs some refactoring and thinko
removal; however, that cleanup should wait for xfsprogs 5.0.

--D

> --D
> 
> > -Eric
> > 
> > 
> > > ---
> > >  scrub/phase6.c |   20 ++++++++++++++++++--
> > >  1 file changed, 18 insertions(+), 2 deletions(-)
> > > 
> > > 
> > > diff --git a/scrub/phase6.c b/scrub/phase6.c
> > > index ead48d77..cbda9b53 100644
> > > --- a/scrub/phase6.c
> > > +++ b/scrub/phase6.c
> > > @@ -435,6 +435,22 @@ xfs_check_rmap(
> > >  	return true;
> > >  }
> > >  
> > > +/*
> > > + * Estimate the amount of parallelization possible for scanning file data on
> > > + * the data and realtime devices.
> > > + */
> > > +static unsigned int
> > > +phase6_threads(
> > > +	struct scrub_ctx	*ctx)
> > > +{
> > > +	unsigned int		nr = disk_heads(ctx->datadev);
> > > +
> > > +	if (ctx->rtdev)
> > > +		nr += disk_heads(ctx->rtdev);
> > > +
> > > +	return nr > nproc ? nproc : nr;
> > > +}
> > > +
> > >  /*
> > >   * Read verify all the file data blocks in a filesystem.  Since XFS doesn't
> > >   * do data checksums, we trust that the underlying storage will pass back
> > > @@ -469,7 +485,7 @@ xfs_scan_blocks(
> > >  	}
> > >  
> > >  	ve.readverify = read_verify_pool_init(ctx, ctx->geo.blocksize,
> > > -			xfs_check_rmap_ioerr, disk_heads(ctx->datadev));
> > > +			xfs_check_rmap_ioerr, phase6_threads(ctx));
> > >  	if (!ve.readverify) {
> > >  		moveon = false;
> > >  		str_info(ctx, ctx->mntpoint,
> > > @@ -525,7 +541,7 @@ xfs_estimate_verify_work(
> > >  		return moveon;
> > >  
> > >  	*items = ((d_blocks - d_bfree) + (r_blocks - r_bfree)) << ctx->blocklog;
> > > -	*nr_threads = disk_heads(ctx->datadev);
> > > +	*nr_threads = phase6_threads(ctx);
> > >  	*rshift = 20;
> > >  	return moveon;
> > >  }
> > > 
