Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41806 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbeLFWc3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Dec 2018 17:32:29 -0500
Subject: Re: [PATCH 2/4] xfsdump: do not split function call with ifdef
References: <20181128165649.56853-1-jtulak@redhat.com>
 <20181128165649.56853-3-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <15f23dc5-5372-9866-a04b-3655d0def568@sandeen.net>
Date: Thu, 6 Dec 2018 16:32:27 -0600
MIME-Version: 1.0
In-Reply-To: <20181128165649.56853-3-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com

On 11/28/18 10:56 AM, Jan Tulak wrote:
> In two files in xfsdump, a function call is split in half by an ifdef
> macro to conditionally pick an argument at compile time. This causes the
> code to be a bit less obvious and some analysis tools have trouble with
> understanding it.
> 
> So, instead of splitting the function in half, move the whole function
> call into each of the ifdef macros.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

It's still #ifdef hell, now with 0.05% less hell ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  common/drive_minrmt.c | 3 ++-
>  common/main.c         | 8 ++++++--
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
> index 59a40a7..04fed3e 100644
> --- a/common/drive_minrmt.c
> +++ b/common/drive_minrmt.c
> @@ -2585,11 +2585,12 @@ read_label( drive_t *drivep )
>  	if (( nread == 0 )  /* takes care of sun */
>  	      ||            /* now handle SGI */
>  	      (nread < 0 && saved_errno == ENOSPC )) {
> -		mlog( MLOG_NORMAL | MLOG_DRIVE,
>  #ifdef DUMP
> +		mlog( MLOG_NORMAL | MLOG_DRIVE,
>  		      _("encountered EOD : assuming blank media\n") );
>  #endif
>  #ifdef RESTORE
> +		mlog( MLOG_NORMAL | MLOG_DRIVE,
>  		      _("encountered EOD : end of data\n") );
>  #endif
>  		( void )rewind_and_verify( drivep );
> diff --git a/common/main.c b/common/main.c
> index b3605d1..0c23eb4 100644
> --- a/common/main.c
> +++ b/common/main.c
> @@ -581,12 +581,14 @@ main( int argc, char *argv[] )
>  		sigaction( SIGTERM, &sa, NULL );
>  		sigaction( SIGQUIT, &sa, NULL );
>  
> +#ifdef DUMP
>  		ok = drive_init2( argc,
>  				  argv,
> -#ifdef DUMP
>  				  gwhdrtemplatep );
>  #endif /* DUMP */
>  #ifdef RESTORE
> +		ok = drive_init2( argc,
> +				  argv,
>  				  ( global_hdr_t * )0 );
>  #endif /* RESTORE */
>  		if ( ! ok ) {
> @@ -629,12 +631,14 @@ main( int argc, char *argv[] )
>  	 * time-consuming chore. drive_init3 will synchronize with each slave.
>  	 */
>  	if ( ! init_error ) {
> +#ifdef DUMP
>  		ok = drive_init2( argc,
>  				  argv,
> -#ifdef DUMP
>  				  gwhdrtemplatep );
>  #endif /* DUMP */
>  #ifdef RESTORE
> +		ok = drive_init2( argc,
> +				  argv,
>  				  ( global_hdr_t * )0 );
>  #endif /* RESTORE */
>  		if ( ! ok ) {
> 
