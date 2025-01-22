Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E812139CEF;
	Wed, 22 Jan 2025 03:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737517916; cv=none; b=G4LGlJ+7VS5sIVU1Y/JnsuxNqEhEuTF/9A9DvaWGuRLexYwcdHE0HUB6L3uttyIFch+RVGspW6i06THtWAJYJ7xqjLYQ4Ap2LwhxYPOdNg17vVp0vpa+YBIRuAHs64l8sUkaNeMnc+viKuqYcJn/nSVbry6LEf7r4VrvvhFIJLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737517916; c=relaxed/simple;
	bh=+Qnd20Nv6oJOEjZ3LLnvGJ62Qnh0OhRXgn/2OPETpgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OpmuFX8Q9wTBJkEX90iOoqeXEvd1qDTjLu5rfo39gBXekw9PC5ttSkmYBWd3eX0UpcHqPZI82h1S3Aoni/U5F4jguAQOnQ4Ww2o2gLYokKPQ6z2muk5QpHWexn4pBIiplJxixpdyrs5+5YQxUERdplAxAE5ylc1aHInGMzg02Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YQIlaQf2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YQIlaQf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F05C4CED6;
	Wed, 22 Jan 2025 03:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737517915;
	bh=+Qnd20Nv6oJOEjZ3LLnvGJ62Qnh0OhRXgn/2OPETpgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YQIlaQf2Pqnpa39JDoDxDX+ofFoCfzCpSiRIaqRr2QyD9fiK5Zwz+GLcf7RpdYGKz
	 opK9X32ZUkKC0cNMRSKFnmV1oBDRU5IHtkbLcl5rwrU1TY7z+8CVjudROEHDttE8C8
	 ECtWdn25a5YT8ROKDLwsOHsSeX07byMmPaAzSBhaU4iBZGo6jtpWCdYdZJY+KHn6RM
	 RjCsyxn3X4KBt85FPrKw3UJdtEdLTx24lLwY+0uc2UJvwK/26SE2uNUDKpkPjJ2P+7
	 e6eQ0Z8WYwAF6rYZYdzB8WHokN9XTrGD+tKVcnX4xudRkiyLQ7cCOb4yOOOlYapDYM
	 Lqo4SuACBA6og==
Date: Tue, 21 Jan 2025 19:51:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>, zlang@redhat.com, hch@lst.de,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/23] generic/650: revert SOAK DURATION changes
Message-ID: <20250122035155.GT1611770@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974273.1927324.11899201065662863518.stgit@frogsfrogsfrogs>
 <Z48pM9GEhp9P_VLX@dread.disaster.area>
 <20250121130027.GB3809348@mit.edu>
 <Z5AclEe71PIikAnH@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5AclEe71PIikAnH@dread.disaster.area>

On Wed, Jan 22, 2025 at 09:15:48AM +1100, Dave Chinner wrote:
> On Tue, Jan 21, 2025 at 08:00:27AM -0500, Theodore Ts'o wrote:
> > On Tue, Jan 21, 2025 at 03:57:23PM +1100, Dave Chinner wrote:
> > > I probably misunderstood how -n nr_ops vs --duration=30 interact;
> > > I expected it to run until either were exhausted, not for duration
> > > to override nr_ops as implied by this:
> > 
> > There are (at least) two ways that a soak duration is being used
> > today; one is where someone wants to run a very long soak for hours
> > and where if you go long by an hour or two it's no big deals.  The
> > other is where you are specifying a soak duration as part of a smoke
> > test (using the smoketest group), where you might be hoping to keep
> > the overall run time to 15-20 minutes and so you set SOAK_DURATION to
> > 3m.
> 
> check-parallel on my 64p machine runs the full auto group test in
> under 10 minutes.
> 
> i.e. if you have a typical modern server (64-128p, 256GB RAM and a
> couple of NVMe SSDs), then check-parallel allows a full test run in
> the same time that './check -g smoketest' will run....
> 
> > (This was based on some research that Darrick did which showed that
> > running the original 5 tests in the smoketest group gave you most of
> > the code coverage of running all of the quick group, which had
> > ballooned from 15 minutes many years ago to an hour or more.  I just
> > noticed that we've since added two more tests to the smoketest group;
> > it might be worth checking whether those two new tests addded to thhe
> > smoketest groups significantly improves code coverage or not.  It
> > would be unfortunate if the runtime bloat that happened to the quick
> > group also happens to the smoketest group...)
> 
> Yes, and I've previously made the point about how check-parallel
> changes the way we should be looking at dev-test cycles. We no
> longer have to care that auto group testing takes 4 hours to run and
> have to work around that with things like smoketest groups. If you
> can run the whole auto test group in 10-15 minutes, then we don't
> need "quick", "smoketest", etc to reduce dev-test cycle time
> anymore...
> 
> > The bottom line is in addition to trying to design semantics for users
> > who might be at either end of the CPU count spectrum, we should also
> > consider that SOAK_DURATION could be set for values ranging from
> > minutes to hours.
> 
> I don't see much point in testing for hours with check-parallel. The
> whole point of it is to enable iteration across the entire fs test
> matrix as fast as possible.

I do -- running all the soak tests in parallel on a (probably old lower
spec) machine.  Parallelism is all right for a lot of things.

--D

> If you want to do long running soak tests, then keep using check for
> that. If you want to run the auto group test across 100 different
> mkfs option combinations, then that is where check-parallel comes in
> - it'll take a few hours to do this instead of a week.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
