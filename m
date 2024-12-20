Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9432185AC
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 14:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734705503; cv=none; b=PXTk95b94lLJQ9bOdAoOYCjCqRANLbcnafH0xLCO4/49bdqcgO1iOEtNpYGKIamgJ29tVa6oX5Ff9YA2SdkaecX02S1Zzwi5oYV4voGjy1ZQFelUsc/LLtWkNXvmr6/HoBDmzLvQIgodSygLEkh1jRa2dPeB+O3ee7v8Avpsc2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734705503; c=relaxed/simple;
	bh=YqYnM2h+BQ1Xpy9cJA6I6NF5w9nxdQMBrj4s94ncK6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lCtCbh9zNOkDwLa3fcSz6hHun6747eFyFFScYDzIpt1Ll+rEr2qO7/ReGdshh2KXZ9yXYOsRElUsvvKvbEyTF1e5JxtkElNdD9rB9/5ltTheuF9zBNmYEXQ+MgK7JqCNnqnhgNjwGbz2yuOd63j4+Ksez+fQCP2sE/PaA1tEspY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XzDkEi6r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XzDkEi6r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734705500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ESGMPASQvRLY+GqifPVdaIbTmbGSWUD3exApWbCRkpM=;
	b=XzDkEi6r5cSS6k0en18iUt4yF9bYOoSeZHzQR3my+QYC1HlOcX2/FDVe7E1DKQmMCyW4E/
	auvgO/VkB5l0yNl44hr/MIPKqIGKbZy6VLvEq9H+jVVAxgutsP11FH8RNSIhwhcH9cLRQD
	DCpPWpQ1VQZySxSHPYoI/hXN4bpywrA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-de0B90q5MiKcr-4BjRQf0Q-1; Fri, 20 Dec 2024 09:38:19 -0500
X-MC-Unique: de0B90q5MiKcr-4BjRQf0Q-1
X-Mimecast-MFC-AGG-ID: de0B90q5MiKcr-4BjRQf0Q
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-aa63b02c69cso40873966b.0
        for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 06:38:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734705498; x=1735310298;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ESGMPASQvRLY+GqifPVdaIbTmbGSWUD3exApWbCRkpM=;
        b=ElpfRqA7EwdGeKrNY9pTDhzqiSdJ22fAh9Bc2Q0uWsetwq96kT9qZbjNFlzPREN7+1
         IgOwebOafwawNEa3o3OwTWTnCgc3J9C0v76iWil1YQO6g+Y1IstfJCw1vhHM1oh53Efd
         r5etRpC6jExxKQnLWlhNbeJ55OR/A5fN0eQiWjv9c3YXTE3fRk7BVVlkp5Iu9blOfGK7
         jz6GDWel6TQC8IVRDUuYXKQdX3PkPx4mbIgxOJbtW1e8737wpZS23d/SZj2hgkCUrNC9
         M4dlpJJYsaqJCCXwIZlezmtJdL5qePyv4D6uXvZjEEbxFkSHuEh0lXJg9AawyFF78F+E
         GjOg==
X-Forwarded-Encrypted: i=1; AJvYcCXcHEQhBFW9qoTURhCNZLbz72GDsaGbwWPR696vGVPcwBBGKDfmCAMnV9jxVuTg9ov8s4abt+DHSj4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+dC6Gj2ViZLZpyJyFN75I0qioUWDEpLBQUJg6L3RvxMhz8mrA
	KjNlqRfKogUI4t1/IKVWkOqdaJvAIIwGIfggwREpUsdZLvQwpMzEakqpeocXG7eDMxyRtD3VeFF
	M1Sc8eVi5iQu0ueMRvBb/U8Jgiy25ihFMKmNp/m4AEpDkQ6fQrIo7bsnR
X-Gm-Gg: ASbGncsbQT/VHbA7FFV+xEZ9i4WAZbPn5S/h/4TblX60ogG/2jDg8bZGkIWt04bL1RQ
	JSiJZpdIEcOVBSIuc7OXXEBz+2BMjOs5Rpu4RIkXV/HCOffIUhQ3sImW22Ze6m/OoD/JjK+qiPI
	hpG3Hnpe2uAA05tToBaYN5ZVo6ZWmO50tLuIX3CG+FwXvXb6mxvl+4qSddgoda3Qf10s7YLavFn
	5Tl+kgKe768ok3CXQ+T34/KdLu7oL5uBbtwHDrl0RFQPgltyzAk7KThM+LSg53Ezke7SVbd+eIN
