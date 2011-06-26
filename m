Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5R0066V010065
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 19:00:07 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B85752FA31
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 17:00:03 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	WtvxyLTEhaBcq3Xx for <linux-xfs@oss.sgi.com>;
	Sun, 26 Jun 2011 17:00:03 -0700 (PDT)
Date: Mon, 27 Jun 2011 09:59:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs error creating large agcount an raid
Message-ID: <20110626235959.GC32466@dastard>
References: <4E063BC6.9000801@task.com.br> <4E0694CC.8050003@hardwarefreak.com>
	<4E06C967.2060107@task.com.br>
MIME-Version: 1.0
Content-Disposition: inline
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

On Sun, Jun 26, 2011 at 02:53:43AM -0300, Marcus Pereira wrote:
> Em 25-06-2011 23:09, Stan Hoeppner escreveu:
> >On 6/25/2011 2:49 PM, Marcus Pereira wrote:
> >>I have an issue when creating xfs volume using large agcounts on raid
> >>volumes.
> >Yes, you do have an issue, but not the one you think.
> Ok, but seems something that should be corrected. Isn't that?
> 
> >>/dev/md0 is a 4 disks raid 0 array:
> >>
> >>----------------------------------------
> >># mkfs.xfs -V
> >>mkfs.xfs version 3.1.4
> >>
> >># mkfs.xfs -d agcount=1872 -b size=4096 /dev/md0 -f
> >mkfs.xfs queries mdraid for its parameters and creates close to the
> >optimal number of AGs, sets the stripe width, etc, all automatically.
> >The default number of AGs for striped mdraid devices is 16 IIRC, and
> >even that is probably a tad too high for a 4 spindle stripe.  Four or
> >eight AGs would probably be better here, depending on your workload,
> >which you did not state.  Please state your target workload.
> The system is a heavy loaded email server.
> >At 1872 you have 117 times the number of default AGs.  The two main
> >downsides to doing this are:
> The default agcount was 32 at this system.
> >1. Abysmal performance due to excessive head seeking on an epic scale
> >2. Premature drive failure due to head actuator failure
> There is already insane head seeking at this server, hundreds of
> simultaneous users reading their mailboxes.

Perhaps you should just usethe defaults first and only consider
changes if there is an obvious problem,?

> In fact I was trying to
> reduce the head seeking with larger agcounts.

AGs are not for reducing seeking - they are for increasing
allocation parallelism and scaling freespace indexes to extremely
large filesystem sizes.

In fact, trying to use more than a few hundred AGs will hit internal
AG indexing scalability limitations, especially as you start to fill
up AGs and have to scan for AGs with free space in them.

IOWs, using large numbers of AGs are inadvisable for many reasons.

> >are actually SSDs then the hardware won't suffer failures, but
> >performance will likely be far less than optimal.
> The 4 disks are mechanical, in fact each of them are 2 SCSI HD raid
> 1 hardware raid 0 array but the OS sees it as a single device.
> So its a raid 10 with hardware raid 1 and software raid 0.
> 
> >Why are you attempting to create an insane number of allocation groups?
> >  What benefit do you expect to gain from doing so?
> >
> >Regardless of your answer, the correct answer is that such high AG
> >counts only have downsides, and zero upside.
> It is still a test to find an optimal agcount, there are several of
> this servers and each of them would be with a different agcount. I
> was trying to build an even larger agcount something like 20000 to
> 30000. :-)

IOWs, you truly do not understand how AGs are used to scale
filesystem performance and therefore you should be using the
defaults.

> The goal is to try to keep less or even 1 mailboxes per AG so more
> sequential reading at each mailbox access and less random seek at
> the volume.

You have no direct control over the placement of directories and
files in AGs, so it doesn't matter how many AGs you create, you
aren't going to be able to achieve this....

> I dont know if it was going to work like I was thinking.
> I got this idea at this post and was giving it a try:
> http://www.techforce.com.br/news/linux_blog/lvm_raid_xfs_ext3_tuning_for_small_files_parallel_i_o_on_debian

<sigh>

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

Cheers,

Dave.
> 
> -- 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
