Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C661B214A97
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 17:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754934262; cv=none; b=E6BjJ8M9cIhFHU/Cr684IrZxz+x6uckmiRJzaRsLDVnxEHZ/Sx22KIkPstV6V8MGQY6w9WHJI0YvSugRVo0arb6DDRLUuKyY3C4JMvLrSP8BHs4PwQ0tcaEmSXUVz6WBRpCr1hXH3G2oBsHSR5Yd/AZg5JIEjn2l4w+Qsgwyusk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754934262; c=relaxed/simple;
	bh=Yg7/15SyVmNKTWlbWZIhj668dQ6JI7v+FwzjvRPxa0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q3kD/So/PWlyU4tjfBKdTpZbFrjeKdVK4NNbr+2m2pcfHacbXjTWQErwuABYc1FzlP58VvuCljC3DaBX8rU8jRksY16z/9j6gUG0aHVfkiqsCA2MZ+GpLrcTaA3FIePZYuOxBAmplvndNazAP1r4zFk9m8MdHeueg4M0DhehZBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dvpnvzUt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dvpnvzUt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754934259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QgbOrYuuMLt64re/iGFNnABNTs6YIiJamghccn9AX1A=;
	b=dvpnvzUtmjUV5boBUn1mXLolDgiw2tnpjJiMbK/mUxVnn/zUvyjE3vSnPjx5MHUfcuAU2w
	mprlfYI/qb7rKBK13DRYYRRH4wjYaoDWyl1PI/cfUA1jMkFeJWKzhX0MtOVilTUUCvIp0T
	48QXNUf/G5Q3CvKmX1cSyiREBIpxH98=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-abXI1LsZP0qff9vOEmvY9w-1; Mon, 11 Aug 2025 13:44:18 -0400
X-MC-Unique: abXI1LsZP0qff9vOEmvY9w-1
X-Mimecast-MFC-AGG-ID: abXI1LsZP0qff9vOEmvY9w_1754934257
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459d7ed90baso37093845e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 10:44:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754934256; x=1755539056;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QgbOrYuuMLt64re/iGFNnABNTs6YIiJamghccn9AX1A=;
        b=XIazwdEQPv5GeQnoW3aW41ZCjT2C98jw/UxIhJcH0fZLV1D0Q2Xwm4rUBSNBm+IUUX
         5Z+ZvgakMsHrj7skiE6N+J9k6ZHx7LPE9YLmrALisY5WV0rijZigkwC1CjjmSjY/7Abh
         aU+aZ+wi8BJJxaldcZX/ouhPiOId93PJriYUIDC/oE1/J0kmhiFlykoKv1psyC6sJG1n
         +XspbGBQmf8doMHkSefBO1O1ZPlKJ0SSEUYQTEEOdRyms/+jcm89CMY8ugr8pR2wKNvO
         H6OXcgfQvuBda6uqrXn1ChDg6Gf0LXL8MLo3njAIMqnD/T3XQyJGfWwbZQihMDi5F0Lp
         5pyQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPfVpFAPN/arqFcjM/sje15NjlCnbS+wRZ/HRJ+/Jy+0/AiYoCoHLqBf3N1iBSTZsC7LemjI61JDw=@vger.kernel.org
X-Gm-Message-State: AOJu0YytUFow/gH4vJfjcUlKz5gPC4IzvwPuL+8vHGeUT4Dk++eeL8nA
	hDmghW0jSGpIB59qopHpuUM9KuXaLbZ19PA61GWbCXo/M+ZnR1HXpSKDT2yKl0IZ25kPMU/6MTA
	Mh59yU3yGd1kQJkHczY1UM5XUdqnH26YI/y7NFrzyDXKjpmp+HkdL5PhnCtdkmFzAhP9B
X-Gm-Gg: ASbGncugj/S/Td8bZdwLEedHyOQAOeTYhvzNhP1QkatH/zYqMDm7aSqO1W461Go8dAW
	A53yM/xXKkfxIWWdd87B5h4LTztm94blN8gwX8Fgc6k23HMT9cMBcgmju6Rd0QLewTL9yLQT5p/
	vSG3c1AVp0klzE1QbvkaGaKzNVbbwAaAnh1lMVKQV/shMM9+rPEsRGSjfehdK1CYlpJ3Hb8W33C
	Ejl997mU2UEvqqd8PHx+o+lbMjEb90JkDkBAaNKdfWulXwlmBz3wBWBZ2pYoZYv2OBYU9XoWmeb
	qx+V8Gy4WVGc4vFsfWp09h+jiMX0EPTAfx1rtgd0JTMO0tvul/4dF/M9OXI=
