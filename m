Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 19B177F90
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 21:33:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 08364304062
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 19:33:10 -0700 (PDT)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id H0oOoX8mYvYxihHl
	for <xfs@oss.sgi.com>; Fri, 08 Aug 2014 19:33:07 -0700 (PDT)
Message-ID: <53E5885A.9090302@fb.com>
Date: Fri, 8 Aug 2014 22:32:58 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: don't zero partial page cache pages during O_DIRECT
References: <53E4E03A.7050101@fb.com> <20140809003628.GE26465@dastard>
In-Reply-To: <20140809003628.GE26465@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com



On 08/08/2014 08:36 PM, Dave Chinner wrote:
> On Fri, Aug 08, 2014 at 10:35:38AM -0400, Chris Mason wrote:
>>
>> xfs is using truncate_pagecache_range to invalidate the page cache
>> during DIO reads.  This is different from the other filesystems who only
>> invalidate pages during DIO writes.
> 
> Historical oddity thanks to wrapper functions that were kept way
> longer than they should have been.
> 
>> truncate_pagecache_range is meant to be used when we are freeing the
>> underlying data structs from disk, so it will zero any partial ranges
>> in the page.  This means a DIO read can zero out part of the page cache
>> page, and it is possible the page will stay in cache.
> 
> commit fb59581 ("xfs: remove xfs_flushinval_pages").  also removed
> the offset masks that seem to be the issue here. Classic case of a
> regression caused by removing 10+ year old code that was not clearly
> documented and didn't appear important.
> 
> The real question is why isn't fsx and other corner case data
> integrity tools tripping over this?
> 

My question too.  Maybe not mixing buffered/direct for partial pages?
Does fsx only do 4K O_DIRECT?

>> buffered reads will find an up to date page with zeros instead of the
>> data actually on disk.
>>
>> This patch fixes things by leaving the page cache alone during DIO
>> reads.
>>
>> We discovered this when our buffered IO program for distributing
>> database indexes was finding zero filled blocks.  I think writes
>> are broken too, but I'll leave that for a separate patch because I don't
>> fully understand what XFS needs to happen during a DIO write.
>>
>> Test program:
> 
> Encapsulate it in a generic xfstest, please, and send it to
> fstests@vger.kernel.org.

This test prog was looking for races, which we really don't have.  It
can be much shorter to just look for the improper zeroing from a single
thread.  I can send it either way.

[ ... ]

> I guarantee you that there are applications out there that rely on
> the implicit invalidation behaviour for performance. There are also
> applications out that rely on it for correctness, too, because the
> OS is not the only source of data in the filesystem the OS has
> mounted.
> 
> Besides, XFS's direct IO semantics are far saner, more predictable
> and hence are more widely useful than the generic code. As such,
> we're not going to regress semantics that have been unchanged
> over 20 years just to match whatever insanity the generic Linux code
> does right now.
> 
> Go on, call me a deranged monkey on some serious mind-controlling
> substances. I don't care. :)

The deranged part is invalidating pos -> -1 on a huge file because of a
single 512b direct read.  But, if you mix O_DIRECT and buffered you get
what the monkeys give you and like it.

> 
> I think the fix should probably just be:
> 
> -			truncate_pagecache_range(VFS_I(ip), pos, -1);
> +			invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
> +					pos >> PAGE_CACHE_SHIFT, -1);
> 

I'll retest with this in the morning.  The invalidate is basically what
we had before with the masking & PAGE_CACHE_SHIFT.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
