Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D92747F37
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 16:44:53 -0500 (CDT)
Date: Mon, 22 Jul 2013 16:44:49 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 02/48] logprint: fix wrapped log dump issue.
Message-ID: <20130722214449.GG3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 10:25:25AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When running xfs/295 on a 512 byte block size filesystem, logprint
> fails during checking with a "Bad log record header" error. This is
> due to the fact that the log has wrapped and there is partial record
> a the start of the log.
> 
> logprint doesn't check for this condition, and simply assumes that
> the first block in the log contains a log header, and hence aborts
> when this case occurs. So we now have a spurious test failure due to
> logprint displaying how right this comment is:
> 
> /*
>  * This code is gross and needs to be rewritten.
>  */
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  logprint/log_misc.c |   49 ++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 32 insertions(+), 17 deletions(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index d08f900..334b6bf 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -833,7 +833,8 @@ xlog_print_record(int			  fd,
>  		 int			  *read_type,
>  		 xfs_caddr_t		  *partial_buf,
>  		 xlog_rec_header_t	  *rhead,
> -		 xlog_rec_ext_header_t	  *xhdrs)
> +		 xlog_rec_ext_header_t	  *xhdrs,
> +		 int			  bad_hdr_warn)
>  {
>      xfs_caddr_t		buf, ptr;
>      int			read_len, skip;
> @@ -1006,11 +1007,17 @@ xlog_print_record(int			  fd,
>  			break;
>  		    }
>  		    default: {
> -			fprintf(stderr, _("%s: unknown log operation type (%x)\n"),
> -				progname, *(unsigned short *)ptr);
> -			if (print_exit) {
> -				free(buf);
> -				return BAD_HEADER;
> +			if(bad_hdr_warn) {
			  ^ Added a space.

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied to the master branch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
