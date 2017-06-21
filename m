Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34362 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751108AbdFUVxy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Jun 2017 17:53:54 -0400
Subject: Re: [PATCH 12/12] xfs_spaceman: add group summary mode
References: <149755894900.3625.8076720525369136771.stgit@birch.djwong.org>
 <149755902328.3625.10845087403849596095.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <847e6b56-aba2-2371-b8f3-a3d8800c1ae8@sandeen.net>
Date: Wed, 21 Jun 2017 16:53:52 -0500
MIME-Version: 1.0
In-Reply-To: <149755902328.3625.10845087403849596095.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 6/15/17 3:37 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a -g switch to show only a per-group summary.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

with a small fix (see below)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  man/man8/xfs_spaceman.8 |    6 +++++-
>  spaceman/freesp.c       |   27 ++++++++++++++++++++++++---
>  2 files changed, 29 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
> index f064360..0302196 100644
> --- a/man/man8/xfs_spaceman.8
> +++ b/man/man8/xfs_spaceman.8
> @@ -25,7 +25,7 @@ then the program exits.
>  
>  .SH COMMANDS
>  .TP
> -.BI "freesp [ \-drs ] [-a agno] [ \-b | \-e bsize | \-h bsize | \-m factor ]"
> +.BI "freesp [ \-dgrs ] [-a agno] [ \-b | \-e bsize | \-h bsize | \-m factor ]"
>  With no arguments,
>  .B freesp
>  shows a histogram of all free space extents in the filesystem.
> @@ -49,6 +49,10 @@ This is the default, and is mutually exclusive with the
>  Print debugging information such as the raw free space extent information.
>  
>  .TP
> +.B \-g
> +Print the free space block and extent counts for each AG.
> +
> +.TP
>  .B \-e bsize
>  Set all histogram bin sizes to a specific value.
>  This option is mutually exclusive with the
> diff --git a/spaceman/freesp.c b/spaceman/freesp.c
> index 99e50cf..79eea44 100644
> --- a/spaceman/freesp.c
> +++ b/spaceman/freesp.c
> @@ -43,6 +43,7 @@ static long long	multsize;
>  static int		histcount;
>  static int		seen1;
>  static int		summaryflag;
> +static int		gflag;
>  static bool		rtflag;
>  static long long	totblocks;
>  static long long	totexts;
> @@ -164,6 +165,8 @@ scan_ag(
>  	off64_t			bperag;
>  	off64_t			aglen;
>  	xfs_agblock_t		agbno;
> +	unsigned long long	freeblks = 0;
> +	unsigned long long	freeexts = 0;
>  	int			ret;
>  	int			i;
>  
> @@ -216,6 +219,8 @@ scan_ag(
>  			agbno = (extent->fmr_physical - (bperag * agno)) /
>  								blocksize;
>  			aglen = extent->fmr_length / blocksize;
> +			freeblks += aglen;
> +			freeexts++;
>  
>  			addtohist(agno, agbno, aglen);
>  		}
> @@ -225,6 +230,15 @@ scan_ag(
>  			break;
>  		fsmap_advance(fsmap);
>  	}
> +
> +	if (gflag) {
> +		if (agno == NULLAGNUMBER)
> +			printf(_("     rtdev %10llu %10llu\n"), freeexts,
> +					freeblks);
> +		else
> +			printf(_("%10u %10llu %10llu\n"), agno, freeexts,
> +					freeblks);
> +	}
>  }
>  static void
>  aglistadd(
> @@ -258,7 +272,7 @@ init(
>  	hist = NULL;
>  	rtflag = false;
>  
> -	while ((c = getopt(argc, argv, "a:bde:h:m:rs")) != EOF) {
> +	while ((c = getopt(argc, argv, "a:bde:gh:m:rs")) != EOF) {
>  		switch (c) {
>  		case 'a':
>  			aglistadd(optarg);
> @@ -280,6 +294,10 @@ init(
>  				return command_usage(&freesp_cmd);
>  			speced = 1;
>  			break;
> +		case 'g':
> +			histcount = 0;
> +			gflag++;
> +			break;

This global needs to be reset in init() or it sticks:

(I can fix it on the way in)

xfs_spaceman> freesp
   from      to extents  blocks    pct
      1       1  647503  647503   1.69
      2       3  334189  790976   2.07
      4       7  369499 2009667   5.26
      8      15  116258 1233152   3.23
     16      31   16648  370824   0.97
     32      63    8817  387963   1.01
     64     127    5474  487854   1.28
    128     255    3483  631960   1.65
    256     511    2613  956121   2.50
    512    1023    1758 1249204   3.27
   1024    2047     828 1151649   3.01
   2048    4095     357  972144   2.54
   4096    8191     122  687724   1.80
   8192   16383      38  432634   1.13
  16384   32767      23  566786   1.48
  32768   65535      15  765430   2.00
  65536  131071      14 1359754   3.56
 131072  262143       4  653264   1.71
 262144  524287       4 1775562   4.64
 524288 1048575       2 1390287   3.64
1048576 2097151       2 2446908   6.40
2097152 4194303       2 6234130  16.31
4194304 8388607       2 11023746  28.84
xfs_spaceman> freesp -g
        AG    extents     blocks
         0     280589    6629403
         1     289696   11847480
         2      14299    7806587
         3     923071   11941772
xfs_spaceman> freesp
        AG    extents     blocks
         0     280589    6629403
         1     289696   11847480
         2      14299    7806587
         3     923071   11941772


>  		case 'h':
>  			if (speced && !histcount)
>  				goto many_spec;
> @@ -331,13 +349,15 @@ freesp_f(
>  
>  	if (!init(argc, argv))
>  		return 0;
> +	if (gflag)
> +		printf(_("        AG    extents     blocks\n"));
>  	if (rtflag)
>  		scan_ag(NULLAGNUMBER);
>  	for (agno = 0; !rtflag && agno < file->geom.agcount; agno++)  {
>  		if (inaglist(agno))
>  			scan_ag(agno);
>  	}
> -	if (histcount)
> +	if (histcount && !gflag)
>  		printhist();
>  	if (summaryflag) {
>  		printf(_("total free extents %lld\n"), totexts);
> @@ -363,6 +383,7 @@ freesp_help(void)
>  " -b       -- binary histogram bin size\n"
>  " -d       -- debug output\n"
>  " -e bsize -- Use fixed histogram bin size of bsize\n"
> +" -g       -- Print only a per-AG summary.\n"
>  " -h hbsz  -- Use custom histogram bin size of h1.\n"
>  "             Multiple specifications are allowed.\n"
>  " -m bmult -- Use histogram bin size multiplier of bmult.\n"
> @@ -382,7 +403,7 @@ freesp_init(void)
>  	freesp_cmd.cfunc = freesp_f;
>  	freesp_cmd.argmin = 0;
>  	freesp_cmd.argmax = -1;
> -	freesp_cmd.args = "[-drs] [-a agno]... [ -b | -e bsize | -h h1... | -m bmult ]";
> +	freesp_cmd.args = "[-dgrs] [-a agno]... [ -b | -e bsize | -h h1... | -m bmult ]";
>  	freesp_cmd.flags = CMD_FLAG_ONESHOT;
>  	freesp_cmd.oneline = _("Examine filesystem free space");
>  	freesp_cmd.help = freesp_help;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
