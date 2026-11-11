Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794379641;
	b=YbYCk46UlFHIUHOmJ2lPJxtSUnRqHVFk+Ed7hmhzOsseWIWmwEqT7HAOKgwBsAMDihEg
	 D70Bxo2/GjUYwfJSY5aQKrDonZqYLcjlEac47u+0oXydnWZzRpH18o65xeBlbmu5nVZZi
	 i9lZISiXx1fbPL5zpG3RwV2QxDAnOhMs+fwRAz+4ST8jCMaX+d1a0GcsoMrPPTywCQjPo
	 Zqq15u/5d4PVg4BAQt24AaA45Ob3Y6QjcWJ0++7ynHRjI+77B0squV5kkS0vQh0+Sx5ES
	 el3/LfmoZEdQZj5LXqnrc3SO++PUYhxLtpQHNQ2XiebpBjEgVIqXqsQztdTJs/Zz7LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794379641;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=rizz0kyhNJ1YCkAfgnYmdjWW7spqcFj6soIo0U3qukA=;
	b=Xx7XpRbnoDsQ89fcz9bDQnib1tki+Yhgp842E1h3u95l8e348KqyqZjFVfdV9WsQdrMR
	 /0XbMOEeq913ij5W260NsyqIZgVHU8q2qYaOvZB7g9Jrudn7IeaVjUgRNgALGtnGngeJM
	 H9xSC2ih81UHlnFDBZO0XhZdMdDAoe/cr+ZNm9/jNRGGQmoetrb+cIlg7KTns1p87G1iE
	 4BvATdbL/iYucdHxi020O/7ycmzk84FLcNqmpzfwEbwqeFALJobGu08tfdvhPTE8QC7Y1
	 8CvUfvjd04vYN2biJC+WH9FClfiEXu3WvmdGzCW4kGQbFaXqd2+7xQGwuaO1HhmQYpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jFNsEONc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5ED606A326;
	Wed, 11 Nov 2026 06:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jFNsEONc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6921F00A05;
	Wed, 11 Nov 2026 06:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794379641;
	bh=rizz0kyhNJ1YCkAfgnYmdjWW7spqcFj6soIo0U3qukA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jFNsEONcd87Q2NYPTWAZFDabJtEpeUt/HScJuR5annauuIim/QKgco46001xb0Qyo
	 vBB0j+eqx3aDM+UqJrdTasKjyiUnZfJcLfOlb2QhChaA+yCj3BdcBvFuUtBxkNKSM6
	 HY+o3+N/K9WEWrMO8YowE+SlaeVneh5bkpm0cXsB28/8KHWIKKQTdvn2prI3z6+ZiI
	 YBMxOrMgJBqN1bkcu4BbM61JPt0GwnQA/hLWRasZXPiH2DE3NRS7sKzcoJuPOdiGlr
	 qwIplWdV/o9lPBLHc0PaVRcvwX91qHBV+a0GBVxl80Apa0xiyX5zfclo1R0b7FT8e0
	 qixAhGbdB6Efg==
Date: Wed, 11 Nov 2026 17:47:11 +1100
From: Dave Chinner <dgc@kernel.org>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] xfs: skip redundant fsync cache flushes
Message-ID: <avQPb5z4ExBOiEJq@dread>
References: <20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com>
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
In-Reply-To: <20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com>

On Wed, Nov 11, 2026 at 12:17:10PM +0900, Daejun Park via B4 Relay wrote:
> Concurrent fsyncs often wait for an iclog that another task wrote out,
> and then send their own cache flush. Patch 1 numbers the cache flushes
> on each buftarg. Patch 2 uses the numbers to skip that flush when a
> later flush has completed.
> 
> 16 fio jobs of 4k append + fsync in a QEMU guest: 1111 -> 4498
> fsyncs/s.

Ok, the number looks good, but IMO that's a very low number of
concurrent fsyncs in general terms.

Typically the journal doesn't start to bottleneck until there
are hundreds to thousands of concurrent fsyncs and/or synchronous
transaction commits running at once. NFS servers are typical for
this, where there can be thousands of in-flight modifications that
each require require ->commit_metadata to fsync changes before the
server returns the response.

In the past, I have used dbench with increasing number of clients
(into the thousands) to stress fsync/log force behaviour and
scalability. The journal has historically topped out at somewhere
around 20,000 forced log writes a second. It hits that limit when
the built in batching (don't send the current iclog for write when
not full if the previous one is still syncing) is not longer
effective at reducing the number of iclog writes the log forcing
load is driving....

Hence the numbers look promising for low concurrency fsync
workloads, but I'd really like to know waht happens at the high end
when log force count rather than per-file fsync latency is the
performance limiting factor. I suspect that it will improve
performance by further mitigating the number of log writes and/or
cache flushes that need to be done, but it really needs to be
tested....

I'd also like to know how this affects storage that does not require
cache flushes - in those cases flushes are no-ops, so all this
tracking and sequencing would likely be pure overhead....

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
