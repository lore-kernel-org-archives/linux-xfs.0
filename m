Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D5C17A311
	for <linux-xfs@vger.kernel.org>; Wed, 19 Mar 2025 10:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742379821; cv=none; b=FjH1lrq+By6cu+qFNi2yCEcv+zwlMuZ2GjGLujGeRHDdVk7ReCp7sFB8EriQfdwzuS8wl5Ja8JlMi70SziIOTBFXS7akpg/4npMNF8AtAbjA65e5EqD4483Rq5Jv7BvWrdhslBFJJeIci8VOg1cq+YCVYLFc4bdW27jHMFXsH2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742379821; c=relaxed/simple;
	bh=YvXct0hqD+r7YiH9d4RC0LNaT+uJ/elR0F89Rr3euhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fSvsHS21riMg5THqn8kufVwvgCebLayIkqTKj2QQF36wA65/cbZ69Wo74iMLtJdYP494WFKsSnIIw0q1Howfi9gX0XrZtHWGCmIN0DMLy+LI+Bho9UNOVze5HIzfU6G2RLopIbYCgnvBQyzYJn63yosbuGJmjF3n1mT7vT+LPo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TpjT9371; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TpjT9371"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742379819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mZ+HYyBde15O7DoTfJBGGz9CSfYYlBPd+h7Psc7zw/8=;
	b=TpjT9371o3OFpAH//KnQ0RbW3JQ0i0TfhBcFriXYxh8LkQ3FFTH8Povb1IcKWBDZuQmJEd
	Xn9IhhqRdEMfUEfYOR8i0ddfh4V4LUdvgCPhJbSsEsYxwe9p+5W/xOEfR1wTyDUlJ0TGyF
	RFkxkfclrfmeRda1P7Hro75YVSGyNxc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-7RS-1DrJNDCAsa1eYrqCIg-1; Wed, 19 Mar 2025 06:23:37 -0400
X-MC-Unique: 7RS-1DrJNDCAsa1eYrqCIg-1
X-Mimecast-MFC-AGG-ID: 7RS-1DrJNDCAsa1eYrqCIg_1742379816
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5e6eb748b17so5922410a12.3
        for <linux-xfs@vger.kernel.org>; Wed, 19 Mar 2025 03:23:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742379816; x=1742984616;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZ+HYyBde15O7DoTfJBGGz9CSfYYlBPd+h7Psc7zw/8=;
        b=XIdVme3QSo1NpqcLJWBq4TubAapy/yv0F5z9aRsQ+ESkuldXk4B2cHidxpGkwYgZGP
         sntl0FEIeil6jdjKAYaEj3C2kyUjZAekVXF6oLb99ozrdYdqlqtCRqTKdr8dLW/vyMvJ
         jV1z7hi/ujrMeizLZUMdyLav4EnB8TnUm64mKa5loWZXDHfvs8OJ7JSOCnUV7f5UAkFq
         5h8CbHeja5XXIAXapFQNvHWVXp7wcvaJROwY6sS1ocytAUY6HmiXEGVumCZhTYk4WaSq
         qa7XeDsXk+Qty6aJsQQFmBuPJt7Uzwi3g3EQzWHVekMkRTEGkZ3XdztvEGMbE1CHK/Nx
         cLyA==
X-Gm-Message-State: AOJu0YysVM10Rt2BVOAaSbfcubolX+jQH0aZZ2m4+nFO93QA3pHoMSQQ
	u+69/HApJymWWVq6m6K2DJXA0hmfN1zCNmPG46fUC+yCg4UkYk6qRDvyfg0EqA2d09sc/UbQRzX
	zstvh1SDkr7NiIXNKAv+Zl7ijS0t9NL3O5y7V5wDoi9jxfQRbA17rX4LB
X-Gm-Gg: ASbGncvftv5D7OmzgSW5Wse46A438VGWo5NHiN7y9IHwKl5OCNfjCzMreUUm+7orVJD
	vLFXg+TF26NipuIbKcc3nLQ+C0eHjUvpnju81l6OQOqliNK2h0d5eykT/5CRXYsrVrjNsr1Sne5
	jxBPZ+HtC+dIEHoNJYIrTzL0Wau5Ayxr+UjgTtczU80YQHw5P4VncaiVBC5Vh6E/erJDfRLmeok
	+EDgJo8+QJH+bvHUlKlQZPOdtZYqOf9aTEN9TDumQ6uBSV5gG1XtCCoRcqwAsDY03LS2f7ENxtM
	826CezVOWdOb68he/Vu1io+Rb2u6Om0lCP0=
X-Received: by 2002:a05:6402:2750:b0:5e5:b7d2:d425 with SMTP id 4fb4d7f45d1cf-5eb80cd3dc8mr1692911a12.8.1742379816158;
        Wed, 19 Mar 2025 03:23:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMH8Yx+akcUpD+01dJqedyBK+6LTCmlATHQuwcUGRok+2Sguox89vM5TS7w2HdqV559nJcxQ==
X-Received: by 2002:a05:6402:2750:b0:5e5:b7d2:d425 with SMTP id 4fb4d7f45d1cf-5eb80cd3dc8mr1692893a12.8.1742379815642;
        Wed, 19 Mar 2025 03:23:35 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e816afe26bsm8924630a12.72.2025.03.19.03.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 03:23:35 -0700 (PDT)
