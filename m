Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D352389E0C
	for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 10:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768384804; cv=none; b=pr5kdDcUn50gJat8/sxdAHomIt/3PMXHGZgkUQwZvT4wiYigPb2iA9YsQ1neUdszrHVZKlQXb6YDffkmFLQJALwIZUIxvn3qMcK6W/KyQ04D0GIhh37NHQAC5q2zIIsSbmHbJyWlmDI9wYvljydPpBC4m5CiYwbiZZkYWQEznXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768384804; c=relaxed/simple;
	bh=gKN2oFuIeXAR327wxIOJI7czk1si0pm+GLG7DhAC9/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sScuNRIkuMB0bOcWE9++75yAxLkYP4KB4n+nWPWecEdYYULLpIXczcMzMbKvd2svsfADr9DKEbKibgD3gLQVPrtu3RQkE9sB/7Go9CS14A5cbYATLIoiGKrJsblBXKqWwf7fl2iwW5apJjpW5W1+5ExTPbztZk1Gmp/S8m+6p6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBs6IfQM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBs6IfQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE83C4CEF7;
	Wed, 14 Jan 2026 10:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768384804;
	bh=gKN2oFuIeXAR327wxIOJI7czk1si0pm+GLG7DhAC9/4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WBs6IfQMq5oRJKVhGV4Z77ZaUnsNoZX5i7rvm+glul/UusddrxvvSpBi00B+UVqm2
	 gBR+Y787Xg5yecEKV8KjNfTp+/7XoqLVLIkB71mxK6XIEvrDeiUA6Vykq39rVTs5eh
	 fQOBjbW0dKXopfwZRdfGViLmJf36fG39vG4aQCMzWW6qielRJ++PAIlXPMudV7csLY
	 vGaXQSW0/nBBg66SQc8L9xJ4tvuInPLitXngkxEFO9fpiwtrDn0X2dd8T6hTQhNpib
	 MN/9Tpo9leS8HZstcXMhgcxHAJKlKabhhBvkcwTbDp/Pp1vSs4mG8+1255kEhenh+U
	 tryIAAjx3rJmA==
Message-ID: <a24e4edc-c882-4a8b-80b6-da9056e49fb9@kernel.org>
Date: Wed, 14 Jan 2026 11:00:01 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] xfs: pass the write pointer to xfs_init_zone
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20260114065339.3392929-1-hch@lst.de>
 <20260114065339.3392929-4-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260114065339.3392929-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/26 07:53, Christoph Hellwig wrote:
> Move the two methods to query the write pointer out of xfs_init_zone into
> the callers, so that xfs_init_zone doesn't have to bother with the
> blk_zone structure and instead operates purely at the XFS realtime group
> level.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

One nit below. Otherwise, looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> ---
>  fs/xfs/xfs_zone_alloc.c | 66 +++++++++++++++++++++++------------------
>  1 file changed, 37 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 4ca7769b5adb..87243644d88e 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -981,43 +981,43 @@ struct xfs_init_zones {
>  	uint64_t		reclaimable;
>  };
>  
> +/*
> + * For sequential write required zones, we restart writing at the hardware write
> + * pointer returned by xfs_zone_validate().
> + *
> + * For conventional zones or conventional devices we have query the rmap to

Nit:
s/we have query/we have to query (or "we must")

> + * find the highest recorded block and set the write pointer to the block after
> + * that.  In case of a power loss this misses blocks where the data I/O has
> + * completed but not recorded in the rmap yet, and it also rewrites blocks if
> + * the most recently written ones got deleted again before unmount, but this is
> + * the best we can do without hardware support.
> + */



-- 
Damien Le Moal
Western Digital Research
