Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42718 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731618AbeKVMwd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 07:52:33 -0500
Date: Wed, 21 Nov 2018 18:15:15 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/10] fsx: always check buffer after each operation
Message-ID: <20181122021515.GD6783@magnolia>
References: <154275100143.8611.10235098565750994724.stgit@magnolia>
 <154275101368.8611.120389888153356093.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154275101368.8611.120389888153356093.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Nov 20, 2018 at 01:56:53PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new option to make fsx read the file after each operation and
> compare it with the good buffer to try to catch corruptions as soon as
> they occur.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  ltp/fsx.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 56 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 5601c70c..4b3a5d5a 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -160,7 +160,8 @@ int     punch_hole_calls = 1;           /* -H flag disables */
>  int     zero_range_calls = 1;           /* -z flag disables */
>  int	collapse_range_calls = 1;	/* -C flag disables */
>  int	insert_range_calls = 1;		/* -I flag disables */
> -int 	mapped_reads = 1;		/* -R flag disables it */
> +int	mapped_reads = 1;		/* -R flag disables it */
> +int	check_file = 1;			/* -X flag disables */
>  int	integrity = 0;			/* -i flag */
>  int	fsxgoodfd = 0;
>  int	o_direct;			/* -Z */
> @@ -561,7 +562,7 @@ dump_fsync_buffer(void)
>  }
>  
>  void
> -check_buffers(unsigned offset, unsigned size)
> +check_buffers(char *buf, unsigned offset, unsigned size)
>  {
>  	unsigned char c, t;
>  	unsigned i = 0;
> @@ -569,19 +570,19 @@ check_buffers(unsigned offset, unsigned size)
>  	unsigned op = 0;
>  	unsigned bad = 0;
>  
> -	if (memcmp(good_buf + offset, temp_buf, size) != 0) {
> +	if (memcmp(good_buf + offset, buf, size) != 0) {
>  		prt("READ BAD DATA: offset = 0x%x, size = 0x%x, fname = %s\n",
>  		    offset, size, fname);
>  		prt("OFFSET\tGOOD\tBAD\tRANGE\n");
>  		while (size > 0) {
>  			c = good_buf[offset];
> -			t = temp_buf[i];
> +			t = buf[i];
>  			if (c != t) {
>  			        if (n < 16) {
> -					bad = short_at(&temp_buf[i]);
> +					bad = short_at(&buf[i]);
>  				        prt("0x%05x\t0x%04x\t0x%04x", offset,
>  				            short_at(&good_buf[offset]), bad);
> -					op = temp_buf[offset & 1 ? i+1 : i];
> +					op = buf[offset & 1 ? i+1 : i];
>  				        prt("\t0x%05x\n", n);
>  					if (op)
>  						prt("operation# (mod 256) for "
> @@ -725,7 +726,46 @@ doread(unsigned offset, unsigned size)
>  			    iret, size);
>  		report_failure(141);
>  	}
> -	check_buffers(offset, size);
> +	check_buffers(temp_buf, offset, size);
> +}
> +
> +void
> +check_contents(void)
> +{
> +	static char *check_buf;
> +	unsigned offset = 0;
> +	unsigned size = file_size;
> +	off_t ret;
> +	unsigned iret;
> +
> +	if (!check_buf) {
> +		check_buf = (char *) malloc(maxfilelen + writebdy);
> +		assert(check_buf != NULL);
> +		check_buf = round_ptr_up(check_buf, writebdy, 0);
> +		memset(check_buf, '\0', maxfilelen);
> +	}
> +
> +	if (o_direct)
> +		size -= size % readbdy;
> +	if (size == 0)
> +		return;
> +
> +	ret = lseek(fd, (off_t)offset, SEEK_SET);
> +	if (ret == (off_t)-1) {
> +		prterr("doread: lseek");
> +		report_failure(140);
> +	}
> +
> +	iret = fsxread(fd, check_buf, size, offset);
> +	if (iret != size) {
> +		if (iret == -1)
> +			prterr("check_contents: read");
> +		else
> +			prt("short check read: 0x%x bytes instead of 0x%x\n",
> +			    iret, size);
> +		report_failure(141);
> +	}
> +	check_buffers(check_buf, offset, size);
>  }
>  
>  
> @@ -808,7 +848,7 @@ domapread(unsigned offset, unsigned size)
>  		report_failure(191);
>  	}
>  
> -	check_buffers(offset, size);
> +	check_buffers(temp_buf, offset, size);
>  }
>  
>  
> @@ -1624,6 +1664,9 @@ test(void)
>  		break;
>  	}
>  
> +	if (check_file)

NAK, this needs to be "if (check_file && testcalls > simulatedopcount)"
or else we end up reading the file before we actually made any
modifications to it (e.g. if -S XXX is given).

--D

> +		check_contents();
> +
>  out:
>  	if (sizechecks && testcalls > simulatedopcount)
>  		check_size();
> @@ -1684,6 +1727,7 @@ usage(void)
>  	-P: save .fsxlog .fsxops and .fsxgood files in dirpath (default ./)\n\
>  	-S seed: for random # generator (default 1) 0 gets timestamp\n\
>  	-W: mapped write operations DISabled\n\
> +	-X: Do not read file and compare to good buffer after every operation.\n\
>          -R: read() system calls only (mapped reads disabled)\n\
>          -Z: O_DIRECT (use -R, -W, -r and -w too)\n\
>  	--replay-ops opsfile: replay ops from recorded .fsxops file\n\
> @@ -1880,7 +1924,7 @@ main(int argc, char **argv)
>  	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
>  
>  	while ((ch = getopt_long(argc, argv,
> -				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyAD:FKHzCILN:OP:RS:WZ",
> +				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyAD:FKHzCILN:OP:RS:WXZ",
>  				 longopts, NULL)) != EOF)
>  		switch (ch) {
>  		case 'b':
> @@ -2044,6 +2088,9 @@ main(int argc, char **argv)
>  			if (!quiet)
>  				prt("mapped writes DISABLED\n");
>  			break;
> +		case 'X':
> +			check_file = 0;
> +			break;
>  		case 'Z':
>  			o_direct = O_DIRECT;
>  			o_flags |= O_DIRECT;
> 
