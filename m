Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27AE1A0BF2
	for <linux-xfs@vger.kernel.org>; Tue,  3 Sep 2024 09:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725356971; cv=none; b=iaNMFc2chtdf1npfolwet6iWaYkjGF3X4vFetuVzS7JXFKxZ7A6fyzOo4I/ujcv/Zc4AclSBwB/Rd4EyLfOSoHWFHJlwL+ISrKEeJX3eSwnMJiORm1mdfZKQ5L+2nX5iZkUVtRyfmEoqo/K1Tl3y0MZKAuT407DWUVYjKWmhDJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725356971; c=relaxed/simple;
	bh=XkL/DBJPB6eu/66EC7V31vfvJx4f6/7Q2IDu27//Qo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AfECbidVeJ0Qyggsux5DhF/zYrxPtG13A18aC6hFwFZfztj52HNhUC5UCeHH3cQZgdkqydwPiFcSGqvGKdDONn+4IDDVHOMu2O4pxsaQogcMs/SYVxGLXank0QsUQswsepnyhM1CubQ/0BOEVMWn0yfKWiC0xlD29qYjoAK9W0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f4ZDGSdX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f4ZDGSdX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725356968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QsbJYfggrfTke8spLwCcl+5ZDZjJmHGefvpuWyMNSrc=;
	b=f4ZDGSdX5U6EgbYA/xR2pSDWVEEhbHrxgRGpZCqHblmtJOYdVWzsa1QKSVEg+Soo1fSKpW
	l51ZB8cNc2BOAuic9EbFFsLpSEMtMp8aQxi7B6qugTvRTC/5Tc6+rFQ/C6NQfL2ctEWRyW
	dNxpv6YyJJZmbQs4j8V1PINNZ0h+M+g=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-4QVGZRcON6KG8Pwx2lFFlw-1; Tue, 03 Sep 2024 05:49:27 -0400
X-MC-Unique: 4QVGZRcON6KG8Pwx2lFFlw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a870cad2633so450142666b.1
        for <linux-xfs@vger.kernel.org>; Tue, 03 Sep 2024 02:49:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725356965; x=1725961765;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QsbJYfggrfTke8spLwCcl+5ZDZjJmHGefvpuWyMNSrc=;
        b=gFcMdBZ503PDkk0IVOzBw483pCOU4uvyMpUQLSgv0sosVM9HOjNM0ZPvF3fh/blHwJ
         a6nBAg4sS6ZSXOUtyo9URc+fQbUHiH8bo9qiLiVOM55rlc+SXR+EGinP2sXNL837nNKu
         QsGEpCNwSxq45SyKzOFt0SIX8SWSCAYbfuHr1yZJK5p94hrKDKs8kaPI9faAjsEAj3xc
         eSDtI4mAV61AaE6rvvFP2R3jnlDinQE+RM69opR/QKfcqw7ZeCqhB9NLab/ay8ze+IhN
         8BurCXGZMcbvwmfCBARMhKDTqhaluCQgF50lg00GAWGvU4pjxNZrUyzmi4vDRGQewsE4
         /y5w==
X-Gm-Message-State: AOJu0YxvvYMLmkInh7N8OQ6LUfC1S4+dFokTCYZ04lX2KvczpEX9KzSe
	gxQderve/UMxiuZtXAsXwXP2q2OvyXG3IHvqaD1VPZET3ByxKcA4G7R5/VDdiwYDVo84+1C2JUa
	uCYwy6LT0SkTkvjI77PrmKRYcST8zVlFE/KjOzgJNsXmJa5H0W1xwzH1FKIt05s1y4R1lDoGkdE
	t+uLRtw6XTotqsqqf2Srxw13AzDjoO1sABf3FL2ND+
X-Received: by 2002:a17:906:f5aa:b0:a86:851e:3a2e with SMTP id a640c23a62f3a-a897f8bd084mr1298531366b.30.1725356965568;
        Tue, 03 Sep 2024 02:49:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEC3Jl646FHaj1MhBl0cuCfwjsRdXEs23c16qUe8iFk3jJ95LIxihWobCU08Y0QItO0vhRD1Q==
X-Received: by 2002:a17:906:f5aa:b0:a86:851e:3a2e with SMTP id a640c23a62f3a-a897f8bd084mr1298528666b.30.1725356964547;
        Tue, 03 Sep 2024 02:49:24 -0700 (PDT)
