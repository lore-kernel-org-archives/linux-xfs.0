Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p53JGnxV029728 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 14:16:49 -0500
Received: from e3.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA20649AFC9
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2011 12:16:48 -0700 (PDT)
Received: from e3.ny.us.ibm.com (e3.ny.us.ibm.com [32.97.182.143]) by
	cuda.sgi.com with ESMTP id jNZOLYisS0ZQRw5b for
	<xfs@oss.sgi.com>; Fri, 03 Jun 2011 12:16:48 -0700 (PDT)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p53IsVDW023825
	for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 14:54:31 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p53JGlLP092674 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 15:16:47 -0400
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p53DGd5Z006027
	for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 07:16:40 -0600
Message-ID: <4DE93316.3080208@linux.vnet.ibm.com>
Date: Fri, 03 Jun 2011 12:16:38 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Fwd: Re: [XFSTEST Add Fallocate Punch Hole Tests 1/3 v4] Add Punch
	Hole	to FSX
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>



-------- Original Message --------
Subject: Re: [XFSTEST Add Fallocate Punch Hole Tests 1/3 v4] Add Punch 
Hole	to FSX
Date: Wed, 01 Jun 2011 16:01:18 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
To: xfs-oss <xfs@oss.sgi.com>

On 5/25/2011 7:34 PM, Allison Henderson wrote:
> This patch adds punch hole tests to the fsx stress test.
>
> Signed-off-by: Allison Henderson<achender@us.ibm.com>
>
> v1 ->  v2:
> Corrections to the Makefile have been backed out.
> Those corrections have been addressed in the
> "xfstests: clean up fallocate configuration tests"
> patch
>
> The punch hole tests can be disabled with the
> -H flag, and will also be disabled if it is
> detected that the filesystem does not support
> punch hole
>
> v2 ->  v4
> Punch hole tests and functionality tests have been moved
> into their own functions.  Existing dofallocate routine
> has been renamed to do_preallocate.
> ---
> :100644 100755 fe072d3... a55b6f7... M	ltp/fsx.c
>   ltp/fsx.c |  140 +++++++++++++++++++++++++++++++++++++++++++++++++++++--------
>   1 files changed, 122 insertions(+), 18 deletions(-)
>
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> old mode 100644
> new mode 100755
> index fe072d3..a55b6f7
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -69,6 +69,7 @@ int			logcount = 0;	/* total ops */
>   #define OP_MAPWRITE	6
>   #define OP_SKIPPED	7
>   #define OP_FALLOCATE	8
> +#define OP_PUNCH_HOLE	9
>
>   #undef PAGE_SIZE
>   #define PAGE_SIZE       getpagesize()
> @@ -110,6 +111,7 @@ int	randomoplen = 1;		/* -O flag disables it */
>   int	seed = 1;			/* -S flag */
>   int     mapped_writes = 1;              /* -W flag disables */
>   int     fallocate_calls = 1;            /* -F flag disables */
> +int     punch_hole_calls = 1;           /* -H flag disables */
>   int 	mapped_reads = 1;		/* -R flag disables it */
>   int	fsxgoodfd = 0;
>   int	o_direct;			/* -Z */
> @@ -279,6 +281,14 @@ logdump(void)
>   			    badoff<  lp->args[0] + lp->args[1])
>   				prt("\t******FFFF");
>   			break;
> +		case OP_PUNCH_HOLE:
> +			prt("PUNCH HOLE\t0x%x thru 0x%x\t(0x%x bytes)",
> +			    lp->args[0], lp->args[0] + lp->args[1] - 1,
> +			    lp->args[1]);
> +			if (badoff>= lp->args[0]&&  badoff<
> +						     lp->args[0] + lp->args[1])
> +				prt("\t******PPPP");
> +			break;
>   		case OP_SKIPPED:
>   			prt("SKIPPED (no operation)");
>   			break;
> @@ -784,10 +794,67 @@ dotruncate(unsigned size)
>   	}
>   }
>
> +#ifdef FALLOC_FL_PUNCH_HOLE
> +void
> +do_punch_hole(unsigned offset, unsigned length)
> +{
> +	unsigned end_offset;
> +	int max_offset = 0;
> +	int max_len = 0;
> +	int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
> +
> +	if (length == 0) {
> +		if (!quiet&&  testcalls>  simulatedopcount)
> +			prt("skipping zero length punch hole\n");
> +			log4(OP_SKIPPED, OP_PUNCH_HOLE, offset, length);
> +		return;
> +	}
> +
> +	if (file_size<= (loff_t)offset) {
> +		if (!quiet&&  testcalls>  simulatedopcount)
> +			prt("skipping hole punch off the end of the file\n");
> +			log4(OP_SKIPPED, OP_PUNCH_HOLE, offset, length);
> +		return;
> +	}
> +
> +	end_offset = offset + length;
> +
> +	log4(OP_PUNCH_HOLE, offset, length, 0);
> +
> +	if (testcalls<= simulatedopcount)
> +		return;
> +
> +	if ((progressinterval&&  testcalls % progressinterval == 0) ||
> +	    (debug&&  (monitorstart == -1 || monitorend == -1 ||
> +		      end_offset<= monitorend))) {
> +		prt("%lu punch\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
> +			offset, offset+length, length);
> +	}
> +	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
> +		prt("%punch hole: %x to %x\n", offset, length);
> +		prterr("do_punch_hole: fallocate");
> +		report_failure(161);
> +	}
> +
> +
> +	max_offset = offset<  file_size ? offset : file_size;
> +	max_len = max_offset + length<= file_size ? length :
> +			file_size - max_offset;
> +	memset(good_buf + max_offset, '\0', max_len);
> +}
> +
> +#else
> +void
> +do_punch_hole(unsigned offset, unsigned length)
> +{
> +	return;
> +}
> +#endif
> +
>   #ifdef FALLOCATE
>   /* fallocate is basically a no-op unless extending, then a lot like a truncate */
>   void
> -dofallocate(unsigned offset, unsigned length)
> +do_preallocate(unsigned offset, unsigned length)
>   {
>   	unsigned end_offset;
>   	int keep_size;
> @@ -831,13 +898,13 @@ dofallocate(unsigned offset, unsigned length)
>   		prt("%lu falloc\tfrom 0x%x to 0x%x\n", testcalls, offset, length);
>   	if (fallocate(fd, keep_size ? FALLOC_FL_KEEP_SIZE : 0, (loff_t)offset, (loff_t)length) == -1) {
>   	        prt("fallocate: %x to %x\n", offset, length);
> -		prterr("dofallocate: fallocate");
> +		prterr("do_preallocate: fallocate");
>   		report_failure(161);
>   	}
>   }
>   #else
>   void
> -dofallocate(unsigned offset, unsigned length)
> +do_preallocate(unsigned offset, unsigned length)
>   {
>   	return;
>   }
> @@ -895,8 +962,7 @@ test(void)
>   	unsigned long	offset;
>   	unsigned long	size = maxoplen;
>   	unsigned long	rv = random();
> -	unsigned long	op = rv % (3 + !lite + mapped_writes + fallocate_calls);
> -
> +	unsigned long	op = rv % (3 + !lite + mapped_writes + fallocate_calls + punch_hole_calls);
>           /* turn off the map read if necessary */
>
>           if (op == 2&&  !mapped_reads)
> @@ -924,6 +990,7 @@ test(void)
>   	 * TRUNCATE:	op = -     3
>   	 * MAPWRITE:    op = 3     4
>   	 * FALLOCATE:   op = -     5
> +	 * PUNCH HOLE:  op = -     6
>   	 */
>   	if (lite ? 0 : op == 3&&  (style&  1) == 0) /* vanilla truncate? */
>   		dotruncate(random() % maxfilelen);
> @@ -941,7 +1008,12 @@ test(void)
>   				offset %= maxfilelen;
>   				if (offset + size>  maxfilelen)
>   					size = maxfilelen - offset;
> -				dofallocate(offset, size);
> +				do_preallocate(offset, size);
> +			} else if (op == 6) {
> +				offset %= maxfilelen;
> +				if (offset + size>  maxfilelen)
> +					size = maxfilelen - offset;
> +				do_punch_hole(offset, size);
>   			} else if (op == 1 || op == (lite ? 3 : 4)) {
>   				/* write / mapwrite */
>   				offset %= maxfilelen;
> @@ -1013,6 +1085,9 @@ usage(void)
>   #ifdef FALLOCATE
>   "	-F: Do not use fallocate (preallocation) calls\n"
>   #endif
> +#ifdef FALLOC_FL_PUNCH_HOLE
> +"       -H: Do not use punch hole calls\n"
> +#endif
>   "	-L: fsxLite - no file creations&  no file size changes\n\
>   	-N numops: total # operations to do (default infinity)\n\
>   	-O: use oplen (see -o flag) for every op (default random)\n\
> @@ -1161,6 +1236,41 @@ int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
>
>   #endif
>
> +void
> +test_fallocate()
> +{
> +#ifdef FALLOCATE
> +	if (!lite&&  fallocate_calls) {
> +		if (fallocate(fd, 0, 0, 1)&&  errno == EOPNOTSUPP) {
> +			warn("main: filesystem does not support fallocate, disabling");
> +			fallocate_calls = 0;
> +		} else {
> +			ftruncate(fd, 0);
> +		}
> +	}
> +#else /* ! FALLOCATE */
> +	fallocate_calls = 0;
> +#endif
> +}
> +
> +void
> +test_punch_hole()
> +{
> +#ifdef FALLOC_FL_PUNCH_HOLE
> +	if (!lite&&  punch_hole_calls) {
> +		if (fallocate(fd, 0, 0,
> +			FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)&&
> +			errno == EOPNOTSUPP) {
> +
> +			warn("main: filesystem does not support fallocate punch hole, disabling");
> +			punch_hole_calls = 0;
> +		}
> +	}
> +#else /* ! PUNCH HOLE */
> +	punch_hole_calls = 0;
> +#endif
> +}
> +
>   int
>   main(int argc, char **argv)
>   {
> @@ -1179,7 +1289,7 @@ main(int argc, char **argv)
>
>   	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
>
> -	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FLN:OP:RS:WZ"))
> +	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHLN:OP:RS:WZ"))
>   	       != EOF)
>   		switch (ch) {
>   		case 'b':
> @@ -1276,6 +1386,9 @@ main(int argc, char **argv)
>   		case 'F':
>   			fallocate_calls = 0;
>   			break;
> +		case 'H':
> +			punch_hole_calls = 0;
> +			break;
>   		case 'L':
>   		        lite = 1;
>   			break;
> @@ -1421,17 +1534,8 @@ main(int argc, char **argv)
>   	} else
>   		check_trunc_hack();
>
> -#ifdef FALLOCATE
> -	if (!lite&&  fallocate_calls) {
> -		if (fallocate(fd, 0, 0, 1)&&  errno == EOPNOTSUPP) {
> -			warn("main: filesystem does not support fallocate, disabling");
> -			fallocate_calls = 0;
> -		} else
> -			ftruncate(fd, 0);
> -	}
> -#else /* ! FALLOCATE */
> -	fallocate_calls = 0;
> -#endif
> +	test_fallocate();
> +	test_punch_hole();
>
>   	while (numops == -1 || numops--)
>   		test();



Hi all,

I just wanted to poke this patch set before too much time gets away.
Most of the changes that happened between v3 and v4 were discussed in
the previous threads.  I updated my xfstest recently and noticed that
some activity in this code has caused the patch not to apply, so I may
need to send out an update, but if anyone has any more comments please
let me know so I can add them in.  Thx!

Allison Henderson


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