X-Received: by 2002:a05:600c:a085:b0:456:11cc:360d with SMTP id 5b1f17b1804b1-459f7a5d1f4mr115649795e9.9.1754934256212;
        Mon, 11 Aug 2025 10:44:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPxM2tIr1vMf/A56ETeWMzOAkQWmc6oE7WWLbyUF+RekLytfzSXrIgxuptZugtVcYka00eOg==
X-Received: by 2002:a05:600c:a085:b0:456:11cc:360d with SMTP id 5b1f17b1804b1-459f7a5d1f4mr115649435e9.9.1754934255704;
        Mon, 11 Aug 2025 10:44:15 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4595cfea56fsm225747475e9.1.2025.08.11.10.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 10:44:15 -0700 (PDT)
Date: Mon, 11 Aug 2025 19:44:14 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] libfrog: add wrappers for file_getattr/file_setattr
 syscalls
Message-ID: <echftqsxxxecifnok2j3tbel377ds7cud2cm5kjc5qbtwszn2m@retzo6pcntfv>
References: <20250808-xattrat-syscall-v1-0-48567c29e45c@kernel.org>
 <20250808-xattrat-syscall-v1-1-48567c29e45c@kernel.org>
 <20250811150242.GA7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811150242.GA7965@frogsfrogsfrogs>

On 2025-08-11 08:02:42, Darrick J. Wong wrote:
> On Fri, Aug 08, 2025 at 09:30:16PM +0200, Andrey Albershteyn wrote:
> > Add wrappers for new file_getattr/file_setattr inode syscalls which will
> > be used by xfs_quota and xfs_io.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  configure.ac          |   1 +
> >  include/builddefs.in  |   5 +++
> >  include/linux.h       |  20 ++++++++++
> >  libfrog/Makefile      |   2 +
> >  libfrog/file_attr.c   | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  libfrog/file_attr.h   |  35 +++++++++++++++++
> >  m4/package_libcdev.m4 |  19 +++++++++
> >  7 files changed, 187 insertions(+)
> > 
> > diff --git a/configure.ac b/configure.ac
> > index 9a3309bcdfd1..40a44c571e7b 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -156,6 +156,7 @@ AC_PACKAGE_NEED_RCU_INIT
> >  AC_HAVE_PWRITEV2
> >  AC_HAVE_COPY_FILE_RANGE
> >  AC_HAVE_CACHESTAT
> > +AC_HAVE_FILE_ATTR
> >  AC_NEED_INTERNAL_FSXATTR
> >  AC_NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG
> >  AC_NEED_INTERNAL_FSCRYPT_POLICY_V2
> > diff --git a/include/builddefs.in b/include/builddefs.in
> > index 04b4e0880a84..d727b55b854f 100644
> > --- a/include/builddefs.in
> > +++ b/include/builddefs.in
> > @@ -97,6 +97,7 @@ HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
> >  HAVE_PWRITEV2 = @have_pwritev2@
> >  HAVE_COPY_FILE_RANGE = @have_copy_file_range@
> >  HAVE_CACHESTAT = @have_cachestat@
> > +HAVE_FILE_ATTR = @have_file_attr@
> >  NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
> >  NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG = @need_internal_fscrypt_add_key_arg@
> >  NEED_INTERNAL_FSCRYPT_POLICY_V2 = @need_internal_fscrypt_policy_v2@
> > @@ -169,6 +170,10 @@ ifeq ($(ENABLE_GETTEXT),yes)
> >  GCFLAGS += -DENABLE_GETTEXT
> >  endif
> >  
> > +ifeq ($(HAVE_FILE_ATTR),yes)
> > +LCFLAGS += -DHAVE_FILE_ATTR
> > +endif
> > +
> >  # Override these if C++ needs other options
> >  SANITIZER_CXXFLAGS = $(SANITIZER_CFLAGS)
> >  GCXXFLAGS = $(GCFLAGS)
> > diff --git a/include/linux.h b/include/linux.h
> > index 6e83e073aa2e..018cc78960e3 100644
> > --- a/include/linux.h
> > +++ b/include/linux.h
> > @@ -16,6 +16,7 @@
> >  #include <sys/param.h>
> >  #include <sys/sysmacros.h>
> >  #include <sys/stat.h>
> > +#include <sys/syscall.h>
> >  #include <inttypes.h>
> >  #include <malloc.h>
> >  #include <getopt.h>
> > @@ -202,6 +203,25 @@ struct fsxattr {
> >  };
> >  #endif
> >  
> > +/*
> > + * Use __NR_file_getattr instead of build system HAVE_FILE_ATTR as this header
> > + * could be included in other places where HAVE_FILE_ATTR is not defined (e.g.
> > + * xfstests's conftest.c in ./configure)
> > + */
> > +#ifndef __NR_file_getattr
> 
> Seeing as uapi fs.h now has:
> 
> #define FILE_ATTR_SIZE_VER0 24
> #define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER0
> 
> I wonder if you'd be better off gating on one of those defines rather
> than the presence of the syscall number?

