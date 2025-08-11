Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B8E224891
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 18:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754935595; cv=none; b=Gj0oopD8kj/oPV5GGXPDbRNYEUkTrJMK9PxbHUuoAELZCifr4BDHogrTJvn3YUnP7SK6nCo7sqXx5LDc/rPkp3Poy8O05+cJM+KofBLi6IKNCytVAeadECez2kz6XNVylqxrTgP1Zu127C2sKSCvuLNDOs6gVgroL13mW+sP1bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754935595; c=relaxed/simple;
	bh=B883spe+HGJuCfDUtTTBYFtKj8bdGxKAyPg6WW4U7HY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mRzIN4mhN94mxV19VO+h8dhJ6Vh05tm9Ofou0VCS9VMdS+10WtWxyYLi7368XLC3isugq0Bw4/9v1I3QrVMRkWoSb2/yloQgmJLYoMzbq/kozT/4Ajl++QSPCrmKuU8PlN6bqBXDOWkoNSIR+lmAlGLNzxCiTvfJJeMJg2xutXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fe6Cwizh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fe6Cwizh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754935592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UetujY4teDrYc0Bxu9Hz0sVSN1mNpDqE+lc/mpyaRP0=;
	b=fe6CwizhdcYkE7ydnj0rUvu4ae9OJa7OiSXe7JXMc1mEpQgQmfdUzijhTxK1/RtnMH8N6f
	8QHOBv5tFZ/Xx8ecjLKgo14qarMP59Baa2OEEGX8I+/yr7oKBogzwtyTbxjoG+DdUhtpz+
	vdlEdPvPp1K/NaNrY5x02bjl+RKUurg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-v5RJeUAgP1-Mgy0mH2gxhg-1; Mon, 11 Aug 2025 14:06:30 -0400
X-MC-Unique: v5RJeUAgP1-Mgy0mH2gxhg-1
X-Mimecast-MFC-AGG-ID: v5RJeUAgP1-Mgy0mH2gxhg_1754935589
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-458bf93f729so24327965e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 11:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754935589; x=1755540389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UetujY4teDrYc0Bxu9Hz0sVSN1mNpDqE+lc/mpyaRP0=;
        b=s43XgXXuMgkRo57UJahySyx2ukxYiAh/1MSp/59kvJqko+7Nn6gb+r8VMnIj4526CU
         NPJWzfr9cDJvLMFHw/9v6Fxs5mbGd3ZcFnXBlkWXNC4yn2B6uDD7Z7a8a71I1kehPr6I
         gRjnbyq+qLsqT52LqhPMjUeiZAcjOVE6QS3eXQfOxROuXtMGsshpsiC8iidOpqKgj7Ec
         xoIOSvRHWtb7TSjL/58Zy6TJvYUMj5rIYO+vrgZqkxc8YK8v6OhEY/GUQxknUia18R/E
         M7coU1YiOq+IKIp1mWtj5vjqsm/SJWLu9LWqpfQHZJvBFkx7Ww05oKEQWwN+TdOHc2s4
         CSjg==
X-Forwarded-Encrypted: i=1; AJvYcCW0AlnuW4ivbX8KhkD1yJj2PRD758D1R0N6aFYFKzqn9yFG2CwUhLcXz3bvrA219ALqnHz2InjVMKg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1zZAHtVLw1R/J3oi9HFrFPMnDRbcAlkKsUKfiKwQj2XSGNhwH
	Tdyuxp02EJ+3D0aypkBt+b205QY7mkW7yBdYr9mvVGB3a+oblmr0YHGKuIHbthzxpbGHnHd23AN
	bwyyGd9OeeXlXYClvf6FuatMzK3f553HrkwG/UuhRwdidGcuW3xpYaZY96c8u
X-Gm-Gg: ASbGncuR5LIjv9juIe4Qqy0gYpxb5KY2gLtpE0wcUUc2Lj43sClJVqyYBxbwkbVATqT
	r0ANvWXc/cT6nEaaetX5PgoVUsv8VXm+vtrBSGd4UaxZ3lhmDHRnpycTNAS/0YmG9pMvZXFZ/4J
	j8nJlej+Fk1cmdBz4E9p+q9/M54o4BHcPXhUxPLTJxaQEVPKM1OQy+hs6md0fIUzxtvmk+V2vpG
	TTMYTSRB2LcPvwTBCdGYS9ar/L9yE/hd6tPMjGwNnKYjpJLSkbo/hU3WPwvt58AEylSLQ830Fjy
	aI75BlNQwhl5MhRlXIQuFK9ha5xUhbC/3ZW4XgMrMpLaPVuw0Fu+2TH99V8=
