Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C6857F60
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 23:58:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6444B30407A
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 21:58:46 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id nRxLQOguT42u6K6C
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 21:58:42 -0800 (PST)
Message-ID: <52EB3B96.7000103@hardwarefreak.com>
Date: Thu, 30 Jan 2014 23:58:46 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <1391005406-sup-1881@al.wesleyan.edu>	<52E91923.4070706@sandeen.net>	<1391022066-sup-5863@al.wesleyan.edu>	<52E99504.4030902@hardwarefreak.com>	<1391090527-sup-4664@al.wesleyan.edu>
	<20140130202819.GO2212@dastard>
In-Reply-To: <20140130202819.GO2212@dastard>
Reply-To: stan@hardwarefreak.com
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
To: Dave Chinner <david@fromorbit.com>, "C. Morgan Hamill" <chamill@wesleyan.edu>
Cc: xfs <xfs@oss.sgi.com>

On 1/30/2014 2:28 PM, Dave Chinner wrote:
> On Thu, Jan 30, 2014 at 09:28:45AM -0500, C. Morgan Hamill wrote:
>> First, thanks very much for your help.  We're weening ourselves off
>> unnecessarily expensive storage and as such I unfortunately haven't had
>> as much experience with physical filesystems as I'd like.  I am also
>> unfamiliar with XFS.  I appreciate the help immensely.
>>
>> Excerpts from Stan Hoeppner's message of 2014-01-29 18:55:48 -0500:
>>> This is not correct.  You must align to either the outer stripe or the
>>> inner stripe when using a nested array.  In this case it appears your
>>> inner stripe is RAID6 su 128KB * sw 12 = 1536KB.  You did not state your
>>> outer RAID0 stripe geometry.  Which one you align to depends entirely on
>>> your workload.
>>
>> Ahh this makes sense; it had occurred to me that something like this
>> might be the case.  I'm not exactly sure what you mean by inner and
>> outer; I can imagine it going both ways.
>>
>> Just to clarify, it looks like this:
>>
>>      XFS     |      XFS    |     XFS      |      XFS
>> ---------------------------------------------------------
>>                     LVM volume group
>> ---------------------------------------------------------
>>                          RAID 0
>> ---------------------------------------------------------
>> RAID 6 (14 disks) | RAID 6 (14 disks) | RAID 6 (14 disks)
>> ---------------------------------------------------------
>>                     42 4TB SAS disks

RAID60 is a nested RAID level just like RAID10 and RAID50.  It is a
stripe, or RAID0, across multiple primary array types, RAID6 in this
case.  The stripe width of each 'inner' RAID6 becomes the stripe unit of
the 'outer' RAID0 array:

RAID6 geometry	 128KB * 12 = 1536KB
RAID0 geometry  1536KB * 3  = 4608KB

If you are creating your RAID60 array with a proprietary hardware
RAID/SAN management utility it may not be clearly showing you the
resulting nested geometry I've demonstrated above, which is correct for
your RAID60.

It is possible with software RAID to continue nesting stripe upon stripe
to build infinitely large nested arrays.  It is not practical to do so
for many reasons, but I'll not express those here as it is out of scope
for this discussion.  I am simply attempting to explain how nested RAID
levels are constructed.

> So optimised for sequential IO. The time-honoured method of setting
> up XFS for this if the workload is large files is to use a stripe
> unit that is equal to the width of the underlying RAID6 volumes with
> a stripe width of 3. That way XFS tries to align files to the start
> of each RAID6 volume, and allocate in full RAID6 stripe chunks. This
> mostly avoids RMW cycles for large files and sequential IO. i.e. su
> = 1536k, sw = 3.

As Dave demonstrates, your hardware geometry is 1536*3=4608KB.  Thus,
when you create your logical volumes they each need to start and end on
a 4608KB boundary, and be evenly divisible by 4608KB.  This will ensure
that all of your logical volumes are aligned to the RAID60 geometry.
When formatting the LVs with XFS you will use:

~# mkfs.xfs -d su=1536k,sw=3 /dev/[lv_device_path]

