Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7884229BD8E
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 17:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754935047; cv=none; b=uYFiuaOhfD5BlHhO7Jc1IQ8NHjPlKM3TQsNabN+meBjaDknMuTRBgIjKufYd9ZvR0wReeOs6A/u1O671pTWS1JDQzCAm1yirBzj45BEatMSe8LYyIsT7lMOui2umlFWgnkRaLAz0tSDlm7MGUvt17Uu3rhpTwKbIXtFmSGCr3mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754935047; c=relaxed/simple;
	bh=7PT3ywZpQUdou1fTrKD67WlDrhKHcvqoNviK5JM1Xtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TRjNMILAXsjMJMovoLMBX0EYTm+hj1q4P9Qloy75WXZ2wbzPZ0PiLbCC3cnoWTttXN0c8cdwhbvIexqRu53AWoQ9QzuiunsIhe5mhB8es4maGdf1XsRGNVmrhxXVK11rnLj/y78dSgjKsiFDa2Ph8kUzCJKW0bySdGdu/m4SlN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L8/JanDZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L8/JanDZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754935044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pFq748FVQYugtXuePIHSaQf+vN4VlTVVmOe1SB0+wlY=;
	b=L8/JanDZNQP4+XBQk4SkPEkAbD/2/kGvGC6rNO0bUdW1g2HHSjcJZPVcrLVNvY6myE7vy4
	dTRyauPzeZd6Dt7+Xd73R5ALiB+0z1Yt62u2YIQ90WsOCPe971EcRoUTd7e48XXCQZWBt1
	NSUZWiuRW/HAq9dtDHh3Ds4KEfXdR7g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-3noF1q0gPw2loFWgzoQRkA-1; Mon, 11 Aug 2025 13:57:22 -0400
X-MC-Unique: 3noF1q0gPw2loFWgzoQRkA-1
X-Mimecast-MFC-AGG-ID: 3noF1q0gPw2loFWgzoQRkA_1754935042
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-458b9ded499so30326305e9.1
        for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 10:57:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754935041; x=1755539841;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFq748FVQYugtXuePIHSaQf+vN4VlTVVmOe1SB0+wlY=;
        b=NFEMVXnksw6QB9P633XHPap8SjxMdWKzf30BMnDxGgKgFeAtsZqtx8rFRpzjKf+6do
         l0bPLJHrArol6iM7g5yprLROCSKX6dEIjZSyDwMo0brXqP8hYXDKH77ZKf74tJ4oDKaN
         EEOOQWWGePNkGWO+7hLa+0SrfudoI/2nk0FykY4RGn5ivm1sEIzwIhXVv6r32nFvOFeJ
         7Qw7TuzTMbNiR9219sh6dFl5So28FEp08OwM26ClN2K8FpK5gRuVBdrE9G3oU5eWqPNh
         zvYGMEiPGtQfQvMiVpe7MIpMPoOlswxliAnG4Rvfr6AMSm6pA0isI9VfQYoHSXIGvd1r
         Hy4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVFpZFZcr0CBQMd6qcdJu5DtImAgSsOWkYcEbRxv+oaD93nLm56wT4qn7TKDPF41tNcFKls5LarkPo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx62rtd3QEg/F1G7CIpEM3oz69/AQW2OWkqRhIImt0eouUX0J+d
	a0iKdvOcWmm13+GtTP1SSEkc2gFoej5D/2BipUhr6WWTI79rnBB6T/AQZvqKja/YADOa7WJmzbO
	RcMaWPE9UsiC2Xgbkb1xX+dRo3fw6SGl1l4R8Uq5IUbGcnmuzDSOHxogiuiGZ
X-Gm-Gg: ASbGncusiG/Fn1aA/u1NgCWDVmDKnnct/Ienw66HV54eaILppRI3pOEpnLYUF47BCQI
	FOxj1A8JrKjjcIpeOqoqWxzSN2xKy3tdqnwxIAikR4dweQ5PwBRVerDH9PPRlxk8M0UJv/pmZGb
	vYtRaexAW0KuVsY2UMlkylT1QwOSNb5RNOa9zufMGUBfYeC5mfgxcD1bc3ItIRah0T4TaRREYBO
	/04A31E21ZipvHW8WJP1xtivnPPP/i3tnBu1DtZ++w4IFEvFxwSU/hRT9bPcDTmMk2SOwyxhWeD
	QGrNPaV9UQKVGoF3qSGiKD61bVMrcZb+WloJgYsJD/CL9d3+jhdOAIhSLdk=
