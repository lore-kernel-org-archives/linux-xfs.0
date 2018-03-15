Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39582 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752052AbeCOSpC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Mar 2018 14:45:02 -0400
Date: Thu, 15 Mar 2018 11:44:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2 v2] xfs_repair: add flag -e to detect corrected errors
Message-ID: <20180315184456.GB4865@magnolia>
References: <20180315174521.33897-1-jtulak@redhat.com>
 <20180315182308.36245-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180315182308.36245-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 15, 2018 at 07:23:08PM +0100, Jan Tulak wrote:
> xfs_repair ends with a return code 0 if it finished ok, no matter if
> there were some errors in the fs, or not. The new flag -e means that we
> can avoid screenscraping and parsing text output to detect if an error
> was found (and corrected).
> 
> If something could not be corrected or in any other case than the "found
> something but fixed it all," the behaviour with this flag is unchanged.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> ---
> v2:
> - edit man page changes
> - report_corrected is now bool
> - minor code simplification
> ---
>  man/man8/xfs_repair.8 | 15 +++++++++++----
>  repair/xfs_repair.c   | 10 +++++++++-
>  2 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
> index 85e4dc97..1ca3b614 100644
> --- a/man/man8/xfs_repair.8
> +++ b/man/man8/xfs_repair.8
> @@ -4,7 +4,7 @@ xfs_repair \- repair an XFS filesystem
>  .SH SYNOPSIS
>  .B xfs_repair
>  [
> -.B \-dfLnPv
> +.B \-defLnPv
>  ] [
>  .B \-m
>  .I maxmem
> @@ -168,6 +168,10 @@ Repair dangerously. Allow
>  to repair an XFS filesystem mounted read only. This is typically done
>  on a root filesystem from single user mode, immediately followed by a reboot.
>  .TP
> +.B \-e
> +If any metadata corruption was found, the status returned is 3 instead of the
> +usual 0.
> +.TP
>  .B \-V
>  Prints the version number and exits.
>  .SS Checks Performed
> @@ -512,14 +516,17 @@ will return a status of 1 if filesystem corruption was detected and
>  0 if no filesystem corruption was detected.
>  .B xfs_repair
>  run without the \-n option will always return a status code of 0 if
> -it completes without problems.  If a runtime error is encountered
> -during operation, it will return a status of 1.  In this case,
> +it completes without problems, unless the flag
> +.B -e
> +is used. If it is used, then status 3 is reported when any issue with the
> +filesystem was found, but could be fixed. If a runtime error is encountered during
> +operation, it will return a status of 1. In this case,
>  .B xfs_repair
>  should be restarted.  If
>  .B xfs_repair is unable
>  to proceed due to a dirty log, it will return a status of 2.  See below.
>  .SH DIRTY LOGS
> -Due to the design of the XFS log, a dirty log can only be replayed 
> +Due to the design of the XFS log, a dirty log can only be replayed
>  by the kernel, on a machine having the same CPU architecture as the
>  machine which was writing to the log.
>  .B xfs_repair
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 312a0d08..a65709ce 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -77,6 +77,7 @@ static char *c_opts[] = {
>  static int	bhash_option_used;
>  static long	max_mem_specified;	/* in megabytes */
>  static int	phase2_threads = 32;
> +static bool report_corrected;
>  
>  static void
>  usage(void)
> @@ -97,6 +98,7 @@ usage(void)
>  "  -o subopts   Override default behaviour, refer to man page.\n"
>  "  -t interval  Reporting interval in seconds.\n"
>  "  -d           Repair dangerously.\n"
> +"  -e           Exit with a non-zero code even when all errors were repaired.\n"
>  "  -V           Reports version and exits.\n"), progname);
>  	exit(1);
>  }
> @@ -214,12 +216,13 @@ process_args(int argc, char **argv)
>  	ag_stride = 0;
>  	thread_count = 1;
>  	report_interval = PROG_RPT_DEFAULT;
> +	report_corrected = false;
>  
>  	/*
>  	 * XXX have to add suboption processing here
>  	 * attributes, quotas, nlinks, aligned_inos, sb_fbits
>  	 */
> -	while ((c = getopt(argc, argv, "c:o:fl:m:r:LnDvVdPt:")) != EOF)  {
> +	while ((c = getopt(argc, argv, "c:o:fl:m:r:LnDvVdPet:")) != EOF)  {
>  		switch (c) {
>  		case 'D':
>  			dumpcore = 1;
> @@ -329,6 +332,9 @@ process_args(int argc, char **argv)
>  		case 't':
>  			report_interval = (int)strtol(optarg, NULL, 0);
>  			break;
> +		case 'e':
> +			report_corrected = true;
> +			break;
>  		case '?':
>  			usage();
>  		}
> @@ -1096,5 +1102,7 @@ _("Repair of readonly mount complete.  Immediate reboot encouraged.\n"));
>  
>  	free(msgbuf);
>  
> +	if (fs_is_dirty && report_corrected)
> +		return (3);
>  	return (0);
>  }
> -- 
> 2.15.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
