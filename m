Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50356 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751032AbdGKAQb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jul 2017 20:16:31 -0400
Subject: Re: [PATCH] xfsdump: Fix memory leak
References: <20170705190656.9106-1-pcacjr@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ac27bfab-9fbf-9fef-ad52-560f89510eae@sandeen.net>
Date: Mon, 10 Jul 2017 19:16:29 -0500
MIME-Version: 1.0
In-Reply-To: <20170705190656.9106-1-pcacjr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Paulo Alcantara <pcacjr@gmail.com>, linux-xfs@vger.kernel.org

On 7/5/17 2:06 PM, Paulo Alcantara wrote:
> This patch fixes the following memory leak reported by valgrind:

Heh, no prior callers of global_hdr_free(), neat.  Good job
getting through the grotty xfsdump code!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
 
> ==9198==
> ==9198== HEAP SUMMARY:
> ==9198==     in use at exit: 272,248 bytes in 13 blocks
> ==9198==   total heap usage: 629 allocs, 616 frees, 354,203 bytes
> allocated
> ==9198==
> ==9198== 4,096 bytes in 1 blocks are definitely lost in loss record 12
> of 13
> ==9198==    at 0x4C2FA50: calloc (vg_replace_malloc.c:711)
> ==9198==    by 0x415801: global_hdr_alloc (global.c:80)
> ==9198==    by 0x403D12: main (main.c:494)
> ==9198==
> ==9198== LEAK SUMMARY:
> ==9198==    definitely lost: 4,096 bytes in 1 blocks
> ==9198==    indirectly lost: 0 bytes in 0 blocks
> ==9198==      possibly lost: 0 bytes in 0 blocks
> ==9198==    still reachable: 268,152 bytes in 12 blocks
> ==9198==         suppressed: 0 bytes in 0 blocks
> ==9198== Reachable blocks (those to which a pointer was found) are not
> shown.
> ==9198== To see them, rerun with: --leak-check=full
> --show-leak-kinds=all
> ==9198==
> ==9198== For counts of detected and suppressed errors, rerun with: -v
> ==9198== ERROR SUMMARY: 1 errors from 1 contexts (suppressed: 0 from 0)
> 
> Command was:
>     # xfsdump -f /dev/vdb
> 
> Signed-off-by: Paulo Alcantara <pcacjr@gmail.com>
> ---
>  common/main.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/common/main.c b/common/main.c
> index 3848499..b34e974 100644
> --- a/common/main.c
> +++ b/common/main.c
> @@ -163,6 +163,7 @@ main( int argc, char *argv[] )
>  	bool_t ok;
>  	/* REFERENCED */
>  	int rval;
> +	int err;
>  
>  	/* sanity checks
>  	 */
> @@ -564,7 +565,8 @@ main( int argc, char *argv[] )
>  	ok = content_init( argc, argv, vmsz / VMSZ_PER );
>  #endif /* RESTORE */
>  	if ( ! ok ) {
> -		return mlog_exit(EXIT_ERROR, RV_INIT);
> +		err = mlog_exit(EXIT_ERROR, RV_INIT);
> +		goto err_free;
>  	}
>  
>  	/* if in a pipeline, go single-threaded with just one stream.
> @@ -587,11 +589,13 @@ main( int argc, char *argv[] )
>  				  ( global_hdr_t * )0 );
>  #endif /* RESTORE */
>  		if ( ! ok ) {
> -			return mlog_exit(EXIT_ERROR, RV_INIT);
> +			err = mlog_exit(EXIT_ERROR, RV_INIT);
> +			goto err_free;
>  		}
>  		ok = drive_init3( );
>  		if ( ! ok ) {
> -			return mlog_exit(EXIT_ERROR, RV_INIT);
> +			err = mlog_exit(EXIT_ERROR, RV_INIT);
> +			goto err_free;
>  		}
>  #ifdef DUMP
>  		exitcode = content_stream_dump( 0 );
> @@ -602,12 +606,13 @@ main( int argc, char *argv[] )
>  		if ( exitcode != EXIT_NORMAL ) {
>  			( void )content_complete( );
>  						/* for cleanup side-effect */
> -			return mlog_exit(exitcode, RV_UNKNOWN);
> +			err = mlog_exit(exitcode, RV_UNKNOWN);
>  		} else if ( content_complete( )) {
> -			return mlog_exit(EXIT_NORMAL, RV_OK);
> +			err = mlog_exit(EXIT_NORMAL, RV_OK);
>  		} else {
> -			return mlog_exit(EXIT_INTERRUPT, RV_UNKNOWN);
> +			err = mlog_exit(EXIT_INTERRUPT, RV_UNKNOWN);
>  		}
> +		goto err_free;
>  	}
>  
>  	/* used to skip to end if errors occur during any
> @@ -873,7 +878,14 @@ main( int argc, char *argv[] )
>  				mlog_exit_hint(RV_INCOMPLETE);
>  		}
>  	}
> -	return mlog_exit(exitcode, RV_UNKNOWN);
> +
> +	err = mlog_exit(exitcode, RV_UNKNOWN);
> +
> +err_free:
> +#ifdef DUMP
> +	global_hdr_free( gwhdrtemplatep );
> +#endif /* DUMP */
> +	return err;
>  }
>  
>  #define ULO( f, o )	fprintf( stderr,		\
> 
