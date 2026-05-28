Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0544B30C63B
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 04:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779944258; cv=none; b=YUGV2MJoSWHryIWbPAB4X+8Ok4ZKvmcCYmE7yHV0wKmi/4vdotMbDHouud2jFk0DUip9VD9dkNa2Mc2oG5l/OPE1pYvRchBl2e2ZlXh3S1foQUFqFks+WoSlpaQChwKWdWph7TZ88xju60FSCgTQN399SjHj/DcSzqqpj9mNEhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779944258; c=relaxed/simple;
	bh=FYhivVqh1po6E98iHUjtDxh3T5G9eiBdC0pgheJfKhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nFVZzNgzldQ5kB0rr9xgRuk6PKSomE9S3SaBj0aDKFceoCu4PQMQI4gcalXg9ldB+XWkYOgCCofjpf7yf+ha3/xKsX2k+2MvmutYBnxFyMi9Yd4+SpbjStIQEmsetdU9blNgp1aj6Yw+TsVl9I1gO8I6GjFQq6nm3hHB+KCQ7gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TBU2PMp9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TBU2PMp9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 917171F000E9;
	Thu, 28 May 2026 04:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779944256;
	bh=i7UrKKLspMFdZlVFmSFbynAr/+HJ5KHNzygcLmQuqP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TBU2PMp9W5ca5OqrhbAep6Og7NJxu0FciYFpD1UbHIBHhllEVtWXHHAVuGC58Cfn5
	 WiW+8VsKjnyOl7bNCiLRV6aUjfU7+FSApkFs6CKe/ABfla+nlprLdX7E3Kf4FgzMLy
	 pplUfULxTLYFPNCAyHsoMSq4asaejZV8yBsgDYwOz8Ca4KDP1dbXAtNAbhck4SSaMa
	 DzReezllbsjuFGIaFugrA16CP9YK1u9xqjft68KSmb7pmOWEIfxxqPTgk8zlr5VdRN
	 ISluhHqIpxyAP6UfGkg9uTuTK6dHaa1ueuSe4oGvCDfR66H0cN3/1gChUXHFXGmu9q
	 beTxfN7wDfTnQ==
Date: Wed, 27 May 2026 21:57:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: sandeen@sandeen.net, aalbersh@kernel.org, dgc@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/5] xfsprogs: mkfs.xfs add auto|autodetect value
 for -d/l/r concurrency
Message-ID: <20260528045736.GE6078@frogsfrogsfrogs>
References: <20260525075752.4159504-1-lukas@herbolt.com>
 <20260525075752.4159504-4-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525075752.4159504-4-lukas@herbolt.com>

On Mon, May 25, 2026 at 09:57:50AM +0200, Lukas Herbolt wrote:
> Add autodetect|auto value for concurrency option to restore the current
> default behavior concurrency detection on SSDs.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  mkfs/xfs_mkfs.c | 11 ++++++++++-

Needs a manual page change to note that you can say -d concurrency=auto.

Otherwise the logic and comment changes look good to me.

--D

>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index bff7d078901c..cb9c528021d6 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1838,9 +1838,12 @@ set_data_concurrency(
>  	/*
>  	 * "nr_cpus" or "1" means set the concurrency level to the CPU count.
>  	 * If this cannot be determined, fall back to the default AG geometry.
> +	 * "auto" or "autodetect" means auto-detect based on storage type.
>  	 */
>  	if (!value || !strcmp(value, "nr_cpus"))
>  		optnum = 1;
> +	else if (!strcmp(value, "auto") || !strcmp(value, "autodetect"))
> +		optnum = -1;
>  	else
>  		optnum = getnum(value, opts, subopt);
>  
> @@ -1986,9 +1989,12 @@ set_log_concurrency(
>  	/*
>  	 * "nr_cpus" or 1 means set the concurrency level to the CPU count.  If
>  	 * this cannot be determined, fall back to the default computation.
> +	 * "auto" or "autodetect" means auto-detect based on storage type.
>  	 */
>  	if (!value || !strcmp(value, "nr_cpus"))
>  		optnum = 1;
> +	else if (!strcmp(value, "auto") || !strcmp(value, "autodetect"))
> +		optnum = -1;
>  	else
>  		optnum = getnum(value, opts, subopt);
>  
> @@ -2206,10 +2212,13 @@ set_rtvol_concurrency(
>  	/*
>  	 * "nr_cpus" or "1" means set the concurrency level to the CPU count.
>  	 * If this cannot be determined, fall back to the default rtgroup
> -	 * geometry.
> +	 * geometry. * "auto" or "autodetect" means auto-detect based on
> +	 * storage type.
>  	 */
>  	if (!value || !strcmp(value, "nr_cpus"))
>  		optnum = 1;
> +	else if (!strcmp(value, "auto") || !strcmp(value, "autodetect"))
> +		optnum = -1;
>  	else
>  		optnum = getnum(value, opts, subopt);
>  
> -- 
> 2.54.0
> 
> 
