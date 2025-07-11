Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA40E18D;
	Fri, 11 Jul 2025 08:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752223483; cv=none; b=pwW7NnKiW9JexjUhPus0eMmfj/1pBfAK9SGI440qmYPIOKhJ4+CNK8fCqb+jWtLQ8ZL0TXJ4dtpzEBENBKQV+sULRdnRbQlk/MCFqSP5zF0CdlbnllOjADawxWCJZjTu35eNERbr66QaoRZVpVIkVYPQsHrKMAeN7NicXrQ5Kn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752223483; c=relaxed/simple;
	bh=6UzQ9X8fgND1wkiNcfbHjH20+xkSoEHtkk9hwmYSovY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RU2zuqT+cE1OUKqfVL347PfroMsrXnl14ZcSSFFAp6Ju1z1+ZzXmVWpinHXiVUl6B/+C/pMuM8GgEMWg5qMDec7ozI65ePuXz7PKVXLkmFF/90Z6TVoZK3XWPpo/e9BADoG1FBGbs6wzAaO0eW4kzcIZSvmmPTP3rborMZgJUOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f4JSKSwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f4JSKSwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A30C4CEED;
	Fri, 11 Jul 2025 08:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752223483;
	bh=6UzQ9X8fgND1wkiNcfbHjH20+xkSoEHtkk9hwmYSovY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f4JSKSwS3O3BmEQzcvUurrEQeBOLNdoYMUi7qzbCfqoDlL3LqOYyR8g0xIVde+i/T
	 sfFjy5dz3z9DMp4iWYlQsocIozAmSEX1IQn4ptIDmkwz9YBxSKrqHyjcoQSsl5Ek8l
	 GA8GSOrBKMj9E+Pgn2zIdGPawoPYknmDDVTXNWuvaZqwCbJbuYjHyRr9qgdWaj+vXZ
	 u/rSJuYs3qbsyAuQqfxQzb9CyT3cIXavVhTMDIhCuZcDqcuHus+qx5mgY4r3l5Mkik
	 gIuIdd3FwjTU5q0FPzDH0Vlvg1HYR1wihRRncLy76aOrutL4isPr36rWDNTnDqTT2p
	 Pku7PZX1lZVpA==
Message-ID: <901ca013-ad1f-45cf-9086-fb4db6c7419b@kernel.org>
Date: Fri, 11 Jul 2025 17:42:26 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/6] block: sanitize chunk_sectors for atomic write
 limits
To: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
 nilay@linux.ibm.com, axboe@kernel.dk, cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
 ojaswin@linux.ibm.com, martin.petersen@oracle.com,
 akpm@linux-foundation.org, linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20250711080929.3091196-1-john.g.garry@oracle.com>
 <20250711080929.3091196-3-john.g.garry@oracle.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250711080929.3091196-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/11/25 5:09 PM, John Garry wrote:
> Currently we just ensure that a non-zero value in chunk_sectors aligns
> with any atomic write boundary, as the blk boundary functionality uses
> both these values.
> 
> However it is also improper to have atomic write unit max > chunk_sectors
> (for non-zero chunk_sectors), as this would lead to splitting of atomic
> write bios (which is disallowed).
> 
> Sanitize atomic write unit max against chunk_sectors to avoid any
> potential problems.
> 
> Fixes: d00eea91deaf3 ("block: Add extra checks in blk_validate_atomic_write_limits()")
> Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  block/blk-settings.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index a000daafbfb48..a2c089167174e 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -180,6 +180,7 @@ static void blk_atomic_writes_update_limits(struct queue_limits *lim)
>  
>  static void blk_validate_atomic_write_limits(struct queue_limits *lim)
>  {
> +	unsigned long long chunk_bytes = lim->chunk_sectors << SECTOR_SHIFT;

Don't you need to cast to a 64-bits "lim->chunk_sectors" here ?

>  	unsigned int boundary_sectors;
>  
>  	if (!(lim->features & BLK_FEAT_ATOMIC_WRITES))
> @@ -202,6 +203,10 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
>  			 lim->atomic_write_hw_max))
>  		goto unsupported;
>  
> +	if (WARN_ON_ONCE(chunk_bytes &&
> +			lim->atomic_write_hw_unit_max > chunk_bytes))
> +		goto unsupported;
> +
>  	boundary_sectors = lim->atomic_write_hw_boundary >> SECTOR_SHIFT;
>  
>  	if (boundary_sectors) {


-- 
Damien Le Moal
Western Digital Research
