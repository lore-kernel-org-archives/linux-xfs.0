Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 63CB07F5F
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 12:34:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E643EAC003
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 10:34:47 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id y7m7ZmfrKwM8BKMt
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 10:34:46 -0700 (PDT)
Message-ID: <544BDF55.9040804@hardwarefreak.com>
Date: Sat, 25 Oct 2014 12:35:17 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: makefs alignment issue
References: <544AB289.8010005@hardwarefreak.com>	<544AB338.2050905@sandeen.net>	<544ACDC4.1070501@hardwarefreak.com>	<544AD077.4080305@sandeen.net>	<544AD234.3060100@sandeen.net>
	<544B1439.6060509@hardwarefreak.com> <544BC6FA.8090101@sandeen.net>
In-Reply-To: <544BC6FA.8090101@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com


On 10/25/2014 10:51 AM, Eric Sandeen wrote:
> On 10/24/14 10:08 PM, Stan Hoeppner wrote:
>> On 10/24/2014 05:27 PM, Eric Sandeen wrote:
>>> On 10/24/14 5:19 PM, Eric Sandeen wrote:
>>>> On 10/24/14 5:08 PM, Stan Hoeppner wrote:
>>>>>
>>>>> On 10/24/2014 03:14 PM, Eric Sandeen wrote:
>>>>
>>>> ...
>>>>
>>>>>>> Any ideas how to verify what's going on here and fix it?
>>>>>>
>>>>>> # blockdev --getiomin --getioopt /dev/s2d_a1l003
>>>
>>> Also, what does it show for the underlying non-multipath device(s)?
>>
>> # blockdev --getiomin --getioopt /dev/sdj
>> 512
>> 1048576
>> # blockdev --getiomin --getioopt /dev/sdf
>> 512
>> 1048576
> 
> Ok, so dm multipath is just bubbling up what the device itself
> is claiming; not dm's doing.
> 
> I forgot to ask (and you forgot to report...!) what version
> of xfsprogs you're using....

Sorry Eric, my bad.  I should know better after all these years. :(
It's old Debian 6.0 IIRC, let's see...

# xfs_repair -V
xfs_repair version 3.1.4

> Currently, blkid_get_topology() in xfsprogs does:
> 
>         /*
>          * Blkid reports the information in terms of bytes, but we want it in
>          * terms of 512 bytes blocks (just to convert it to bytes later..)
>          *
>          * If the reported values are the same as the physical sector size
>          * do not bother to report anything.  It will just cause warnings
>          * if people specify larger stripe units or widths manually.
>          */
>         val = blkid_topology_get_minimum_io_size(tp);
>         if (val > *psectorsize)
>                 *sunit = val >> 9;
>         val = blkid_topology_get_optimal_io_size(tp);
>         if (val > *psectorsize)
>                 *swidth = val >> 9;
> 
> so in your case sunit probably wouldn't get set (can you confirm with
> # blockdev --getpbsz that the physical sector size is also 512?)

# blockdev --getpbsz /dev/dm-0
512

> But the optimal size is > physical sector so swidth gets set.
> 
> Bleah...  can you just collect all of:
> 
> # blockdev --getpbsz --getss --getiomin --getioopt

# blockdev --getpbsz --getss --getiomin --getioopt /dev/sdj
512
512
512
1048576

# blockdev --getpbsz --getss --getiomin --getioopt /dev/sdh
512
512
512
1048576

> for your underlying devices, and I'll dig into how xfsprogs is behaving for
> those values.  I have a hunch that we should be ignoring stripe units of 512
> even if the "width" claims to be something larger.

Just a hunch? :)

If the same interface is used for Linux logical block devices (md, dm,
lvm, etc) and hardware RAID, I have a hunch it may be better to
determine that, if possible, before doing anything with these values.
As you said previously, and I agree 100%, a lot of RAID vendors don't
export meaningful information here.  In this specific case, I think the
RAID engineers are exporting a value, 1 MB, that works best for their
cache management, or some other path in their firmware.  They're
concerned with host interface xfer into the controller, not the IOs on
the back end to the disks.  They don't see this as an end-to-end deal.
In fact, I'd guess most of these folks see their device as performing
magic, and it doesn't matter what comes in or goes out either end.
"We'll take care of it."

I don't know what underlying SCSI command is used for populating
optimal_io_size.  I'm guessing this has different meaning for different
folks.  You say optimal_io_size is the same as RAID width.  Apply that
to this case:

hardware RAID 60 LUN, 4 arrays
16+2 RAID6, 256 KB stripe unit, 4096 KB stripe width
16 MB LUN stripe width
optimal_io_size = 16 MB

Is that an appropriate value for optimal_io_size even if this is the
RAID width?  I'm not saying it isn't.  I don't know.  I don't know what
other layers of the Linux and RAID firmware stacks are affected by this,
nor how they're affected.

Thanks,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
