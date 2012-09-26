Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8QED4VE214576 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 09:13:04 -0500
Message-ID: <50630DB6.4070405@sgi.com>
Date: Wed, 26 Sep 2012 09:14:14 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock
	hang
References: <20120924171159.GG1140@sgi.com>
	<201209241809.q8OI94s3003323@eagdhcp-232-125.americas.sgi.com>
	<20120925005632.GB23520@dastard> <5061CA48.3040202@sgi.com>
	<20120925220110.GF29154@dastard>
In-Reply-To: <20120925220110.GF29154@dastard>
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
Cc: bpm@sgi.com, xfs@oss.sgi.com

On 09/25/12 17:01, Dave Chinner wrote:
> On Tue, Sep 25, 2012 at 10:14:16AM -0500, Mark Tinguely wrote:

<deletes>

>>>>
>>>> As a bonus, consolidating the loops into one worker actually gives a slight
>>>> performance advantage.
>>>
>>> Can you quantify it?
>>
>> I was comparing the bonnie and iozone benchmarks outputs. I will see
>> if someone can enlighten me on how to quantify those numbers.
>
> Ugh.
>
> Don't bother. Those are two of the worst offenders in the "useless
> benchmarks for regression testing" category. Yeah, they *look* like
> they give decent numbers, but I've wasted so much time looking at
> results from these benhmarks only to find they do basic things wrong
> and give numbers that vary simple because you've made a change that
> increases or decreases the CPU cache footprint of a code path.
>
> e.g. IOZone uses the same memory buffer as the source/destination of
> all it's IO, and does not touch the contents of it at all. Hence for
> small IO, the buffer stays resident in the CPU caches and gives
> unrealsitically high throughput results. Worse is the fact that CPU
> cache residency of the buffer can change according to the kernel
> code path taken, so you can get massive changes in throughput just
> by changing the layout of the code without changing any logic....
>
> IOZone can be useful if you know exactly what you are doing and
> using it to test a specific code path with a specific set of
> configurations. e.g. comparing ext3/4/xfs/btrfs on the same kernel
> and storage is fine. However, the moment you start using it to
> compare different kernels, it's a total crap shoot....

does anyone have a good benchmark XFS should use to share performance 
results? A number that we can agree a series does not degrade the 
filesystem..

lies, damn lies, statistics and then filesystem benchmarks?! :)


> I guess I don't understand what you mean by "loop on
> xfs_alloc_vextent()" then.
>
> The problem I see above is this:
>
> thread 1		worker 1		worker 2..max
> xfs_bmapi_write(userdata)

     loops here calling xfs_bmapi_alloc()

>    xfs_bmapi_allocate(user)
>      xfs_alloc_vextent(user)
>        wait
>
> 			_xfs_alloc_vextent()
> 			locks AGF

			 first loop it takes the lock
			 one of the next times through the above
			 loop it cannot get a worker. deadlock here.

			 I saved the xfs_bmalloca and fs_alloc_arg when
			 allocating a buffer to verify the paths.

> 						_xfs_alloc_vextent()
> 						blocks on AGF lock

> 			completes allocation
>
>        <returns with AGF locked in transaction>
>      xfs_bmap_add_extent_hole_real
>        xfs_bmap_extents_to_btree
>          xfs_alloc_vextent(user)
>            wait

	   this does not need a worker, and since in the same
            transaction all locks to the AGF buffer are recursive locks.
	   no wait here.
>
> <deadlock as no more workers available>

<deletes>

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
