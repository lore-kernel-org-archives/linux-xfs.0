Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CED9136E12
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 18:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293213; cv=none; b=V/eR0ZFS8WWSf1I7YEaYsT7H11MjhzKSt4Qbs+ATCdp0ymtNSygE3XAVeljOIwiAIE7sgHme9fZFohw1BdJ4jydsbuk/5xLTakb9nmhrBFGHj8wa4vWB/4yvilAFXZd7Iy8mtBYuBQEY64RRJ2XQgozGO6Dp/81l2jz1o3LoFRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293213; c=relaxed/simple;
	bh=W5TqMeB1CHC7HqXwpCi3DUGZXYuwjNch/zpIQkPZwOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g02hMUDEV6MT8lSiUnpUeR/gxJ2EKvYR/jBl7YF9BiKGJEaBn+mD3Oh1rDosNFXkfUo7etPOdIHhTM3bAPET0c7yi0iVbrh8rt/JoNIMM3kt31n4oBoCODaKoRv3HApkXpL122oO/E2G3B3u9vtTj6TqyJA7msG4C08hZLZD+JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bzsHN15k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzsHN15k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918A8C113CE;
	Tue, 16 Apr 2024 18:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713293212;
	bh=W5TqMeB1CHC7HqXwpCi3DUGZXYuwjNch/zpIQkPZwOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bzsHN15kRbF58KqT02bF+EG+RQI1PwwrcTsHpRmO8p2qGYYSPzOEaCBGZjAQEahTF
	 9Uurn4tmGJuuSMkEKIh6MIVOOXNH4CkVPmi+7xVvjgn1HlErK+Q7p+LACUDmN0YcEQ
	 BEgp/X40DS8B5fqLYuenE5YTYih9EjOY1GfgDwiqpTSWQ6IlVYMWwF+avYt+AeMtbI
	 x8WzKE3BNvURRR422iQvgpbQA6STwqCk8VGvFihCFBTZbWA+BwTTujA19f3fsdTueE
	 hmvcVHpguvWYsASN+8Gq3Qnejy7WXY73+7iiKybIlVV4OHG9NYog4vsY+7OrYiLFbF
	 LDkxFnLlHX8KA==
Date: Tue, 16 Apr 2024 11:46:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/4] xfs: introduce vectored scrub mode
Message-ID: <20240416184652.GY11948@frogsfrogsfrogs>
References: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
 <171323030293.253873.15581752242911696791.stgit@frogsfrogsfrogs>
 <Zh4NtkXCdUumZmFQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh4NtkXCdUumZmFQ@infradead.org>

On Mon, Apr 15, 2024 at 10:33:42PM -0700, Christoph Hellwig wrote:
> On Mon, Apr 15, 2024 at 06:42:12PM -0700, Darrick J. Wong wrote:
> > A new pseudo scrub type BARRIER is introduced to force the kernel to
> > return to userspace if any corruptions have been found when scrubbing
> > the previous scrub types in the array.  This enables userspace to
> > schedule, for example, the sequence:
> > 
> >  1. data fork
> >  2. barrier
> >  3. directory
> > 
> > If the data fork scrub is clean, then the kernel will perform the
> > directory scrub.  If not, the barrier in 2 will exit back to userspace.
> > 
> > When running fstests in "rebuild all metadata after each test" mode, I
> > observed a 10% reduction in runtime due to fewer transitions across the
> > system call boundary.
> 
> Can you record your explanation on why we don't encode the order in
> the kernel code here?

I have added the following to the commit message:

"A reviewer asked why didn't I design the interface so that the kernel
determines what scrubbers to run and in what order, and then fills the
output buffer with the results of whatever it decided to do.

"I thought about designing this interface that way, where userspace
passes a pointer to an empty buffer, and the kernel formats that with
xfs_scrub_vecs that tell userspace what it scrubbed and what the outcome
was.  I didn't like that, because now the kernel has to have a way to
communicate that the buffer needed to have been at least X size, even
though for our cases XFS_SCRUB_TYPE_NR + 2 would always be enough.

"Better, I thought, to let userspace figure out what it wants to run,
and tell that explicitly to the kernel.  Then the kernel can just do
that.  The upside is that all that dependency policy and ordering logic
can be in userspace instead of the kernel; the downside is that now we
need the barriers."

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D

