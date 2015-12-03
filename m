Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 89CDD7F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 23:50:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6DCFE8F8040
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 21:50:10 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ZvPDJSoNVTxj2c1W for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 21:50:07 -0800 (PST)
Date: Thu, 3 Dec 2015 16:49:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/11] xfsprogs: fix integer overflow in
	xlog_find_verify_cycle
Message-ID: <20151203054941.GS26718@dastard>
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
	<1449055167-19936-3-git-send-email-t.vivek@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1449055167-19936-3-git-send-email-t.vivek@samsung.com>
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
To: Vivek Trivedi <t.vivek@samsung.com>
Cc: a.sahrawat@samsung.com, pankaj.m@samsung.com, xfs@oss.sgi.com

On Wed, Dec 02, 2015 at 04:49:18PM +0530, Vivek Trivedi wrote:
> Fix unintentional integer overflow in xlog_find_verify_cycle.
> Reported by coverity.
> 
> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
> ---
>  libxlog/xfs_log_recover.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
> index ef7cf68..73f4d36 100644
> --- a/libxlog/xfs_log_recover.c
> +++ b/libxlog/xfs_log_recover.c
> @@ -254,7 +254,7 @@ xlog_find_verify_cycle(
>  	 * try a smaller size.  We need to be able to read at least
>  	 * a log sector, or we're out of luck.
>  	 */
> -	bufblks = 1 << ffs(nbblks);
> +	bufblks = (xfs_daddr_t)1 << ffs(nbblks);

Ummm, in isolation that change is technically correct, but when you
look at what bufblks contains it is clearly wrong.  nbblks is an
int, so "1 << ffs(nbblks)" should not be larger than an int.

i.e. bufblks is simply a count of blocks in the log, which by
definition cannot be more than an int (in fact, 2^31 / 2^9 is the
largest legal value it can have). Hence it can't be larger than an
int, and all the functions it is passed to expect it to be an
int...

Hence the use of xfs_daddr_t is wrong, and that's the first thing
that needs fixing....

>  	while (bufblks > log->l_logBBsize)
>  		bufblks >>= 1;
>  	while (!(bp = xlog_get_bp(log, bufblks))) {
                                       ^^^^^^^^
And given this, it's clear that coverity doesn't warn about
overflows caused by passing a 64 bit value into a 32 bit function
parameter....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
