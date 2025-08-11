Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD582D4818
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 17:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754934724; cv=none; b=RIfCCz/JFMpM9K3tiNZjqtSO/LTE3Wce1Nea5VHMvg7O56jNIIYQnuqTNyypkrHCY8zpqiZHsRnVZPMlUNQyuY0KAwZS3iGVlINcUPDMxBWmGkFx+2sSMLKyfzlV7LkP5IP3xfOpZCzZfpBoHF8BW8+rpv7PE3B/E/kWurDVmVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754934724; c=relaxed/simple;
	bh=LylafxiwH3k+ZP4j46HDIJ64h1LHH7pZctqxhPvSUs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fMoCJ8KwwzLMDol1i0uyBceKcm/DmhAc9d9Lu0p5ne4P8+qZ5M8OpXe7IY2yA7DyAJQr61/2czrBQGDeSDoYxPxOtFTA5g9z/l4M7V2EAsukqX+W5JM3VE/8t6BvkstAQup18ZkYNb915ugZ6CfaAh1/lR8vHuqRU35isVdjhHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fNtIkytR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fNtIkytR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754934721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gXT4qvfbPfbCMUM3Y5jBW6QA3yFneKsWJs0UM5FJ3j4=;
	b=fNtIkytRWrlWf8QK6+hHW1PLskoQOhWm1fyBS4pYei2UmP1YCA4uSdnrwqoudXScpVe3cK
	5dl6SHaqjlqUsZILGnnyCvD44vLOAfknI42qHyzvD7FDB+ejmyo4a+apWzD5Eso0SiTF2o
	7x9UQO34o64Qg8Kq8MqMS7U6IFFt8JQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-TkWDhUtgNq2ojQwBlrzNqg-1; Mon, 11 Aug 2025 13:52:00 -0400
X-MC-Unique: TkWDhUtgNq2ojQwBlrzNqg-1
X-Mimecast-MFC-AGG-ID: TkWDhUtgNq2ojQwBlrzNqg_1754934719
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b8d612996cso3474603f8f.2
        for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 10:52:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754934719; x=1755539519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gXT4qvfbPfbCMUM3Y5jBW6QA3yFneKsWJs0UM5FJ3j4=;
        b=KWSdjRYXMgogmS6Nenwx7Fekhsk9+DVaX6dwDQyg05kXBdUKGg1mGeHmV13Hsxwcpi
         PvlNNRuNdVuEtKQaUTsbbAI5XuckYmTjN3BmxyC7gR1R8/oH44A0X0R34pReJrXIsA9/
         oKh4cSvnB5porSsH6aU9bWYwp26N0QH586Vu3UWgsYNj2q7ahFF2H1/IeBtU1Mm5k9wo
         8vSTe0T+t/U6mZz6xZRyWBnK8a+6YM3W1P6G/oALVvCEf75Aqvr7KQz5zwlGPZa4uYp4
         D/YXboj4IvxDe0NAlrVZYvUQ2mJ8wO5iBACLvRPIYdx9Z36D6tl29BJzXsuOA/o/ZTze
         AG+w==
X-Forwarded-Encrypted: i=1; AJvYcCUtikssC2l7oh5tH/qQT4iZGfeQ7tE5Mk8zcniCaPixxMCCp3sOwXlXcDzyorcqBi1+tZ64ZiEb9+U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzkp9Jq4D7DEix2DMJ2xFMupNNwyi1M7x5vgshHv5IF9T27yvhN
	zOI+eX+Atxi7AEQYUseriszeiSyBYmGRbg+u1omUVzb2p+E8/NWp7lmDeIO0RwERp+1eCc7Lw8s
	6VP4BpX3aII4qPD+ttcoYazecHM8dOlHegsRvQcKmGA2+ZJtELqf7OxR1xykrDtL+XAky
X-Gm-Gg: ASbGncsYx0x3OGGj4MHti2br4gzXjLfvhU/i4k6ZOCQhixxodHY7+pZQtl6zdMWumAc
	wWnXvz3s4mTcXNX9VPNW2uJzX9Nb6l5bo8yNL0mHmr7NSHMmbBHF5mWHbFftmA/apoQqMLJUBj1
	7BkNXFyXA2CYYYBF8kt3j5theN7ZcD4S4xboJN1yJURFVlt2S9YGhD9AhJZFaDcb9YEhL8xX1jl
	8wwbIsynuOfX1YTln/AJp4NVAYOIIpC29CW18DyLHuJ66N+yJvvnQNgxTu8ZRnq2UVJs+O+VE3v
	5tliMohgDvNmRM7faaG82YWlo3hMCkICQRoNtBpNbol0VXXzXZdbUNtdnX4=
X-Received: by 2002:a05:6000:290c:b0:3b7:94a2:87e8 with SMTP id ffacd0b85a97d-3b900b4db70mr9585402f8f.18.1754934718574;
        Mon, 11 Aug 2025 10:51:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGj17bPm4Yt4yABD7ZRqL6YobksjOiBPmA+a8Y9DlRybFQy4FXjOcwwYwQSd70b/Otxj5PXXA==
