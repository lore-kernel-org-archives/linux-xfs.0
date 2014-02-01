Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BEDF87FB2
	for <xfs@oss.sgi.com>; Sat,  1 Feb 2014 15:06:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A56A8F8040
	for <xfs@oss.sgi.com>; Sat,  1 Feb 2014 13:06:23 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id fsxohdR6K09DVAmg
	for <xfs@oss.sgi.com>; Sat, 01 Feb 2014 13:06:18 -0800 (PST)
Message-ID: <52ED61C9.8060504@hardwarefreak.com>
Date: Sat, 01 Feb 2014 15:06:17 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <1391005406-sup-1881@al.wesleyan.edu>	<52E91923.4070706@sandeen.net>	<1391022066-sup-5863@al.wesleyan.edu>	<52E99504.4030902@hardwarefreak.com>	<1391090527-sup-4664@al.wesleyan.edu>	<20140130202819.GO2212@dastard>	<52EB3B96.7000103@hardwarefreak.com>
	<1391202273-sup-9265@al.wesleyan.edu>
In-Reply-To: <1391202273-sup-9265@al.wesleyan.edu>
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
To: "C. Morgan Hamill" <chamill@wesleyan.edu>
Cc: xfs <xfs@oss.sgi.com>

On 1/31/2014 3:14 PM, C. Morgan Hamill wrote:
> Excerpts from Stan Hoeppner's message of 2014-01-31 00:58:46 -0500:
...
>> LVM typically affords you much more flexibility here than your RAID/SAN
>> controller.  Just be mindful that when you expand you need to keep your
>> geometry, i.e. stripe width, the same.  Let's say some time in the
>> future you want to expand but can only afford, or only need, one 14 disk
>> chassis at the time, not another 3 for another RAID60.  Here you could
>> create a single 14 drive RAID6 with stripe geometry 384KB * 12 = 4608KB.
>>
>> You could then carve it up into 1-3 pieces, each aligned to the
>> start/end of a 4608KB stripe and evenly divisible by 4608KB, and add
>> them to one of more of your LVs/XFS filesystems.  This maintains the
>> same overall stripe width geometry as the RAID60 to which all of your
>> XFS filesystems are already aligned.
> 
> OK, so the upshot is is that any additions to the volume group must be
> array with su*sw=4608k, and all logical volumes and filesystems must
> begin and end on multiples of 4608k from the start of the block device.
> 
> As long as these things hold true, is it all right for logical
> volumes/filesystems to begin on one physical device and end on another?

Yes, that's one of the beauties of LVM.  However, there are other
reasons you may not want to do this.  For example, if you have allocated
space from two different JBOD or SAN units to a single LVM volume, and
you lack multipath connections, if you have a cable, switch, HBA, or
other failure disconnecting one LUN that will wreak havoc on your
mounted XFS filesystem.  If you have multipath and the storage device
disappears due to some other failure such as backplane,  UPS, etc, you
have the same problem.

This isn't a deal breaker.  There are many large XFS filesystems in
production that span multiple storage arrays.  You just need to be
mindful of your architecture at all times, and it needs to be
documented.  Scenario:  XFS unmounts due to an IO error.  You're not yet
aware an entire chassis is offline.  You can't remount the filesystem so
you start a destructive xfs_repair thinking that will fix the problem.
Doing so will wreck your filesystem and you'll likely lose access to all
the files on the offline chassis, with no ability to get it back short
of some magic and a full restore from tape or D2D backup server.  We had
a case similar to this reported a couple of years ago.

>> If you remember only 3 words of my post, remember:
>>
>> Alignment, alignment, alignment.
> 
> Yes, I am hearing you. :-)
> 
>> For a RAID60 setup such as you're describing, you'll want to use LVM,
>> and you must maintain consistent geometry throughout the stack, from
>> array to filesystem.  This means every physical volume you create must
>> start and end on a 4608KB stripe boundary.  Every volume group you
>> create must do the same.  And every logical volume must also start and
>> end on a 4608KB stripe boundary.  If you don't verify each layer is
>> aligned all of your XFS filesystems will likely be unaligned.  And
>> again, performance will suffer, possibly horribly so.
> 
> So, basically, --dataalignment is my friend during pvcreate and
> lvcreate.

If the logical sector size reported by your RAID controller is 512
bytes, then "--dataalignment=9216s" should start your data section on a
RAID60 stripe boundary after the metadata section.

Tthe PhysicalExtentSize should probably also match the 4608KB stripe
width, but this is apparently not possible.  PhysicalExtentSize must be
a power of 2 value.  I don't know if or how this will affect XFS aligned
write out.  You'll need to consult with someone more knowledgeable of LVM.

> Thanks so much for your and Dave's help; this has been tremendously
> helpful.

You bet.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
