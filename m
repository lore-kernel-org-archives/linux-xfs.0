Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5C2D77F3F
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 21:21:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2CB8D8F8033
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 19:21:48 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	AlQQIZtRVvveYtEK for <xfs@oss.sgi.com>;
	Mon, 21 Sep 2015 19:21:44 -0700 (PDT)
Date: Tue, 22 Sep 2015 12:17:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/11] xfs_io: support reflinking and deduping file ranges
Message-ID: <20150922021755.GF19114@dastard>
References: <20150826003220.23973.59731.stgit@birch.djwong.org>
	<20150826003311.23973.64761.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150826003311.23973.64761.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 25, 2015 at 05:33:11PM -0700, Darrick J. Wong wrote:
> +static int
> +dedupe_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	off64_t		soffset, doffset;
> +	long long	count, total;
> +	char		s1[64], s2[64], ts[64];

Magic!

> +	char		*infile;
> +	int		Cflag, qflag, wflag, Wflag;

Urk. Variables that differ only by case!

> +	struct xfs_ioctl_file_extent_same_args	*args = NULL;
> +	struct xfs_ioctl_file_extent_same_info	*info;

verbosity--;

> +	size_t		fsblocksize, fssectsize;
> +	struct timeval	t1, t2;
> +	int		c, fd = -1;
> +
> +	Cflag = qflag = wflag = Wflag = 0;
> +	init_cvtnum(&fsblocksize, &fssectsize);
> +
> +	while ((c = getopt(argc, argv, "CqwW")) != EOF) {
> +		switch (c) {
> +		case 'C':
> +			Cflag = 1;
> +			break;
> +		case 'q':
> +			qflag = 1;
> +			break;
> +		case 'w':
> +			wflag = 1;
> +			break;
> +		case 'W':
> +			Wflag = 1;
> +			break;
> +		default:
> +			return command_usage(&dedupe_cmd);
> +		}
> +	}
> +	if (optind != argc - 4)
> +		return command_usage(&dedupe_cmd);
> +	infile = argv[optind];
> +	optind++;
> +	soffset = cvtnum(fsblocksize, fssectsize, argv[optind]);
> +	if (soffset < 0) {
> +		printf(_("non-numeric src offset argument -- %s\n"), argv[optind]);
> +		return 0;
> +	}
> +	optind++;
> +	doffset = cvtnum(fsblocksize, fssectsize, argv[optind]);
> +	if (doffset < 0) {
> +		printf(_("non-numeric dest offset argument -- %s\n"), argv[optind]);
> +		return 0;
> +	}
> +	optind++;
> +	count = cvtnum(fsblocksize, fssectsize, argv[optind]);
> +	if (count < 1) {
> +		printf(_("non-positive length argument -- %s\n"), argv[optind]);
> +		return 0;
> +	}
> +
> +	c = IO_READONLY;
> +	fd = openfile(infile, NULL, c, 0);
> +	if (fd < 0)
> +		return 0;
> +
> +	gettimeofday(&t1, NULL);
> +	args = calloc(1, sizeof(struct xfs_ioctl_file_extent_same_args) +
> +			 sizeof(struct xfs_ioctl_file_extent_same_info));
> +	if (!args)
> +		goto done;
> +	info = (struct xfs_ioctl_file_extent_same_info *)(args + 1);
> +	args->logical_offset = soffset;
> +	args->length = count;
> +	args->dest_count = 1;
> +	info->fd = file->fd;
> +	info->logical_offset = doffset;
> +	do {
> +		c = ioctl(fd, XFS_IOC_FILE_EXTENT_SAME, args);
> +		if (c)
> +			break;
> +		args->logical_offset += info->bytes_deduped;
> +		info->logical_offset += info->bytes_deduped;
> +		args->length -= info->bytes_deduped;
> +	} while (c == 0 && info->status == 0 && info->bytes_deduped > 0);

What's "c"? it's actually a return value, and it's already been
handled if it's non zero. and there's nothing preventing
args->length from going negative.

> +	if (c)
> +		perror(_("dedupe ioctl"));
> +	if (info->status < 0)
> +		printf("dedupe: %s\n", _(strerror(-info->status)));
> +	if (info->status == XFS_SAME_DATA_DIFFERS)

"same data differs"? Really? :P

> +		printf(_("Extents did not match.\n"));

And putting hte error messages outside the loop is going to be hard
to maintain. I'd much prefer to see this written as:

	while (args->length > 0) {
		result = ioctl(fd, XFS_IOC_FILE_EXTENT_SAME, args);
		if (result) {
			perror("XFS_IOC_FILE_EXTENT_SAME");
			goto done;
		}
		if (info->status != 0) {
			printf("dedupe: %s\n", _(strerror(-info->status)));
			if (info->status == XFS_SAME_DATA_DIFFERS)
				printf(_("Extents did not match.\n"));
			goto done;
		}
		if (info->bytes_deduped == 0)
			break;

		args->logical_offset += info->bytes_deduped;
		info->logical_offset += info->bytes_deduped;
		args->length -= info->bytes_deduped;
	}

Actually, I'd really lik eto see this bit factored out into a
separate function, so there's clear separation between arg parsing,
the operation and post-op cleanup.

