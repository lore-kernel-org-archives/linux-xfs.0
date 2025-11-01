Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5C9A59;
	Sat,  1 Nov 2025 15:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762011757; cv=none; b=lV/ZPaqtJxohsC7ReFXY5HeR3gC3P+k0f10plWUSiObGgnRSDmTveFfq5XtXCHdt8h8z64TrVax3+DwVBHWU77ZSae2RZZheRwXC7AVa6mwPVI/SFOuq3dbAQd1xdHUeVtLgANwKhMa1DZf7gj8imKzrCF6yZcfR0KXrm537AdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762011757; c=relaxed/simple;
	bh=V07lZsrxvWXMK8WB9s+PWL1C4odDK+wtZZoV5pOb2zQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TURAiGAew3YqI5XWspbg2MCYm43HFJGU8QgoGH7UUxBa9eVQkFhRjFLJipIOh5x2IkPBtyIzCnjndJEI8cjO8/RKg2m/JSQ/Ac/UX8FXtcGsZQOXTLj6kYVS74RD8YRfyM8OGkNCxmdSetkh9d3WWHQ0hw8XMijE/+xYJ8Xa3vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S1cqjkQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S1cqjkQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7617AC4CEF1;
	Sat,  1 Nov 2025 15:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762011756;
	bh=V07lZsrxvWXMK8WB9s+PWL1C4odDK+wtZZoV5pOb2zQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S1cqjkQqMIpTeMljNJekQ+Hy1L9rHsrgikqPcS/m6qqeW1vgizxMsa0ufOxIzeQQ9
	 ivjertPGdTHZYa8pc9nYGWTX8RSl/k5+EEDAb5SHYb/if2R0OBKUdkm6gKrvXs5wSy
	 lDq9iPYsom3UuZoPTNZtI0e574JgeO1cGe/1iT5jW4lNoARu1eJQO5KxNdM5HeRx8C
	 e4f4/tEhtSu4hZiOUmT7ifBCydJ/21BiJHNVpLGO33Yjvb7N/7hDtVJGXRTvqHumKN
	 6xa8g6uCDqoIlSqWaxBK/VUYQnQRFTTNjrRMxPxJ4RhEj/t7F65Mgg4osav4hCYlft
	 qrqAeFYj8dijQ==
Date: Sat, 1 Nov 2025 08:42:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] generic/778: fix severe performance problems
Message-ID: <20251101154235.GX4015566@frogsfrogsfrogs>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
 <176107188833.4163693.9661686434641271120.stgit@frogsfrogsfrogs>
 <aPhbp5xf9DgX0If7@infradead.org>
 <20251022042731.GK3356773@frogsfrogsfrogs>
 <20251031174734.GD6178@frogsfrogsfrogs>
 <20251101093418.wxv6w6diisvflrrp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251101093418.wxv6w6diisvflrrp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Nov 01, 2025 at 05:34:18PM +0800, Zorro Lang wrote:
> On Fri, Oct 31, 2025 at 10:47:34AM -0700, Darrick J. Wong wrote:
> > On Tue, Oct 21, 2025 at 09:27:31PM -0700, Darrick J. Wong wrote:
> > > On Tue, Oct 21, 2025 at 09:20:55PM -0700, Christoph Hellwig wrote:
> > > > On Tue, Oct 21, 2025 at 11:41:33AM -0700, Darrick J. Wong wrote:
> > > > > As a result, one loop through the test takes almost 4 minutes.  The test
> > > > > loops 20 times, so it runs for 80 minutes(!!) which is a really long
> > > > > time.
> > > > 
> > > > Heh.  I'm glade none of my usual test setups even supports atomics I
> > > > guess :)
> > > 
> > > FWIW the failure was on a regular xfs, no hw atomics.  So in theory
> > > you're affected, but only if you pulled the 20 Oct next branch.
> > > 
> > > > > So the first thing we do is observe that the giant slow loop is being
> > > > > run as a single thread on an empty filesystem.  Most of the time the
> > > > > allocator generates a mostly physically contiguous file.  We could
> > > > > fallocate the whole file instead of fallocating one block every other
> > > > > time through the loop.  This halves the setup time.
> > > > > 
> > > > > Next, we can also stuff the remaining pwrite commands into a bash array
> > > > > and only invoke xfs_io once every 128x through the loop.  This amortizes
> > > > > the xfs_io startup time, which reduces the test loop runtime to about 20
> > > > > seconds.
> > > > 
> > > > Wouldn't it make sense to adopt src/punch-alternating.c to also be
> > > > able to create unwritten extents instead of holes for the punched
> > > > range and run all of this from a C program?
> > > 
> > > For the write sizes it comes up with I'm guessing that this test will
> > > almost always be poking the software fallbacks so it probably doesn't
> > > matter if the file is full of holes.
> > 
> > ...and now running this with 32k-fsblocks reveals that the
> > atomic_write_loop code actually writes the wrong value into $tmp.aw and
> > only runs the loop once, so the test fails because dry_run thinks the
> > file size should be 0.
> > 
> > Also the cmds+=() line needs to insert its own -c or else you end up
> > writing huge files to $here.  Ooops.
> > 
> > Will send a v2 once the brownpaperbag testing finishes.
> 
> Hi Darrick,
> 
> JFYI:) If you don't mind, as I haven't seen your v2, I'll try to merge this patchset
> without this [09/11] at first. Then I can merge another patchset "[PATCH 0/3] generic/772:
> split and fix" which bases on this patchset, and give them a test.

Sounds good!

The 778 changes are going to take a while longer because it keeps
breaking down in weird ways on 64k fsblock filesystems.

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > > Otherwise this looks good:
> > > > 
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > Thanks!
> > > 
> > > --D
> > > 
> > 
> 
