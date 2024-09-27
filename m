Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB09A80034
	for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 14:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727446683; cv=none; b=u8lxVXND/cghi8xdsf3lWHkScKZ5wyJADfq7bhk3TAG8d2dOQOo3dsedUMXgHD/R2erZtni/JlTb16NBrpwdJNz95QAyVXmzjsGey7zuzEYBydTj3ylmxvBb+Qlvc3fwzjiGBbnAoU0emA+wXv48kgttNH4HE8GvL+9spKaozoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727446683; c=relaxed/simple;
	bh=M7VV9lVwVRozdGEecyn+Z61KNcOE4t+84jF3+ebCTzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G8YmU3TmNQSJEwMfrL7m+MHzlGlBV77PVmPqRg3VerqQgyLunyR28SDzlSvr+HSBKm+Ug+l5YgcRUcGwOJlo52hLquiwHReH5QQau+ufdXjouTZWRMWPZ5R2xeZGbXxEpYsn4RgSJWpxJNSJ+B6ziN8Mp7CXQYuKgB7zV+byyuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Egq2wAvk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Egq2wAvk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727446680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vtSq7rJJHzzMOS68cfX6ZtqANxI01Yn3PgT0bCb2a+Q=;
	b=Egq2wAvkHwknZPw30hOAahZx7A41/v0RhQcqwzvHtBzH1iGyXwaxUPWSCxOC8rLo+LmlLw
	N+lsKWnxrjjIjoJZj61GKYI/lQ50KYs9ibAc96iW0aJ0IVr64KXXuIKLK81ytiks2l9YeK
	hkW3E5bgtdnqY3jx1UgkRklGFUxLV1s=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-TzLIKfmrOz-xh_hXhpYK6A-1; Fri, 27 Sep 2024 10:17:59 -0400
X-MC-Unique: TzLIKfmrOz-xh_hXhpYK6A-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2f7538dc9d7so19069691fa.1
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 07:17:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727446678; x=1728051478;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vtSq7rJJHzzMOS68cfX6ZtqANxI01Yn3PgT0bCb2a+Q=;
        b=CkNwhHjiF2GNdRwRPZb5PEiikHiZNDuUoWAINsToiUmdfwq5ilxIKfM3H+E/IchZKs
         CuBYHxcUmqalLByJk+yFqFxpOaIl1Y7ma+KDrasQvb9w9KTOUacW50IVzpZWrLdQJagX
         B6m/7Th81GmSFvfAyqmDFB8mY+ybfbPlMl7ADNPYOJK08tuNmx++ZlkZM8wl5oJYCmTk
         vuVfP5CwX3CIN9jpaSjVAHGGlvEKgPWKo6TMVbOxUVy4Nqwzt/nt8BFHwRgZiJzdVckc
         J4M1Z2BkP19nAoTO9SyX/Ev08zRwXdYoG293cIBoL477wnWwG/+ce9JfZbjVDoKQwZ1q
         ALYQ==
X-Gm-Message-State: AOJu0YzfVWYIKcj6eRGv5YuX5fGI/ByOmix3WC6N83Dm+MS7JvN65V05
	hMRUxIrYfWjjmtl7IZ/pA+y02MFi29Nr/n+8pAd+x20wi+Qh6vN7+RwO02ogjyROLKCEev+LD3y
	R6DZ3pInj7jcUF8juZ+8MATFGfnpOc8pA60oj3E9/iwWvsNC1Con04G8E
X-Received: by 2002:a05:651c:2226:b0:2f7:5818:a234 with SMTP id 38308e7fff4ca-2f9d3e55d4fmr23423981fa.19.1727446677951;
        Fri, 27 Sep 2024 07:17:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7szO+VdHjg6WylQjskoAW6XFE+VFtqs+rcdQaFtK+EVnRh7CDmQrkxPG8f64jXcKrkbClOA==
X-Received: by 2002:a05:651c:2226:b0:2f7:5818:a234 with SMTP id 38308e7fff4ca-2f9d3e55d4fmr23423751fa.19.1727446677416;
        Fri, 27 Sep 2024 07:17:57 -0700 (PDT)
Received: from thinky (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f57de10e8sm28088245e9.13.2024.09.27.07.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 07:17:57 -0700 (PDT)
Date: Fri, 27 Sep 2024 16:17:56 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: Re: [PATCH 2/2] xfsprogs: update gitignore
Message-ID: <xsfgvilxt524gct2jrjplcbu2irjjoapwmmy4qj6bnzwyq3lys@hfp5d3hkkou7>
References: <20240927134142.200642-2-aalbersh@redhat.com>
 <20240927134142.200642-4-aalbersh@redhat.com>
 <65wlm36uziggutarpnmmy3uxbnrwdrv6bf3co54gjipbwxp2ej@r2sbabrc5m23>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65wlm36uziggutarpnmmy3uxbnrwdrv6bf3co54gjipbwxp2ej@r2sbabrc5m23>

On 2024-09-27 16:09:20, Carlos Maiolino wrote:
> On Fri, Sep 27, 2024 at 03:41:43PM GMT, Andrey Albershteyn wrote:
> > Building xfsprogs seems to produce many build artifacts which are
> > not tracked by git. Ignore them.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  .gitignore | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/.gitignore b/.gitignore
> > index fd131b6fde52..26a7339add42 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -33,6 +33,7 @@
> >  /config.status
> >  /config.sub
> >  /configure
> > +/configure~
> 
> This smells like your vim configuration, not the make system.

opsie, you're right

Andrey

> 
> Carlos
> 
> >  
> >  # libtool
> >  /libtool
> > @@ -73,9 +74,20 @@ cscope.*
> >  /scrub/xfs_scrub_all
> >  /scrub/xfs_scrub_all.cron
> >  /scrub/xfs_scrub_all.service
> > +/scrub/xfs_scrub_all_fail.service
> > +/scrub/xfs_scrub_fail
> >  /scrub/xfs_scrub_fail@.service
> > +/scrub/xfs_scrub_media@.service
> > +/scrub/xfs_scrub_media_fail@.service
> >  
> >  # generated crc files
> > +/libxfs/crc32selftest
> > +/libxfs/crc32table.h
> > +/libxfs/gen_crc32table
> >  /libfrog/crc32selftest
> >  /libfrog/crc32table.h
> >  /libfrog/gen_crc32table
> > +
> > +# docs
> > +/man/man8/mkfs.xfs.8
> > +/man/man8/xfs_scrub_all.8
> > -- 
> > 2.44.1
> > 
> > 
> 

-- 
- Andrey