X-Received: by 2002:a05:6000:290c:b0:3b7:94a2:87e8 with SMTP id ffacd0b85a97d-3b900b4db70mr9585385f8f.18.1754934718029;
        Mon, 11 Aug 2025 10:51:58 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e583ff76sm261620775e9.5.2025.08.11.10.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 10:51:57 -0700 (PDT)
Date: Mon, 11 Aug 2025 19:51:57 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_quota: utilize file_setattr to set prjid on
 special files
Message-ID: <l3nhzpwey4zw3h3gz7mgotf7b3n2aa3jueo3rkmsvoyyafuwfr@en4klcgxwwqq>
References: <20250808-xattrat-syscall-v1-0-48567c29e45c@kernel.org>
 <20250808-xattrat-syscall-v1-2-48567c29e45c@kernel.org>
 <20250811150747.GB7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811150747.GB7965@frogsfrogsfrogs>

On 2025-08-11 08:07:47, Darrick J. Wong wrote:
> On Fri, Aug 08, 2025 at 09:30:17PM +0200, Andrey Albershteyn wrote:
> > From: Andrey Albershteyn <aalbersh@redhat.com>
> > 
> > Utilize new file_getattr/file_setattr syscalls to set project ID on
> > special files. Previously, special files were skipped due to lack of the
> > way to call FS_IOC_SETFSXATTR ioctl on them. The quota accounting was
> > therefore missing these inodes (special files created before project
> > setup). The ones created after porject initialization did inherit the
> > projid flag from the parent.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  quota/project.c | 144 +++++++++++++++++++++++++++++---------------------------
> >  1 file changed, 74 insertions(+), 70 deletions(-)
> > 
> > diff --git a/quota/project.c b/quota/project.c
> > index adb26945fa57..93d7ace0e11b 100644
> > --- a/quota/project.c
> > +++ b/quota/project.c
> > @@ -4,14 +4,17 @@
> >   * All Rights Reserved.
> >   */
> >  
> > +#include <unistd.h>
> >  #include "command.h"
> >  #include "input.h"
> >  #include "init.h"
> > +#include "libfrog/file_attr.h"
> >  #include "quota.h"
> >  
> >  static cmdinfo_t project_cmd;
> >  static prid_t prid;
> >  static int recurse_depth = -1;
> > +static int dfd;
> 
> Ew, global scope variables, can we pass that through to check_project?

it's used in all ops (setup, check and clear), this is opened in
project_operations() which then calls nftw which doesn't seem to
have any context for callbacks. So, I think in anyway we will need
some global state.

