Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953514DE73F;
	Fri, 25 Sep 2026 19:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790365044; cv=none; b=JmLvPTX4fbHihmeJ5bAOZl8sLoAxtiDHBu0Z5Tgp6Ns1d7FsG9lZ8OfQKhcM5rM+2W+R6Ogc03DdiZhXsn/rzoa6ehhusGdL6gfGYGIpSNmPm6lDgHWS4vzc6PYDeejO+FtlfDdoKfli0IujP9X6sns+w8DmJ47AR5hyuhga1w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790365044; c=relaxed/simple;
	bh=RfW8sGRT5+qoYaxBWno9E7kyH2YwL9rGfo0FyyF7m9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+TLVpniQFbrZNxSROynujfvMMOpuvv6S4m4zFAQbbHTZm7M3snxBJ8vCBwSYXAv5wuehriifyP5ih/9cXImfg98BHZJZwDP1gwZ4aj7ELJCXXjCXRB7SuJwS1Ta8FLgbtIqqjg3qsM7iCLhmiGXFfNVutA7jTegfLxy2/WyJfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gPLHJ7SN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPLHJ7SN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6FADD1F000FF;
	Fri, 25 Sep 2026 19:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790365043;
	bh=7fAX8ToQ+KN1SjKBrrQcodD+POK4xgQeUTLqOhlBn1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gPLHJ7SNY9CVlofi9WtCYgndW75HeoV1PKazU+u5dlrVltYjtFdqbX7IAwvyWCIYz
	 Xal7EgQmn3ccDlSR3k7lRO6mzhSCpCyQCgcFPXQBNSrvUme5u+UYpl92tOf2svSsBl
	 RhWVo6jEOgAyrXCp5Nz+62deGs9UJ/VzXIEufNJ66SAkMLOtmbrNj2qQ8NGOt9KdUt
	 XLuwS3IA++2bB1N0q5TdLX/9yKAktg5/E7M3jar+R4haFDxJW89mEh2fEtrEv2F7U5
	 G2pfj2Ers78X7ggXQUjTyRXgSTUZTpngp44MGbCEfX4m9EZmOZsHlj70MIBu8a675c
	 1vpw+WetbVcxg==
Date: Fri, 25 Sep 2026 12:37:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 09/12] xfs: break out of zoned reservation loop if
 signals are pending
Message-ID: <20260925193722.GP2705364@frogsfrogsfrogs>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
 <179030932240.3344850.15431918414180548991.stgit@frogsfrogsfrogs>
 <arYJouxwjLL4O2GY@infradead.org>
 <20260925191830.GO2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925191830.GO2705364@frogsfrogsfrogs>

On Fri, Sep 25, 2026 at 12:18:30PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 24, 2026 at 10:41:54PM -0700, Christoph Hellwig wrote:
> > On Thu, Sep 24, 2026 at 09:12:51PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > I noticed that if you run generic/476 for long enough on a zoned
> > > filesystem that it runs out of space in the zoned section, fsstress gets
> > > stuck in this loop trying to reserve space, failing, and kicking off the
> > > gc.
> > 
> > I guess this is not directly fixed here, right?
> 
> Correct.  There's enough space freeing activity going on (truncate,
> punch, unlink, etc) so that the gc actually does clear out zones; but
> there are also enough writers consuming more space that they all end up
> in this loop at some point, and some of the threads never manage to get
> what they want from rtavailable.
> 
> > > The garbage collector in turn is continuously running (so we don't
> > > break out of the loop) but the process is no longer responsive to
> > > signals and can't be killed.
> > > 
> > > Fix this by backing out to userspace for any pending signal.  This
> > > should be safe because space reservation is usually the first step in
> > > any modification to a zoned file.
> > > 
> > > Cc: <hch@lst.de>
> > > Cc: <stable@vger.kernel.org> # v6.15
> > > Fixes: 0bb2193056b596 ("xfs: add support for zoned space reservations")
> > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > ---
> > >  fs/xfs/xfs_zone_space_resv.c |    5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
> > > index 7aa3c74fb2e01a..8edc82025abbd5 100644
> > > --- a/fs/xfs/xfs_zone_space_resv.c
> > > +++ b/fs/xfs/xfs_zone_space_resv.c
> > > @@ -157,6 +157,11 @@ xfs_zoned_reserve_available(
> > >  		if (error != -ENOSPC)
> > >  			break;
> > >  
> > > +		if (signal_pending(current)) {
> > > +			error = -ERESTARTSYS;
> > > +			break;
> > > +		}
> > 
> > I don't think normal fs read/write semantics allow for -ERESTARTSYS
> > on arbitrary signals.  So this should probably be limited to
> > fatal_signal_pending().
> 
> Ok.  That at least means I can ^C the g/476 test processes. :)

Heh.  Rereading my notes it was always possible to kill -9 the process,
but the difficulty with fsstress is that it uses SIGTERM sets a global
flag to tell its threads to exit their file IO loops.  Since that's not
a fatal action, fatal_signal_pending() returns false and so the thread
remains stuck looping in the kernel.

--D
