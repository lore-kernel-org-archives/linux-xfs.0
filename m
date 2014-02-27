Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 927FF7F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 14:25:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8288030406B
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 12:25:49 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	psDSlm9iKIBSWshQ for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 12:25:46 -0800 (PST)
Date: Fri, 28 Feb 2014 07:25:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: add missing break in O_TMPFILE case
Message-ID: <20140227202544.GF30131@dastard>
References: <530F9D31.5070103@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530F9D31.5070103@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Feb 27, 2014 at 02:16:49PM -0600, Eric Sandeen wrote:
> Coverity spotted this.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> (I assume that -T isn't supposed to imply -x?)
> 
> diff --git a/io/init.c b/io/init.c
> index fd1a52f..1e2690e 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -181,6 +181,7 @@ init(
>  			break;
>  		case 'T':
>  			flags |= IO_TMPFILE;
> +			break;
>  		case 'x':
>  			expert = 1;
>  			break;

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
