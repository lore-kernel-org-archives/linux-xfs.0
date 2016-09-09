Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 773157CA1
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2016 01:32:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1959D304043
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 23:32:32 -0700 (PDT)
Received: from chinanetcenter.com (mail.chinanetcenter.com [123.103.13.31]) by
	cuda.sgi.com with ESMTP id 0uiQockA2pdcT2SG for
	<xfs@oss.sgi.com>; Thu, 08 Sep 2016 23:32:28 -0700 (PDT)
Message-ID: <57D25772.3070304@chinanetcenter.com>
Date: Fri, 09 Sep 2016 14:32:18 +0800
From: Lin Feng <linf@chinanetcenter.com>
MIME-Version: 1.0
Subject: Re: [BUG REPORT] missing memory counter introduced by xfs
References: <57CFEDA3.9000005@chinanetcenter.com>
	<20160907212206.GP30056@dastard>
	<57D13871.9070603@chinanetcenter.com>
	<20160908204413.GW30056@dastard>
In-Reply-To: <20160908204413.GW30056@dastard>
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

A final not-clear concept about XFS, look beblow please.

On 09/09/2016 04:44 AM, Dave Chinner wrote:
> On Thu, Sep 08, 2016 at 06:07:45PM +0800, Lin Feng wrote:
>> Hi Dave,
>>
>> Thank you for your fast reply, look beblow please.
>>
>> On 09/08/2016 05:22 AM, Dave Chinner wrote:
>>> On Wed, Sep 07, 2016 at 06:36:19PM +0800, Lin Feng wrote:
>>>> Hi all nice xfs folks,
>>>>
>>>> I'm a rookie and really fresh new in xfs and currently I ran into an
>>>> issue same as the following link described:
>>>> http://oss.sgi.com/archives/xfs/2014-04/msg00058.html
>>>>
>>>> In my box(running cephfs osd using xfs kernel 2.6.32-358) and I sum
>>>> all possible memory counter can be find but it seems that nearlly
>>>> 26GB memory has gone and they are back after I echo 2 >
>>>> /proc/sys/vm/drop_caches, so seems these memory can be reclaimed by
>>>> slab.
>>>
>>> It isn't "reclaimed by slab". The XFS metadata buffer cache is
>>> reclaimed by a memory shrinker, which are for reclaiming objects
>> >from caches that aren't the page cache. "echo 2 >
>>> /proc/sys/vm/drop_caches" runs the memory shrinkers rather than page
>>> cache reclaim. Many slab caches are backed by memory shrinkers,
>>> which is why it is thought that "2" is "slab reclaim"....
>>>
>>>> And according to what David said replying in the list:
>>> ..
>>>> That's where your memory is - in metadata buffers. The xfs_buf slab
>>>> entries are just the handles - the metadata pages in the buffers
>>>> usually take much more space and it's not accounted to the slab
>>>> cache nor the page cache.
>>>
>>> That's exactly the case.
>>>
>>>>   Minimum / Average / Maximum Object : 0.02K / 0.33K / 4096.00K
>>>>
>>>>    OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
>>>> 4383036 4383014  99%    1.00K 1095759        4   4383036K xfs_inode
>>>> 5394610 5394544  99%    0.38K 539461       10   2157844K xfs_buf
>>>
>>> So, you have *5.4 million* active metadata buffers. Each buffer will
>>> hold  1 or 2 4k pages on your kernel, so simple math says 4M * 4k +
>>> 1.4M * 8k = 26G. There's no missing counter here....
>>
>> Does xattr contribute to such metadata buffers or there is something else?
>
> xattrs are metadata, so if they don't fit in line in the inode
> (typical for ceph because it uses xattrs larger than 256 bytes) then
> they are held in external blocks which are cached in the buffer
> cache.
>

So the 'buffer cache' here you mean is the pages handled by xfs_buf struct, used 
to hold the xattrs if the inode inline data space overflows, not the 
'beffer/cache' seen via free command, they won't reflect in cache field by free 
command, right?

>> After consulting to my teammate, who told me that in our case small files
>> (there are a looot, look below) always use xattr.
>
> Which means that if you have 4.4M cached inodes, you probably have
> ~4.4M xattr metadata buffers in cache for those inodes, too.
>
>> Another thing is do we need to export such thing or we have to make
>> the computation every time to figure out if we leak memory.
>> And more important is that seems these memory has a low priority to
>> be reclaimed by memory reclaim mechanism, does it due to most of the
>> slab objects are active?
>
> "active" slab objects simply mean they are allocated. It does not
> mean they are cached or imply anything else about the object's life
> cycle.

Sorry, I mistake the concept for active in slab, thanks your explanation.
>
>>>>     OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
>>>> 4383036 4383014  99%    1.00K 1095759        4   4383036K xfs_inode
>>>> 5394610 5394544  99%    0.38K 539461       10   2157844K xfs_buf
>>
>> In fact xfs eats a lot of my ram and I will never know where it goes
>> without diving into xfs source, at least I'm the second extreme user
>> ;-)
>>
>>>
>>> Obviously your workload is doing something extremely metadata
>>> intensive to have a cache footprint like this - you have more cached
>>> buffers than inodes, dentries, etc. That in itself is very unusual -
>>> can you describe what is stored on that filesystem and how large the
>>> attributes being stored in each inode are?
>>
>> The fs-user behavior is that ceph-osd daemon will intensively
>> pull/synchronize/update files from other osd when the server is up.
>> In our case cephfs osd stores a lot of small pictures in the
>> filesystem, and I do some simple analysis, there are nearly
>> 3,000,000 files on each disk and there are 10 such disk.
>> [root@wzdx49 osd.670]# find current -type f -size -512k | wc -l
>> 2668769
>> [root@wzdx49 ~]# find /data/osd/osd.67 -type f | wc -l
>> 2682891
>> [root@wzdx49 ~]# find /data/osd/osd.67 -type d | wc -l
>> 109760
>
> Yup, that's a pretty good indication that you have a high metadata
> to data ratio in each filesystem, and that ceph is accessing the
> metadata more intensively than the data. The fact that the metadata
> buffer count roughly matches the cached inode count tells me that
> the memory reclaim code is being fairly balanced about what it
> reclaims under memory pressure - I think the problem here is more
> that you didn't know where the memory was being used than anything
> else....

Yes, that's exactly why I sent this mail.
Again, thanks for your detailed explanation.

Best regards,
linfeng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
