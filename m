Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5QLQvuf002040
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 16:26:57 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1454C2F7E5
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 14:26:55 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id VkxNRCxce7rk2Pdt
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 14:26:55 -0700 (PDT)
Message-ID: <4E07A41C.1000102@hardwarefreak.com>
Date: Sun, 26 Jun 2011 16:26:52 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: mkfs.xfs error creating large agcount an raid
References: <4E063BC6.9000801@task.com.br> <4E0694CC.8050003@hardwarefreak.com>
	<4E06C967.2060107@task.com.br>
In-Reply-To: <4E06C967.2060107@task.com.br>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Marcus Pereira <marcus@task.com.br>
Cc: linux-xfs@oss.sgi.com

On 6/26/2011 12:53 AM, Marcus Pereira wrote:
> Em 25-06-2011 23:09, Stan Hoeppner escreveu:
>> On 6/25/2011 2:49 PM, Marcus Pereira wrote:
>>> I have an issue when creating xfs volume using large agcounts on raid
>>> volumes.
>> Yes, you do have an issue, but not the one you think.
> Ok, but seems something that should be corrected. Isn't that?

No.  The error you received had nothing directly to do with the insane
AG count.  You received the error because with that specific AG count
you end up with the alignment issue that was stated in the error message
itself.

>>> /dev/md0 is a 4 disks raid 0 array:
>>>
>>> ----------------------------------------
>>> # mkfs.xfs -V
>>> mkfs.xfs version 3.1.4
>>>
>>> # mkfs.xfs -d agcount=1872 -b size=4096 /dev/md0 -f
>> mkfs.xfs queries mdraid for its parameters and creates close to the
>> optimal number of AGs, sets the stripe width, etc, all automatically.
>> The default number of AGs for striped mdraid devices is 16 IIRC, and
>> even that is probably a tad too high for a 4 spindle stripe.  Four or
>> eight AGs would probably be better here, depending on your workload,
>> which you did not state.  Please state your target workload.

> The system is a heavy loaded email server.

Maildir is much more metadata intensive than mbox, generating many more
small IOs, and thus head movement.  With a large number of allocation
groups this will exacerbate the head seeking problem.

>> At 1872 you have 117 times the number of default AGs.  The two main
>> downsides to doing this are:

> The default agcount was 32 at this system.

That seems high.  IIRC the default for mdraid stripes is 16 AGs.  Maybe
the default is higher for RAID0 (which I never use).

>> 1. Abysmal performance due to excessive head seeking on an epic scale
>> 2. Premature drive failure due to head actuator failure
> There is already insane head seeking at this server, hundreds of
> simultaneous users reading their mailboxes. In fact I was trying to
> reduce the head seeking with larger agcounts.
> 
>> Now, the above assumes your "4 disks" are mechanical drives.  If these
>> are actually SSDs then the hardware won't suffer failures, but
>> performance will likely be far less than optimal.

> The 4 disks are mechanical, in fact each of them are 2 SCSI HD raid 1
> hardware raid 0 array but the OS sees it as a single device.
> So its a raid 10 with hardware raid 1 and software raid 0.

Please always provide this level of detail up front.  Until now you had
us believing this was a straight RAID0 stripe for storing mail.

>> Why are you attempting to create an insane number of allocation groups?
>>   What benefit do you expect to gain from doing so?
>>
>> Regardless of your answer, the correct answer is that such high AG
>> counts only have downsides, and zero upside.

> It is still a test to find an optimal agcount, there are several of this
> servers and each of them would be with a different agcount. I was trying
> to build an even larger agcount something like 20000 to 30000. :-)

You have no idea what you are doing.  You have no understanding of XFS
allocation groups.  See 'man 5 xfs' and search this list's archives for
threads discussing agcount.

> The goal is to try to keep less or even 1 mailboxes per AG so more
> sequential reading at each mailbox access and less random seek at the
> volume. 

The logic behind your goal is flawed.  Each AG contains its own metadata
section which contains btrees for inodes and freespace.  When new mail
is written into a user maildir the btrees for that AG are read from
disk, unless cached.  With the numbers of AGs you're talking about,
you're increasing your head seeks for metadata reads by several orders
of magnitude as you now have 1872 metadata sections to read/write
instead of something sane like 16.

> I dont know if it was going to work like I was thinking.

It won't.

> I got this idea at this post and was giving it a try:
> http://www.techforce.com.br/news/linux_blog/lvm_raid_xfs_ext3_tuning_for_small_files_parallel_i_o_on_debian

Did you happen to notice that configuration has an IBM DS8300 SAN head
with tons of BBWC and *512* fiber channel disks?  You have 8 disks.

You are attempting to duplicate a filesystem configuration, that may
work well on that specific high end platform, but is never going to work
on your 8 disk machine.  As is stated in that article, they tuned and
re-tuned that system over a very long period of time before arriving
where they are.  They have tuned XFS to that specific machine/storage
environment.

Those lessons are not directly applicable to your system.  In fact
they're not applicable at all.

Stick with a sane agcount of 8 or 16.  Also, for a maildir server with
XFS you'd be better off concatenating those 4 RAID1 pairs instead of
striping them, due to the fact that mail files are so small, typically
4-16KB, which can cause many partial width stripes, decreasing overall
performance.

Using concatenation (mdadm --linear) you can take more advantage of
allocation group parallelism and achieve better overall throughput vs
the md RAID0 over hardware RAID1 setup.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
