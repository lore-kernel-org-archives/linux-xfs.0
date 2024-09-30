Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C7D5339F
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 23:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727738380; cv=none; b=tKb3hXcv5rtsZ0cGrepSftzS/Dzc2MORZDgi11TsI6cfpazo+rUbqVixX1neUWPDJpQCyDIbI4DenGoZ2tizIGRaCxq4nTvnD7ZRqQYbep7FtUsXaq3w22NiGQrry05HSRrpG2i1g96zJ/3U2Ii2jTcbDOcKJaB3b01Fs9yslUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727738380; c=relaxed/simple;
	bh=dXCXD5wrJmdqTWj0YHYVjrXP6eqVQATpBMpQrbW8Ry0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kv2sXfRFV/blHGX5MUgtt28ltwC2Rl7SUsggL1nzNKu2jnl+45eb1tQzhczLX+TQjoODat2m481ljJ37z+sPAC0kachOapJJHQUrsIQGwcPSAK16GxwyrfB1dq3gZbcbJ0ldNkBbuhsWbEDXliZAu4rOhBCtANBpB7GIq0Cx5GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=fkclomyF; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="fkclomyF"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2e109539aedso1626459a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 16:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727738378; x=1728343178; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YU82hqcu3AmyXYClRxGGlvm1J9lCdXT7ZaoZ+qqkZug=;
        b=fkclomyFLBET0VMNkSKfMCE90ntPhrCUo21LSTFc6XwiGt6lFM30kxeoaDHlM92Er/
         f/IDUCR4GBly6HNKbjgyHke4F+eJgUJ2lx2H7/56KIYAcYHXgpV+nHfguzwiEFhOTFH0
         Ded8WqD2vg8I6PiGF/pAJgu5eXkgsTvbRSUTq073KF97SAhAWEEKhOJEfl/cCGGwHhbB
         tie9D9I/Ubxmt679HyvHLmGJRT6Wr1WMOgZMxz1MbxUyJO/JYxUwaqfYg+TpI+m7r1SL
         lv1j4VXXvnu942Rr1sq7ty+oeBLhhTYlgrgAP7TaKe4/hpBGgZAGoS2vlZm7f6IX63wq
         t3lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727738378; x=1728343178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YU82hqcu3AmyXYClRxGGlvm1J9lCdXT7ZaoZ+qqkZug=;
        b=YTxVZmuqJ8MPoU14hHd1GSK1N5SWGo08ZPtYbPnPWQCEZMypfcIdiU1/yZUYN5KH7q
         qh5cEotS93tzTlZXsNvWYANr8bb1wwctbRy3dsBmjK97acu6978WTbqT3CqFJXF1cHja
         eVkFdanU3aEEnqhQM+iCc9Na1KxjZ+3asMfs6lLe/2iezPUqpOKlt/k4evOQeAfC9+qK
         meicaSIZxmuUAgf26cbdUXHbeB7ChnKMzbU1DHCE3peo7i5ZVCTTgtz7lxSqFOc1+JHE
         PGjtuDSMyYNX8NPaxM31zNy5EDrn5imiQHiNibL6KVtmgaBozhNwQ6oo+M2hS+73iLTd
         I35g==
X-Forwarded-Encrypted: i=1; AJvYcCWMILNFujYdT8cjUk7xiEV2YZQgTGilrUvuET0/LX58NDmsh/soZvHa8N6foA7nRJTXlnUZbR2IsRM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTrINHlGEYYDW4g8XwziVD6/flMtCihRvZbBU8LVFWgoZtP7NP
	JTJ3APYeoVIyswQOarY7mi4cPrydb7SbXXZJjfsu0teqUQpe+j7e5nlihkuLhGE=
X-Google-Smtp-Source: AGHT+IEGrY3dHhFNHeOESvTCbVszKpY2A5f5D7dN9U01R5cFHlJYIKcKzPUQN3zGv59u+QdQq4RiGA==
X-Received: by 2002:a17:90a:df01:b0:2d3:c8e5:e548 with SMTP id 98e67ed59e1d1-2e0b89dff8cmr16755521a91.13.1727738378524;
        Mon, 30 Sep 2024 16:19:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e16812547esm1239a91.1.2024.09.30.16.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 16:19:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1svPfy-00CFto-1b;
	Tue, 01 Oct 2024 09:19:34 +1000
Date: Tue, 1 Oct 2024 09:19:34 +1000
From: Dave Chinner <david@fromorbit.com>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [next] xfs: remove the redundant xfs_alloc_log_agf
Message-ID: <ZvsyBj3jBjuTjXey@dread.disaster.area>
References: <20240930104217.2184941-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930104217.2184941-1-leo.lilong@huawei.com>

[ Your email is being being classified as spam by gmail because it
does not have a valid DKIM authentication signature.  Hence it
doesn't get delivered to anyone who's mail is backed by gmail.... ]

On Mon, Sep 30, 2024 at 06:42:17PM +0800, Long Li wrote:
> There are two invocations of xfs_alloc_log_agf in xfs_alloc_put_freelist.
> The AGF does not change between the two calls. Although this does not pose
> any practical problems, it seems like a small mistake. Therefore, fix it
> by removing the first xfs_alloc_log_agf invocation.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 59326f84f6a5..cce32b2f3ffd 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3159,8 +3159,6 @@ xfs_alloc_put_freelist(
>  		logflags |= XFS_AGF_BTREEBLKS;
>  	}
>  
> -	xfs_alloc_log_agf(tp, agbp, logflags);
> -

Looks fine. That's been there since commit 92821e2ba4ae ("[XFS] Lazy
Superblock Counters") was merged back in 2007...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
