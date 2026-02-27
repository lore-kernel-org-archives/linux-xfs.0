Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB77279DC3
	for <linux-xfs@vger.kernel.org>; Fri, 27 Feb 2026 12:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772193970; cv=none; b=WZF+QcbQUMwnwT7/B8pnywvUUkRMsglVW9GbydO1IfkO+tIn95wJV5kEJmuA5g0RB9WPWw6yW64Fv7vaZ64vun0+K+egy8o7MA3s1fbu0IDhCaOwA0edL0Obr5GEraefMwrf9uEdCDaGtOtPfw40TGKKgrRefkbRikze+r31mV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772193970; c=relaxed/simple;
	bh=+3Dzd4tyddQavHioEUmKmFJ4n1nBWXcYE/OhpxlCdBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ez0aBYdoIvr9kMIgzHVUj/xbyYVHj8ytbpQcvdWDKwl1cLJiXu3cImBhgRQYTEXoR1n+O0P4i+lV7kXwMma93omt5jBhwdhylnLnBDo2HMHnBFn+AwDDB72TgVjElFanIvqzBhxFjdfS9d1QMYP2Temoavz7aIyUMVbzC99maKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jMzxIVXu; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jMzxIVXu"
Date: Fri, 27 Feb 2026 12:05:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772193966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dsP/JQZ+Zaq82z5JrI6qLtzkvjI5jzRNUWJWT41j2oY=;
	b=jMzxIVXuqdhNYbGW9HBqYG6y7djez3jriGIoxFlgWfK7V2oicNlyur7iTLvBalCycRd+nE
	XhsdQr7wIrRZJ8FV6nzEuAMHiFbA3WfcMxr3WkKTwXfoJzfimFpernl4bDuaTwthzZ8Rp+
	T2/HD30DdinMhqw0nnvREOI1hSWrXrU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: Lukas Herbolt <lukas@herbolt.com>, linux-xfs@vger.kernel.org, 
	djwong@kernel.org, cem@kernel.org, hch@infradead.org, p.raghav@samsung.com
Subject: Re: [PATCH v10] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <mkvpxf3xsfmbko64qfzbnz54dbokifkejlgtl5tnu3263ingop@435s7e3pins3>
References: <20260225083932.580849-2-lukas@herbolt.com>
 <wmxdwtvahubdga73cgzprqtj7fxyjgx5kxvr4cobtl6ski2i6y@ic2g3bfymkwi>
 <aaB38r55RPLj3ij-@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaB38r55RPLj3ij-@bfoster>
X-Migadu-Flow: FLOW_OUT

> > Hi Lukas,
> > 
> > I independently started implmenting this feature as well. I ran a test case
> > on your patches and it resulted in a warning in iomap_zero_range.
> > iomap_zero_range has a check for folios outside eof, and it is being
> > called as a part of setsize, i.e, before we change the size of the file.
> > 
> > I think we need to do a PREALLOC and then do a XFS_BMAPI_ZERO with
> > XFS_BMAPI_CONVERT. Or I don't know if we should change the warning in
> > iomap_zero_range.
> > 
> 
> The reason the warning is there is because iomap_zero_range() uses
> buffered writes but doesn't actually bump i_size for writes beyond eof.
> Therefore if it ends up zeroing folios that start beyond eof, writeback
> would potentially toss those folios if i_size wasn't updated somehow or
> another by the time it occurs..
> 
> I'd guess there are two likely scenarios that lead to this warning, but
> you'd have to confirm. One is that we're unnecessarily zeroing an
> unwritten range for some reason. That would probably be harmless, but
> unexpected. The other would be zeroing written blocks beyond eof, which
> is risky and probably something we want to avoid, but also suspicious in
> that I don't think we should ever have written extents beyond eof in XFS
> (but rather either delalloc or written).
> 

Thanks for the reply Brian. The issue is the latter.

As a part of the new FALLOC_FL_WRITE_ZEROES flag, we do want to
physcally zero beyond eof before we update the size of the file as a
part of fallocate. But we will zero them out by directly talking to the
block device. As you say, we should do only unwritten extents beyond
eof, we can do something similar to what ext4 does: write unwritten
extents first, increase the size of the file, then zero out those extents
with XFS_BMAPI_CONVERT with XFS_BMAPI_ZERO.

I will send the patches soon.
--
Pankaj
