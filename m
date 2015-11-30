Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 979AD7F37
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 07:22:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 256A9AC003
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 05:22:22 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1u9AtvVhu7Z3Bzdp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Nov 2015 05:22:21 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 7186B42E5B7
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 13:22:20 +0000 (UTC)
Date: Mon, 30 Nov 2015 08:22:19 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_io: implement 'inode' command V5
Message-ID: <20151130132217.GA24765@bfoster.bfoster>
References: <1448552795-8794-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1448552795-8794-1-git-send-email-cmaiolino@redhat.com>
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

On Thu, Nov 26, 2015 at 04:46:35PM +0100, Carlos Maiolino wrote:
> Implements a new xfs_io command, named 'inode', which is supposed to be
> used to query information about inode's existence and its physical size
> in the filesystem.
> 
> Supported options:
> 
> Default:     -- Return true(1) or false(0) if any inode greater than
>                 32bits has been found in the filesystem
> -v           -- verbose mode
>                 Display the number and the physical size (in bits)
>                 of the largest inode in the filesystem
> [num]        -- Return true(1) or false(0) if the inode [num] is in use
> -n [num]     -- Return the next valid inode after [num]
> 
> No manpage sent because there were changes in the supported options and its
> descriptions.
> I'll send the manpage after the options and descriptions are reviewed.
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
> V4:
> 	- Refactor inode_f function to reduce its size and easier logic
> 	- Implement error handlers for invalid command combination (hopefully
> 	  all invalid combinations).
> 	- use a single xfs_inogrp array for keep track of inodes
> 	- Fix missing newline in inode_help()
> 	- Rewrite help message in inode_help()
> 	- Fix indentation
> 
> V5:
> 	- Reduce the amount of options
> 	- remove igrp_rec variable, and use igroup[lastgrp] directly to get
> 	  information from the last inode groups returned by ioctl
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  io/open.c | 143 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 143 insertions(+)
> 
> diff --git a/io/open.c b/io/open.c
> index ac5a5e0..1e38ea8 100644
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
> @@ -750,6 +752,136 @@ statfs_f(
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
> +" Default:	-- Return true(1) or false(0) if any inode greater than\n"
> +"		   32bits has been found in the filesystem\n"
> +" -v		-- verbose mode\n"
> +"		   Display the number and the physical size (in bits)\n"
> +"		   of the largest inode in the filesystem\n"
> +"[num]		-- Return true(1) or false(0) if the inode [num] is in use\n"
> +" -n [num]	-- Return the next valid inode after [num]\n"
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
> +	int			verbose = 0;
> +	int			ret_next = 0;
> +	int			cmd = 0;
> +	struct xfs_inogrp	igroup[1024];
> +	struct xfs_fsop_bulkreq	bulkreq;
> +	struct xfs_bstat	bstat;
> +
> +	while ((c = getopt(argc, argv, "nv")) != EOF) {

I think we want "n:v" here since -n expects an argument, even if we
don't process the arg here.

> +		switch (c) {
> +		case 'v':
> +			verbose = 1;
> +			break;
> +		case 'n':
> +			ret_next = 1;
> +			break;
> +		default:
> +			return command_usage(&inode_cmd);
> +		}
> +	}
> +
> +	if (ret_next && verbose)
> +		return command_usage(&inode_cmd);
> +

Why is this not supported? Hmm, I see that -n returns an inode number
and otherwise we print 0/1 or <inode>:<size> with -v. Perhaps this would
be easier if the command semantics/output were more consistent. E.g., 

"inode": print 0/1 based on largest inode size
"inode -v": print <ino>:<size> of largest inode
"inode <ino>": print <ino> if inode exists
"inode -v <ino>": print <ino>:<size> if inode exists
"inode -n <ino>": print <next ino> if next inode exists
"inode -nv <ino>": print <next ino>:<size> if next inode exists

In other words, the default behavior is to identify the 32-bit/64-bit
state of the fs. If an inode is provided, we print the inode number if
the inode exists. The -n flags alters this behavior to find the next
inode. The -v flag alters the previous two situations to also print the
inode size.

> +	if (optind < argc) {

A comment above this check to explain what it means (i.e., user passed
an inode number) would be nice.

> +		if (verbose)
> +			return command_usage(&inode_cmd);

Also, why is this not supported (see above)?

> +
> +		if (ret_next) {
> +			cmd = XFS_IOC_FSBULKSTAT;
> +		} else {
> +			if (argc > 2)
> +				return command_usage(&inode_cmd);
> +			else
> +				cmd = XFS_IOC_FSBULKSTAT_SINGLE;
> +		}
> +
> +		userino = strtoull(argv[optind], &p, 10);
> +		if ((*p != '\0')) {
> +			printf(_("[num] must be a numeric value\n"));
> +			exitcode = 1;
> +			return 0;
> +		}
> +
> +		bulkreq.lastip = &userino;
> +		bulkreq.icount = 1;
> +		bulkreq.ubuffer = &bstat;
> +		bulkreq.ocount = &count;
> +
> +		if (xfsctl(file->name, file->fd, cmd, &bulkreq)) {
> +			if (errno == EINVAL) {
> +				if (!ret_next)
> +					printf("0\n");
> +			} else {
> +				perror("xfsctl");
> +			}
> +			exitcode = 1;
> +			return 0;
> +		}
> +
> +		if (ret_next) {
> +			printf("%llu\n", bstat.bs_ino);
> +			return 0;
> +		} else {
> +			/* Inode number used*/
> +			printf("1\n");
> +			return 0;
> +		}

The return 0 can go after the if/else.

> +	}
> +

	/*
	 * The user has not provided an inode number. Therefore, find
	 * the largest inode in the fs.
	 */

Brian

> +	bulkreq.lastip = &last;
> +	bulkreq.icount = 1024; /* User-defined maybe!? */
> +	bulkreq.ubuffer = &igroup;
> +	bulkreq.ocount = &count;
> +
> +	for (;;) {
> +		if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS,
> +				&bulkreq)) {
> +			perror("XFS_IOC_FSINUMBERS");
> +			exitcode = 1;
> +			return 0;
> +		}
> +
> +		if (count == 0)
> +			break;
> +
> +		lastgrp = count;
> +	}
> +
> +	lastgrp--;
> +	lastino = igroup[lastgrp].xi_startino +
> +		  xfs_highbit64(igroup[lastgrp].xi_allocmask);
> +
> +	if (verbose)
> +		printf("%llu:%d\n", lastino,
> +			lastino > XFS_MAXINUMBER_32 ? 64 : 32);
> +	else
> +		printf("%d\n", lastino > XFS_MAXINUMBER_32 ? 1 : 0);
> +
> +	return 0;
> +}
> +
>  void
>  open_init(void)
>  {
> @@ -815,6 +947,16 @@ open_init(void)
>  		_("get/set preferred extent size (in bytes) for the open file");
>  	extsize_cmd.help = extsize_help;
>  
> +	inode_cmd.name = "inode";
> +	inode_cmd.cfunc = inode_f;
> +	inode_cmd.args = _("[-n | -v] [num]");
> +	inode_cmd.argmin = 0;
> +	inode_cmd.argmax = 2;
> +	inode_cmd.flags = CMD_NOMAP_OK;
> +	inode_cmd.oneline =
> +		_("Query inode number usage in the filesystem");
> +	inode_cmd.help = inode_help;
> +
>  	add_command(&open_cmd);
>  	add_command(&stat_cmd);
>  	add_command(&close_cmd);
> @@ -822,4 +964,5 @@ open_init(void)
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
