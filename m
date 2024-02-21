Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9606B1E4BE
	for <linux-xfs@vger.kernel.org>; Wed, 21 Feb 2024 00:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708473658; cv=none; b=N5JbrafhoSkVbyI+nCAeNoMaEPqIQgSGZTsozHV4w15eT1HZE6RiC+355dJIvIcbZuWc2cs3a8S8RDjlVMLlqP/Gf2Fat2nvgH/3vQy8kNPaKbCXT9EQMa9lKFKCRoE03Xfpl2fwj3UWwwhreRdwh+N8JCeNMs8BNEnPJz6BgD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708473658; c=relaxed/simple;
	bh=83d28gdVEP5M26dYOqwMjsjSZCjh/VT9T2ZB8z7b7KA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSJXVNiXxS6/XkEG3E67wh17+fVsabtSFGf9hHufhv/muaqXgT+PSuTDZHXcWwT9XV8tFOS65WfVxdDx79fTmN4nFaJPym5tpHCpNJ/rCXDzMtBdWEzoflGoi7soNfA7HBbOJYXQaYdVlrXfGTpKtPlx5hY70s9LH2dJIxvcqlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=SyxvKCSJ; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="SyxvKCSJ"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e4670921a4so1753556b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 16:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708473656; x=1709078456; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yT9t8DZQjVDxKHwXofHuOVJe/xTzHPQJNftSPs/nZdA=;
        b=SyxvKCSJZIV1r4Z2Sq7Y72JIxv2erMUj3rC+wCA+ehzq+lt25u+ma2Vvrv9BIpYN3C
         93TZxO0o4z+GGX7zDoa6iaFF1iUNdFiVUhycSRh2MiCfQV1x9aeIRxiqukRfdPacNLPK
         KZ9GepCqCNXifXZ1P8qDa2qSoLlMnC9nVwWpnoBkGgvk91qaZgM1HHowCAAX189P1jS2
         I7hSub6/lMBCsInEWW5tCU2AgE80D+Adv7f4MGlU909F8xatncvuOxj9H8Z03ZiRsymB
         T05JZEU0YHvivM3Cx6sHrbeFp3egLEEbCkpzNHWe+I7z/Rv9fGKgeZ/VYoM22XNKylpt
         04Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708473656; x=1709078456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yT9t8DZQjVDxKHwXofHuOVJe/xTzHPQJNftSPs/nZdA=;
        b=tDI1sXYwlhPkFvJ1UVQuZh2bKoWoiz7Cp5q/ZYPIGd5wP9qO9Of6tG3yqhfQrvUB7e
         IUxGuKhh1g3z4oee/glr4+VlyFL+b2NsCWy6rnlNOdpnCDgAB+skvpHYs0/jpmeN7kNd
         +0hqfNchx8lebuLQTcTBK0AX08dRQJzB8o9awtrCtumfLaFMsB2lE6UmzD2WZEpPT/kG
         clwtphHbLEH/K/UCnuOFDHZw/CxDDEWLBEGvTN77eWE6vlSWoUhIsKDq7/h/1OUfhtap
         6iFfLw3P4qWTp1ty2WROz2yEHs9whbmNB1+kLn1lhh/WRQt12uyZ2F4KnP2av5wpyMN5
         rk7A==
X-Forwarded-Encrypted: i=1; AJvYcCVyFyNeOZ4QEiO4l+wsnIj2XjJ4ZDMjq7dS7rn6LDnRO4twsl0gPlK6FU6GuC4Q1lWaLsQl+t0RXLiYO7oCz/aauiF9sqX4kjPS
X-Gm-Message-State: AOJu0Ywdi5JbxfyLVL3RTvsXuVH15ZCCCOAkt9mVQknqx6ezlggBRFLj
	glFhBIDOWHjVeBr287Nc+dAEp+ucJM2kKw3fRESvN94d/ZPsigGgC8UhCfnqLKk=
