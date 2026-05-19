Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C259A1C3BFC
	for <linux-xfs@vger.kernel.org>; Tue, 19 May 2026 07:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779177380; cv=none; b=KIEB4EUU7X/3J0pAhsllTrS6TIU7wQFr0wxXegCVBrNOseZx7w6BnwbcyDqgXMxgpqp/f3tIGgc8WxZhb0KqTsi2aXyDdk4m+/HGpWjHAudczzhliXLc/8muZY1bnxuy2Qa+jutC+GXshUate03paOXVsa7TSKbTloR5LkHEtgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779177380; c=relaxed/simple;
	bh=FENFk8lf6EWOH6tqV1VhqUT7mHxr2xYkXtQHvTISnkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MLeesZGok3aUertCXJaLw+Y/uwRN4DTO5BKYdLjRu7SlKUgBRDLbHr7XxJLKo0smkW0p+HOaZB4P2N7Q9o/SA7Uqwr8lquoOR47JRj6CPvtDmYvDJFjyPS6GhNd6BprLoOkEHnb1n+ybmp4JH40pdGBUP4U4rFJGjZdeEOQBdf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PMHQcyIk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=d3qIt28F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PMHQcyIk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="d3qIt28F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779177377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hI2xgPVnZNihjPBipnce+JZwWbCgNou/RucNF4x4FEk=;
	b=PMHQcyIkjgwmi9RzQcAvx2dfOD+yk/umZhqUptWZc18CkjcLHnqgDhhag+KiLns6BFpqoi
	S78dzYwzjyue/gnRQOmQdqf+fajxBzqkSJw01OweJ+bpYx2dyMo8+egpqsDjtg+lDclXEr
	IdPMgTP/l7atkoynGdb9ty4DFIsbvuo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-y2TIIOWMNxizfmvqoRVr3w-1; Tue, 19 May 2026 03:56:16 -0400
X-MC-Unique: y2TIIOWMNxizfmvqoRVr3w-1
X-Mimecast-MFC-AGG-ID: y2TIIOWMNxizfmvqoRVr3w_1779177375
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48eb0da933fso26159895e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2026 00:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1779177375; x=1779782175; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hI2xgPVnZNihjPBipnce+JZwWbCgNou/RucNF4x4FEk=;
        b=d3qIt28F1okCChN4XjG0/UHXuLKplPS50dzk/wn2ffJCtREgGxyK0wGk77ye0mnd2D
         x7TpF0e8WgzN0W/+CEQ4l6S5Jp9GF0/GzieW3F+EqxBnthCmOqVzDtu47Y+vpc2oz99b
         LNQP3r7zB0ttsk2VkZEOJcIttMsttgPjBGT+y+K9gwbmIJxOPxcfGNCc9E4oNbsDnxDm
         jC4oyhOhQHPXXQ7DtyX6IF2i6IpOEbAhOUgaSaIfD1VSNTELIF85N8K3WFIkBUn3krDJ
         JDE4AQTPJA1ovAmwAq8IFTBRP92dzy0HK2QDovcL8RqugZZuYmKOh1I83t2P1rY4nyvt
         2xXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779177375; x=1779782175;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hI2xgPVnZNihjPBipnce+JZwWbCgNou/RucNF4x4FEk=;
        b=I6vCw3TpOD6Vojj+q2qkHYk9yFJkhwSlk5dl9LSNiC6OHhdSqZoJ7EcIVg/UrL8OHJ
         d6nr1ly+7tglHcpgJtMYRn3i9XpnoB04x2bbhbvm9cWuErBxwbanYhwCGRDniW3jQkuC
         SmF9NjHxIUSNdU8yX0SJ8mGe7ZFOpE6uYRj7CrENAKDCp0TKJe3M8Z4mnKQng6iBWdP9
         aUu3/RuNvdf5VaW5j1/CsGNwKYGi5XL/G1T92T2ihI9opzukdptFmlLqLkbXDb5Gw+BU
         Y1ACXeAiUiH4zGLe1TsXgrEL4CUBTENUorYiUQOh5mniRX4kWZrDIceFk1GZzxIIQ1mb
         +4pA==
X-Gm-Message-State: AOJu0YxVdM/3OOSgP16eKw6FqbOCrhPoN4F9MJlArjjB9KAsr3aJ7OuU
	uaYuZ1t5pAFWfD1FgqGEzt8c1xlG1PrWjX9F0oKcAA10kxU1bgkL3ySYbiJWrw2vFqUunC9dbJk
	/uKNHtvgarOL/8Ke7/LnmFEmIRuwJvsVwBYUxH9Rt5zlHDIu1Zf048PfTikwp
