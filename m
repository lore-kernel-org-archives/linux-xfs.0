Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9PMRZYf166843 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 17:27:36 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	OG6EdizthUJNhZ3a for <xfs@oss.sgi.com>;
	Thu, 25 Oct 2012 15:29:16 -0700 (PDT)
Date: Fri, 26 Oct 2012 09:29:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs_io: [v3] add the lseek() SEEK_DATA/SEEK_HOLE
	support
Message-ID: <20121025222914.GE29378@dastard>
References: <20121022213759.033667921@sgi.com>
	<20121022213804.616209844@sgi.com> <20121022232931.GD4291@dastard>
	<20121023200144.515107339@sgi.com>
	<20121025141450.995788000@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121025141450.995788000@sgi.com>
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

On Thu, Oct 25, 2012 at 09:14:44AM -0500, Mark Tinguely wrote:
> Add the lseek SEEK_DATA/SEEK_HOLE support into xfs_io.
> The result from the lseek() call will be printed to the output.
> For example:
> 
> xfs_io> lseek -h 609k
> Type	Offset
> hole	630784
> 
> v1 -> v2 Add "-a" and "-r" options.
> 	 Simplify the output.
> v2 -> v3 Refactor for configure.in -> configure.ac change.
> 	 SEEK_DATA with -1 offset behaves badly on older Linux.
> 	 Display error message as "ERR <errno>".
....
> +
> +#include <linux/fs.h>

I missed this first time around - why is this include necessary?

> +#define	LSEEK_DFLAG	1 << 0
> +#define	LSEEK_HFLAG	1 << 1
> +#define	LSEEK_RFLAG	1 << 2

Need parenthesis there, i.e. "(1 << 0)", so we don't get weird bugs
due to operator precendence causing unintended behaviour, but....

> +static int
> +lseek_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	off64_t		offset, roff;
> +	size_t          fsblocksize, fssectsize;
> +	int		cseg;
> +	int		flag;
> +	int		i, c;
> +
> +	flag = 0;
> +	init_cvtnum(&fsblocksize, &fssectsize);
> +
> +	while ((c = getopt(argc, argv, "adhr")) != EOF) {
> +		switch (c) {
> +		case 'a':
> +			flag |= LSEEK_HFLAG;
> +			/* fall through to pick up the DFLAG */

I'd just set the flags directly - much more obvious, less likely to
go wrong in the future...

> +	offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
> +
> +	/* recursively display all information, decide where to start. */
> +	roff = lseek64(file->fd, offset, SEEK_DATA);
> +	if (roff == offset)
> +		cseg = LSEEK_DFLAG;
> +	else
> +		cseg = LSEEK_HFLAG;

I'm not really sure what these variables mean. "roff" is returned
offset, "cseg" is current segment? Perhaps a comment or a better
names is in order because right now I'm guessing at what a segment
is as it is not referenced in any of the comments...

> +	
> +	printf("Type	offset\n");
> +
> +	/* loop to handle the data / hole entries in assending order.
> +	 * Only display the EOF when the initial offset was greater
> +	 * the end of file.
> +	 */
> +	for (i = 0; flag & LSEEK_RFLAG || i < 2; i++) {

I'm very surprised gcc doesn't warn here about lack of parenthesis.

As it is, I think the code would be much clearer if you separated
the non-recursive case from the recursive case given it took me 20
minutes to work out whether this loop worked correctly for both
cases (e.g. why does it need 2 loops instead of 1 for the non
recursive case, and does the double loop behaviour give the right
results?). Something like:

	if (!(flags & RECURSIVE))
		return seek_single(offset, flags);

	return seek_recursive(offset, flags);

makes the simple case is easy to verify correct (it's just a
single seek), and the recursive case doesn't get complicated by the
requirements of the single seek case. That results in code that is
much easier to maintain and modify in future....

> +		if (cseg == LSEEK_DFLAG) {
> +			if (flag & LSEEK_DFLAG) {
> +				roff = lseek64(file->fd, offset, SEEK_DATA);
> +				if (roff == -1) {
> +					if (i < 2) {
> +						if (errno == ENXIO)
> +							printf("data	EOF\n");
> +						else
> +							printf("data	ERR %d\n",
> +								errno);
> +					}

Why would you only print a seek error for the first seek? I
would have thought that the recursive case also needs differentiate
between an error and EOF detection.

> +				} else
> +					printf("data	%lld\n", roff);
> +			}
> +			/* set the offset and type for the next iteration */
> +			cseg = LSEEK_HFLAG;
> +			roff = lseek64(file->fd, offset, SEEK_HOLE);
> +			if (roff != -1)
> +				offset = roff;
> +			continue;

This extra seek only needs to be done if LSEEK_HFLAG is not set
to move the offset to the point where the next SEEK_DATA will find
the next data extent....

> +		}
> +
> +		/* cseg == LSEEK_HFLAG */
> +		if (flag & LSEEK_HFLAG) {
> +			roff = lseek64(file->fd, offset, SEEK_HOLE);

But if LSEEK_HFLAG is set, we do the same seek anyway on the next
loop iteration. The logic currently is:

	loop {
		if (in data) {
			if (seek data) {
				move to next data
				print
			}
			move to next hole
			update offset
			continue
		}
		/* in hole */
		if (seek hole) {
			move to next hole
			print
		}
		move to next data
		update offset
	}

Effectively, the loop is only dealing with a data extent or a hole
extent in each loop. But given that holes and data always alternate,
the same canbe acheived in a single loop:

	loop {
		move to next data
		if (data)
			print
		update offset
		move to next hole
		if (hole)
			print
		update offset
	}

And the initial loop start (i.e. offset starts in a hole or data)
can be handled with a simple "skip data" variable that is cleared on
the first pass through the loop. This gets rid of needing to track
the current segment type and gets rid of the redundant seeks to the
same offset when dumping both data and holes....

And the printing can become a simple functions that takes a "data"
or "hole" string and can be common for all callers (single and
recursive)...

> +lseek_init(void)
> +{
> +	lseek_cmd.name = "lseek";
> +	lseek_cmd.altname = "seek";

I'd just call them both "seek" - the "l" part of the lseek() call is
an implementation detail.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
