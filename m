Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564F856B60
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 19:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710791337; cv=none; b=FUgRlw70pqrtf9PJI5bQMHITy5d3Sd0MAeZMfdQaVvWFREA7Xiil4pJ2gY+TLxoVnMLQjjRPGI2Ffa/RWld3Sp84kAvCKuOOFWsuEfdTgdJ7/+c+xRFF7Jx+a1A4h5rrGwsB4zfdnSixjoSUU9jGjtfn1Htcp3B20n0qaHRJMOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710791337; c=relaxed/simple;
	bh=HcyNRAaSvVR/TK1oY1imlZkpQ7tr6zcuYNe1c6B+IZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aQHgs3+xdio7bQYAWorElmDeE1eQlpfOUjlZ0X6FEQ+iOyOWw2YEdJgL4kuo3x/HPSUOsW3QC/W8FA8n8cd/RUeThhtJywU+8sOPU/Y/2X3dENGyfwgNqpmPAAHaLNjLwJGY0tRyBIKzTup/BbyyBThDRsW7PirnLy8ujr+SHUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tq3W9y6W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tq3W9y6W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710791332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oOqdgcxTH2OLnV0pHfnH8Nt0Lqbw8koRvQxc7E7h07s=;
	b=Tq3W9y6Wd42HMN9TQpwF0M4AUX9R8H+c/6NQ9coZRZZ+5hJMMpg5+OAhfpQw2dKyUNZno4
	/1DjU+XjmUBHJKlEJrdkjRest48epd1S4GioUyGlUEbPFbRRXmjXSNUDUVwQFadAZh3kNI
	jrffI1uMufs5gZWI44iTJNPZDXl+890=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-D0XbA3CNO22N4LkMmQMPyw-1; Mon, 18 Mar 2024 15:48:50 -0400
X-MC-Unique: D0XbA3CNO22N4LkMmQMPyw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33ece03ca5dso2796126f8f.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 12:48:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710791329; x=1711396129;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOqdgcxTH2OLnV0pHfnH8Nt0Lqbw8koRvQxc7E7h07s=;
        b=stcFwzfjLJzDVmEt8GLKmv0IyN2zxqeSow9MBB/4WLXFOyLTzJVJ5pTylip3OgmL6o
         tKUzHpdVGbvuRLvQBuGgda0yZoVWauFhS8KmBlysD83WJMKDVYzTr3+MpdDo8sVomOHa
         obirvnF4XDc9P90FmQk6fY4n1MXrmDtFHoF5FOoaqgs9rj1ouhoUOcYPURod/I7V4F4K
         moLcJvHwiS6gEDNMU8Ki29Xb+I6RRkLQntU/daOTmFwXp25Ppedl+WFHivkXyfdiOfYD
         4ajeE9l8sGWNgUPw7neNXai4cgnsTqF0TbmMpUn5ZU2f4v/78lWxMbkghSwlBYUPIlAh
         3Gbg==
X-Forwarded-Encrypted: i=1; AJvYcCUvomLpxicqjJ0mflyEwMxqxp4ZzA/mm1GyFczEYejxGBGpcm3X5CjXzzANpeXdqDd0eqSM5FQcoCC1cZlwfsGZOw9CQ+Tf5sNn
X-Gm-Message-State: AOJu0YzxlGSz9k4pkUboWFQRTByBXajH2H6jOIvSeUc2HYDObNmLgyi4
	FCTQRAyv/y4WtRXWcoy+8WRREMRF7F8KRi2M3O09Jrjl8KdFZGFNgqysyAmG3Z54fwsXkEv9Aw+
	YK+t+2FUAm1Qr1bGrORnmDNZc27g/+SqCgE9qpnFqaJ69I1TieSqN/jcFsFhulbDo
X-Received: by 2002:a05:6000:2c1:b0:33e:75fb:b913 with SMTP id o1-20020a05600002c100b0033e75fbb913mr362546wry.14.1710791329023;
        Mon, 18 Mar 2024 12:48:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmhHFEmeCMf0/MvrmnUNbFENwn/JsYxFZoXvcdt6TUYYdr+isHkaJA/RtYfMH4u+9ztYUvhg==
X-Received: by 2002:a05:6000:2c1:b0:33e:75fb:b913 with SMTP id o1-20020a05600002c100b0033e75fbb913mr362530wry.14.1710791328487;
        Mon, 18 Mar 2024 12:48:48 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id f22-20020a5d58f6000000b0033e7a204dc7sm10493478wrd.32.2024.03.18.12.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 12:48:48 -0700 (PDT)
Date: Mon, 18 Mar 2024 20:48:47 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/40] xfs: disable direct read path for fs-verity files
Message-ID: <eb7rlbfslyht2vmn7ocqcx5fkjyrle4ocgex6hmjxzs4gtkkgm@mvmsrj7sgojd>
References: <171069245829.2684506.10682056181611490828.stgit@frogsfrogsfrogs>
 <171069246296.2684506.17423583037447505680.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171069246296.2684506.17423583037447505680.stgit@frogsfrogsfrogs>

On 2024-03-17 09:29:39, Darrick J. Wong wrote:
> From: Andrey Albershteyn <aalbersh@redhat.com>
> 
> The direct path is not supported on verity files. Attempts to use direct
> I/O path on such files should fall back to buffered I/O path.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> [djwong: fix braces]
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_file.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 74dba917be93..0ce51a020115 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -281,7 +281,8 @@ xfs_file_dax_read(
>  	struct kiocb		*iocb,
>  	struct iov_iter		*to)
>  {
> -	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
> +	struct inode		*inode = iocb->ki_filp->f_mapping->host;
> +	struct xfs_inode	*ip = XFS_I(inode);
>  	ssize_t			ret = 0;
>  
>  	trace_xfs_file_dax_read(iocb, to);
> @@ -334,10 +335,18 @@ xfs_file_read_iter(
>  
>  	if (IS_DAX(inode))
>  		ret = xfs_file_dax_read(iocb, to);
> -	else if (iocb->ki_flags & IOCB_DIRECT)
> +	else if (iocb->ki_flags & IOCB_DIRECT && !fsverity_active(inode))

Brackets missing

>  		ret = xfs_file_dio_read(iocb, to);
> -	else
> +	else {
> +		/*
> +		 * In case fs-verity is enabled, we also fallback to the
> +		 * buffered read from the direct read path. Therefore,
> +		 * IOCB_DIRECT is set and need to be cleared (see
> +		 * generic_file_read_iter())
> +		 */
> +		iocb->ki_flags &= ~IOCB_DIRECT;
>  		ret = xfs_file_buffered_read(iocb, to);
> +	}
>  
>  	if (ret > 0)
>  		XFS_STATS_ADD(mp, xs_read_bytes, ret);
> 
> 

-- 
- Andrey

