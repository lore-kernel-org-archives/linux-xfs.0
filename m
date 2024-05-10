Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E478A79945
	for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 09:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715333961; cv=none; b=jvtKyYvoh0l4XukJZgnsR5wmNyLCqxaCcUbfnWykQLxkX6zPgYryt5ARvHYdKE5x8/oqvspNCA7IrDGjMmi3Jgqf4c06IkC20I2fK4BYvVYEmWtbm6Gyg+GA+gCBxm/9sXkpMfzJmDsoL4JzxJo4ystYd4JQPtMdqO0J9ktc1ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715333961; c=relaxed/simple;
	bh=nr5bEg0DBoWjJ4iUXKQWJ2oBkAN+2IveUciVU8CDeQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdn9QBKgZBbH66n5NqGm3B6meDVdeyOUsPqmgeXyRVTBdiC6tIdc3mykdOjLy1C1ORBLbNvSTUDgmDzspp/+jUy7DkxEYM3cDtH55Qi4/6ZimTRBEW5BBQZVGtxTizq7uT44B8ekPLvNYT2o8L9Zp3nL4bRUY9m9gXojACbwRCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ISvEvnI5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ISvEvnI5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715333958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mpxiEEzgS2Ajr3HlOy6yA7KJ4ag8GJJnNEK1lRuWMiM=;
	b=ISvEvnI5IAAZY2LEDHIcmDtdIP2oddvZ7WuEQ9ahn9fpWet447NdyCrRpE+0xKG+cxFGYp
	EMg5EpnIOnJ28V3mhfR+qCnGGTWx80RiyVA+qOxmX4NSPVBBnG7DhC8fd2lLxFaJll1z4G
	ylZz4YxaYeS7huPNexbY9Etu011RC6o=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-214-6RPXJmYTPB6SbPJ4M-GoWA-1; Fri, 10 May 2024 05:39:17 -0400
X-MC-Unique: 6RPXJmYTPB6SbPJ4M-GoWA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-34d9b4d3a4fso928238f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 02:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715333956; x=1715938756;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mpxiEEzgS2Ajr3HlOy6yA7KJ4ag8GJJnNEK1lRuWMiM=;
        b=AysE0uQhrqSlbPUXfQ8N0+kQ8LI8JAmGm1P2AWH2HrdZTD2f3lqw+P5x4sn1KTIUuC
         H5c4sz9Qpy0u5DGtjW/tCAhwI6t1GC89T5nkQRnedLjI7DLCOb/KeCLeZGOwlMwG7MYz
         41mflu3I9OFqSQFR2LWUi+n+jT5/68hMb1sYxXDNm1tNAnmxu6e+uQYBDX06F5E0Zk8T
         ZlzXKeYpOq/kQy8iYf5nsLqi0xqMLD+pw3iIX1rM/lW6Z0X+79b1tF3DNfq0gxBHMQkp
         0lt2PJEr0jex6V5/0J/CZmV54R/LkcAH4TPUeQgBVpbPhr4g/MhNq44IBfeP08ITNF23
         CwIw==
X-Forwarded-Encrypted: i=1; AJvYcCUrwtwTReRRTuzEMcaERMLDMDDnijv3F/4VWasYREzlsltWmj1M1U1ZNUp2gc1wu/o7K9YqpCBhEUX8qdYSmdyoTE4XUq7PMPcB
X-Gm-Message-State: AOJu0YzuAWg2jk6wbwFWrBl56cYrs/8vliBEEhpyh3tRcba5tLX0I5kA
	I/wf+eWp7fD19Fz3c06f/s91XTtZ4TAyjt7Im7jWXk/MZXqJcZBvwvt69qs4BbTCXn4MmsL3OEt
	nsMZKaWtQDgTzXN97pMTb6v8XuBijjlnAnsJqj4xzsVMvhOMDfqC4tmOGFOKSpC3L
X-Received: by 2002:adf:fe04:0:b0:34f:9b4:43d0 with SMTP id ffacd0b85a97d-3504a6311e0mr1746650f8f.26.1715333955818;
        Fri, 10 May 2024 02:39:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHn2b/qXpJf8aKTqTirtsrw/GsXeYzyh50tUVcEqIzyytJFdcKs+FgiUgqDVw6q/R2i+JCvbw==
