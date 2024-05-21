Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3250A7EEF3
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 13:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716298721; cv=none; b=baq+HI4htvhK5MfQbafGTWT7KM5dZ8Ka7QdVNjGg3z4d0IRTxfdXzgSl11U3oa1QERb4oevJuurdL8rdKc8e0cCTfs8O5R1EgBOlpDZuCnkR0SUvi+S05oozP7ywGFzB1ccHH/OK8if+F8Optlrm1isodoc0jaEM4FxGuTmSAGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716298721; c=relaxed/simple;
	bh=P+/iAvS7JcI1gm+CgY2ocBXinHlTS78lb3rVoUukszU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CC9A2APojfDiemL+UZnO6wBxIKAbiBw/T68hwfw2hlc/esJSX+a4MVUkEUyW38y/rY1WDytF7u1aETCN6qKIp0opR8rm5sTQV9uOCtgJE5hVHh8XhNsZw/KolCBFutbbNyIbHN1epi+MmLnosOmWGWagbBlzGxWI/OFemuwwQ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y7Gx+ITc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y7Gx+ITc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716298718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HgC/uXNUTwjmTpZfomJwLtJIRosBRXJLoYqkoACKed0=;
	b=Y7Gx+ITcrN39duOyoGEigmo5N8mrv8P1dUDsIa5K/xymABdo5FYRtZi+CioG3PEPkTz5eA
	UCFApRGwgw9LE4aoaARyDbmcDGnl5ZwPf/v6J2QbWeTC3nSxocHHCDLTU8dtJLIOfulZXv
	uBrFR88VeWN0/9E78NzaaTrxZOqrAbQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-FkbemZBEO3muw98u15G2OA-1; Tue, 21 May 2024 09:38:37 -0400
X-MC-Unique: FkbemZBEO3muw98u15G2OA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-41fc6a4f513so65739815e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 06:38:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716298715; x=1716903515;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HgC/uXNUTwjmTpZfomJwLtJIRosBRXJLoYqkoACKed0=;
        b=u7fQXdRt/cQ7JXAPXl45Q/ojvLHkb4tYodeZ9m7X8mMvHiJffIBZxU4n4FG46+/Fqo
         MMNE6nW2nSbLVvWkjInQjxBueRl5cFzDDBCbN7YEze5aNoXdcufuq1IdzCyj5d6vKBVb
         N8ML6bFgBsjtziVmCaQqU5MOo95Xds20PsEfuBu4CIpWdC+I/+IMXdg97SqJp9r6makJ
         M0DeB3UHiZvnModq4J0VCbyByeuEYOBXF0/22HC/HWx+gHqiu2lcxBFwCYnHSW2WBSjt
         MBZN5wbcuf8XLcb2RBuWc8FtewzK7wX6FnNBcwRbNjVggGZVSAsksb7+AGshyt8FVlD5
         HMEA==
X-Gm-Message-State: AOJu0YyAIZJaOOLeO2UXq2iSwjNdBtLkKmz45dCtbTKxah72Ipb+6nIv
	ycV3Afg9wcAYZlN6kT9wdo7QeLnn/dVpM6w1POE+lW5He5+cFmS3fvjbpNjCDcKZdQkzuGXMHv7
	LxF+GGib2RQzdwSTZ8hXJjW6+XJvNh3RFPDpZ9BjojobQNm9nuFgNUAEoJRAnE3bj
X-Received: by 2002:a05:600c:292:b0:41b:8041:53c2 with SMTP id 5b1f17b1804b1-420e19f136emr86557615e9.15.1716298715073;
        Tue, 21 May 2024 06:38:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkMcECDWBSxpAgWvPuY1rpzT5upeTcDMv20ZVtjaAM3W3z19cgUHh9neqIK5c1gmwZVPY57Q==
X-Received: by 2002:a05:600c:292:b0:41b:8041:53c2 with SMTP id 5b1f17b1804b1-420e19f136emr86557305e9.15.1716298714385;
        Tue, 21 May 2024 06:38:34 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42016a511a7sm337961335e9.0.2024.05.21.06.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 May 2024 06:38:33 -0700 (PDT)
