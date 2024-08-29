Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32A71C28E
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 01:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724894967; cv=none; b=cKE6VRRVxC+AaEeMIb1nXr2Yy+6dxw7Yhur4AkWFFAuqqN1lPa2siQmOL16gqX0wi3op11WTItuBHXuJlTn+Jz3pZbRgUg0C7q9KpcaTToTpDOe/z3/yLzwiEQmv0IpbdjG4jLQvF/n4jxNePhxfd7wneZoPMJouxXiLL2LIOsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724894967; c=relaxed/simple;
	bh=tMKRHMiwYFBYYLpYz5ULfIeIZa2th4YCSl0sLmzj03s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rw7vwndhLgBSknevz1VjcmPPGufkk8WZFRnXFjKZChBLQ7cy/Edj4CkcvJyfPwep07PGnU6j0n4j8kFruAJ9nU+z5GzrhMIP/XtSlEP0LU38uGRYIsZuyGxsgNx57NZwSHEeNbE8c1z0wneYoQbFHgslAEM3nzgxE0AcNF7MV9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=HHtdW6GF; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="HHtdW6GF"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-39b0826298cso261425ab.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 18:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724894965; x=1725499765; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ybDQc90PP+sMcx9+DKPiXjIgthWlBK0JJU1cbW7Ny8A=;
        b=HHtdW6GF1xIL7AB+pQrRYVZeOKkvZAhbg3qRnGgo9NRqhHuMwnkcKPAH5qT9P0A0ph
         RTsqMCh39AScyP4mVui1Lm9iQdEu9oymVfGbOYiG58ziQ8eS37LmCnd7d/ZJG1yoTJRs
         2CLbOMruyh0X7AMeXQo+76TjinIyJdVmLMM7a0PZBLYjS5ZojlBk4C3TZtPpuCugyeKZ
         BfW5TOn829QVzZvjlRkIJ1km3niajdOmZeLZJremwyUrYNwDEo8W9YmY/9ghcEMedAST
         dP6uU6glI4RQ43gY7PrGvQySp9n08nCRj2tQFnTjzbCoI67YzkMkF7fdEU9y+YAOvovI
         WiEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724894965; x=1725499765;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ybDQc90PP+sMcx9+DKPiXjIgthWlBK0JJU1cbW7Ny8A=;
        b=NRLHvzTS6Rx2VmrtBf5qqxb+P7mKVZVfGSGbbDiQgnWOtaCE2dwFitd+YmSnUlBIYh
         Anf3x/apC9G7d2D79GJsV2+zCGxuwCBKO50MF/tyjApTCcjAzIl4xg0n/J2j2Ixi5Ys2
         a2u9srMSwdSDuLIquQrVlrIJn3RI8D2r0fTiWKSgMwtCALqhIUV6exgUP3GjHaXgVghx
         YrAPuLHc2wiGKdUTbF5TAUOuEHsd3GaydoV5wmxTl1j0ICnxkJqVY9xObSGHRe6TzzTu
         Ly6IpWA/pQ4IwEtGuaN8ou+GvW791TOq3hW6oT3vBoQzBBYFkAp2Z55D0oZjaNwL7216
         9Uhg==
X-Forwarded-Encrypted: i=1; AJvYcCU/s6le6wBHQbkwCxfTYsdvKQiU6LtsPjx/YUkOPAq8YKx2rRjAoj6beaP4BMP1QSor64vF57MYgBc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKaa51Fl/ea1UT7WcywExO2QQuJq2U8iPuPGvXQpZV2/7wBKnF
	wGB5kP9tnxpHtP5vAX30gHW/DGEh6IEJs34fS6dUKN30lCpDPy4vkV5VB1Vhr08t+EHwR6qkL6p
	q
X-Google-Smtp-Source: AGHT+IFsquxPJ8jP9mQ17ksvvSYJACH35Cs/YSadkrlBwfSkD43Eqw/AxrDBMdx6Xh74xdbPDWuUMw==
X-Received: by 2002:a05:6e02:1ca6:b0:377:14a7:fc99 with SMTP id e9e14a558f8ab-39f37884e46mr18397465ab.24.1724894964695;
        Wed, 28 Aug 2024 18:29:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d22e774d7csm108445a12.31.2024.08.28.18.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 18:29:24 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sjTyT-00GNMq-1f;
	Thu, 29 Aug 2024 11:29:21 +1000
Date: Thu, 29 Aug 2024 11:29:21 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: kernel@mattwhitlock.name, sam@gentoo.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 01/10] xfs: fix C++ compilation errors in xfs_fs.h
Message-ID: <Zs/O8fklY8mmcZX8@dread.disaster.area>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
 <172480131521.2291268.17945339760767205637.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172480131521.2291268.17945339760767205637.stgit@frogsfrogsfrogs>

On Tue, Aug 27, 2024 at 04:33:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Several people reported C++ compilation errors due to things that C
> compilers allow but C++ compilers do not.  Fix both of these problems,
> and hope there aren't more of these brown paper bags in 2 months when we
> finally get these fixes through the process into a released xfsprogs.
> 
> Reported-by: kernel@mattwhitlock.name
> Reported-by: sam@gentoo.org
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219203
> Fixes: 233f4e12bbb2c ("xfs: add parent pointer ioctls")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_fs.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index c85c8077fac39..6a63634547ca9 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -930,13 +930,13 @@ static inline struct xfs_getparents_rec *
>  xfs_getparents_next_rec(struct xfs_getparents *gp,
>  			struct xfs_getparents_rec *gpr)
>  {
> -	void *next = ((void *)gpr + gpr->gpr_reclen);
> +	void *next = ((char *)gpr + gpr->gpr_reclen);
>  	void *end = (void *)(uintptr_t)(gp->gp_buffer + gp->gp_bufsize);
>  
>  	if (next >= end)
>  		return NULL;
>  
> -	return next;
> +	return (struct xfs_getparents_rec *)next;
>  }

Please move this code completely out of the xfs_fs.h header. It is
not part of the kernel UAPI, and we have always tried to keep code
out of public header files like this because it tends to cause
unexpected build problems for users and 3rd party applications....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
