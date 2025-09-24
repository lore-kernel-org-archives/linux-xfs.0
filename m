Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D594A35
	for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 13:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758719904; cv=none; b=Q+fDU5UYvqcNGuu/mwXw6yrAf7Ejbed9xkI5peMXR2gGIQ/A4rwlYgFRg8PeA8UdN77INC6e5aGXJA29kXtkWEZpFGtHsPv+zUp8l39OfzYqh18G1iiAl/YngcyiwajNbtPC5zFaPY2VuaiB/czmUv2vdtGglX3LdamQAJ63qSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758719904; c=relaxed/simple;
	bh=yF+7xX7ykx3hS336M2IlJmGHvyexh4Y7GSYUze0pkFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F+yQA1fa6zf5VFpO2ljIr2mUcK6oF4x2AHRRJAO/6tg10/SI0Z5G/SZMl+qzv76+svdkfA/TEy+oyN0IfdV8JF5L2OX4o3EmzAi7IskBj3qByY+/h8hH5tmiwQZVpplU5qY3elr/RHdmEIgifQEALtNUxZK65NB77zKCKx5zxjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=crsEljmX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="crsEljmX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758719901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K/Ecjhv2mPIllq5wyRpDs9pUowOC4T5F6rzP9Qn3n1w=;
	b=crsEljmXXASEH0krlJfXzuYZzGfGmPj0TlXm4r5DMEcf8t8vndDnt2fHaY2rEkaomkW0qP
	qdQfe9RZAfKjrO2tS+ZJyN+fvTbK5xPrnvbpCwXRL06eNl8qe6o63E30/HLRX7Z6s4QYud
	0WgAG8SNmTi6CZyuFps6xjmmMso5aNM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-hu6I0nHyPzCyUgxHqJ3pHg-1; Wed, 24 Sep 2025 09:18:20 -0400
X-MC-Unique: hu6I0nHyPzCyUgxHqJ3pHg-1
X-Mimecast-MFC-AGG-ID: hu6I0nHyPzCyUgxHqJ3pHg_1758719899
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46c84b3b27bso24485805e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 06:18:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758719898; x=1759324698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K/Ecjhv2mPIllq5wyRpDs9pUowOC4T5F6rzP9Qn3n1w=;
        b=gZJ7aqv0A1tL5g/yHfcNyPhVRE/TTlsApa0Iz34RRKsgdBiMOaAmjv2CHXrd4A6VqE
         JqbU2d3KnK9zbpRW5/5QdMalkXLkt5EOm7jfJuEAycRUSbRwunVAtx0M2fkmaUrhdABN
         6tbVqKjk1PfcOvJgvYEFJvYCDzsjqEkHF3b9yrF8qBW6LG5w4xx9iYkDGyr4qFq8iV3P
         7IfGy+Yr0M0bK1L+LcoTuinvkZhsGskUMmy1x30SLR+5K+jE8knNE8Xk31POunUD92du
         j+pFW3auTfafM1zRqtQI1SA4GXrhsvARpyjNCsd1I3VHRDVO3ZHAXin6WVhvg7sbBPpe
         WsCw==
X-Gm-Message-State: AOJu0Yzz+I1UFvxGOURR9bZ5RoqpQcXOFnxw8M0ofq7dy6LGfltP2nnq
	MJN28VcaDbp+0/6Xu0+1s2jgstYZLEn9YH0MLQZ4Cp8ztQC3pK+o1mPUzc1+pTrql67m0oVRqKW
	PUmJ32K6pK1g1jHuucNd8nwmjtTaDSiG3GwDdQfOVx5sjJeYiMyT5SXQd22s9EUJ2TaHi6uo=
X-Gm-Gg: ASbGncsgR3nA7p0NZ1OX7mCRMBdgiAI9gLmFfcjJrj3rmtvnWjXys0+vrLDnjTAyk6b
	Bb7xfHhz3zSm/qyvI1SaUIrEZIiOAFn+0kd95zUcHNrhAC7NE8ujSWW4SnLWRimmhFJuusn6ykw
	gEWuhB8AoT7R9XYR68NogpIQ0nZjDLWIw8me86oiBPGeLiZ+C+74O39u+9/MPut3iakP7UIMFm+
	cyn3DnfOp5pOeoU2+rFuZoXr477Ym14sEZyx9f/zJnO0+/JxixDdE3b4eOpOCRIIjnC5QnttAgF
	9l7u7ZI3k4sE+AjM+O9FVhQvfvJ2O2C3
X-Received: by 2002:a05:600c:198f:b0:45d:d9ab:b86d with SMTP id 5b1f17b1804b1-46e1dac6457mr66958845e9.31.1758719897855;
        Wed, 24 Sep 2025 06:18:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpAPXc6FySB4IcrV5YRJYZpddIM/HitLD16HFfsSh/dTyl9pq8g+LLJcWEjrtStLGYSj+79w==
X-Received: by 2002:a05:600c:198f:b0:45d:d9ab:b86d with SMTP id 5b1f17b1804b1-46e1dac6457mr66958535e9.31.1758719897338;
        Wed, 24 Sep 2025 06:18:17 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f829e01a15sm16557447f8f.57.2025.09.24.06.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 06:18:16 -0700 (PDT)
Date: Wed, 24 Sep 2025 15:18:15 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] libfrog: pass mode to xfrog_file_setattr
Message-ID: <zzigcp3ew5h2yyngalxt7dpahsl2z2zdhpqxytc36os7ou257i@2nbwj2qghase>
References: <20250923170857.GS8096@frogsfrogsfrogs>
 <20250923171027.GU8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923171027.GU8096@frogsfrogsfrogs>

