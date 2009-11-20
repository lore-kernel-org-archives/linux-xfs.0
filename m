Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAK6b1md125064 for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 00:37:02 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 207129EA16
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 22:37:23 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	AKsFOuCqwzq6XMN7 for <xfs@oss.sgi.com>;
	Thu, 19 Nov 2009 22:37:23 -0800 (PST)
Date: Fri, 20 Nov 2009 17:37:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: make several more functions static
Message-ID: <20091120063720.GA3804@discord.disaster>
References: <4B0569A0.10405@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B0569A0.10405@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Nov 19, 2009 at 09:52:00AM -0600, Eric Sandeen wrote:
> Just minor housekeeping, a lot more functions can be trivially
> made static; others could if we reordered things a bit...

Only one minor comment:

> -void
> +STATIC_INLINE void
>  xlog_put_bp(
>  	xfs_buf_t	*bp)
>  {

I'd change that as STATIC as Christoph's recent patch removed
STATIC_INLINE. gcc will inline it for us if it's a win....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
