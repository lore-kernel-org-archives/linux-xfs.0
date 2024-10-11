Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9031A198840;
	Fri, 11 Oct 2024 16:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728664601; cv=none; b=nOCxeiuDI2pnfcrIrgk2w/hQrfGfL59ySW2lk0e+ziYjb1GsLpi4mODYGQrxPUtJaty8lJoDLqt8EQaqCzNTuuhdwNc9E1Y3ku3QICMd5BEtR5iSuA/zMsV98XbvuFPG24K292yPBH+Q1u4+7khNhHvZxrShbDuOcX5ZYElnSyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728664601; c=relaxed/simple;
	bh=CJiLhaO9TqdTvQ+rRkN9hcR6sC5eBtu/dSqzV8pCers=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gnz92h/4yKUzalOvEKWb34YDwLF9fZPRjVz4IKVsgEgWkLLQVE2OtPe8NZ2PHGLW42TCentsKpVAzxRkOr4HJZOj1LUxZnbjZoPXwc+kl5G7rp0EJp+uL5lbMu+IP+bsXKyf98G6mgGLdnKTKmGLB84zPKAt9O76AAge6fKXdXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KUoFSiIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KUoFSiIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AE9C4CEC7;
	Fri, 11 Oct 2024 16:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728664601;
	bh=CJiLhaO9TqdTvQ+rRkN9hcR6sC5eBtu/dSqzV8pCers=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KUoFSiIZKujccBH0dgVqHaLI/nFapkh139XRcGAq8X20prgAKO+HLMmuBdv2PRRFT
	 NHfn1/5Yum5bCH2ko4Q6PgwLwwFtHp4YBmUfLV289bYlxmD9wWBs9etIZLiaIu547J
	 G5gYTKrnKBdnu4tbzNEsWE2gwzcCvZA3jy33Zn05yD0I7ZYbXLs/p3S07mZtDJQ/XP
	 rrZHXptzE0PcHB6noCmk00MWZ6ccH1j6jMpf0xW3Xv+mkmYR/IYn+4uBOeLvlhxWCj
	 e/Rocp0MjCpIpiVxGvJu2MsZzX0e9XI6V7gbadQxsCrzvJZDVS8JjMpFpB9fCbUKcp
	 dQD8Ipel6Jusw==
Date: Fri, 11 Oct 2024 09:36:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chi Zhiling <chizhiling@163.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH v2] xfs_logprint: Fix super block buffer interpretation
 issue
Message-ID: <20241011163640.GV21853@frogsfrogsfrogs>
References: <20241011075253.2369053-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011075253.2369053-1-chizhiling@163.com>

On Fri, Oct 11, 2024 at 03:52:53PM +0800, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
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
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
> ---
>  logprint/log_misc.c | 17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index 8e86ac34..0da92744 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -282,22 +282,15 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
>  		if (be32_to_cpu(head->oh_len) < 4*8) {
>  			printf(_("Out of space\n"));
>  		} else {
> -			__be64		 a, b;
> +			struct xfs_dsb *dsb = (struct xfs_dsb *) *ptr;

Nit: tab between type and variable    ^ name

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  
>  			printf("\n");
> -			/*
> -			 * memmove because *ptr may not be 8-byte aligned
> -			 */
> -			memmove(&a, *ptr, sizeof(__be64));
> -			memmove(&b, *ptr+8, sizeof(__be64));
>  			printf(_("icount: %llu  ifree: %llu  "),
> -			       (unsigned long long) be64_to_cpu(a),
> -			       (unsigned long long) be64_to_cpu(b));
> -			memmove(&a, *ptr+16, sizeof(__be64));
> -			memmove(&b, *ptr+24, sizeof(__be64));
> +			       (unsigned long long) be64_to_cpu(dsb->sb_icount),
> +			       (unsigned long long) be64_to_cpu(dsb->sb_ifree));
>  			printf(_("fdblks: %llu  frext: %llu\n"),
> -			       (unsigned long long) be64_to_cpu(a),
> -			       (unsigned long long) be64_to_cpu(b));
> +			       (unsigned long long) be64_to_cpu(dsb->sb_fdblocks),
> +			       (unsigned long long) be64_to_cpu(dsb->sb_frextents));
>  		}
>  		super_block = 0;
>  	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
> -- 
> 2.43.0
> 
> 