X-Received: by 2002:a05:600c:83cf:b0:459:e200:67e0 with SMTP id 5b1f17b1804b1-45a11053889mr1854415e9.10.1754935041588;
        Mon, 11 Aug 2025 10:57:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6Bp28fsaCBq/pmqQU96sXCBYtR1EmmK/bt+iFcnj9SyZ8knO+oYvXFRD+Wi+fOyzaJ0EsEQ==
X-Received: by 2002:a05:600c:83cf:b0:459:e200:67e0 with SMTP id 5b1f17b1804b1-45a11053889mr1854185e9.10.1754935041168;
        Mon, 11 Aug 2025 10:57:21 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5b84674sm283897035e9.30.2025.08.11.10.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 10:57:20 -0700 (PDT)
Date: Mon, 11 Aug 2025 19:57:20 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_io: make ls/chattr work with special files
Message-ID: <4566ibfc2eljlicxwgdyp3q2m4o72vm3mxe6epg7e7grbkvqv4@564comcelktz>
References: <20250808-xattrat-syscall-v1-0-48567c29e45c@kernel.org>
 <20250808-xattrat-syscall-v1-3-48567c29e45c@kernel.org>
 <20250811151217.GC7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811151217.GC7965@frogsfrogsfrogs>

On 2025-08-11 08:12:17, Darrick J. Wong wrote:
> On Fri, Aug 08, 2025 at 09:30:18PM +0200, Andrey Albershteyn wrote:
> > From: Andrey Albershteyn <aalbersh@redhat.com>
> > 
> > With new file_getattr/file_setattr syscalls we can now list/change file
> > attributes on special files instead for ignoring them.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  io/attr.c | 130 ++++++++++++++++++++++++++++++++++++--------------------------
> >  1 file changed, 75 insertions(+), 55 deletions(-)
> > 
> > diff --git a/io/attr.c b/io/attr.c
> > index fd82a2e73801..1cce602074f4 100644
> > --- a/io/attr.c
> > +++ b/io/attr.c
> > @@ -8,6 +8,7 @@
> >  #include "input.h"
> >  #include "init.h"
> >  #include "io.h"
> > +#include "libfrog/file_attr.h"
> >  
> >  static cmdinfo_t chattr_cmd;
> >  static cmdinfo_t lsattr_cmd;
> > @@ -156,36 +157,35 @@ lsattr_callback(
> >  	int			status,
> >  	struct FTW		*data)
> >  {
> > -	struct fsxattr		fsx;
> > -	int			fd;
> > +	struct file_attr	fa;
> > +	int			error;
> >  
> >  	if (recurse_dir && !S_ISDIR(stat->st_mode))
> >  		return 0;
> >  
> > -	if ((fd = open(path, O_RDONLY)) == -1) {
> > -		fprintf(stderr, _("%s: cannot open %s: %s\n"),
> > -			progname, path, strerror(errno));
> > -		exitcode = 1;
> > -	} else if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
> > +	error = file_getattr(AT_FDCWD, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
> > +	if (error) {
> >  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> >  			progname, path, strerror(errno));
> >  		exitcode = 1;
> > -	} else
> > -		printxattr(fsx.fsx_xflags, 0, 1, path, 0, 1);
> > +		return 0;
> > +	}
> > +
> > +	printxattr(fa.fa_xflags, 0, 1, path, 0, 1);
> 
> Maybe it's time to rename this printxflags or something that's less
> easily confused with extended attributes...

print_xflags()?

