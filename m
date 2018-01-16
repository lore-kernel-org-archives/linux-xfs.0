Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42642 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750817AbeAPWHr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Jan 2018 17:07:47 -0500
Subject: Re: [PATCH 24/27] xfs_scrub: fstrim the free areas if there are no
 errors on the filesystem
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520364185.2027.9541960389654762144.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <36955880-90ad-86c3-9db1-59191e267533@sandeen.net>
Date: Tue, 16 Jan 2018 16:07:44 -0600
MIME-Version: 1.0
In-Reply-To: <151520364185.2027.9541960389654762144.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/5/18 7:54 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the filesystem scan comes out clean or fixes all the problems, call
> fstrim to clean out the free areas (if it's an ssd/thinp/whatever).

Is this the right patch header for this patch?

Oh ok, this adds a "repair phase" which is really only implementing
preen for now, which is really only fstrimming at this point.

so:

preen()
  if no errors
     xfs_repair_fs() (IMHO odd to call "repair" on a clean filesystem?)
       fstrim

So I guess what was confusing to me is that you do "preen" work under
"repair" functions.  I get it that they might all be lumped together
in pending work now, but I'm still wrapping my head around what does
and doesn't happen in various modes, and how to recognize that in
the code...


> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  scrub/Makefile    |    1 +
>  scrub/phase4.c    |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  scrub/vfs.c       |   23 +++++++++++++++++++++++
>  scrub/vfs.h       |    2 ++
>  scrub/xfs_scrub.c |   26 +++++++++++++++++++++++++-
>  scrub/xfs_scrub.h |    1 +
>  6 files changed, 104 insertions(+), 1 deletion(-)
>  create mode 100644 scrub/phase4.c
> 
> 
> diff --git a/scrub/Makefile b/scrub/Makefile
> index fd26624..91f99ff 100644
> --- a/scrub/Makefile
> +++ b/scrub/Makefile
> @@ -41,6 +41,7 @@ inodes.c \
>  phase1.c \
>  phase2.c \
>  phase3.c \
> +phase4.c \
>  phase5.c \
>  phase6.c \
>  phase7.c \
> diff --git a/scrub/phase4.c b/scrub/phase4.c
> new file mode 100644
> index 0000000..dadf4de
> --- /dev/null
> +++ b/scrub/phase4.c
> @@ -0,0 +1,52 @@
> +/*
> + * Copyright (C) 2018 Oracle.  All Rights Reserved.
> + *
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +#include <stdio.h>
> +#include <stdint.h>
> +#include <stdbool.h>
> +#include <dirent.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <sys/statvfs.h>
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "list.h"
> +#include "path.h"
> +#include "workqueue.h"
> +#include "xfs_scrub.h"
> +#include "common.h"
> +#include "scrub.h"
> +#include "vfs.h"
> +
> +/* Phase 4: Repair filesystem. */
> +
> +/* Fix everything that needs fixing. */
> +bool
> +xfs_repair_fs(
> +	struct scrub_ctx		*ctx)
> +{
> +	bool				moveon = true;
> +
> +	pthread_mutex_lock(&ctx->lock);
> +	if (moveon && ctx->errors_found == 0)
> +		fstrim(ctx);
> +	pthread_mutex_unlock(&ctx->lock);
> +
> +	return moveon;
> +}
> diff --git a/scrub/vfs.c b/scrub/vfs.c
> index 6a51090..98d356f 100644
> --- a/scrub/vfs.c
> +++ b/scrub/vfs.c
> @@ -219,3 +219,26 @@ _("Could not queue directory scan work."));
>  	free(sftd);
>  	return false;
>  }
> +
> +#ifndef FITRIM
> +struct fstrim_range {
> +	__u64 start;
> +	__u64 len;
> +	__u64 minlen;
> +};
> +#define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
> +#endif

(I wonder if we should move all these "if it ain't available define it"
stuff into a single header file at some point...)

> +
> +/* Call FITRIM to trim all the unused space in a filesystem. */
> +void
> +fstrim(
> +	struct scrub_ctx	*ctx)
> +{
> +	struct fstrim_range	range = {0};
> +	int			error;
> +
> +	range.len = ULLONG_MAX;
> +	error = ioctl(ctx->mnt_fd, FITRIM, &range);
> +	if (error && errno != EOPNOTSUPP && errno != ENOTTY)
> +		perror(_("fstrim"));
> +}

still wondering if we should have an option to skip this, given some device's
horrific performance under fstrim, and/or an other desire to keep an image
whole.

> diff --git a/scrub/vfs.h b/scrub/vfs.h
> index 100eb18..3305159 100644
> --- a/scrub/vfs.h
> +++ b/scrub/vfs.h
> @@ -28,4 +28,6 @@ typedef bool (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
>  bool scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
>  		scan_fs_tree_dirent_fn dirent_fn, void *arg);
>  
> +void fstrim(struct scrub_ctx *ctx);
> +
>  #endif /* XFS_SCRUB_VFS_H_ */
> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> index bc40f3c..7809431 100644
> --- a/scrub/xfs_scrub.c
> +++ b/scrub/xfs_scrub.c
> @@ -340,6 +340,20 @@ _("%sI/O rate: %.1f%s/s in, %.1f%s/s out, %.1f%s/s tot\n"),
>  	return true;
>  }
>  
> +/* Run the preening phase if there are no errors. */
> +static bool
> +preen(
> +	struct scrub_ctx	*ctx)
> +{
> +	if (ctx->errors_found) {
> +		str_info(ctx, ctx->mntpoint,
> +_("Errors found, please re-run with -y."));
> +		return true;
> +	}
> +
> +	return xfs_repair_fs(ctx);
> +}
> +
>  /* Run all the phases of the scrubber. */
>  static bool
>  run_scrub_phases(
> @@ -393,8 +407,18 @@ run_scrub_phases(
>  	/* Run all phases of the scrub tool. */
>  	for (phase = 1, sp = phases; sp->fn; sp++, phase++) {
>  		/* Turn on certain phases if user said to. */
> -		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data)
> +		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data) {
>  			sp->fn = xfs_scan_blocks;
> +		} else if (sp->fn == REPAIR_DUMMY_FN) {
> +			if (ctx->mode == SCRUB_MODE_PREEN) {
> +				sp->descr = _("Preen filesystem.");
> +				sp->fn = preen;
> +			} else if (ctx->mode == SCRUB_MODE_REPAIR) {
> +				sp->descr = _("Repair filesystem.");
> +				sp->fn = xfs_repair_fs;
> +			}
> +			sp->must_run = true;

if must_run is always true here, should it just be initialized in
the structure along w/ the other must_run phases?

> +		}
>  
>  		/* Skip certain phases unless they're turned on. */
>  		if (sp->fn == REPAIR_DUMMY_FN ||
> diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
> index a5cdba8..4a383f1 100644
> --- a/scrub/xfs_scrub.h
> +++ b/scrub/xfs_scrub.h
> @@ -108,5 +108,6 @@ bool xfs_scan_inodes(struct scrub_ctx *ctx);
>  bool xfs_scan_connections(struct scrub_ctx *ctx);
>  bool xfs_scan_blocks(struct scrub_ctx *ctx);
>  bool xfs_scan_summary(struct scrub_ctx *ctx);
> +bool xfs_repair_fs(struct scrub_ctx *ctx);
>  
>  #endif /* XFS_SCRUB_XFS_SCRUB_H_ */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