X-Gm-Gg: Acq92OGsy3KeCzVgr985gA4MBkq09Pm8EUY9OQc4Mhp+pgyswRpbuNjlpUTr+fHUoxN
	uM3ZmfQaP8Sik0YgkdJOcjR+QhVeu6gJrx0nV2oFJdpbKvkrnaF3s6pQkFd75DVdTZwe2RwXPeT
	NpagKsLl+lwrcQdyv55hHuoLSmyikjTS3Uw41PViOQCnNINiH1GMXuTSgYChZm74YrCZuK2h/pV
	ZwmF94if13w9rZkZC99C3vVSJBcuPYGh2GG/N/VlAoSMR4smxI+dm8w/uUsKByjLbXwkLsqahe8
	IAmiei52bYlqVuQMEAozPUYIg1y0PgyBuLhbAD/EUv7BO9h6mVzyGagAJGuEmOrbx5kfbD+NX7L
	LIaz2pq6kn+eyoVI1Un8lYbTFKSzqSLb5oNa0sTxOY+/yVxPUODWpuJqp9DZa5nDR8g==
X-Received: by 2002:a05:600c:8b01:b0:48a:53ea:13eb with SMTP id 5b1f17b1804b1-48ff3345725mr219787865e9.5.1779177374880;
        Tue, 19 May 2026 00:56:14 -0700 (PDT)
X-Received: by 2002:a05:600c:8b01:b0:48a:53ea:13eb with SMTP id 5b1f17b1804b1-48ff3345725mr219787225e9.5.1779177374264;
        Tue, 19 May 2026 00:56:14 -0700 (PDT)
Received: from thinky (178-221-68-189.dynamic.isp.telekom.rs. [178.221.68.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0a178adsm46008212f8f.18.2026.05.19.00.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 00:56:13 -0700 (PDT)
Date: Tue, 19 May 2026 09:56:13 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, ailiop@suse.com
Subject: Re: [PATCH] xfs_healer: fix missing HAVE_LISTMOUNT flag and stubs
Message-ID: <lv2xj4az73algsagwgglizbdouactg64xsu7z5qruwhgzu4usx@sievot5skos5>
References: <20260519041805.GF9555@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519041805.GF9555@frogsfrogsfrogs>

On 2026-05-18 21:18:05, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs/666 regressed with a broken xfs_healer_start that can't actually
> walk the mount namespace with listmount and statmount.  The new stubs
> are wrapped with HAVE_LISTMOUNT, but this cflag is not added in healer/
> Makefile even if the build system has HAVE_LISTMOUNT set.
> 
> Also fix the stubs to return error correctly -- the wrappers follow C
> library behavior.
> 
> Fixes: b30356f25335eb ("libfrog: add fallback stubs for libfrog_statmount and fstatmount")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  libfrog/statmount.h |    6 ++++--
>  healer/Makefile     |    4 ++++
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/libfrog/statmount.h b/libfrog/statmount.h
> index 13aaad3a99dca1..b12e6d52ea5749 100644
> --- a/libfrog/statmount.h
> +++ b/libfrog/statmount.h
> @@ -107,12 +107,14 @@ int libfrog_fstatmount(int fd, uint64_t statmount_flags,
>  static inline int libfrog_statmount(uint64_t mnt_id, int mnt_ns_fd, uint64_t statmount_flags,
>  		struct statmount *smbuf, size_t smbuf_size)
>  {
> -	return -ENOSYS;
> +	errno = ENOSYS;
> +	return -1;
>  }
>  static inline int libfrog_fstatmount(int fd, uint64_t statmount_flags,
>  		struct statmount *smbuf, size_t smbuf_size)
>  {
> -	return -ENOSYS;
> +	errno = ENOSYS;
> +	return -1;
>  }
>  #endif
>  
> diff --git a/healer/Makefile b/healer/Makefile
> index 19255f6537ae9c..b35e310cf0a220 100644
> --- a/healer/Makefile
> +++ b/healer/Makefile
> @@ -21,6 +21,10 @@ xfs_healer.h
>  
>  CFLAGS+=-DXFS_SCRUB_SVCNAME=\"$(XFS_SCRUB_SVCNAME)\"
>  
> +ifeq ($(HAVE_LISTMOUNT),yes)
> +CFLAGS += -DHAVE_LISTMOUNT
> +endif
> +
>  LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBURCU) $(LIBPTHREAD)
>  LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG)
>  LLDFLAGS = -static
> 


Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

