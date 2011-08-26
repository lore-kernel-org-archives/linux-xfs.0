Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7QFgY2f114734 for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 10:42:35 -0500
Subject: Re: [PATCH] xfsdump: refactor exit_codestring()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1313430212-20028-1-git-send-email-wkendall@sgi.com>
References: <1313430212-20028-1-git-send-email-wkendall@sgi.com>
Date: Fri, 26 Aug 2011 10:42:30 -0500
Message-ID: <1314373350.2821.28.camel@doink>
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

On Mon, 2011-08-15 at 12:43 -0500, Bill Kendall wrote:
> Simplify exit_codestring(), which maps an exit code into a string.
> Make it available to all code which includes "exit.h".
> 
> Also remove the unused type "exit_t".
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Nice simplification.

For something like this I might have done:

	switch (code) {
#define	CASE(x)	CASE EXIT_ ## x: return #x
	CASE(NORMAL);
	CASE(ERROR);
	CASE(INTERRUPT);
	CASE(FAULT);
	default:
		return "???";
#undef	CASE
	}

But I don't know how others feel about that--they
could understandably hate it.

In any case I'm taking yours just as you posted it.

Reviewed-by: Alex Elder <aelder@sgi.com>


> ---
>  common/exit.h |   12 +++++++++++-
>  common/main.c |   33 ---------------------------------
>  2 files changed, 11 insertions(+), 34 deletions(-)
> 
> diff --git a/common/exit.h b/common/exit.h
> index 276562d..ef01684 100644
> --- a/common/exit.h
> +++ b/common/exit.h
> @@ -25,6 +25,16 @@
>  #define EXIT_INTERRUPT	2	/* interrupted (operator or device error) */
>  #define EXIT_FAULT	4	/* code fault */
>  
> -typedef size_t exit_t;
> +static inline const char *
> +exit_codestring( intgen_t code )
> +{
> +	switch ( code ) {
> +	case EXIT_NORMAL:    return "EXIT_NORMAL";
> +	case EXIT_ERROR:     return "EXIT_ERROR";
> +	case EXIT_INTERRUPT: return "EXIT_INTERRUPT";
> +	case EXIT_FAULT:     return "EXIT_FAULT";
> +	}
> +	return "???";
> +}
>  
>  #endif /* EXIT_H */
> diff --git a/common/main.c b/common/main.c
> index c4d6878..5567d44 100644
> --- a/common/main.c
> +++ b/common/main.c
> @@ -100,7 +100,6 @@ static bool_t set_rlimits( void );
>  #ifdef RESTORE
>  static bool_t set_rlimits( size64_t * );
>  #endif /* RESTORE */
> -static char *exit_codestring( intgen_t code );
>  static char *sig_numstring( intgen_t num );
>  static char *strpbrkquotes( char *p, const char *sep );
>  
> @@ -2448,38 +2447,6 @@ set_rlimits( size64_t *vmszp )
>  	return BOOL_TRUE;
>  }
>  
> -struct exit_printmap {
> -	intgen_t code;
> -	char *string;
> -};
> -
> -typedef struct exit_printmap exit_printmap_t;
> -
> -static exit_printmap_t exit_printmap[ ] = {
> -	{EXIT_NORMAL,	"EXIT_NORMAL"},
> -	{EXIT_ERROR,	"EXIT_ERROR"},
> -	{EXIT_INTERRUPT,"EXIT_INTERRUPT"},
> -	{EXIT_FAULT,	"EXIT_FAULT"}
> -};
> -
> -static char *
> -exit_codestring( intgen_t code )
> -{
> -	exit_printmap_t *p = exit_printmap;
> -	exit_printmap_t *endp = exit_printmap
> -				+
> -				( sizeof( exit_printmap )
> -				  /
> -				  sizeof( exit_printmap[ 0 ] ));
> -	for ( ; p < endp ; p++ ) {
> -		if ( p->code == code ) {
> -			return p->string;
> -		}
> -	}
> -
> -	return "???";
> -}
> -
>  struct sig_printmap {
>  	intgen_t num;
>  	char *string;



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
