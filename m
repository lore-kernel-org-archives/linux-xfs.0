Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FAC320B
	for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2024 19:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711741517; cv=none; b=nYVs1Vp9OTPvQw820A99Duy/B/WY6PMnRwLGADk991f42TLFzmK8kAN5KAiU9T9TCjDbzT6cQIqW77tFe8XBTg7hqo4CNTmcGHJvXLU+qv0+WIx9HBMYUYQdXJm5pZ3clnRJdUdGeljPGxDpR1jVzPiOTR2yrTzI2bnQegipdYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711741517; c=relaxed/simple;
	bh=2yvvbiighnpQ9+iRuwofJxKQrdGhgMT//YlCesaq6lM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EiU1uxTg2paQvlgsrLylbwQZ+5h+a6Fp1dAQM3TLt42S+fUBnMMrLC2tWXFV75YwZkSsg+pSuMWHN6fSFGR7y5CNPsIWIOJWjo0UVqQ3CXgIYuODvkr1jMKuN5Ev6jS351ADH/qLJo2pY92jE0L8m3aAU71PWqm20pd/xd6TIOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nrVWGxcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nrVWGxcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762C7C433F1;
	Fri, 29 Mar 2024 19:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711741517;
	bh=2yvvbiighnpQ9+iRuwofJxKQrdGhgMT//YlCesaq6lM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nrVWGxcPUfcIjs1DnvMhZlXG6CsB7nnWeCQeRKTuTJxj8i+5NvtsJXfp0xjG4A8DT
	 u98QIVjQyjeuDWsag9aww3hRS/CEMmAKBoKixXo9gHkOSR6TY9U4ZwoLbGOPACFjR+
	 PxvjG3zDlcujhOpS8E7xKg/Nl5EFQlFfFlbnCVidTuWZi28JxIWkfhBpHGdveYiUXG
	 y90pLTKEYye53RfaRM7OlJNPo2f0gT2Zituel4lY1FX6Qsg2chpjRzYXpYAjFA7mP7
	 cPCdArN8cLRYEt1lacJnCQpOlby2okJfA9fPo1xVsnhBeR7A9K1c30fPEyTU0OlgAw
	 vYJlDsXlk3aDw==
Date: Fri, 29 Mar 2024 12:45:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/15] xfs: introduce new file range commit ioctls
Message-ID: <20240329194516.GL6390@frogsfrogsfrogs>
References: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
 <171150380898.3216674.17747658861040725823.stgit@frogsfrogsfrogs>
 <ZgP9yEGOO5XZt0_6@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgP9yEGOO5XZt0_6@infradead.org>

On Wed, Mar 27, 2024 at 04:06:48AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 26, 2024 at 06:56:29PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This patch introduces two more new ioctls to manage atomic updates to
> > file contents -- XFS_IOC_START_COMMIT and XFS_IOC_COMMIT_RANGE.  The
> > commit mechanism here is exactly the same as what XFS_IOC_EXCHANGE_RANGE
> > does, but with the additional requirement that file2 cannot have changed
> > since some sampling point.  The start-commit ioctl performs the sampling
> > of file attributes.
> 
> Unless we actually have a good use case for this right now I'd still
> prefer to skip it.

<nod> I'll leave this in djwong-wtf for review, but eventually I'll turn
it into a separate branch that can be picked up or not.

--D
