Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D54036BCEC
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 14:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770041764; cv=none; b=rGyBdwsPcmyvWf5axg8Iidl3ovyLf9pyOuRHoF4RUKNOUQ2kpp/85ACudh3mZUquaM4j0U0/e4YwMOo+8vbzBViZ2AlROckcFHJhDa0Qe+G6DGDgl9rzdsWmb/toLmSmnY7Tu3+1nDYa0PzJhdHTzvAxBefSfULTTLCxPShesmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770041764; c=relaxed/simple;
	bh=vLq/mPUg5y1mIYNMNuGANtFNFNSSjgHUf1rn6crifbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d8kUDBjXW80rUnN3mQha8419r6kxyL70ExkmUSqAE2j14O9jmjUxlYn+XKTMJjigOscuoC/uM8LFhyNRJhfxmI0990qn0ttTfCUphBnb/cw36i2oxjBoUjmCf1Z7azVbrwY3sIN2R0mr0ciOmf0DhK/Ozyc5KlPHSrwomA75Fzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CyTkvyZG; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CyTkvyZG"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a9042df9a2so7304185ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 02 Feb 2026 06:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770041762; x=1770646562; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KBeDXS062wH3yuXGOmNvteYSzzKzz6ieXG7XctVF8Y8=;
        b=CyTkvyZGFAaFHn4BPMAyiFLWOUBilxRyZYx88qZ6DMKmajXJDT7ohuwDeWxi9Ddf73
         3aPjztN8eJR6q1pkQPODSjfOYJSpDTZ+3kCrHLc92CUzJ9dFLH6/mmGUD6LKwhEb7zVk
         pXtVgE6sg4tgQeBmtCDeMjso0RLN64D3EM+c708G4pLpzwTu0rQm6DMm4t22pvhqdQfU
         HlUSkX16U6bD4n4aZ2ftJJ26vKxD2EqSm2Fz/CpbEDO1WDeSe5yVaEnuurrJWRbTOiOP
         NsfktZOaB1qtIQFG4Q96ZvjKdLjSYsr2EZNI93CKkHPALihsbAY4N9CcqCiatXo1mBCD
         iVuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770041762; x=1770646562;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KBeDXS062wH3yuXGOmNvteYSzzKzz6ieXG7XctVF8Y8=;
        b=u6FQH0e3bToj/vggZKlHShyqb9P5Cn8XRUJzipz8ap3btN4+P8c4a9mipIY37LLP83
         dZpNiamT9qi4VIg1o7c5CzCVn3uDlZEzRgjIwgOBeOr22fttQXUftDNn1EuL0qTN8CcF
         x3HdiSKOLFsfse21iCAT6nHwBzymca5dtD3mcQ7Fs73WETHPxHsBQ9Ho5F+LHwVhgiDM
         R7NM/F7h+ffIqxw4vz881yvP+9MXoWobWs1LDJGx9XYGo6IQPSc5lZnfu+Txh6jPEOC+
         lONo0PSewSfhLY2UWff4E4yLiK8dC13WnMZyatTghQbeyWeSZmhc+0+kVWquZuXOoqXl
         RXMA==
X-Gm-Message-State: AOJu0Yymp8HL8oJmbkNcwWFUh6Z4IS8Pl9ahSjW1ViYs6iNobJuG0Fyx
	M1UNlA3W9qgv6/7aQmJ1XAjkHb9a1e+r4LKaT9nw8qIAwfkF1OX3t6yeV8ijAw==
X-Gm-Gg: AZuq6aJ5KWrLAiMqS0YF8Z7c4jBMYcYX8urwugtqI7RRWFoxy27NBLj17LDysJhsbmW
	F93W6q1ieeXW7ODlFMD8bWwkABBmmmkaXNa87CE//GJjNbQ7vKZaAfz/JA5HaC/duPU2gAhzFPJ
	ETOaOI1jZF4wkgGlsFxacRhytKGK4K0ScUFWn3BvueQGKnGnns88epgUTdrjt5G+fveHQLApO4H
	8A9vAO44ZM2d8hpPI/PrVCQERizz2F6WWxq05/hmq8T70IUWaxU6afLPRFDTe+YTvw+kAjoBtKs
	qidmOe3qOmfyOhe2EdJxZzG7JXlr2mgHbUwfBD/pwXESXwdqLrBHJis01eJCcQ8afLtVflBp4iq
	HQPP11G9qiRslFKsFMm1BCTSI1X6CLjDMSrwxEyPjMkZEwVS29/1SU7LdZHijlobI1fNvsMgrfS
	5GdcLejYhK5dc1pVCP31bugw==
X-Received: by 2002:a17:903:2ec8:b0:2a7:9ded:9b4a with SMTP id d9443c01a7336-2a8d990b74emr127768425ad.36.1770041761694;
        Mon, 02 Feb 2026 06:16:01 -0800 (PST)
