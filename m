Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BBEEAF6;
	Fri, 11 Oct 2024 03:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728617057; cv=none; b=YDmoHq+jIsbdjNNw62pYBuPqiAsJ0Qqri9/QrEPun0sqZ6K7jgJ52CGNMn5lzKJcGynfc3937U+pONBi7HwuHDfNAQk3LluXHi1PUICjAOhxtRW+M73XlwdxqyWExWmuO8lfzOPHNeMm0kA7pNPTSvxrLJv3K66rbfNFD0UxqHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728617057; c=relaxed/simple;
	bh=kUInw0iXWZE0kEy0xOJYNWsYah9TJB93Ibzr5+rEY2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jpoexjbxpvkh6WsHYgrO+IL1Hdg1i/gWOiGys4S6equnUAIwuxmcZ++A2+zGbw/gs4VOjUr9MiFTc54rk/176AtzPh8JjuDxEoS7fdXcDO5tQKwf0zA5yyg3IoNhjS3sn6SvaDBQX4p7DW74rT1pysV9yErb0vIwJxwo2EzP3fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gy4ZiQI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gy4ZiQI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9930FC4CEC3;
	Fri, 11 Oct 2024 03:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728617056;
	bh=kUInw0iXWZE0kEy0xOJYNWsYah9TJB93Ibzr5+rEY2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gy4ZiQI87fSrd0VzsF3oVo3iC/pmH1Zp4F8xQEiY5nCJ6Wkc3nnniVZ7cYpu7twad
	 5qiHPc1F/rgJXbi/eo54S9c58nmU211sft/Lv90ukgTVL1pGfVlrqiBJqTUwvdM7Gy
	 g9TkY472nsFhHQubVH32YMwElTWZ0gsotBiZraHkOaskFrs6BkPus4jnxMidMm7Pui
	 KRdefm5McAKSWzdJBkptopA8BfYh4uh38SuivnWzCiXAueow764Nzzqmm/5BfQdBQm
	 2rrPvIBwNJbx8p6swssh5BGHzu/tMRn2Ca9ktnnIVapo630wxnwsBKHiaQLhbU9hX6
	 jB8Psh0/BF25A==
Date: Thu, 10 Oct 2024 20:24:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chi Zhiling <chizhiling@163.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	chizhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH] xfs_logprint: Fix super block buffer interpretation issue
Message-ID: <20241011032415.GC21877@frogsfrogsfrogs>
References: <20241011030810.1083636-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011030810.1083636-1-chizhiling@163.com>

On Fri, Oct 11, 2024 at 11:08:10AM +0800, Chi Zhiling wrote:
> From: chizhiling <chizhiling@kylinos.cn>
> 
> When using xfs_logprint to interpret the buffer of the super block, the
> icount will always be 6360863066640355328 (0x5846534200001000). This is
> because the offset of icount is incorrect, causing xfs_logprint to
> misinterpret the MAGIC number as icount.
> This patch fixes the offset value of the SB counters in xfs_logprint.
> 
> Before this patch:
> icount: 6360863066640355328  ifree: 5242880  fdblks: 0  frext: 0
> 
> After this patch:
> icount: 10240  ifree: 4906  fdblks: 37  frext: 0
> 
> Signed-off-by: chizhiling <chizhiling@kylinos.cn>
> ---
>  logprint/log_misc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index 8e86ac34..21da5b8b 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -288,13 +288,13 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
>  			/*
>  			 * memmove because *ptr may not be 8-byte aligned
>  			 */
> -			memmove(&a, *ptr, sizeof(__be64));
> -			memmove(&b, *ptr+8, sizeof(__be64));

How did this ever work??  This even looks wrong in "Release_1.0.0".

> +			memmove(&a, *ptr + offsetof(struct xfs_dsb, sb_icount), sizeof(__be64));
> +			memmove(&b, *ptr + offsetof(struct xfs_dsb, sb_ifree), sizeof(__be64));

Why not do:

			struct xfs_dsb *dsb = *ptr;

			memcpy(&a, &dsb->sb_icount, sizeof(a));

or better yet, skip the indirection and do

			printf(_("icount: %llu  ifree: %llu  "),
					(unsigned long long)be64_to_cpu(dsb->sb_icount),
					(unsigned long long)be64_to_cpu(dsb->sb_ifree));

Hm?

--D

>  			printf(_("icount: %llu  ifree: %llu  "),
>  			       (unsigned long long) be64_to_cpu(a),
>  			       (unsigned long long) be64_to_cpu(b));
> -			memmove(&a, *ptr+16, sizeof(__be64));
> -			memmove(&b, *ptr+24, sizeof(__be64));
> +			memmove(&a, *ptr + offsetof(struct xfs_dsb, sb_fdblocks), sizeof(__be64));
> +			memmove(&b, *ptr + offsetof(struct xfs_dsb, sb_frextents), sizeof(__be64));
>  			printf(_("fdblks: %llu  frext: %llu\n"),
>  			       (unsigned long long) be64_to_cpu(a),
>  			       (unsigned long long) be64_to_cpu(b));
> -- 
> 2.43.0
> 
