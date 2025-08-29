Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8F0326D54
	for <linux-xfs@vger.kernel.org>; Fri, 29 Aug 2025 15:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756482129; cv=none; b=EacTl6zBE4c1MerfJveo4t3oeI7aNzX8U3+psY3p82SvHQCIAmjyRcA7Ys+G40E32Qx8fG0TGVvV9hWYwxEdRtrUnn/4HpViFJjhKkfKSnNUOGIz7SNiXcwl5Llq/x2lcn76aBKTfX8rw0wRNVAGKWBOpoC/A5NN0GJ6YFOezas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756482129; c=relaxed/simple;
	bh=dWU0tQnl/a7jB6nh8zbQfROWvt9TJT4pB283jKPUmuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LDJmjC2C7YFK7qzvlKsh74fjNpp3dv4xFg68ujZqKV+3O30379h90yGczCAE01AxSjxYYNPJ76wKF9QYAU1MOrHsAkDbf+3jyRlARweP1Z8tB4B2fbs3wAZQ+kjap0MOY6haUcC+RO8me+T1P8RHSoHGsCkybJGDvu+zaQKt3i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YwwjIpdh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YwwjIpdh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756482126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L3dkqzGDG292nybq+xc2L7EMzaG/HONK5U6tSiASXoY=;
	b=YwwjIpdhn7ZGenIIUu37WoS+g5rXgsaipwT4CiZk64VNvlpfyMXPU93SZHAhRvteNu1KuK
	avGfBJ50MJ0rES9EfWnXcodVu+Paw0nL8t8BJP8tCh/aItvpWkTLxF1lHe30WF8piek1fe
	BbzwlYcNmnjFBK5bM0sWTwfDFSHyqqY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-CHTGyrQpO9-lDB8r3_F0ng-1; Fri, 29 Aug 2025 11:42:04 -0400
X-MC-Unique: CHTGyrQpO9-lDB8r3_F0ng-1
X-Mimecast-MFC-AGG-ID: CHTGyrQpO9-lDB8r3_F0ng_1756482124
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ce3e098c48so1181951f8f.2
        for <linux-xfs@vger.kernel.org>; Fri, 29 Aug 2025 08:42:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756482124; x=1757086924;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L3dkqzGDG292nybq+xc2L7EMzaG/HONK5U6tSiASXoY=;
        b=QHS7cYcNsRVQWUD8uucvH46zvMihn1KXSzmmxO0tOnvSIjeCb+o7upb857OwwuKCZ4
         kReNA/IkreaErSyH7d2i/cicbXHdp625tdcVAVtvtOX5RIFFshMEcnoU15/SXghGeDDw
         yB7nlzVncG9OGQ1x7K8XTPA/w5mmPrR7j23wbci60aAZFynvm/7k3x78YhOzSPPNB5zG
         8rimcERXfU9aTkqYpGTlN9R+BpJmd7eNH9NKfUUWSNEFfuvIsXXKf1SLqtCHHO1zjXm4
         nC0e0Eny+NEsuHyBO8MpkB8Ihohq/1q9cjKYz3jfgmQm59uANAeUXH+QkZH04TaFjXq8
         LnhA==
X-Forwarded-Encrypted: i=1; AJvYcCX1tOy/UYxFlqvIuF70WF2zhpqO3DcjShPMCp0NuGTJPcCBr5xgJS1TZK71rZS0qtk7bAHEwx6jiiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKG8e6VxR28iu2JjRff6sZ8s/hQsRdPd2TR+Zs3isNXhKM68F+
	/axfkfP4ax9E5JCZwdt1r33NRZWUk26nDQ0iN13gvpdBfCisMe6+sYDZ+O8SsrVVJUczjh2cE3s
	5/UDpdVn62nfHKzZoHa8HexBMB4x0Xsn8xrpN1Ezz/muU/tPWWjN7+sMZtATs
X-Gm-Gg: ASbGncu5A0DALClZT9hkap3ACVmb8DX/IHQA7NGG3rBoDMelNkpN3y7GiK/JRBhsJKq
	xOnHt+B7VcyLEh6NrNAf6e2Hndu6rsNxkQXjAyK2n3NZeGc3GX3WAFKdgAfFcexAfiuIaElhnus
	v+2r1EfDNuwXS+f27KrB/EQFDrK4M70J7tHjjGWtkfANJM9flS2hQvQzVpPQN9PTIhgFk94DfrM
	P/5HAdiPScB9KtUzXzIbcvSF5MzPxdPhslRa8CsNK5Z5JoHnx98akaMRrfqaolJ67BiquSc6NlR
	mGnVKv+ccSGO4Vwr8oW+YQXwz5WWaMM=
X-Received: by 2002:a05:6000:2c0c:b0:3ce:f09:afac with SMTP id ffacd0b85a97d-3ce0f09b49cmr5734022f8f.27.1756482123543;
        Fri, 29 Aug 2025 08:42:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEo+ERCJFbSB+0Kzj5T+Zw7lTOL8oDAEEwJKh5DZaZt9+HK8IL4RGpBPufkBeZged9GV2vFGg==
X-Received: by 2002:a05:6000:2c0c:b0:3ce:f09:afac with SMTP id ffacd0b85a97d-3ce0f09b49cmr5733993f8f.27.1756482123041;
        Fri, 29 Aug 2025 08:42:03 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fb9237sm3695476f8f.42.2025.08.29.08.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 08:42:02 -0700 (PDT)