> +	total = info->bytes_deduped;
> +	c = 1;
> +	if (Wflag)
> +		fsync(file->fd);
> +	if (wflag)
> +		fdatasync(file->fd);

So these flags are just for syncing. This does not need to be a part
of this function, because the user can simply do:

xfs_io -c "dedupe ...." -c "fsync" ...

if an fsync or fdatasync is required after dedupe. So kill those
options.


> +	if (qflag)
> +		goto done;

Urk.

> +	gettimeofday(&t2, NULL);
> +	t2 = tsub(t2, t1);
> +
> +	/* Finally, report back -- -C gives a parsable format */
> +	timestr(&t2, ts, sizeof(ts), Cflag ? VERBOSE_FIXED_TIME : 0);
> +	if (!Cflag) {
> +		cvtstr((double)total, s1, sizeof(s1));
> +		cvtstr(tdiv((double)total, t2), s2, sizeof(s2));
> +		printf(_("linked %lld/%lld bytes at offset %lld\n"),
> +			total, count, (long long)doffset);
> +		printf(_("%s, %d ops; %s (%s/sec and %.4f ops/sec)\n"),
> +			s1, c, ts, s2, tdiv((double)c, t2));
> +	} else {/* bytes,ops,time,bytes/sec,ops/sec */
> +		printf("%lld,%d,%s,%.3f,%.3f\n",
> +			total, c, ts,
> +			tdiv((double)total, t2), tdiv((double)c, t2));
> +	}

This must be common with other timing code. Factor it out?

> +static void
> +reflink_help(void)
> +{
> +	printf(_(
> +"\n"
> +" Links a range of bytes (in block size increments) from a file into a range \n"
> +" of bytes in the open file.  The two extent ranges need not contain identical\n"
> +" data. \n"
> +"\n"
> +" Example:\n"
> +" 'reflink some_file 0 4096 32768' - links 32768 bytes from some_file at \n"
> +"                                    offset 0 to into the open file at \n"
> +"                                    position 4096\n"
> +" 'reflink some_file' - links all bytes from some_file into the open file\n"
> +"                       at position 0\n"
> +"\n"
> +" Reflink a range of blocks from a given input file to the open file.  Both\n"
> +" files share the same range of physical disk blocks; a write to the shared\n"
> +" range of either file should result in the write landing in a new block and\n"
> +" that range of the file being remapped (i.e. copy-on-write).  Both files\n"
> +" must reside on the same filesystem.\n"
> +" -w   -- call fdatasync(2) at the end (included in timing results)\n"
> +" -W   -- call fsync(2) at the end (included in timing results)\n"
> +"\n"));
> +}

FWIW, could these just be a single string like:

"
 Links a range of bytes (in block size increments) from a file into a range
 of bytes in the open file.  The two extent ranges need not contain identical
....
\n"));

So we don't have to mangle the entire layout if we modify the help
tet in future?

> +static int
> +reflink_f(
> +	int		argc,
> +	char		**argv)
> +{

Same comments as the dedupe_f() function about factoring and
variable names and reusing "c" for a bunch of unrelated values.

indeed, most of this is common with the dedupe_f function, so
perhaps it might be worth putting them in the same file and
factoring them appropriately to shared common elements?

> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index 89689c6..0c922ad 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -559,6 +559,42 @@ typedef struct xfs_swapext
>  #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
>  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
>  
> +/* reflink ioctls; these MUST match the btrfs ioctl definitions */
> +struct xfs_ioctl_clone_range_args {
> +	__s64 src_fd;
> +	__u64 src_offset;
> +	__u64 src_length;
> +	__u64 dest_offset;
> +};

struct xfs_clone_args

> +
> +#define XFS_SAME_DATA_DIFFERS	1

#define XFS_EXTENT_DATA_SAME		0
#define XFS_EXTENT_DATA_DIFFERS		1

> +/* For extent-same ioctl */
> +struct xfs_ioctl_file_extent_same_info {
> +	__s64 fd;		/* in - destination file */
> +	__u64 logical_offset;	/* in - start of extent in destination */
> +	__u64 bytes_deduped;	/* out - total # of bytes we were able
> +				 * to dedupe from this file */
> +	/* status of this dedupe operation:
> +	 * 0 if dedup succeeds
> +	 * < 0 for error
> +	 * == XFS_SAME_DATA_DIFFERS if data differs
> +	 */
> +	__s32 status;		/* out - see above description */
> +	__u32 reserved;
> +};

struct xfs_extent_data_info

> +
> +struct xfs_ioctl_file_extent_same_args {
> +	__u64 logical_offset;	/* in - start of extent in source */
> +	__u64 length;		/* in - length of extent */
> +	__u16 dest_count;	/* in - total elements in info array */
> +	__u16 reserved1;
> +	__u32 reserved2;
> +	struct xfs_ioctl_file_extent_same_info info[0];
> +};

struct xfs_extent_data

> +
> +#define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
> +#define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_ioctl_clone_range_args)
> +#define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_ioctl_file_extent_same_args)

FWIW, these structure and ioctl definitions really need to be in a
separate patch as they need to be shared with the kernel code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
