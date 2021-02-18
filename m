Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E15D5C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 04:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9834614A7
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 04:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhBREhM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Feb 2021 23:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229864AbhBREhC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 Feb 2021 23:37:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BBC564E4B;
        Thu, 18 Feb 2021 04:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613622981;
        bh=0qKLpIYxFwdvLlYYpvX3esfctiAkIZoH65f1rTZ5WJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UM4c6KnR6S0HeKs7geRXBknVtR0WjlOYhMRGfoZC5hORcqjlmSFbNcf9yfBOO0maw
         g5DkCet1vGn7tV+qDAY+nEeg9JVM02Tuzh2jkNT3hed9opf5xEici8DZWMyKmH0Nsa
         KuwA3P9YuF+3ZRn0fZ7/2kiA33r6+LBzracee28d7Ep9egS+U1xK+pEZC0Zu9XXf1w
         VGy70NxteGcaiYGMxryVJlekz77+fO/esXSF9EoPoBaZWKCaBhGh975JjRZ8zesLVY
         4SNsQATm2683vxZhxRAzBtmYHiD+Ovp2SI/DkYyTl2yDju1HqsOY/CEMuKT+KPAmZa
         ptlgkqIZstIEg==
Date:   Wed, 17 Feb 2021 20:36:20 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] libxfs: simulate system failure after a certain
 number of writes
Message-ID: <20210218043620.GQ7193@magnolia>
References: <161319520460.422860.10568013013578673175.stgit@magnolia>
 <161319521620.422860.17802896302850828411.stgit@magnolia>
 <20210216115645.GC534175@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216115645.GC534175@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 16, 2021 at 06:56:45AM -0500, Brian Foster wrote:
