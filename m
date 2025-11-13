Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2632D6E51
	for <linux-xfs@vger.kernel.org>; Thu, 13 Nov 2025 11:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763032154; cv=none; b=pJCS/Fao4sCsc73ETkskFMIAtdM6YZT03yeJ751vCOTE/qqKmArniaNA2uT6mFXjhLKqPItvEl9eDRkV86NDQxZybM6DmR3KHQfJM08O1YNPNnJCpfjoN4NqORiPnkkc9YE92Ix0rZOBqvFe/t8W0tHkmZTau9S5QzATnqpa1ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763032154; c=relaxed/simple;
	bh=1mRlQqJT8tc+WfmsJKzktgmuAOQ+AUnfN6uAFt/9Uec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L3rwgZHN6Pxh8fsdLwgwmtwbYmqw/EaYCYMzv7rst2r+Tbxlytf2RskA5WcWfaJtCcGV6Gp0l5/aC1EI/fML1arAulzDcTh4aUxL9pjcIoLPoncBHpYV2TQZ6mi9JxScy7wHLhY5RyrfL1FdjTz3Mrc7b/vTYwiyeZzIuRu+wBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pFxgb9ZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pFxgb9ZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B0FC4CEF5;
	Thu, 13 Nov 2025 11:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763032154;
	bh=1mRlQqJT8tc+WfmsJKzktgmuAOQ+AUnfN6uAFt/9Uec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pFxgb9ZNvlCRNENR/OvH/4BfyGeVk98MBxnex2pSyrMeCPTqDRKWoYZnjw78P72yt
	 5Gt47jX7H3UWaImiA0FEkfFp76wsBvvFftENR6Xpr9hsuQ8Hsfp5PEypZDErGBoxeI
	 UakKkoXfekrEO+dJM9pd9KUS5O4JHeHq13TGRtlTCXNVMemPFu+U2hykZlXqWC6+J3
	 P5xgBZzdML6CUJz+LEfsBadNq6J5FuFOYlrqiuwbRZx8wGcgHs4mOnfrngt+PKZ6YT
	 1BayUCNvAJU56i6Y1jH97D5X05TzeHGAbK0cte6SUYYX9ed1PIZBc6spzbe7sC6Ksq
	 /yX8RlCnTH7vw==
Date: Thu, 13 Nov 2025 12:09:09 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, aalbersh@kernel.org, 
	david@fromorbit.com, hubjin657@outlook.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] metadump: catch used extent array overflow
Message-ID: <aiqeiz2c6pwtcsojofyfnv7r5o67ip2p24faf2kjwdbtdlf475@6u3ruuk5fbx3>
References: <20251111141139.638844-1-cem@kernel.org>
 <NM5nTfOcdVh4Bz31WhekwpUkERNHbF4mHQTkHyzB2nADKWkzKweM2xvo8AyVGHJnBk0joWMby8EL6pNvIVmKQw==@protonmail.internalid>
 <aRNGBoLES2Re4L5m@infradead.org>
 <t2d73maqm4uxsipsacb423dcsg3u6dy3gty3u34wlj3zp4xfgw@lalkwdrmkj2b>
 <20251112163608.GZ196370@frogsfrogsfrogs>
 <kiF3QEt7mVpzNcCiRIobKwQml-Bf3KcdLNIvDtizjwO1h7qnl91aha-zXymV9Qs9oGaCX1nqcAj3bYpf_oHOBg==@protonmail.internalid>
 <aRS4Smu72bIwabJn@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRS4Smu72bIwabJn@infradead.org>

On Wed, Nov 12, 2025 at 08:39:38AM -0800, Christoph Hellwig wrote:
> On Wed, Nov 12, 2025 at 08:36:08AM -0800, Darrick J. Wong wrote:
> > > > used really isn't a xfs_extnum_t, so you probably just want to use an
> > > > undecored uint64_t.
> > >
> > > Fair enough. Thanks!
> >
> > Does check_mul_overflow work for this purpose?
> 
> 
> Oh, I didn't realize we have that in xfsprogs now.  Using it here
> sounds like a good idea.

+1, thanks Darrick, I'll update it.
