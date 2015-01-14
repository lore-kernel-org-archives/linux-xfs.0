Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 359657F3F
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2015 14:16:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EA4428F8039
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2015 12:16:24 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OKYmAETmvuU0SZvK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 Jan 2015 12:16:19 -0800 (PST)
Date: Wed, 14 Jan 2015 15:16:10 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v8 11/11] xfstests: fsx: Add fallocate insert range
	operation
Message-ID: <20150114201610.GA49511@bfoster.bfoster>
References: <1421165126-3585-1-git-send-email-linkinjeon@gmail.com>
	<1421165126-3585-12-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421165126-3585-12-git-send-email-linkinjeon@gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, Jan 14, 2015 at 01:05:26AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This commit adds fallocate FALLOC_FL_INSERT_RANGE support for fsx.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> Cc: Brian Foster<bfoster@redhat.com>
> ---
> Changelog
> v8:
>  - create TRIM_OFF() and TRIM_LEN() and redeine redefine TRIM_OFF_LEN().
> 
>  ltp/fsx.c |  122 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 113 insertions(+), 9 deletions(-)
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 3709419..741af34 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -95,7 +95,8 @@ int			logcount = 0;	/* total ops */
>  #define OP_PUNCH_HOLE		6
>  #define OP_ZERO_RANGE		7
>  #define OP_COLLAPSE_RANGE	8
> -#define OP_MAX_FULL		9
> +#define OP_INSERT_RANGE	9
> +#define OP_MAX_FULL		10
>  
>  /* operation modifiers */
>  #define OP_CLOSEOPEN	100
> @@ -145,6 +146,7 @@ int     fallocate_calls = 1;            /* -F flag disables */
>  int     punch_hole_calls = 1;           /* -H flag disables */
>  int     zero_range_calls = 1;           /* -z flag disables */
>  int	collapse_range_calls = 1;	/* -C flag disables */
> +int	insert_range_calls = 1;		/* -i flag disables */
>  int 	mapped_reads = 1;		/* -R flag disables it */
>  int	fsxgoodfd = 0;
>  int	o_direct;			/* -Z */
> @@ -339,6 +341,14 @@ logdump(void)
>  						     lp->args[0] + lp->args[1])
>  				prt("\t******CCCC");
>  			break;
> +		case OP_INSERT_RANGE:
> +			prt("INSERT 0x%x thru 0x%x\t(0x%x bytes)",
> +			    lp->args[0], lp->args[0] + lp->args[1] - 1,
> +			    lp->args[1]);
> +			if (badoff >= lp->args[0] && badoff <
> +						     lp->args[0] + lp->args[1])
> +				prt("\t******CCCC");
> +			break;
>  		case OP_SKIPPED:
>  			prt("SKIPPED (no operation)");
>  			break;
> @@ -1012,6 +1022,59 @@ do_collapse_range(unsigned offset, unsigned length)
>  }
>  #endif
>  
> +#ifdef FALLOC_FL_INSERT_RANGE
> +void
> +do_insert_range(unsigned offset, unsigned length)
> +{
> +	unsigned end_offset;
> +	int mode = FALLOC_FL_INSERT_RANGE;
> +
> +	if (length == 0) {
> +		if (!quiet && testcalls > simulatedopcount)
> +			prt("skipping zero length insert range\n");
> +		log4(OP_SKIPPED, OP_INSERT_RANGE, offset, length);
> +		return;
> +	}
> +
> +	if ((loff_t)offset >= file_size) {
> +		if (!quiet && testcalls > simulatedopcount)
> +			prt("skipping insert range behind EOF\n");
> +		log4(OP_SKIPPED, OP_INSERT_RANGE, offset, length);
> +		return;
> +	}
> +
> +	log4(OP_INSERT_RANGE, offset, length, 0);
> +
> +	if (testcalls <= simulatedopcount)
> +		return;
> +
> +	end_offset = offset + length;
> +	if ((progressinterval && testcalls % progressinterval == 0) ||
> +	    (debug && (monitorstart == -1 || monitorend == -1 ||
> +		      end_offset <= monitorend))) {
> +		prt("%lu insert\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
> +			offset, offset+length, length);
> +	}
> +	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
> +		prt("insert range: %x to %x\n", offset, length);
> +		prterr("do_insert_range: fallocate");
> +		report_failure(161);
> +	}
> +
> +	memmove(good_buf + end_offset, good_buf + offset,
> +		file_size - offset);
> +	memset(good_buf + offset, '\0', length);
> +	file_size += length;
> +}
> +
> +#else
> +void
> +do_insert_range(unsigned offset, unsigned length)
> +{
> +	return;
> +}
> +#endif
> +
>  #ifdef HAVE_LINUX_FALLOC_H
>  /* fallocate is basically a no-op unless extending, then a lot like a truncate */
>  void
> @@ -1117,14 +1180,25 @@ docloseopen(void)
>  	}
>  }
>  
> -#define TRIM_OFF_LEN(off, len, size)	\
> -do {					\
> -	if (size)			\
> +
> +#define TRIM_OFF(off, size)	\
> +do {						\
> +	if (size)				\
>  		(off) %= (size);	\
> -	else				\
> -		(off) = 0;		\
> -	if ((off) + (len) > (size))	\
> -		(len) = (size) - (off);	\
> +	else					\
> +		(off) = 0;			\
> +} while (0)
> +
> +#define TRIM_LEN(off, len, size)	\
> +do {								\
> +	if ((off) + (len) > (size))		\
> +		(len) = (size) - (off);		\
> +} while (0)
> +
> +#define TRIM_OFF_LEN(off, len, size)	\
> +do {									\
> +	TRIM_OFF(off, size);				\
> +	TRIM_LEN(off, len, size);			\
>  } while (0)
>  
>  void
> @@ -1192,6 +1266,12 @@ test(void)
>  			goto out;
>  		}
>  		break;
> +	case OP_INSERT_RANGE:
> +		if (!insert_range_calls) {
> +			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
> +			goto out;
> +		}
> +		break;
>  	}
>  
>  	switch (op) {
> @@ -1244,6 +1324,22 @@ test(void)
>  		}
>  		do_collapse_range(offset, size);
>  		break;
> +	case OP_INSERT_RANGE:
> +		TRIM_OFF(offset, file_size);
> +		TRIM_LEN(offset, size, maxfilelen - file_size);

