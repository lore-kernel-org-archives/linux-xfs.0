Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4MNOSua029878 for <xfs@oss.sgi.com>; Tue, 22 May 2012 18:24:28 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	AnQ1CXFiGs5ZLoHz for <xfs@oss.sgi.com>;
	Tue, 22 May 2012 16:24:26 -0700 (PDT)
Date: Wed, 23 May 2012 09:24:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Prefix IO_XX flags with XFS_IO_XX to avoid namespace
	colision.
Message-ID: <20120522232424.GK25351@dastard>
References: <4fbbfd75.nYwhMRRjLSAq0x8u%arenaud@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4fbbfd75.nYwhMRRjLSAq0x8u%arenaud@sgi.com>
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
To: Alain Renaud <arenaud@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, May 22, 2012 at 03:56:21PM -0500, Alain Renaud wrote:
> 
>  This mod simply add a XFS_ prefix to IO_DIRECT,XFS_IO_DELALLOC,
> XFS_IO_UNWRITTEN and XFS_IO_OVERWRITE. This to avoid namespace conflict
> with other modules.

While I don't see any problems with making the change, I don't see
exactly how we could have a namespace clash here given they are
internal to XFS, not very widely included and have beenthis way for
years. What is the namespace clash you are seeing/caring about?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
