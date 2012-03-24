Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2O1RQjT078127 for <xfs@OSS.SGI.com>; Fri, 23 Mar 2012 20:27:27 -0500
Received: from anakin.london.02.net (anakin.london.02.net [87.194.255.134]) by
	cuda.sgi.com with ESMTP id GvCfSR1ZCRkKr649 for
	<xfs@OSS.SGI.com>; Fri, 23 Mar 2012 18:27:24 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by anakin.london.02.net (8.5.140)
	id 4EEB63D201BCD28B for xfs@OSS.SGI.com;
	Sat, 24 Mar 2012 01:27:21 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1SBFlC-0001kI-7X
	for <xfs@OSS.SGI.com>; Sat, 24 Mar 2012 01:27:14 +0000
MIME-Version: 1.0
Message-ID: <20333.8944.573177.821944@tree.ty.sabi.co.UK>
Date: Sat, 24 Mar 2012 01:27:12 +0000
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
In-Reply-To: <201203232348.09158.Martin@lichtvoll.de>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F6624A3.5010206@hardwarefreak.com>
	<20331.39194.377610.888636@tree.ty.sabi.co.UK>
	<201203232348.09158.Martin@lichtvoll.de>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@oss.sgi.com>

>> Overselling 'delaylog' with cheeky propaganda glossing over
>> the heavy tradeoffs involved is understandable, but quite
>> wrong.

> [ ... ] there has been quite some other metadata related
> performance improvements. Thus IMHO reducing the recent
> improvements in metadata performance is underselling XFS and
> overselling delaylog. [ ... ]

That's a good way of putting it, and I am pleased that I finally
get a reasonable comment on this story, and one that agrees with
one of my previous points in this thread:

http://www.spinics.net/lists/raid/msg37931.html
 =ABNote: the work on multithreading the journaling path is an
    authentic (and I guess amazingly tricky) performance
    improvement instead, not merely a new safety/latency/speed
    tradeoff similar to 'nobarrier' or 'eatmydata'.=BB

There are two reasons why I rate the multithreading work as more
important than the 'delaylog' work:

  * It is a *net* improvement, as it increases the potential and
    actual retirement rate of metadata operation without adverse
    impact.

  * It improves XFS in the area where it is strongest, which is
    massive and multithread workloads, on reliable storage
    systems with large IOPS.

Conversely, 'delaylog' does not improve the XFS performance
envelope, it seems a crowd-pleasing yet useful intermediate
tradeoff between 'sync' and 'nobarrier', and the standard
documents about XFS tuning make it clear that XFS is really meant
to run on reliable and massive storage layers with 'nobarrier',
and it is/was not aimed at =ABuntarring kernel tarballs=BB with
'barrier' on.

My suspicion is that 'delaylog' therefore is in large part a
marketing device to match 'ext4' in unsafety and therefore in
apparent speed for "popular" systems, as an argument to stop
investing in 'ext4' and continue to invest in XFS.

Consider DaveC's famous presentation (the one in which he makes
absolutely no mention of the safety/speed tradeoff of 'delaylog'):

http://xfs.org/images/d/d1/Xfs-scalability-lca2012.pdf
 =ABThere's a White Elephant in the Room....
  * With the speed, performance and capability of XFS and the
    maturing of BTRFS, why do we need EXT4 anymore?=BB

That's a pretty big tell :-). I agree with it BTW.

In the same presentation earlier there are also these other
interesting points:

http://xfs.org/images/d/d1/Xfs-scalability-lca2012.pdf
 =AB* Ext4 can be up 20-50x times than XFS when data is also being
    written as well (e.g. untarring kernel tarballs).
  * This is XFS @ 2009-2010.
  * Unless you have seriously fast storage, XFS just won't
    perform well on metadata modification heavy workloads.=BB

It is never mentioned that 'ext4' is 20-50x faster on metadata
modification workloads because it implements much weaker
semantics than =ABXFS @ 2009-2010=BB, and that 'delaylog' matches
'ext4' because it implements similarly weaker semantics, by
reducing the frequency of commits, as the XFS FAQ briefly
summarizes:

http://www.xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_f=
or_.3Csomething.3E
 =ABIncreasing logbsize reduces the number of journal IOs for a
  given workload, and delaylog will reduce them even further.
  The trade off for this increase in metadata performance is
  that more operations may be "missing" after recovery if the
  system crashes while actively making modifications.=BB

As should be obvious by now that I think that is an outrageously
cheeky omission from the =ABfilesystem of the futurex presentation,
an omission that makes =ABXFS @ 2009-2010=BB seem much worse than it
really was/is, making 'delaylog' seem then a more significant
improvement than it is, or as you wrote =ABunderselling XFS and
overselling delaylog=BB.

Note: I wrote =ABimprovement=BB above because 'delaylog' is indeed
  an improvement, but not to the performance of XFS, but to its
  functionality/flexibility: it is significant as an additional
  and useful speed/safety tradeoff, not as a speed improvement.

The last point above =ABUnless you have seriously fast storage=BB
gives away the main story: metadata intensive workloads are
mostly random access workloads, and random access workloads get
out of typical disk drives around 1-2MB/s, which means that if
you play it safe and commit modifications frequently, you need a
storage layer with massive IOPS indeed.

For what I think are essentially marketing reasons, 'ext3' and
'ext4' try to be "popular" filesystem (consider the quote from
Eric Sandeen's blog about the O_PONIES issue), and this has
caused a lot of problems, and 'delaylog' seems to be an attempt
to compete with 'ext4' in "popular" appeal.

It may be good salesmanship for whoever claims the credit for
'delaylog', but advertising a massive speed improvement with
colourful graphs without ever mentioning the massive improvement
in unsafety seems quite cheeky to me, and I guess to you too.

BTW some other interesting quotes from DaveC, the first about the
aim of 'delaylog' to compete with 'ext4' on low end systems:

http://lwn.net/Articles/477278/
 =ABThat's *exactly* the point of my talk - to smash this silly
  stereotype that XFS is only for massive, expensive servers and
  storage arrays. It is simply not true - there are more consumer
  NAS devices running XFS in the world than there are servers
  running XFS. Not to mention DVRs, or the fact that even TVs
  these days run XFS.=BB

Another one instead on the impact of the locking improvements,
where metadata operations now can use many CPUs instead of the
previous limit of one:

http://oss.sgi.com/archives/xfs/2010-08/msg00345.html
 =ABI'm getting a 8core/16thread server being CPU bound with
  multithreaded unlink workloads using delaylog, so it's entirely
  possible that all CPU cores are fully utilised on your machine.=BB
http://lwn.net/Articles/476617/
 =ABI even pointed out in the talk some performance artifacts in
  the distribution plots that were a result of separate threads
  lock-stepping at times on AG resources, and that increasing the
  number of AGs solves the problem (and makes XFS even faster!)
  e.g. at 8 threads, XFS unlink is about 20% faster when I
  increase the number of AGs from 17 to 32 on teh same test rig.

  If you have a workload that has a heavy concurrent metadata
  modification workload, then increasing the number of AGs might
  be a good thing. I tend to use 2x the number of CPU cores as a
  general rule of thumb for such workloads but the best tunings
  are highly depended on the workload so you should start just by
  using the defaults. :)=BB

An interesting quote from an old (1996) design document for XFS
where the metadata locking issue was acknowleged:

http://oss.sgi.com/projects/xfs/papers/xfs_usenix/index.html
 =ABIn order to support the parallelism of such a machine, XFS has
  only one centralized resource: the transaction log. All other
  resources in the file system are made independent either across
  allocation groups or across individual inodes. This allows
  inodes and blocks to be allocated and freed in parallel
  throughout the file system. The transaction log is the most
  contentious resource in XFS.=BB

 =ABAs long as the log can be written fast enough to keep up with
  the transaction load, the fact that it is centralized is not a
  problem. However, under workloads which modify large amount of
  metadata without pausing to do anything else, like a program
  constantly linking and unlinking a file in a directory, the
  metadata update rate will be limited to the speed at which we
  can write the log to disk.=BB

It is remarkable that it is has taken ~15 years before the
implementation needed improving.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
