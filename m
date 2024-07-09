Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDB77CF18
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 21:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720559938; cv=none; b=aAz3N7WX9lYH4spVlbNRfwbwNhCqhjRc+4VF5SuFHRA0to/GzBigHu8v9B5RXqOY4B/7h7rC7Irq9aNSl+a2FI99+m9A1J65+MWdMvfITKIDzj4HRqY6d1O5uO9mdXyYU8SUwNWRoKP+KrKxpzPZCCIgAeUPpTRsW2NUzD47L9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720559938; c=relaxed/simple;
	bh=ZX+qRsjwJGp0gLrBV4AcXL8KAG2lIBSg1C5IQ5Gw+FU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sr3lu9hmkDQsyIGYFNwiUfoV1FvJ6ptawr8Yhz4oXPlFsF2RIvEw9YKB/HQCOLBkvkb/+yxo4nGiV7EK2Ilc4RzqZcve/ybOfDD7H1DE00N1o86+2phLS0UNI17BvEMgRArsxSWmBy1yaFQVJlqaYqinZTiZ6BwBMVdVHMx5Yjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RwCdW9Qn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RwCdW9Qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75E3C3277B;
	Tue,  9 Jul 2024 21:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720559938;
	bh=ZX+qRsjwJGp0gLrBV4AcXL8KAG2lIBSg1C5IQ5Gw+FU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RwCdW9QnuFlbC+7nR4GGnTkJDQ+ScdvyvV8ZPsa5T+NEa/SL1Env6Kiplpka7ddvi
	 1mbqypAtIN2L883SMSL/R9kdRr3tqYC8GdDXurT2XrYQynqID2EsX0S4SYCDuiRkT2
	 OsD7rRblTLBiymxqstzIrCkbYIEwn4Qnc9UKa7SCR8EVVh8Q5DjB8WM8yi98SIUJgC
	 HbqU6PBmtjEeI6hmoQ/CAlfXpTQJFYr6tZmMTKgLA0x8/0Sa1QvotzAexDTwRDDmFw
	 FqEMvQVHp7kVSMO8Jmvsx/xT6dnhJXLdCBUFGtzBaAhLaWflamoU32biLzZAAsBAqt
	 gSjoFuqqnDLtA==
Date: Tue, 9 Jul 2024 14:18:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfsprogs: introduce defrag command to spaceman
Message-ID: <20240709211857.GY612460@frogsfrogsfrogs>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-2-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240709191028.2329-2-wen.gang.wang@oracle.com>

