Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5Q5rmDr183834
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 00:53:48 -0500
Received: from smtp1.task.com.br (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E0661B195E2
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 22:53:45 -0700 (PDT)
Received: from smtp1.task.com.br (smtp1.task.com.br [174.37.54.130]) by
	cuda.sgi.com with ESMTP id vtyHnZnIjrxRYtZh for
	<linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 22:53:45 -0700 (PDT)
Message-ID: <4E06C967.2060107@task.com.br>
Date: Sun, 26 Jun 2011 02:53:43 -0300
From: Marcus Pereira <marcus@task.com.br>
MIME-Version: 1.0
Subject: Re: mkfs.xfs error creating large agcount an raid
References: <4E063BC6.9000801@task.com.br> <4E0694CC.8050003@hardwarefreak.com>
In-Reply-To: <4E0694CC.8050003@hardwarefreak.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Em 25-06-2011 23:09, Stan Hoeppner escreveu:
> On 6/25/2011 2:49 PM, Marcus Pereira wrote:
>> I have an issue when creating xfs volume using large agcounts on raid
>> volumes.
> Yes, you do have an issue, but not the one you think.
Ok, but seems something that should be corrected. Isn't that?

>> /dev/md0 is a 4 disks raid 0 array:
>>
>> ----------------------------------------
>> # mkfs.xfs -V
>> mkfs.xfs version 3.1.4
>>
>> # mkfs.xfs -d agcount=1872 -b size=4096 /dev/md0 -f
> mkfs.xfs queries mdraid for its parameters and creates close to the
> optimal number of AGs, sets the stripe width, etc, all automatically.
> The default number of AGs for striped mdraid devices is 16 IIRC, and
> even that is probably a tad too high for a 4 spindle stripe.  Four or
> eight AGs would probably be better here, depending on your workload,
> which you did not state.  Please state your target workload.
The system is a heavy loaded email server.
> At 1872 you have 117 times the number of default AGs.  The two main
> downsides to doing this are:
The default agcount was 32 at this system.
> 1. Abysmal performance due to excessive head seeking on an epic scale
> 2. Premature drive failure due to head actuator failure
There is already insane head seeking at this server, hundreds of 
simultaneous users reading their mailboxes. In fact I was trying to 
reduce the head seeking with larger agcounts.

> Now, the above assumes your "4 disks" are mechanical drives.  If these
> are actually SSDs then the hardware won't suffer failures, but
> performance will likely be far less than optimal.
The 4 disks are mechanical, in fact each of them are 2 SCSI HD raid 1 
hardware raid 0 array but the OS sees it as a single device.
So its a raid 10 with hardware raid 1 and software raid 0.

> Why are you attempting to create an insane number of allocation groups?
>   What benefit do you expect to gain from doing so?
>
> Regardless of your answer, the correct answer is that such high AG
> counts only have downsides, and zero upside.
It is still a test to find an optimal agcount, there are several of this 
servers and each of them would be with a different agcount. I was trying 
to build an even larger agcount something like 20000 to 30000. :-)
The goal is to try to keep less or even 1 mailboxes per AG so more 
sequential reading at each mailbox access and less random seek at the 
volume. I dont know if it was going to work like I was thinking.
I got this idea at this post and was giving it a try: 
http://www.techforce.com.br/news/linux_blog/lvm_raid_xfs_ext3_tuning_for_small_files_parallel_i_o_on_debian

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
