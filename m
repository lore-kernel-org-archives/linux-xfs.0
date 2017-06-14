Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31302 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752057AbdFNRWz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2017 13:22:55 -0400
Date: Wed, 14 Jun 2017 10:22:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/10] xfs_spaceman: add group summary mode
Message-ID: <20170614172248.GW4530@birch.djwong.org>
References: <149643307433.15899.922559884171553380.stgit@birch.djwong.org>
 <149643313776.15899.17808639449781969033.stgit@birch.djwong.org>
 <1c5025dd-e903-3780-f693-ce582d908c96@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c5025dd-e903-3780-f693-ce582d908c96@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jun 14, 2017 at 11:23:51AM -0500, Eric Sandeen wrote:
> On 6/2/17 2:52 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a -g switch to show only a per-group summary.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  man/man8/xfs_spaceman.8 |    8 +++++++-
> >  spaceman/freesp.c       |   29 +++++++++++++++++++++++++----
> >  2 files changed, 32 insertions(+), 5 deletions(-)
> > 
> > 
> > diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
> > index c1d19c0..a57a0c3 100644
> > --- a/man/man8/xfs_spaceman.8
> > +++ b/man/man8/xfs_spaceman.8
> > @@ -25,7 +25,7 @@ then the program exits.
> >  
> >  .SH COMMANDS
> >  .TP
> > -.BI "freesp [ \-sr ] [ \-b | \-e bsize | \-h h1 [ \-m bmult ]] [-a agno]"
> > +.BI "freesp [ \-srg ] [ \-b | \-e bsize | \-h h1 [ \-m bmult ]] [-a agno]"
> >  With no arguments,
> >  .B freesp
> >  shows a histogram of all free space extents in the filesystem.
> > @@ -49,6 +49,12 @@ option may be specified multiple times.
> >  A summary of free space information will be printed if the
> >  .B -s
> >  option is given.
> > +The
> > +.B -g
> > +option prints a brief per-AG summary of the free space found in that AG.
> > +If
> > +.B -r
> > +is specified it will also report on free space in the realtime device.
> 
> If you're reworking patches, the -r switch doc should probably go in the manpage
> patch, not here, but *shrug*

<shrug> I was mostly re

> 
> >  .TP
> >  .BR "help [ " command " ]"
> >  Display a brief description of one or all commands.
> > diff --git a/spaceman/freesp.c b/spaceman/freesp.c
> > index 2290a5e..351f0ce 100644
> > --- a/spaceman/freesp.c
> > +++ b/spaceman/freesp.c
> > @@ -42,6 +42,7 @@ static int		histcount;
> >  static int		multsize;
> >  static int		seen1;
> >  static int		summaryflag;
> > +static int		gflag;
> >  static bool		rtflag;
> >  static long long	totblocks;
> >  static long long	totexts;
> > @@ -159,6 +160,8 @@ scan_ag(
> >  	off64_t			bperag;
> >  	off64_t			aglen;
> >  	xfs_agblock_t		agbno;
> > +	unsigned long long	freeblks = 0;
> > +	unsigned long long	freeexts = 0;
> >  	int			ret;
> >  	int			i;
> >  
> > @@ -211,6 +214,8 @@ scan_ag(
> >  			agbno = (extent->fmr_physical - (bperag * agno)) /
> >  								blocksize;
> >  			aglen = extent->fmr_length / blocksize;
> > +			freeblks += aglen;
> > +			freeexts++;
> >  
> >  			addtohist(agno, agbno, aglen);
> >  		}
> > @@ -220,6 +225,15 @@ scan_ag(
> >  			break;
> >  		fsmap_advance(fsmap);
> >  	}
> > +
> > +	if (gflag) {
> > +		if (agno == NULLAGNUMBER)
> > +			printf(_("     rtdev %10llu %10llu\n"), freeexts,
> > +					freeblks);
> > +		else
> > +			printf(_("%10u %10llu %10llu\n"), agno, freeexts,
> > +					freeblks);
> > +	}
> 
> ok so -g can be used with -a?
> 
> xfs_spaceman> freesp -g
>         AG    extents     blocks
>          0          2      65519
>          1          1      65527
>          2          1      62967
>          3          1      65527
> xfs_spaceman> freesp -a 0
>         AG    extents     blocks
>          0          2      65519
> xfs_spaceman> freesp -a 0 -g
>         AG    extents     blocks
>          0          2      65519
> 
> Ok, so I guess "-g" is the same as "-a" for each AG?  Documenting it that
> way might help.

Well, -g is "tell us about each AG individually" whereas the -a options
together mean "tell us about this specific subset of AGs".

We can make -g and -a mutually exclusive with each other.

> Oh, wait, something is wrong here - global vars, danger danger?
> 
> xfs_spaceman> freesp
>    from      to extents  blocks    pct
>       1       1       1       1   0.00
>   32768   65536       4  254826 100.00
> xfs_spaceman> freesp -g
>         AG    extents     blocks
>          0          1      63479
>          1          2      62854
>          2          1      62967
>          3          1      65527
> xfs_spaceman> freesp
>         AG    extents     blocks
>          0          1      63479
>          1          2      62854
>          2          1      62967
>          3          1      65527
> 
> *blink*
> 
> yeah, I think you need to set gflag = 0 in init().
> 
> (and scratch my earlier comment about histcount being init to zero so why
> do it in init, now I see why) ;)

