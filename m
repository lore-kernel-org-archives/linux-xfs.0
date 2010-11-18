Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAI59AxC125388 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 23:09:10 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23AF018C803
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 21:10:42 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	y5gXYhBzIdACY8ov for <xfs@oss.sgi.com>;
	Wed, 17 Nov 2010 21:10:42 -0800 (PST)
Date: Thu, 18 Nov 2010 16:10:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Xfsprogs: add fiemap command to xfs_io V2
Message-ID: <20101118051029.GR13830@dastard>
References: <1289582374-19324-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1289582374-19324-1-git-send-email-josef@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Josef Bacik <josef@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 12, 2010 at 12:19:34PM -0500, Josef Bacik wrote:
> When trying to add a test for hole punching I noticed that the "bmap" command
> only works on XFS, which makes testing hole punching on other fs's kind of
> difficult.  To fix this I've added an fiemap command that works almost exactly
> like bmap.  It is formatted similarly and takes similar flags, the only thing
> thats different is obviously it doesn't spit out AG info and it doesn't make
> finding prealloc space optional.  This is my first foray into all of this stuff
> so a good hard look would be appreciated.  I tested it with a few different
> files to make sure bmap and fiemap both looked the same.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
> V1->V2: add checks to make sure the system supports fiemap so xfsprogs builds on
> things other than linux :).
> +static void
> +fiemap_help(void)
> +{
> +	printf(_(
> +"\n"
> +" prints the block mapping for a file's data or attribute forks"
> +"\n"
> +" Example:\n"
> +" 'bmap -vp' - tabular format verbose map, including unwritten extents\n"

'fiemap -vp' ?

> +"\n"
> +" bmap prints the map of disk blocks used by the current file.\n"

fiemap prints...

> +" The map lists each extent used by the file, as well as regions in the\n"
> +" file that do not have any corresponding blocks (holes).\n"
> +" By default, each line of the listing takes the following form:\n"
> +"     extent: [startoffset..endoffset]: startblock..endblock\n"
> +" Holes are marked by replacing the startblock..endblock with 'hole'.\n"
> +" All the file offsets and disk blocks are in units of 512-byte blocks.\n"
> +" -a -- prints the attribute fork map instead of the data fork.\n"
> +" -l -- also displays the length of each extent in 512-byte blocks.\n"
> +" -n -- query n extents.\n"
> +" -v -- Verbose information\n"
> +" Note: the bmap for non-regular files can be obtained provided the file\n"
> +" was opened appropriately (in particular, must be opened read-only).\n"
> +"\n"));

This last note about non-regular files is not true for fiemap,
right?

> +}
> +
> +static int
> +numlen(
> +	__u64	val,
> +	int	base)
> +{
> +	__u64	tmp;
> +	int	len;
> +
> +	for (len = 0, tmp = val; tmp > 0; tmp = tmp/base)
> +		len++;
> +	return (len == 0 ? 1 : len);
> +}
> +
> +static void
> +print_verbose(
> +	struct fiemap_extent	*extent,
> +	int			blocksize,
> +	int			foff_w,
> +	int			boff_w,
> +	int			tot_w,
> +	int			flg_w,
> +	int			*cur_extent,
> +	__u64			*last_logical)
> +{
> +	__u64			lstart;
> +	__u64			len;
> +	__u64			block;
> +	char			lbuf[32];
> +	char			bbuf[32];

I don't think these two buffers are large enough to hold 2
64 bit integers as strings.

> +static void
> +print_plain(
> +	struct fiemap_extent	*extent,
> +	int			lflag,
> +	int			blocksize,
> +	int			*cur_extent,
> +	__u64			*last_logical)
> +{
> +	__u64			lstart;
> +	__u64			block;
> +	__u64			len;
> +
> +	lstart = extent->fe_logical / blocksize;
> +	len = extent->fe_length / blocksize;
> +	block = extent->fe_physical / blocksize;
> +
> +	if (lstart != *last_logical) {
> +		printf("\t%d: [%llu..%llu]: hole", *cur_extent,
> +		       *last_logical, lstart - 1LL);
> +		if (lflag)
> +			printf(_(" %llu blocks\n"),
> +			       lstart - *last_logical);
> +		else
> +			printf("\n");
> +		(*cur_extent)++;
> +	}
> +
> +	printf("\t%d: [%llu..%llu]: %llu..%llu", *cur_extent,
> +	       lstart, lstart + len - 1LL, block,
> +	       block + len - 1);

Why the "1LL" here and not anywhere else?

> +
> +	if (lflag)
> +		printf(_(" %llu blocks\n"), len);
> +	else
> +		printf("\n");
> +	(*cur_extent)++;
> +	*last_logical = lstart + len;
> +}
> +
> +int
> +fiemap_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	struct fiemap	*fiemap;
> +	int		num_extents = 32;
> +	int		nflag = 0;
> +	int		lflag = 0;
> +	int		vflag = 0;
> +	int		fiemap_flags = FIEMAP_FLAG_SYNC;
> +	int		c;
> +	int		i;
> +	int		map_size;
> +	int		ret;
> +	int		cur_extent = 0;
> +	int		foff_w = 16;	/* 16 just for a good minimum range */
> +	int		boff_w = 16;
> +	int		tot_w = 5;	/* 5 since its just one number */
> +	int		flg_w = 5;
> +	__u64		blocksize = 512;
> +	__u64		last_logical = 0;
> +	struct stat	st;
> +
> +	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
> +		switch (c) {
> +		case 'a':
> +			fiemap_flags |= FIEMAP_FLAG_XATTR;
> +			break;
> +		case 'l':
> +			lflag = 1;
> +			break;
> +		case 'n':
> +			num_extents = atoi(optarg);
> +			nflag = 1;
> +			break;
> +		case 'v':
> +			vflag++;
> +			break;
> +		default:
> +			return command_usage(&fiemap_cmd);
> +		}
> +	}
> +
> +	map_size = sizeof(struct fiemap) +
> +		(num_extents * sizeof(struct fiemap_extent));

