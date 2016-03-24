Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A4577CA0
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:20:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7B2FCAC006
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 02:20:30 -0700 (PDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id JjmVRCBJRfwA5Dn2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Mar 2016 02:20:26 -0700 (PDT)
Received: by mail-wm0-f50.google.com with SMTP id l68so228485079wml.0
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 02:20:26 -0700 (PDT)
Subject: Re: Failing XFS memory allocation
References: <56F26CCE.6010502@kyup.com>
	<20160323124312.GB43073@bfoster.bfoster> <56F29279.70600@kyup.com>
	<20160323131059.GC43073@bfoster.bfoster>
	<20160323230002.GY30721@dastard>
From: Nikolay Borisov <kernel@kyup.com>
Message-ID: <56F3B157.2060505@kyup.com>
Date: Thu, 24 Mar 2016 11:20:23 +0200
MIME-Version: 1.0
In-Reply-To: <20160323230002.GY30721@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com



On 03/24/2016 01:00 AM, Dave Chinner wrote:
> On Wed, Mar 23, 2016 at 09:10:59AM -0400, Brian Foster wrote:
>> On Wed, Mar 23, 2016 at 02:56:25PM +0200, Nikolay Borisov wrote:
>>> On 03/23/2016 02:43 PM, Brian Foster wrote:
>>>> On Wed, Mar 23, 2016 at 12:15:42PM +0200, Nikolay Borisov wrote:
>> ...
>>>> It looks like it's working to add a new extent to the in-core extent
>>>> list. If this is the stack associated with the warning message (combined
>>>> with the large alloc size), I wonder if there's a fragmentation issue on
>>>> the file leading to an excessive number of extents.
>>>
>>> Yes this is the stack trace associated.
>>>
>>>>
>>>> What does 'xfs_bmap -v /storage/loop/file1' show?
>>>
>>> It spews a lot of stuff but here is a summary, more detailed info can be
>>> provided if you need it:
>>>
>>> xfs_bmap -v /storage/loop/file1 | wc -l
>>> 900908
>>> xfs_bmap -v /storage/loop/file1 | grep -c hole
>>> 94568
>>>
>>> Also, what would constitute an "excessive number of extents"?
>>>
>>
>> I'm not sure where one would draw the line tbh, it's just a matter of
>> having too many extents to the point that it causes problems in terms of
>> performance (i.e., reading/modifying the extent list) or such as the
>> allocation problem you're running into. As it is, XFS maintains the full
>> extent list for an active inode in memory, so that's 800k+ extents that
>> it's looking for memory for.
>>
>> It looks like that is your problem here. 800k or so extents over 878G
>> looks to be about 1MB per extent.
> 
> Which I wouldn't call excessive. I use a 1MB extent size hint on all
> my VM images as this allows the underlying device to do IOs large
> enough to maintain clear to full bandwidth when reading and writing
> regions of the underlying image file that are non-contiguous w.r.t.
> sequential IO from the guest.
> 
> Mind you, it's not until I use ext4 or btrfs in the guests that I
> actually see significant increases in extent size. Rule of thumb in
> my testing is that if XFs creates 100k extents in the image file,
> ext4 will create 500k, and btrfs will create somewhere between 1m
> and 5m extents....
> 
> i.e. XFS as a guest filesystem gives results in much lower image
> file fragmentation that the other options....
> 
> As it is, yes, the memory allocation problem is with the in-core
> extent tree, and we've known about it for some time. The issue is
> that as memory gets fragmented, the top level indirection array
> grows too large to be allocated as a contiguous chunk. When this
> happens really depends on memory load, uptime and the way the extent
> tree is being modified.

And what about the following completely crazy idea of switching order >
3 allocations to using vmalloc? I know this would incur heavy
performance hit, but other than that would it cause correctness issues?
Of course I'm not saying this should be implemented in upstream rather
whether it's worth it having a go for experimenting with this idea.


> 
> I'm working on prototype patches to convert it to an in-memory btree
> but they are far from ready at this point. This isn't straight
> forward because all the extent management code assumes extents are
> kept in a linear array and can be directly indexed by array offset
> rather than file offset. I also want to make sure we can demand page
> the extent list if necessary, and that also complicates things like
> locking, as we currently assume the extent list is either completely
> in memory or not in memory at all.
> 
> Fundamentally, I don't want to repeat the mistakes ext4 and btrfs
> have made with their fine-grained in memory extent trees that are
> based on rb-trees (e.g. global locks, shrinkers that don't scale or
> consume way too much CPU, excessive memory consumption, etc) and so
> solving all aspects of the problem in one go is somewhat complex.
> And, of course, there's so much other stuff that needs to be done at
> the same time, I cannot find much time to work on it at the
> moment...
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
