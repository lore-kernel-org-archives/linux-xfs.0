Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9MNSIDS166865 for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 18:28:18 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	xEU6Vnm7k4YEdiBj for <xfs@oss.sgi.com>;
	Mon, 22 Oct 2012 16:29:59 -0700 (PDT)
Date: Tue, 23 Oct 2012 10:29:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: add the lseek() SEEK_DATA/SEEK_HOLE support
Message-ID: <20121022232931.GD4291@dastard>
References: <20121022213759.033667921@sgi.com>
	<20121022213804.616209844@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121022213804.616209844@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 22, 2012 at 04:38:00PM -0500, Mark Tinguely wrote:
> Add the lseek() SEEK_DATA/SEEK_HOLE support into xfs_io.
> The result from the lseek() call is printed to the output:
>   xfs_io> lseek -h 609k
>   lseek for hole starting at offset 623616 result offset 630784

Nice, though I think the output is too verbose. We really want to
make it easy to parse, and we don't need to know what offset the
seek started at as that is in the command. i.e. something like:

Type		Offset
HOLE		630784

or:

DATA found at 524288

If probably all that is necessary. Indeed, one thing that might be
useful is adding a "-r" option to dump out the result of repeated
seeks of the same type, so if you were to do something like:

xfs_io> lseek -r -d 0
Type		Offset
DATA		0
DATA		65536
DATA		524288
xfs_io> lseek -r -h 0
Type		Offset
HOLE		16384
HOLE		131072
HOLE		1049576

If we then add a "-a" option to dump "all", it could alternate
data/hole after determining if the first offset is a hole or data:

xfs_io> lseek -r -a 0
DATA		0
HOLE		16384
DATA		65536
HOLE		131072
DATA		524288
HOLE		1049576

That gives us a method of verifying the basic layout of the file and
that the basic data/hole search operation (i.e. what cp will do)
works correctly via a single command in a test.

> +#define _LARGEFILE64_SOURCE     /* See feature_test_macros(7) */

That's defined by _GNU_SOURCE, which is set in the makefiles, so not
necessary here.

> +static void
> +lseek_help(void)
> +{
> +	printf(_(
> +"\n"
> +" returns the next hole or data offset at or after the specified offset\n"
> +"\n"
> +" Example:\n"
> +" 'lseek -d 512'  - offset of data at or following offset 512\n"
> +"\n"
> +" Repositions and returns the offset of either the next data or hole.\n"
> +" There is an implied hole at the end of file. If the specified offset is\n"
> +" past end of file, or there is no data past the specied offset, the offset\n"
> +" -1 is returned.\n"

I'd prefer that "EOF" rather than "-1" is printed in this case.

> +" -d   -- search for data starting at the specified offset.\n"
> +" -h   -- search for a hole starting at the specified offset.\n"
> +"\n"));
> +}
> +
> +static int
> +lseek_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	off64_t		offset, res_off;
> +	size_t          fsblocksize, fssectsize;
> +	int		flag;
> +	int		c;
> +
> +	flag = 0;
> +	init_cvtnum(&fsblocksize, &fssectsize);
> +
> +	while ((c = getopt(argc, argv, "dh")) != EOF) {
> +		switch (c) {
> +		case 'd':
> +			flag = SEEK_DATA;
> +			break;
> +		case 'h':
> +			flag = SEEK_HOLE;
> +			break;
> +		default:
> +			return command_usage(&lseek_cmd);
> +		}
> +	}
> +	if (!flag  || optind > 2)
> +		return command_usage(&lseek_cmd);
> +	offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
> +	res_off = lseek64(file->fd, offset, flag);
> +	printf("lseek for %s starting at offset %lld result offset %lld\n",
> +		(flag == SEEK_DATA) ? "data" : "hole",	offset, res_off);

I think that needs the _("....") around the format string.

Also, you need to check for ENXIO for a seek beyond EOF rather than
some other execution error encountered during the lseek. i.e. ENXIO
is a valid result, while something like EINVAL or EBADF indicates an
actual error. I think that needs to be differentiated in the output.

>  or by path
>  .RB ( \-i ).
> +.TP
> +.BI "lseek [ \-b " offset " | \-h " offset " ]
                 ^^ -d

The parameters aren't optional - that's what the "[ ... ]" brackets
indicate. i.e. this will render like:

	lseek [ -b _offset_ | -h _offset_ ]

indicating lseek can be executed without parameters successfully.
If should probably render like:

	lseek -d | -h _offset_

Indicating that you must select either -d or -h, and you must supply
an offset parameter....

> +Repositions and prints the file pointer to the next offset containing data
> +.RB ( \-d )
> +or next offset containing a hole 
> +.RB ( \-h )

Given that we only support pread and pwrite operations, the
repositioning of the file pointer is irrelevant so probably should
not be mentioned. If it was relevant, then we'd also need to support
the other seek modes to reposition the file pointer. So jsut
mentioning that it returns the offset of the next ... is probably
sufficient here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