Hmm, yeah, should work

> 
> > +/*
> > + * We need to define file_attr if it's missing to know how to convert it to
> > + * fsxattr
> > + */
> > +struct file_attr {
> > +	__u32		fa_xflags;
> > +	__u32		fa_extsize;
> > +	__u32		fa_nextents;
> > +	__u32		fa_projid;
> > +	__u32		fa_cowextsize;
> > +};
> > +#endif
> > +
> >  #ifndef FS_IOC_FSGETXATTR
> >  /*
> >   * Flags for the fsx_xflags field
> > diff --git a/libfrog/Makefile b/libfrog/Makefile
> > index b64ca4597f4e..7d49fd0fe6cc 100644
> > --- a/libfrog/Makefile
> > +++ b/libfrog/Makefile
> > @@ -24,6 +24,7 @@ fsproperties.c \
> >  fsprops.c \
> >  getparents.c \
> >  histogram.c \
> > +file_attr.c \
> >  list_sort.c \
> >  linux.c \
> >  logging.c \
> > @@ -55,6 +56,7 @@ fsprops.h \
> >  getparents.h \
> >  handle_priv.h \
> >  histogram.h \
> > +file_attr.h \
> >  logging.h \
> >  paths.h \
> >  projects.h \
> > diff --git a/libfrog/file_attr.c b/libfrog/file_attr.c
> > new file mode 100644
> > index 000000000000..8592d775f554
> > --- /dev/null
> > +++ b/libfrog/file_attr.c
> > @@ -0,0 +1,105 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2024 Red Hat, Inc.
> > + * All Rights Reserved.
> > + */
> > +
> > +#include "file_attr.h"
> > +#include <stdio.h>
> > +#include <errno.h>
> > +#include <string.h>
> > +#include <sys/syscall.h>
> > +#include <asm/types.h>
> > +#include <fcntl.h>
> > +
> > +static void
> > +file_attr_to_fsxattr(
> > +	const struct file_attr	*fa,
> > +	struct fsxattr		*fsxa)
> > +{
> > +     memset(fsxa, 0, sizeof(struct fsxattr));
> > +
> > +     fsxa->fsx_xflags = fa->fa_xflags;
> > +     fsxa->fsx_extsize = fa->fa_extsize;
> > +     fsxa->fsx_nextents = fa->fa_nextents;
> > +     fsxa->fsx_projid = fa->fa_projid;
> > +     fsxa->fsx_cowextsize = fa->fa_cowextsize;
> > +
> > +}
> > +
> > +static void
> > +fsxattr_to_file_attr(
> > +	const struct fsxattr	*fsxa,
> > +	struct file_attr	*fa)
> > +{
> > +     memset(fa, 0, sizeof(struct file_attr));
> > +
> > +     fa->fa_xflags = fsxa->fsx_xflags;
> > +     fa->fa_extsize = fsxa->fsx_extsize;
> > +     fa->fa_nextents = fsxa->fsx_nextents;
> > +     fa->fa_projid = fsxa->fsx_projid;
> > +     fa->fa_cowextsize = fsxa->fsx_cowextsize;
> > +}
> > +
> > +int
> > +file_getattr(
> > +	const int		dfd,
> > +	const char		*path,
> > +	const struct stat	*stat,
> > +	struct file_attr	*fa,
> > +	const unsigned int	at_flags)
> > +{
> 
> Will this cause a naming conflict when libc wraps the new syscall?

xfrog_file_getattr?

> 
> > +	int			error;
> > +	int			fd;
> > +	struct fsxattr		fsxa;
> > +
> > +#ifdef HAVE_FILE_ATTR
> > +	return syscall(__NR_file_getattr, dfd, path, fa,
> > +			sizeof(struct file_attr), at_flags);
> 
> What happens if we build xfsprogs on new userspace but it then gets run
> on an old kernel that doesn't support file_getattr(2)?  Shouldn't we
> fall back to the old ioctl on ENOSYS?

oh right, missed that. I can add this check.

Is it something common in general? I suppose booting into older
kernel when xfsprogs was compiled with the "current" one is one case
but it's expected that kernel can miss some features

> 
> > +#else
> > +	if (SPECIAL_FILE(stat->st_mode))
> > +		return 0;
> 
> Why does it return 0 without filling out @fa?  Shouldn't this be
> EOPNOTSUPP or something?
> 
> > +#endif
> > +
> > +	fd = open(path, O_RDONLY|O_NOCTTY);
> > +	if (fd == -1)
> > +		return errno;
> > +
> > +	error = ioctl(fd, FS_IOC_FSGETXATTR, &fsxa);
> > +	close(fd);
> > +
> > +	fsxattr_to_file_attr(&fsxa, fa);
> 
> Er... if the ioctl errors out, fsxa will still be uninitialized stack
> garbage, which is (pointlessly) copied to the caller's fa structure.
> 
> > +
> > +	return error;
> 
> I'm confused about the return value of this function.  If the syscall
> or the ioctl fail we'll pass the -1 to the caller and let them access
> errno, but if the open fails we return errno directly?

I was trying to just wrap the old code without changing the output,
I haven't thought too hard about design of this function. I will
apply your suggestion including EOPNOSUPP mentioned in other mail.

> 
> > +}
> > +
> > +int
> > +file_setattr(
> > +	const int		dfd,
> > +	const char		*path,
> > +	const struct stat	*stat,
> > +	struct file_attr	*fa,
> > +	const unsigned int	at_flags)
> > +{
> > +	int			error;
> > +	int			fd;
> > +	struct fsxattr		fsxa;
> > +
> > +#ifdef HAVE_FILE_ATTR
> > +	return syscall(__NR_file_setattr, dfd, path, fa,
> > +			sizeof(struct file_attr), at_flags);
> > +#else
> > +	if (SPECIAL_FILE(stat->st_mode))
> > +		return 0;
> > +#endif
> > +
> > +	fd = open(path, O_RDONLY|O_NOCTTY);
> > +	if (fd == -1)
> > +		return errno;
> 
> Same comments that I had about file_getattr.
> 
> > +
> > +	file_attr_to_fsxattr(fa, &fsxa);
> > +	error = ioctl(fd, FS_IOC_FSSETXATTR, fa);
> > +	close(fd);
> > +
> > +	return error;
> > +}
> > diff --git a/libfrog/file_attr.h b/libfrog/file_attr.h
> > new file mode 100644
> > index 000000000000..3e56e80a6f95
> > --- /dev/null
> > +++ b/libfrog/file_attr.h
> > @@ -0,0 +1,35 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2024 Red Hat, Inc.
> > + * All Rights Reserved.
> > + */
> > +#ifndef __LIBFROG_IXATTR_H__
> > +#define __LIBFROG_IXATTR_H__
> 
> __LIBFROG_FILE_ATTR_H__ ?