On Tue, Jul 09, 2024 at 12:10:20PM -0700, Wengang Wang wrote:
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Non-exclusive defragment
> Here we are introducing the non-exclusive manner to defragment a file,
> especially for huge files, without blocking IO to it long.
> Non-exclusive defragmentation divides the whole file into small segments.
> For each segment, we lock the file, defragment the segment and unlock the file.
> Defragmenting the small segment doesn’t take long. File IO requests can get
> served between defragmenting segments before blocked long.  Also we put
> (user adjustable) idle time between defragmenting two consecutive segments to
> balance the defragmentation and file IOs.
> 
> The first patch in the set checks for valid target files
> 
> Valid target files to defrag must:
> 1. be accessible for read/write
> 2. be regular files
> 3. be in XFS filesystem
> 4. the containing XFS has reflink enabled. This is not checked
>    before starting defragmentation, but error would be reported
>    later.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  spaceman/Makefile |   2 +-
>  spaceman/defrag.c | 198 ++++++++++++++++++++++++++++++++++++++++++++++
>  spaceman/init.c   |   1 +
>  spaceman/space.h  |   1 +
>  4 files changed, 201 insertions(+), 1 deletion(-)
>  create mode 100644 spaceman/defrag.c
> 
> diff --git a/spaceman/Makefile b/spaceman/Makefile
> index 1f048d54..9c00b20a 100644
> --- a/spaceman/Makefile
> +++ b/spaceman/Makefile
> @@ -7,7 +7,7 @@ include $(TOPDIR)/include/builddefs
>  
>  LTCOMMAND = xfs_spaceman
>  HFILES = init.h space.h
> -CFILES = info.c init.c file.c health.c prealloc.c trim.c
> +CFILES = info.c init.c file.c health.c prealloc.c trim.c defrag.c
>  LSRCFILES = xfs_info.sh
>  
>  LLDLIBS = $(LIBXCMD) $(LIBFROG)
> diff --git a/spaceman/defrag.c b/spaceman/defrag.c
> new file mode 100644
> index 00000000..c9732984
> --- /dev/null
> +++ b/spaceman/defrag.c
> @@ -0,0 +1,198 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2024 Oracle.
> + * All Rights Reserved.
> + */
> +
> +#include "libxfs.h"
> +#include <linux/fiemap.h>
> +#include <linux/fsmap.h>
> +#include "libfrog/fsgeom.h"
> +#include "command.h"
> +#include "init.h"
> +#include "libfrog/paths.h"
> +#include "space.h"
> +#include "input.h"
> +
> +/* defrag segment size limit in units of 512 bytes */
> +#define MIN_SEGMENT_SIZE_LIMIT 8192 /* 4MiB */
> +#define DEFAULT_SEGMENT_SIZE_LIMIT 32768 /* 16MiB */
> +static int g_segment_size_lmt = DEFAULT_SEGMENT_SIZE_LIMIT;
> +
> +/* size of the defrag target file */
> +static off_t g_defrag_file_size = 0;
> +
> +/* stats for the target file extents before defrag */
> +struct ext_stats {
> +	long	nr_ext_total;
> +	long	nr_ext_unwritten;
> +	long	nr_ext_shared;
> +};
> +static struct ext_stats	g_ext_stats;
> +
> +/*
> + * check if the target is a valid file to defrag
> + * also store file size
> + * returns:
> + * true for yes and false for no
> + */
> +static bool
> +defrag_check_file(char *path)
> +{
> +	struct statfs statfs_s;
> +	struct stat stat_s;
> +
> +	if (access(path, F_OK|W_OK) == -1) {
> +		if (errno == ENOENT)
> +			fprintf(stderr, "file \"%s\" doesn't exist\n", path);
> +		else
> +			fprintf(stderr, "no access to \"%s\", %s\n", path,
> +				strerror(errno));
> +		return false;
> +	}
> +
> +	if (stat(path, &stat_s) == -1) {
> +		fprintf(stderr, "failed to get file info on \"%s\":  %s\n",
> +			path, strerror(errno));
> +		return false;
> +	}
> +
> +	g_defrag_file_size = stat_s.st_size;
> +
> +	if (!S_ISREG(stat_s.st_mode)) {
> +		fprintf(stderr, "\"%s\" is not a regular file\n", path);
> +		return false;
> +	}
> +
> +	if (statfs(path, &statfs_s) == -1) {

statfs is deprecated, please use fstatvfs.

> +		fprintf(stderr, "failed to get FS info on \"%s\":  %s\n",
> +			path, strerror(errno));
> +		return false;
> +	}
> +
> +	if (statfs_s.f_type != XFS_SUPER_MAGIC) {
> +		fprintf(stderr, "\"%s\" is not a xfs file\n", path);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * defragment a file
> + * return 0 if successfully done, 1 otherwise
> + */
> +static int
> +defrag_xfs_defrag(char *file_path) {

defrag_xfs_path() ?

> +	int	max_clone_us = 0, max_unshare_us = 0, max_punch_us = 0;
> +	long	nr_seg_defrag = 0, nr_ext_defrag = 0;
> +	int	scratch_fd = -1, defrag_fd = -1;
> +	char	tmp_file_path[PATH_MAX+1];
> +	char	*defrag_dir;
> +	struct fsxattr	fsx;
> +	int	ret = 0;
> +
> +	fsx.fsx_nextents = 0;
> +	memset(&g_ext_stats, 0, sizeof(g_ext_stats));
> +
> +	if (!defrag_check_file(file_path)) {
> +		ret = 1;
> +		goto out;
> +	}
> +
> +	defrag_fd = open(file_path, O_RDWR);
> +	if (defrag_fd == -1) {

Not sure why you check the path before opening it -- all those file and
statvfs attributes that you collect there can change (or the entire fs
gets unmounted) until you've pinned the fs by opening the file.

> +		fprintf(stderr, "Opening %s failed. %s\n", file_path,
> +			strerror(errno));
> +		ret = 1;
> +		goto out;
> +	}
> +
> +	defrag_dir = dirname(file_path);
> +	snprintf(tmp_file_path, PATH_MAX, "%s/.xfsdefrag_%d", defrag_dir,
> +		getpid());
> +	tmp_file_path[PATH_MAX] = 0;
> +	scratch_fd = open(tmp_file_path, O_CREAT|O_EXCL|O_RDWR, 0600);

O_TMPFILE?  Then you don't have to do this .xfsdefrag_XXX stuff.

> +	if (scratch_fd == -1) {
> +		fprintf(stderr, "Opening temporary file %s failed. %s\n",
> +			tmp_file_path, strerror(errno));
> +		ret = 1;
> +		goto out;
> +	}
> +out:
> +	if (scratch_fd != -1) {
> +		close(scratch_fd);
> +		unlink(tmp_file_path);
> +	}
> +	if (defrag_fd != -1) {
> +		ioctl(defrag_fd, FS_IOC_FSGETXATTR, &fsx);
> +		close(defrag_fd);
> +	}
> +
> +	printf("Pre-defrag %ld extents detected, %ld are \"unwritten\","
> +		"%ld are \"shared\"\n",
> +		g_ext_stats.nr_ext_total, g_ext_stats.nr_ext_unwritten,
> +		g_ext_stats.nr_ext_shared);
> +	printf("Tried to defragment %ld extents in %ld segments\n",
> +		nr_ext_defrag, nr_seg_defrag);
> +	printf("Time stats(ms): max clone: %d, max unshare: %d,"
> +	       " max punch_hole: %d\n",
> +	       max_clone_us/1000, max_unshare_us/1000, max_punch_us/1000);
> +	printf("Post-defrag %u extents detected\n", fsx.fsx_nextents);
> +	return ret;
> +}
> +
> +
> +static void defrag_help(void)
> +{
> +	printf(_(
> +"\n"
> +"Defragemnt files on XFS where reflink is enabled. IOs to the target files \n"

"Defragment"

> +"can be served durning the defragmentations.\n"
> +"\n"
> +" -s segment_size    -- specify the segment size in MiB, minmum value is 4 \n"
> +"                       default is 16\n"));
> +}
> +
> +static cmdinfo_t defrag_cmd;
> +
> +static int
> +defrag_f(int argc, char **argv)
> +{
> +	int	i;
> +	int	c;
> +
> +	while ((c = getopt(argc, argv, "s:")) != EOF) {
> +		switch(c) {
> +		case 's':
> +			g_segment_size_lmt = atoi(optarg) * 1024 * 1024 / 512;
> +			if (g_segment_size_lmt < MIN_SEGMENT_SIZE_LIMIT) {
> +				g_segment_size_lmt = MIN_SEGMENT_SIZE_LIMIT;
> +				printf("Using minimium segment size %d\n",
> +					g_segment_size_lmt);
> +			}
> +			break;
> +		default:
> +			command_usage(&defrag_cmd);
> +			return 1;
> +		}
> +	}
> +
> +	for (i = 0; i < filecount; i++)
> +		defrag_xfs_defrag(filetable[i].name);

Pass in the whole filetable[i] and then you've already got an open fd
and some validation that it's an xfs filesystem.

> +	return 0;
> +}
> +void defrag_init(void)
> +{
> +	defrag_cmd.name		= "defrag";
> +	defrag_cmd.altname	= "dfg";
> +	defrag_cmd.cfunc	= defrag_f;
> +	defrag_cmd.argmin	= 0;
> +	defrag_cmd.argmax	= 4;
> +	defrag_cmd.args		= "[-s segment_size]";
> +	defrag_cmd.flags	= CMD_FLAG_ONESHOT;

IIRC if you don't set CMD_FLAG_FOREIGN_OK then the command processor
won't let this command get run against a non-xfs file.

--D

> +	defrag_cmd.oneline	= _("Defragment XFS files");
> +	defrag_cmd.help		= defrag_help;
> +
> +	add_command(&defrag_cmd);
> +}
> diff --git a/spaceman/init.c b/spaceman/init.c
> index cf1ff3cb..396f965c 100644
> --- a/spaceman/init.c
> +++ b/spaceman/init.c
> @@ -35,6 +35,7 @@ init_commands(void)
>  	trim_init();
>  	freesp_init();
>  	health_init();
> +	defrag_init();
>  }
>  
>  static int
> diff --git a/spaceman/space.h b/spaceman/space.h
> index 723209ed..c288aeb9 100644
> --- a/spaceman/space.h
> +++ b/spaceman/space.h
> @@ -26,6 +26,7 @@ extern void	help_init(void);
>  extern void	prealloc_init(void);
>  extern void	quit_init(void);
>  extern void	trim_init(void);
> +extern void	defrag_init(void);
>  #ifdef HAVE_GETFSMAP
>  extern void	freesp_init(void);
>  #else
> -- 
> 2.39.3 (Apple Git-146)
> 
> 
