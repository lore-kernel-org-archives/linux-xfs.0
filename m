Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1AF1F1937
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 12:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737463489; cv=none; b=LsmxNiQwMlDmWYiF/fjXS5QfG5oH7wBF3MukTWcsx9b0EvYDWpKO0huTc3sQAeTWfB3b5vGDfmztfEcNa1QD+SLxl01cyf+XMqLzdg3h/rrfCgDRXR+kBGPiPbcYKzGyyKB1AErT1vVQVkh5t4c5Ba/PPM3OSTpTAFjA823glhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737463489; c=relaxed/simple;
	bh=ANp3OH3mx5KasX0OyT5VGzZf+KaJsSvE7iOIWHbvwyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=czmLyeokFFaCX1eyrxI8+qIooeW23bR8S5y8jUIxRodLfxi06USPz0kW2FVuLOzSqDPryTu091qZRzSEVMcvbAw6Og9CXqnxMUjmrTkyEo5CJmXG3uD/1C1+0DYZgjdTRfEcKKzu9aXSslMgTEDIssFLq5hfoHjwFkyEjJ9qFn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=CW1iKlNd; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="CW1iKlNd"
Received: from cwcc.thunk.org (pool-173-48-114-200.bstnma.fios.verizon.net [173.48.114.200])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 50LCiVGc032151
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 07:44:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1737463473; bh=wUoxwg++YKNF6nKKpNyDiSSgpiw6M5OVkgoc2CdjZds=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=CW1iKlNdh/s9iA7lhbDbuqf/85v1gF2k1GbQDsuqt3KFwXy1iwr7w1dNUgqFKJXJ2
	 fdk6SD77tx6O2I7tT3LIAc1q/uzQnowVdlKK6vI4w9BFrcfrHO02QvWLm8bDvrgd59
	 28HUmUGJQZY+bE4Npd8hsEPBD0ZnRyOtjldYfPlLeJ2DM8jY6NhaJKH/zeYHEBW/x7
	 S3gMYpinJU2uirakJeooOZCYuwI/VBe7QAGaMc6fK4mTOGM/J5ISs8b+W7Rg6d+o+Y
	 Bvz/3bnVLXDyHzMpkDtVx/eR/Z/5LYjO2HgG4FFwHGA1f4EgTofAAEfk/n6LW/57f+
	 CSDSdhEjmfQlw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id F1A6F15C01A1; Tue, 21 Jan 2025 07:44:30 -0500 (EST)
Date: Tue, 21 Jan 2025 07:44:30 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com, hch@lst.de,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/23] mkfs: don't hardcode log size
Message-ID: <20250121124430.GA3809348@mit.edu>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974228.1927324.17714311358227511791.stgit@frogsfrogsfrogs>
 <Z48bYVRvWt-wPmUz@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z48bYVRvWt-wPmUz@dread.disaster.area>

On Tue, Jan 21, 2025 at 02:58:25PM +1100, Dave Chinner wrote:
> > +# Are there mkfs options to try to improve concurrency?
> > +_scratch_mkfs_concurrency_options()
> > +{
> > +	local nr_cpus="$(( $1 * LOAD_FACTOR ))"
> 
> caller does not need to pass a number of CPUs. This function can
> simply do:
> 
> 	local nr_cpus=$(getconf _NPROCESSORS_CONF)
> 
> And that will set concurrency to be "optimal" for the number of CPUs
> in the machine the test is going to run on. That way tests don't
> need to hard code some number that is going to be too large for
> small systems and to small for large systems...

Hmm, but is this the right thing if you are using check-parallel?  If
you are running multiple tests that are all running some kind of load
or stress-testing antagonist at the same time, then having 3x to 5x
the number of necessary antagonist threads is going to unnecessarily
slow down the test run, which goes against the original goal of what
we were hoping to achieve with check-parallel.

How many tests are you currently able to run in parallel today, and
what's the ultimate goal?  We could have some kind of antagonist load
which is shared across multiple tests, but it's not clear to me that
it's worth the complexity.  (And note that it's not just fs and cpu
load antagonistsw; there could also be memory stress antagonists, where
having multiple antagonists could lead to OOM kills...)

							- Ted