> 
> >  enum {
> >  	CHECK_PROJECT	= 0x1,
> > @@ -19,13 +22,6 @@ enum {
> >  	CLEAR_PROJECT	= 0x4,
> >  };
> >  
> > -#define EXCLUDED_FILE_TYPES(x) \
> > -	   (S_ISCHR((x)) \
> > -	|| S_ISBLK((x)) \
> > -	|| S_ISFIFO((x)) \
> > -	|| S_ISLNK((x)) \
> > -	|| S_ISSOCK((x)))
> > -
> >  static void
> >  project_help(void)
> >  {
> > @@ -85,8 +81,8 @@ check_project(
> >  	int			flag,
> >  	struct FTW		*data)
> >  {
> > -	struct fsxattr		fsx;
> > -	int			fd;
> > +	int			error;
> > +	struct file_attr	fa = { 0 };
> >  
> >  	if (recurse_depth >= 0 && data->level > recurse_depth)
> >  		return 0;
> > @@ -96,30 +92,30 @@ check_project(
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
> > -		exitcode = 1;
> > +	error = file_getattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
> > +	if (error) {
> > +#ifndef HAVE_FILE_ATTR
> > +		if (SPECIAL_FILE(stat->st_mode)) {
> > +			fprintf(stderr, _("%s: skipping special file %s\n"),
> > +					progname, path);
> > +			return 0;
> > +		}
> > +#endif
> 
> Yeah, file_getattr really ought to return some error code for "not
> supported" and then this becomes:
> 
> 	error = file_getattr(...);
> 	if (error && errno == EOPNOTSUPP) {
> 		fprintf(stderr, _("%s: skipping special file %s\n"),
> 					progname, path);
> 		return 0;
> 	}
> 	if (error) {
> 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> 			progname, path, strerror(errno));
> 		exitcode = 1;
> 		return 0;
> 	}

Sure, that's better, will redo file_getattr()

> 
> >  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> > -			progname, path, strerror(errno));
> > -	} else {
> > -		if (fsx.fsx_projid != prid)
> > -			printf(_("%s - project identifier is not set"
> > -				 " (inode=%u, tree=%u)\n"),
> > -				path, fsx.fsx_projid, (unsigned int)prid);
> > -		if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT) && S_ISDIR(stat->st_mode))
> > -			printf(_("%s - project inheritance flag is not set\n"),
> > -				path);
> > +				progname, path, strerror(errno));
> > +		exitcode = 1;
> > +		return 0;
> >  	}
> > -	if (fd != -1)
> > -		close(fd);
> > +
> > +	if (fa.fa_projid != prid)
> > +		printf(_("%s - project identifier is not set"
> > +				" (inode=%u, tree=%u)\n"),
> > +			path, fa.fa_projid, (unsigned int)prid);
> > +	if (!(fa.fa_xflags & FS_XFLAG_PROJINHERIT) && S_ISDIR(stat->st_mode))
> > +		printf(_("%s - project inheritance flag is not set\n"),
> > +			path);
> > +
> >  	return 0;
> >  }
> >  
> > @@ -130,8 +126,8 @@ clear_project(
> >  	int			flag,
> >  	struct FTW		*data)
> >  {
> > -	struct fsxattr		fsx;
> > -	int			fd;
> > +	int			error;
> > +	struct file_attr	fa;
> >  
> >  	if (recurse_depth >= 0 && data->level > recurse_depth)
> >  		return 0;
> > @@ -141,32 +137,31 @@ clear_project(
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
> > -		exitcode = 1;
> > +	error = file_getattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
> > +	if (error) {
> > +#ifndef HAVE_FILE_ATTR
> > +		if (SPECIAL_FILE(stat->st_mode)) {
> > +			fprintf(stderr, _("%s: skipping special file %s\n"),
> > +					progname, path);
> > +			return 0;
> > +		}
> > +#endif
> >  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> > -			progname, path, strerror(errno));
> > -		close(fd);
> > +				progname, path, strerror(errno));
> > +		exitcode = 1;
> >  		return 0;
> >  	}
> >  
> > -	fsx.fsx_projid = 0;
> > -	fsx.fsx_xflags &= ~FS_XFLAG_PROJINHERIT;
> > -	if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx) < 0) {
> > -		exitcode = 1;
> > +	fa.fa_projid = 0;
> > +	fa.fa_xflags &= ~FS_XFLAG_PROJINHERIT;
> > +
> > +	error = file_setattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
> > +	if (error) {
> >  		fprintf(stderr, _("%s: cannot clear project on %s: %s\n"),
> >  			progname, path, strerror(errno));
> > +		exitcode = 1;
> >  	}
> > -	close(fd);
> >  	return 0;
> >  }
> >  
> > @@ -177,8 +172,8 @@ setup_project(
> >  	int			flag,
> >  	struct FTW		*data)
> >  {
> > -	struct fsxattr		fsx;
> > -	int			fd;
> > +	struct file_attr	fa;
> > +	int			error;
> >  
> >  	if (recurse_depth >= 0 && data->level > recurse_depth)
> >  		return 0;
> > @@ -188,32 +183,32 @@ setup_project(
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
> > -		exitcode = 1;
> > +	error = file_getattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
> > +	if (error) {
> > +#ifndef HAVE_FILE_ATTR
> > +		if (SPECIAL_FILE(stat->st_mode)) {
> > +			fprintf(stderr, _("%s: skipping special file %s\n"),
> > +					progname, path);
> > +			return 0;
> > +		}
> > +#endif
> >  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> > -			progname, path, strerror(errno));
> > -		close(fd);
> > +				progname, path, strerror(errno));
> > +		exitcode = 1;
> >  		return 0;
> >  	}
> >  
> > -	fsx.fsx_projid = prid;
> > -	fsx.fsx_xflags |= FS_XFLAG_PROJINHERIT;
> > -	if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx) < 0) {
> > -		exitcode = 1;
> > +	fa.fa_projid = prid;
> > +	if (S_ISDIR(stat->st_mode))
> > +		fa.fa_xflags |= FS_XFLAG_PROJINHERIT;
> > +
> > +	error = file_setattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
> > +	if (error) {
> >  		fprintf(stderr, _("%s: cannot set project on %s: %s\n"),
> >  			progname, path, strerror(errno));
> > +		exitcode = 1;
> >  	}
> > -	close(fd);
> >  	return 0;
> >  }
> >  
> > @@ -223,6 +218,13 @@ project_operations(
> >  	char		*dir,
> >  	int		type)
> >  {
> > +	dfd = open(dir, O_RDONLY|O_NOCTTY);
> > +	if (dfd < -1) {
> > +		printf(_("Error opening dir %s for project %s...\n"), dir,
> > +				project);
> > +		return;
> > +	}
> > +
> >  	switch (type) {
> >  	case CHECK_PROJECT:
> >  		printf(_("Checking project %s (path %s)...\n"), project, dir);
> > @@ -237,6 +239,8 @@ project_operations(
> >  		nftw(dir, clear_project, 100, FTW_PHYS|FTW_MOUNT);
> >  		break;
> >  	}
> > +
> > +	close(dfd);
> >  }
> >  
> >  static void
> > 
> > -- 
> > 2.49.0
> > 
> > 
> 

-- 
- Andrey

