Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7839237CD39;
	Wed,  7 Oct 2026 15:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791386343; cv=none; b=B3AoJ49oOdKq5ZZkH5qE+nWBQWFjya7BSIFkVxuPVAks50sK+GyLNxBmsvb6/HX/5YmXcki9ZkWrsd5EQ4VNmuxaS5B4dJH4nLBJ48EfXw8PoiAe9RhaM/yKKgnIjQjtO79/VKWrbDccj4tHukgQDRw5auai3O74n+xNhbdKGM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791386343; c=relaxed/simple;
	bh=eYSxDY/qaM5SA3ToG8nCg6KhBszaINoHLQkmU3LqRT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JiqZ7Kx1qDjDPo+d/FR7MmYjfkykOMX+eSDr5sXeWHLFAZ9M9N0dzrcfjaA3CLJaVbk1Qv/siEvZ2vQadCHnQSh1LJCF4a5K7lznYemU9qObrDQQaW3v0VSIMi3VMcFUM61zzTw7vKq218LjW/X8PpwcYFBUVjfTP/dXja3aeRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BQRGU/S2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BQRGU/S2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E21F21F000FF;
	Wed,  7 Oct 2026 15:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791386341;
	bh=htXXxv45bbpeGL51KcXde26myOhoTc4sMBCkbGS8GiE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BQRGU/S2MrCpXbE+WaY0Oinqw7NIh2vjaN2vVllxelo8+VpoKohNw0P8c5wV1IT8Y
	 HQwakVmc+IrawsaGb8viP8yshm1rjdsCcDsHVguEBZ3/902Yfa/AjdG3uKUD9A5vNt
	 0KZOyKLw/1DInCF/fn7GrNAKMc8Ks8lMwFt4KfZ4bJuBnkT2416hXuM9TJn1Q81Skz
	 klpIKMP1EILEmn+7K+rKzaEZ42AScyqgTVxbJlTTRfRJ79qNXPEz9iNN3UlletGb5n
	 UTP7891lMkX5gA3OT+lpUbH3t0viOo+mk8/PxCf2aW1DXTeCIqqypH4w/XUzTc4UZh
	 mshZToYUFYvkg==
Date: Wed, 7 Oct 2026 08:19:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs/2304: version of generic/388 that run
 xfs_scrub -x for each iteration
Message-ID: <20261007151900.GT6253@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-10-hch@lst.de>
 <20260929015645.GL2705364@frogsfrogsfrogs>
 <20261005132522.GN26805@lst.de>
 <20261005145123.GB2705364@frogsfrogsfrogs>
 <20261005145615.GB2082@lst.de>
 <20261005152057.GC2705364@frogsfrogsfrogs>
 <20261007134202.GB507@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007134202.GB507@lst.de>

On Wed, Oct 07, 2026 at 03:42:02PM +0200, Christoph Hellwig wrote:
> On Mon, Oct 05, 2026 at 08:20:57AM -0700, Darrick J. Wong wrote:
> > I was about to repy "Sounds like a good idea for g388 and probably g475
> > as well" but then I remembered something from my notes.  The two tests
> > run without _check_filesystems on the assumption that accidental
> > corruptions will multiply until either (a) the cycle_mount will fail or
> > (b) the post-test _check_filesystems will have a lot to complain about.
> > Doing the check every loop cycle reduces the number of log recoveries
> > that we can do in a given SOAK_DURATION by a significant amount.
> > 
> > What if we ran $XFS_IO_PROG -c verifymedia once per loop if
> > XFS_VERIFY_FILE_DATA?  That would avoid a full xfs_{repair,scrub} run
> > (+ extra mount cycle) but catch problems earlier.
> 
> $XFS_IO_PROG -c verifymedia would also verify potentially unwritten
> areas.  We'd still need the full xfs_scrub space map scan at least,
> but I can look into an option to only do media verification in
> scrub, which also sounds useful outside of just xfstests.

XFS_SCRUB_PHASE=6 xfs_scrub -d -x $SCRATCH_MNT

--D
