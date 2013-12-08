Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 78E247F80
	for <xfs@oss.sgi.com>; Sat,  7 Dec 2013 23:22:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B8998F8039
	for <xfs@oss.sgi.com>; Sat,  7 Dec 2013 21:22:22 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id jXvMen9sZzu1Iart
	for <xfs@oss.sgi.com>; Sat, 07 Dec 2013 21:22:11 -0800 (PST)
Message-ID: <52A401FF.9050506@hardwarefreak.com>
Date: Sat, 07 Dec 2013 23:22:07 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Fwd: Sudden File System Corruption
References: <CAPd9ww_qT9J_Rt04g7+OApoBeggNOyWNwD+57DiDTuUvz-O-0g@mail.gmail.com>	<52A03513.6030408@hardwarefreak.com>	<CAPd9ww9hsOFK6pxqRY-YtLLAkkJHCuSi1BaM4n9=2XTjNVAn2Q@mail.gmail.com>	<CAPd9ww9QzFWUnLtzkdktd+fSX9pdft+wL6cvG2MzLpSdLko1dg@mail.gmail.com>	<52A191BA.20800@hardwarefreak.com>	<CAPd9ww8+W2VX2HAfxEkVN5mL1a_+=HDAStf1126WSE33Vb=VsQ@mail.gmail.com>	<52A302A9.9050509@hardwarefreak.com>
	<CAPd9ww8ovd1rOCQdjUF=U_ji2SOjyBCG-eFjeWSPXr8L5Zg9-A@mail.gmail.com>
