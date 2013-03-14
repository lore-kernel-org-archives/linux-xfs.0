Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 55FFF7F3F
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 07:26:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DE164AC004
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 05:26:33 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id Cizz71shppqzFBJs
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 05:26:32 -0700 (PDT)
Message-ID: <5141C1FC.4060209@hardwarefreak.com>
Date: Thu, 14 Mar 2013 07:26:36 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_fsr, sunit, and swidth
References: <5140C147.7070205@binghamton.edu>
	<514113C6.9090602@hardwarefreak.com>
	<514153ED.3000405@binghamton.edu>
In-Reply-To: <514153ED.3000405@binghamton.edu>
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
To: Dave Hall <kdhall@binghamton.edu>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 3/13/2013 11:37 PM, Dave Hall wrote:
> Stan,
> 
> If you'd rather I can re-post this to xfs@oss.sgi.com, but I'm not clear
> on exactly where this address leads.  I am grateful for your response.

No need, I'm CC'ing the list address.  Read this entirely before hitting
reply.

> So the details are that this is a 16 x 2GB 7200 rpm SATA drive array in
> a RAID enclosure.   The array is configured RAID6 (so 14 data spindles)
> with a chunk size of 128k.  The XFS formatted size is 26TB with 19TB
> currently used.

So your RAID6 stripe width is 14 * 128KB = 1,792KB.

> The workload is a backup program called rsnapshot.  If you're not
> familiar, this program uses cp -al top create a linked copy of the
> previous backup, and then rsync -av --del to copy in any changes. The
> current snapshots contain about 14.8 million files.  The total number of
> snapshots is about 600.

So you've got a metadata heavy workload with lots of links being created.

> The performance problem that lead me to investigate XFS is that some
> time around mid-November the cp -al step started running very long -
> sometimes over 48 hours.  Sometimes it runs in just a few hours. Prior
> to then the entire backup consistenly finished in less than 12 hours. 
> When the cp -al is running long the output of dstat indicates that the
> I/O to the fs is fairly light.

The 'cp -al' command is a pure metadata workload, which means lots of
writes to the filesystem directory trees, but not into files.  And if
your kernel is lower than 2.6.39 your log throughput would be pretty
high as well.  But given this is RAID6 you'll have significant RMW for
these directory writes, maybe overwhelming RMW, driving latency up and
thus actual bandwidth down.  So dstat bytes throughput may be low, but
%wa may be through the roof, making the dstat data you're watching
completely misleading as to what's really going on, what's causing the
problem.

> Please let me know if you need any further information.  

Yes,  please provide the output of the following commands:

~$ grep xfs /etc/fstab
~$ xfs_info /dev/[mount-point]
~$ df /dev/[mount_point]
~$ df -i /dev/[mount_point]
~$ xfs_db -r -c freesp /dev/[mount-point]

Also please provide the make/model of the RAID controller, the write
cache size and if it is indeed enabled and working, as well as any
errors, if any, logged by the controller in dmesg or elsewhere in Linux,
or in the controller firmware.

> Also, again, I
> can post this to xfs@oss.sgi.com but I'd really like to know more about
> the address.

Makes me where you obtained the list address.  Apparently not from the
official websites or you'd not have to ask.  Maybe this will assuage
your fears. ;)

xfs@oss.sgi.com is the official XFS mailing list submission address for
the XFS developers and users.  oss.sgi.com is the server provided and
managed by SGI (www.sgi.com) that houses the XFS open source project.
SGI created the XFS filesystem first released on their proprietary
IRIX/MIPS computers in 1994.  SGI open sourced XFS and ported it to
Linux in the early 2000s.

XFS is actively developed by a fairly large group of people, and AFAIK
most of them are currently employed by Red Hat, including Dave Chinner,
who also replied to your post.  Dave wrote the delaylog code which will
probably go a long way toward fixing your problem, if you're currently
using 2.6.38 or lower and not mounting with this option enabled.  It
didn't become the default until 2.6.39.

More info here http://www.xfs.org and here http://oss.sgi.com/projects/xfs/

> Thanks.

You bet.

-- 
Stan


> -Dave
> 
> 
> On 3/13/2013 8:03 PM, Stan Hoeppner wrote:
>> On 3/13/2013 1:11 PM, Dave Hall wrote:
>>
>>> Does xfs_fsr react in any way to the sunit and swidth attributes of the
>>> file system?
>> No, manually remounting with new stripe alignment and then running
>> xfs_fsr is not going to magically reorganize your filesystem.
>>
>>> In other words, with an XFS filesytem set up directly on a
>>> hardware RAID, it is recommended that the mount command be changed to
>>> specify sunit and swidth values that reflect the new geometry of the
>>> RAID.
>> This recommendation (as well as most things storage related) is workload
>> dependent.  A common misconception many people have is that XFS simply
>> needs to be aligned to the RAID stripe.  In reality, it's more critical
>> that XFS write out be aligned to the application's write pattern, and
>> thus, the hardware RAID stripe needs to be as well.  Another common
>> misconception is that simply aligning XFS to the RAID stripe will
>> automagically yield fully filled hardware stripes.  This is entirely
>> dependent on matching the hardware RAID stripe to the applications write
>> pattern.
>>
>>> In my case, these values were not specified on the mkfs.xfs of a
>>> rather large file system running on a RAID 6 array.  I am wondering
>>> adding sunit and swidth parameters to the fstab will cause xfs_fsr to do
>>> anything different than it is already doing.
>> No, see above.  And read this carefully:  Aligning XFS affects write out
>> only during allocation.  It does not affect xfs_fsr.  Nor does it affect
>> non allocation workloads, i.e. database inserts, writing new mail to
>> mbox files, etc.
>>
>>> Most importantly, will it
>>> improve performace in any way?
>> You provided insufficient information for us to help you optimize
>> performance.  For us to even take a stab at answering this we need to
>> know at least:
>>
>> 1.  application/workload write pattern(s)  Is it allocation heavy?
>>          a.  small random IO
>>          b.  large streaming
>>          c.  If mixed, what is the ratio
>>
>> 2.  current hardware RAID parameters
>>          a.  strip/chunk size
>>          b.  # of effective spindles (RAID6 minus 2)
>>
>> 3.  Current percentage of filesystem bytes and inodes used
>>          a.  ~$ df /dev/[mount_point]
>>          b.  ~$ df -i /dev/[mount_point]
>>
>> FWIW, parity RAID is abysmal with random writes, and especially so if
>> the hardware stripe width is larger than the workload's write IOs.
>> Thus, optimizing performance with hardware RAID and filesystems must be
>> done during the design phase of the storage.  For instance if you have a
>> RAID6 chunk/strip size of 512K and 8 spindles that's a 4MB stripe width.
>>   If your application is doing random allocation write out in 256K
>> chunks, you simply can't optimize performance without blowing away the
>> array and recreating.  For this example you'd need a chunk/strip of 32K
>> with 8 effective spindles which equals 256K.
>>
>> Now, there is a possible silver lining here.  If your workload is doing
>> mostly large streaming writes, allocation or not, that are many
>> multiples of your current hardware RAID stripe, it doesn't matter if
>> your XFS is doing default 4K writes or if it has been aligned to the
>> RAID stripe.  In this case the controller's BBWC is typically going to
>> take the successive XFS 4K IOs and fill hardware stripes automatically.
>>
>> So again, as always, the answer depends on your workload.
>>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
