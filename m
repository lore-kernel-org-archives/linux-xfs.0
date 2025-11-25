Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B943349659;
	Tue, 25 Nov 2025 02:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764037083; cv=none; b=eLJgKKoFzqnMB8uXsMW9tjb3SO48+FeKbJ4c+cpAQoUaBwASriTc+HPUhbga9C8sr3Y7ChR4SMXvlHTn/vdErfL+urZhj7kMf73Gt/s1uCyfAvFF06WNI3B8FCT2uLHMtvb6Jy4BbKgioWVEjOyxBRY1cWHqf2yGxUva8QmKEwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764037083; c=relaxed/simple;
	bh=Kk/CmrdbxkznimXTdC/ci5K9XqUz1AQXR79o+wFoR8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pZnUf613Pt7zItPm+ofBCABZmwanjaItnX3g+Y4qLzWSbVF0ghJaX3XFJzgx+Nx8JYb/iVhjFP0mtjtMEbZ2+AuVCv+/tRWyOBXZTpkRS42/Igv2JlM+aqtSxmRCozvoGpJbDTa1go+9EoTqBdPl46hZFArktDo5Via0SpAclRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jlfDVqBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jlfDVqBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A20C4CEF1;
	Tue, 25 Nov 2025 02:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764037082;
	bh=Kk/CmrdbxkznimXTdC/ci5K9XqUz1AQXR79o+wFoR8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jlfDVqBOzPpWPIgKqzNrn5fC00E5kFW+D9KcqEqbNlfdOTzIIFW8uG7VtJ5VvLG9c
	 /DeOIWcPzEnt5Z6lQIWzC68wZbHxRduB+EB86AvelCQN32NP90YPJS9cExkUXy/pZx
	 EPcfkW/cBwTPucaao8szoCKiSjIp6uqvQQXr8/IRtUwP6c6PTNObYQbvJ88+P0DMIC
	 bRIl/sWnacKDTFDOs1aYkWKrWENU2qJH+UG9NqqrydPzVtcHplvGU9Ihh2Aw9+rN+n
	 uDrPSXA0mbePvLrDhS+NZxGPjrK982Md12RWrdDfriz0NTI7eguxpaZUjvoTXyoPBT
	 VGsEJdtFBlBfA==
Date: Mon, 24 Nov 2025 18:18:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, alexjlzheng@gmail.com,
	cem@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix confused tracepoints in
 xfs_reflink_end_atomic_cow()
Message-ID: <20251125021800.GA6061@frogsfrogsfrogs>
References: <20251121115656.8796-1-alexjlzheng@tencent.com>
 <aSQmomhODBHTip8j@infradead.org>
 <93b2420b-0bd8-4591-83eb-8976afec4550@oracle.com>
 <aSRmCPKBOpSaAYYN@infradead.org>
 <2ef7123a-cfc7-40b5-beb3-e23db1a0d75f@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ef7123a-cfc7-40b5-beb3-e23db1a0d75f@oracle.com>

On Mon, Nov 24, 2025 at 02:25:29PM +0000, John Garry wrote:
> On 24/11/2025 14:04, Christoph Hellwig wrote:
> > On Mon, Nov 24, 2025 at 10:57:24AM +0000, John Garry wrote:
> > > Commit d6f215f35963 might be able to explain that.
> > 
> > I don't think so.
> 
> I am just pointing out why it was changed to use a separate transaction per
> extent [and why the cow end handler for atomic writes is different].
> 
> > That commit splits up the operation so to avoid
> > doing the entire operation in a single transaction, and the rationale
> > for this is sound.  But the atomic work showed that it went to far,

It did go too far, because when d6f215f3596 was written we didn't have
these nice helpers that guestimate how many deferred remapping ops we
can attach to a single fresh transaction.

Nowadays we probably could speed up the non-atomic remapping path by
computing a safe batching factor and doing that much instead of only one
extent per transaction chain.  Stupidly hardcoding 16 would be enough to
achieve an order of magnitude improvement.

Nobody's complained about slow ioend performance enough to do that work
and then QA it though.  Remember, that d6f commit comes with the
following barb:

"Note that this can be reproduced after ~320 million fsx ops while
running generic/938 (long soak directio fsx exerciser):"

(generic/938 is now generic/521.)

--D

> > because we can still batch up a fair amount of conversions.  I think
> > the argument of allowing to batch up as many transactions as we allow
> > in an atomic write still makes perfect sense.
> > 
> 
> Sure, Darrick knows more about this than me (so I'll let him comment).
> 
> 
