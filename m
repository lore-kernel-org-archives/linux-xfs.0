Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D547E11E
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 06:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717136303; cv=none; b=SdhOpSRbzlPt7PxncaSiDbYSi2Rp16sROtT6sPL9p09bTkhwdSCoLEdKNRHwBVM4HOI2PVG0DRRM+x5Zhhcgubp53MIxt5baL7D9Qq3ad9dXIDirdH52pdw1HEYzjvM7ZJq62cwXugACmSoZLzFVeBEsp8V4N/9sBM4vmdmrofo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717136303; c=relaxed/simple;
	bh=3ExIqqlrFtxLy+ERvYxTiGPq4gU3CZKVNeKlM7fD5zE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iNxPcdPhpKKmNVgcdDHXDxmEX9R3k2GwgZGQSEawgfGE4T1o6sLoGHMTnqEt46nP/KYeDq7gPMvQ+5YEOJZ339V1TyrFZpp0whVakQBmNH+veustBzAKDe2nhagHv4ncWtwJ7JqkVBVG/YbpRyyFm2HWEC8nh0T8vvKwPusf4zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mpvLsZHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mpvLsZHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F419C116B1;
	Fri, 31 May 2024 06:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717136302;
	bh=3ExIqqlrFtxLy+ERvYxTiGPq4gU3CZKVNeKlM7fD5zE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mpvLsZHIEVSgstoyUR3SNw63nGeXXhkPRKDsNGEPEoFTb+5k1mhYZlxkNiMDSOvAq
	 X8A/mhS7MPw01oVwv9ksIhEq6xtH9f2GUk8rlhZgTe/bH0PZQCXKcYWu8fAkbgscdM
	 277FMwLmzsiJUpkvQQa6rqq4dw4wQbCmNsx/PocWEN+owu5Mxn4GfWYSAlhUVcewKH
	 UubAoFOm2nejGx9B+ABsKIqOviurR4YubK1zWMK3L0Moxupr5H16MTDhuDPFF4VB0B
	 YpqTh/kykZm0GSb9X7vE4DRhz/jPjItD9OEuzNzqSUC1FMS3CV/4mlVHw1N/OzufaK
	 7dmlJ2OnfbjbQ==
Date: Thu, 30 May 2024 23:18:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: weird splats in xfs/561 on 6.10-rc1?
Message-ID: <20240531061822.GG53013@frogsfrogsfrogs>
References: <20240530225912.GC52987@frogsfrogsfrogs>
 <ZllikUoZiO3jVqru@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZllikUoZiO3jVqru@infradead.org>

On Thu, May 30, 2024 at 10:39:29PM -0700, Christoph Hellwig wrote:
> On Thu, May 30, 2024 at 03:59:12PM -0700, Darrick J. Wong wrote:
> > >From what I can tell, this wasn't happening with my 6.9 djwong-dev
> > branch, so I suspect it's something that came in from when I rebased
> > against 6.10-rc1.  It seems to happen all over the place (and not just
> > with realtime files) if I leave Zhang Yi's iomap patches applied.  If I
> > revert them, the screaming seems to go down to just this one test.
> 
> When testing Linus' tree I haven't seen this yet, but I also haven't
> done a lot of testing yet.  I mostly triggered odd MM warnings that
> Johannes fixes, but I haven't seen something like this yet. 
> 
> > The file itself is ~1482KB, or enough for the file to have 0x169 actual
> > blocks of written data to it, so the delalloc reservation is beyond the
> > eof block.  Any thoughts?
> 
> I'll see if I can reproduce it with your tree.  I have a pretty full
> plate given that yesterday was a public holiday here which doesn't
> really help my catch up rate..

Yeah.  You might want to revert all of Zhang Yi's patches first, though
maybe his new series actually fixes all the problems.

(Hm, no, it's still missing that cow-over-hole thing Dave was musing
about.)

--D
