Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26BB1F95A
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 15:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730821289; cv=none; b=FN/k+O8Oyg2Cdzvw6Wd4DgMb4MixF+I13LWBXSIfMYr3h7OvJu5Aamc9yLppQgXWmDJtTcsBriE9HQqy+f4YQVs+NO10sC+ooQzPj+i3syPQdLTn935CNutrl7yYuaZYoBHY3N6tLB5c16wXFCiWpP/5clOriG7PWO1TqR6UH9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730821289; c=relaxed/simple;
	bh=fB33uAI/QO5+f2nsws/D/YQzhj3WUfO8133pFJ63i/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FLNfOMScG7/5/3EowRpLBnlLVAHKYZeUs/L5WvuXQVVxIrTfbYUa8hwC4PYkSYSCDD0wBhHHQrJXKs8CmcfrIY4akdjujY/nmwk5CxF3M2QOkKUwtYqwjWUdCefBCr/UCkBcocr2SXCTd0kzLN0BYEH5M7hpd/93laXtddLRTAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n8K5CMCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n8K5CMCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8B4C4CECF;
	Tue,  5 Nov 2024 15:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730821289;
	bh=fB33uAI/QO5+f2nsws/D/YQzhj3WUfO8133pFJ63i/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n8K5CMCltm0+uF4tLnIu2ZOBB47ChNkeW/9zOp/vEwD3IKQBbu68lVG/UstNO0xDQ
	 nz60QXu/uVNTCcSy7bZeFEGVAe7GU5HCapeTCfYQXSflj+5JMCQoFg1QcLzfKQFuYU
	 kXRSspqbU5QwaMGs5hX6ugQg9f19CKob8kGFBN/Hkv2DabVLc/Vof7vNINQj2PYvCF
	 X5qkiZG+soEig6uZaLQWpZfbKBCXkvyXOOR1p6AzlCeSa0/B6zuH+Is+zpC4HuXH0S
	 oFVBTEH5NAmSF9vWc4V+AYPConrQpM0BvFloUaSGennXYBBqZSKqK4uSbyPuM6sonv
	 gpwQVY2pghtHQ==
Date: Tue, 5 Nov 2024 07:41:28 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, david@fromorbit.com
Subject: Re: [PATCHSET v5.4] xfs: improve ondisk structure checks
Message-ID: <20241105154128.GE2578692@frogsfrogsfrogs>
References: <173049942744.1909552.870447088364319361.stgit@frogsfrogsfrogs>
 <pe7qdtl3omqnhxw7qbtqko4ywvhhrtcljvbfz6d54po7kpabch@l2a6ftl7p7ir>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pe7qdtl3omqnhxw7qbtqko4ywvhhrtcljvbfz6d54po7kpabch@l2a6ftl7p7ir>

On Tue, Nov 05, 2024 at 01:57:33PM +0100, Carlos Maiolino wrote:
> On Fri, Nov 01, 2024 at 03:18:28PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Reorganize xfs_ondisk.h to group the build checks by type, then add a
> > bunch of missing checks that were in xfs/122 but not the build system.
> > With this, we can get rid of xfs/122.
> > 
> > If you're going to start using this code, I strongly recommend pulling
> > from my git trees, which are linked below.
> > 
> > This has been running on the djcloud for a couple of weeks with no problems.
> > Enjoy!  Comments and questions are, as always, welcome.  Note that the branch
> > is based off the metadir patchset.
> 
> This is giving me some conflicts on top of -rc6. I'm assuming you'll rebase it
> on top of -rc6 and send a PR later on?

Yep, I intend to send out my 6.13 PRs later today.

--D

> Cheers.
> 
> > 
> > --D
> > 
> > kernel git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=better-ondisk
> > 
> > xfsprogs git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=better-ondisk
> > ---
> > Commits in this patchset:
> >  * xfs: convert struct typedefs in xfs_ondisk.h
> >  * xfs: separate space btree structures in xfs_ondisk.h
> >  * xfs: port ondisk structure checks from xfs/122 to the kernel
> > ---
> >  fs/xfs/libxfs/xfs_ondisk.h |  186 ++++++++++++++++++++++++++++++++------------
> >  1 file changed, 137 insertions(+), 49 deletions(-)
> > 
> > 
