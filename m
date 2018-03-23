Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59874 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751551AbeCWB5D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Mar 2018 21:57:03 -0400
Subject: Re: [PATCH 1/2 v2] xfs_repair: add flag -e to detect corrected errors
References: <20180315174521.33897-1-jtulak@redhat.com>
 <20180315182308.36245-1-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <669909a6-6976-04fc-7717-f109b58b9c5a@sandeen.net>
Date: Thu, 22 Mar 2018 20:57:02 -0500
MIME-Version: 1.0
In-Reply-To: <20180315182308.36245-1-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 3/15/18 1:23 PM, Jan Tulak wrote:
> xfs_repair ends with a return code 0 if it finished ok, no matter if
> there were some errors in the fs, or not. The new flag -e means that we
> can avoid screenscraping and parsing text output to detect if an error
> was found (and corrected).
> 
> If something could not be corrected or in any other case than the "found
> something but fixed it all," the behaviour with this flag is unchanged.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

A couple more minor things, sorry for chiming in late.

Can we make the changelog summary a little more specific, i.e.

"xfs_repair: add flag -e to modify exit code for corrected errors"

I had a late-breaking thought ;) that maybe we should skip up to exit
code 4, so that if for some reason in the future we need to, we can
OR together exit codes ala e2fsck to convey more information.
I don't know what other exit codes we might need, but this might
future-proof it a little.

(Actually, I can see an use today:  1 | 4 = 5 could mean
"we found and fixed some errors and then encountered an operational
problem and exited." - but that can come later, not here.  Skipping
to 4 would keep this option open.)

more below

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

Sorry, I know Darrick already commented on this once, but I think
it probably needs to distinguish from the -n case a little more.  Maybe:

+If any metadata corruption was repaired, the status returned is 3 (4?) instead of the
+usual 0.

which makes it more clear that it's in repair mode, not dry-run mode?

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

tab that out please, to match lines above

>  
>  static void
>  usage(void)
> @@ -97,6 +98,7 @@ usage(void)
>  "  -o subopts   Override default behaviour, refer to man page.\n"
>  "  -t interval  Reporting interval in seconds.\n"
>  "  -d           Repair dangerously.\n"
> +"  -e           Exit with a non-zero code even when all errors were repaired.\n"

+"  -e           Exit with a non-zero code if any errors were repaired.\n"


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

It looks like we can specify -e and -n together; I think they need to be
mutually exclusive, because the combination has no valid meaning that
I can see.

(if so, I guess that needs a usage/summary/manpage update to reflect the change)

Thanks,
-Eric

> @@ -1096,5 +1102,7 @@ _("Repair of readonly mount complete.  Immediate reboot encouraged.\n"));
>  
>  	free(msgbuf);
>  
> +	if (fs_is_dirty && report_corrected)
> +		return (3);
>  	return (0);
>  }
> 
