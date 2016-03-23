Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8F9387CB1
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 10:03:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 609038F8035
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 08:03:23 -0700 (PDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com
	[74.125.82.46]) by cuda.sgi.com with ESMTP id zj0ddH70vWHh3wW1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 23 Mar 2016 08:03:20 -0700 (PDT)
Received: by mail-wm0-f46.google.com with SMTP id l68so200097968wml.0
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 08:03:20 -0700 (PDT)
Subject: Re: Failing XFS memory allocation
References: <56F26CCE.6010502@kyup.com>
	<20160323124312.GB43073@bfoster.bfoster> <56F29279.70600@kyup.com>
	<20160323131059.GC43073@bfoster.bfoster>
From: Nikolay Borisov <kernel@kyup.com>
Message-ID: <56F2B036.4090306@kyup.com>
Date: Wed, 23 Mar 2016 17:03:18 +0200
MIME-Version: 1.0
In-Reply-To: <20160323131059.GC43073@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com



On 03/23/2016 03:10 PM, Brian Foster wrote:
> On Wed, Mar 23, 2016 at 02:56:25PM +0200, Nikolay Borisov wrote:
>>
>>
>> On 03/23/2016 02:43 PM, Brian Foster wrote:
>>> On Wed, Mar 23, 2016 at 12:15:42PM +0200, Nikolay Borisov wrote:
> ...
>>> It looks like it's working to add a new extent to the in-core extent
>>> list. If this is the stack associated with the warning message (combined
>>> with the large alloc size), I wonder if there's a fragmentation issue on
>>> the file leading to an excessive number of extents.
>>
>> Yes this is the stack trace associated.
>>
>>>
>>> What does 'xfs_bmap -v /storage/loop/file1' show?
>>
>> It spews a lot of stuff but here is a summary, more detailed info can be
>> provided if you need it:
>>
>> xfs_bmap -v /storage/loop/file1 | wc -l
>> 900908
>> xfs_bmap -v /storage/loop/file1 | grep -c hole
>> 94568
>>
>> Also, what would constitute an "excessive number of extents"?
>>
> 
> I'm not sure where one would draw the line tbh, it's just a matter of
> having too many extents to the point that it causes problems in terms of
> performance (i.e., reading/modifying the extent list) or such as the
> allocation problem you're running into. As it is, XFS maintains the full
> extent list for an active inode in memory, so that's 800k+ extents that
> it's looking for memory for.

I saw in the comments that this problem has already been identified and
a possible solution would be to add another level of indirection. Also,
can you confirm that my understanding of the operation of the
indirection array is correct in that each entry in the indirection array
xfs_ext_irec is responsible for 256 extents. (the er_extbuf is
PAGE_SIZE/4kb and an extent is 16 bytes which results in 256 extents)

> 
> It looks like that is your problem here. 800k or so extents over 878G
> looks to be about 1MB per extent. Are you using extent size hints? One
> option that might prevent this is to use a larger extent size hint
> value. Another might be to preallocate the entire file up front with
> fallocate. You'd probably have to experiment with what option or value
> works best for your workload.

By preallocating with fallocate you mean using fallocate with
FALLOC_FL_ZERO_RANGE and not FALLOC_FL_PUNCH_HOLE, right? Because as it
stands now the file does have holes, which presumably are being filled
and in order to be filled an extent has to be allocated which caused the
issue?  Am I right in this reasoning?

Currently I'm not using extents size hint but will look into that, also
if the extent size hint is say 4mb, wouldn't that cause a fairly serious
loss of space, provided that the writes are smaller than 4mb. Would XFS
try to perform some sort of extent coalescing or something else? I'm not
an FS developer but my understanding is that with a 4mb extent size,
whenever a new write occurs even if it's 256kb a new 4mb extent would be
allocated, no?

And a final question - when i printed the contents of the inode with
xfs_db I get core.nextents = 972564 whereas invoking the xfs_bmap | wc
-l on the file always gives varying numbers?

Thanks a lot for taking the time to reply.




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