This aligns XFS to the RAID60 geometry.  Geometry alignment must be
maintained throughout the entire storage stack.  If a single layer is
not aligned properly, every layer will be misaligned.  When this occurs
performance will suffer, and could suffer tremendously.

You'll want to add "inode64" to your fstab mount options for these
filesystems.  This has nothing to do with geometry, but how XFS
allocates inodes and how/where files are written to AGs.  It is the
default in very recent kernels but I don't know in which it was made so.

>> ...more or less.
>>
>> I agree that it's quite weird, but I'll describe the workload and the
>> constraints.
> 
> [snip]
> 
> summary: concurrent (initially slow) sequential writes of ~4GB files.
> 
>> Now, here's the constraints, which is why I was planning on setting
>> things up as above:
>>
>>   - This is a budget job, so sane things like RAID 10 are our.  RAID
>>     6 or 60 are (as far as I can tell, correct me if I'm wrong) our only
>>     real options here, as anything else either sacrifices too much
>>     storage or is too susceptible failure from UREs.
> 
> RAID6 is fine for this.
>
>>   - I need to expose, in the end, three-ish (two or four would be OK)
>>     filesystems to the backup software, which should come fairly close
>>     to minimizing the effects of the archive maintenance jobs (integrity
>>     checks, mostly).  CrashPlan will spawn 2 jobs per store point, so
>>     a max of 8 at any given time should be a nice balance between
>>     under-utilizing and saturating the IO.
> 
> So concurrency is up to 8 files being written at a time. That's
> pretty much on the money for striped RAID. Much more than this and
> you end up with performance being limited by seeking on the slowest
> disk in the RAID sets.
> 
>> So I had thought LVM over RAID 60 would make sense because it would give
>> me the option of leaving a bit of disk unallocated and being able to
>> tweak filesystem sizes a bit as time goes on.
> 
> *nod*
> 
> And it allows you, in future, to add more disks and grow across them
> via linear concatentation of more RAID60 luns of the same layout...
> 
>> Now that I think of it though, perhaps something like 2 or 3 RAID6
>> volumes would make more sense, with XFS directly on top of them.  In
>> that case I have to balance number of volumes against the loss of
>> 2 parity disks, however.
> 
> Probably not worth the complexity.

You'll lose 2 disks to parity with RAID6 regardless.  Three standalone
arrays costs you 6 disks, same as making a RAID60 of those 3 arrays.
The problem you'll have with XFS directly on RAID6 is the inability to
easily expand.  The only way to do it is by by adding disks to each
RAID6 and having the controller reshape the array.  Reshapes with 4TB
drives will take more than a day to complete and the array will be very
slow during the reshape.  Every time you reshape the array your geometry
will change.  XFS has the ability to align to a new geometry using a
mount option, but it's best to avoid this.

LVM typically affords you much more flexibility here than your RAID/SAN
controller.  Just be mindful that when you expand you need to keep your
geometry, i.e. stripe width, the same.  Let's say some time in the
future you want to expand but can only afford, or only need, one 14 disk
chassis at the time, not another 3 for another RAID60.  Here you could
create a single 14 drive RAID6 with stripe geometry 384KB * 12 = 4608KB.

You could then carve it up into 1-3 pieces, each aligned to the
start/end of a 4608KB stripe and evenly divisible by 4608KB, and add
them to one of more of your LVs/XFS filesystems.  This maintains the
same overall stripe width geometry as the RAID60 to which all of your
XFS filesystems are already aligned.

The volume manager in your RAID hardware may not, probably won't, allow
doing this type of expansion after the fact, meaning after the original
RAID60 has been created.

If you remember only 3 words of my post, remember:

Alignment, alignment, alignment.

For a RAID60 setup such as you're describing, you'll want to use LVM,
and you must maintain consistent geometry throughout the stack, from
array to filesystem.  This means every physical volume you create must
start and end on a 4608KB stripe boundary.  Every volume group you
create must do the same.  And every logical volume must also start and
end on a 4608KB stripe boundary.  If you don't verify each layer is
aligned all of your XFS filesystems will likely be unaligned.  And
again, performance will suffer, possibly horribly so.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