In-Reply-To: <CAPd9ww8ovd1rOCQdjUF=U_ji2SOjyBCG-eFjeWSPXr8L5Zg9-A@mail.gmail.com>
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
To: Mike Dacre <mike.dacre@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/7/2013 12:36 PM, Mike Dacre wrote:
> On Sat, Dec 7, 2013 at 3:12 AM, Stan Hoeppner <stan@hardwarefreak.com>wrote:
> 
>> On 12/6/2013 4:14 PM, Mike Dacre wrote:
>>> On Fri, Dec 6, 2013 at 12:58 AM, Stan Hoeppner <stan@hardwarefreak.com
>>> wrote:
>> ...
>>> UUID=a58bf1db-0d64-4a2d-8e03-aad78dbebcbe /science                xfs
>>> defaults,inode64          1 0
>>
>> Your RAID card has persistent write cache (BBWC) and we know it's
>> enabled from tool your output.  By default XFS assumes BBWC is not
>> present, and uses write barriers to ensure order/consistency.   Using
>> barriers on top of BBWC will be detrimental to write performance, for a
>> couple of reasons:
>>
>> 1.  Prevents the controller from optimizing writeback patterns
>> 2.  A portion, or all of, the write cache is frequently flushed
>>
>> Add 'nobarrier' to your mount options to avoid this problem.  It should
>> speed up many, if not all, write operations considerably, which will in
>> turn decrease seek contention amongst jobs.  Currently your write cache
>> isn't working nearly as well as it should, and in fact could be
>> operating horribly.
>>
>>> On the slave nodes, I managed to reduce the demand on the disks by adding
>>> the actimeo=60 mount option.  Prior to doing this I would sometimes see
>> the
>>> disk being negatively affected by enormous numbers of getattr requests.
>>>  Here is the fstab mount on the nodes:
>>>
>>> 192.168.2.1:/science                      /science                nfs
>>> defaults,vers=3,nofail,actimeo=60,bg,hard,intr,rw  0 0
>>
>> One minute attribute cache lifetime seems maybe a little high for a
>> compute cluster.  But if you've had no ill effects and it squelched the
>> getattr flood this is good.
>>
>> ...
>>> Correct, I am not consciously aligning the XFS to the RAID geometry, I
>>> actually didn't know that was possible.
>>
>> XFS alignment is not something to worry about in this case.
>>
>> ...
>>>> So it's a small compute cluster using NFS over Infiniband for shared
>>>> file access to a low performance RAID6 array.  The IO resource sharing
>>>> is automatic.  But AFAIK there's no easy way to enforce IO quotas on
>>>> users or processes, if at all.  You may simply not have sufficient IO to
>>>> go around.  Let's ponder that.
>>>
>>> I have tried a few things to improve IO allocation.  BetterLinux have a
>>> cgroup control suite that allow on-the-fly user-level IO adjustments,
>>> however I found them to be quite cumbersome.
>>
>> This isn't going to work well because a tiny IO stream can seek the
>> disks to death, such as a complex find command, ls -R, etc.  A single
>> command such as these can generate thousands of seeks.  Shaping/limiting
>> user IO won't affect this.
>>
>> ...
>>>> Looking at the math, you currently have approximately 14*150=2100
>>>> seeks/sec capability with 14x 7.2k RPM data spindles.  That's less than
>>>> 100 seeks/sec per compute node, i.e. each node is getting about 2/3rd of
>>>> the performance of a single SATA disk from this array.  This simply
>>>> isn't sufficient for servicing a 23 node cluster, unless all workloads
>>>> are compute bound, and none IO/seek bound.  Given the overload/crash
>>>> that brought you to our attention, I'd say some of your workloads are
>>>> obviously IO/seek bound.  I'd say you probably need more/faster disks.
>>>> Or you need to identify which jobs are IO/seek heavy and schedule them
>>>> so they're not running concurrently.
>>>
>>> Yes, this is a problem.  We sadly lack the resources to do much better
>> than
>>> this, we have recently been adding extra storage by just chaining
>> together
>>> USB3 drives with RAID and LVM... which is cumbersome and slow, but
>> cheaper.
>>
>> USB disk is generally a recipe for disaster.  Plenty of horror stories
>> on both this list and linux-raid regarding USB connected drives,
>> enclosures, etc.  I pray you don't run into those problems.
>>
>>> My current solution is to be on the alert for high IO jobs, and to move
>>> them to a specific torque queue that limits the number of concurrent
>> jobs.
>>>  This works, but I have not found a way to do it automatically.
>>>  Thankfully, with a 12 member lab, it is actually not terribly complex to
>>> handle, but I would definitely prefer a more comprehensive solution.  I
>>> don't doubt that the huge IO and seek demands we put on these disks will
>>> cause more problems in the future.
>>
>> Your LSI 9260 controller supports using SSDs for read/write flash cache.
>>  LSI charges $279 for it.  It's called CacheCade Pro:
>>
>>
>> http://www.lsi.com/products/raid-controllers/pages/megaraid-cachecade-pro-software.aspx
>> .
>>
>>
>> Connect two good quality fast SSDs to the controller, such as:
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16820147192
>>
>> Two SSDs, mirrored, to prevent cached writes from being lost if a single
>> SSD fails.  You now have a ~90K IOPS, 128GB, 500MB/s low latency
>> read/write cache in front of your RAID6 array.  This should go a long
>> way toward eliminating your bottlenecks.  You can accomplish this for
>> ~$550 assuming you have two backplane drive slots free for the SSDs.  If
>> not, you add one of these for $279:
>>
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16816117207
>>
>> This is an Intel 24 port SAS expander, the same device as in your drive
>> backplane.  SAS expanders can be daisy chained many deep.  You can drop
>> it into a PCIe x4 or greater slot from which it only draws power--no
>> data pins are connected.  Or if no slots are available you can mount it
>> to the side wall of your rack server chassis and power it via the 4 pin
>> Molex plug.  This requires a drill, brass or plastic standoffs, and DIY
>> skills.  I use this option as it provides a solid mount for un/plugging
>> the SAS cables, and being side mounted neither it nor the cables
>> interfere with airflow.
>>
>> You'll plug the 9260-4i into one port of the Intel expander.  You'll
>> need another SFF-8087 cable for this:
>>
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16812652015
>>
>> You will plug your drive backplane cable into another of the 6 SFF-8087
>> ports on the Intel.  Into a 3rd port you will plug an SFF-8087 breakout
>> cable to give you 4 individual drive connections.  You will plug two of
>> these into your two SSDs.
>>
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16816116097
>>
>> If you have no internal 2.5/3.5" drive brackets free for the SSDs and
>> you'd prefer not to drill (more) holes in the chassis to directly mount
>> them or a new cage for them, simply use some heavy duty Velcro squares,
>> 2" is fine.
>>
>> Worst case scenario you're looking at less than $1000 to cure your IO
>> bottlenecks, or at the very least mitigate them to a minor annoyance
>> instead of a show stopper.  And if you free up some money for some
>> external JBODs and drives in the future, you can route 2 of the unused
>> SFF-8087 connectors of the Intel Expander out the back panel to attach
>> expander JBOD enclosures, using one of these and 2 more of the 8087
>> cables up above:
>>
>>
>> http://www.ebay.com/itm/8-Port-SAS-SATA-6G-Dual-SFF-8088-mini-SAS-to-SFF-8087-PCIe-Adapter-w-LP-Bracket-/390508767029
>>
>> I'm sure someone makes a 3 port model but 10 minutes of searching didn't
>> turn one up.  These panel adapters are application specific.  Most are
>> made to be mounted in a disk enclosure where the HBA/RAID card is on the
>> outside of the chassis, on the other end of the 8088 cable.  This two
>> port model is designed to be inside a server chassis, where the HBA
>> connects to the internal 8087 ports.  Think Ethernet x-over cable.
>>
>> The 9260-4i supports up to 128 drives.  This Intel expander and a panel
>> connector allow you to get there with external JBODs.  The only caveat
>> being that you're limited to "only" 4.8 GB/s to/from all the disks.
>>
>> --
>> Stan
>>
> 
> Hi Stan,
> 
> Thanks for the great advice, I think you are on to something there.  I will

You're welcome.  Full disclosure:  I should have mentioned that I
haven't used CacheCade yet myself.  My statements WRT performance are
based on available literature and understanding of the technology.

That said, considering the 9260-4i is $439 MSRP and the key to unlock
the CacheCade feature in the firmware is $279, well more than half the
price of the RAID card, LSI obviously feels there is serious performance
value in this feature.  If there wasn't the price of CacheCade would be
much lower.

> look into doing this in the next week or so when I have more time.  I added
> 'nobarrier' to my mount options.

Just be sure to remount the filesystem so this option becomes active.
Apologies for stating the obvious, but many people forget this step.

> Thanks again, I will let you know how it goes after I have upgraded.

I'd evaluate the impact of the noop elevator and nobarrier before
spending on SSD caching.  It may turn out you don't need it, yet.  But
yes, either way, it would be great to be kept abreast of your progress.
 If you do implement CacheCade I'm sure a wider audience would be
interested in reading of your experience with it.  There are probably
more than a few users on this list who have LSI gear.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