X-Received: by 2002:a05:600c:3e08:b0:456:1b6f:c888 with SMTP id 5b1f17b1804b1-45a10d22f93mr5084245e9.23.1754935588652;
        Mon, 11 Aug 2025 11:06:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+u3mV+tfyDx8XsODWBVKQ1IzrUBIuQC6glKK4U1fYfDEhPItjm+le3RxrvndcuIpnP3fQMg==
X-Received: by 2002:a05:600c:3e08:b0:456:1b6f:c888 with SMTP id 5b1f17b1804b1-45a10d22f93mr5083995e9.23.1754935588203;
        Mon, 11 Aug 2025 11:06:28 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8fc28a830sm17317007f8f.16.2025.08.11.11.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 11:06:27 -0700 (PDT)
Date: Mon, 11 Aug 2025 20:06:27 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, zlang@redhat.com, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 1/3] file_attr: introduce program to set/get fsxattr
Message-ID: <gmkcjrcegsypuiuljh4jh7nluubzpz36t6lnb5fgn6hwyqfzy7@pxx6xoe53c7e>
References: <20250808-xattrat-syscall-v1-0-6a09c4f37f10@kernel.org>
 <20250808-xattrat-syscall-v1-1-6a09c4f37f10@kernel.org>
 <20250811152340.GG7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811152340.GG7965@frogsfrogsfrogs>

