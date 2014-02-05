Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6DB597F55
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 17:02:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 51BBA304084
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 15:02:46 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	hCP2vl7SNGobmNuO for <xfs@oss.sgi.com>;
	Wed, 05 Feb 2014 15:02:44 -0800 (PST)
Date: Thu, 6 Feb 2014 10:02:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: initialize "valid" bitmap in randholes.c
Message-ID: <20140205230205.GH13997@dastard>
References: <52F2848B.5070704@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52F2848B.5070704@redhat.com>
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

On Wed, Feb 05, 2014 at 12:35:55PM -0600, Eric Sandeen wrote:
> Failures were reported in xfs/008 on s390; dchinner suggested that
> perhaps the uninitialized "valid" bitmap was behaving differently on
> that platform, and sure enough, this patch fixes things up.
> 
> TBH, I'm not sure why using an uninitialized bitmap worked at
> all, ever, anywhere...?

It depends on glibc behaviour to whether newly allocated memory is
zeroed or not. e.g. for large allocations glibc uses
mmap() to directly map anonymous pages for the allocation. These get
zeroed by the kernel before being mapped into the user address
space. If glibc allocates from the heap and needs to grow it, it
uses sbrk() to grow the heap an dthose pages are, again, zeroed by
the kernel. However, if the allocation comes from the heap from
previously freed memory, then it doesn't get zeroed.

I'd say that the 3rd case is occurring here - there's memory that is
allocated and freed as part of the program startup that the bitmap
is being allocated from, and so it's not newly zeroed pages that it
is being allocated from...

Regardless of the cause, the fix looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
