Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521AB226CF0
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 18:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744741393; cv=none; b=S8HBIkori7hGvhipt89SmufWqQwONd8+qHMPvSOaAG0wwbWY0GiH0Tt3IiWAdU++ITAZu9eO7asT65zwKHs8ZdWUSRm20ibZj9JUo8mGhSUR0EHJ2ErU6xkNqv5UtCGZQpvC5UFI+rM77b4WH0TXVMzzM3Ez47+GaCGI+ocmz28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744741393; c=relaxed/simple;
	bh=V0Ou2OkOM/yfiTtADzH6LoF50O8W/mzI+zhdf3d2nYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VAl20LNt8s6Zbg26FQ7y/HjPdH/112fxBWf2Z8enLJMxEYNdwkG/5Yxw2iRGUxsOQHPsLWJ+yClQDXRVw8cnEXeI+VShGwlsIoujBrWifE2V9NSF36A0Ek+B6NIybeFu4Q9lgXMC3ttjAiUe/fKgDh2lHKtR2FP8v9wfQgj7/L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d1ths0uP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d1ths0uP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744741389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=04NGhkPb/wzM/cnaZe4owo44UhgC65AEXq1pdCNuc+0=;
	b=d1ths0uP43xe8s3FwMiHD/upykM95vdGXKBlQxxZZdPmiWpxyTLBp4mMo4W/V+jaG7Wi33
	7fRPDIEhk0csCyWU3MXey9c87mBusLXWJs20D6S2671pKbg2eBGxv1x47b+AK0Hy1MSIuo
	WA/oX5L4AkdLnXrcdjFDU42zKbu9sms=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-R-aK7NOyMEGYewNHtu5t9A-1; Tue, 15 Apr 2025 14:23:07 -0400
X-MC-Unique: R-aK7NOyMEGYewNHtu5t9A-1
X-Mimecast-MFC-AGG-ID: R-aK7NOyMEGYewNHtu5t9A_1744741387
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-85db3356bafso1219772339f.3
        for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 11:23:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744741387; x=1745346187;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=04NGhkPb/wzM/cnaZe4owo44UhgC65AEXq1pdCNuc+0=;
        b=Pg6kuSGZYWDSDCKbYyni/dRe6th8sIfMu4Dv3VXwJPHo4pWvIv7Exj/QHhFT1IxStE
         a0LkwUdN+uKlwjmFIXcgF7YgoggR4HKXs5IaggrLR9mTbLjRSYtsygPBFTYGwd0GOZKi
         TxNaJd1yXvqEl4njgVPNLt5DMTTtmtrDiTUtHHopeEz4aeqbla3bJXkJWHWxIZDX5Gxh
         P6PMQ1f4cbmdbPqi0f0SpvccStYyOvX2vxBcmqHtd3SbHnNEk13pUF9RhB465r2wB5oR
         +30EI1koGzgZInNC0bGEH3dBpKN1smm8iOg51I2bQV8J4fuunAMi6tjFfAQesXD2yrb6
         7kYg==
X-Gm-Message-State: AOJu0YxzGzYEyAk5PDExfVqkbGHYG7jAGM46fHoL/jziH9VWuBmZjqhz
	bZpdDwJ2SenVDQjnd9JgWjrBUVRcY3hO+AnaIy+pbi0UUfzzlamUfntcWNttWVUMXidG2zM05QL
	GgF3vaAl/qtNnOFKXoGF8S3b71R7TcSIsk+Mr6YmYZ/d10/0EPtEXpPSvpA==
X-Gm-Gg: ASbGncvLKPQ6jtofn2U74O2wdN3LdieJVOgIo4Q3YOzkpHdjXw8Usq+JjkNVUa30wsv
	2+nNHSkk+CNRELH7K209zr/yBjQZcxL0TvYZZhBY14wmOyyMgJ38Ro8Ht1qaZuTifI2267IBJmI
	PtM/FONmmrXeeTAcDt05B+QJRTSSyB5ieSy2tU532xBQt4CkdTOPwIoU96FuQGQhayswgEr+HjL
	SGj/VlJOx+LEtP4NnvDqA03xplsVFNn8ecWbq+IHkTtzImEUrsGm2qLS8wcvxcWDmQpO8ea5s3G
	Innjv6BBbqTafUXjShaVybEUpINkBY/LUvvMNgmXWhm9
X-Received: by 2002:a05:6e02:1aa4:b0:3d4:70ab:f96f with SMTP id e9e14a558f8ab-3d8124cf722mr3833025ab.8.1744741386866;
        Tue, 15 Apr 2025 11:23:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtAEZ6EqBfZZ1hLQ37Xn2IAIVO83k6K/y7daQt3QLBq87iXqXABgOSzsOwPgfwnUuC32k50A==
X-Received: by 2002:a05:6e02:1aa4:b0:3d4:70ab:f96f with SMTP id e9e14a558f8ab-3d8124cf722mr3832885ab.8.1744741386577;
        Tue, 15 Apr 2025 11:23:06 -0700 (PDT)
Received: from redhat.com (72-50-215-160.fttp.usinternet.com. [72.50.215.160])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d7dc5827ecsm33333105ab.51.2025.04.15.11.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 11:23:05 -0700 (PDT)
Date: Tue, 15 Apr 2025 13:23:04 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "user.mail" <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org, djwong@kernel.org
Subject: Re: [PATCH] xfs_repair: Bump link count if longform_dir2_rebuild
 yields shortform dir
Message-ID: <Z_6kCAHGNoSnPc27@redhat.com>
References: <20250415180923.264941-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415180923.264941-1-sandeen@redhat.com>

On Tue, Apr 15, 2025 at 01:09:23PM -0500, user.mail wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> If longform_dir2_rebuild() has so few entries in *hashtab that it results
> in a short form directory, bump the link count manually as shortform
> directories have no explicit "." entry.
> 
> Without this, repair will end with i.e.:
> 
> resetting inode 131 nlinks from 2 to 1
> 
> in this case, because it thinks this directory inode only has 1 link
> discovered, and then a 2nd repair will fix it:
> 
> resetting inode 131 nlinks from 1 to 2
> 
> because shortform_dir2_entry_check() explicitly adds the extra ref when
> the (newly-created)shortform directory is checked:
> 
>         /*
>          * no '.' entry in shortform dirs, just bump up ref count by 1
>          * '..' was already (or will be) accounted for and checked when
>          * the directory is reached or will be taken care of when the
>          * directory is moved to orphanage.
>          */
>         add_inode_ref(current_irec, current_ino_offset);
> 
> Avoid this by adding the extra ref if we convert from longform to
> shortform.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: user.mail <sandeen@redhat.com>
> ---

I was about to send a v3 of my patch to handle this (fix link counts
update...) based on djwong's review. This looks cleaner. Thanks!

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>


>  repair/phase6.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index dbc090a5..8804278a 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1392,6 +1392,13 @@ _("name create failed in ino %" PRIu64 " (%d)\n"), ino, error);
>  _("name create failed (%d) during rebuild\n"), error);
>  	}
>  
> +	/*
> +	 * If we added too few entries to retain longform, add the extra
> +	 * ref for . as this is now a shortform directory.
> +	 */
> +	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL)
> +		add_inode_ref(irec, ino_offset);
> +
>  	return;
>  
>  out_bmap_cancel:
> -- 
> 2.49.0
> 