Date: Tue, 21 May 2024 15:38:32 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH v2] libxfs/quota: utilize FS_IOC_FSSETXATTRAT to set
 prjid on special files
Message-ID: <rgjdcth22yryfeoapkbdrkzojvjyqo3az6v3rtyy4y43yhokq4@feddkvhbjbgr>
References: <20240520165200.667150-2-aalbersh@redhat.com>
 <20240520175924.GG25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520175924.GG25518@frogsfrogsfrogs>

On 2024-05-20 10:59:24, Darrick J. Wong wrote:
> On Mon, May 20, 2024 at 06:52:01PM +0200, Andrey Albershteyn wrote:
> > Utilize new FS_IOC_FS[SET|GET]XATTRAT ioctl to set project ID on
> > special files. Previously, special files were skipped due to lack of
> > the way to call FS_IOC_SETFSXATTR on them. The quota accounting was
> > therefore missing a few inodes (special files created before project
> > setup).
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  include/linux.h |  14 +++++
> >  quota/project.c | 158 ++++++++++++++++++++++++++++++++----------------
> >  2 files changed, 120 insertions(+), 52 deletions(-)
> > 
> > diff --git a/include/linux.h b/include/linux.h
> > index 95a0deee2594..baae28727030 100644
> > --- a/include/linux.h
> > +++ b/include/linux.h
> > @@ -249,6 +249,20 @@ struct fsxattr {
> >  #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
> >  #endif
> >  
> > +#ifndef FS_IOC_FSGETXATTRAT
> > +/*
> > + * Structure passed to FS_IOC_FSGETXATTRAT/FS_IOC_FSSETXATTRAT
> > + */
> > +struct fsxattrat {
> > +	struct fsxattr	fsx;		/* XATTR to get/set */
> > +	__u32		dfd;		/* parent dir */
> > +	const char	*path;
> > +};
> > +
> > +#define FS_IOC_FSGETXATTRAT   _IOR ('X', 33, struct fsxattrat)
> > +#define FS_IOC_FSSETXATTRAT   _IOW ('X', 34, struct fsxattrat)
> > +#endif
> 
> Might want to hide this in quota/project.c since it's the only user.
> (Do we need to port the xfs_io commands?  I think not since xfs_io
> cannot open special files?)

yup, it cannot open special files. But lsproj\chproj\lsattr\setattr
(statx?) seems to be worth updating, do you see any other commands
which could be useful?

> 
> > +
> >  /*
> >   * Reminder: anything added to this file will be compiled into downstream
> >   * userspace projects!
> > diff --git a/quota/project.c b/quota/project.c
> > index adb26945fa57..438dd925c884 100644
> > --- a/quota/project.c
> > +++ b/quota/project.c
> > @@ -12,6 +12,8 @@
> >  static cmdinfo_t project_cmd;
> >  static prid_t prid;
> >  static int recurse_depth = -1;
> > +static int dfd;
> > +static int dlen;
> >  
> >  enum {
> >  	CHECK_PROJECT	= 0x1,
> > @@ -19,7 +21,7 @@ enum {
> >  	CLEAR_PROJECT	= 0x4,
> >  };
> >  
> > -#define EXCLUDED_FILE_TYPES(x) \
> > +#define SPECIAL_FILE(x) \
> >  	   (S_ISCHR((x)) \
> >  	|| S_ISBLK((x)) \
> >  	|| S_ISFIFO((x)) \
> > @@ -78,6 +80,71 @@ project_help(void)
> >  "\n"));
> >  }
> >  
> > +static int
> > +get_fsxattr(
> > +	const char		*path,
> > +	const struct stat	*stat,
> > +	struct FTW		*data,
> > +	struct fsxattr		*fsx)
> > +{
> > +	int			error;
> > +	int			fd;
> > +	struct fsxattrat	xreq = {
> > +		.fsx = { 0 },
> > +		.dfd = dfd,
> > +		.path = path + (data->level ? dlen + 1 : 0),
> > +	};
> > +
> > +	if (SPECIAL_FILE(stat->st_mode)) {
> > +		error = ioctl(dfd, FS_IOC_FSGETXATTRAT, &xreq);
> > +		if (error)
> > +			return error;
> > +
> > +		memcpy(fsx, &xreq.fsx, sizeof(struct fsxattr));
> > +		return error;
> > +	}
> > +
> > +	fd = open(path, O_RDONLY|O_NOCTTY);
> > +	if (fd == -1)
> > +		return errno;
> > +
> > +	error = ioctl(fd, FS_IOC_FSGETXATTR, fsx);
> > +	close(fd);
> > +
> > +	return error;
> > +}
> > +
> > +static int
> > +set_fsxattr(
> > +	const char		*path,
> > +	const struct stat	*stat,
> > +	struct FTW		*data,
> > +	struct fsxattr		*fsx)
> > +{
> > +	int			error;
> > +	int			fd;
> > +	struct fsxattrat	xreq = {
> > +		.fsx = { 0 },
> 
> 		.fsx = *fsx, /* struct copy */
> 
> > +		.dfd = dfd,
> > +		.path = path + (data->level ? dlen + 1 : 0),
> > +	};
> > +
> > +	if (SPECIAL_FILE(stat->st_mode)) {
> > +		memcpy(&xreq.fsx, fsx, sizeof(struct fsxattr));
> > +		error = ioctl(dfd, FS_IOC_FSSETXATTRAT, &xreq);
> > +		return error;
> 
> 	if (SPECIAL_FILE(stat->st_mode))
> 		return ioctl(dfd, FS_IOC_FSSETXATTRAT, &xreq);
> 
> Everything else looks good!
> 
> --D
> 
> > +	}
> > +
> > +	fd = open(path, O_RDONLY|O_NOCTTY);
> > +	if (fd == -1)
> > +		return errno;
> > +
> > +	error = ioctl(fd, FS_IOC_FSSETXATTR, fsx);
> > +	close(fd);
> > +
> > +	return error;
> > +}
> > +
> >  static int
> >  check_project(
> >  	const char		*path,
> > @@ -85,8 +152,8 @@ check_project(
> >  	int			flag,
> >  	struct FTW		*data)
> >  {
> > -	struct fsxattr		fsx;
> > -	int			fd;
> > +	int			error;
> > +	struct fsxattr		fsx = { 0 };
> >  
> >  	if (recurse_depth >= 0 && data->level > recurse_depth)
> >  		return 0;
> > @@ -96,30 +163,23 @@ check_project(
> >  		fprintf(stderr, _("%s: cannot stat file %s\n"), progname, path);
> >  		return 0;
> >  	}
> > -	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
> > -		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> > -		return 0;
> > -	}
> >  
> > -	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
> > -		exitcode = 1;
> > -		fprintf(stderr, _("%s: cannot open %s: %s\n"),
> > -			progname, path, strerror(errno));
> > -	} else if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
> > +	error = get_fsxattr(path, stat, data, &fsx);
> > +	if (error) {
> >  		exitcode = 1;
> >  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> >  			progname, path, strerror(errno));
> > -	} else {
> > -		if (fsx.fsx_projid != prid)
> > -			printf(_("%s - project identifier is not set"
> > -				 " (inode=%u, tree=%u)\n"),
> > -				path, fsx.fsx_projid, (unsigned int)prid);
> > -		if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT) && S_ISDIR(stat->st_mode))
> > -			printf(_("%s - project inheritance flag is not set\n"),
> > -				path);
> > +		return 0;
> >  	}
> > -	if (fd != -1)
> > -		close(fd);
> > +
> > +	if (fsx.fsx_projid != prid)
> > +		printf(_("%s - project identifier is not set"
> > +				" (inode=%u, tree=%u)\n"),
> > +			path, fsx.fsx_projid, (unsigned int)prid);
> > +	if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT) && S_ISDIR(stat->st_mode))
> > +		printf(_("%s - project inheritance flag is not set\n"),
> > +			path);
> > +
> >  	return 0;
> >  }
> >  
> > @@ -130,8 +190,8 @@ clear_project(
> >  	int			flag,
> >  	struct FTW		*data)
> >  {
> > +	int			error;
> >  	struct fsxattr		fsx;
> > -	int			fd;
> >  
> >  	if (recurse_depth >= 0 && data->level > recurse_depth)
> >  		return 0;
> > @@ -141,32 +201,24 @@ clear_project(
> >  		fprintf(stderr, _("%s: cannot stat file %s\n"), progname, path);
> >  		return 0;
> >  	}
> > -	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
> > -		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> > -		return 0;
> > -	}
> >  
> > -	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
> > -		exitcode = 1;
> > -		fprintf(stderr, _("%s: cannot open %s: %s\n"),
> > -			progname, path, strerror(errno));
> > -		return 0;
> > -	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx) < 0) {
> > +	error = get_fsxattr(path, stat, data, &fsx);
> > +	if (error) {
> >  		exitcode = 1;
> >  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> > -			progname, path, strerror(errno));
> > -		close(fd);
> > +				progname, path, strerror(errno));
> >  		return 0;
> >  	}
> >  
> >  	fsx.fsx_projid = 0;
> >  	fsx.fsx_xflags &= ~FS_XFLAG_PROJINHERIT;
> > -	if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx) < 0) {
> > +
> > +	error = set_fsxattr(path, stat, data, &fsx);
> > +	if (error) {
> >  		exitcode = 1;
> >  		fprintf(stderr, _("%s: cannot clear project on %s: %s\n"),
> >  			progname, path, strerror(errno));
> >  	}
> > -	close(fd);
> >  	return 0;
> >  }
> >  
> > @@ -178,7 +230,7 @@ setup_project(
> >  	struct FTW		*data)
> >  {
> >  	struct fsxattr		fsx;
> > -	int			fd;
> > +	int			error;
> >  
> >  	if (recurse_depth >= 0 && data->level > recurse_depth)
> >  		return 0;
> > @@ -188,32 +240,24 @@ setup_project(
> >  		fprintf(stderr, _("%s: cannot stat file %s\n"), progname, path);
> >  		return 0;
> >  	}
> > -	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
> > -		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> > -		return 0;
> > -	}
> >  
> > -	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
> > -		exitcode = 1;
> > -		fprintf(stderr, _("%s: cannot open %s: %s\n"),
> > -			progname, path, strerror(errno));
> > -		return 0;
> > -	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx) < 0) {
> > +	error = get_fsxattr(path, stat, data, &fsx);
> > +	if (error) {
> >  		exitcode = 1;
> >  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> > -			progname, path, strerror(errno));
> > -		close(fd);
> > +				progname, path, strerror(errno));
> >  		return 0;
> >  	}
> >  
> >  	fsx.fsx_projid = prid;
> >  	fsx.fsx_xflags |= FS_XFLAG_PROJINHERIT;
> > -	if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx) < 0) {
> > +
> > +	error = set_fsxattr(path, stat, data, &fsx);
> > +	if (error) {
> >  		exitcode = 1;
> >  		fprintf(stderr, _("%s: cannot set project on %s: %s\n"),
> >  			progname, path, strerror(errno));
> >  	}
> > -	close(fd);
> >  	return 0;
> >  }
> >  
> > @@ -223,6 +267,14 @@ project_operations(
> >  	char		*dir,
> >  	int		type)
> >  {
> > +	dfd = open(dir, O_RDONLY|O_NOCTTY);
> > +	if (dfd < -1) {
> > +		printf(_("Error opening dir %s for project %s...\n"), dir,
> > +				project);
> > +		return;
> > +	}
> > +	dlen = strlen(dir);
> > +
> >  	switch (type) {
> >  	case CHECK_PROJECT:
> >  		printf(_("Checking project %s (path %s)...\n"), project, dir);
> > @@ -237,6 +289,8 @@ project_operations(
> >  		nftw(dir, clear_project, 100, FTW_PHYS|FTW_MOUNT);
> >  		break;
> >  	}
> > +
> > +	close(dfd);
> >  }
> >  
> >  static void
> > -- 
> > 2.42.0
> > 
> > 
> 

-- 
- Andrey

