Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED6B4E9C2F;
	Tue, 22 Sep 2026 20:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790109763; cv=none; b=ZzNtRXOW754XqkxFWkTmWsZU04OK5V4WNURXc3qPTJYm4mLFI+Z2yB9OY7E9yBjZ7j3F8mrx9AxVfVNsOFqWHqX3MWPN2HbI/vuHONd5A7Gwr83yfRsHKe98FIDMR29IHX7rYfMY4mZUizRSLm6t8LHXwUykdsHDtIfC1qcGrd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790109763; c=relaxed/simple;
	bh=3lXpl3UE7AyDeAGPAanPbqklNIdQZmEAqtLgpWdnLrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iVDc9fGMl3m9TbkU9ObGjzfFuJyUpTlWo1RkTki/l9f33ZN1iFndH3SXWAX5LU9bLUMQ/UWkjbXOoxTkEQUarQJnIcCupECOYHIeaw9F1pcCreJu4DnccFlJ1Zdj7oaBS+u0vt5AzBZ0mM9hpR/7i9ne9leoeHBrYE5hG5WrNVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=np76Om/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="np76Om/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C030D1F0089B;
	Tue, 22 Sep 2026 20:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790109752;
	bh=qRHRsqo8o0hNLrRSmD794IHU0wY0Y9CsdLjregfn41A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=np76Om/CgSJJC75OLPUn1rdFuSxXQbyxygvfHbbi/GZcZwrhYhaJhoNG8u1nm7WIC
	 oR+LAFcHqh4wV3bUnun9Y2cvOnIWR3BVCne2NZG8QwoAlQLoRkkn+qPh7IRYN169mI
	 IKRPVGH4vkRrgaBCrC5WGfCFsGsDcgNbXrmoV9u1wFNQlfFnuocGdhFOAeT+mNhkSC
	 OGUBrgeTEOm48D7iQWrxkN8Uvm3/CbmA8wbhgAZTF17JDmgGfdlB+5F1WIt26v+nTv
	 ih9NdFgWcALfdgCwFgbZfvXC14xa3ITMvPZD415cvwskNwBKrWICcSK0jp8NcSfR4/
	 R06yKPnHTPHgg==
Date: Wed, 23 Sep 2026 06:42:24 +1000
From: Dave Chinner <dgc@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/14] xfs: fix ondisk symlink target validation in
 xrep_dinode_check_dfork
Message-ID: <arLoMIvZlGkVQcrB@dread>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120700.181988.4590274849890145532.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120700.181988.4590274849890145532.stgit@frogsfrogsfrogs>

On Sun, Sep 20, 2026 at 11:16:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that online repair of a broken symlink file could fail
> unnecessarily if a local-format symlink target isn't null terminated.
> The ondisk target isn't required to be null terminated, but repair
> enforces that anyway because it uses the validator for the incore
> symlink target.  (The incore buffer is always null-terminated).  Fix
> this by reverting the changes to xfs_symlink_shortform_verify and adding
> an ondisk-specific helper in inode_repair.c.
> 
> Cc: <stable@vger.kernel.org> # v6.8
> Fixes: e744cef2060559 ("xfs: zap broken inode forks")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> ---
>  fs/xfs/libxfs/xfs_symlink_remote.h |    2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c     |    4 +---
>  fs/xfs/libxfs/xfs_symlink_remote.c |    8 ++++++--
>  fs/xfs/scrub/inode_repair.c        |   26 +++++++++++++++++++++++++-
>  4 files changed, 33 insertions(+), 7 deletions(-)

Just tripped over this independently looking at local format symlink
verification for inode log item recovery. Fix looks good.

Reviewed-by: Dave Chinner <dgc@kernel.org>

-- 
Dave Chinner
dgc@kernel.org
