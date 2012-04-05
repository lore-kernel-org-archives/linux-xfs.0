Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q35MWSmJ081265 for <xfs@oss.sgi.com>; Thu, 5 Apr 2012 17:32:29 -0500
Received: from a.mx.filmlight.ltd.uk (a.mx.filmlight.ltd.uk [77.107.81.250])
	by cuda.sgi.com with SMTP id ADmduflo90qO7sNR for
	<xfs@oss.sgi.com>; Thu, 05 Apr 2012 15:32:26 -0700 (PDT)
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
Mime-Version: 1.0 (Apple Message framework v1084)
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
Date: Thu, 5 Apr 2012 23:32:20 +0100
Message-Id: <8544B101-3848-428A-BB7E-C91CE897163B@filmlight.ltd.uk>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: xfs@oss.sgi.com

http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide/tmp/en-US/html/ch06s10.html


On 5 Apr 2012, at 19:10, Stefan Ring wrote:

> Encouraged by reading about the recent improvements to XFS, I decided
> to give it another try on a new server machine. I am happy to report
> that compared to my previous tests a few years ago, performance has
> progressed from unusably slow to barely acceptable, but still lagging
> behind ext4, which is a noticeable (and notable) improvement indeed
> ;).
> 
> The filesystem operations I care about the most are the likes which
> involve thousands of small files across lots of directories, like
> large trees of source code. For my test, I created a tarball of a
> finished IcedTea6 build, about 2.5 GB in size. It contains roughly
> 200,000 files in 20,000 directories. The test I want to report about
> here was extracting this tarball onto an XFS filesystem. I tested
> other actions as well, but they didn't reveal anything too noticeable.
> 
> So the test consists of nothing but un-tarring the archive, followed
> by a "sync" to make sure that the time-to-disk is measured. Prior to
> running it, I had populated the filesystem in the following way:
> 
> I created two directory hierarchies, each containing the unpacked
> tarball 20 times, which I rsynced simultaneously to the target
> filesystem. When this was done, I deleted one half of them, creating
> some free space fragmentation, and what I hoped would mimic real-world
> conditions to some degree.
> 
> So now to the test itself -- the tar "x" command returned quite fast
> (on the order of only a few seconds), but the following sync took
> ages. I created a diagram using seekwatcher, and it reveals that the
> disk head jumps about wildly between four zones which are written to
> in almost perfectly linear fashion.
> 
> When I reran the test with only a single allocation group, behavior
> was much better (about twice as fast).
> 
> OTOH, when I continuously extracted the same tarball in a loop without
> syncing in-between, it would continuously slow down in the ag=1 case
> to the point of being unacceptably slow. The same behavior did not
> occur with ag=4.
> 
> I am aware that no filesystem can be optimal, but given that the
> entire write set -- all 2.5 GB of it -- is "known" to the file system,
> that is, in memory, wouldn't it be possible to write it out to disk in
> a somewhat more reasonable fashion?
> 
> This is the seekwatcher graph:
> http://dl.dropbox.com/u/5338701/dev/xfs/xfs-ag4.png
> 
> And for comparison, the same on ext4, on the same partition primed in
> the same way (parallel rsyncs mentioned above):
> http://dl.dropbox.com/u/5338701/dev/xfs/ext4.png
> 
> As can be seen from the time scale in the bottom part, the ext4
> version performed about 5 times as fast because of a much more
> disk-friendly write pattern.
> 
> I ran the tests with a current RHEL 6.2 kernel and also with a 3.3rc2
> kernel. Both of them exhibited the same behavior. The disk hardware
> used was a SmartArray p400 controller with 6x 10k rpm 300GB SAS disks
> in RAID 6. The server has plenty of RAM (64 GB).
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
