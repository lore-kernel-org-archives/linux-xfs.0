Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76971B87C0
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 18:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764613463; cv=none; b=MzXWA6XCQB2D1s3K+2NhZlFzvK5Fbet34OJ8Qm23lqxeFy6b3bXfjPEoB0iiq9UqraJw9BWJgJ7SlrnDR/g14+w5gVGC+i3OWM0LFBfffH8CTfGsO2K321as3hcjSN5pvUWFjwDJYRd/TbFvRcAMa2+gkcPRwJNlUFJHqSv3nQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764613463; c=relaxed/simple;
	bh=O+1606zwGWf6k1D+6XczHn84SlzHEE154y9Q7s4N1L0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fcArKeie/g+41dU0jWANtXGtLQDvVa0uS5dfDZ5sFc+RQ++IOZ91FYysSa7uxyRNhnAmvdr28y139Wl8AFvtQCuaDgnhyM3UL90M1f+1XQ/s9aUgkfiLsDkHeIixdOLLK+42uXYZYh6HORL9r6sAHnYXL9CInJGzFISwrbJrf68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xe12GtKR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bBCrLkKF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xe12GtKR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bBCrLkKF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764613460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f6+Fp6BluZhg1ci9hJfDKKFxU18Bh2eEtKGpESFzzGc=;
	b=Xe12GtKRtrOh2vX7k1H3SxbzBoeJciUZOwSfNVAyymDZXExyiu8tIbBi5K0h4w7LarLa7b
	48pLu4fHlLL4M81BMNpXHZjSw87onwaYIZkefz8+INcAhkUPo3Es/UHYHS4k5KFxGTUf5Z
	lsCX7ocCUC98/kLUnE5FRh6mYVVqGDQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-G0Ud9XIqPs2qEt0mL-c3jA-1; Mon, 01 Dec 2025 13:24:19 -0500
X-MC-Unique: G0Ud9XIqPs2qEt0mL-c3jA-1
X-Mimecast-MFC-AGG-ID: G0Ud9XIqPs2qEt0mL-c3jA_1764613458
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47921784b97so9043455e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 01 Dec 2025 10:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764613457; x=1765218257; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f6+Fp6BluZhg1ci9hJfDKKFxU18Bh2eEtKGpESFzzGc=;
        b=bBCrLkKFpWGZrqbGGjmq7mUc0Elloecu4wGPlkzk3MmTaFTgZVEEZ0mSc42adFe3IB
         DFlSMFXKozm9nUoM6GRDstx6OfcG4Ug5kkVDMxrc+XFUOJPFpZImkewcol97rRAkYegR
         mqEp8KyioGUbNf+fRa1hyT1S8GrOdNeaU+4o2hslMczIsGlFE+2QolR4eRAB0EV6tUMx
         WTQwuIX5ITb/A77A82yCe61Jj6P7FQZrhZr3SzkT+7FBfMcATPQmMzbynkPBI1hxCmGk
         rmdez0YyWxHRm7roymwvJCO4eT7H5atPikeD4fJUfvf/1QZaLfDnlsHD45j/UrWmEcDh
         tt2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764613457; x=1765218257;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f6+Fp6BluZhg1ci9hJfDKKFxU18Bh2eEtKGpESFzzGc=;
        b=TdUul/2r25gOv34n87/BG7fJoVOPVkXrgcD3ZZ/62D1lUcnT+u1XYxu/iWPgR83we/
         OmWOpc8JurA3orHlSUoO2M5QEwYBbMI+GCcOKCV8nbia3/E1ENdETU+pnCcWlCgfIyQA
         hi3uu1dV0DhTOPjiAMfA4VEKgpLnWqoOXPoprtR9STPy3j8RsZd982hRAzff5Bk1jB+9
         9gCkBUprLBSSt+GL619OVT7eMTQdoxO0E9wy4icrRQK+YRz+t5BeXLWv5KUcNUHy5vvn
         gwZrmR6ujlJnVk586rGhKE3sOghkLbROEAxA1WflIBpJCDgV8UatsBpAcGsU/De+A3xO
         8qeg==
X-Forwarded-Encrypted: i=1; AJvYcCVAthO829ZpocMhHXDg428xz2jL2ruby57nAFRzRAJSqxS4vaqw1vj5F7AyqHAr0VPVpw2T/K9C45A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeIudsoIzw+JUGPJN0kXbYdchH8kkuZCFp72uqnMneKTrjIkVz
	aFx1khNg4A98TzpE9CoXr0AYMWHy+kLBZhcn0M4+ByEzjPMCVMInLaQt7lT+ehyF8YoxIVFZK56
	mPrOQ5+EYhKy+mMlx6mLzXE9vkH9NUorqqfP8az4vZt9SksWLIsTDrroRxs5VNdkF8oGW
X-Gm-Gg: ASbGnctkhXORsKI6HUOsg+auU0qCyr9FYvuJNzdTP+16EHvWaG0ToqYiTmPz1qxFChj
	5jX0uWvwmQjSkLxwoowPT+RBsG3WolRw2FlldHDTbP/ee4iR0OJYRzrlLS0yjiWSG3NZJE67inx
	Smfb/g13COwXh7E8TF2JjwE93DR8+shklpvYaJa+6g+99plf5tJgpFWdBTaUkOKuYfPHYzWYQnJ
	SvnPz/W57NtrLJwM/7WGYweEISII4U6TOssJSORK+5uOWlFYlGfZ33cRx5SoARuKF1Ws60JdYJ4
	AnQOuk1rEMkiglSSTMHN6wOW+mO/8VGhhccolY+KHdNbyNKbk+sG64MnuIHuswiFpXUiAztOsKs
	=
