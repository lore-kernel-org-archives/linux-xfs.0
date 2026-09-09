Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C965657ED81;
	Wed,  9 Sep 2026 16:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788970128; cv=none; b=XpLG1DQi7D/N2Dbi+hWmX22T8Yv1s0MD9gU17wKaipEnOIXI/ktucSs6DZg8kEQ0RADWC+qg6VnstW3SYOxf7dRvBBorf7RrQykzQJkCIxj8mz5kJnc/XrJjun5XxfHFNgeqiUGA8SxFYEHFeI9KhVDXsmKTX8bqrtmfBdxxPmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788970128; c=relaxed/simple;
	bh=S/UQIZuX7pSEQtw6EymF1U7DV5iy9KK1+GVL2aLlpgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCxENWCecLNfGayq5tyZhKlKHtlekaFhsdc0fNE+ycbIHFojuM0BTJgpvSsYENUFdhSDSL6TtjGJwNoTfi6yIQuoS0TNO3TRiMuYJDKMlninmbWkWnR7CqkjaxDemNJ7cge3AHGpVXc9osgpVWHyzUATYUE/nztQHpBI95kwLqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DFjAO7H7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DFjAO7H7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31CC1F00A3A;
	Wed,  9 Sep 2026 16:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788970127;
	bh=hBWAKzvLWfdIO2wpk11o5RxzGhVGcrpOuED+vxWRH2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DFjAO7H7YchODDznxcoEvaXVrKCO/tNLnZF86Q4ZJwY6dWXqzgvijGZaNHNmIwCwF
	 SFqji/acgtoPGGFoak1hWTGYVLYze/c1o5gostl8WLosQNyBxswiBpZHs561iF+Rpo
	 oslOUjfCi6aWZvKxjTjpQ+VQSOiDU7LxQa676x8f+Bu/kywcAb2oi8xGd9W8SnYE2S
	 SCtFDu3Av3REbvHW1g5aMgZyz19mGvQ2d4aF00mbgYQsE9oSCtFpJJzzkRlo6kIIkB
	 bLMav0tCU//+U9jL+FjHKObin9osWuDLTlllDG4WEeZ6m/SdJBNVCuotfKqfd17MrT
	 CB+6BceJVSKzw==
Date: Wed, 9 Sep 2026 18:08:43 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Alejandro Colomar <alx@kernel.org>, linux-man@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] man/man2: introduce man page for
 file_getattr/file_setattr syscalls
Message-ID: <aqGCEDzd39VbrYfY@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260907131747.1389798-1-aalbersh@kernel.org>
 <20260908144051.GJ6047@frogsfrogsfrogs>
 <aqEWjV-NCUuPJlwr@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <20260909150006.GH2619314@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909150006.GH2619314@frogsfrogsfrogs>

On 2026-09-09 08:00:06, Darrick J. Wong wrote:
> > > > +User-space applications should zero-initialize
> > > > +.I struct file_attr
> > > > +to ensure that future fields added to the structure
> > > > +will be treated as no-ops if the structure definition is updated
> > > > +but the application is not.
> > > 
> > > I thought they were supposed to call file_getattr() to initialize fattr
> > > before making whatever changes they want and calling file_setattr()?
> > 
> > Yes, if file_getattr() is used for initialization then zeroing is
> > not required as kernel will zero/check that everything fits, but if
> > used by itself then zeroing would be necessary to work with older
> > kernels. What about this:
> > 
> > 	.P
> > 	User-space applications should use
> > 	.B file_getattr(2)
> > 	to initialize
> > 	.I fattr
> > 	structure beforehand or zero-initialize
> > 	.I struct file_attr
> > 	to ensure that future fields added to the structure
> > 	will be treated as no-ops if the structure definition is updated
> > 	but the application is not.
> 
> I don't see how zeroing (instead of calling file_getattr) would ever
> make sense since that would turn off pre-existing attributes, but I do
> like the sentence "User-space applications should use file_getattr(2) to
> initialize fattr beforehand."

Right, agree, I will shorten to this then.

-- 
- Andrey
