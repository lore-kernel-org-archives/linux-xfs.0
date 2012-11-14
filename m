Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAEIml4f156577 for <xfs@oss.sgi.com>; Wed, 14 Nov 2012 12:48:47 -0600
Message-ID: <50A3E807.5010403@sgi.com>
Date: Wed, 14 Nov 2012 12:50:47 -0600
From: Andrew Dahl <adahl@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/32 V2] xfs: remove xfs_tosspages
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-3-git-send-email-david@fromorbit.com>
	<20121114064247.GC1710@dastard>
In-Reply-To: <20121114064247.GC1710@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/14/2012 12:42 AM, Dave Chinner wrote:
> xfs: remove xfs_tosspages
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's a buggy, unnecessary wrapper that is duplicating
> truncate_pagecache_range().
> 
> When replacing the call in xfs_change_file_space(), also ensure that
> the length being allocated/freed is always positive before making
> any changes. These checks are done in the lower extent manipulation
> functions, too, but we need to do them before any page cache
> operations.
> 
> Reported-by: Andrew Dahl <adahl@sgi.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

>  	case XFS_IOC_ZERO_RANGE:
>  		prealloc_type |= XFS_BMAPI_CONVERT;
> -		xfs_tosspages(ip, startoffset, startoffset + bf->l_len, 0);
> +		end = round_down(startoffset + bf->l_len, PAGE_SIZE) - 1;
> +		if (startoffset > end)

This should be

if (startoffset <= end)

This exact like was in my original patch, though it returned if this was
true. -- Also, it needs to be "or equal to" for the case of passing
[4095,4096] -- after we round down and subtract one, they'll be equal
and the call will zero one byte.

--

I'll follow up with a patch just so Ben can get this pulled today.

Looks great though!

Reviewed-By: Andrew Dahl <adahl@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
