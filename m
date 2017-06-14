Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16793 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751714AbdFNQ5w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2017 12:57:52 -0400
Date: Wed, 14 Jun 2017 09:57:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/10] xfs_spaceman: Free space mapping command
Message-ID: <20170614165745.GV4530@birch.djwong.org>
References: <149643307433.15899.922559884171553380.stgit@birch.djwong.org>
 <149643312367.15899.5168600768651475925.stgit@birch.djwong.org>
 <91b3a6c0-3851-e500-c78d-aca1aee872fa@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91b3a6c0-3851-e500-c78d-aca1aee872fa@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Wed, Jun 14, 2017 at 11:04:11AM -0500, Eric Sandeen wrote:
> 
> On 6/2/17 2:52 PM, Darrick J. Wong wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add freespace mapping tool modelled on the xfs_db freesp command.
> > The advantage of this command over xfs_db is that it can be done
> > online and is coherent with concurrent modifications to the
> > filesystem.
> > 
> > This requires the kernel to support the XFS_IOC_GETFSMAP ioctl to map
> > free space indexes.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > [darrick: port from FIEMAPFS to GETFSMAP]
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> 
> > +static int
> > +init(
> > +	int		argc,
> > +	char		**argv)
> > +{
> > +	int		c;
> > +	int		speced = 0;
> > +
> > +	agcount = dumpflag = equalsize = multsize = optind = 0;
> > +	histcount = seen1 = summaryflag = 0;
> 
> ew, setting histcount to 0 (already done, right?  it's global?)
> and checking it here but never setting it is a little confusing.

Yes, I'll get rid of the redundant initializers.

> Maybe the comment below would help.

Ok.

> > +	totblocks = totexts = 0;
> > +	aglist = NULL;
> > +	hist = NULL;
> > +	rtflag = false;
> > +	while ((c = getopt(argc, argv, "a:bde:h:m:rs")) != EOF) {
> > +		switch (c) {
> > +		case 'a':
> > +			aglistadd(optarg);
> > +			break;
> > +		case 'b':
> > +			if (speced)
> > +				return 0;
> > +			multsize = 2;
> > +			speced = 1;
> > +			break;
> > +		case 'd':
> > +			dumpflag = 1;
> > +			break;
> > +		case 'e':
> > +			if (speced)
> > +				return 0;
> > +			equalsize = atoi(optarg);
> > +			speced = 1;
> > +			break;
> > +		case 'h':
> > +			if (speced && !histcount)
> > +				return 0;
> 
> maybe:			/* increments histcount */

Fixed.

> > +			addhistent(atoi(optarg));
> > +			speced = 1;
> > +			break;
> > +		case 'm':
> > +			if (speced)
> > +				return 0;
> > +			multsize = atoi(optarg);
> > +			speced = 1;
> > +			break;
> > +		case 'r':
> > +			rtflag = true;
> > +			break;
> > +		case 's':
> > +			summaryflag = 1;
> > +			break;
> > +		case '?':
> > +			return 0;
> > +		}
> > +	}
> > +	if (optind != argc)
> > +		return 0;
> > +	if (!speced)
> > +		multsize = 2;
> 
> Manpage indicates that -b, -e, and -h are mutually exclusive, but that's
> not enforced here (?)
> 
> Specifying more than one seems to break the command:
> 
> xfs_spaceman> freesp -b
>    from      to extents  blocks    pct
>       2       3       1       3   0.00
>   32768   65536       4  259537 100.00
> xfs_spaceman> freesp -e 4096
>    from      to extents  blocks    pct
>       1    4096       1       3   0.00
>   61441   65536       4  259537 100.00
> xfs_spaceman> freesp -e 4096 -b
> xfs_spaceman> 
> 
> Oh I see, if more than one is "speced" init returns 0 (silently).
> 
> I'd document what speced is for, and I guess print a warning about
> the exclusive nature of the 3 arguments in each case if re-spec'd
> before returning.

I made a note of that in the help screen and redirected all the overspec
cases to print the help screen instead of silently returning.

> And note the exclusive nature somehow in the help.
> (hm, looks like -m is in this exclusive group too?)
> 
> in gneneral need to sanitize behavior w/ built in help as well
> as manpage...

Ok.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
