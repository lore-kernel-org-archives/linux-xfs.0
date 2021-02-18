Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041AFC43381
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8C1164EC2
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbhBRSsa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:48:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233665AbhBRRms (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Feb 2021 12:42:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01ABE64EC2;
        Thu, 18 Feb 2021 17:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613670127;
        bh=JkW0nbIyHZjOwHuToIgmxHT0qQ73qc/QZTBGTwFN/fE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JJr4tDzjYjGFCexazUjsQ+S2v+DGs0/zLsmC/0dmvDQfrFbBKsMCudMVvQfNXa+H9
         2We2Qxk39MgzGG503zrCHRiDNDCMaMqDPAGfO+EauAfgq2onsaWjWMg+AXPSL1s5p6
         Wb6EQsAMdkplcSamEBgjaD/1ATx6BaD2B7194ppTy2gmdyrjIUm936zbv7DDCrySca
         TXL3pgj/JL9NHHiNjDQEImYNQHpJYpwnZR4N4YEayBxlE7Yl5GetY9zTsD6P8kTiyq
         EJTq2rhsuSuQ//jkEqVi1zSLScp0BrKSnCF6ZCbMLOF7cvMJVSwzAsVBd4+RfrXWvH
         jMgPpncm36ZQA==
Date:   Thu, 18 Feb 2021 09:42:06 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] libxfs: simulate system failure after a certain
 number of writes
Message-ID: <20210218174206.GV7193@magnolia>
References: <161319520460.422860.10568013013578673175.stgit@magnolia>
 <161319521620.422860.17802896302850828411.stgit@magnolia>
 <20210216115645.GC534175@bfoster>
 <20210218043620.GQ7193@magnolia>
 <20210218130217.GB685651@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218130217.GB685651@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 08:02:17AM -0500, Brian Foster wrote:
