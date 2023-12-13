Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ADD15A4
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 01:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mq4xryP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A64C433C8;
	Wed, 13 Dec 2023 01:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702431405;
	bh=ZOrV9GzvksAoGeH/Cj1syshPtZ3tlEKkC0lD7wXzyoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mq4xryP6ufPKMSKiqHr9Ypg/BoP5B4REoQKQg3jyWiyQomj9OoSUqY7aaL7dW7wT0
	 wXYRJOf2z6gBF2gF/B8wOi4OeqHVhi7G7YQy2jtUbKZyppCygICvTwEnU+mx1qrKmj
	 2HTT4ayrMf35lMci5Ik7vHUfVQX5jjgbkP5trgoP050y252WuKHPwXN55VDUe5XjpF
	 5llx/Qgi1r+83WmzNQQtvbfFMW+aEtqQ6jeT9SCyc/mXzeYyK0KsA/eg4VGE7BFYye
	 KgUG5zE9T21yjLmpig1r1V9IOA0Qn2S5dQ14UnBHTGJXmXeSiKXoivl5wS5C3MU3Mk
	 ABP/8x+Puwt9g==
Date: Tue, 12 Dec 2023 17:36:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: repair inode records
Message-ID: <20231213013644.GC361584@frogsfrogsfrogs>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666171.1182270.14955183758137681010.stgit@frogsfrogsfrogs>
 <ZXFbHDCxAkFq1OXT@infradead.org>
 <20231211200458.GU361584@frogsfrogsfrogs>
 <ZXfxbsxl1bRwnoSO@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXfxbsxl1bRwnoSO@infradead.org>

On Mon, Dec 11, 2023 at 09:36:46PM -0800, Christoph Hellwig wrote:
> On Mon, Dec 11, 2023 at 12:04:58PM -0800, Darrick J. Wong wrote:
> > > Otherwise I'm still a bit worried about the symlink pointing to ?
> > > and suspect we need a clear and documented strategy for things that
> > > can change data for applications before doing something like that.
> > 
> > For a brief second I thought about adding another ZAPPED health flag,
> > like I just did for the data/attr forks.  Then I realized that for
> > symbolic link targets this doesn't make sense because we've lost the
> > target data so there's no extended recovery that can be applied.
> > 
> > Unfortunately this leaves me stuck because targets are arbitrary null
> > terminated strings, so there's no bulletproof way to communicate "target
> > has been lost, do not try to follow this path" without risking that the
> > same directory actually contains a file with that name.
> > 
> > At this point, we can't even iget the dead symlink to find the parent
> > pointers so we can delete the inode from the directory tree, so that's
> > also not an option.
> 
> Can't we have a zapped flag that:
> 
>   a) let's it pass the verifier
>   b) but returns -EIO on any non-scrub access?

After spending an entire day trying to figure out another way to encode
an empty symlink target that wouldn't trip existing verifiers and
failing, I suppose I will add a new flag.  XFS_SICK_INO_SYMLINK_ZAPPED
and I'll add it to the list of persistable inode health flags when we do
them all.

--D
