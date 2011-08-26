Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7QGFvoA121069 for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 11:15:57 -0500
Subject: Re: [PATCH] xfsdump: call mlog_exit in content_stream_restore
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1313434763-22340-1-git-send-email-wkendall@sgi.com>
References: <1313434763-22340-1-git-send-email-wkendall@sgi.com>
Date: Fri, 26 Aug 2011 11:15:44 -0500
Message-ID: <1314375344.2821.47.camel@doink>
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

On Mon, 2011-08-15 at 13:59 -0500, Bill Kendall wrote:
> This patch adds mlog_exit() calls to all the return paths in
> content_stream_restore(). mlog_exit() is supposed to be called before
> returning from content_stream_dump() and content_stream_restore(), but
> many paths in the latter did not do so, allowing for the stream exit
> status to be incorrect.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

It looks like content_stream_restore() *never* used it.

Looking at _mlog_exit(), it looks to me like it could
benefit from using exit_codestring() rather than the
exit_strings[] array (which could be deleted).  This
would report "EXIT_ERROR" instead of just "ERROR" though,
and normal exit would be reported as "EXIT_NORMAL"
rather than "SUCCESS".   The function call is more
resilient though because it handles any value it's
passed (whereas one could conceivably index beyond
the end of the exit_strings[] array).

Just a thought--a suggestion for a future patch.

More suggestions below.  They apply to pretty much
the whole thing so I've put it all at the bottom.

> ---
>  restore/content.c |   64 ++++++++++++++++++++++++++--------------------------
>  1 files changed, 32 insertions(+), 32 deletions(-)
> 
> diff --git a/restore/content.c b/restore/content.c
> index e3e4994..a2f20e3 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -1930,7 +1930,7 @@ content_stream_restore( ix_t thrdix )
>  		      "chdir %s failed: %s\n"),
>  		      persp->a.dstdir,
>  		      strerror( errno ));
> -		return EXIT_ERROR;
> +		return mlog_exit(EXIT_ERROR, RV_ERROR);
>  	}
>  
>  	/* set my file creation mask to zero, to avoid modifying the

. . .
 
> @@ -2545,7 +2545,7 @@ content_stream_restore( ix_t thrdix )
>  #ifndef EOMFIX
>  		Media_end( Mediap );
>  #endif /* ! EOMFIX */

These #ifdef's are pretty yucky.

Another suggested future cleanup:  Add a flag to Media_end() to
indicate whether this is one of those #ifdef's calls, and
within Media_end() use a single #ifdef to determine whether
simply return or actually do it, based on that passed-in value.
Then just call Media_end() in all spots without the #ifdef's.

> -		return EXIT_NORMAL;
> +		return mlog_exit(EXIT_NORMAL, RV_DONE);
>  	}
>  	tranp->t_sync5 = SYNC_BUSY;
>  	unlock( );

. . .

> @@ -2588,7 +2588,7 @@ content_stream_restore( ix_t thrdix )
>  #ifndef EOMFIX
>  	Media_end( Mediap );
>  #endif /* ! EOMFIX */
> -	return EXIT_NORMAL;
> +	return mlog_exit(EXIT_NORMAL, rv);

If you kept this line as-is, use RV_OK rather than rv,
since it makes it more explicit we know that's what's
getting returned.  The same would hold in many spots
above as well.

But...

The end of this function is a whole bunch of repetitive
code.  It would be cleaner to assign a "ret" variable
(or whatever name you think fits the existing code)
and then after this last switch statement call:

	return mlog_exit(ret, rv);

(If Media_end() got a flag, you might not need the
switch statement at all...)

Christoph suggested a goto which would be similar
but would affect the whole function.  And in fact
I think it might simplify a lot--possibly eliminating
whole switch statements entirely--so I think that's
an idea worth considering.

I think you should re-post your patch after considering
these suggestions.  Thanks.

					-Alex

>  }
>  
>  /* called after all threads have exited. scans state to decide



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