Need to validate num_extents before using it.

> +	fiemap = malloc(map_size);
> +	if (!fiemap) {
> +		fprintf(stderr, _("%s: malloc of %d bytes failed.\n"),
> +			progname, map_size);
> +		exitcode = 1;
> +		return 0;
> +	}
> +
> +	memset(fiemap, 0, map_size);
> +	fiemap->fm_flags = fiemap_flags;
> +	fiemap->fm_length = -1;
> +	fiemap->fm_extent_count = nflag ? 0 : num_extents;
> +
> +	ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
> +	if (ret < 0) {
> +		fprintf(stderr, "%s: ioctl(FS_IOC_FIEMAP) [\"%s\"]: "
> +			"%s\n", progname, file->name, strerror(errno));
> +		free(fiemap);
> +		exitcode = 1;
> +		return 0;
> +	}
> +
> +	if (!nflag) {
> +		if (fiemap->fm_mapped_extents > num_extents) {
> +			num_extents = fiemap->fm_mapped_extents;
> +			map_size = sizeof(struct fiemap) +
> +				(num_extents * sizeof(struct fiemap_extent));
> +			fiemap = realloc(fiemap, map_size);
> +			if (!fiemap) {
> +				fprintf(stderr, _("%s: realloc of %d bytes "
> +						  "failed.\n"), progname,
> +						  map_size);
> +				exitcode = 1;
> +				return 0;
> +			}
> +		}
> +		memset(fiemap, 0, map_size);
> +		fiemap->fm_flags = fiemap_flags;
> +		fiemap->fm_length = -1;
> +		fiemap->fm_extent_count = num_extents;
> +
> +		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
> +		if (ret < 0) {
> +			fprintf(stderr, "%s: ioctl(FS_IOC_FIEMAP) [\"%s\"]: "
> +				"%s\n", progname, file->name, strerror(errno));
> +			free(fiemap);
> +			exitcode = 1;
> +			return 0;
> +		}
> +	}

Hmmm. I'd prefer to see a loop mapping and printing N extents at a
time rather than one massive allocation and hoping it fits in memory
(think of a file with hundreds of thousands of extents). That's a
problem with the existing xfs_bmap code - should we be duplicating
that problem here?

Otherwise seems fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
