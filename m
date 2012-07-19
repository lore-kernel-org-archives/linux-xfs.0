Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6J8KHjP002460 for <xfs@oss.sgi.com>; Thu, 19 Jul 2012 03:20:17 -0500
Message-ID: <5007C33B.5010603@sgi.com>
Date: Thu, 19 Jul 2012 10:20:11 +0200
From: Alain Renaud <arenaud@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfs: prevent xfs_bmap_extsize_align() to exceed maximum
	extent size.
References: <20120712154554.377970666@sgi.com> <4FFFF3D8.7060001@sgi.com>
	<50059437.6070705@sgi.com> <20120719033027.GD23387@dastard>
In-Reply-To: <20120719033027.GD23387@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


On 12-07-19 05:30 AM, Dave Chinner wrote:
>
> Note the minlen? It's been shortened to reflect the fact I don't
> have 8GB freespace extents in the filesystem.
>
> Firstly, can you reproduce this on your test setup, Alain? What is
> the size (and number) of the AGs in the filesystem? If you do see
> this behaviour, then the alignment code is not the problem...

Note that I did provide an xfstest case in a seperate patch and YES you do 
need to make sure that the AG size is bigger then 8Gig for a filesystem 
with 4K block size you can reduce that by using a filesystem with a 512 
block size and 1Gig AG. look for this patch that I sent to the list.

[PATCH] xfstest: preallocate file space greater then MAXEXTLEN

>
>> +        * Make sure we do not exceed the maximum len of an extent.
>> +        */
>> +       align_alen = XFS_FILBLKS_MIN(align_alen,
>> +                                    MAXEXTLEN - (MAXEXTLEN % extsz));
> I don't think that is correct. alignment happens at both the start
> and end of the extent, so you need to take into account two lots of
> (extsz - 1) blocks of range extension for alignment.

If you look in the function where I put this code is it AFTER the head/len 
alignment so the HEAD is already align so I do not need to account for it. 
And if you look at the rest of the function we can only decrease the length 
and we do return the start and the length not the start and the end.

>
>> +	/*
>>   	 * If the previous block overlaps with this proposed allocation
>>   	 * then move the start forward without adjusting the length.
>>   	 */
>> @@ -1999,7 +2004,6 @@ xfs_bmap_extsize_align(
>>   			return XFS_ERROR(EINVAL);
>>   	} else {
>>   		ASSERT(orig_off >= align_off);
>> -		ASSERT(orig_end <= align_off + align_alen);
> Why is this removed? What it is checking is that the aligned end
> covers the entire range of the original space requested.

This is the logic I am following if the original start was at zero and the 
length we passed in was 9G the orig_end would be at 0+9G however the since 
we will truncate the 8Gig the align_off + align_alen will be smaller then 9G
>
>>   	}
>>   #ifdef DEBUG
>> @@ -2009,6 +2013,7 @@ xfs_bmap_extsize_align(
>>   		ASSERT(align_off >= prevp->br_startoff + prevp->br_blockcount);
>>   #endif
>> +	ASSERT(align_alen <= MAXEXTLEN);
>>   	*lenp = align_alen;
>>   	*offp = align_off;
>>   	return 0;
>> @@ -4450,13 +4455,6 @@ xfs_bmapi_reserve_delalloc(
>>   	/* Figure out the extent size, adjust alen */
>>   	extsz = xfs_get_extsz_hint(ip);
>>   	if (extsz) {
>> -		/*
>> -		 * Make sure we don't exceed a single extent length when we
>> -		 * align the extent by reducing length we are going to
>> -		 * allocate by the maximum amount extent size aligment may
>> -		 * require.
>> -		 */
>> -		alen = XFS_FILBLKS_MIN(len, MAXEXTLEN - (2 * extsz - 1));
> This code is allowing for both head and tail extent alignment....

Like I said I think my code does the same thing since when we truncate the 
length we already have aligned the head.


>
> Cheers,
>
> Dave.

-- 
===============================================
Alain Renaud     - Cluster File System Engineer
arenaud@sgi.com  - SGI
===============================================



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
