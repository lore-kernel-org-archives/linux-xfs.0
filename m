Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 50A227F77
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 11:58:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2E893304048
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 09:58:35 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id h7jWECesrclsl6aK for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 09:58:29 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id BFC8763C3BC5
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 11:58:29 -0600 (CST)
Subject: Re: [PATCH 02/11] xfsprogs: fix integer overflow in
	xlog_find_verify_cycle
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
	<1449055167-19936-3-git-send-email-t.vivek@samsung.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <565F3145.4090909@sandeen.net>
Date: Wed, 2 Dec 2015 11:58:29 -0600
MIME-Version: 1.0
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
To: xfs@oss.sgi.com



On 12/2/15 5:19 AM, Vivek Trivedi wrote:
> Fix unintentional integer overflow in xlog_find_verify_cycle.
> Reported by coverity.
> 
> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>

Coverity-Id: 200684
Reviewed-by: Eric Sandeen <sandeen@redhat.com>

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
>  	while (bufblks > log->l_logBBsize)
>  		bufblks >>= 1;
>  	while (!(bp = xlog_get_bp(log, bufblks))) {
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
