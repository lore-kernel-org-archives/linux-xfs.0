Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E0AF67F4E
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 07:57:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CE9298F8066
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 05:56:59 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Up6KgFnickR3FEMd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Sep 2013 05:56:58 -0700 (PDT)
Message-ID: <52418C3A.9080506@oracle.com>
Date: Tue, 24 Sep 2013 20:57:30 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix the wrong new_size/rnew_size at
	xfs_iext_realloc_direct()
References: <523EA96B.3040904@oracle.com> <20130923005657.GN12541@dastard>
	<523FC7DB.20204@oracle.com> <20130923235642.GY9901@dastard>
In-Reply-To: <20130923235642.GY9901@dastard>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 09/24/2013 07:56 AM, Dave Chinner wrote:

> On Mon, Sep 23, 2013 at 12:47:23PM +0800, Jeff Liu wrote:
>> Hi Dave,
>>
>> On 09/23/2013 08:56 AM, Dave Chinner wrote:
>>
>>> On Sun, Sep 22, 2013 at 04:25:15PM +0800, Jeff Liu wrote:
>>>> From: Jie Liu <jeff.liu@oracle.com>
>>>>
>>>> At xfs_iext_realloc_direct(), the new_size is changed by adding
>>>> if_bytes if originally the extent records are stored at the inline
>>>> extent buffer, and we have to switch from it to a direct extent
>>>> list for those new allocated extents, this is wrong. e.g,
>>>>
>>>> Create a file with three extents which was showing as following,
>>>>
>>>> xfs_io -f -c "truncate 100m" /xfs/testme
>>>>
>>>> for i in $(seq 0 5 10); do
>>>> 	offset=$(($i * $((1 << 20))))
>>>> 	xfs_io -c "pwrite $offset 1m" /xfs/testme
>>>> done
>>>>
>>>> Inline
>>>> ------
>>>> irec:	if_bytes	bytes_diff	new_size
>>>> 1st	0		16		16
>>>> 2nd	16		16		32
>>>>
>>>> Switching
>>>> ---------						rnew_size
>>>> 3rd	32		16		48 + 32 = 80	roundup=128
>>>>
>>>> In this case, the desired value of new_size should be 48, and then
>>>> it will be roundup to 64 and be assigned to rnew_size.
>>>
>>> Ok, so it allocates 128 bytes instead of 64 bytes. It tracks that
>>> allocation size correctly ifp->if_real_bytes, and all it means is
>>> that there are 4 empty extra slots in the extent array. The code
>>> already handles having empty slots in the direct extent array, so
>>> what impact is there as a result of the oversized initial allocation
>>> that is currently happening?
>>>
>>> i.e. if fixing the oversized results in more memory allocations due
>>> to resizing more regularly, then is there a benefit to changing this
>>> code given that the rewrite of the ifp->if_bytes value in the case
>>> where we do inline->direct conversion prevents this over-allocation
>>> from being a problem...
>>
>> I guess my current patch subject/description mislead you.  The result
>> of the oversized can be ignored since this can be handled in the direct
>> extent array as empty slots.
> 
> That's what I thought ;)
> 
>> Actually, what I want to say is that we don't need to perform
>> "new_size += ifp->if_bytes;" again at xfs_iext_realloc_direct()
>> because the new_size at xfs_iext_add() already be the size of
>> extents after adding, just as the variable comments is mentioned.
> 
> Yes, I understand.
> 
> What I'm really asking is that whether there is any specific impact
> you can measure as a result of changing the initial allocation size?
> i.e. are there workloads where there is a measurable difference in
> memory footprint or noticable performance impact of having to
> reallocate the direct array more frequently as files grow and/or
> shrink?

Not yet observed any performance matter, but IMO this problem can cause
difference in dynamic memory footprint for creating a large number of
files with 3 extents and with additional kmalloc/kfree overhead for 4
extents file.

For the first case, the current code will allocate buffers from
kmalloc-128 slab cache rather than kmalloc-64, hence it would occupy
more memory until being dropped from the cache, e.g,

# Create 10240 files with 3 extents
for ((i=0; i<10240; i++))
do
	xfs_io -f -c 'truncate 10m' /xfs/test_$i
	xfs_io -c 'pwrite 0 1' /xfs/test_$i 2>&1 >>/dev/null
	xfs_io -c 'pwrite 1m 1' /xfs/test_$i 2>&1 >>/dev/null
	xfs_io -c 'pwrite 5m 1' /xfs/test_$i 2>&1 >>/dev/null
done

# cat /proc/slab_info
# name        <active_objs>  <num_objs> <objsize> <objperslab> <pagesperslab>...

# Non-patched -- before creating files
kmalloc-128         5391   	6176       128		32    		1
kmalloc-64         21852  	25152      64 		64		1

# After that -- the number of objects in 128 slab increased significantly, while
there basically no change in 64 slab
kmalloc-128        15381  	15488      128		32    		1
kmalloc-64         21958	25088      64		64    		1


# patched -- before creating files
kmalloc-128         5751   	7072	   128		32   		1
kmalloc-64         21420	24896	   64		64		1	

After after
kmalloc-128         6155	6688	   128		32		1
kmalloc-64         30464	30464	   64		64		1

With this patch, we can reduce the memory footprint for this particular scenario.

For the 2nd case, i.e, 4 extents file.  It need to resize the direct extent list
to add the fourth extent because rnew_bytes is be re-initialized to 64 at the
beginning of xfs_iext_realloc_direct(), however the ifp->if_real_bytes is 128...

I can not think out a convenient approach(perf kmem not works on working laptop
for now) to demonstrate the consequence, but using ftrace to figure out the
different number of kmalloc. e.g,

# Creating 4096 files with 4 extents and fetch the # of kmalloc.
echo 0 > /sys/kernel/debug/tracing/events/kmem/kmalloc/enable
echo > /sys/kernel/debug/tracing/trace

for ((i=0; i<4096; i++))
do
	xfs_io -f -c 'truncate 10m' /xfs/test_$i
	xfs_io -c 'pwrite 0 1' /xfs/test_$i 2>&1 >>/dev/null
	xfs_io -c 'pwrite 1m 1' /xfs/test_$i 2>&1 >>/dev/null
	xfs_io -c 'pwrite 5m 1' /xfs/test_$i 2>&1 >>/dev/null
done

echo 1 > /sys/kernel/debug/tracing/events/kmem/kmalloc/enable
for ((i=0; i<4096; i++))
do
	xfs_io -c 'pwrite 8m 1' /xfs/test_$i 2>&1 >>/dev/null
done
cat /sys/kernel/debug/tracing/trace|grep kmalloc|wc -l

# The number of kmalloc calls
Default     	Patched
110364		103471


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
