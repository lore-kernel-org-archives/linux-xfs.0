Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0FC177F4E
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 18:12:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A9A70AC004
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 16:12:37 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id pCqEdE7FXw5yTjs7 for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 16:12:35 -0800 (PST)
Message-ID: <53166BF1.6010507@sandeen.net>
Date: Tue, 04 Mar 2014 18:12:33 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 12/13] xfs_db: Use EFSBADCRC for CRC validity indication
References: <1393923117-9559-1-git-send-email-david@fromorbit.com>
	<1393923117-9559-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1393923117-9559-13-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 3/4/14, 2:51 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_db currently gives indication as to whether a buffer CRC is ok
> or not. Currently it does this by checking for EFSCORRUPTED in the
> b_error field of the buffer. Not that we have EFSBADCRC to indicate

Now that...

> a bad CRC independently of structure corruption, use that instead to
> drive the CRC correct/incorrect indication in the structured output.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  db/io.c | 5 +++--
>  db/io.h | 2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/db/io.c b/db/io.c
> index d29816c..9a787c8 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -521,10 +521,11 @@ set_cur(
>  	}
>  
>  	/*
> -	 * keep the buffer even if the verifier says it is corrupted.
> +	 * Keep the buffer even if the verifier says it is corrupted.
>  	 * We're a diagnostic tool, after all.
>  	 */
> -	if (!bp || (bp->b_error && bp->b_error != EFSCORRUPTED))
> +	if (!bp || (bp->b_error && bp->b_error != EFSCORRUPTED &&
> +				   bp->b_error != EFSBADCRC))
>  		return;
>  	iocur_top->buf = bp->b_addr;
>  	iocur_top->bp = bp;
> diff --git a/db/io.h b/db/io.h
> index d8cf383..ad39bee 100644
> --- a/db/io.h
> +++ b/db/io.h
> @@ -67,6 +67,6 @@ static inline bool
>  iocur_crc_valid()
>  {
>  	return (iocur_top->bp &&
> -		iocur_top->bp->b_error != EFSCORRUPTED &&
> +		iocur_top->bp->b_error != EFSBADCRC &&
>  		(!iocur_top->ino_buf || iocur_top->ino_crc_ok));
>  }
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
