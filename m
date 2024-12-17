Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A911F755F
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 17:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455456; cv=none; b=HaNbfjhELIKLkTmLXsdwYDz3Hf/8iKd6Aa7zzYCQJclgNn0WaH3VvJyUp40HrWGROqg4+i7P7cZY7vX7kD+4PFWKNUE1CHlWSzb35fotrjmQBMa3tq4hrd4kVOUgAFSKTJniQD2lAMkxHd+waMOzGunmQsfwg2mjwN+MuQ4Ro+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455456; c=relaxed/simple;
	bh=vfkcBcgodcstZ1cUv+p1zzYVfci6su3nHvhHd5QSlqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kgssKl7zTQ47aYIWduyh0sEku5+w4gDzXIn1DkEjOM9eLezEwgO1du3Fko6P3oPa/VXrGm9vSAgbFzbsOBcGNsblcJpdUcGa2b38uUL08OuxTDlDZIc7+0dtIPuhpM7whk1rcUSNSh3YV7aEiOKpjZJLiOrDIs2/hQGOjWXb03w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=diq1e8TQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="diq1e8TQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48311C4CEDF;
	Tue, 17 Dec 2024 17:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734455456;
	bh=vfkcBcgodcstZ1cUv+p1zzYVfci6su3nHvhHd5QSlqo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=diq1e8TQ+UKN5Kl5gveIMb/vj643Qmv2v+cOUNXjR54OUINoq74DkVowqSIcGL7yU
	 GQoVSN98tp5fiXjCrglT6DFMlPoeEYXUGwTF86y4oG97z9tgXhYkk3qSte9xVF+1fe
	 VScMlqvsBJjugnG82IVb8mRnt8zV/EBBtxjKpM9EtH0KLMymrhS3rrnbyRHUZ5jSKX
	 pnNE29HqwAh0qOjqJhqHjtufx2G7brZR43NImydP+sEiRZxNt3YfJujl5KDhXalgj3
	 0BdWa6Q1WHrMYb+hA1PJ0RTgI6lGGi5WYvbxzGSB2MIjNvrSW5H6VhXDiMue4l5ruw
	 LEImAWqrabqcg==
Date: Tue, 17 Dec 2024 09:10:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/43] xfs: disable reflink for zoned file systems
Message-ID: <20241217171055.GJ6174@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-37-hch@lst.de>
 <20241213231247.GG6678@frogsfrogsfrogs>
 <20241215062654.GH10855@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241215062654.GH10855@lst.de>

On Sun, Dec 15, 2024 at 07:26:54AM +0100, Christoph Hellwig wrote:
> On Fri, Dec 13, 2024 at 03:12:47PM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 11, 2024 at 09:55:01AM +0100, Christoph Hellwig wrote:
> > > While the zoned on-disk format supports reflinks, the GC code currently
> > > always unshares reflinks when moving blocks to new zones, thus making the
> > > feature unusuable.  Disable reflinks until the GC code is refcount aware.
> > 
> > This goes back to the question I had in the gc patch -- can we let
> > userspace do its own reflink-aware freespace copygc, and only use the
> > in-kernel gc if userspace doesn't respond fast enough?  I imagine
> > someone will want to share used blocks on zoned storage at some point.
> 
> I'm pretty sure we could, if we're willing to deal with worse decision
> making, worse performance and potential for deadlocks while dealing with
> a bigger and more complicated code base.  But why?

Mostly intellectual curiosity on my part about self-reorganizing
filesystems.  The zonegc you've already written is good enough for now,
though the no-reflink requirement feels a bit onerous.

But hey, it's not like I have numbers showing that a userspace
copy-dedupe gc strategy is any better, so I'll not hold up this whole
series on account of that.

--D
