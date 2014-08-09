Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ED7B27F96
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 21:42:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC4B98F8066
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 19:42:30 -0700 (PDT)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id 8cGT9e64toE96I5D
	for <xfs@oss.sgi.com>; Fri, 08 Aug 2014 19:42:29 -0700 (PDT)
Message-ID: <53E58A90.7060709@fb.com>
Date: Fri, 8 Aug 2014 22:42:24 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfs: use invalidate_inode_pages2_range for DIO writes
References: <53E4E03A.7050101@fb.com> <53E4F518.9030107@fb.com>
	<20140809004857.GF26465@dastard>
In-Reply-To: <20140809004857.GF26465@dastard>
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



On 08/08/2014 08:48 PM, Dave Chinner wrote:
> On Fri, Aug 08, 2014 at 12:04:40PM -0400, Chris Mason wrote:
>>
>> xfs is using truncate_pagecache_range to invalidate the page cache
>> during DIO writes.  The other filesystems are calling
>> invalidate_inode_pages2_range
>>  
>> truncate_pagecache_range is meant to be used when we are freeing the
>> underlying data structs from disk, so it will zero any partial ranges
>> in the page.  This means a DIO write can zero out part of the page cache
>> page, and it is possible the page will stay in cache.
>>
>> This one is an RFC because it is untested and because I don't understand
>> how XFS is dealing with pages the truncate was unable to clear away.
>> I'm not able to actually trigger zeros by mixing DIO writes with
>> buffered reads.
>>
>> Signed-off-by: Chris Mason <clm@fb.com>
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 8d25d98..c30c112 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -638,7 +638,10 @@ xfs_file_dio_aio_write(
>>  						    pos, -1);
>>  		if (ret)
>>  			goto out;
>> -		truncate_pagecache_range(VFS_I(ip), pos, -1);
>> +
>> +		/* what do we do if we can't invalidate the pages? */
>> +		invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
>> +					      pos >> PAGE_CACHE_SHIFT, -1);
> 
> I don't think it can on XFS.
> 
> We're holding the XFS_IOLOCK_EXCL, so no other syscall based IO can
> dirty pages, all the pages are clean, try_to_free_buffers() will
> never fail, no-one can run a truncate operation concurently, and
> so on.
> 
> So, I'd just do:
> 
> 		ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
> 						pos >> PAGE_CACHE_SHIFT, -1);
> 		WARN_ON_ONCE(ret);
> 		ret = 0;
> 

Since pos is page aligned I agree this should be fine.  I'll leave that
one to you though, since I don't have a great test case for/against it.


-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
