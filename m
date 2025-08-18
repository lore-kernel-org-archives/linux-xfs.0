Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F26C274B31
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 20:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755550171; cv=none; b=WVHjhwCrvzlpZWHDt3Kg04nr2W5cTdNzNVX9ac8ji+j7WbBRgPiB5VocFdNgi5owZ5xAyY9glyRebGovUs3Wc3j6zHRMPxTkX3lRiSXrxMxITdxxH/szGI5F7N+pcXag0o56+2Pad83bi7XJe1tL6+5uJBPZIYagjDhrjicHB3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755550171; c=relaxed/simple;
	bh=yVoFoZNT/zvBaVA4cGgxZXf2HLJF2cE/onn3B9T+244=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oXEl6USVxKOJ9ze4Pp6vAkdqsVc5/vurtrkMUC6meSVAK+gcH2fgOnMbSdrzQzrme2RwcfOVHjzBtydMdsILhjZ9jST/39dY/E7eANTYZb809FDZE3BXc366i0CRP/2z4gGgc2cSvKPF0Pr4sfgmhJ5W9FgbljlQ0CFFs+JdgqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W1/NM/N8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W1/NM/N8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E71C4CEEB;
	Mon, 18 Aug 2025 20:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755550170;
	bh=yVoFoZNT/zvBaVA4cGgxZXf2HLJF2cE/onn3B9T+244=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W1/NM/N8XQbGKVnK4JYbkTTJNuOEqkOuP67mbM5O7vGoXCi31HIwLhXj7scZ4mY3R
	 voUJWD8LiWtWxh8trMkhvEEyCBVPMyC8L09fx85tlS0m3YLGpEK8lct9SE4BZRRPPL
	 XLx2Fwe4Ts8IZk2UZ2Sg+auxJNkMkjgYzP9yqRpiS4Ncv6y+M3DbWUe5EI3D7FZzMK
	 ixPLuO6pO0iVSYnKgyAaK6DAaMldpAP50bPWDUOnJeQcdERJ3IuZSNiEdWmP2lgNtt
	 wIwRq8mc8XP8WPCQdajt7y3UzAgiP4VuL6ZYkS59gsn43UXvtRroElBWmU5S8CaPSi
	 w4N7zap92dpoQ==
Date: Mon, 18 Aug 2025 13:49:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: use bt_nr_blocks in xfs_dax_translate_range
Message-ID: <20250818204929.GZ7965@frogsfrogsfrogs>
References: <20250818051155.1486253-1-hch@lst.de>
 <20250818051155.1486253-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818051155.1486253-3-hch@lst.de>

On Mon, Aug 18, 2025 at 07:11:24AM +0200, Christoph Hellwig wrote:
> Only ranges inside the file system can be translated, and the file system
> can be smaller than the containing device.
> 
> Fixes: f4ed93037966 ("xfs: don't shut down the filesystem for media failures beyond end of log")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_notify_failure.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
> index fbeddcac4792..3726caa38375 100644
> --- a/fs/xfs/xfs_notify_failure.c
> +++ b/fs/xfs/xfs_notify_failure.c
> @@ -165,7 +165,7 @@ xfs_dax_translate_range(
>  	uint64_t		*bblen)
>  {
>  	u64			dev_start = btp->bt_dax_part_off;
> -	u64			dev_len = bdev_nr_bytes(btp->bt_bdev);
> +	u64			dev_len = BBTOB(btp->bt_nr_blocks);

Yeah, dev_len is used to filter out ranges beyond what the filesystem
cares about, so

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	u64			dev_end = dev_start + dev_len - 1;
>  
>  	/* Notify failure on the whole device. */
> -- 
> 2.47.2
> 
> 
