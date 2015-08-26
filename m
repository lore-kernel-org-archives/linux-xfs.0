Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8A5F27F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 16:38:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7845C8F8040
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 14:38:32 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2RFhKfOSEwCwq9r9 for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 14:38:31 -0700 (PDT)
Date: Thu, 27 Aug 2015 07:37:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfsdump: prevent segfault in cb_add_inogrp
Message-ID: <20150826213746.GC3902@dastard>
References: <20150924193241.975348815@gulag1.americas.sgi.com>
	<55EDF3BA.60409@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55EDF3BA.60409@sgi.com>
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
To: rjohnston@sgi.com
Cc: xfs@oss.sgi.com

On Wed, Aug 26, 2015 at 12:36:42PM -0500, rjohnston@sgi.com wrote:
> The call to memset will segfault because the offset for the first
> parameter is done twice. We are using pointer math to do the
> calculation.
> The first time is when calculating oldsize, the size of i2gseg_t
> is accounted for.
> 	oldsize = (numsegs - SEGPERHNK) * sizeof(i2gseg_t);
> Then in the call to memset, oldsize is again multiplied by the size
> of i2gmap_t.
> 	memset(inomap.i2gmap + oldsize, ...)
> 	
> i2gmap holds the used inodes in each chunk. When there are 2^31 chunk
> entries, it could describe 2^31 (1 inode/chunk)- 2^40 (64 inodes/chunk).
> 
> With 100s of millions of inodes there are enough entries to wrap the
> 32 bit variable oldsize.
> 
> Switching to use array index notation instead of calculating the
> pointer address twice ;) would resolve this issue. The unneeded
> local variable oldsize can be removed as well.
> 
> numsegs is used to calculate an array index, change it from a
> signed int (intgen_t) to an unsigned (uint32_t).

Description does not match code:

> -			intgen_t numsegs;
> -			intgen_t oldsize;
> +			int32_t numsegs;

It's still a signed int here. And, really, just a plain old "int" is
fine here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