Received: from thinky (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a89891dc6a1sm670678166b.175.2024.09.03.02.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 02:49:24 -0700 (PDT)
Date: Tue, 3 Sep 2024 11:49:23 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: Re: [PATCH] xfs_io: add fiemap -s flag to print number of extents
Message-ID: <ntgfvpl6beu73odmc6svck7yadyf7yb7dny7g756dxygg467kg@fm2i3p7tre57>
References: <20240903093729.1282981-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903093729.1282981-2-aalbersh@redhat.com>

NACK haven't noticed that FIEMAP also doesn't count holes

ignore

On 2024-09-03 11:37:30, Andrey Albershteyn wrote:
> FS_IOC_FIEMAP has an option to return total number of extents
> without copying each one of them. This could be pretty handy for
> checking if large file is heavily fragmented. The same can be done
> with calling FS_IOC_FIEMAP and counting lines with wc but
> FS_IOC_FIEMAP is limited to ~76mil extents (FIEMAP_MAX_EXTENTS). The
> other option is FS_IOC_FSGETXATTR which is much faster than
> iterating through all extents, but it doesn't include holes.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  io/fiemap.c | 27 +++++++++++++++++++++++----
>  1 file changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/io/fiemap.c b/io/fiemap.c
> index b41f71bfd027..d4e55a82f6db 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -42,6 +42,13 @@ fiemap_help(void)
>  "\n"));
>  }
>  
> +static void
> +print_total(
> +	   struct fiemap	*fiemap)
> +{
> +	printf("Extents total: %d\n", fiemap->fm_mapped_extents);
> +}
> +
>  static void
>  print_hole(
>  	   int		foff_w,
> @@ -223,9 +230,11 @@ fiemap_f(
>  	int		done = 0;
>  	int		lflag = 0;
>  	int		vflag = 0;
> +	int		sflag = 0;
>  	int		fiemap_flags = FIEMAP_FLAG_SYNC;
>  	int		c;
>  	int		i;
> +	int		ext_arr_size = 0;
>  	int		map_size;
>  	int		ret;
>  	int		cur_extent = 0;
> @@ -242,7 +251,7 @@ fiemap_f(
>  
>  	init_cvtnum(&fsblocksize, &fssectsize);
>  
> -	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
> +	while ((c = getopt(argc, argv, "aln:sv")) != EOF) {
>  		switch (c) {
>  		case 'a':
>  			fiemap_flags |= FIEMAP_FLAG_XATTR;
> @@ -253,6 +262,9 @@ fiemap_f(
>  		case 'n':
>  			max_extents = atoi(optarg);
>  			break;
> +		case 's':
> +			sflag++;
> +			break;
>  		case 'v':
>  			vflag++;
>  			break;
> @@ -285,8 +297,9 @@ fiemap_f(
>  		range_end = start_offset + length;
>  	}
>  
> -	map_size = sizeof(struct fiemap) +
> -		(EXTENT_BATCH * sizeof(struct fiemap_extent));
> +	if (!sflag)
> +		ext_arr_size = (EXTENT_BATCH * sizeof(struct fiemap_extent));
> +	map_size = sizeof(struct fiemap) + ext_arr_size;
>  	fiemap = malloc(map_size);
>  	if (!fiemap) {
>  		fprintf(stderr, _("%s: malloc of %d bytes failed.\n"),
> @@ -302,7 +315,8 @@ fiemap_f(
>  		fiemap->fm_flags = fiemap_flags;
>  		fiemap->fm_start = last_logical;
>  		fiemap->fm_length = range_end - last_logical;
> -		fiemap->fm_extent_count = EXTENT_BATCH;
> +		if (!sflag)
> +			fiemap->fm_extent_count = EXTENT_BATCH;
>  
>  		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
>  		if (ret < 0) {
> @@ -313,6 +327,11 @@ fiemap_f(
>  			return 0;
>  		}
>  
> +		if (sflag) {
> +			print_total(fiemap);
> +			goto out;
> +		}
> +
>  		/* No more extents to map, exit */
>  		if (!fiemap->fm_mapped_extents)
>  			break;
> -- 
> 2.44.1
> 

-- 
- Andrey