On 2025-08-11 08:23:40, Darrick J. Wong wrote:
> On Fri, Aug 08, 2025 at 09:31:56PM +0200, Andrey Albershteyn wrote:
> > This programs uses newly introduced file_getattr and file_setattr
> > syscalls. This program is partially a test of invalid options. This will
> > be used further in the test.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  .gitignore            |   1 +
> >  configure.ac          |   1 +
> >  include/builddefs.in  |   1 +
> >  m4/package_libcdev.m4 |  16 +++
> >  src/Makefile          |   5 +
> >  src/file_attr.c       | 277 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  6 files changed, 301 insertions(+)
> > 
> > diff --git a/.gitignore b/.gitignore
> > index 4fd817243dca..1a578eab1ea0 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -210,6 +210,7 @@ tags
> >  /src/fiemap-fault
> >  /src/min_dio_alignment
> >  /src/dio-writeback-race
> > +/src/file_attr
> >  
> >  # Symlinked files
> >  /tests/generic/035.out
> > diff --git a/configure.ac b/configure.ac
> > index f3c8c643f0eb..6fe54e8e1d54 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -73,6 +73,7 @@ AC_HAVE_RLIMIT_NOFILE
> >  AC_NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE
> >  AC_HAVE_FICLONE
> >  AC_HAVE_TRIVIAL_AUTO_VAR_INIT
> > +AC_HAVE_FILE_ATTR
> >  
> >  AC_CHECK_FUNCS([renameat2])
> >  AC_CHECK_FUNCS([reallocarray])
> > diff --git a/include/builddefs.in b/include/builddefs.in
> > index 96d5ed25b3e2..821237339cc7 100644
> > --- a/include/builddefs.in
> > +++ b/include/builddefs.in
> > @@ -74,6 +74,7 @@ HAVE_BMV_OF_SHARED = @have_bmv_of_shared@
> >  HAVE_RLIMIT_NOFILE = @have_rlimit_nofile@
> >  NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE = @need_internal_xfs_ioc_exchange_range@
> >  HAVE_FICLONE = @have_ficlone@
> > +HAVE_FILE_ATTR = @have_file_attr@
> >  
> >  GCCFLAGS = -std=gnu11 -funsigned-char -fno-strict-aliasing -Wall
> >  SANITIZER_CFLAGS += @autovar_init_cflags@
> > diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> > index ed8fe6e32ae0..e68a70f7d87e 100644
> > --- a/m4/package_libcdev.m4
> > +++ b/m4/package_libcdev.m4
> > @@ -86,3 +86,19 @@ AC_DEFUN([AC_HAVE_TRIVIAL_AUTO_VAR_INIT],
> >      CFLAGS="${OLD_CFLAGS}"
> >      AC_SUBST(autovar_init_cflags)
> >    ])
> > +
> > +#
> > +# Check if we have a file_getattr/file_setattr system call (Linux)
> > +#
> > +AC_DEFUN([AC_HAVE_FILE_ATTR],
> > +  [ AC_MSG_CHECKING([for file_getattr/file_setattr syscalls])
> > +    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
> > +#define _GNU_SOURCE
> > +#include <sys/syscall.h>
> > +#include <unistd.h>
> > +    ]], [[
> > +         syscall(__NR_file_getattr, 0, 0, 0, 0, 0, 0);
> > +    ]])],[have_file_attr=yes
> > +       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
> > +    AC_SUBST(have_file_attr)
> > +  ])
> > diff --git a/src/Makefile b/src/Makefile
> > index 6ac72b366257..f3137acf687f 100644
> > --- a/src/Makefile
> > +++ b/src/Makefile
> > @@ -61,6 +61,11 @@ ifeq ($(HAVE_FALLOCATE), true)
> >  LCFLAGS += -DHAVE_FALLOCATE
> >  endif
> >  
> > +ifeq ($(HAVE_FILE_ATTR), yes)
> > +LINUX_TARGETS += file_attr
> > +LCFLAGS += -DHAVE_FILE_ATTR
> > +endif
> > +
> >  ifeq ($(PKG_PLATFORM),linux)
> >  TARGETS += $(LINUX_TARGETS)
> >  endif
> > diff --git a/src/file_attr.c b/src/file_attr.c
> > new file mode 100644
> > index 000000000000..9756ab265a57
> > --- /dev/null
> > +++ b/src/file_attr.c
> > @@ -0,0 +1,277 @@
> > +#include "global.h"
> > +#include <sys/syscall.h>
> > +#include <getopt.h>
> > +#include <errno.h>
> > +#include <linux/fs.h>
> > +#include <sys/stat.h>
> > +#include <string.h>
> > +#include <getopt.h>
> > +#include <stdlib.h>
> > +#include <unistd.h>
> > +
> > +#ifndef HAVE_FILE_ATTR
> > +#define __NR_file_getattr 468
> > +#define __NR_file_setattr 469
> > +
> > +struct file_attr {
> > +       __u32           fa_xflags;     /* xflags field value (get/set) */
> > +       __u32           fa_extsize;    /* extsize field value (get/set)*/
> > +       __u32           fa_nextents;   /* nextents field value (get)   */
> > +       __u32           fa_projid;     /* project identifier (get/set) */
> > +       __u32           fa_cowextsize; /* CoW extsize field value (get/set) */
> > +};
> > +
> > +#endif
> > +
> > +#define SPECIAL_FILE(x) \
> > +	   (S_ISCHR((x)) \
> > +	|| S_ISBLK((x)) \
> > +	|| S_ISFIFO((x)) \
> > +	|| S_ISLNK((x)) \
> > +	|| S_ISSOCK((x)))
> > +
> > +static struct option long_options[] = {
> > +	{"set",			no_argument,	0,	's' },
> > +	{"get",			no_argument,	0,	'g' },
> > +	{"no-follow",		no_argument,	0,	'n' },
> > +	{"at-cwd",		no_argument,	0,	'a' },
> > +	{"set-nodump",		no_argument,	0,	'd' },
> > +	{"invalid-at",		no_argument,	0,	'i' },
> > +	{"too-big-arg",		no_argument,	0,	'b' },
> > +	{"too-small-arg",	no_argument,	0,	'm' },
> > +	{"new-fsx-flag",	no_argument,	0,	'x' },
> > +	{0,			0,		0,	0 }
> > +};
> > +
> > +static struct xflags {
> > +	uint	flag;
> > +	char	*shortname;
> > +	char	*longname;
> > +} xflags[] = {
> > +	{ FS_XFLAG_REALTIME,		"r", "realtime"		},
> > +	{ FS_XFLAG_PREALLOC,		"p", "prealloc"		},
> > +	{ FS_XFLAG_IMMUTABLE,		"i", "immutable"	},
> > +	{ FS_XFLAG_APPEND,		"a", "append-only"	},
> > +	{ FS_XFLAG_SYNC,		"s", "sync"		},
> > +	{ FS_XFLAG_NOATIME,		"A", "no-atime"		},
> > +	{ FS_XFLAG_NODUMP,		"d", "no-dump"		},
> > +	{ FS_XFLAG_RTINHERIT,		"t", "rt-inherit"	},
> > +	{ FS_XFLAG_PROJINHERIT,		"P", "proj-inherit"	},
> > +	{ FS_XFLAG_NOSYMLINKS,		"n", "nosymlinks"	},
> > +	{ FS_XFLAG_EXTSIZE,		"e", "extsize"		},
> > +	{ FS_XFLAG_EXTSZINHERIT,	"E", "extsz-inherit"	},
> > +	{ FS_XFLAG_NODEFRAG,		"f", "no-defrag"	},
> > +	{ FS_XFLAG_FILESTREAM,		"S", "filestream"	},
> > +	{ FS_XFLAG_DAX,			"x", "dax"		},
> > +	{ FS_XFLAG_COWEXTSIZE,		"C", "cowextsize"	},
> > +	{ FS_XFLAG_HASATTR,		"X", "has-xattr"	},
> > +	{ 0, NULL, NULL }
> > +};
> > +
> > +static int
> > +file_getattr(
> > +		int			dfd,
> > +		const char		*filename,
> > +		struct file_attr	*fsx,
> > +		size_t			usize,
> > +		unsigned int		at_flags)
> > +{
> > +	return syscall(__NR_file_getattr, dfd, filename, fsx, usize, at_flags);
> > +}
> > +
> > +static int
> > +file_setattr(
> > +		int			dfd,
> > +		const char		*filename,
> > +		struct file_attr	*fsx,
> > +		size_t			usize,
> > +		unsigned int		at_flags)
> > +{
> > +	return syscall(__NR_file_setattr, dfd, filename, fsx, usize, at_flags);
> > +}
> > +
> > +void
> > +printxattr(
> > +	uint		flags,
> > +	int		verbose,
> > +	int		dofname,
> > +	const char	*fname,
> > +	int		dobraces,
> > +	int		doeol)
> > +{
> > +	struct xflags	*p;
> > +	int		first = 1;
> > +
> > +	if (dobraces)
> > +		fputs("[", stdout);
> > +	for (p = xflags; p->flag; p++) {
> > +		if (flags & p->flag) {
> > +			if (verbose) {
> > +				if (first)
> > +					first = 0;
> > +				else
> > +					fputs(", ", stdout);
> > +				fputs(p->longname, stdout);
> > +			} else {
> > +				fputs(p->shortname, stdout);
> > +			}
> > +		} else if (!verbose) {
> > +			fputs("-", stdout);
> > +		}
> > +	}
> > +	if (dobraces)
> > +		fputs("]", stdout);
> > +	if (dofname)
> > +		printf(" %s ", fname);
> > +	if (doeol)
> > +		fputs("\n", stdout);
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +	int error;
> > +	int c;
> > +	const char *path = NULL;
> > +	const char *path1 = NULL;
> > +	const char *path2 = NULL;
> > +	unsigned int at_flags = 0;
> > +	unsigned int fa_xflags = 0;
> > +	int action = 0; /* 0 get; 1 set */
> > +	struct file_attr fsx = { };
> > +	int fa_size = sizeof(struct file_attr);
> > +	struct stat status;
> > +	int fd;
> > +	int at_fdcwd = 0;
> > +	int unknwon_fa_flag = 0;
> > +
> > +        while (1) {
> > +            int option_index = 0;
> > +
> > +            c = getopt_long_only(argc, argv, "", long_options, &option_index);
> > +            if (c == -1)
> > +                break;
> > +
> > +            switch (c) {
> > +	    case 's':
> > +		action = 1;
> > +		break;
> > +	    case 'g':
> > +		action = 0;
> > +		break;
> > +	    case 'n':
> > +		at_flags |= AT_SYMLINK_NOFOLLOW;
> > +		break;
> > +	    case 'a':
> > +		at_fdcwd = 1;
> > +		break;
> > +	    case 'd':
> > +		fa_xflags |= FS_XFLAG_NODUMP;
> > +		break;
> > +	    case 'i':
> > +		at_flags |= (1 << 25);
> > +		break;
> > +	    case 'b':
> > +		fa_size = getpagesize() + 1; /* max size if page size */
> > +		break;
> > +	    case 'm':
> > +		fa_size = 19; /* VER0 size of fsxattr is 20 */
> > +		break;
> > +	    case 'x':
> > +		unknwon_fa_flag = (1 << 27);
> > +		break;
> > +	    default:
> > +		goto usage;
> > +            }
> > +        }
> > +
> > +	if (!path1 && optind < argc)
> > +		path1 = argv[optind++];
> > +	if (!path2 && optind < argc)
> > +		path2 = argv[optind++];
> > +
> > +	if (at_fdcwd) {
> > +		fd = AT_FDCWD;
> > +		path = path1;
> > +	} else if (!path2) {
> > +		error = stat(path1, &status);
> > +		if (error) {
> > +			fprintf(stderr,
> > +"Can not get file status of %s: %s\n", path1, strerror(errno));
> > +			return error;
> > +		}
> > +
> > +		if (SPECIAL_FILE(status.st_mode)) {
> > +			fprintf(stderr,
> > +"Can not open special file %s without parent dir: %s\n", path1, strerror(errno));
> > +			return errno;
> > +		}
> > +
> > +		fd = open(path1, O_RDONLY);
> > +		if (fd == -1) {
> > +			fprintf(stderr, "Can not open %s: %s\n", path1,
> > +					strerror(errno));
> > +			return errno;
> > +		}
> > +	} else {
> > +		fd = open(path1, O_RDONLY);
> > +		if (fd == -1) {
> > +			fprintf(stderr, "Can not open %s: %s\n", path1,
> > +					strerror(errno));
> > +			return errno;
> > +		}
> > +		path = path2;
> > +	}
> > +
> > +	if (!path)
> > +		at_flags |= AT_EMPTY_PATH;
> > +
> > +	if (action) {
> > +		error = file_getattr(fd, path, &fsx, fa_size,
> > +				at_flags);
> > +		if (error) {
> > +			fprintf(stderr, "Can not get fsxattr on %s: %s\n", path,
> > +					strerror(errno));
> > +			return error;
> > +		}
> > +
> > +		fsx.fa_xflags |= (fa_xflags | unknwon_fa_flag);
> > +
> > +		error = file_setattr(fd, path, &fsx, fa_size,
> > +				at_flags);
> > +		if (error) {
> > +			fprintf(stderr, "Can not set fsxattr on %s: %s\n", path,
> > +					strerror(errno));
> > +			return error;
> > +		}
> > +	} else {
> > +		error = file_getattr(fd, path, &fsx, fa_size,
> > +				at_flags);
> > +		if (error) {
> > +			fprintf(stderr, "Can not get fsxattr on %s: %s\n", path,
> > +					strerror(errno));
> > +			return error;
> > +		}
> 
> Can the file_getattr be lifted above the if (action) ?

yup

> 
> > +
> > +		if (path2)
> > +			printxattr(fsx.fa_xflags, 0, 1, path, 0, 1);
> > +		else
> > +			printxattr(fsx.fa_xflags, 0, 1, path1, 0, 1);
> > +	}
> > +
> > +	return error;
> > +
> > +usage:
> > +	printf("Usage: %s [options]\n", argv[0]);
> > +	printf("Options:\n");
> > +	printf("\t--get\t\tget filesystem inode attributes\n");
> > +	printf("\t--set\t\tset filesystem inode attributes\n");
> > +	printf("\t--at-cwd\t\topen file at current working directory\n");
> > +	printf("\t--no-follow\t\tdon't follow symlinks\n");
> > +	printf("\t--set-nodump\t\tset FS_XFLAG_NODUMP on an inode\n");
> > +	printf("\t--invalid-at\t\tUse invalida AT_* flag\n");
> > +	printf("\t--too-big-arg\t\tSet fsxattr size bigger than PAGE_SIZE\n");
> > +	printf("\t--too-small-arg\t\tSet fsxattr size to 27 bytes\n");
> 
> 27?  I thought you put in 19 above?

ops, forgot to update it here

> 
> Also it'd be nice if the help listed the short and long versions.
> 
> (Or skip the short cli switches ;))

will add short versions

> 
> --D
> 
> > +	printf("\t--new-fsx-flag\t\tUse unknown fa_flags flag\n");
> > +
> > +	return 1;
> > +}
> > 
> > -- 
> > 2.49.0
> > 
> > 
> 

-- 
- Andrey

