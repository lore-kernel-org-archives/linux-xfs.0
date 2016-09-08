Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A9A4B7CBB
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 05:08:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 79AB08F8050
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 03:08:01 -0700 (PDT)
Received: from chinanetcenter.com (mail.chinanetcenter.com [123.103.13.31]) by
	cuda.sgi.com with ESMTP id 3TgduxRjavhbGpyZ for
	<xfs@oss.sgi.com>; Thu, 08 Sep 2016 03:07:56 -0700 (PDT)
Message-ID: <57D13871.9070603@chinanetcenter.com>
Date: Thu, 08 Sep 2016 18:07:45 +0800
From: Lin Feng <linf@chinanetcenter.com>
MIME-Version: 1.0
Subject: Re: [BUG REPORT] missing memory counter introduced by xfs
References: <57CFEDA3.9000005@chinanetcenter.com>
	<20160907212206.GP30056@dastard>
In-Reply-To: <20160907212206.GP30056@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: dchinner@redhat.com, xfs@oss.sgi.com

Hi Dave,

Thank you for your fast reply, look beblow please.

On 09/08/2016 05:22 AM, Dave Chinner wrote:
> On Wed, Sep 07, 2016 at 06:36:19PM +0800, Lin Feng wrote:
>> Hi all nice xfs folks,
>>
>> I'm a rookie and really fresh new in xfs and currently I ran into an
>> issue same as the following link described:
>> http://oss.sgi.com/archives/xfs/2014-04/msg00058.html
>>
>> In my box(running cephfs osd using xfs kernel 2.6.32-358) and I sum
>> all possible memory counter can be find but it seems that nearlly
>> 26GB memory has gone and they are back after I echo 2 >
>> /proc/sys/vm/drop_caches, so seems these memory can be reclaimed by
>> slab.
>
> It isn't "reclaimed by slab". The XFS metadata buffer cache is
> reclaimed by a memory shrinker, which are for reclaiming objects
> from caches that aren't the page cache. "echo 2 >
> /proc/sys/vm/drop_caches" runs the memory shrinkers rather than page
> cache reclaim. Many slab caches are backed by memory shrinkers,
> which is why it is thought that "2" is "slab reclaim"....
>
>> And according to what David said replying in the list:
> ..
>> That's where your memory is - in metadata buffers. The xfs_buf slab
>> entries are just the handles - the metadata pages in the buffers
>> usually take much more space and it's not accounted to the slab
>> cache nor the page cache.
>
> That's exactly the case.
>
>>   Minimum / Average / Maximum Object : 0.02K / 0.33K / 4096.00K
>>
>>    OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
>> 4383036 4383014  99%    1.00K 1095759        4   4383036K xfs_inode
>> 5394610 5394544  99%    0.38K 539461       10   2157844K xfs_buf
>
> So, you have *5.4 million* active metadata buffers. Each buffer will
> hold  1 or 2 4k pages on your kernel, so simple math says 4M * 4k +
> 1.4M * 8k = 26G. There's no missing counter here....

Does xattr contribute to such metadata buffers or there is something else?
After consulting to my teammate, who told me that in our case small files
(there are a looot, look below) always use xattr.

Another thing is do we need to export such thing or we have to make the 
computation every time to figure out if we leak memory.
And more important is that seems these memory has a low priority to be reclaimed 
by memory reclaim mechanism, does it due to most of the slab objects are active?
 >>    OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
 >> 4383036 4383014  99%    1.00K 1095759        4   4383036K xfs_inode
 >> 5394610 5394544  99%    0.38K 539461       10   2157844K xfs_buf

In fact xfs eats a lot of my ram and I will never know where it goes without 
diving into xfs source, at least I'm the second extreme user ;-)

>
> Obviously your workload is doing something extremely metadata
> intensive to have a cache footprint like this - you have more cached
> buffers than inodes, dentries, etc. That in itself is very unusual -
> can you describe what is stored on that filesystem and how large the
> attributes being stored in each inode are?

The fs-user behavior is that ceph-osd daemon will intensively 
pull/synchronize/update files from other osd when the server is up.
In our case cephfs osd stores a lot of small pictures in the filesystem, and I 
do some simple analysis, there are nearly 3,000,000 files on each disk and there 
are 10 such disk.
[root@wzdx49 osd.670]# find current -type f -size -512k | wc -l
2668769
[root@wzdx49 ~]# find /data/osd/osd.67 -type f | wc -l
2682891
[root@wzdx49 ~]# find /data/osd/osd.67 -type d | wc -l
109760

thanks,
linfeng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
