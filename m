Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D2B219FC;
	Wed, 22 Jan 2025 03:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737516986; cv=none; b=EeHymJEXFUzXSUn68+G+jAE9Zls4sZn56lRk1d9lGbVCoXe9m4+TuhtbHIP9TIyVW1k7Ftg8hvYSu8EAkzcc3T97qKcxCD9WyGPrpWKxXJSgxeLiKAEIfaKnZYY3DqThbVmWFgLabVonqqUYLMpxzXFl3B3Ru4HhU5kdFbOuRB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737516986; c=relaxed/simple;
	bh=YlxgwC2nQKRXQ4LN1WJ/vx7iVFsohQVRSu5j1c6XAnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sp7/zU/oY5UOLWoEEqs4ujS4eexcG99nwDQXNzLxvrP650NZncJIG9QyIqdFOJOvg7Qbfjvn7+clt0BwbGUdfDyhOSC82586dZgMgZzVYy2EV760m6m5Bd1iHRQilHy66xY8Ri23n75lsrE4MPhmCsm29gDg8XNC3jjMHuIM0bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KvG+BQ0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KvG+BQ0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F129C4CED6;
	Wed, 22 Jan 2025 03:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737516985;
	bh=YlxgwC2nQKRXQ4LN1WJ/vx7iVFsohQVRSu5j1c6XAnQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KvG+BQ0zIOOY5SsmFgcRD9pkfgZXy5j52RvltrDjWX38WDW+GUFLqikhFVHgR2C+H
	 vkn0xQeGsKUnEvuJWGIhYVBRCb9UEt8A4JVohPLXCFqGKyLbl/QXqe/mbSkP2WFW5A
	 qwQPX2DAZqCzD6ugBCmsqleo7SXIROV0FfM2qER4tAObMfOV1EznovkKNWaN03QcDX
	 Fwu0E67BfA84iFCs4+JHcjAb7kneCMzCPB6RGToGy+6WHJcFvmzul5vp0ZEvwkizdC
	 3yxUhpZp22CtoiKL9N/+m1gXL6F1nHKQlc8CGa+nd+2mmiQRKME75+5Vqxoc9ni2l0
	 4wFypyW4bhmLA==
Date: Tue, 21 Jan 2025 19:36:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>, zlang@redhat.com, hch@lst.de,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/23] mkfs: don't hardcode log size
Message-ID: <20250122033625.GQ1611770@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974228.1927324.17714311358227511791.stgit@frogsfrogsfrogs>
 <Z48bYVRvWt-wPmUz@dread.disaster.area>
 <20250121124430.GA3809348@mit.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250121124430.GA3809348@mit.edu>

On Tue, Jan 21, 2025 at 07:44:30AM -0500, Theodore Ts'o wrote:
> On Tue, Jan 21, 2025 at 02:58:25PM +1100, Dave Chinner wrote:
> > > +# Are there mkfs options to try to improve concurrency?
> > > +_scratch_mkfs_concurrency_options()
> > > +{
> > > +	local nr_cpus="$(( $1 * LOAD_FACTOR ))"
> > 
> > caller does not need to pass a number of CPUs. This function can
> > simply do:
> > 
> > 	local nr_cpus=$(getconf _NPROCESSORS_CONF)
> > 
> > And that will set concurrency to be "optimal" for the number of CPUs
> > in the machine the test is going to run on. That way tests don't
> > need to hard code some number that is going to be too large for
> > small systems and to small for large systems...
> 
> Hmm, but is this the right thing if you are using check-parallel?  If
> you are running multiple tests that are all running some kind of load
> or stress-testing antagonist at the same time, then having 3x to 5x
> the number of necessary antagonist threads is going to unnecessarily
> slow down the test run, which goes against the original goal of what
> we were hoping to achieve with check-parallel.

<shrug> Maybe a more appropriate thing to do is:

	local nr_cpus=$(grep Cpus_allowed /proc/self/status | hweight)

So a check-parallel could (if they see such problems) constrain the
parallelism through cpu pinning.  I think getconf _NPROCESSORS_CONF is
probably fine for now.

(The other day I /did/ see some program in either util-linux or
coreutils that told you the number of "available" cpus based on checking
the affinity mask and whatever cgroups constraints are applied.  I can't
find it now, alas...)

> How many tests are you currently able to run in parallel today, and
> what's the ultimate goal?  We could have some kind of antagonist load
> which is shared across multiple tests, but it's not clear to me that
> it's worth the complexity.  (And note that it's not just fs and cpu
> load antagonistsw; there could also be memory stress antagonists, where
> having multiple antagonists could lead to OOM kills...)

On the other hand, perhaps having random antagonistic processes from
other ./check instances is exactly the kind of stress testing that we
want to shake out weirder bugs?  It's clear from Dave's RFC that the
generic/650 cpu hotplug shenanigans had some effect. ;)

--D

> 							- Ted
> 