X-Google-Smtp-Source: AGHT+IEDfBd9nytfbZAKwDHlg+u6OqEH7DJXJk4stFbG6XRnee8YtUbscjIijcxW+oZyQbqlbrYdeQ==
X-Received: by 2002:a05:6a00:1813:b0:6e4:88bf:461e with SMTP id y19-20020a056a00181300b006e488bf461emr2119841pfa.11.1708473655585;
        Tue, 20 Feb 2024 16:00:55 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id e8-20020a056a0000c800b006d98ae070c3sm641267pfj.135.2024.02.20.16.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 16:00:55 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rca2e-009HXL-2C;
	Wed, 21 Feb 2024 11:00:52 +1100
Date: Wed, 21 Feb 2024 11:00:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: split xfs_mod_freecounter
Message-ID: <ZdU9NAeprkO54iO/@dread.disaster.area>
References: <20240219063450.3032254-1-hch@lst.de>
 <20240219063450.3032254-4-hch@lst.de>
 <ZdPiaP+tApjr4K+M@dread.disaster.area>
 <20240220072821.GA10025@lst.de>
 <20240220160858.GA18908@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220160858.GA18908@lst.de>

On Tue, Feb 20, 2024 at 05:08:58PM +0100, Christoph Hellwig wrote:
> On Tue, Feb 20, 2024 at 08:28:21AM +0100, Christoph Hellwig wrote:
> > So we should be fine here, but the code could really use documentation,
> > a few more asserts and a slightly different structure that makes this
> > more obvious.  I'll throw in a patch for that.
> 
> This is what I ended up with:
> 
> ---
> From 22cba925f1f94b22cfa6143a814f1d14a3521621 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Tue, 20 Feb 2024 08:35:27 +0100
> Subject: xfs: block deltas in xfs_trans_unreserve_and_mod_sb must be positive
> 
> And to make that more clear, rearrange the code a bit and add asserts
> and a comment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_trans.c | 38 ++++++++++++++++++++++++--------------
>  1 file changed, 24 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 12d45e93f07d50..befb508638ca1f 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -594,28 +594,38 @@ xfs_trans_unreserve_and_mod_sb(
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
> -	int64_t			blkdelta = 0;
> -	int64_t			rtxdelta = 0;
> +	int64_t			blkdelta = tp->t_blk_res;
> +	int64_t			rtxdelta = tp->t_rtx_res;
>  	int64_t			idelta = 0;
>  	int64_t			ifreedelta = 0;
>  	int			error;
>  
> -	/* calculate deltas */
> -	if (tp->t_blk_res > 0)
> -		blkdelta = tp->t_blk_res;
> -	if ((tp->t_fdblocks_delta != 0) &&
> -	    (xfs_has_lazysbcount(mp) ||
> -	     (tp->t_flags & XFS_TRANS_SB_DIRTY)))
> +	/*
> +	 * Calculate the deltas.
> +	 *
> +	 * t_fdblocks_delta and t_frextents_delta can be positive or negative:
> +	 *
> +	 *  - positive values indicate blocks freed in the transaction.
> +	 *  - negative values indicate blocks allocated in the transaction
> +	 *
> +	 * Negative values can only happen if the transaction has a block
> +	 * reservation that covers the allocated block.  The end result is
> +	 * that the calculated delta values must always be positive and we
> +	 * can only put back previous allocated or reserved blocks here.
> +	 */
> +	ASSERT(tp->t_blk_res || tp->t_fdblocks_delta >= 0);
> +	if (xfs_has_lazysbcount(mp) || (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
>  	        blkdelta += tp->t_fdblocks_delta;
> +		ASSERT(blkdelta >= 0);
> +	}
>  
> -	if (tp->t_rtx_res > 0)
> -		rtxdelta = tp->t_rtx_res;
> -	if ((tp->t_frextents_delta != 0) &&
> -	    (tp->t_flags & XFS_TRANS_SB_DIRTY))
> +	ASSERT(tp->t_rtx_res || tp->t_frextents_delta >= 0);
> +	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
>  		rtxdelta += tp->t_frextents_delta;
> +		ASSERT(rtxdelta >= 0);
> +	}
>  
> -	if (xfs_has_lazysbcount(mp) ||
> -	     (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
> +	if (xfs_has_lazysbcount(mp) || (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
>  		idelta = tp->t_icount_delta;
>  		ifreedelta = tp->t_ifree_delta;
>  	}

That seems reasonable - at least it documents the expectations.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
