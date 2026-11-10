Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.31
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794317242;
	b=s8XRDo9hx84opAdYrkZJbqcrT/0rCgkRyL2o7FHsfJZ89pe40H5E5tEAASRijE+SdzFp
	 I649mo+8s1Hv2Lj6pw6wVKAr3vuwfnJ/d0eAn1Pxygx2FPSbR10dsn4lkVIP+wwRh+w5K
	 iZwMSsqdDISg1WU8noy3j9EIyFKccvqIrVQLNFClt+x5vjHMxuDZAtghURq0k7HIeMCmq
	 jIBRh3F8r2O3AveZcHGopVmO3pl1wE+0T+0UVXCWFJwrnWqFlzHFy1FXMKd9qcb//ApF7
	 0HbNdxvkLydQBi/87m2qKKm9rK+XhypyZjd6CFPLnsugSkNWHhlfVuc+2kVip1YiMrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794317242;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wxaCYyKL+z4mqSacizxtGpLwQg976okfyyahEHpaHsY=;
	b=kr2/dIWD2zyrNEfOG6KX3ojh0m1Pm+3gn5H3fdLRTug1IbT1R0hdc+qRKyXcPXUWRh1j
	 oKR+FhwIrS//IIHOfECM5hCdnufxdKPezlJfL4xJLpsqCzeOxBBn9Vz50iIfW5x1MxcXn
	 h+mW002qLAgZ0VEemnwSPa8BE9o/DcYQJU3gTYqIfF8ietaqmqrCwJI13fbkbduifKh7d
	 KPfakMyTopVlf+Z9uQ17yTsi4T8fFsCne5NLbdo9WXt3GcYxka62dFXWbc9bQQEw1nFNV
	 pDT9uK/3lr8MuDP5dgwlhU6adoZYLkQTssdPmwBW11+OE0zpCA0Vjp8HlkVJ3YTF+Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Hg8ZZveN;
	arc=none smtp.remote-ip=95.215.58.31
Received: from mta1.migadu.com (out-31.mta1.migadu.com [95.215.58.31])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6664606A9C7
	for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2026 13:27:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6664606A9C7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Hg8ZZveN
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ZeuUfEfQhCgZ/JtebCRh29O9EvKPCwKAdhyX7sNum/k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794317238; v=1; x=1794922038;
 b=Hg8ZZveN2MXg+dQOCvqXKdVn2uuRgRfWJO5U8ZuNeAwdpcpch68Pbv6740xLqSHhrRgHbBcw
 OfZErMtvLOUKZoT9gvQlAjJgOJsoVKB+/k//2bIXWeI1A0TZxRMekRbaCYX+MN7VhV9AawNvxX/
 Mf/HNoGltsDy5gj1oapADiJM=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a733b54b25416052;
	Tue, 10 Nov 2026 13:27:18 +0000
X-Mizu-Trace-ID: a733b54b25416052
X-Migadu-Flow: FLOW_OUT
Date: Tue, 10 Nov 2026 14:27:08 +0100
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	Pankaj Raghav <p.raghav@samsung.com>, John Garry <john.garry@linux.dev>, 
	"Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: check the disk address for hardware atomic writes
Message-ID: <avMVZKaUjc8qVktd@quentin>
References: <20261110-xfs-hw-atomic-align-v1-1-2274b169c32e@samsung.com>
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
In-Reply-To: <20261110-xfs-hw-atomic-align-v1-1-2274b169c32e@samsung.com>

On Tue, Nov 10, 2026 at 05:00:57PM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> xfs_bmap_hw_atomic_write_possible() checks the alignment of the encoded
> br_startblock, not of the disk address. The two can differ outside the
> first group.
> 
> Since commit ec8f62cc109a ("xfs: don't limit software atomic writes by
> the group alignment"), a misaligned write can reach the hardware path.
> The block layer can fail it with -EINVAL, and XFS does not retry it
> through the COW path.
> 
> Check the disk address instead.
> 
> Fixes: ec8f62cc109a ("xfs: don't limit software atomic writes by the group alignment")
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

The changes look good to me.

It looks like this bug got exposed as a side effect of relaxing the
software atomic writes as we should have always did this check in
xfs_bmap_hw_atomic_write_possible()?

Could you explain a bit more of that in the commit to give some more
context?

Especially, we need mkfs.xfs < 6.16 to trigger this for data volume but
it is an issue for rt volume even on latest xfsprogs.

> ---
> Affects a group size that is not a multiple of the device's atomic
> write unit max. mkfs.xfs 6.16+ rounds agsize to it, not rgsize.
> 
> Tested on emulated NVMe, 64 KiB atomic unit and boundary: 64 KiB
> atomic overwrites in AG 1-3 (mkfs.xfs 6.6.0, agsize=262142b) and
> rtgroups 1-7 (xfsprogs 7ebfc20eb88e, rgsize=65534b) failed with EINVAL
> before and use COW after. fstests -g atomicwrites, xfs/838 (rt): no
> change.
> ---
>  fs/xfs/xfs_iomap.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index c3465204b8d..cfa2f7ac03a 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -848,8 +848,11 @@ xfs_bmap_hw_atomic_write_possible(
>  	 * atomic writes are required to be naturally aligned for disk blocks,
>  	 * which ensures that we adhere to block layer rules that we won't
>  	 * straddle any boundary or violate write alignment requirement.
> +	 * Check the disk address: br_startblock carries the group number in
> +	 * its high bits, so it can be aligned when the disk address is not.

I guess you can keep the comment generic by saying "fsbno is not a linear
disk address" as we can have start offsets for rt groups.

>  	 */
> -	if (!IS_ALIGNED(imap->br_startblock, imap->br_blockcount))
> +	if (!IS_ALIGNED(xfs_fsb_to_db(ip, imap->br_startblock),
> +			XFS_FSB_TO_BB(mp, imap->br_blockcount)))

Good catch.

-- 
Pankaj
