Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25EA21830E
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 23:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731455988; cv=none; b=LZ++xtvBPfLHrofUGcHoABwIXvkYNQEXrP0u242q0V+m3sjX8gym/Hrvql+AhXsLYxN75dHqy11935VGzwcN75bDnHUiUaji+js1Y5YmXAI7s22CoV5+kN3sKyEQlZtgY+I+5lEtYyPJG4cnjmA2QH7ohSgRRQG1SLJd6ffkxic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731455988; c=relaxed/simple;
	bh=nr8do7R8KbutNbLsF5n65X1/Cd4E+MhVhVDarXilix0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JCJ8ZKffE9CYGMKyOoHpixNusKJBFV2BUirb0i15cXm0o5RGQiHvrDgWSasZI9VpUMAQkRHTbUir+nv08wDMm5CBGGDSjQXDvoJgd9uZSc+wGmEjfYwZfEDcROBul43Wcy0VIMqnuSUWcz/NDNGCOzV0jawPM3BQtU1qIvT1HPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ivnx/udY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ivnx/udY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB46C4CECD;
	Tue, 12 Nov 2024 23:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731455987;
	bh=nr8do7R8KbutNbLsF5n65X1/Cd4E+MhVhVDarXilix0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ivnx/udYtwGvhRdcpPh9Z0DGyLT2YHNjZCPs5nc5XN28ixs7ivZ2sIJCP4f4DuCVQ
	 OO9154Q119fQUy6uzVaThcdY2D0NHcBjjn2GOBb3wEgWC0HkupjyDNU8b+vq28cQ1m
	 MFEESRGTmW2XONFpTpjsyxttoiPaf27NJ/y9V98IvyYVCaK4XMb/BJEBjahnUOos3X
	 CFlRA6Kh90TL8rSZurtQm8TMzediHLKY+3dfI2/+5BDPsl3LmN5Lrg5wOMAHkRZK32
	 O2Rezh7Kk3rpG3xabgJHFRiBtvAG/bl2eYe3C7dHVIPe3itlj3XwObkSUMvL0Iow8m
	 4aASqhFow5LSA==
Date: Tue, 12 Nov 2024 15:59:46 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 0/3] xfs: miscellaneous bug fixes
Message-ID: <20241112235946.GJ9438@frogsfrogsfrogs>
References: <20241112221920.1105007-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112221920.1105007-1-david@fromorbit.com>

On Wed, Nov 13, 2024 at 09:05:13AM +1100, Dave Chinner wrote:
> These are three bug fixes for recent issues.
> 
> The first is a repost of the original patch to prevent allocation of
> sparse inode clusters at the end of an unaligned runt AG. There
> was plenty of discussion over that fix here:
> 
> https://lore.kernel.org/linux-xfs/20241024025142.4082218-1-david@fromorbit.com/
> 
> And the outcome of that discussion is that we can't allow sparse
> inode clusters overlapping the end of the runt AG without an on disk
> format definition change. Hence this patch to ensure the check is
> done correctly is the only change we need to make to the kernel to
> avoid this problem in the future.
> 
> Filesystems that have this problem on disk will need to run
> xfs_repair to remove the bad cluster, but no data loss is possible
> from this because the kernel currently disallows inode allocation
> from the bad cluster and so none of the inodes in the sparse cluster
> can actually be used. Hence there is no possible data loss or other
> metadata corruption possible from this situation, all we need to do
> is ensure that it doesn't happen again once repair has done it's
> work.

<shrug> How many systems are in this state?  Would those users rather we
fix the validation code in repair/scrub/wherever to allow ichunks that
overrun the end of a runt AG?

--D

> The other two patches are for issues I've recently hit when running
> lots of fstests in parallel. That changes loading and hence timing
> of events during tests, exposing latent race conditions in the code.
> The quota fix removes racy debug code that has been there since the
> quota code was first committed in 1996.
> 
> The log shutdown race fix is a much more recent issue created by
> trying to ensure shutdowns operate in a sane and predictable manner.
> The logic flaw is that we allow multiple log shutdowns to start and
> force the log before selecting on a single log shutdown task. This
> leads to a situation where shutdown log item callback processing
> gets stuck waiting on a task holding a buffer lock that is waiting
> on a log force that is waiting on shutdown log item callback
> processing to complete...
> 
> Thoughts?
> 
> 
