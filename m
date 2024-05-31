Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C6C15D5A6
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 13:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717163882; cv=none; b=LTGxCM3Uvs5GCtvrJt6mDjtN73AeaV3OIi1IdbE9oDd0UxRhvRnlLeoBSWm9KGor5WkTId0BZx8QSUZZit/BMOBOyyMcF4WS95o88wpOxoBAUjt16iSAp3U1yykY9naGjXic2o/f5JW59lHDxmi+9Yk0faeLWzS+J9NQUwaeNjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717163882; c=relaxed/simple;
	bh=5mKXkSYVbG751Bbihh/7bWA8USJOyI570GqvdA9ruto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eLzmK54S07AyDST3FuMP9uuxVOfjvuF4sXPmVgZOoM1aEEC6moYICWgEUAZOLhyF+IaMkXd/T6vsPW9h7sxk1x0RoPhRV5Z7sOBa+8WoIFEpI2EoiHdtdiV7xi31rzdsB6aKBHECGmcPeHd9rkNO5DlrQ2TKesehKXNA4tGd87U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dowP8X+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dowP8X+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED0CC116B1;
	Fri, 31 May 2024 13:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717163881;
	bh=5mKXkSYVbG751Bbihh/7bWA8USJOyI570GqvdA9ruto=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dowP8X+XjUP5KdwW+jZuQd3dVF/9yRVro+63S3BpxhFzKFuWH4eBzCF3NK7Y5Vp22
	 GUa6O4QiLj1Mr4/z69aXPvA794qUHS+zYSsUzrHMwERGNDKyKJ/5pRb/umy4ozLzj7
	 JQCIROgbUnqaKT6shJ3r7t2BE7SoIiN7Gs+HzsBwQytvvce2oYrZjZ++t+R63svgQE
	 EzTqddSc4cf9bG+a+x6FYTqymZqmzT87eGxSTDiaca5zhIplEFMb5Fde46m4RXoGIy
	 ZM2VJ2y3ByNcJdG61asGcqp99zex3eQyPedrCVSv5gTm48KgWLZ5rgHmKEjyICA6o6
	 bdjZejPeiWe9A==
Date: Fri, 31 May 2024 06:58:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: weird splats in xfs/561 on 6.10-rc1?
Message-ID: <20240531135800.GE52987@frogsfrogsfrogs>
References: <20240530225912.GC52987@frogsfrogsfrogs>
 <ZllikUoZiO3jVqru@infradead.org>
 <20240531061822.GG53013@frogsfrogsfrogs>
 <ZllslcE-Oj6JkYfD@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZllslcE-Oj6JkYfD@infradead.org>

On Thu, May 30, 2024 at 11:22:13PM -0700, Christoph Hellwig wrote:
> On Thu, May 30, 2024 at 11:18:22PM -0700, Darrick J. Wong wrote:
> > Yeah.  You might want to revert all of Zhang Yi's patches first, though
> > maybe his new series actually fixes all the problems.
> > 
> > (Hm, no, it's still missing that cow-over-hole thing Dave was musing
> > about.)
> 
> I've kicked off a run with realtime and rthinherit on your current
> realtime reflink tree and haven't seen any warning yet.  Do you know
> if it's limited to > 4K page sizes?  My testing ability on that is
> unfortunately limited to a used macbook running linux in a VM as that
> Asahi installer sucks ass, so rather limited.

I don't know specifically if it's limited to > 4K pagesize, other than
to say that I haven't seen it show up on x86 yet.

--D