Date: Wed, 19 Mar 2025 11:23:34 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC] xfs_io: Add cachestat syscall support
Message-ID: <vivvr34bth3bonb6zd5bmenkscxfp6d3bzxmztkxmxzdazmjm5@c3gk5ebun3mr>
References: <f93cec1c02eefffff7a5182cf2c0333cec600889.1742150405.git.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f93cec1c02eefffff7a5182cf2c0333cec600889.1742150405.git.ritesh.list@gmail.com>

On 2025-03-17 00:15:29, Ritesh Harjani (IBM) wrote:
> This adds -c "cachestat off len" command which uses cachestat() syscall
> [1]. This can provide following pagecache detail for a file.
> 
> - no. of cached pages,
> - no. of dirty pages,
> - no. of pages marked for writeback,
> - no. of evicted pages,
> - no. of recently evicted pages
> 
> [1]: https://lore.kernel.org/all/20230503013608.2431726-3-nphamcs@gmail.com/T/#u
> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  configure.ac          |  1 +
>  include/builddefs.in  |  1 +
>  io/Makefile           |  5 +++
>  io/cachestat.c        | 77 +++++++++++++++++++++++++++++++++++++++++++
>  io/init.c             |  1 +
>  io/io.h               |  6 ++++
>  m4/package_libcdev.m4 | 19 +++++++++++
>  7 files changed, 110 insertions(+)
>  create mode 100644 io/cachestat.c
> 
> diff --git a/configure.ac b/configure.ac
> index 8c76f398..f039bc91 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -154,6 +154,7 @@ AC_PACKAGE_NEED_RCU_INIT
>  
>  AC_HAVE_PWRITEV2
>  AC_HAVE_COPY_FILE_RANGE
> +AC_HAVE_CACHESTAT
>  AC_NEED_INTERNAL_FSXATTR
>  AC_NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG
>  AC_NEED_INTERNAL_FSCRYPT_POLICY_V2
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 82840ec7..fe2a7824 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -95,6 +95,7 @@ HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
>  
>  HAVE_PWRITEV2 = @have_pwritev2@
>  HAVE_COPY_FILE_RANGE = @have_copy_file_range@
> +HAVE_CACHESTAT = @have_cachestat@
>  NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
>  NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG = @need_internal_fscrypt_add_key_arg@
>  NEED_INTERNAL_FSCRYPT_POLICY_V2 = @need_internal_fscrypt_policy_v2@
> diff --git a/io/Makefile b/io/Makefile
> index 14a3fe20..444e2d6a 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -61,6 +61,11 @@ CFILES += copy_file_range.c
>  LCFLAGS += -DHAVE_COPY_FILE_RANGE
>  endif
>  
> +ifeq ($(HAVE_CACHESTAT),yes)
> +CFILES += cachestat.c
> +LCFLAGS += -DHAVE_CACHESTAT
> +endif
> +
>  ifeq ($(ENABLE_EDITLINE),yes)
>  LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
>  endif
> diff --git a/io/cachestat.c b/io/cachestat.c
> new file mode 100644
> index 00000000..9edf3f9a
> --- /dev/null
> +++ b/io/cachestat.c
> @@ -0,0 +1,77 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include "command.h"
> +#include "input.h"
> +#include "init.h"
> +#include "io.h"
> +#include <unistd.h>
> +#include <linux/mman.h>
> +#include <asm/unistd.h>
> +
> +static cmdinfo_t cachestat_cmd;
> +
> +static void print_cachestat(struct cachestat *cs)
> +{
> +	printf(_("Cached: %llu, Dirty: %llu, Writeback: %llu, Evicted: %llu, Recently Evicted: %llu\n"),
> +			cs->nr_cache, cs->nr_dirty, cs->nr_writeback,
> +			cs->nr_evicted, cs->nr_recently_evicted);
> +}
> +
> +static int
> +cachestat_f(int argc, char **argv)
> +{
> +	off_t offset = 0, length = 0;
> +	size_t blocksize, sectsize;
> +	struct cachestat_range cs_range;
> +	struct cachestat cs;
> +
> +	if (argc != 3) {
> +		exitcode = 1;
> +		return command_usage(&cachestat_cmd);
> +	}
> +
> +	init_cvtnum(&blocksize, &sectsize);
> +	offset = cvtnum(blocksize, sectsize, argv[1]);
> +	if (offset < 0) {
> +		printf(_("invalid offset argument -- %s\n"), argv[1]);
> +		exitcode = 1;
> +		return 0;
> +	}
> +
> +	length = cvtnum(blocksize, sectsize, argv[2]);
> +	if (length < 0) {
> +		printf(_("invalid length argument -- %s\n"), argv[2]);
> +		exitcode = 1;
> +		return 0;
> +	}
> +
> +	cs_range.off = offset;
> +	cs_range.len = length;
> +
> +	if (syscall(__NR_cachestat, file->fd, &cs_range, &cs, 0)) {
> +		perror("cachestat");
> +		exitcode = 1;
> +		return 0;
> +	}
> +
> +	print_cachestat(&cs);
> +
> +	return 0;
> +}
> +
> +static cmdinfo_t cachestat_cmd = {
> +	.name		= "cachestat",
> +	.altname	= "cs",
> +	.cfunc		= cachestat_f,
> +	.argmin		= 2,
> +	.argmax		= 2,
> +	.flags		= CMD_NOMAP_OK | CMD_FOREIGN_OK,
> +	.args		= "[off len]",
I suppose [] aren't needed, as those arguments are mandatory. I can
fix while pulling if no v2

> +	.oneline	= "find page cache pages for a given file",
> +};

Otherwise, looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