X-Received: by 2002:adf:fe04:0:b0:34f:9b4:43d0 with SMTP id ffacd0b85a97d-3504a6311e0mr1746626f8f.26.1715333955191;
        Fri, 10 May 2024 02:39:15 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35046de981fsm2307391f8f.117.2024.05.10.02.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 02:39:14 -0700 (PDT)
Date: Fri, 10 May 2024 11:39:14 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs/quota: utilize XFS_IOC_SETFSXATTRAT to set prjid
 on special files
Message-ID: <xzi6vm7ttq6df5xxln55r6dg3pnq7cn5zb5b2vlm2rhhw7zzx5@fzgjkqpulzvo>
References: <20240509151714.3623695-2-aalbersh@redhat.com>
 <20240509234104.GU360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509234104.GU360919@frogsfrogsfrogs>

On 2024-05-09 16:41:04, Darrick J. Wong wrote:
> On Thu, May 09, 2024 at 05:17:15PM +0200, Andrey Albershteyn wrote:
> > Utilize new XFS ioctl to set project ID on special files.
> > Previously, special files were skipped due to lack of the way to
> > call FS_IOC_SETFSXATTR on them. The quota accounting was therefore
> > missing a few inodes (special files created before project setup).
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  libxfs/xfs_fs.h |  11 ++++
> >  quota/project.c | 139 +++++++++++++++++++++++++++++++++++++++++++++---
> >  2 files changed, 144 insertions(+), 6 deletions(-)
> > 
> > diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> > index 6360073865db..1a560dfa7e15 100644
> > --- a/libxfs/xfs_fs.h
> > +++ b/libxfs/xfs_fs.h
> > @@ -662,6 +662,15 @@ typedef struct xfs_swapext
> >  	struct xfs_bstat sx_stat;	/* stat of target b4 copy */
> >  } xfs_swapext_t;
> >  
> > +/*
> > + * Structure passed to XFS_IOC_GETFSXATTRAT/XFS_IOC_GETFSXATTRAT
> > + */
> > +struct xfs_xattrat_req {
> > +	struct fsxattr	__user *fsx;		/* XATTR to get/set */
> > +	__u32		dfd;			/* parent dir */
> > +	const char	__user *path;		/* NUL terminated path */
> > +};
> > +
> >  /*
> >   * Flags for going down operation
> >   */
> > @@ -837,6 +846,8 @@ struct xfs_scrub_metadata {
> >  #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
> >  #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
> >  #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
> > +#define XFS_IOC_GETFSXATTRAT	     _IOR ('X', 130, struct xfs_xattrat_req)
> > +#define XFS_IOC_SETFSXATTRAT	     _IOW ('X', 131, struct xfs_xattrat_req)
> >  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
> >  
> >  
> > diff --git a/quota/project.c b/quota/project.c
> > index adb26945fa57..e6059db93a77 100644
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
> > @@ -78,6 +80,42 @@ project_help(void)
> >  "\n"));
> >  }
> >  
> > +static int
> > +check_special_file(
> > +	const char		*path,
> > +	const struct stat	*stat,
> > +	int			flag,
> > +	struct FTW		*data)
> > +{
> > +	int			error;
> > +	struct fsxattr		fa;
> > +	struct xfs_xattrat_req	xreq = {
> > +		.fsx = &fa,
> > +		.dfd = dfd,
> > +		.path = path + (data->level ? dlen + 1 : 0),
> > +	};
> > +
> > +	error = xfsctl(path, dfd, XFS_IOC_GETFSXATTRAT, &xreq);
> > +	if (error == -ENOTTY) {
> 
> These xfsctl calls should be direct ioctl calls.

I see, will change those new ones.

> 
> > +		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> > +		return 0;
> > +	}
> > +
> > +	if (error) {
> > +		exitcode = 1;
> > +		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> > +			progname, path, strerror(errno));
> > +		return 0;
> > +	}
> > +
> > +	if (xreq.fsx->fsx_projid != prid)
> > +		printf(_("%s - project identifier is not set"
> > +			 " (inode=%u, tree=%u)\n"),
> > +			path, xreq.fsx->fsx_projid, (unsigned int)prid);
> > +
> > +	return 0;
> > +}
> > +
> >  static int
> >  check_project(
> >  	const char		*path,
> > @@ -97,8 +135,7 @@ check_project(
> >  		return 0;
> >  	}
> >  	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
> > -		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> > -		return 0;
> > +		return check_special_file(path, stat, flag, data);
> >  	}
> >  
> >  	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
> > @@ -123,6 +160,48 @@ check_project(
> >  	return 0;
> >  }
> >  
> > +static int
> > +clear_special_file(
> > +	const char		*path,
> > +	const struct stat	*stat,
> > +	int			flag,
> > +	struct FTW		*data)
> > +{
> > +	int			error;
> > +	struct fsxattr		fa;
> > +	struct xfs_xattrat_req	xreq = {
> > +		.fsx = &fa,
> > +		.dfd = dfd,
> > +		.path = path + (data->level ? dlen + 1 : 0),
> > +	};
> > +
> > +	error = xfsctl(path, dfd, XFS_IOC_GETFSXATTRAT, &xreq);
> > +	if (error == -ENOTTY) {
> > +		fprintf(stderr, _("%s: skipping special file %s\n"),
> > +				progname, path);
> > +		return 0;
> > +	}
> > +
> > +	if (error) {
> > +		exitcode = 1;
> > +		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> > +			progname, path, strerror(errno));
> > +		return 0;
> > +	}
> > +
> > +	xreq.fsx->fsx_projid = 0;
> > +	xreq.fsx->fsx_xflags &= ~FS_XFLAG_PROJINHERIT;
> > +	error = xfsctl(path, dfd, XFS_IOC_SETFSXATTRAT, &xreq);
> > +	if (error) {
> > +		exitcode = 1;
> > +		fprintf(stderr, _("%s: cannot clear project on %s: %s\n"),
> > +			progname, path, strerror(errno));
> > +		return 0;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static int
> >  clear_project(
> >  	const char		*path,
> > @@ -142,8 +221,7 @@ clear_project(
> >  		return 0;
> >  	}
> >  	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
> > -		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> > -		return 0;
> > +		return clear_special_file(path, stat, flag, data);
> >  	}
> >  
> >  	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
> > @@ -170,6 +248,47 @@ clear_project(
> >  	return 0;
> >  }
> >  
> > +static int
> > +setup_special_file(
> > +	const char		*path,
> > +	const struct stat	*stat,
> > +	int			flag,
> > +	struct FTW		*data)
> > +{
> > +	int			error;
> > +	struct fsxattr		fa;
> > +	struct xfs_xattrat_req	xreq = {
> > +		.fsx = &fa,
> > +		.dfd = dfd,
> > +		/* Cut path to parent - make it relative to the dfd */
> > +		.path = path + (data->level ? dlen + 1 : 0),
> > +	};
> > +
> > +	error = xfsctl(path, dfd, XFS_IOC_GETFSXATTRAT, &xreq);
> > +	if (error == -ENOTTY) {
> > +                fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> > +                return 0;
> > +        }
> > +
> > +	if (error) {
> > +		exitcode = 1;
> > +		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> > +			progname, path, strerror(errno));
> > +		return 0;
> > +	}
> > +	xreq.fsx->fsx_projid = prid;
> > +	xreq.fsx->fsx_xflags |= FS_XFLAG_PROJINHERIT;
> > +	error = xfsctl(path, dfd, XFS_IOC_SETFSXATTRAT, &xreq);
> > +	if (error) {
> > +		exitcode = 1;
> > +		fprintf(stderr, _("%s: cannot set project on %s: %s\n"),
> > +			progname, path, strerror(errno));
> > +		return 0;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static int
> >  setup_project(
> >  	const char		*path,
> > @@ -189,8 +308,7 @@ setup_project(
> >  		return 0;
> >  	}
> >  	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
> > -		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> > -		return 0;
> > +		return setup_special_file(path, stat, flag, data);
> >  	}
> >  
> >  	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
> > @@ -223,6 +341,13 @@ project_operations(
> >  	char		*dir,
> >  	int		type)
> >  {
> > +	if ((dfd = open(dir, O_RDONLY|O_NOCTTY)) == -1) {
> 
> Please let's not introduce more of this ^ in the codebase:
> 
> 	dfd = open(...);
> 	if (dfd < 0) {
> 		printf(...);

Sure, will change that.

> 
> --D
> 
> > +		printf(_("Error opening dir %s for project %s...\n"), dir,
> > +				project);
> > +		return;
> > +	}
> > +	dlen = strlen(dir);
> > +
> >  	switch (type) {
> >  	case CHECK_PROJECT:
> >  		printf(_("Checking project %s (path %s)...\n"), project, dir);
> > @@ -237,6 +362,8 @@ project_operations(
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

