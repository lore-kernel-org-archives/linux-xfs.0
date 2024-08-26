Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9234F4C6C
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 02:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724638023; cv=none; b=kdd7D3oNw2vp8Qh8WU1hHv93vvMrowJsJ09+39NYsWH0SWbDMiks5PQ+jI9KXBuL6SYuSQRftvUkYivLd7fAlpVWBngyTabDjrAvh852MTXNGSsAw7QCh9cURBEPkX+ad4T0FjTEeHcfHGEXmkLM1ISCSkR6IxQRu9T/XUT3k0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724638023; c=relaxed/simple;
	bh=lbHN/hCuAuUIRkE5bkf+Ra/5ZzZmRnLt1f6+tWXyT/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g0lvVLIIyu9u35cyjOrQkZNJaXrvdeL250GZV0idcoBP6zywoYPLS4SNTqUY0RR3WAvVcxjjxgAquZtmaM+nfFxhz5dSUCaYycakRkzH3x519ec06ZTiw7TpdP3vWqjDSg6R1UIfCNrROqfLxi93QVj1o2y7zhVpdu5IxUtt7hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=gCAlBv/z; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="gCAlBv/z"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-201e52ca0caso25650665ad.3
        for <linux-xfs@vger.kernel.org>; Sun, 25 Aug 2024 19:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724638021; x=1725242821; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CtWz0Y3W4dpos06oLe2KJ9CHbNbbkxgoBIxSsmMtKmc=;
        b=gCAlBv/zBkB6g1b0o0q04+6TUjb0NHNasi0MlJrf8icisXI98OW6FtwJfEHeVGMlA9
         aQvNonYpMXhJmTG388yRBZZ7wcF6DSpojDvg+aYo4wxnotXYQnL/Y70+nPRSJ7qkZPCr
         /uIlDBxKixrVsFrUXMYot00RR96HyUM8QQw+LjFA4R7Is2WsoOWggPDNWbEdFKdrHhYx
         pLguajJkT8vqxL63O40Lm0C76r/7gqF4lktTH5WCGeE73TYFWjormJ3YVhB379vepAhn
         R/xXOGne4+kgZgijrQ6KV1AnPYXlA2Ndc+bhupwfy3WBLvtRho37M6xhSSk9XASN94YJ
         l05g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724638021; x=1725242821;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CtWz0Y3W4dpos06oLe2KJ9CHbNbbkxgoBIxSsmMtKmc=;
        b=OacMoqqsLbPo6QT8833uBMfm/AHSAhx+YqCDSDdyGV0Jm5ChLbt1yG8N6Y+0BGKomt
         VOqIV0xcKpBGQEV8lvpYWr5rNorzzMK8bC7xsATxW44/AoiPpURiS2EcjAbS+aX9n/my
         cPMpyKbC12rN4wPWq/YVcpO6fo1f3NpWJlZyawyY2VotarcCfIJsmTnefI5j6MzIyY3O
         NvGjN3Wh5lAY0EFwgWMW1a5vzUQ5rxtmEq4q3TWjSckNdJYhZpW56AtYiufpnwuEvqO5
         kPWJEa+MGKpRiNNultB8uBgKiIgjfYvvb2xtCYBVoz+nhS1dafO6su3mveRnMYfGIWbG
         MqBg==
X-Forwarded-Encrypted: i=1; AJvYcCWNLCDiO4GDiI+mTgXshkqP2FFacfkCJUDkpsJJD2+nPpzFQnAovol7QqAydjgg3SQJDmtaDgY5S7I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQ11lH+2wZlVAStExHP8YlfO4PTnNtTEf7Mm6XMhDwKpMeF3ru
	8SGa/BrS67+H/PObvGPbe/OhOOb9Xhndn1amEps4+J/Q6pis9oqQlAEp8vD1wn0=
X-Google-Smtp-Source: AGHT+IGBwpBCSo8WWtxCIs8JCBLAkj3jBVv9OqqJ0n5apeA0f75kbRpFY1FRknWKW1jVqeEQXtkM+g==
X-Received: by 2002:a17:902:e80d:b0:202:4666:f031 with SMTP id d9443c01a7336-2039e4ab21dmr73132435ad.29.1724638020711;
        Sun, 25 Aug 2024 19:07:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2038557e7cfsm59490845ad.83.2024.08.25.19.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 19:07:00 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1siP8E-00Cqdg-0R;
	Mon, 26 Aug 2024 12:06:58 +1000
Date: Mon, 26 Aug 2024 12:06:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/24] xfs: factor out a xfs_growfs_check_rtgeom helper
Message-ID: <ZsvjQiGQS6WD/rwB@dread.disaster.area>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087611.59588.7898768503459548119.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437087611.59588.7898768503459548119.stgit@frogsfrogsfrogs>

On Thu, Aug 22, 2024 at 05:20:07PM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Split the check that the rtsummary fits into the log into a separate
> helper, and use xfs_growfs_rt_alloc_fake_mount to calculate the new RT
> geometry.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> [djwong: avoid division for the 0-rtx growfs check]
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_rtalloc.c |   43 +++++++++++++++++++++++++++++--------------
>  1 file changed, 29 insertions(+), 14 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 61231b1dc4b79..78a3879ad6193 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1023,6 +1023,31 @@ xfs_growfs_rtg(
>  	return error;
>  }
>  
> +static int
> +xfs_growfs_check_rtgeom(
> +	const struct xfs_mount	*mp,
> +	xfs_rfsblock_t		rblocks,
> +	xfs_extlen_t		rextsize)
> +{
> +	struct xfs_mount	*nmp;
> +	int			error = 0;
> +
> +	nmp = xfs_growfs_rt_alloc_fake_mount(mp, rblocks, rextsize);
> +	if (!nmp)
> +		return -ENOMEM;
> +
> +	/*
> +	 * New summary size can't be more than half the size of the log.  This
> +	 * prevents us from getting a log overflow, since we'll log basically
> +	 * the whole summary file at once.
> +	 */
> +	if (nmp->m_rsumblocks > (mp->m_sb.sb_logblocks >> 1))
> +		error = -EINVAL;

FWIW, the new size needs to be smaller than that, because the "half
the log size" must to include all the log metadata needed to
encapsulate that object. The grwofs transaction also logs inodes and
the superblock, so that also takes away from the maximum size of
the summary file....

-Dave.

-- 
Dave Chinner
david@fromorbit.com
