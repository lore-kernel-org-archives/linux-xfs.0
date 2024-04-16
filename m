Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9868137773
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 19:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294385; cv=none; b=Zpo+PlOJ6UEMm3/HzNUunpYP+Nny5vh5w7UUTEC/PVmHryczG5ruW194f19P4UbM3tCZP5km9B0CU0fpyk1aQ4s4SOPYEaTR4rpznJi5UQefeFe9Rb77yVBWwn+kXkBIWRbx0ib7W1DdMbJkCaRycKG0xPDVcvHHT4FBTzGWQaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294385; c=relaxed/simple;
	bh=IQF/lhehrUKPy7fyaBtnil0tSPZx8jjCelt6yI3Eiv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nj01gjrLUz9BVK1gC7/diTpo/zWp1am56RButOBf/CsbJsy17q7Sn/Pb89KPRJorrrYcog4zC/yFF/YxLErvxkb+RQiTupTpXGvHRspqo2cXH5PeLpkQExFrV9pbeblpUVycj/RQE2UuzV0pi1g0Jlx7takbr111YyJnL9q09ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVkKBhWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVkKBhWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602E5C32786;
	Tue, 16 Apr 2024 19:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713294385;
	bh=IQF/lhehrUKPy7fyaBtnil0tSPZx8jjCelt6yI3Eiv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iVkKBhWKf/zncxcMh9xmK3oqNtnOh04Jyx1c0/fRN+mZe7ZM2dOvxnz1vyRf+79kO
	 hYHXKQGs6XhJQgBN6K1mgOLEoYlF+Z06M6xATndrgBtpsrt1Cil77f3jNBjMJZJkbj
	 4o3kS7J1zcaXAgAjPrHEjI6de09RPutSj4qxkDLaUhVqfVXA7b4sv8qWXsSoKjydyL
	 jd/S55afYvcnAtbBAnKaNcDg31gtv3HznCuH9u7CFlF9QvQILZ/FoIY0w2JIMc+G+c
	 DGhsKU1kAMsqTu95LbhC90GDhrQiMoCdLm1/vLZ1J0YTeCkH8Qjwbw/18OC2UMtArg
	 IrvQgkc/TJBwg==
Date: Tue, 16 Apr 2024 12:06:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/4] xfs: introduce vectored scrub mode
Message-ID: <20240416190624.GB11948@frogsfrogsfrogs>
References: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
 <171323030293.253873.15581752242911696791.stgit@frogsfrogsfrogs>
 <Zh4NtkXCdUumZmFQ@infradead.org>
 <20240416184652.GY11948@frogsfrogsfrogs>
 <Zh7J1tDb4nEDkCKo@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh7J1tDb4nEDkCKo@infradead.org>

On Tue, Apr 16, 2024 at 11:56:22AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 16, 2024 at 11:46:52AM -0700, Darrick J. Wong wrote:
> > "A reviewer asked why didn't I design the interface so that the kernel
> > determines what scrubbers to run and in what order, and then fills the
> > output buffer with the results of whatever it decided to do.
> > 
> > "I thought about designing this interface that way, where userspace
> > passes a pointer to an empty buffer, and the kernel formats that with
> > xfs_scrub_vecs that tell userspace what it scrubbed and what the outcome
> > was.  I didn't like that, because now the kernel has to have a way to
> > communicate that the buffer needed to have been at least X size, even
> > though for our cases XFS_SCRUB_TYPE_NR + 2 would always be enough.
> > 
> > "Better, I thought, to let userspace figure out what it wants to run,
> > and tell that explicitly to the kernel.  Then the kernel can just do
> > that.  The upside is that all that dependency policy and ordering logic
> > can be in userspace instead of the kernel; the downside is that now we
> > need the barriers."
> 
> Maybe it's just personal preferences, but I find these a reviewer
> asked dialogs really odd.  Here is how I would have written the
> above:

I find it weird too.  This is a defensive reaction on my part due to
criticisms from patch reviewers earlier in this project over documenting
paths not taken, aka "Why would you include this bit that doesn't
correspond to anything in the patch?" :(

> The alternative would have been an interface where userspace passes a
> pointer to an empty buffer, and the kernel formats that with
> xfs_scrub_vecs that tell userspace what it scrubbed and what the outcome
> was.  With that the kernel would have to communicate that the buffer
> needed to have been at least X size, even though for our cases
> XFS_SCRUB_TYPE_NR + 2 would always be enough.
> 
> Compared to that this design keeps all the dependency policy and
> ordering logic in userspace where it already resides instead of
> duplicating it in the kernel. The downside of that is tha it
> needs the barrier logic.

That sounds better to me; I'll put that in the commit message instead.
Thank you for that.

--D
