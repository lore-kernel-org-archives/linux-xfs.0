Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 407CB29DF8
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 19:29:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AD68DAC004
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 17:29:16 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	neCM7C1sD00QtIhw for <xfs@oss.sgi.com>;
	Wed, 26 Feb 2014 17:29:14 -0800 (PST)
Date: Thu, 27 Feb 2014 12:28:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs_logprint: don't advance op counter in
	xlog_print_trans_icreate
Message-ID: <20140227012852.GY13647@dastard>
References: <530E8E17.1090901@redhat.com>
 <530E91C8.1010207@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530E91C8.1010207@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Feb 26, 2014 at 07:15:52PM -0600, Eric Sandeen wrote:
> xlog_print_trans_icreate is advancing the op counter
> "(*i)++" incorrectly; it only contains one region, and
> the loop which called it will properly advance the op
> once we're done.
> 
> Found-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index 7070fa3..52f1e85 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -810,7 +810,6 @@ xlog_print_trans_icreate(
>  
>  	memmove(&icl_buf, *ptr, MIN(sizeof(struct xfs_icreate_log), len));
>  	icl = &icl_buf;
> -	(*i)++;
>  	*ptr += len;
>  
>  	/* handle complete header only */

*nod*. I'm pretty sure I introduced that bug - thanks for exposing
it and fixing it :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
