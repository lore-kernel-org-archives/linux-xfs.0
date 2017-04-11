Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54430 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751997AbdDKSd7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 14:33:59 -0400
Date: Tue, 11 Apr 2017 14:33:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] mdrestore: warn about corruption if log is dirty
Message-ID: <20170411183356.GB3865@bfoster.bfoster>
References: <20170411141237.9274-1-jtulak@redhat.com>
 <20170411141237.9274-3-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170411141237.9274-3-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Tue, Apr 11, 2017 at 04:12:37PM +0200, Jan Tulak wrote:
> A dirty log in an obfuscated dump means that a corruption can happen
> when replaying the log (which contains unobfuscated data). Warn the user
> about this possibility.
> 
> The xlog workaround is copy&paste solution from repair/phase2.c and
> other tools, because the function is not implemented in libxlog.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mdrestore/Makefile        |  4 +--
>  mdrestore/xfs_mdrestore.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 86 insertions(+), 2 deletions(-)
> 
> diff --git a/mdrestore/Makefile b/mdrestore/Makefile
> index 5171306..6355df9 100644
> --- a/mdrestore/Makefile
> +++ b/mdrestore/Makefile
> @@ -8,8 +8,8 @@ include $(TOPDIR)/include/builddefs
>  LTCOMMAND = xfs_mdrestore
>  CFILES = xfs_mdrestore.c
>  
> -LLDLIBS = $(LIBXFS) $(LIBRT) $(LIBPTHREAD) $(LIBUUID)
> -LTDEPENDENCIES = $(LIBXFS)
> +LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBRT) $(LIBPTHREAD) $(LIBUUID)
> +LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
>  LLDFLAGS = -static
>  

FYI, I get the following on a 'make -j 4':

...
Building mdrestore
gmake[3]: *** No rule to make target '../libxlog/libxlog.la', needed by 'xfs_mdrestore'.  Stop.
gmake[3]: *** Waiting for unfinished jobs....

It succeeds if I restart the build so I suspect something might be up
with the dependency tracking here.

>  default: depend $(LTCOMMAND)
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 0d399f1..3797955 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -17,6 +17,7 @@
>   */
>  
>  #include "libxfs.h"
> +#include "libxlog.h"
>  #include "xfs_metadump.h"
>  
>  char 		*progname;
> @@ -190,6 +191,87 @@ perform_restore(
>  	free(metablock);
>  }
>  
> +/* workaround craziness in the xlog routines */
> +int xlog_recover_do_trans(struct xlog *log, xlog_recover_t *t, int p)
> +{
> +	return 0;
> +}
> +
> +/*
> + * Warn if we just wrote a dump with a dirty log.
> + */
> +void
> +test_dirty_log(
> +	bool	is_target_file,
> +	char*	target_name)
> +{
> +	struct xfs_sb	*sbp;
> +	struct xfs_buf	*bp;
> +	struct xfs_mount	xmount;
> +	struct xfs_mount	*mp;
> +	struct xlog		xlog;
> +	libxfs_init_t		x;
> +
> +	x.isreadonly = LIBXFS_ISREADONLY;
> +	if (is_target_file) {
> +		x.dname = target_name;
> +		x.disfile = true;
> +	} else {
> +		x.disfile = false;
> +		x.volname = target_name;
> +	}
> +
> +	if (!libxfs_init(&x)) {
> +		fatal(_("\nfatal error -- couldn't initialize XFS library\n"),
> +		      strerror(errno));
> +	}
> +
> +	memset(&xmount, 0, sizeof(struct xfs_mount));
> +	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev);
> +	bp = libxfs_readbuf(xmount.m_ddev_targp, XFS_SB_DADDR,
> +			    1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
> +
> +	if (!bp || bp->b_error) {
> +		fprintf(stderr, _("%s: %s is invalid (cannot read first 512 "
> +			"bytes)\n"), progname, target_name);
> +		exit(1);
> +	}
> +
> +	/* copy SB from buffer to in-core, converting architecture as we go */
> +	libxfs_sb_from_disk(&xmount.m_sb, XFS_BUF_TO_SBP(bp));
> +	libxfs_putbuf(bp);
> +	libxfs_purgebuf(bp);
> +
> +	sbp = &xmount.m_sb;
> +	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
> +			  LIBXFS_MOUNT_DEBUGGER);
> +	if (!mp) {
> +		fprintf(stderr,
> +			_("%s: restored device %s unusable (not an XFS filesystem?)\n"),
> +			progname, target_name);
> +		exit(1);
> +	}

It might be cleaner to bury all of this init stuff in a separate init
function to be called before the log check. We also may not want to exit
the program if parsing the log or something happens to fail, given that
this is a debug tool.

> +
> +	switch (xlog_is_dirty(mp, &xlog, &x,0)) {
> +		case -1:
> +			/* An error occured and we can't read the log. */
> +			fprintf(stderr,
> +			_("Warning: can't discern a log.\n"));
> +			break;
> +		case 1:
> +			/* The log is dirty, warn. */
> +			fprintf(stderr,
> +			_("Warning: The log is dirty. If the image was obfuscated, "
> +			  "an attempt to replay the log may lead to corruption.\n"));
> +			break;

Then the above can remain in the test_log_dirty() helper or just be
open-coded at the end of main(), provided the mount was initialized
successfully (or we could still warn if we can't make sense of the log).

BTW, this is going to warn on every xfs_mdrestore of an image with a
dirty log, right? That is slightly unfortunate, if so. Do we have any
method to track or determine whether an image is obfuscated (I'm
guessing not easily...)?

Brian

> +		case 0:
> +			 /* Everything is ok. */
> +			break;
> +	}
> +
> +}
> +
> +
>  static void
>  usage(void)
>  {
> @@ -271,5 +353,7 @@ main(
>  	if (src_f != stdin)
>  		fclose(src_f);
>  
> +	test_dirty_log(is_target_file, argv[optind]);
> +
>  	return 0;
>  }
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