Date: Fri, 29 Aug 2025 17:42:01 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] xfs_quota: utilize file_setattr to set prjid on
 special files
Message-ID: <gzvj4imrixnjbolyi6uwzhpwuybuaiqd5pnkeg2cn7lh6jn5nk@go3wmefvgy7d>
References: <20250827-xattrat-syscall-v2-0-82a2d2d5865b@kernel.org>
 <20250827-xattrat-syscall-v2-2-82a2d2d5865b@kernel.org>
 <20250828143916.GB8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828143916.GB8096@frogsfrogsfrogs>

On 2025-08-28 07:39:16, Darrick J. Wong wrote:
> On Wed, Aug 27, 2025 at 05:15:54PM +0200, Andrey Albershteyn wrote:
> > From: Andrey Albershteyn <aalbersh@redhat.com>
> > 
> > Utilize new file_getattr/file_setattr syscalls to set project ID on
> > special files. Previously, special files were skipped due to lack of the
> > way to call FS_IOC_SETFSXATTR ioctl on them. The quota accounting was
> > therefore missing these inodes (special files created before project
> > setup). The ones created after project initialization did inherit the
> > projid flag from the parent.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  quota/project.c | 142 +++++++++++++++++++++++++++++---------------------------
> >  1 file changed, 74 insertions(+), 68 deletions(-)
> > 
> > diff --git a/quota/project.c b/quota/project.c
> > index adb26945fa57..857b1abe71c7 100644
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
> >  
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
> > +	struct file_attr	fa;
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
> > +	error = xfrog_file_getattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
> > +	if (error && errno == EOPNOTSUPP) {
> > +		if (SPECIAL_FILE(stat->st_mode)) {
> > +			fprintf(stderr, _("%s: skipping special file %s: %s\n"),
> > +					progname, path, strerror(errno));
> > +			return 0;
> > +		}
> > +	}
> > +	if (error) {
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
> > @@ -141,32 +137,32 @@ clear_project(
> >  		fprintf(stderr, _("%s: cannot stat file %s\n"), progname, path);
> >  		return 0;
> >  	}
> > -	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
> > -		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> > -		return 0;
> > +
> > +	error = xfrog_file_getattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
> > +	if (error && errno == EOPNOTSUPP) {
> > +		if (SPECIAL_FILE(stat->st_mode)) {
> > +			fprintf(stderr, _("%s: skipping special file %s: %s\n"),
> > +					progname, path, strerror(errno));
> > +			return 0;
> > +		}
> >  	}
> >  
> > -	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
> > -		exitcode = 1;
> > -		fprintf(stderr, _("%s: cannot open %s: %s\n"),
> > -			progname, path, strerror(errno));
> > -		return 0;
> > -	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx) < 0) {
> > -		exitcode = 1;
> > +	if (error) {
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
> > +	error = xfrog_file_setattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
> > +	if (error) {
> >  		fprintf(stderr, _("%s: cannot clear project on %s: %s\n"),
> >  			progname, path, strerror(errno));
> > +		exitcode = 1;
> >  	}
> > -	close(fd);
> >  	return 0;
> >  }
> >  
> > @@ -177,8 +173,8 @@ setup_project(
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
> > @@ -188,32 +184,33 @@ setup_project(
> >  		fprintf(stderr, _("%s: cannot stat file %s\n"), progname, path);
> >  		return 0;
> >  	}
> > -	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
> > -		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> > -		return 0;
> > +
> > +	error = xfrog_file_getattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
> > +	if (error && errno == EOPNOTSUPP) {
> > +		if (SPECIAL_FILE(stat->st_mode)) {
> > +			fprintf(stderr, _("%s: skipping special file %s\n"),
> > +					progname, path);
> > +			return 0;
> > +		}
> >  	}
> >  
> > -	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
> > -		exitcode = 1;
> > -		fprintf(stderr, _("%s: cannot open %s: %s\n"),
> > -			progname, path, strerror(errno));
> > -		return 0;
> > -	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx) < 0) {
> > -		exitcode = 1;
> > +	if (error) {
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
> 
> Hrm, interesting change in projinherit logic -- is this because the new
> setattr code rejects projinherit on non-directories?

They don't reject it so far, but I think PROJINHERIT was never set
on files (according to xfs_flags2diflags()).

> 
> > +
> > +	error = xfrog_file_setattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
> > +	if (error) {
> >  		fprintf(stderr, _("%s: cannot set project on %s: %s\n"),
> >  			progname, path, strerror(errno));
> > +		exitcode = 1;
> >  	}
> > -	close(fd);
> >  	return 0;
> >  }
> >  
> > @@ -223,6 +220,13 @@ project_operations(
> >  	char		*dir,
> >  	int		type)
> >  {
> > +	dfd = open(dir, O_RDONLY|O_NOCTTY);
> 
> Nit: spaces around the pipe char^acter, please.
> 
> --D
> 
> > +	if (dfd < -1) {
> > +		printf(_("Error opening dir %s for project %s...\n"), dir,
> > +				project);
> > +		return;
> > +	}
> > +
> >  	switch (type) {
> >  	case CHECK_PROJECT:
> >  		printf(_("Checking project %s (path %s)...\n"), project, dir);
> > @@ -237,6 +241,8 @@ project_operations(
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

