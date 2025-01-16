Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512211804A;
	Thu, 16 Jan 2025 00:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736987631; cv=none; b=LDD0uSdF4DKeICCmrNIstn+T3gQJQDY3CHuEK2nhJyXKBuNCyWiYGEiiFn6YesGbAjY6szOOLbgFxg0EvKe4jhKwfof+j+wIAbMKJMWvN3pvI8Wnh1vb/1emuqRadz0WYQ7ZgjlfYOtE+t6OWgBIIt1JnmwJILq3yBAdXYAhR6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736987631; c=relaxed/simple;
	bh=w32V/FABHl8kv2jggE+z0JUnQqEXP2lI34GZDVoAhNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eWhApQZuUUwkQG8XXhe+GA/8szWbar/CQJRJAodzzgr/vlr4zzBGe2kmvV8dwoclQi53UqqIbdhGjfSsudCGx6nCcug9wKlqmUsTjWUSH0eUbr5tnRwaeubz0bhYRM3WC1gjiYIGfJ1cbe2NcmgqayltzvU3Z/XzdGnFZ0M1ScM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pm4vo4ZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pm4vo4ZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B7CC4CED1;
	Thu, 16 Jan 2025 00:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736987630;
	bh=w32V/FABHl8kv2jggE+z0JUnQqEXP2lI34GZDVoAhNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pm4vo4ZH3ROEN2PSvcotUTxdC9ngHVMWeQekzsAfx2XLFQt833AFPtkLnNpHgIdfT
	 EVdDdHeMloJHHKZPiZDLLMft4JaguXO1Mnr1hS1Yx4HfKehSbBb1/+f24Zl5MJt7+3
	 si4o5lBq1F3TXIdIUBcdjWlfC3h4eva3ndCK1Sj/CJDqsQh1xByYHXFivgkKW+9hnv
	 mH0aegLyMTK1frZ1j8ealN38BVgtte9K7EqZgQzjhu0eV5dEk+2t9GG05Nt1AJZ4j/
	 yuNtyc8+0hmgdrLZsVHiKvWVj1b/Jg+0MJbQaoW+RUET1ITWda1CFoT3adh8e4qPg1
	 7zjdMGFHx7/fw==
Date: Wed, 15 Jan 2025 16:33:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chi Zhiling <chizhiling@163.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4] xfs_logprint: Fix super block buffer interpretation
 issue
Message-ID: <20250116003350.GD3566461@frogsfrogsfrogs>
References: <20241013042952.2367585-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241013042952.2367585-1-chizhiling@163.com>

On Sun, Oct 13, 2024 at 12:29:52PM +0800, Chi Zhiling wrote:
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
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  logprint/log_misc.c | 17 +++++------------

Hmm, I don't think this ever got merged...

but shouldn't log_print_all.c also get fixed?  I think it has the same
pointer arithmetic problem that could be replaced by get_unaligned_be64
calls just like you did below.

--D

>  1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index 8e86ac34..803e4d2f 100644
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
> +			       (unsigned long long) get_unaligned_be64(dsb->sb_icount),
> +			       (unsigned long long) get_unaligned_be64(dsb->sb_ifree));
>  			printf(_("fdblks: %llu  frext: %llu\n"),
> -			       (unsigned long long) be64_to_cpu(a),
> -			       (unsigned long long) be64_to_cpu(b));
> +			       (unsigned long long) get_unaligned_be64(dsb->sb_fdblocks),
> +			       (unsigned long long) get_unaligned_be64(dsb->sb_frextents));
>  		}
>  		super_block = 0;
>  	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
> -- 
> 
> 2.43.0
> 
> 
