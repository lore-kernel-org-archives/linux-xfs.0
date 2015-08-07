Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3109F7F59
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 06:37:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ADE37AC007
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 04:37:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bkF52bn6846RJTUT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 04:37:08 -0700 (PDT)
Date: Fri, 7 Aug 2015 07:37:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] db: fix uninitialised variable warnings
Message-ID: <20150807113705.GA8322@bfoster.bfoster>
References: <1438814992-31588-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438814992-31588-1-git-send-email-david@fromorbit.com>
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

On Thu, Aug 06, 2015 at 08:49:52AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> New versions of gcc barf on the conversion table code in
> db/convert.c. Shut it up by initialising the conversion array.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  db/convert.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/db/convert.c b/db/convert.c
> index 09f9225..a337abe 100644
> --- a/db/convert.c
> +++ b/db/convert.c
> @@ -157,7 +157,7 @@ convert_f(int argc, char **argv)
>  {
>  	ctype_t		c;
>  	int		conmask;
> -	cval_t		cvals[NCTS];
> +	cval_t		cvals[NCTS] = {};
>  	int		i;
>  	int		mask;
>  	__uint64_t	v;
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
