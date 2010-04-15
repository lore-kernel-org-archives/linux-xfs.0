Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3F6xfp4136850 for <xfs@oss.sgi.com>; Thu, 15 Apr 2010 01:59:42 -0500
Received: from mail.netcenter.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FFC32C3F0F
	for <xfs@oss.sgi.com>; Thu, 15 Apr 2010 00:01:18 -0700 (PDT)
Received: from mail.netcenter.hu (ns.netcenter.hu [195.228.254.57]) by
	cuda.sgi.com with ESMTP id 5Ch1lR1DN28lZctd for
	<xfs@oss.sgi.com>; Thu, 15 Apr 2010 00:01:18 -0700 (PDT)
Message-ID: <233401cadc69$64c1f4f0$0400a8c0@dcccs>
From: "Janos Haar" <janos.haar@netcenter.hu>
References: <20100405224522.GZ3335@dastard>
	<3a5f01cad6c5$8a722c00$0400a8c0@dcccs>
	<20100408025822.GL11036@dastard>
	<11b701cad9c8$93212530$0400a8c0@dcccs>
	<20100412001158.GA2493@dastard>
	<18b101cadadf$5edbb660$0400a8c0@dcccs>
	<20100413083931.GW2493@dastard>
	<190201cadaeb$02ec22c0$0400a8c0@dcccs>
	<20100413113445.GZ2493@dastard>
	<1cd501cadb62$3a93e790$0400a8c0@dcccs>
	<20100414001615.GC2493@dastard>
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look
	please!...)
Date: Thu, 15 Apr 2010 09:00:49 +0200
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, xiyou.wangcong@gmail.com, kamezawa.hiroyu@jp.fujitsu.com

Dave,

The corruption + crash reproduced. (unfortunately)

http://download.netcenter.hu/bughunt/20100413/messages-15

Apr 14 01:06:33 alfa kernel: XFS mounting filesystem sdb2

This was the point of the xfs_repair more times.

Regards,
Janos

----- Original Message ----- 
From: "Dave Chinner" <david@fromorbit.com>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <xiyou.wangcong@gmail.com>; <linux-kernel@vger.kernel.org>; 
<kamezawa.hiroyu@jp.fujitsu.com>; <linux-mm@kvack.org>; <xfs@oss.sgi.com>; 
<axboe@kernel.dk>
Sent: Wednesday, April 14, 2010 2:16 AM
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look 
please!...)


> On Wed, Apr 14, 2010 at 01:36:56AM +0200, Janos Haar wrote:
>> ----- Original Message ----- From: "Dave Chinner"
>> >On Tue, Apr 13, 2010 at 11:23:36AM +0200, Janos Haar wrote:
>> >>>If you run:
>> >>>
>> >>>$ xfs_db -r -c "inode 474253940" -c p /dev/sdb2
>> >>>
>> >>>Then I can can confirm whether there is corruption on disk or not.
>> >>>Probably best to sample multiple of the inode numbers from the above
>> >>>list of bad inodes.
>> >>
>> >>Here is the log:
>> >>http://download.netcenter.hu/bughunt/20100413/debug.log
>> >
>> >There are multiple fields in the inode that are corrupted.
>> >I am really surprised that xfs-repair - even an old version - is not
>> >picking up the corruption....
>>
>> I think i know now the reason....
>> My case starting to turn into more and more interesting.
>>
>> (Just a little note for remember: tuesday night, i have run the old
>> 2.8.11 xfs_repair on the partiton wich was reported as corrupt by
>> the kernel, but it was clean.
>> The system was not restarted!)
>>
>> Like you suggested, today, i have tried to make a backup from the data.
>> During the copy, the kernel reported a lot of corrupted entries
>> again, and finally the kernel crashed! (with the 19 patch pack)
>> Unfortunately the kernel can't write the debug info into the syslog.
>> The system restarted automatically, the service runs again, and i
>> can't do another backup attempt because force of the owner.
>> Today night, when the traffic was in the low period, i have stopped
>> the service, umount the partition, and repeat the xfs_repair on the
>> previously reported partition on more ways.
>>
>> Here you can see the results:
>> xfs_repair 2.8.11 run #1:
>> http://download.netcenter.hu/bughunt/20100413/repair2811-nr1.log
>
> So this successfully detected and repaired the corruption.  I don't
> think this is new corruption - the corrupted inode numbers are the
> same as you reported a few days back.
>
>> xfs_repair 2.8.11 run #2:
>> http://download.netcenter.hu/bughunt/20100413/repair2811-nr2.log
>>
>> echo 3 >/proc/sys/vm/drop_caches - performed
>>
>> xfs_repair 2.8.11 run #3:
>> http://download.netcenter.hu/bughunt/20100413/repair2811-nr3.log
>
> These two are clearing lost+found and rediscovering the
> diesconnected inodes that were discovered in the first pass. Nothing
> wrng here, that's just the way older repair versions behaved.
>
>> xfs_reapir 3.1.1 run #1:
>> http://download.netcenter.hu/bughunt/20100413/repair311-nr1.log
>
> And this detected nothing wrong, either.
>
>> For me, it looks like the FS gets corrupted between tuesday night
>> and today night.
>> Note: because i am expecting kernel crashes, the dirty data flush
>> was set for some miliseconds timeout only for prevent too much data
>> lost.
>> It was one kernel crash in this period, but the XFS have journal,
>> and should be cleaned correctly. (i don't think this is the problem)
>>
>> The other interesting thing is, why only this partition gets
>> corrupted? (again, and again?)
>
> Can you reporduce the corruption again now that the filesystem has
> been repaired? I want to know (if the corruption appears again)
> whether it appears in the same location as this one.
>
>> >>I mean, if i am right, the hw memory problem makes only 1-2 bit
>> >>corruption seriously, and the sw page handling problem makes bad
>> >>memory pages, no?
>> >
>> >RAM ECC guarantees correction of single bit errors and detection of
>> >double bit errors (which cause the kernel to panic, IIRC). I can't
>> >tell you what happens when larger errors occur, though...
>>
>> Yes, but this system have non-ECC ram unfortunately.
>
> If your hardware doesn't have ECC, then you can't rule out anything
> - even a dodgy power supply can cause this sort of transient
> problem. I'm not saying that this is the cause, but I've been
> assuming that you're actually running hardware with ECC on RAM,
> caches, buses, etc.
>
>> This makes me think this is sw problem, and not a simple memory
>> corruption, or the corruption can appear only for a short of time in
>> the hw.
>
> If you can take the performance hit, turn on the kernel memory leak
> detector and see if that catches anything.
>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