X-Received: by 2002:a05:6402:2691:b0:5d0:7282:6f22 with SMTP id 4fb4d7f45d1cf-5d80245b76fmr6064404a12.14.1734705498290;
        Fri, 20 Dec 2024 06:38:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF4vIpfYzp9xofNwbghPGoCDzzOcULp/GyM9MWipXldmXp9S37WjWB9nn/OxP9G6PsKMgAfqg==
X-Received: by 2002:a05:6402:2691:b0:5d0:7282:6f22 with SMTP id 4fb4d7f45d1cf-5d80245b76fmr6064384a12.14.1734705497818;
        Fri, 20 Dec 2024 06:38:17 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80679efc9sm1781535a12.47.2024.12.20.06.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2024 06:38:17 -0800 (PST)
Date: Fri, 20 Dec 2024 15:38:16 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/50] xfs_mdrestore: restore rt group superblocks to
 realtime device
Message-ID: <qpdtf3v2zytshxy7wmw364jrtrpjhm6rivk5bel5mwhw7edtif@rzguazl3gqvo>
References: <173405323136.1228937.15295934936342173452.stgit@frogsfrogsfrogs>
 <173405323720.1228937.8741858826144010013.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405323720.1228937.8741858826144010013.stgit@frogsfrogsfrogs>

On 2024-12-12 17:29:22, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Support restoring realtime device metadata to the realtime device, if
> the dumped filesystem had one.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

LGTM
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