> On Wed, Feb 17, 2021 at 08:36:20PM -0800, Darrick J. Wong wrote:
> > On Tue, Feb 16, 2021 at 06:56:45AM -0500, Brian Foster wrote:
> > > On Fri, Feb 12, 2021 at 09:46:56PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Add an error injection knob so that we can simulate system failure after
> > > > a certain number of disk writes.  This knob is being added so that we
> > > > can check repair's behavior after an arbitrary number of tests.
> > > > 
> > > > Set LIBXFS_DEBUG_WRITE_CRASH={ddev,logdev,rtdev}=nn in the environment
> > > > to make libxfs SIGKILL itself after nn writes to the data, log, or rt
> > > > devices.  Note that this only applies to xfs_buf writes and zero_range.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  libxfs/init.c      |   68 +++++++++++++++++++++++++++++++++++++++++++++++++---
> > > >  libxfs/libxfs_io.h |   19 +++++++++++++++
> > > >  libxfs/rdwr.c      |    6 ++++-
> > > >  3 files changed, 88 insertions(+), 5 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/libxfs/init.c b/libxfs/init.c
> > > > index 8a8ce3c4..1ec83791 100644
> > > > --- a/libxfs/init.c
> > > > +++ b/libxfs/init.c
> > > ...
> > > > @@ -614,6 +634,46 @@ libxfs_buftarg_init(
> > > >  	dev_t			logdev,
> > > >  	dev_t			rtdev)
> > > >  {
> > > > +	char			*p = getenv("LIBXFS_DEBUG_WRITE_CRASH");
> > > > +	unsigned long		dfail = 0, lfail = 0, rfail = 0;
> > > 
> > > Was there a reason for using an environment variable now rather than the
> > > original command line option?
> > 
> > Well, you said you wanted a generic write error injection hook for
> > libxfs, and this is the simplest way to add that, given that libraries
> > don't have a direct means to parse argc and argv.
> > 
> 
> I think you're misinterpreting my previous feedback. ;) I thought the
> injection mechanism was too closely tied to an implementation detail
> (i.e. "fail after updating needsrepair bit") of the application.
> Instead, I preferred a more generic mechanism (the "fail after so many
> I/Os," "fail after phase N" approaches in these patches) that covers the
> original use case. That broadens the potential test coverage and
> usefulness of the mechanism.

Agreed.  Admittedly, the test case I wrote for it that kills repair
after NR writes (where NR steadily increases) has opened my eyes to how
... stunningly awful xfs_repair (and e2fsck) can be.

(As in, you can *very easily* snatch death from the jaws of victory if
all you wanted was to fix a minor bitflip somewhere /and/ repair
dies...)

> > I mean... this /could/ take the form of an exposed library function that
> > xfs utilities could opt into their own getopt loops, but that's even
> > /more/ infrastructure code that I'd have to write.
> > 
> 
> In this case I was just curious why the interface was changed from the
> previous approach. ISTM it didn't necessarily have to, but I'm not
> concerned about it either way.

<nod>

> ...
> > > > diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> > > > index c80e2d59..85485257 100644
> > > > --- a/libxfs/libxfs_io.h
> > > > +++ b/libxfs/libxfs_io.h
> > > ...
> > > > @@ -30,6 +32,23 @@ struct xfs_buftarg {
> > > >  #define XFS_BUFTARG_LOST_WRITE		(1 << 0)
> > > >  /* A dirty buffer failed the write verifier. */
> > > >  #define XFS_BUFTARG_CORRUPT_WRITE	(1 << 1)
> > > > +/* Simulate failure after a certain number of writes. */
> > > > +#define XFS_BUFTARG_INJECT_WRITE_FAIL	(1 << 2)
> > > > +
> > > > +/* Simulate the system crashing after a write. */
> > > > +static inline void
> > > > +xfs_buftarg_trip_write(
> > > > +	struct xfs_buftarg	*btp)
> > > > +{
> > > > +	if (!(btp->flags & XFS_BUFTARG_INJECT_WRITE_FAIL))
> > > > +		return;
> > > > +
> > > > +	pthread_mutex_lock(&btp->lock);
> > > > +	btp->writes_left--;
> > > > +	if (!btp->writes_left)
> > > > +		kill(getpid(), SIGKILL);
> > > 
> > > Can we just exit()?
> > > 
> > > (Same questions for the next patch..)
> > 
> > The goal of this generic write error injection framework is to simulate
> > total system crashes immediately after a write.
> > 
> > SIGKILL and exit are not the same, because atexit handlers don't run if
> > the process forcibly kills itself.
> > 
> 
> Can you document this somewhere please?

Will do.

--D

> Brian
> 
> > --D
> > 
> > > 
> > > Brian
> > > 
> > > > +	pthread_mutex_unlock(&btp->lock);
> > > > +}
> > > >  
> > > >  extern void	libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
> > > >  				    dev_t logdev, dev_t rtdev);
> > > > diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> > > > index ca272387..fd456d6b 100644
> > > > --- a/libxfs/rdwr.c
> > > > +++ b/libxfs/rdwr.c
> > > > @@ -74,8 +74,10 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
> > > >  	/* try to use special zeroing methods, fall back to writes if needed */
> > > >  	len_bytes = LIBXFS_BBTOOFF64(len);
> > > >  	error = platform_zero_range(fd, start_offset, len_bytes);
> > > > -	if (!error)
> > > > +	if (!error) {
> > > > +		xfs_buftarg_trip_write(btp);
> > > >  		return 0;
> > > > +	}
> > > >  
> > > >  	zsize = min(BDSTRAT_SIZE, BBTOB(len));
> > > >  	if ((z = memalign(libxfs_device_alignment(), zsize)) == NULL) {
> > > > @@ -105,6 +107,7 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
> > > >  				progname, __FUNCTION__);
> > > >  			exit(1);
> > > >  		}
> > > > +		xfs_buftarg_trip_write(btp);
> > > >  		offset += bytes;
> > > >  	}
> > > >  	free(z);
> > > > @@ -860,6 +863,7 @@ libxfs_bwrite(
> > > >  	} else {
> > > >  		bp->b_flags |= LIBXFS_B_UPTODATE;
> > > >  		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_UNCHECKED);
> > > > +		xfs_buftarg_trip_write(bp->b_target);
> > > >  	}
> > > >  	return bp->b_error;
> > > >  }
> > > > 
> > > 
> > 
> 