> On Fri, Feb 12, 2021 at 09:46:56PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add an error injection knob so that we can simulate system failure after
> > a certain number of disk writes.  This knob is being added so that we
> > can check repair's behavior after an arbitrary number of tests.
> > 
> > Set LIBXFS_DEBUG_WRITE_CRASH={ddev,logdev,rtdev}=nn in the environment
> > to make libxfs SIGKILL itself after nn writes to the data, log, or rt
> > devices.  Note that this only applies to xfs_buf writes and zero_range.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  libxfs/init.c      |   68 +++++++++++++++++++++++++++++++++++++++++++++++++---
> >  libxfs/libxfs_io.h |   19 +++++++++++++++
> >  libxfs/rdwr.c      |    6 ++++-
> >  3 files changed, 88 insertions(+), 5 deletions(-)
> > 
> > 
> > diff --git a/libxfs/init.c b/libxfs/init.c
> > index 8a8ce3c4..1ec83791 100644
> > --- a/libxfs/init.c
> > +++ b/libxfs/init.c
> ...
> > @@ -614,6 +634,46 @@ libxfs_buftarg_init(
> >  	dev_t			logdev,
> >  	dev_t			rtdev)
> >  {
> > +	char			*p = getenv("LIBXFS_DEBUG_WRITE_CRASH");
> > +	unsigned long		dfail = 0, lfail = 0, rfail = 0;
> 
> Was there a reason for using an environment variable now rather than the
> original command line option?

Well, you said you wanted a generic write error injection hook for
libxfs, and this is the simplest way to add that, given that libraries
don't have a direct means to parse argc and argv.

I mean... this /could/ take the form of an exposed library function that
xfs utilities could opt into their own getopt loops, but that's even
/more/ infrastructure code that I'd have to write.

OTOH there's already precedent for magic environment variables to enable
libxfs debug hooks.

> > +
> > +	/* Simulate utility crash after a certain number of writes. */
> > +	while (p && *p) {
> > +		char *val;
> > +
> > +		switch (getsubopt(&p, wf_opts, &val)) {
> > +		case WF_DATA:
> > +			if (!val) {
> > +				fprintf(stderr,
> > +		_("ddev write fail requires a parameter\n"));
> > +				exit(1);
> > +			}
> > +			dfail = strtoul(val, NULL, 0);
> > +			break;
> > +		case WF_LOG:
> > +			if (!val) {
> > +				fprintf(stderr,
> > +		_("logdev write fail requires a parameter\n"));
> > +				exit(1);
> > +			}
> > +			lfail = strtoul(val, NULL, 0);
> > +			break;
> > +		case WF_RT:
> > +			if (!val) {
> > +				fprintf(stderr,
> > +		_("rtdev write fail requires a parameter\n"));
> > +				exit(1);
> > +			}
> > +			rfail = strtoul(val, NULL, 0);
> > +			break;
> > +		default:
> > +			fprintf(stderr, _("unknown write fail type %s\n"),
> > +					val);
> > +			exit(1);
> > +			break;
> > +		}
> > +	}
> > +
> >  	if (mp->m_ddev_targp) {
> >  		/* should already have all buftargs initialised */
> >  		if (mp->m_ddev_targp->bt_bdev != dev ||
> ...
> > diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> > index c80e2d59..85485257 100644
> > --- a/libxfs/libxfs_io.h
> > +++ b/libxfs/libxfs_io.h
> ...
> > @@ -30,6 +32,23 @@ struct xfs_buftarg {
> >  #define XFS_BUFTARG_LOST_WRITE		(1 << 0)
> >  /* A dirty buffer failed the write verifier. */
> >  #define XFS_BUFTARG_CORRUPT_WRITE	(1 << 1)
> > +/* Simulate failure after a certain number of writes. */
> > +#define XFS_BUFTARG_INJECT_WRITE_FAIL	(1 << 2)
> > +
> > +/* Simulate the system crashing after a write. */
> > +static inline void
> > +xfs_buftarg_trip_write(
> > +	struct xfs_buftarg	*btp)
> > +{
> > +	if (!(btp->flags & XFS_BUFTARG_INJECT_WRITE_FAIL))
> > +		return;
> > +
> > +	pthread_mutex_lock(&btp->lock);
> > +	btp->writes_left--;
> > +	if (!btp->writes_left)
> > +		kill(getpid(), SIGKILL);
> 
> Can we just exit()?
> 
> (Same questions for the next patch..)

The goal of this generic write error injection framework is to simulate
total system crashes immediately after a write.

SIGKILL and exit are not the same, because atexit handlers don't run if
the process forcibly kills itself.

--D

> 
> Brian
> 
> > +	pthread_mutex_unlock(&btp->lock);
> > +}
> >  
> >  extern void	libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
> >  				    dev_t logdev, dev_t rtdev);
> > diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> > index ca272387..fd456d6b 100644
> > --- a/libxfs/rdwr.c
> > +++ b/libxfs/rdwr.c
> > @@ -74,8 +74,10 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
> >  	/* try to use special zeroing methods, fall back to writes if needed */
> >  	len_bytes = LIBXFS_BBTOOFF64(len);
> >  	error = platform_zero_range(fd, start_offset, len_bytes);
> > -	if (!error)
> > +	if (!error) {
> > +		xfs_buftarg_trip_write(btp);
> >  		return 0;
> > +	}
> >  
> >  	zsize = min(BDSTRAT_SIZE, BBTOB(len));
> >  	if ((z = memalign(libxfs_device_alignment(), zsize)) == NULL) {
> > @@ -105,6 +107,7 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
> >  				progname, __FUNCTION__);
> >  			exit(1);
> >  		}
> > +		xfs_buftarg_trip_write(btp);
> >  		offset += bytes;
> >  	}
> >  	free(z);
> > @@ -860,6 +863,7 @@ libxfs_bwrite(
> >  	} else {
> >  		bp->b_flags |= LIBXFS_B_UPTODATE;
> >  		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_UNCHECKED);
> > +		xfs_buftarg_trip_write(bp->b_target);
> >  	}
> >  	return bp->b_error;
> >  }
> > 
> 