Ugh, I hit a crash down in do_insert_range() due to the memset() on
good_buf going off the end of the buffer. It looks like the TRIM_LEN()
here is not correct and can result in a really large length value.

Perhaps something like TRIM_LEN(file_size, length, maxfilelen) is what
we want for insert range ops?

Brian

> +		offset = offset & ~(block_size - 1);
> +		size = size & ~(block_size - 1);
> +		if (size == 0) {
> +			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
> +			goto out;
> +		}
> +		if (file_size + size > maxfilelen) {
> +			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
> +			goto out;
> +		}
> +
> +		do_insert_range(offset, size);
> +		break;
>  	default:
>  		prterr("test: unknown operation");
>  		report_failure(42);
> @@ -1307,6 +1403,9 @@ usage(void)
>  #ifdef FALLOC_FL_COLLAPSE_RANGE
>  "	-C: Do not use collapse range calls\n"
>  #endif
> +#ifdef FALLOC_FL_INSERT_RANGE
> +"	-i: Do not use insert range calls\n"
> +#endif
>  "	-L: fsxLite - no file creations & no file size changes\n\
>  	-N numops: total # operations to do (default infinity)\n\
>  	-O: use oplen (see -o flag) for every op (default random)\n\
> @@ -1493,7 +1592,7 @@ main(int argc, char **argv)
>  
>  	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
>  
> -	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHzCLN:OP:RS:WZ"))
> +	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHzCiLN:OP:RS:WZ"))
>  	       != EOF)
>  		switch (ch) {
>  		case 'b':
> @@ -1599,6 +1698,9 @@ main(int argc, char **argv)
>  		case 'C':
>  			collapse_range_calls = 0;
>  			break;
> +		case 'i':
> +			insert_range_calls = 0;
> +			break;
>  		case 'L':
>  		        lite = 1;
>  			break;
> @@ -1758,6 +1860,8 @@ main(int argc, char **argv)
>  		zero_range_calls = test_fallocate(FALLOC_FL_ZERO_RANGE);
>  	if (collapse_range_calls)
>  		collapse_range_calls = test_fallocate(FALLOC_FL_COLLAPSE_RANGE);
> +	if (insert_range_calls)
> +		insert_range_calls = test_fallocate(FALLOC_FL_INSERT_RANGE);
>  
>  	while (numops == -1 || numops--)
>  		test();
> -- 
> 1.7.9.5
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
