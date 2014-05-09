Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3BB5E7F51
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 23:18:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DC2D9AC013
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 21:18:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 1iFFsAFTmY6peipC for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 21:18:43 -0700 (PDT)
Message-ID: <536C5728.6040805@sandeen.net>
Date: Thu, 08 May 2014 23:18:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] repair: don't grind CPUs with large extent lists
References: <1399598222-4349-1-git-send-email-david@fromorbit.com>
	<1399598222-4349-3-git-send-email-david@fromorbit.com>
	<536C4511.3050201@sandeen.net> <20140509035653.GJ26353@dastard>
In-Reply-To: <20140509035653.GJ26353@dastard>
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
Cc: xfs@oss.sgi.com

On 5/8/14, 10:56 PM, Dave Chinner wrote:
> On Thu, May 08, 2014 at 10:01:37PM -0500, Eric Sandeen wrote:
>> On 5/8/14, 8:17 PM, Dave Chinner wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> When repairing a large filesystem with fragemented files, xfs_repair
>>> can grind to a halt burning multiple CPUs in blkmap_set_ext().
>>> blkmap_set_ext() inserts extents into the blockmap for the inode
>>> fork and it keeps them in order, even if the inserts are not done in
>>> order.
>>>
>>> The ordered insert is highly inefficient - it starts at the first
>>> extent, and simple walks the array to find the insertion point. i.e.
>>> it is an O(n) operation. When we have a fragemented file with a
>>> large number of extents, the cost of the entire mapping operation
>>> is rather costly.
>>>
>>> The thing is, we are doing the insertion from an *ordered btree
>>> scan* which is inserting the extents in ascending offset order.
>>> IOWs, we are always inserting the extent at the end of the array
>>> after searching the entire array. i.e. the mapping operation cost is
>>> O(N^2).
>>>
>>> Fix this simply by reversing the order of the insert slot search.
>>> Start at the end of the blockmap array when we do almost all
>>> insertions, which brings the overhead of each insertion down to O(1)
>>> complexity. This, in turn, results in the overall map building
>>> operation being reduced to an O(N) operation, and so performance
>>> degrades linearly with increasing extent counts rather than
>>> exponentially.
>>>
>>> The result is that the test filesystem (27TB, 30M inodes, at ENOSPC)
>>> takes 5m10s to *fully repair* on my test system, rather that getting
>>> 15 (of 60) AGs into phase three and sitting there burning 3-4 CPUs
>>> making no progress for over half an hour.
>>
>> Did the blkmap_grow() changes sneak in here accidentally?
> 
> Ah, forgot to mention them. Do a realloc every 4 entries when we
> have hundreds of thousands of extents is just silly ;)

<snip>

> OK, I'll add "because we are doing an ascending offset order scan of
> the bmapbt" or words to that effect.

Ok, with those agreed-upon changes feel free to add a 

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

- thanks for getting these done.

-Eric
 
> Thanks!
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
