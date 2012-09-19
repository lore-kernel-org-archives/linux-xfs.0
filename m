Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JNdqJ5001939 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 18:39:52 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	F5eR5aLHbxaJuFWf for <xfs@oss.sgi.com>;
	Wed, 19 Sep 2012 16:41:03 -0700 (PDT)
Date: Thu, 20 Sep 2012 09:41:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: zero allocation_args on the kernel stack
Message-ID: <20120919234102.GG31501@dastard>
References: <20120919163133.097340199@sgi.com>
	<20120919163145.587098223@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120919163145.587098223@sgi.com>
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
To: tinguely@sgi.com
Cc: xfs@oss.sgi.com

On Wed, Sep 19, 2012 at 11:31:36AM -0500, tinguely@sgi.com wrote:
> The allocation argument structures is created on the kernel stack space. This
> patch makes sure the userdata variable is always initialized.
> 
> The better solution is always memset to 0 or "= { 0 }" the xfs_alloc_arg

Yes, please do that and remove all the initialisations to zero
instead. It's much easier to maintain in future if new additions
to structures are automaticlly zeroed by the code that uses it...

> and xfs_bmalloca structures. I believe there will only be 4 places that need
> this memset change.

The only definition of xfs_bmalloca (in xfs_bmapi_write) is already
zeroed:

	struct xfs_bmalloca     bma = { 0 };    /* args for xfs_bmap_alloc */

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
