Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916F085C5E
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 18:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734545800; cv=none; b=Nty7M7KoMwNFcBO82WD2z8wpiDsAl24yabjHRkMWE/Nx39eqqqfgUcBcubXZf0eSjfOKOquLeN4JMWviEzZi73zbBDpQeY4snvseYNaUYfnJk0Wc9f8ZdtC/fTCwtwppH9rNVzSxr8w3SdC5ZrOwGrmpfSHUaWqRjxkYRvxVgTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734545800; c=relaxed/simple;
	bh=YqopJ40cPjz4ggkZmdZ37kc19kHxRkr2yzwUbFgVtiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NPc/kL1QWN6d4vJdxu1pYrXfL/Dtr4No7GzTdxDBgEdOJmzJMWvuJXdZwuTrvR6Jd3K4JaD/gclxx9VScN9K76/y0TAYYJrVn9+f3k1R62AwDNa59JT9nCeGn5bVkTpZtSDSMzIuZncx9R+qFLuYEDvNK2vWwHnMNTlKOFOMFr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a2OE+a8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a2OE+a8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AA2C4CECD;
	Wed, 18 Dec 2024 18:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734545800;
	bh=YqopJ40cPjz4ggkZmdZ37kc19kHxRkr2yzwUbFgVtiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a2OE+a8MwctIMT8Xabx7SRw6KmxjYfjVD0A2fs10hWNlZDCE3e5sBnAmARe3FxPwM
	 LEOY99rNs89cuSLDk1BYrBgsQs09Hx5P0ZqFxST3LozNiHZhLJA78muxTgfy4JlgfG
	 PkkvXwdKXBS+OT6dYdg79XUwbYgvFIUmKnoZD+vl3EmBdxPfS97kNeD/frEDgJLO1h
	 JzToX0UaCqnYFW/5thH3pzbd02xT1IDChROzbH+YS9OcAiSxn2ZYMyKwRy9yqFCKyA
	 rKXzfd+bKcNn7+hqe+vDAOygw3SsOEOnPdo7vS3sAMIXY6KcWa8FFkKB4hM/pTqCnV
	 lGLhdudtROdsQ==
Date: Wed, 18 Dec 2024 10:16:39 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/43] xfs: disable reflink for zoned file systems
Message-ID: <20241218181639.GY6174@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-37-hch@lst.de>
 <20241213231247.GG6678@frogsfrogsfrogs>
 <20241215062654.GH10855@lst.de>
 <20241217171055.GJ6174@frogsfrogsfrogs>
 <20241218070934.GA25652@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241218070934.GA25652@lst.de>

On Wed, Dec 18, 2024 at 08:09:34AM +0100, Christoph Hellwig wrote:
> On Tue, Dec 17, 2024 at 09:10:55AM -0800, Darrick J. Wong wrote:
> > Mostly intellectual curiosity on my part about self-reorganizing
> > filesystems.  The zonegc you've already written is good enough for now,
> > though the no-reflink requirement feels a bit onerous.
> 
> The no-reflink is mostly because we want a minimum viable merge candidate,
> and our initial uses for things like lsm databases and objects stores
> don't strongly need it.  I hope to add reflink support ~ 2 or 3 merge
> windows after the initial code.

<nod>

--D
