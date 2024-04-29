Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89B283CBD
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 15:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714404412; cv=none; b=JvIxPVJdfcXXpguo1qS/vkxSBL7/aS+NyjcBe/+26WQxmF9WF97xH3rxUABzAPz9MZ4XwDP5dUEv2ZeQ4PCQDJihSWnR8znRC00yciJvG6I7V61m6N969OCF+thAVysfr3PurlmlVmg5W9p9xu1UNTXz68TsDqjLt8czldyiEYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714404412; c=relaxed/simple;
	bh=wuFZT5MFwQue1A0Rkk0/Z2lwU5LGnUNyr49vNOWlmZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PhKElHb2VZ3mb9p3EH7AyrZZEHqjrKaLrRdBIb/mM/a1Fb8fi76wCCCQOccZA7S+OoAuNAqQpHXbT+ec+76KiR068HkqH1e1L0Kl4qcT29s+0TUHEkzNElyKQdUIHaI6uPyV1FoAPqyZuEy/4mEy1KmzZZQMhqI2SenAFPsuqwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NmDrjkJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NmDrjkJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D89AC116B1;
	Mon, 29 Apr 2024 15:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714404412;
	bh=wuFZT5MFwQue1A0Rkk0/Z2lwU5LGnUNyr49vNOWlmZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NmDrjkJBasfsKkbqRRHzgs9uoY3tiN+YZFA8l4XLw7ZpwZoNIjhgt0goUzgkbL2A2
	 yse26zy2T3XlUw3Fn4CIT4x/jJq41iJrgH58vpHBaAFxLjwmsYxwugHrB0XKW8/k6Q
	 IfNTmYq8ZPBQZJqVcmrcr3jfERZheCNS7e5P87B4rEJ7gD6T3UwupyjCy6K+DprUTC
	 tf6pP82h4XgAQZZXL2/AbNGaiSUcIJ6Cda4Bf3Utj5f8d3M5Hsk/EFU975pQmMwCPk
	 JNQzVWcY/FpXG5disOezh4nkcOrSBfBpQVrlhGNIoGpi15alUyu+3HbUtTXhqvg1q9
	 8J7vKfv2OsyUQ==
Date: Mon, 29 Apr 2024 08:26:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: upgrade the extent counters in
 xfs_reflink_end_cow_extent later
Message-ID: <20240429152652.GV360919@frogsfrogsfrogs>
References: <20240429044917.1504566-1-hch@lst.de>
 <20240429044917.1504566-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429044917.1504566-2-hch@lst.de>

On Mon, Apr 29, 2024 at 06:49:10AM +0200, Christoph Hellwig wrote:
> Defer the extent counter size upgrade until we know we're going to
> modify the extent mapping.  This also defers dirtying the transaction
> and will allow us safely back out later in the function in later
> changes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_reflink.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 7da0e8f961d351..9ce37d366534c3 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -751,14 +751,6 @@ xfs_reflink_end_cow_extent(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> -			XFS_IEXT_REFLINK_END_COW_CNT);
> -	if (error == -EFBIG)
> -		error = xfs_iext_count_upgrade(tp, ip,
> -				XFS_IEXT_REFLINK_END_COW_CNT);
> -	if (error)
> -		goto out_cancel;
> -
>  	/*
>  	 * In case of racing, overlapping AIO writes no COW extents might be
>  	 * left by the time I/O completes for the loser of the race.  In that

I think this is actually a bug fix.  If an xfs_iext_count_upgrade
dirties the transaction and then xfs_iext_lookup_extent cancels the
transaction due to the overlapping AIO race, the _trans_cancel shuts
down the fs, right?

Fixes: 4f86bb4b66c9 ("xfs: Conditionally upgrade existing inodes to use large extent counters")
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> @@ -787,6 +779,14 @@ xfs_reflink_end_cow_extent(
>  	del = got;
>  	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
>  
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +			XFS_IEXT_REFLINK_END_COW_CNT);
> +	if (error == -EFBIG)
> +		error = xfs_iext_count_upgrade(tp, ip,
> +				XFS_IEXT_REFLINK_END_COW_CNT);
> +	if (error)
> +		goto out_cancel;
> +
>  	/* Grab the corresponding mapping in the data fork. */
>  	nmaps = 1;
>  	error = xfs_bmapi_read(ip, del.br_startoff, del.br_blockcount, &data,
> -- 
> 2.39.2
> 
> 
