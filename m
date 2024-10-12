Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5060914A084
	for <linux-xfs@vger.kernel.org>; Sat, 12 Oct 2024 22:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728771105; cv=none; b=iz+7vDYIFc58kp5Jb1lwieqhsaHa7w8PW1pDhC7lulU6QkivrUVW7DkPMo/GIMFooZZ1JgsEiqz1IYBkc1k5akUv4mcSkReSUNcM6e6Q/rWyj1wrFqIrMXbwyMrXUrOu5J1/0w/jY6USC+rlaqbcr+DVxe1nyCNl0A5ZqCSvBGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728771105; c=relaxed/simple;
	bh=AlMhcJX50hSxnrI0a6Uvif2TQNbil0fVJDanclSGDAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ahshHWrgkTiWj7ge/uR0ypLZZysi2h9F0jC+gncsGZmSD5bk11nT9+RCjgRQQoxiuq012VxCYcwGXpo/BSTNa+wrPAWjCx6rB1TaWmPFN8dLnSLOEjB59qJP+wEAvp4B06k/7VRV+0kSdrzejGZiIjUitQ1rsg2HsCAELjH8Rko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=fVGO5buP; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="fVGO5buP"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20cdda5cfb6so597085ad.3
        for <linux-xfs@vger.kernel.org>; Sat, 12 Oct 2024 15:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1728771101; x=1729375901; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mCgo47vs9YInm+iXBcEPJ6CJpiZ2JCPQ0Y7mdYDfI24=;
        b=fVGO5buPOs+ro1fTg14PhIw5Ppc76/n/eHP2z2k9r9mg6EW9PgKdDt/VWtRETUmeRR
         VkwCwDqm/a7lIl4Qa+BcfCgRo5KmMmoeAN0WXPOPdLLp8oWEJCOvX74LS8KQo8cZWxV7
         cBusv5/jtPZsU/gzuE3B9urmCr+PZcaJ1HFyLgSHOu8di68KWiGh2NkH+XE+ZiMrXl6V
         k/E7TFMg+NJkEWDg+oTFWuHI26itVu8Dt+wT1XBtTc3dCFhK6QFUPeiAI3eCk8+nKoWb
         B/Z4POBdzefob9klWRKWGyaj/gzEXCtGJt8FIupd7Wdbs/hgRNFMuO/MG+vKLhoUK/Q6
         M4tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728771101; x=1729375901;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mCgo47vs9YInm+iXBcEPJ6CJpiZ2JCPQ0Y7mdYDfI24=;
        b=PQAgujxiGmpEb6YHg0hKA+DBKUJEK1sL3GECLUXS19PanJ4ToMHgtIo/N8053WZhh8
         OJGw7pMZ5BzG8ejCDo4aUZCGRgYj2rCSW5YFXYm6y0DDqk5ZaQ5ZeCS7kilcHQUK3gQm
         11rRuQeR4NULlckDqT4H5vux9I2u97TZOK4TR8MLnjLBXp+SJZL0sFJ9RTSvsIW/oez/
         ktrLPgTXA+wnb7n66GhUHUnvCM9dngghRdzr9+VwRIQJ+o8rJc2rX0MPpJ1qEqZVFXm8
         BDIvr2asYCjRwsu5BzAoj0lK0HXc9gnQdzlQAeZM69sQJrx+n8SfanzazfjxduxyEkVO
         pYlg==
X-Forwarded-Encrypted: i=1; AJvYcCVljbxj+eG590uyWsP/ZLNM1FmfKELW5NuISUx69btdxkYtlNd0V84IldHF47bh89tKE04q+L6JzsA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyK3iubCY6a0yRwLQLqyFYC4T2iRLm5wusFd5caKjtZ6LWnSBLr
	xduwF1bmi7e712hcw2qsy7/+qVW/mnJnVUAm1cp0rTU7+BZnSJIz+kCuFdJuurQ=
X-Google-Smtp-Source: AGHT+IEWR+hMG7xdDdreKD9xvy+TjNQgqDOoR4nvIvTn8kM/an+dXKfpRIwOfypOlmK2Qj6znLAfjQ==
X-Received: by 2002:a17:903:2284:b0:20c:b483:cce2 with SMTP id d9443c01a7336-20cb483d145mr69361725ad.60.1728771101562;
        Sat, 12 Oct 2024 15:11:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c0e74c0sm41594575ad.121.2024.10.12.15.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 15:11:41 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1szkKo-00HXiU-1j;
	Sun, 13 Oct 2024 09:11:38 +1100
Date: Sun, 13 Oct 2024 09:11:38 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chi Zhiling <chizhiling@163.com>
Cc: cem@kernel.org, djwong@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH v3] xfs_logprint: Fix super block buffer interpretation
 issue
Message-ID: <Zwr0GiZeiiTBs5/7@dread.disaster.area>
References: <20241012015235.1706690-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241012015235.1706690-1-chizhiling@163.com>

On Sat, Oct 12, 2024 at 09:52:35AM +0800, Chi Zhiling wrote:
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
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  logprint/log_misc.c | 17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index 8e86ac34..e366f8f5 100644
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
> +			       (unsigned long long) be64_to_cpu(dsb->sb_icount),
> +			       (unsigned long long) be64_to_cpu(dsb->sb_ifree));
>  			printf(_("fdblks: %llu  frext: %llu\n"),
> -			       (unsigned long long) be64_to_cpu(a),
> -			       (unsigned long long) be64_to_cpu(b));
> +			       (unsigned long long) be64_to_cpu(dsb->sb_fdblocks),
> +			       (unsigned long long) be64_to_cpu(dsb->sb_frextents));

Still broken. As I just mentioned, it needs to use
get_unaligned_be64()....


-Dave.
-- 
Dave Chinner
david@fromorbit.com
