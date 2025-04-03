Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18EC1DFF0
	for <linux-xfs@vger.kernel.org>; Thu,  3 Apr 2025 02:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743647310; cv=none; b=j32xtrXgXDOwpVs2KIwwxWeFpoLRKlAnufLaDCLC7LmeIrYEGWSgZWphbNdn5OTeKtHk5kX6R7nfGLTOCiBL35pjHEr72DnCtgVOEOXlaSikIXqmS1ZAGh58opPaUP5H99sTBfOG2l9vSl0ojxGkNYiBGLBL/4HGmy8zTCYRbgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743647310; c=relaxed/simple;
	bh=ENPObbhZOoHyzpjjxzts6KJUvUfBFBGJ6cGzEyjmNE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ciUqRWcHTs8kPe+07xca6PuKi5KKPfSCcapdgm2LHxJTXUfHHPAciBj5TlfW5aeUY4vQlH36aJ1o+iDLCqATWpyUpKpGi8CL1XbVIgd2cGZB41CF37crbETG5Spn8kIeo8OSljWBRB8EPH4ns3q5D3pPE7ouwTNA7PtxRzJEYvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUSbTEMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUSbTEMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0610C4CEDD;
	Thu,  3 Apr 2025 02:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743647309;
	bh=ENPObbhZOoHyzpjjxzts6KJUvUfBFBGJ6cGzEyjmNE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SUSbTEMwHAY8DipIgK/1jB0S8cLKwZPFP/QG8MwBMRoVk2wmk57rWy6IdreIiOB8O
	 2i786ukJ5FAnoCUv5Sj8x29ZIuXb+Xtvun/nArBT9pTUDyNE4fze0mN+qQVQjNGxCN
	 EWkvx9BX+LFCF0J5qcHNznWCVH06hEABI7BH0lP8X6pIhrwi1q9U2Ie6OI3DyIz6N0
	 7oCsE0Tn/13MNtuxmDS9g6u0A+1IT8S/dZAbvS07il5PBty3utNaOgv8NEVYdqK3sl
	 9h9aAm2vUmC3fuCd77Ex19h3VSOhtf7XP3MCaM1Rlc24H0DXVfaIXiOWZq0sLLy/+D
	 udiwcCmYsWAcw==
Date: Wed, 2 Apr 2025 19:28:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC] xfs_io: Add cachestat syscall support
Message-ID: <20250403022829.GA6283@frogsfrogsfrogs>
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

On Mon, Mar 17, 2025 at 12:15:29AM +0530, Ritesh Harjani (IBM) wrote:
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

Just out of curiosity, is there a manpage change for xfs_io.8 that goes
with this new subcommand?

--D

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
> +	.oneline	= "find page cache pages for a given file",
> +};
> +
> +void cachestat_init(void)
> +{
> +	add_command(&cachestat_cmd);
> +}
> +
> diff --git a/io/init.c b/io/init.c
> index 4831deae..49e9e7cb 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -49,6 +49,7 @@ init_commands(void)
>  	bmap_init();
>  	bulkstat_init();
>  	copy_range_init();
> +	cachestat_init();
>  	cowextsize_init();
>  	encrypt_init();
>  	fadvise_init();
> diff --git a/io/io.h b/io/io.h
> index d9906558..259c0349 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -132,6 +132,12 @@ extern void		copy_range_init(void);
>  #define copy_range_init()	do { } while (0)
>  #endif
>  
> +#ifdef HAVE_CACHESTAT
> +extern void cachestat_init(void);
> +#else
> +#define cachestat_init() do { } while (0)
> +#endif
> +
>  extern void		sync_range_init(void);
>  extern void		readdir_init(void);
>  extern void		reflink_init(void);
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index 4ef7e8f6..af9da812 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -35,6 +35,25 @@ syscall(__NR_copy_file_range, 0, 0, 0, 0, 0, 0);
>      AC_SUBST(have_copy_file_range)
>    ])
>  
> +#
> +# Check if we have a cachestat system call (Linux)
> +#
> +AC_DEFUN([AC_HAVE_CACHESTAT],
> +  [ AC_MSG_CHECKING([for cachestat])
> +    AC_LINK_IFELSE(
> +    [	AC_LANG_PROGRAM([[
> +#include <unistd.h>
> +#include <linux/mman.h>
> +#include <asm/unistd.h>
> +	]], [[
> +syscall(__NR_cachestat, 0, 0, 0, 0);
> +	]])
> +    ], have_cachestat=yes
> +       AC_MSG_RESULT(yes),
> +       AC_MSG_RESULT(no))
> +    AC_SUBST(have_cachestat)
> +  ])
> +
>  #
>  # Check if we need to override the system struct fsxattr with
>  # the internal definition.  This /only/ happens if the system
> -- 
> 2.48.1
> 
> 
