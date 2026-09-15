Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B303CB8F4;
	Tue, 15 Sep 2026 17:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789493902; cv=none; b=aMOWbUE+66V4qBOQJI0kdgkZjWFUu33zyA5AKM9KMexU7qwFvoTuf/zfMIJqd+LwD6uZSSimIZ8jMdqMdW6XJ6ev9T6ddFGh0JwNc1IhV+ex+7aM1fY5jk034HRjONmJleA6646a0kbDPOcE1/yhggwKN04abu665Xniuc/e8yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789493902; c=relaxed/simple;
	bh=/X2ABGyt1SqIl+kabkjicz862lH9DGuCh7FWW7jwwJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h5qmAefgz08bI+Vr6xyyEuTpB7lwTRTFqnrJONa7Xc7zsbETKn+5Kb+pT/sQjVHeBBhfjNrt6LuubhZAyVPbuG3aSmwM5pggDyyQ7ffdiwaSphttFao1oN90zIqvjbn9YXuQ5BbG7jVmCg+79GAetNNFYgmJl/p+eb1JnNq2RtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T0on3fDc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T0on3fDc"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AD40D1F000FF;
	Tue, 15 Sep 2026 17:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789493900;
	bh=f+BAxDWEHuhk2HejEQGGmhPqFNbiHVcTOmZLdQfSJh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T0on3fDcxo4rjcEXhbBuwEsr/+4cZ5tZBRBUebsAXj6x+Zxhvi4AwnobAc5aAFNXV
	 mS5shX0kvXN8HnsbHq6OLrktJw4g0G5jzYgLCe9jykETAdLobBkAdxN/yPjtjwql+Y
	 MCrsQUeZM272ftHRw3bo+R6bHJd0Y3r2/ObaqkCjy9GBX3DAtbpK7XVEpdWIWlDYya
	 zGNfdrp306hj1STCEBV6Wg5nKiuHqcdI8ffl5989+tyKfSsqJsii2bg4XwQHuuoEHo
	 b9zdxVDis9FrrbaoOBpLvAADNzmRbjESz+SdaKAq34Prcnce2zDG4wdi0d9TgSSbb8
	 2Kgz0AZ9WYhDQ==
Date: Tue, 15 Sep 2026 10:38:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs: always call xfs_qm_adjust_dqlimits during
 quotacheck repair
Message-ID: <20260915173820.GE2705364@frogsfrogsfrogs>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
 <178945048522.3061055.5283654279910692050.stgit@frogsfrogsfrogs>
 <aqjkzGLzYfjrWI3Q@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqjkzGLzYfjrWI3Q@infradead.org>

On Mon, Sep 14, 2026 at 11:25:16PM -0700, Christoph Hellwig wrote:
> On Mon, Sep 14, 2026 at 10:36:49PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM notices that everywhere else in the kernel, a call to
> > xfs_qm_adjust_dqlimits precedes every call to xfs_qm_adjust_dqtimers.
> > In particular, mount-time quotacheck does this.
> > 
> > Looking at xfs_qm_adjust_dqlimits, that function is in charge of
> > conveying default limits to a dquot if that dquot's limits have been
> > zeroed.  That's quite possible in a repair, so let's follow what
> > everyone else does and set it.  This requires us to add a new predicate
> > to decide if xfs_qm_adjust_dqlimits is likely to reset any of the
> > dquot's limits, and to set the dirty flag to true if so.
> 
> I'd vote for merging the two functions as they clearly always should
> be called together instead.

Ok, I'll combine them into an xfs_qm_adjust_dqenforcement() function as
a separate patch...

> > A different LOLLM noticed that we have no way to force xchk_commit_dquot
> > to call xfs_qm_adjust_dqtimers, so pack that in at the same time.
> 
> This feels completely unrelated, and could also use a much more
> detailed explanation why we'd want that.

...and turn this patch into a justification for code that forces dirty =
true.  cem said he'd like to take the other 10 patches from part 15, so
I'll move these two to the start of part 16.

--D