Heh.  Yeah, I noticed that when I was fiddling with the patches.

> >  }
> >  static void
> >  aglistadd(
> > @@ -244,7 +258,7 @@ init(
> >  	aglist = NULL;
> >  	hist = NULL;
> >  	rtflag = false;
> > -	while ((c = getopt(argc, argv, "a:bde:h:m:rs")) != EOF) {
> > +	while ((c = getopt(argc, argv, "a:bde:gh:m:rs")) != EOF) {
> >  		switch (c) {
> >  		case 'a':
> >  			aglistadd(optarg);
> > @@ -264,6 +278,10 @@ init(
> >  			equalsize = atoi(optarg);
> >  			speced = 1;
> >  			break;
> > +		case 'g':
> > +			histcount = 0;
> > +			gflag++;
> > +			break;
> >  		case 'h':
> >  			if (speced && !histcount)
> >  				return 0;
> > @@ -306,13 +324,15 @@ freesp_f(
> >  
> >  	if (!init(argc, argv))
> >  		return 0;
> > +	if (gflag)
> > +		printf(_("        AG    extents     blocks\n"));
> >  	if (rtflag)
> >  		scan_ag(NULLAGNUMBER);
> >  	for (agno = 0; !rtflag && agno < file->geom.agcount; agno++)  {
> >  		if (inaglist(agno))
> >  			scan_ag(agno);
> >  	}
> > -	if (histcount)
> > +	if (histcount && !gflag)
> >  		printhist();
> >  	if (summaryflag) {
> >  		printf(_("total free extents %lld\n"), totexts);
> > @@ -334,12 +354,13 @@ freesp_help(void)
> >  "\n"
> >  "Examine filesystem free space\n"
> >  "\n"
> > -"Options: [-bdsr] [-a agno] [-e bsize] [-h h1]... [-m bmult]\n"
> > +"Options: [-bdgsr] [-a agno] [-e bsize] [-h h1]... [-m bmult]\n"
> 
> (drop the options re-specification in the long help)

Ok.

> >  "\n"
> >  " -a agno  -- Scan only the given AG agno.\n"
> 
> >  " -b       -- binary histogram bin size\n"
> >  " -d       -- debug output\n"
> >  " -e bsize -- Use fixed histogram bin size of bsize\n"
> > +" -g       -- Print only a per-AG summary.\n"
> >  " -h hbsz  -- Use custom histogram bin size of h1.\n"
> >  "             Multiple specifications are allowed.\n"
> >  " -m bmult -- Use histogram bin size multiplier of bmult.\n"
> > @@ -357,7 +378,7 @@ freesp_init(void)
> >  	freesp_cmd.cfunc = freesp_f;
> >  	freesp_cmd.argmin = 0;
> >  	freesp_cmd.argmax = -1;
> > -	freesp_cmd.args = "[-bdsr] [-a agno] [-e bsize] [-h h1]... [-m bmult]";
> > +	freesp_cmd.args = "[-bdgsr] [-a agno] [-e bsize] [-h h1]... [-m bmult]";
> 
> (make clear which ones are mutually exclusive)

Ok.

--D

> 
> >  	freesp_cmd.flags = CMD_FLAG_ONESHOT;
> >  	freesp_cmd.oneline = _("Examine filesystem free space");
> >  	freesp_cmd.help = freesp_help;
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