> 
> >  
> > -	if (fd != -1)
> > -		close(fd);
> >  	return 0;
> >  }
> >  
> >  static int
> >  lsattr_f(
> > -	int		argc,
> > -	char		**argv)
> > +	int			argc,
> > +	char			**argv)
> >  {
> > -	struct fsxattr	fsx;
> > -	char		*name = file->name;
> > -	int		c, aflag = 0, vflag = 0;
> > +	struct file_attr	fa;
> > +	char			*name = file->name;
> > +	int			c, aflag = 0, vflag = 0;
> > +	struct stat		st;
> > +	int			error;
> >  
> >  	recurse_all = recurse_dir = 0;
> >  	while ((c = getopt(argc, argv, "DRav")) != EOF) {
> > @@ -211,17 +211,27 @@ lsattr_f(
> >  	if (recurse_all || recurse_dir) {
> >  		nftw(name, lsattr_callback,
> >  			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
> > -	} else if ((xfsctl(name, file->fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
> > +		return 0;
> > +	}
> > +
> > +	error = stat(name, &st);
> > +	if (error)
> > +		return error;
> > +
> > +	error = file_getattr(AT_FDCWD, name, &st, &fa, AT_SYMLINK_NOFOLLOW);
> > +	if (error) {
> >  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> >  			progname, name, strerror(errno));
> >  		exitcode = 1;
> > -	} else {
> > -		printxattr(fsx.fsx_xflags, vflag, !aflag, name, vflag, !aflag);
> > -		if (aflag) {
> > -			fputs("/", stdout);
> > -			printxattr(-1, 0, 1, name, 0, 1);
> > -		}
> > +		return 0;
> >  	}
> > +
> > +	printxattr(fa.fa_xflags, vflag, !aflag, name, vflag, !aflag);
> > +	if (aflag) {
> > +		fputs("/", stdout);
> > +		printxattr(-1, 0, 1, name, 0, 1);
> > +	}
> > +
> >  	return 0;
> >  }
> >  
> > @@ -232,44 +242,43 @@ chattr_callback(
> >  	int			status,
> >  	struct FTW		*data)
> >  {
> > -	struct fsxattr		attr;
> > -	int			fd;
> > +	struct file_attr	attr;
> > +	int			error;
> >  
> >  	if (recurse_dir && !S_ISDIR(stat->st_mode))
> >  		return 0;
> >  
> > -	if ((fd = open(path, O_RDONLY)) == -1) {
> > -		fprintf(stderr, _("%s: cannot open %s: %s\n"),
> > -			progname, path, strerror(errno));
> > -		exitcode = 1;
> > -	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &attr) < 0) {
> > +	error = file_getattr(AT_FDCWD, path, stat, &attr, AT_SYMLINK_NOFOLLOW);
> > +	if (error) {
> >  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> >  			progname, path, strerror(errno));
> >  		exitcode = 1;
> > -	} else {
> > -		attr.fsx_xflags |= orflags;
> > -		attr.fsx_xflags &= ~andflags;
> > -		if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &attr) < 0) {
> > -			fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
> > -				progname, path, strerror(errno));
> > -			exitcode = 1;
> > -		}
> > +		return 0;
> > +	}
> > +
> > +	attr.fa_xflags |= orflags;
> > +	attr.fa_xflags &= ~andflags;
> > +	error = file_setattr(AT_FDCWD, path, stat, &attr, AT_SYMLINK_NOFOLLOW);
> > +	if (error) {
> > +		fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
> > +			progname, path, strerror(errno));
> > +		exitcode = 1;
> >  	}
> >  
> > -	if (fd != -1)
> > -		close(fd);
> >  	return 0;
> >  }
> >  
> >  static int
> >  chattr_f(
> > -	int		argc,
> > -	char		**argv)
> > +	int			argc,
> > +	char			**argv)
> >  {
> > -	struct fsxattr	attr;
> > -	struct xflags	*p;
> > -	unsigned int	i = 0;
> > -	char		*c, *name = file->name;
> > +	struct file_attr	attr;
> > +	struct xflags		*p;
> > +	unsigned int		i = 0;
> > +	char			*c, *name = file->name;
> > +	struct stat		st;
> > +	int			error;
> >  
> >  	orflags = andflags = 0;
> >  	recurse_all = recurse_dir = 0;
> > @@ -326,19 +335,30 @@ chattr_f(
> >  	if (recurse_all || recurse_dir) {
> >  		nftw(name, chattr_callback,
> >  			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
> > -	} else if (xfsctl(name, file->fd, FS_IOC_FSGETXATTR, &attr) < 0) {
> > +		return 0;
> > +	}
> > +
> > +	error = stat(name, &st);
> > +	if (error)
> > +		return error;
> > +
> > +	error = file_getattr(AT_FDCWD, name, &st, &attr, AT_SYMLINK_NOFOLLOW);
> > +	if (error) {
> >  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> >  			progname, name, strerror(errno));
> >  		exitcode = 1;
> > -	} else {
> > -		attr.fsx_xflags |= orflags;
> > -		attr.fsx_xflags &= ~andflags;
> > -		if (xfsctl(name, file->fd, FS_IOC_FSSETXATTR, &attr) < 0) {
> > -			fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
> > -				progname, name, strerror(errno));
> > -			exitcode = 1;
> > -		}
> > +		return 0;
> >  	}
> > +
> > +	attr.fa_xflags |= orflags;
> > +	attr.fa_xflags &= ~andflags;
> > +	error = file_setattr(AT_FDCWD, name, &st, &attr, AT_SYMLINK_NOFOLLOW);
> 
> For my own curiosity, if you wanted to do the get/set sequence on a file
> that's already open, is that just:
> 
> 	file_getattr(fd, "", &attr, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
> 	...
> 	file_setattr(fd, "", &attr, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);

yeah, that should work

> 
> --D
> 
> > +	if (error) {
> > +		fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
> > +			progname, name, strerror(errno));
> > +		exitcode = 1;
> > +	}
> > +
> >  	return 0;
> >  }
> >  
> > 
> > -- 
> > 2.49.0
> > 
> > 
> 

-- 
- Andrey

