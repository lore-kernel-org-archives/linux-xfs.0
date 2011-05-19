Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4J0ghE9005773 for <xfs@oss.sgi.com>; Wed, 18 May 2011 19:42:43 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1089FCE430F
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 17:42:41 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wVC7dXuZa7eAF4I7 for <xfs@oss.sgi.com>;
	Wed, 18 May 2011 17:42:41 -0700 (PDT)
Date: Thu, 19 May 2011 10:42:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS Tests Punch Hole 1/3 v3] XFS TESTS: Add Punch Hole to FSX
Message-ID: <20110519004238.GE32466@dastard>
References: <4DD432FC.5030904@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DD432FC.5030904@linux.vnet.ibm.com>
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
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Wed, May 18, 2011 at 01:58:36PM -0700, Allison Henderson wrote:
> This patch adds punch hole tests to the fsx
> stress test. The test is performed through
> the fallocate call by randomly choosing to
> use the punch hole flag when running the
> fallocate test. Regions that have
> been punched out should contain zeros, so
> the expected file contents buffer is updated
> to contain zeros when a hole is punched out.
> 
> Signed-off-by: Allison Henderson <achender@us.ibm.com>
> ---
> v0 -> v1:
> Corrections to the Makefile have been backed out.
> This patch needs to be applied on top of
> the "xfstests: clean up fallocate configuration tests"
> patch
> 
> The punch hole tests can be disabled with the
> -H flag, and will also be disabled if it is
> detected that the filesystem does not support
> punch hole
> 
> 
> :100644 100644 fe072d3... 8978ef1... M	ltp/fsx.c
>  ltp/fsx.c |  111 ++++++++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 96 insertions(+), 15 deletions(-)
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index fe072d3..8978ef1 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -110,6 +110,7 @@ int	randomoplen = 1;		/* -O flag disables it */
>  int	seed = 1;			/* -S flag */
>  int     mapped_writes = 1;              /* -W flag disables */
>  int     fallocate_calls = 1;            /* -F flag disables */
> +int     punch_hole_calls = 1;           /* -H flag disables */
>  int 	mapped_reads = 1;		/* -R flag disables it */
>  int	fsxgoodfd = 0;
>  int	o_direct;			/* -Z */
> @@ -207,7 +208,8 @@ logdump(void)
>  {
>  	int	i, count, down;
>  	struct log_entry	*lp;
> -	char *falloc_type[3] = {"PAST_EOF", "EXTENDING", "INTERIOR"};
> +	char *falloc_type[4] = {"PAST_EOF", "EXTENDING", "INTERIOR",
> +				"PUNCH_HOLE"};
>  
>  	prt("LOG DUMP (%d total operations):\n", logcount);
>  	if (logcount < LOGSIZE) {
> @@ -791,6 +793,11 @@ dofallocate(unsigned offset, unsigned length)
>  {
>  	unsigned end_offset;
>  	int keep_size;
> +	int max_offset = 0;
> +	int max_len = 0;
> +	int mode = 0;
> +	char *op_name;
> +	int punch_hole = 0;
>  
>          if (length == 0) {
>                  if (!quiet && testcalls > simulatedopcount)
> @@ -799,11 +806,37 @@ dofallocate(unsigned offset, unsigned length)
>                  return;
>          }
>  
> +#ifdef FALLOC_FL_PUNCH_HOLE
> +	if (fallocate_calls && !punch_hole_calls)
> +		punch_hole = 0;
> +	else if (!fallocate_calls && punch_hole_calls)
> +		punch_hole = 1;
> +	else
> +		punch_hole = random() % 2;
> +
> +	/* Keep size must be set for punch hole */
> +	if (punch_hole) {
> +		keep_size = 1;
> +		mode = FALLOC_FL_PUNCH_HOLE;
> +	} else
> +		keep_size = random() % 2;
> +#else
>  	keep_size = random() % 2;
> +#endif

Ugh. Can you please separate hole punching out into it's own
function? i.e. do_fallocate() gets renamed to do_preallocate(), and
this new functionality goes into do_hole_punch()? The fact that they
both use the fallocate() system call is no reason for complicating
the logic like this....

> @@ -1426,8 +1489,26 @@ main(int argc, char **argv)
>  		if (fallocate(fd, 0, 0, 1) && errno == EOPNOTSUPP) {
>  			warn("main: filesystem does not support fallocate, disabling");
>  			fallocate_calls = 0;
> -		} else
> +			/*
> +			 * punch hole depends on fallocate,
> +			 * so turn punch hole off too
> +			 */
> +			punch_hole_calls = 0;
> +		} else {
> +#ifdef FALLOC_FL_PUNCH_HOLE
> +			if (fallocate(fd,
> +				FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
> +				0, 1) && errno == EOPNOTSUPP) {
> +				warn("main: filesystem does not support"
> +					" fallocate punch hole, disabling");
> +				punch_hole_calls = 0;
> +			}
> +#else
> +			punch_hole_calls = 0;
> +#endif
> +
>  			ftruncate(fd, 0);
> +		}
>  	}
>  #else /* ! FALLOCATE */
>  	fallocate_calls = 0;

And these functionality tests would probably be better in their own
function, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