X-Received: by 2002:a05:600c:4f46:b0:477:63a4:88fe with SMTP id 5b1f17b1804b1-477c1103099mr404725465e9.2.1764613457572;
        Mon, 01 Dec 2025 10:24:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGIkicc7vnbUQBj+A8HatNjw81LVpZ7KE5Qrc/+eB2NDVcB7WYg5jNwv1VynwITjSAUFARquA==
X-Received: by 2002:a05:600c:4f46:b0:477:63a4:88fe with SMTP id 5b1f17b1804b1-477c1103099mr404725155e9.2.1764613457092;
        Mon, 01 Dec 2025 10:24:17 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4791164d365sm251234205e9.12.2025.12.01.10.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 10:24:16 -0800 (PST)
Date: Mon, 1 Dec 2025 19:23:45 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/25] logprint: cleanup xlog_print_trans_inode_core
Message-ID: <3qqhnocgpycj3dkni4l45myxx3wa5ygzrdzk4kuh6oui5zpg4x@4o7xxc237nt7>
References: <20251128063007.1495036-1-hch@lst.de>
 <20251128063007.1495036-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128063007.1495036-11-hch@lst.de>

On 2025-11-28 07:29:47, Christoph Hellwig wrote:
> Re-indent and drop typedefs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  logprint/log_misc.c | 69 +++++++++++++++++++++++++++------------------
>  1 file changed, 41 insertions(+), 28 deletions(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index 227a0c84644f..a3aa4a323193 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -531,39 +531,52 @@ static void
>  xlog_print_trans_inode_core(
>  	struct xfs_log_dinode	*ip)
>  {
> -    xfs_extnum_t		nextents;
> -
> -    printf(_("INODE CORE\n"));
> -    printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
> -	   ip->di_magic, ip->di_mode, (int)ip->di_version,
> -	   (int)ip->di_format);
> -    printf(_("nlink %" PRIu32 " uid %d gid %d\n"),
> -	   ip->di_nlink, ip->di_uid, ip->di_gid);
> -    printf(_("atime 0x%llx mtime 0x%llx ctime 0x%llx\n"),
> +	xfs_extnum_t		nextents;

Still here? I don't see any other typedefs

> +
> +	printf(_("INODE CORE\n"));
> +	printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
> +		ip->di_magic,
> +		ip->di_mode,
> +		(int)ip->di_version,
> +		(int)ip->di_format);
> +	printf(_("nlink %" PRIu32 " uid %d gid %d\n"),
> +		ip->di_nlink,
> +		ip->di_uid,
> +		ip->di_gid);
> +	printf(_("atime 0x%llx mtime 0x%llx ctime 0x%llx\n"),
>  		xlog_extract_dinode_ts(ip->di_atime),
>  		xlog_extract_dinode_ts(ip->di_mtime),
>  		xlog_extract_dinode_ts(ip->di_ctime));
>  
> -    if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
> -	nextents = ip->di_big_nextents;
> -    else
> -	nextents = ip->di_nextents;
> -    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%llx\n"),
> -	   (unsigned long long)ip->di_size, (unsigned long long)ip->di_nblocks,
> -	   ip->di_extsize, (unsigned long long)nextents);
> +	if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
> +		nextents = ip->di_big_nextents;
> +	else
> +		nextents = ip->di_nextents;
> +	printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%llx\n"),
> +		(unsigned long long)ip->di_size,
> +		(unsigned long long)ip->di_nblocks,
> +		ip->di_extsize,
> +		(unsigned long long)nextents);
> +
> +	if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
> +		nextents = ip->di_big_anextents;
> +	else
> +		nextents = ip->di_anextents;
> +	printf(_("naextents 0x%llx forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
> +		(unsigned long long)nextents,
> +		(int)ip->di_forkoff,
> +		ip->di_dmevmask,
> +		ip->di_dmstate);
> +	printf(_("flags 0x%x gen 0x%x\n"),
> +		ip->di_flags,
> +		ip->di_gen);
> +
> +	if (ip->di_version < 3)
> +		return;
>  
> -    if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
> -	nextents = ip->di_big_anextents;
> -    else
> -	nextents = ip->di_anextents;
> -    printf(_("naextents 0x%llx forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
> -	   (unsigned long long)nextents, (int)ip->di_forkoff, ip->di_dmevmask, ip->di_dmstate);
> -    printf(_("flags 0x%x gen 0x%x\n"),
> -	   ip->di_flags, ip->di_gen);
> -    if (ip->di_version == 3) {
> -        printf(_("flags2 0x%llx cowextsize 0x%x\n"),
> -            (unsigned long long)ip->di_flags2, ip->di_cowextsize);
> -    }
> +	printf(_("flags2 0x%llx cowextsize 0x%x\n"),
> +		(unsigned long long)ip->di_flags2,
> +		ip->di_cowextsize);
>  }
>  
>  static int
> -- 
> 2.47.3
> 

-- 
- Andrey