ops, right

> 
> --D
> 
> > +
> > +#include "linux.h"
> > +#include <sys/stat.h>
> > +
> > +#define SPECIAL_FILE(x) \
> > +	   (S_ISCHR((x)) \
> > +	|| S_ISBLK((x)) \
> > +	|| S_ISFIFO((x)) \
> > +	|| S_ISLNK((x)) \
> > +	|| S_ISSOCK((x)))
> > +
> > +int
> > +file_getattr(
> > +	const int		dfd,
> > +	const char		*path,
> > +	const struct stat	*stat,
> > +	struct file_attr	*fa,
> > +	const unsigned int	at_flags);
> > +
> > +int
> > +file_setattr(
> > +	const int		dfd,
> > +	const char		*path,
> > +	const struct stat	*stat,
> > +	struct file_attr	*fa,
> > +	const unsigned int	at_flags);
> > +
> > +#endif /* __LIBFROG_IXATTR_H__ */
> > diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> > index 61353d0aa9d5..cb8ff1576d01 100644
> > --- a/m4/package_libcdev.m4
> > +++ b/m4/package_libcdev.m4
> > @@ -274,3 +274,22 @@ AC_DEFUN([AC_PACKAGE_CHECK_LTO],
> >      AC_SUBST(lto_cflags)
> >      AC_SUBST(lto_ldflags)
> >    ])
> > +
> > +#
> > +# Check if we have a file_getattr/file_setattr system call (Linux)
> > +#
> > +AC_DEFUN([AC_HAVE_FILE_ATTR],
> > +  [ AC_MSG_CHECKING([for file_getattr/file_setattr syscalls])
> > +    AC_LINK_IFELSE(
> > +    [	AC_LANG_PROGRAM([[
> > +#define _GNU_SOURCE
> > +#include <sys/syscall.h>
> > +#include <unistd.h>
> > +	]], [[
> > +syscall(__NR_file_getattr, 0, 0, 0, 0, 0);
> > +	]])
> > +    ], have_file_attr=yes
> > +       AC_MSG_RESULT(yes),
> > +       AC_MSG_RESULT(no))
> > +    AC_SUBST(have_file_attr)
> > +  ])
> > 
> > -- 
> > 2.49.0
> > 
> > 
> 

-- 
- Andrey

