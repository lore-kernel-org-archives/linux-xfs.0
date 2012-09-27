Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8RMpVQU149353 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 17:51:31 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5W9sX8TT7PAJt0i1 for <xfs@oss.sgi.com>;
	Thu, 27 Sep 2012 15:52:50 -0700 (PDT)
Date: Fri, 28 Sep 2012 08:52:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfsprog: remove duplicate vector memalign from xfs_io
Message-ID: <20120927225248.GB25626@dastard>
References: <20120925142414.660506845@sgi.com>
	<20120925142421.398175185@sgi.com> <20120926220434.GG13214@sgi.com>
	<20120927124742.695778439@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120927124742.695778439@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Thu, Sep 27, 2012 at 07:47:36AM -0500, Mark Tinguely wrote:
> The vector feature of xfs_io uses its own memory buffer in the iov structure
> and does not use the buffer entry. Remove the duplicate memalign.
> 
> v2: removed global buffer in __dump_buffer() and use passed buf pointer per
>     Ben's detection.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> Reviewed-by: Ben Myers <bpm@sgi.com>

Looks good, Thanks for fixing this.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
