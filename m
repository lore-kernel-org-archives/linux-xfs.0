Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D09777F37
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2015 09:42:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 924EF8F8035
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2015 07:42:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uKkauOy9lHlg8sXV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 22 Oct 2015 07:42:57 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 647D98E675
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2015 14:42:57 +0000 (UTC)
Date: Thu, 22 Oct 2015 10:42:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_io: implement 'inode' command V3
Message-ID: <20151022144255.GB13661@bfoster.bfoster>
References: <1445257880-30797-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1445257880-30797-1-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 19, 2015 at 02:31:20PM +0200, Carlos Maiolino wrote:
> Implements a new xfs_io command, named 'inode', which is supposed to be used to
> query information about inode's existence and its physical size in the
> filesystem.
> 
> Currently supporting three arguments:
> -s       -- return physical size of the largest inode
> -l       -- return the largest inode number allocated and used
> -n [num] -- Return the next existing inode after [num], even if [num] is not
>             allocated/used
> [num]    -- Return if the inode exists or not.
> 
> I didn't send the man page patch because I'm sure I'll get some points to
> improve, and I'll write the manpage for the next revision.
> 
> - Changelog
> 
> V3:
> 	- Merge all 3 patches from the V2 together in a single patch
> 	- Rework of '-n [num]' and 'num' only arguments algorithm
> 	- Argument -n now relies on bulkreq.count to check for next inodes, not
> 	  on bstat.bs_ino anymore.
> 	- for loop in ret_lsize or ret_largest case, now relies on count being 0
> 	  to break the loop
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  io/open.c | 161 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 161 insertions(+)
> 
> diff --git a/io/open.c b/io/open.c
> index ac5a5e0..59b5c94 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -20,6 +20,7 @@
>  #include "input.h"
>  #include "init.h"
>  #include "io.h"
> +#include "libxfs.h"
>  
>  #ifndef __O_TMPFILE
>  #if defined __alpha__
> @@ -44,6 +45,7 @@ static cmdinfo_t statfs_cmd;
>  static cmdinfo_t chproj_cmd;
>  static cmdinfo_t lsproj_cmd;
>  static cmdinfo_t extsize_cmd;
> +static cmdinfo_t inode_cmd;
>  static prid_t prid;
>  static long extsize;
>  
> @@ -750,6 +752,154 @@ statfs_f(
>  	return 0;
>  }
>  
> +static void
> +inode_help(void)
> +{
> +	printf(_(
> +"\n"
> +"Query physical information about the inode"
> +"\n"
> +" -l	-- Returns the largest inode number in the filesystem\n"
> +" -s	-- Returns the physical size (in bits) of the\n"
> +"	   largest inode number in the filesystem\n"
> +" -n	-- Return the next valid inode after [num]"

Missing newline at the end of the above line.

> +"[num]	   Check if the inode [num] exists in the filesystem"

I would word this to say check if the filesystem "is used" in the
filesystem (or "is linked", or something like that) rather than
"exists," simply because this confuses me about whether the inode needs
to be physically allocated (in a chunk) or actually in-use by the fs. A
quick run of the command suggests that the inode must actually be
linked.

> +"\n"));
> +}
> +
> +static int
> +inode_f(
> +	  int			argc,
> +	  char			**argv)
> +{
> +	__s32			count = 0;
> +	__s32			lastgrp = 0;
> +	__u64			last = 0;
> +	__u64			lastino = 0;
> +	__u64			userino = 0;
> +	char			*p;
> +	int			c;
> +	int			ret_lsize = 0;
> +	int			ret_largest = 0;
> +	int			ret_next = 0;
> +	struct xfs_inogrp	igroup[1024], igrp_rec[1024];
> +	struct xfs_fsop_bulkreq	bulkreq;
> +	struct xfs_bstat	bstat;
> +
> +
> +	while ((c = getopt(argc, argv, "sln:")) != EOF) {
> +		switch (c) {
> +		case 's':
> +			ret_lsize = 1;
> +			break;
> +		case 'l':
> +			ret_largest = 1;
> +			break;
> +		case 'n':
> +			ret_next = 1;
> +			userino = strtoull(optarg, &p, 10);
> +			break;
> +		default:
> +			return command_usage(&inode_cmd);
> +		}
> +	}
> +

We don't check for invalid combinations anywhere. E.g.:

	xfs_io -c "inode -l <num>" <dev>

... should probably display the command usage, right? I take it the same
goes for the '-s' option.

Also, since I was playing with it:

# ./xfs_io -c "inode -l" /mnt/
Largest inode: 98
# ./xfs_io -c "inode 98" /mnt/
Invalid or non-existent inode number

... what's up with that? ;) FWIW, 98 is one of the internal inodes so
perhaps this is just filtered from bulkstat.

> +	if (((optind < argc) || ret_next) &&
> +	     !(ret_lsize || ret_largest)) {
> +

If we check for invalid combinations as mentioned above, this entire
function can look something like this (pseudocode):

{
	...
	get_opts();
	if (check_cmd_errors())
		command_usage();
	if (find_largest) {
		do_find_largest();
		printf("Largest inode: <ino> (<N>-bit);
		return 0;
	}
	
	do_bulkstat();
	printf("Valid/Next inode: ...");

	return 0;
}

... and so we can eliminate some indentation.

> +		/* Setup bulkreq for -n or [num] only */
> +		bulkreq.lastip = &last;
> +		bulkreq.icount = 1;
> +		bulkreq.ubuffer = &bstat;
> +		bulkreq.ocount = &count;
> +
> +		if (ret_next) {
> +				if ((*p != '\0')) {
> +					printf(_("[num] must be a numeric value\n"));
> +					exitcode = 1;
> +					return 0;
> +				}

Indentation of the above is off.

> +			last = userino;
> +			if (xfsctl(file->name, file->fd, XFS_IOC_FSBULKSTAT,
> +					&bulkreq)) {
> +				if (errno == EINVAL)
> +					printf(_("Invalid or non-existent inode\n"));
> +				else
> +					perror("XFS_IOC_FSBULKSTAT");
> +				exitcode = 1;
> +				return 0;
> +			}
> +
> +			if (!count) {
> +			printf(_("There are no further inodes in the filesystem\n"));
> +			return 0;

Indentation.

> +			}
> +
> +			printf(_("Next inode: %llu\n"), bstat.bs_ino);
> +			return 0;
> +		} else {
> +			userino = strtoull(argv[optind], &p, 10);
> +				if ((*p != '\0')) {
> +					printf(_("[num] must be a numeric value\n"));
> +					exitcode = 1;
> +					return 0;
> +				}
> +			last = userino;
> +			if (xfsctl(file->name, file->fd, XFS_IOC_FSBULKSTAT_SINGLE,
> +					&bulkreq)) {
> +				if (errno == EINVAL) {
> +					printf(_("Invalid or non-existent inode number\n"));
> +				} else
> +					perror("XFS_IOC_FSBULKSTAT_SINGLE");
> +				exitcode = 1;
> +				return 0;
> +			}
> +			printf(_("Valid inode: %llu\n"), bstat.bs_ino);
> +			return 0;
> +

Both of the above bulkstat cases look quite similar. Could we do
something like the following?

	bulkreq.lastip = ...;
	/* check userino */
	last = userino;
	if (ret_next)
		cmd = XFS_IOC_FSBULKSTAT;
	else
		cmd = XFS_IOC_FSBULKSTAT_SINGLE;
	
	if (xfsctl(...)) {
		...
	}

	printf("Inode: ...", ...);

	return 0;

> +		}
> +	}
> +
> +	if (ret_lsize || ret_largest) {
> +
> +		bulkreq.lastip = &last;
> +		bulkreq.icount = 1024; /* User-defined maybe!? */
> +		bulkreq.ubuffer = &igroup;
> +		bulkreq.ocount = &count;
> +
> +		for (;;) {
> +
> +			if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS,
> +					&bulkreq)) {
> +				perror("XFS_IOC_FSINUMBERS");
> +				exitcode = 1;
> +				return 0;
> +			}
> +
> +			if (count == 0)
> +				break;
> +
> +			lastgrp = count;
> +			memcpy(igrp_rec, igroup,
> +				sizeof(struct xfs_inogrp) * 1024);

Why keep and copy a separate instance of the entire array when we only
care about the last record? It seems to me that igrp_rec could be a
single record.

> +		}
> +
> +		lastgrp--;
> +		lastino = igrp_rec[lastgrp].xi_startino +
> +			  xfs_highbit64(igrp_rec[lastgrp].xi_allocmask);
> +
> +		if (ret_lsize)
> +			printf (_("Largest inode size: %d\n"),
> +				lastino > XFS_MAXINUMBER_32 ? 64 : 32);
> +		else
> +			printf(_("Largest inode: %llu\n"), lastino);
> +

I still don't really get why we have separate -l and -s options here. It
seems to me that the behavior of -l already gives us the information
that -s does. Even if that's not obvious enough, the -l command could
just print out both. For example:

	"Largest inode: 1234 (32-bit)"

Brian

> +		return 0;
> +	}
> +
> +	return command_usage(&inode_cmd);
> +}
> +
>  void
>  open_init(void)
>  {
> @@ -815,6 +965,16 @@ open_init(void)
>  		_("get/set preferred extent size (in bytes) for the open file");
>  	extsize_cmd.help = extsize_help;
>  
> +	inode_cmd.name = "inode";
> +	inode_cmd.cfunc = inode_f;
> +	inode_cmd.args = _("[-s | -l | -n] [num]");
> +	inode_cmd.argmin = 1;
> +	inode_cmd.argmax = 2;
> +	inode_cmd.flags = CMD_NOMAP_OK;
> +	inode_cmd.oneline =
> +		_("Query inode number usage in the filesystem");
> +	inode_cmd.help = inode_help;
> +
>  	add_command(&open_cmd);
>  	add_command(&stat_cmd);
>  	add_command(&close_cmd);
> @@ -822,4 +982,5 @@ open_init(void)
>  	add_command(&chproj_cmd);
>  	add_command(&lsproj_cmd);
>  	add_command(&extsize_cmd);
> +	add_command(&inode_cmd);
>  }
> -- 
> 2.4.3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
