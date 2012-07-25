Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6PA0kqB070608 for <xfs@oss.sgi.com>; Wed, 25 Jul 2012 05:00:46 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ISUk1i1vrClM35we
	for <xfs@oss.sgi.com>; Wed, 25 Jul 2012 03:00:45 -0700 (PDT)
Message-ID: <500FC3CD.7010809@hardwarefreak.com>
Date: Wed, 25 Jul 2012 05:00:45 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: A little RAID experiment
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<CAAxjCEzEiXv5Kna9zxZ-ePbhNg6nfRinkU=PCuyX3QHesq5qcg@mail.gmail.com>
	<5004875D.1020305@hardwarefreak.com>
	<CAAxjCEw-NJzZmX3Q5CJ+aZ_Q7Yo39pMU=-hiXk0ghTMq7q3PWA@mail.gmail.com>
	<5004C243.6040404@hardwarefreak.com>
	<20120717052621.GB23387@dastard>
	<50061CEA.4070609@hardwarefreak.com>
	<CAAxjCEwgDKLF=RY0aCCNTMsc1oefXWfyHKh+morYB9zVUrnH-A@mail.gmail.com>
	<50066115.7070807@hardwarefreak.com>
	<CAAxjCExFUJOKaD-LMPfZvCrS34V1VHgtrhgvPP0jZ3Hm1YV=6g@mail.gmail.com>
	<50068EC5.5020704@hardwarefreak.com>
	<CAAxjCEy2Yj=XWctNg2gACbFy81aTu70YJ13Ee8G6-E3Tqvvs7g@mail.gmail.com>
	<CAAxjCEzF3nTFoedyKf1o5Nv4yPUJkgvC8nCJcx_2dDx8xqWtWA@mail.gmail.com>
	<50077A34.5070304@hardwarefreak.com>
	<CAAxjCEy=N9ceAA5V6bnrcMc3961gs-Z2NgNyenPJ+gjE2mYUXQ@mail.gmail.com>
In-Reply-To: <CAAxjCEy=N9ceAA5V6bnrcMc3961gs-Z2NgNyenPJ+gjE2mYUXQ@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stefan Ring <stefanrin@gmail.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

Hi Stefan,

On 7/25/2012 4:29 AM, Stefan Ring wrote:
> There appears to be a bit of a tension in this thread, and I have the
> suspicion that it's a case of mismatched presumed expectations. The
> sole purpose of my activity here over the last months was to present
> some findings which I thought would be interesting to XFS developers.
> If I were working on XFS, I would be interested. From most of the
> answers, though, I get the impression that I am perceived as looking
> for help tuning my XFS setup, which is not the case at all. In fact,
> I'm quite happy with it. Let me recap just to give this thread the
> intended tone:

I don't want to top post, but I don't want to trim a bunch lest it
appear I'm ignoring significant points you make, so I'll start here, and
flow, but maybe not respond to each point.

I didn't intend to create tension, and I apologize for any sarcasm in my
last point.  I think you may be on to something, and I do find your
research efforts worthwhile.  However...

The single point I was attempting to make in my last post was that for
your data and conclusions to have any validity, you need to provide all
of the details of your testing environment.  You made head-to-head
comparisons and performance conclusions of 3 RAID systems, but omitted
critical details that are needed to interpret and compare the
performance data.  Some of this data you simply didn't have access to.
In a situation like that, you simply shouldn't include that system in
your presentation.  WRT the LSI controller, you didn't mention RAID
level or number of disks.

You simply must present complete information.  The omission of such is
likely why most ignored your post but for me.  I'm the hardwarefreak
after all, so I'm always game for RAID discussions. ;)

If you can represent with complete specs and data, so that it paints a
coherent picture, you may see more willing participation.

> This episode of my journey with XFS started when I read that there had
> been recent significant performance improvements to XFS' metadata
> operations. Having tried XFS every couple of years or so before, and
> always with the same verdict -- horribly slow -- I was curious if it
> had finally become usable.
> 
> A new server machine arriving just at the right time would serve as
> the perfect testbed. I threw some workloads at it, which I hoped would
> resemble my typical workload, and I focussed especially on areas which
> bothered me the most on our current development server running ext3.
> Everything worked more or less satisfactorily, except for the case of
> un-tarring a metadata-heavy tarball in the presence of considerable
> free-space fragmentation.
> 
> In this particular case, performance was conspicuously poor, and after
> some digging with blktrace and seekwatcher, I identified the cause of
> this slowness to be a write pattern that looked like this (in block
> numbers), where the step width (arbitrarily displayed as 10000 here
> for illustration purposes) was 1/4 of the size of the volume, clearly
> because the volume had 4 allocation groups (the default). Of course it
> was not entirely regular, but overall it was very similar to this:
> 
> 10001
> 20001
> 30001
> 40001
> 10002
> 20002
> 30002
> 40002
> 10003
> 20003
> ...
> 
> I tuned and tweaked everything I could think of -- elevator settings,
> readahead, su/sw, barrier, RAID hardware cache --, but the behavior
> would always be the same. It just so happens that the RAID controller
> in this machine (HP SmartArray P400) doesn't cope very well with a
> write pattern like this. To it, the sequence appears to be random, and
> it performs even worse than it would if it were actually random.
> 
> Going by what I think to know about the topic, it struck me as odd
> that blocks would be sent to disk in this very unfavorable order. To
> my mind, three entities had failed at sanitizing the write sequence:
> the filesystem, the block layer and the RAID controller. My opinion is
> still unchanged regarding the latter two.
> 
> The strikingly bad performance on the RAID controller piqued my
> interest, and I went on a different journey investigating this oddity
> and created a minor sysbench modification that would just measure
> performance for this particular pattern. Not many people helped with
> my experiment, and I was accused of wanting ponies. If I'm the only
> one who is curious about this, then so be it. I deemed it worthwile
> sharing my experience and pointing out that a sequence like the one
> above is a death blow to all HP gear I've got my hands on so far.
> 
> It has been pointed out that XFS schedules the writes like this on
> purpose so that they can be done in parallel, and that I should create
> a concatenated volume with physical devices matching the allocation
> groups. I actually went through this exercise, and yes, it was very
> beneficial, but that's not the point. I don't want to (have to) do
> that. And it's not always feasible, anyway. What about home usage with
> a single SATA disk? Is it not worthwile to perform well on low-end
> devices?
> 
> You might ask then, why even bother using XFS instead of ext4?
> 
> I care about the multi-user case. The problem I have with ext is that
> it is unbearably unresponsive when someone writes a semi-large amount
> of data (a few gigs) at once -- like extracting a large-ish tarball.
> Just using vim, even with :set nofsync, is almost impossible during
> that time. I have adopted various disgusting hacks like extracting to
> a ramdisk instead and rsyncing the lot over to the real disk with a
> very low --bwlimit, but I'm thoroughly fed up with this kind of crap,
> and in general, XFS works very well.
> 
> If noone cares about my findings, I will henceforth be quiet on this topic.

Again, it's not that nobody cares.  It's that your findings have no
weight, no merit, in absence of complete storage system and software
stack configuration specs.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
