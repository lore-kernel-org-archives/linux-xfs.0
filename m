Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C0A1F171
	for <linux-xfs@vger.kernel.org>; Thu,  6 Jun 2024 16:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717691660; cv=none; b=t3q5JEY4sAqe8q+UDNYCFiw02iy2YF0G8Qq5ofBA0YH/B3er7yMKTp3AqgCP8A/hy+im8UAg62UIEdbW//2j6Bk9WWeUNKwofnkPHLplqjH7A208iPypS2v1DKENI3IcCR2SD5MvzDV89OduXJQcdpf44vFgPgVz+A/T3dz5JOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717691660; c=relaxed/simple;
	bh=j9df1mjIfuHvs6kA7UrgBnJunyV4/ur2NmUsF8aJy6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HzYdVD6PTGkSEBUzfoCitJ1DBZ7Mlkbqu/MhDnjUFmXgR91xZQfKyW1ec9kgLXLpzlOsNSMBDdSD4lKLMdnHWv4uHoQs1kH82d/AlYfQu5O6Ww+PAmwwGxI6G9qzRJ2qOdg2z9iu8huOmLIANUXr66CceuerXlNGs9iB0GqybSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fm8w7NLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fm8w7NLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6558DC2BD10;
	Thu,  6 Jun 2024 16:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717691660;
	bh=j9df1mjIfuHvs6kA7UrgBnJunyV4/ur2NmUsF8aJy6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fm8w7NLTa9HtHuyN/zZ7SGvjIrKbEMFYSMMVqb/lPGtDHMx9LBF6yn9I2l2gcqm8f
	 mVK7HrN3we67aSLEsvAFc/xuTCjmoMAguH2GTa1BJZF1aDpGoWQqOk/djgcJdFcJAn
	 OPI1RCTfJWVjxmyhPfCFu8DVV2caZMVCW9FfEB6s+MYYv+VIMWFex5cKvS8gjFn9HH
	 5Vmhn8b1KUKQjawPlwlriKepYssTz23wHpZ7XXQVqywEutPiY555/eYr4Cx/EB+/b3
	 7XaXypJD3OvScgWEHqP8EUlrWzEYzSturJuCctMELDoynOCmjm08/fpzoSCF7OAzDT
	 pS3q7PJCoaAag==
Date: Thu, 6 Jun 2024 09:34:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: lei lu <llfamsec@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: add bounds checking to xlog_recover_process_data
Message-ID: <20240606163419.GN52987@frogsfrogsfrogs>
References: <20240603094608.83491-1-llfamsec@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603094608.83491-1-llfamsec@gmail.com>

On Mon, Jun 03, 2024 at 05:46:08PM +0800, lei lu wrote:
> There is a lack of verification of the space occupied by fixed members
> of xlog_op_header in the xlog_recover_process_data.
> 
> We can create a crafted image to trigger an out of bounds read by
> following these steps:
>     1) Mount an image of xfs, and do some file operations to leave records
>     2) Before umounting, copy the image for subsequent steps to simulate
>        abnormal exit. Because umount will ensure that tail_blk and
>        head_blk are the same, which will result in the inability to enter
>        xlog_recover_process_data
>     3) Write a tool to parse and modify the copied image in step 2
>     4) Make the end of the xlog_op_header entries only 1 byte away from
>        xlog_rec_header->h_size
>     5) xlog_rec_header->h_num_logops++
>     6) Modify xlog_rec_header->h_crc
> 
> Fix:
> Add a check to make sure there is sufficient space to access fixed members
> of xlog_op_header.
> 
> Signed-off-by: lei lu <llfamsec@gmail.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_recover.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1251c81e55f9..14609ce212db 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2456,7 +2456,10 @@ xlog_recover_process_data(
>  
>  		ohead = (struct xlog_op_header *)dp;
>  		dp += sizeof(*ohead);
> -		ASSERT(dp <= end);
> +		if (dp > end) {
> +			xfs_warn(log->l_mp, "%s: op header overrun", __func__);
> +			return -EFSCORRUPTED;
> +		}
>  
>  		/* errors will abort recovery */
>  		error = xlog_recover_process_ophdr(log, rhash, rhead, ohead,
> -- 
> 2.34.1
> 
> 
