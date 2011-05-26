Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4Q9vJ50197032 for <xfs@oss.sgi.com>; Thu, 26 May 2011 04:57:19 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04D761D6C6DF
	for <xfs@oss.sgi.com>; Thu, 26 May 2011 02:57:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NyyrAu0q5pvcSJOc for
	<xfs@oss.sgi.com>; Thu, 26 May 2011 02:57:18 -0700 (PDT)
Date: Thu, 26 May 2011 11:57:02 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: automatically running fstrim
In-Reply-To: <20110526091135.GA561@dastard>
Message-ID: <alpine.LFD.2.00.1105261143390.3624@dhcp-27-109.brq.redhat.com>
References: <4DDBE293.8030203@philkarn.net>
	<alpine.LFD.2.00.1105251155120.4667@dhcp-27-109.brq.redhat.com>
	<20110526091135.GA561@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Lukas Czerner <lczerner@redhat.com>, Phil Karn <karn@philkarn.net>, xfs@oss.sgi.com

On Thu, 26 May 2011, Dave Chinner wrote:

> On Wed, May 25, 2011 at 12:06:32PM +0200, Lukas Czerner wrote:
> > On Tue, 24 May 2011, Phil Karn wrote:
> > 
> > > Now that the Linux 2.6.39 kernel is out, is there any reason I shouldn't
> > > run fstrim out of my crontab? It doesn't seem to slow down my system
> > > significantly while it runs.
> > > 
> > > As I understand fstrim, it walks through the file system free list
> > > issuing TRIMs for each entry, and except for whatever load the TRIM
> > > commands themselves generate (which is drive dependent) it shouldn't
> > > interfere that much with system operation. Correct? Is there any
> > > mechanism to issue these commands at a lower priority than regular disk I/O?
> > 
> > No, not that I know of. But why not to run fstrim from cron lets say every
> > day ? Note that you do not necessarily need to run it "all the time",
> > because if the drive firmware has a lot of space for doing
> > wear-leveling, there is no point of sending TRIM.
> > 
> > Also keep in mind that lot of newer SSD's has some "hidden" space just
> > for wear-leveling, so to get to the point where firmware will have hard
> > time doing it and the drive actually get slower takes even more writes
> > than just filling your drive up to max.
> > 
> > So doing fstrim once or twice a day (it really depends on your work
> > load) is more than enough.
> > 
> > Also, since we have all this in place we might talk to distributions to
> > add the infrastructure to actually recognise "discard enabled" devices
> > and add fstrim into cron job automatically.
> 
> History suggests regularly scheduled preventative maintenance like
> this can have unintended consequences that don't show up for some
> time.
> 
> When XFS first got it's online defrag tool (xfs_fsr) back on Irix in
> the late 90s, it was considered a good idea that running it once a
> week to quickly detect and fix fragementation problems before they
> got out of hand.
> 
> That seems like a good idea, but then 6-12 months later people
> started reporting XFS filesystems with really severe fragmentation,
> worse than before xfs_fsr was being run regularly. The majority of
> the files that had been in the filesystem for some time were not
> fragmented, but any new file would be badly fragemented and could
> not be fixed.
> 
> It was then discovered that the act of defragmenting files caused
> the fragementation of free space. That is, for every file with 2
> extents that was defragmented into 1 extent, we now have two
> freespace extents instead of 1. So, the more files you defragment,
> the more free space fragments you create. If you don't delete files
> regularly, then eventually you run out of large free space extents.
> Then you can't defragment files any more, nor can you create
> unfragemented files. 
> 
> So, xfs_fsr was then removed from the system weekly cron job, and
> filesystems that suffered from this went through a dump-mkfs-restore
> process to defragment them. From that time, xfs_fsr has been
> recommended as a "run only when fragmentation is causing perf
> problems" type of tool...
> 
> The moral of this story is that running trim as a preventative
> maintenance tool could have the same sort of unintended long-term
> consequences. That is, it may look like a good idea to run it often
> to keep things clean and neat, but we just don't know what it is
> doing to the underlying device's algorithms and it may take months
> for such problems to show up. e.g. as a device that performance
> cannot be restored to except via a secure erase....

Hi Dave,

Interesting story really, so what you have got from this experience is
"lesson learned". I would not be very optimistic about avoiding this
next logical step, because otherwise we'll never learn the lesson, hence
things might be still wrong but silent enough that noone notice. It is
the same like enabling virtually any feature, unless you do not enable
it by default it get very little testing and you'll never find if there
is anything deeply wrong with it.

But I agree that we have to be careful with enabling something to do its
job periodically. So now (I hope) people will use it, possibly create
their own cron jobs, a if there is any problem, we'll notice. And after
six moths or so, when new Fedora will come out (hypothetically with
mentioned infrastructure) it should be relatively safe. But still, this
is something to discuss.

> 
> > Or, since the filesystem
> > should know the best when is the "right" time to do this, we might try
> > to figure out some kernel logic to trigger it. However it might be a
> > little bit tricky, since every drive behaves differently...
> 
> And that makes it much more likely that it will cause some kind of
> unintended problem.

I agree, that's why I like the first approach better.

> 
> Cheers,
> 
> Dave.

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