Received: from [192.168.0.120] ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b5d99eesm146149725ad.78.2026.02.02.06.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Feb 2026 06:16:01 -0800 (PST)
Message-ID: <1659bd90-2fbc-42df-abbe-3da52402feb6@gmail.com>
Date: Mon, 2 Feb 2026 19:45:56 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V3 2/3] xfs: Refactoring the nagcount and delta calculation
Content-Language: en-US
To: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>
Cc: ritesh.list@gmail.com, ojaswin@linux.ibm.com, djwong@kernel.org,
 bfoster@redhat.com, david@fromorbit.com, hsiangkao@linux.alibaba.com
References: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
 <b84a4243ee87e0f0519e8565b1da5b8579ed0f64.1760640936.git.nirjhar.roy.lists@gmail.com>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <b84a4243ee87e0f0519e8565b1da5b8579ed0f64.1760640936.git.nirjhar.roy.lists@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/20/25 21:13, Nirjhar Roy (IBM) wrote:
> Introduce xfs_growfs_compute_delta() to calculate the nagcount
> and delta blocks and refactor the code from xfs_growfs_data_private().
> No functional changes.
>
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Hi Carlos, Darrick,

Can this be picked up? This is quite independent of the rest of the 
patches in this series.

--NR

> ---
>   fs/xfs/libxfs/xfs_ag.c | 28 ++++++++++++++++++++++++++++
>   fs/xfs/libxfs/xfs_ag.h |  3 +++
>   fs/xfs/xfs_fsops.c     | 17 ++---------------
>   3 files changed, 33 insertions(+), 15 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index e6ba914f6d06..f2b35d59d51e 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -872,6 +872,34 @@ xfs_ag_shrink_space(
>   	return err2;
>   }
>   
> +void
> +xfs_growfs_compute_deltas(
> +	struct xfs_mount	*mp,
> +	xfs_rfsblock_t		nb,
> +	int64_t			*deltap,
> +	xfs_agnumber_t		*nagcountp)
> +{
> +	xfs_rfsblock_t	nb_div, nb_mod;
> +	int64_t		delta;
> +	xfs_agnumber_t	nagcount;
> +
> +	nb_div = nb;
> +	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
> +	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
> +		nb_div++;
> +	else if (nb_mod)
> +		nb = nb_div * mp->m_sb.sb_agblocks;
> +
> +	if (nb_div > XFS_MAX_AGNUMBER + 1) {
> +		nb_div = XFS_MAX_AGNUMBER + 1;
> +		nb = nb_div * mp->m_sb.sb_agblocks;
> +	}
> +	nagcount = nb_div;
> +	delta = nb - mp->m_sb.sb_dblocks;
> +	*deltap = delta;
> +	*nagcountp = nagcount;
> +}
> +
>   /*
>    * Extent the AG indicated by the @id by the length passed in
>    */
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 1f24cfa27321..f7b56d486468 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -331,6 +331,9 @@ struct aghdr_init_data {
>   int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
>   int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
>   			xfs_extlen_t delta);
> +void
> +xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t nb,
> +	int64_t *deltap, xfs_agnumber_t *nagcountp);
>   int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
>   			xfs_extlen_t len);
>   int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 0ada73569394..8353e2f186f6 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -92,18 +92,17 @@ xfs_growfs_data_private(
>   	struct xfs_growfs_data	*in)		/* growfs data input struct */
>   {
>   	xfs_agnumber_t		oagcount = mp->m_sb.sb_agcount;
> +	xfs_rfsblock_t		nb = in->newblocks;
>   	struct xfs_buf		*bp;
>   	int			error;
>   	xfs_agnumber_t		nagcount;
>   	xfs_agnumber_t		nagimax = 0;
> -	xfs_rfsblock_t		nb, nb_div, nb_mod;
>   	int64_t			delta;
>   	bool			lastag_extended = false;
>   	struct xfs_trans	*tp;
>   	struct aghdr_init_data	id = {};
>   	struct xfs_perag	*last_pag;
>   
> -	nb = in->newblocks;
>   	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
>   	if (error)
>   		return error;
> @@ -122,20 +121,8 @@ xfs_growfs_data_private(
>   			mp->m_sb.sb_rextsize);
>   	if (error)
>   		return error;
> +	xfs_growfs_compute_deltas(mp, nb, &delta, &nagcount);
>   
> -	nb_div = nb;
> -	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
> -	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
> -		nb_div++;
> -	else if (nb_mod)
> -		nb = nb_div * mp->m_sb.sb_agblocks;
> -
> -	if (nb_div > XFS_MAX_AGNUMBER + 1) {
> -		nb_div = XFS_MAX_AGNUMBER + 1;
> -		nb = nb_div * mp->m_sb.sb_agblocks;
> -	}
> -	nagcount = nb_div;
> -	delta = nb - mp->m_sb.sb_dblocks;
>   	/*
>   	 * Reject filesystems with a single AG because they are not
>   	 * supported, and reject a shrink operation that would cause a

-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

