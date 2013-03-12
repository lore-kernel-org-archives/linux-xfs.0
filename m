Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6F3D7F52
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 11:33:51 -0500 (CDT)
Message-ID: <513F58FE.1010200@sgi.com>
Date: Tue, 12 Mar 2013 11:34:06 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: properly set Parent's PID
References: <1359663197-30473-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1359663197-30473-1-git-send-email-cmaiolino@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 01/31/2013 02:13 PM, Carlos Maiolino wrote:
> Set parentpid variable to the correct Parent's ID using getppid() instead of
> getpid()
>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>   common/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/common/main.c b/common/main.c
> index 980d2d4..848a887 100644
> --- a/common/main.c
> +++ b/common/main.c
> @@ -198,7 +198,7 @@ main( int argc, char *argv[] )
>   	/* Get the parent's pid. will be used in signal handling
>   	 * to differentiate parent from children.
>   	 */
> -	parentpid = getpid( );
> +	parentpid = getppid( );
>   	rval = atexit(mlog_exit_flush);
>   	assert(rval == 0);
>
>
Sorry for the late review, this does not apply to current xfsdump tree.

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
