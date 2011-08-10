Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7ALlhEs210472 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 16:47:43 -0500
Subject: Re: [PATCH v2 4/7] xfsdump: rework dialog timeout and EINTR reliance
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1312497011-24840-5-git-send-email-wkendall@sgi.com>
References: <1312497011-24840-1-git-send-email-wkendall@sgi.com>
	<1312497011-24840-5-git-send-email-wkendall@sgi.com>
Date: Wed, 10 Aug 2011 16:47:42 -0500
Message-ID: <1313012862.2865.136.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, 2011-08-04 at 17:30 -0500, Bill Kendall wrote:
> The current dialog code uses alarm(2) to implement the dialog timeout.
> This is suboptimal as the main loop already makes use of alarm.
> 
> Additionally the existing code relies on its blocking read(2) being
> interrupted if a signal is received. This is not guaranteed to work
> as a signal may be delivered to a different thread.
> 
> Both of these issues can be resolved by using select(2) rather than
> a blocking read.
> 
> This also changes dlog_desist() to not change 'dlog_ttyfd', as that
> could impact a dialog already in progress. Clearing 'dlog_allowed_flag'
> is sufficient to disable dialogs.

I can tell by inspection that changes to dlog_ttyfd
go hand-in-hand with changes to dlog_allowed_flag.

The value of dlog_ttyfd is only really used by
promptinput(), which is in turn only called by
dlog_string_query() and dlog_multi_query().  The
latter contains this:
        ASSERT( dlog_allowed_flag );
It would be reassuring to have the same assertion
in dlog_string_query().

(I've given up tracing back much further than
that to ensure your statement that "Clearing
'dlog_allowed_flag' is sufficient to disable
dialogs" is correct.)

A few more things below.  I think the "volatile"
thing ought to be changed, but otherwise:

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> ---
>  common/dlog.c |   57 +++++++++++++++++++++++++++++++++------------------------
>  1 files changed, 33 insertions(+), 24 deletions(-)
> 
> diff --git a/common/dlog.c b/common/dlog.c
> index 6a243ef..cbaa5cb 100644
> --- a/common/dlog.c
> +++ b/common/dlog.c

. . .

> @@ -399,16 +398,17 @@ promptinput( char *buf,
>  #endif /* NOTYET */
>  	mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, promptstr );
>  
> -	/* set up signal handling
> +	/* set up timeout
>  	 */
> -	dlog_signo_received = -1;
>  	if ( dlog_timeouts_flag && timeoutix != IXMAX ) {
> -		if ( pid == parentpid && ! miniroot ) {
> -			( void )sigrelse( SIGALRM );
> -		}
> -		sigalrm_save = sigset( SIGALRM, sighandler );
> -		alarm_save = alarm( ( u_intgen_t )timeout );
> +		timeout += now;
> +	} else {
> +		timeout = TIMEMAX;
>  	}
> +
> +	/* set up signal handling
> +	 */
> +	dlog_signo_received = -1;

You should make dlog_signo_received have a
"volatile" qualifier to ensure the compiler
doesn't optimize out checking whether it
changed while inside your loop.  Same thing
with dlog_allowed_flag I guess, although
honestly I get confused figuring out which
signal hander is in effect...

>  	if ( sigintix != IXMAX ) {
>  		if ( pid == parentpid && ! miniroot ) {
>  			( void )sigrelse( SIGINT );
> @@ -432,10 +432,27 @@ promptinput( char *buf,
>  		sigquit_save = sigset( SIGQUIT, sighandler );
>  	}
>  
> -	/* wait for input, timeout, or interrupt
> +	/* wait for input, timeout, or interrupt.
> +	 * note we come out of the select() frequently in order to
> +	 * check for a signal. the signal may have been handled by the
> +	 * the main thread, so we can't rely on the signal waking us
> +	 * up from the select().
>  	 */
> -	ASSERT( dlog_ttyfd >= 0 );
> -	nread = read( dlog_ttyfd, buf, bufsz - 1 );
> +	while ( now < timeout && dlog_signo_received == -1 && dlog_allowed_flag ) {
> +		int rc;
> +		fd_set rfds;
> +		struct timeval tv = { 0, 100000 }; // 100 ms
> +
> +		FD_ZERO( &rfds );
> +		FD_SET( dlog_ttyfd, &rfds );
> +
> +		rc = select( dlog_ttyfd + 1, &rfds, NULL, NULL, &tv );

You could pass a null pointer as the timeout to select()
if dlog_timeouts is not set, rather than using TIMEMAX,
in order to truly not time out.  (You would otherwise
know you timed out if select() returned 0.)

(This and the next suggestion are just ideas to
consider--I don't care if you do them or not.)

> +		if ( rc > 0 && FD_ISSET( dlog_ttyfd, &rfds ) ) {
> +			nread = read( dlog_ttyfd, buf, bufsz - 1 );
> +			break;
> +		}
> +		now = time( NULL );

You could exploit the non-portable Linux way of updating
timeout with the time left and avoid having to get the
time 10 times per second.

> +	}
>  
>  	/* restore signal handling
>  	 */

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
