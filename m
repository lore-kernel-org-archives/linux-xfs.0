Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DA9153598;
	Thu, 16 Jan 2025 17:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737048831; cv=none; b=lb6vNddFAoZlVhjAG8WFUXn0ETOiqG7K4aG/xwAfW3+kgYbWwAE1uVSfSIKA1s+h6pP6lE0bXwr2v2MIpbDlj4kHyLVl7a5opdcgfcFWEWipqJOj8Ge417Xm/mCd+VrJlbcehL6/K0nrR/c+xbdtkPdaL4DJFzo63Ny8uhbGKV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737048831; c=relaxed/simple;
	bh=bRe4lNW3GXCFlTbmW6clmGIZUxD5/9vRXUsmMzhWjn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VHBugHTHd6HzUVAcFH71FyS4gRpmgMz2G+Akug1wqu/CqSfhaQqJl6xuhC50mNK5hXO+EfndZkX2JYfxRPzBCH5eh9cbcJcQXZK/jv2g4JX5CXMHLLUB5DQomavEUiZeEuB9iLxNmZh8/pqZd2HW+uIeixCwwQvoixvlzZQmoo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eb35M923; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eb35M923"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9D3C4CED6;
	Thu, 16 Jan 2025 17:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737048831;
	bh=bRe4lNW3GXCFlTbmW6clmGIZUxD5/9vRXUsmMzhWjn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Eb35M923lm2jY0AKSoeyzIFqj3nkUOD2mimk+TlsXgmrDowb3LoMjLppxbuLWxH+2
	 Dh9o2NCuK5yZBbrH+M7gHEgdpIsjJoWTgn1Gcl/83oqa7y7G8sl/rQMLXIoxzhkH3R
	 fMs1JJMLhg42zwxs+0Exdt3P0/QbOLMBS4vg+MLeHRXeCXqYeED2gIutQ3s1j5h4b0
	 oKa6QH74XO/wNepHZu+ljWZlGv3fyyNLYunF2EAvUzhFgN1OD4gcu2Jw24I1iauo9j
	 Ao+6o6AFXWUBmRZOU0uKJX7uWiYGA3C+cH4fS1dnfJPwYJGkEGsAt3evZlZ+s+iSxW
	 kFZY1fdaknqKA==
Date: Thu, 16 Jan 2025 09:33:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chi Zhiling <chizhiling@163.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5] xfs_logprint: Fix super block buffer interpretation
 issue
Message-ID: <20250116173350.GA1611770@frogsfrogsfrogs>
References: <20250116090939.570792-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116090939.570792-1-chizhiling@163.com>

On Thu, Jan 16, 2025 at 05:09:39PM +0800, Chi Zhiling wrote:
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
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>

I think this looks ok now, though my unaligned-access fu has become weak
since the end of my personal sparc era...

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  logprint/log_misc.c      | 17 +++++------------
>  logprint/log_print_all.c | 22 ++++++++++------------
>  2 files changed, 15 insertions(+), 24 deletions(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index 8e86ac34..973bc90c 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -282,22 +282,15 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
>  		if (be32_to_cpu(head->oh_len) < 4*8) {
>  			printf(_("Out of space\n"));
>  		} else {
> -			__be64		 a, b;
> +			struct xfs_dsb	*dsb = (struct xfs_dsb *) *ptr;
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
> +			       (unsigned long long) get_unaligned_be64(&dsb->sb_icount),
> +			       (unsigned long long) get_unaligned_be64(&dsb->sb_ifree));
>  			printf(_("fdblks: %llu  frext: %llu\n"),
> -			       (unsigned long long) be64_to_cpu(a),
> -			       (unsigned long long) be64_to_cpu(b));
> +			       (unsigned long long) get_unaligned_be64(&dsb->sb_fdblocks),
> +			       (unsigned long long) get_unaligned_be64(&dsb->sb_frextents));
>  		}
>  		super_block = 0;
>  	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
> index a4a5e41f..cd5fccce 100644
> --- a/logprint/log_print_all.c
> +++ b/logprint/log_print_all.c
> @@ -91,22 +91,20 @@ xlog_recover_print_buffer(
>  		len = item->ri_buf[i].i_len;
>  		i++;
>  		if (blkno == 0) { /* super block */
> +			struct xfs_dsb  *dsb = (struct xfs_dsb *)p;
> +
>  			printf(_("	SUPER Block Buffer:\n"));
>  			if (!print_buffer)
>  				continue;
> -		       printf(_("              icount:%llu ifree:%llu  "),
> -			       (unsigned long long)
> -				       be64_to_cpu(*(__be64 *)(p)),
> -			       (unsigned long long)
> -				       be64_to_cpu(*(__be64 *)(p+8)));
> -		       printf(_("fdblks:%llu  frext:%llu\n"),
> -			       (unsigned long long)
> -				       be64_to_cpu(*(__be64 *)(p+16)),
> -			       (unsigned long long)
> -				       be64_to_cpu(*(__be64 *)(p+24)));
> +			printf(_("              icount:%llu ifree:%llu  "),
> +				(unsigned long long) get_unaligned_be64(&dsb->sb_icount),
> +				(unsigned long long) get_unaligned_be64(&dsb->sb_ifree));
> +			printf(_("fdblks:%llu  frext:%llu\n"),
> +				(unsigned long long) get_unaligned_be64(&dsb->sb_fdblocks),
> +				(unsigned long long) get_unaligned_be64(&dsb->sb_frextents));
>  			printf(_("		sunit:%u  swidth:%u\n"),
> -			       be32_to_cpu(*(__be32 *)(p+56)),
> -			       be32_to_cpu(*(__be32 *)(p+60)));
> +				get_unaligned_be32(&dsb->sb_unit),
> +				get_unaligned_be32(&dsb->sb_width));
>  		} else if (be32_to_cpu(*(__be32 *)p) == XFS_AGI_MAGIC) {
>  			int bucket, buckets;
>  			agi = (xfs_agi_t *)p;
> -- 
> 2.43.0
> 
> 
