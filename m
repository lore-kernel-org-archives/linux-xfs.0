Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792869620;
	b=5iAM0LOHpC1jkK6PEbc6mFUpoPzy8qKddJ+t/GAd6AUy7uoDPHxfaCsI+DdWF5dkEq+t
	 EgFZAiDXsqJhEFjP/60jnrZJpx3ZV3EjpHPzFTMtTJPnuPfqHklfa2NyjDxAY5vwbP5dx
	 nKaF4kTeNBXmAHwSSXB/K+UO1VCLfzfHH0BuuFLDPtmBhYGLLhh9HD772xkFAA4eTGJZM
	 jAlAsXs3X4tn0t3whYTffScrbRrUWFiSYGjZGi7/b75/lWaWlY/2Gpbt69ozVXrbGswGs
	 3uP5mwtc0UVQzeGYQL5dsxNz+NKS4NouFQAALPHbIyxwm6HJ4ipRC76DCj7fBYNak3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792869620;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=zupueEs92LLYhplKMYURHzUt9KCcFQQdwtlOs89HPOI=;
	b=wFHR6pD3oa72NRvWZInG9+nnJCH9IKrkFjS/fo1kX6ZeJs8TtL2Fq9AEaTQhg6VIqbFq
	 ulVNmo5kREfCEt9qIKvCKPc/rMVof+pyPkdarLtmxPLjbOq5iylfITu70dnrJqRua5sSf
	 hJcSI5YP/Vx65+4S5aFTpWYEJN24H+/3HR+ZFj1gqqzyK6KpbE7K+ySbGqjQyg1sOpPiZ
	 55JqgKjpnj/b2Uzow6SXpr2LkCcD+PeWsFGIdzpGgTav/2mf03N9SWIrOYgh19S0tCRrN
	 pYHFOrjpCpQeAiB+9GinwR6lmvnUpflOItUzs6yA8CLCLDZxNheXdwSsKQyT/UrsKIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NYz2U1JU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAD7606A31A;
	Sat, 24 Oct 2026 19:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NYz2U1JU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8894B1F01825;
	Sat, 24 Oct 2026 19:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792869619;
	bh=zupueEs92LLYhplKMYURHzUt9KCcFQQdwtlOs89HPOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NYz2U1JUdsTsXpsZPMHyY+GfubyW4W5DiXoocXwqCA7aiJE8dNB8zaX3eNCMkxldb
	 A5Y3ccC8BQj1aJhLQSJCmr+L5eOwFy+6N3fpV3GXuLvbce9Xy1hlbrtjX/WIRQeK/O
	 0dvx6ZI6szQz+Nrkwr90sD6Ii7OSkBcflLfRdKyHWV7/3o07xNavk9VlF7KxEYPjqO
	 9iCi2oVbbllbKEncXfI2ZzlQbpXE0dp3lP35W0nNoW47HtRmdX+YaGjZfVJyMRXFNl
	 pDaWb+l4e03a/0mPb0KZm1U0rW7pU1DKNvvQIzYW0VXwNk+RaDK0OE03LZaqChuX9c
	 PGiXyFaAIRTDQ==
Date: Sat, 24 Oct 2026 12:20:17 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@kernel.org>
Subject: Re: [PATCH 1/2] dcache: don't leave negative dentries in casefolded
 directories
Message-ID: <20261024192017.GG2553@quark>
References: <20261023-work-dcache-casefold-v1-0-1b0bd5c73a69@kernel.org>
 <20261023-work-dcache-casefold-v1-1-1b0bd5c73a69@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023-work-dcache-casefold-v1-1-1b0bd5c73a69@kernel.org>

On Fri, Oct 23, 2026 at 02:44:22PM +0200, Christian Brauner wrote:
> +static __always_inline bool d_delete_drop(struct dentry *dentry)
> +{
> +	return dentry_negative_policy ||
> +	       IS_CASEFOLDED(d_inode(dentry->d_parent));
> +}

Should this also check IS_ENABLED(CONFIG_UNICODE), so there will be no
overhead when CONFIG_UNICODE=n?

- Eric