On 2025-09-23 10:10:27, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs/633 crashes rdump_fileattrs_path passes a NULL struct stat pointer
> and then the fallback code dereferences it to get the file mode.

Oh is it latest xfsprogs with older kernel (without file_[g]etattr)?

(I see this on 6.16)

> Instead, let's just pass the stat mode directly to it, because that's
> the only piece of information that it needs.
> 
> Fixes: 128ac4dadbd633 ("xfs_db: use file_setattr to copy attributes on special files with rdump")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  libfrog/file_attr.h |    9 ++-------
>  db/rdump.c          |    4 ++--
>  io/attr.c           |    4 ++--
>  libfrog/file_attr.c |    4 ++--
>  quota/project.c     |    6 ++++--
>  5 files changed, 12 insertions(+), 15 deletions(-)
> 
> diff --git a/libfrog/file_attr.h b/libfrog/file_attr.h
> index df9b6181d52cf9..2a1c0d42d0a771 100644
> --- a/libfrog/file_attr.h
> +++ b/libfrog/file_attr.h
> @@ -24,12 +24,7 @@ xfrog_file_getattr(
>  	struct file_attr	*fa,
>  	const unsigned int	at_flags);
>  
> -int
> -xfrog_file_setattr(
> -	const int		dfd,
> -	const char		*path,
> -	const struct stat	*stat,
> -	struct file_attr	*fa,
> -	const unsigned int	at_flags);
> +int xfrog_file_setattr(const int dfd, const char *path, const mode_t mode,
> +		struct file_attr *fa, const unsigned int at_flags);

Is this formatting change intentional? (maybe then the
xfrog_file_getattr also)

otherwise lgtm
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

>  
>  #endif /* __LIBFROG_FILE_ATTR_H__ */
> diff --git a/db/rdump.c b/db/rdump.c
> index 84ca3156d60598..26f9babad62be1 100644
> --- a/db/rdump.c
> +++ b/db/rdump.c
> @@ -188,8 +188,8 @@ rdump_fileattrs_path(
>  			return 1;
>  	}
>  
> -	ret = xfrog_file_setattr(destdir->fd, pbuf->path, NULL, &fa,
> -			AT_SYMLINK_NOFOLLOW);
> +	ret = xfrog_file_setattr(destdir->fd, pbuf->path, VFS_I(ip)->i_mode,
> +			&fa, AT_SYMLINK_NOFOLLOW);
>  	if (ret) {
>  		if (errno == EOPNOTSUPP || errno == EPERM || errno == ENOTTY)
>  			lost_mask |= LOST_FSXATTR;
> diff --git a/io/attr.c b/io/attr.c
> index 022ca5f1df1b7c..9563ff74e44777 100644
> --- a/io/attr.c
> +++ b/io/attr.c
> @@ -261,7 +261,7 @@ chattr_callback(
>  
>  	attr.fa_xflags |= orflags;
>  	attr.fa_xflags &= ~andflags;
> -	error = xfrog_file_setattr(AT_FDCWD, path, stat, &attr,
> +	error = xfrog_file_setattr(AT_FDCWD, path, stat->st_mode, &attr,
>  				   AT_SYMLINK_NOFOLLOW);
>  	if (error) {
>  		fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
> @@ -357,7 +357,7 @@ chattr_f(
>  
>  	attr.fa_xflags |= orflags;
>  	attr.fa_xflags &= ~andflags;
> -	error = xfrog_file_setattr(AT_FDCWD, name, &st, &attr,
> +	error = xfrog_file_setattr(AT_FDCWD, name, st.st_mode, &attr,
>  				   AT_SYMLINK_NOFOLLOW);
>  	if (error) {
>  		fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
> diff --git a/libfrog/file_attr.c b/libfrog/file_attr.c
> index bb51ac6eb2ef95..c2cbcb4e14659c 100644
> --- a/libfrog/file_attr.c
> +++ b/libfrog/file_attr.c
> @@ -85,7 +85,7 @@ int
>  xfrog_file_setattr(
>  	const int		dfd,
>  	const char		*path,
> -	const struct stat	*stat,
> +	const mode_t		mode,
>  	struct file_attr	*fa,
>  	const unsigned int	at_flags)
>  {
> @@ -103,7 +103,7 @@ xfrog_file_setattr(
>  		return error;
>  #endif
>  
> -	if (SPECIAL_FILE(stat->st_mode)) {
> +	if (SPECIAL_FILE(mode)) {
>  		errno = EOPNOTSUPP;
>  		return -1;
>  	}
> diff --git a/quota/project.c b/quota/project.c
> index 5832e1474e2549..33449e01ef4dbb 100644
> --- a/quota/project.c
> +++ b/quota/project.c
> @@ -157,7 +157,8 @@ clear_project(
>  	fa.fa_projid = 0;
>  	fa.fa_xflags &= ~FS_XFLAG_PROJINHERIT;
>  
> -	error = xfrog_file_setattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
> +	error = xfrog_file_setattr(dfd, path, stat->st_mode, &fa,
> +			AT_SYMLINK_NOFOLLOW);
>  	if (error) {
>  		fprintf(stderr, _("%s: cannot clear project on %s: %s\n"),
>  			progname, path, strerror(errno));
> @@ -205,7 +206,8 @@ setup_project(
>  	if (S_ISDIR(stat->st_mode))
>  		fa.fa_xflags |= FS_XFLAG_PROJINHERIT;
>  
> -	error = xfrog_file_setattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
> +	error = xfrog_file_setattr(dfd, path, stat->st_mode, &fa,
> +			AT_SYMLINK_NOFOLLOW);
>  	if (error) {
>  		fprintf(stderr, _("%s: cannot set project on %s: %s\n"),
>  			progname, path, strerror(errno));
> 

-- 
- Andrey

