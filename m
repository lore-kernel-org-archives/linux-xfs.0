Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 71BC07CA7
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2016 16:22:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 440AE30404E
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2016 14:22:12 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Iq5Jd78S6QxPaOEa for <xfs@oss.sgi.com>;
	Wed, 07 Sep 2016 14:22:08 -0700 (PDT)
Date: Thu, 8 Sep 2016 07:22:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [BUG REPORT] missing memory counter introduced by xfs
Message-ID: <20160907212206.GP30056@dastard>
References: <57CFEDA3.9000005@chinanetcenter.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <57CFEDA3.9000005@chinanetcenter.com>
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
To: Lin Feng <linf@chinanetcenter.com>
Cc: dchinner@redhat.com, xfs@oss.sgi.com

On Wed, Sep 07, 2016 at 06:36:19PM +0800, Lin Feng wrote:
> Hi all nice xfs folks,
> 
> I'm a rookie and really fresh new in xfs and currently I ran into an
> issue same as the following link described:
> http://oss.sgi.com/archives/xfs/2014-04/msg00058.html
> 
> In my box(running cephfs osd using xfs kernel 2.6.32-358) and I sum
> all possible memory counter can be find but it seems that nearlly
> 26GB memory has gone and they are back after I echo 2 >
> /proc/sys/vm/drop_caches, so seems these memory can be reclaimed by
> slab.

It isn't "reclaimed by slab". The XFS metadata buffer cache is
reclaimed by a memory shrinker, which are for reclaiming objects
from caches that aren't the page cache. "echo 2 >
/proc/sys/vm/drop_caches" runs the memory shrinkers rather than page
cache reclaim. Many slab caches are backed by memory shrinkers,
which is why it is thought that "2" is "slab reclaim"....

> And according to what David said replying in the list:
..
> That's where your memory is - in metadata buffers. The xfs_buf slab
> entries are just the handles - the metadata pages in the buffers
> usually take much more space and it's not accounted to the slab
> cache nor the page cache.

That's exactly the case.

>  Minimum / Average / Maximum Object : 0.02K / 0.33K / 4096.00K
> 
>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> 4383036 4383014  99%    1.00K 1095759        4   4383036K xfs_inode
> 5394610 5394544  99%    0.38K 539461       10   2157844K xfs_buf

So, you have *5.4 million* active metadata buffers. Each buffer will
hold  1 or 2 4k pages on your kernel, so simple math says 4M * 4k +
1.4M * 8k = 26G. There's no missing counter here....

Obviously your workload is doing something extremely metadata
intensive to have a cache footprint like this - you have more cached
buffers than inodes, dentries, etc. That in itself is very unusual -
can you describe what is stored on that filesystem and how large the
attributes being stored in each inode are?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