> ---
>  man/man8/xfs_mdrestore.8  |   10 ++++++++++
>  mdrestore/xfs_mdrestore.c |   47 ++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 48 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
> index f60e7b56ebf0d1..6f6e14e96c6a5c 100644
> --- a/man/man8/xfs_mdrestore.8
> +++ b/man/man8/xfs_mdrestore.8
> @@ -8,6 +8,9 @@ .SH SYNOPSIS
>  ] [
>  .B \-l
>  .I logdev
> +] [
> +.B \-r
> +.I rtdev
>  ]
>  .I source
>  .I target
> @@ -17,6 +20,9 @@ .SH SYNOPSIS
>  [
>  .B \-l
>  .I logdev
> +] [
> +.B \-r
> +.I rtdev
>  ]
>  .I source
>  .br
> @@ -61,6 +67,10 @@ .SH OPTIONS
>  In such a scenario, the user has to provide a device to which the log device
>  contents from the metadump file are copied.
>  .TP
> +.BI \-r " rtdev"
> +Restore realtime device metadata to this device.
> +This is only required for a metadump in v2 format.
> +.TP
>  .B \-V
>  Prints the version number and exits.
>  .SH DIAGNOSTICS
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index c5584fec68813e..d5014981b15a68 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -28,7 +28,8 @@ struct mdrestore_ops {
>  	void (*show_info)(union mdrestore_headers *header, const char *md_file);
>  	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
>  			const struct mdrestore_dev *ddev,
> -			const struct mdrestore_dev *logdev);
> +			const struct mdrestore_dev *logdev,
> +			const struct mdrestore_dev *rtdev);
>  };
>  
>  static struct mdrestore {
> @@ -37,6 +38,7 @@ static struct mdrestore {
>  	bool			show_info;
>  	bool			progress_since_warning;
>  	bool			external_log;
> +	bool			realtime_data;
>  } mdrestore;
>  
>  static void
> @@ -212,7 +214,8 @@ restore_v1(
>  	union mdrestore_headers		*h,
>  	FILE				*md_fp,
>  	const struct mdrestore_dev	*ddev,
> -	const struct mdrestore_dev	*logdev)
> +	const struct mdrestore_dev	*logdev,
> +	const struct mdrestore_dev	*rtdev)
>  {
>  	struct xfs_metablock	*metablock;	/* header + index + blocks */
>  	__be64			*block_index;
> @@ -336,8 +339,9 @@ read_header_v2(
>  	if (!mdrestore.external_log && (compat & XFS_MD2_COMPAT_EXTERNALLOG))
>  		fatal("External Log device is required\n");
>  
> -	if (h->v2.xmh_incompat_flags & cpu_to_be32(XFS_MD2_INCOMPAT_RTDEVICE))
> -		fatal("Realtime device not yet supported\n");
> +	if ((h->v2.xmh_incompat_flags & cpu_to_be32(XFS_MD2_INCOMPAT_RTDEVICE)) &&
> +	    !mdrestore.realtime_data)
> +		fatal("Realtime device is required\n");
>  }
>  
>  static void
> @@ -346,14 +350,17 @@ show_info_v2(
>  	const char		*md_file)
>  {
>  	uint32_t		compat_flags;
> +	uint32_t		incompat_flags;
>  
>  	compat_flags = be32_to_cpu(h->v2.xmh_compat_flags);
> +	incompat_flags = be32_to_cpu(h->v2.xmh_incompat_flags);
>  
> -	printf("%s: %sobfuscated, %s log, external log contents are %sdumped, %s metadata blocks,\n",
> +	printf("%s: %sobfuscated, %s log, external log contents are %sdumped, rt device contents are %sdumped, %s metadata blocks,\n",
>  		md_file,
>  		compat_flags & XFS_MD2_COMPAT_OBFUSCATED ? "":"not ",
>  		compat_flags & XFS_MD2_COMPAT_DIRTYLOG ? "dirty":"clean",
>  		compat_flags & XFS_MD2_COMPAT_EXTERNALLOG ? "":"not ",
> +		incompat_flags & XFS_MD2_INCOMPAT_RTDEVICE ? "":"not ",
>  		compat_flags & XFS_MD2_COMPAT_FULLBLOCKS ? "full":"zeroed");
>  }
>  
> @@ -390,7 +397,8 @@ restore_v2(
>  	union mdrestore_headers		*h,
>  	FILE				*md_fp,
>  	const struct mdrestore_dev	*ddev,
> -	const struct mdrestore_dev	*logdev)
> +	const struct mdrestore_dev	*logdev,
> +	const struct mdrestore_dev	*rtdev)
>  {
>  	struct xfs_sb		sb;
>  	struct xfs_meta_extent	xme;
> @@ -431,6 +439,11 @@ restore_v2(
>  		verify_device_size(logdev, sb.sb_logblocks, sb.sb_blocksize);
>  	}
>  
> +	if (sb.sb_rblocks > 0) {
> +		ASSERT(mdrestore.realtime_data == true);
> +		verify_device_size(rtdev, sb.sb_rblocks, sb.sb_blocksize);
> +	}
> +
>  	if (pwrite(ddev->fd, block_buffer, len, 0) < 0)
>  		fatal("error writing primary superblock: %s\n",
>  			strerror(errno));
> @@ -459,6 +472,10 @@ restore_v2(
>  			device = "log";
>  			fd = logdev->fd;
>  			break;
> +		case XME_ADDR_RT_DEVICE:
> +			device = "rt";
> +			fd = rtdev->fd;
> +			break;
>  		default:
>  			fatal("Invalid device found in metadump\n");
>  			break;
> @@ -488,7 +505,7 @@ static struct mdrestore_ops mdrestore_ops_v2 = {
>  static void
>  usage(void)
>  {
> -	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n",
> +	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] [-r rtdev] source target\n",
>  		progname);
>  	exit(1);
>  }
> @@ -501,18 +518,21 @@ main(
>  	union mdrestore_headers	headers;
>  	DEFINE_MDRESTORE_DEV(ddev);
>  	DEFINE_MDRESTORE_DEV(logdev);
> +	DEFINE_MDRESTORE_DEV(rtdev);
>  	FILE			*src_f;
>  	char			*logdev_path = NULL;
> +	char			*rtdev_path = NULL;
>  	int			c;
>  
>  	mdrestore.show_progress = false;
>  	mdrestore.show_info = false;
>  	mdrestore.progress_since_warning = false;
>  	mdrestore.external_log = false;
> +	mdrestore.realtime_data = false;
>  
>  	progname = basename(argv[0]);
>  
> -	while ((c = getopt(argc, argv, "gil:V")) != EOF) {
> +	while ((c = getopt(argc, argv, "gil:r:V")) != EOF) {
>  		switch (c) {
>  			case 'g':
>  				mdrestore.show_progress = true;
> @@ -524,6 +544,10 @@ main(
>  				logdev_path = optarg;
>  				mdrestore.external_log = true;
>  				break;
> +			case 'r':
> +				rtdev_path = optarg;
> +				mdrestore.realtime_data = true;
> +				break;
>  			case 'V':
>  				printf("%s version %s\n", progname, VERSION);
>  				exit(0);
> @@ -592,10 +616,15 @@ main(
>  	if (mdrestore.external_log)
>  		open_device(&logdev, logdev_path);
>  
> -	mdrestore.mdrops->restore(&headers, src_f, &ddev, &logdev);
> +	/* check and open realtime device */
> +	if (mdrestore.realtime_data)
> +		open_device(&rtdev, rtdev_path);
> +
> +	mdrestore.mdrops->restore(&headers, src_f, &ddev, &logdev, &rtdev);
>  
>  	close_device(&ddev);
>  	close_device(&logdev);
> +	close_device(&rtdev);
>  
>  	if (src_f != stdin)
>  		fclose(src_f);
> 

-- 
- Andrey

