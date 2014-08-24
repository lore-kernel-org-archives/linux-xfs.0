Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 698C57F4E
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2014 15:14:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EDC1DAC001
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2014 13:14:43 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id cKECPEteVhkJ9os4
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2014 13:14:42 -0700 (PDT)
Message-ID: <53FA47B4.6020103@hardwarefreak.com>
Date: Sun, 24 Aug 2014 15:14:44 -0500
From: stan hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: inode64 directory placement determinism
References: <e1eeba7b0fb97c63e41f40ed9ac162d7@localhost>	<20140818070153.GL20518@dastard>	<bc34a576d2b3e8c431633574deaa37cc@localhost>	<20140818224853.GD26465@dastard>
	<ed7598d015f5a1d3576e6b03f3ef3116@localhost>
In-Reply-To: <ed7598d015f5a1d3576e6b03f3ef3116@localhost>
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
Cc: xfs@oss.sgi.com


On 08/18/2014 07:02 PM, Stan Hoeppner wrote:
> On Tue, 19 Aug 2014 08:48:53 +1000, Dave Chinner <david@fromorbit.com>
> wrote:
>> On Mon, Aug 18, 2014 at 11:16:12AM -0500, Stan Hoeppner wrote:
>>> On Mon, 18 Aug 2014 17:01:53 +1000, Dave Chinner <david@fromorbit.com>
>>> wrote:
>>>> On Sun, Aug 17, 2014 at 10:29:21PM -0500, Stan Hoeppner wrote:
>>>>> Say I have a single 4TB disk in an md linear device.  The md device
>>>>> has
>>> a
>>>>> filesystem on it formatted with defaults.  It has 4 AGs, 0-3.  I
> have
>>>>> created 4 directories.  Each should reside in a different AG, the
>>>>> first
>>>>> in
>>>>> AG0.  Now I expand the linear device with an identical 4TB disk and
>>>>> execute
>>>>> xfs_growfs.  I now have 4 more AGs, 4-7.  I create 4 more
> directories.
>>>>>
>>>>> Will these 4 new dirs be created sequentially in AGs 4-7, or in the
>>> first
>>>>> 4 AGs?  Is this deterministic, or is there any chance involved?  On
>>>>> the
>>>>
>>>> Deterministic, assuming single threaded *file-system-wide* directory
>>>> creation. Completely unpredictable under concurrent directory
>>>> creations.  See xfs_ialloc_ag_select/xfs_ialloc_next_ag.
>>>>
>>>> Note that the rotor used to select the next AG is set to
>>>> zero at mount.
>>>>
>>>> i.e. single threaded behaviour at agcount = 4:
>>>>
>>>> dir number	rotor value	  destination AG
>>>>   1		  0			0
>>>>   2		  1			1
>>>>   3		  2			2
>>>>   4		  3			3
>>>>   5		  0			0
>>>>   6		  1			1
>>>> ....
>>>>
>>>> So, if you do what you suggest, and grow *after* the first 4 dirs
>>>> are created, the above is what you'll get because the rotor goes
>>>> back to zero on the fourth directory create. Now, with changing from
>>>> 4 to 8 AGs after the first 4:
>>>>
>>>> dir number	rotor value	  new inode location (AG)
>>>>   1		  0			0
>>>>   2		  1			1
>>>>   3		  2			2
>>>>   4		  3			3
>>>> <grow to 8 AGs>
>>>>   5		  0			0
>>>>   6		  1			1
>>>>   7		  2			2
>>>>   8		  3			3
>>>>   9		  4			4
>>>>   10		  5			5
>>>>   11		  6			6
>>>>   13		  7			7
>>>>   14		  0			0
>>>>
>>>>> real system these 4TB drives are actually 48TB LUNs.  I'm after
>>>>> deterministic parallel bandwidth to subsequently added RAIDs after
>>>>> each
>>>>> grow operation by simply writing to the proper directory.
>>>>
>>>> Just create new directories and use the inode number to
>>>> determine their location. If the directory is not in the correct AG,
>>>> remove it and create a new one, until you have directories located
>>>> in the AGs you want.
>>>>
>>>> Cheers,
>>>>
>>>> Dave.
>>>
>>>
>>> Thanks for the info Dave.  Was hoping it would be more straightforward.
>
>>> Modifying the app for this is out of the question.  They've spent 3+
>>> years
>>> developing with EXT4 and decided to try XFS at the last minute.
> Product
>>> is
>>> to ship in October, so optimizations I can suggest are limited.
>>
>> Perhaps you could actually tell us what the requirement for
>> layout/separation is, and how they are acheiving it with ext4. We
>> really need a more "directed" allocation ability, but it's not clear
>> exactly what requirements need to drive that.
>>
>> Cheers,
>>
>> Dave.
>
> The test harness app writes to thousands of preallocated files in hundreds
> of directories.  The target is ~250MB/s at the application per array, more
> if achievable, writing a combination of fast and slow streams from up to
> ~1000 threads, to different files, circularly.  The mix of stream rates and
> the files they write will depend on the end customers' needs.  Currently
> they have 1 FS per array with 3 top level dirs each w/3 subdirs, 2 of these
> with ~100 subdirs each, and hundreds files in each of those.  Simply doing
> a concat, growing and just running with it might work fine.  The concern is
> ending up with too many fast stream writers hitting AGs on a single array
> which won't be able to keep up.  Currently they simply duplicate the layout
> on each new filesystem they mount.  The application duplicates the same
> layout on each filesystem and does its own load balancing among the group
> of them.
>
> Ideally they'd obviously like to simply add files to existing directories
> after growing, but that won't achieve scalable bandwidth.


My apologies Dave.  The above isn't really a description of a 
requirement, but simply how they do things currently.  So let me take 
another stab at this.  I think the generic requirement is best described 
as:

	Create a directory in the first AG in a range of specified
	AGs.  Create all child directories and files in AGs within the
	range of AGs, starting with the first AG.  In other words, we
	take the default behavior of the inode64 allocator and we apply
	it to a subset of AGs within the filesystem.  Something like...

agr = allocation group range

1.  mkdir $directory agr=0,47

2.  create $directory in AG0 and set flag in metadata to have inode64
     allocator rotor new child directories of this parent across only
     the AGs in the range specified

3.  file allocation policy need not be altered, files go in parent
     directory, parent AG.  If we spill due to AG free space do what
     we already do and allow writing outside of the AGs in agr


So when we expand the concat and grow XFS we simply do

~$ mkdir $directory agr=48,95

All child directories and files created in $directory will be allocated 
in AGs 48-95, only on the new LUN.  Rinse and repeat.

Such a feature would provide everything needed I think for this 
particular workload.  I can imagine there are similar workloads out 
there that would benefit from something like this given the prevalence 
of large concatenated RAID6s today.  Another scenario that might benefit 
from something like this is short stroking of mechanical storage, but 
controlling it at the filesystem level instead of the block or 
controller layer.

Setting AGR with an mkdir switch might not fly due to it being a generic 
command for all filesystems.  But it would sure be the most 
straightforward approach and easiest to use.

Due to the timetable and other restrictions I wouldn't be able to use 
patches that might come from fleshing out our ideas here, but I think it 
would be very useful functionality for others.

Cheers,

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
