Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1C4BF29DF8
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 05:26:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A3B8CAC009
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 03:26:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ggB8A4Orw3EKptpo for
	<xfs@oss.sgi.com>; Wed, 30 Apr 2014 03:26:18 -0700 (PDT)
Date: Wed, 30 Apr 2014 12:26:13 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] xfstests: fsstress: fix incorrect if condition check
	for collapse range mode
In-Reply-To: <004401cf645c$8f874710$ae95d530$@samsung.com>
Message-ID: <alpine.LFD.2.00.1404301223160.2100@localhost.localdomain>
References: <004401cf645c$8f874710$ae95d530$@samsung.com>
MIME-Version: 1.0
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
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com

On Wed, 30 Apr 2014, Namjae Jeon wrote:

> Date: Wed, 30 Apr 2014 19:11:32 +0900
> From: Namjae Jeon <namjae.jeon@samsung.com>
> To: Dave Chinner <david@fromorbit.com>
> Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
>     Ashish Sangwan <a.sangwan@samsung.com>
> Subject: [PATCH] xfstests: fsstress: fix incorrect if condition check for
>     collapse range mode
> 
> There is if condition to be block aligned for off and len of Collapse range.
> But off and len for all fallocate opearion can be aligned by incorrect
> if condition check.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  ltp/fsstress.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 29fc250..ff9ed12 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -2230,7 +2230,7 @@ do_fallocate(int opno, long r, int mode)
>  	 * Collapse range requires off and len to be block aligned, make it
>  	 * more likely to be the case.
>  	 */
> -	if (FALLOC_FL_COLLAPSE_RANGE && (opno % 2)) {
> +	if (mode & FALLOC_FL_COLLAPSE_RANGE && (opno % 2)) {
>  		off = ((off + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
>  		len = ((len + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
>  	}

oops :). Thanks for fixing it. Even though it would be better to use
parentheses

+	if ((mode & FALLOC_FL_COLLAPSE_RANGE) && (opno % 2)) {

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
