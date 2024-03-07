Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCD639856;
	Thu,  7 Mar 2024 23:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709853515; cv=none; b=t1EJmbPoz2SnoO9OCyW0BRHRlJYDTUc/Bd/AgxIpEeaRJxr6lUsh+zVbD8lGJciuB8mbZSz0zKEyHnBYHPK/nYetUvEuriMwNlJxDnKGvpMkqWLyluYXOEMPZy6NALldd34lRJwGZ5AU3u7ghG7r0fiOxC5YZtR9ovFeHEwNLuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709853515; c=relaxed/simple;
	bh=vDWF5dtBJbXB1kvkuV2n4Pc13RMCpLTaytfR3Rj9fnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I8MVCjv7XxlTnW33QAPkbkHxJ+QFQTqzaETL52TDxxi1RlyguYvRzWg9WSx4aMSrIGt0aT7qUV9IZ67/PAJp/CU8diomY70BqeLRT9Vt/1tAh5e5cS80Sr+m8/a2xCo54aAOwRehMtPrWk+5Cx/skMpGb0bpxRvSYso55X8YcgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g6++CPMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6++CPMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA242C433C7;
	Thu,  7 Mar 2024 23:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709853514;
	bh=vDWF5dtBJbXB1kvkuV2n4Pc13RMCpLTaytfR3Rj9fnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g6++CPMaEwgh9SGRFUqES/ujgVVFZNqJw1YWgKVYGY7aAnWXZIZgX36t56zCMfYFS
	 vTYoN5weGHydnTiXDVtuPgjN+qf36NefFY83x0amKO9tAVR/5wB6qRGVeuytBwRErK
	 m+wlMhuQe6JLXMFPAOc5yIm4zHNpelLHg/hq/pT7UWrNH57h/vI5blmjRJ4Tew+YWo
	 U0vuSWn0ZVTJgzI2pKTMStedmvrokjCjoO1lHWvL622L/Aif+5wesLmDGaPkXaG9aI
	 mqOThUxbEJPf1THHOh6wD7aClZ25clicYoynUSwpAK8hYqvbQCptRUtJOnPtLaTG6E
	 BM9uEd4McLcWw==
Date: Thu, 7 Mar 2024 15:18:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET] fstests: random fixes for v2024.02.09
Message-ID: <20240307231834.GF1927156@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <20240303133453.bxsvioauy4jhtkgf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240303133453.bxsvioauy4jhtkgf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sun, Mar 03, 2024 at 09:34:53PM +0800, Zorro Lang wrote:
> On Mon, Feb 26, 2024 at 06:00:41PM -0800, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Here's the usual odd fixes for fstests.  Most of these are cleanups and
> > bug fixes that have been aging in my djwong-wtf branch forever.
> > 
> > If you're going to start using this code, I strongly recommend pulling
> > from my git trees, which are linked below.
> > 
> > This has been running on the djcloud for months with no problems.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> > 
> > kernel git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes
> > 
> > xfsprogs git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes
> > 
> > fstests git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
> > ---
> > Commits in this patchset:
> >  * generic/604: try to make race occur reliably
> >  * xfs/155: fail the test if xfs_repair hangs for too long
> >  * generic/192: fix spurious timeout?
> >  * generic/491: increase test timeout
> >  * xfs/599: reduce the amount of attrs created here
> >  * xfs/122: update test to pick up rtword/suminfo ondisk unions
> >  * xfs/43[4-6]: make module reloading optional
> >  * xfs: test for premature ENOSPC with large cow delalloc extents
> 
> Hi Darrick,
> 
> This patchset didn't catch last fstests release. Six of the 8 patches are
> acked, I've merge those 6 patches in my local branch. They're in testing.
> Now only the patch [6/8] and the [8/8] are waiting for your response.
> 
> As this's a random fix patchset, and I've merged 6 of it. If you have more
> patches are waiting for reviewing, you can send those 2 patches in another
> patchset :)

The only pending things I have are resends of 6 and 8.  Will go do that
momentarily, sorry for being a bit late this week.

--D

> Thanks,
> Zorro
> 
> > ---
> >  common/module      |   34 ++++++++++++++++++---
> >  common/rc          |   14 +++++++++
> >  tests/generic/192  |   16 ++++++++--
> >  tests/generic/491  |    2 +
> >  tests/generic/604  |    7 ++--
> >  tests/xfs/122      |    2 +
> >  tests/xfs/122.out  |    2 +
> >  tests/xfs/155      |    4 ++
> >  tests/xfs/1923     |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/1923.out |    8 +++++
> >  tests/xfs/434      |    3 +-
> >  tests/xfs/435      |    3 +-
> >  tests/xfs/436      |    3 +-
> >  tests/xfs/599      |    9 ++----
> >  14 files changed, 168 insertions(+), 24 deletions(-)
> >  create mode 100755 tests/xfs/1923
> >  create mode 100644 tests/xfs/1923.out
> > 
> 
> 
