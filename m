Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4608F7F3F
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 18:16:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1211F8F8064
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 16:16:46 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	qjJ8drq2FunUG3CI for <xfs@oss.sgi.com>;
	Tue, 12 Aug 2014 16:16:44 -0700 (PDT)
Date: Wed, 13 Aug 2014 09:16:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Subject : Happened again, 20140811 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
Message-ID: <20140812231629.GA20518@dastard>
References: <alpine.LSU.2.11.1408111720170.7326@minas-tirith.valinor>
	<53E93530.4070902@sgi.com>
	<alpine.LSU.2.11.1408112347480.17839@minas-tirith.valinor>
	<53E93C29.1020103@sgi.com>
	<alpine.LSU.2.11.1408120013500.17839@minas-tirith.valinor>
	<alpine.LSU.2.11.1408120139060.21410@minas-tirith.valinor>
	<20140812165143.GB46654@bfoster.bfoster>
	<53EA86DE.5060508@sandeen.net>
	<20140812215943.GA39704@bfoster.bfoster>
	<53EA9386.2040207@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53EA9386.2040207@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, "Carlos E. R." <carlos.e.r@opensuse.org>, XFS mailing list <xfs@oss.sgi.com>

On Tue, Aug 12, 2014 at 03:21:58PM -0700, Eric Sandeen wrote:
> On 8/12/14, 2:59 PM, Brian Foster wrote:
> > On Tue, Aug 12, 2014 at 02:27:58PM -0700, Eric Sandeen wrote:
> >> On 8/12/14, 9:51 AM, Brian Foster wrote:
> >>> On Tue, Aug 12, 2014 at 02:17:00AM +0200, Carlos E. R. wrote:
> >>> Content-ID: <alpine.LSU.2.11.1408120142170.21410@minas-tirith.valinor>
> >>>
> >>>
> >>> El 2014-08-12 a las 00:36 +0200, Carlos E. R. escribi=F3:
> >>>>>> El 2014-08-11 a las 16:56 -0500, Mark Tinguely escribi=F3:
> >>>
> >>>>>> but all of them are about 401M before compression. The upload will=
 take
> >>>>>> long, my ADSL upload is 0.3M/s at most.
> >>>
> >>>
> >>> I have shared (view) on google drive a folder with the three files. B=
oth
> >>> Brian Foster and Mark Tinguely should have got a link on the mail fro=
m me.
> >>> If somebody else wants access, just tell me.
> >>>
> >>>
> >>>> I see the same thing from repair that was in your repair output:
> >>>
> >>>> block (1,12608397-12608397) multiply claimed by cnt space tree, stat=
e - 2
> >>>
> >>>> If I take a look at the btrees as is, I see "235:[12608397,10]" incl=
uded
> >>>> in the bnobt (fsb 0x200aa55) and "270:[12608397,10]" in the cntbt (f=
sb
> >>>> 0x2000781). If I skip the mount, zero the log and repair, everything
> >>>> seems Ok. I can allocate the remainder of available space and rm -rf
> >>>> everything in the fs without an error.
> >>>
> >>>> Once I replay the log, I see "272:[12608397,10] 273:[12608397,10]" in
> >>>> the cntbt, which is clearly a duplicate entry. This is what repair
> >>>> detects and cleans up and seems to lead to the shutdown. E.g., if I
> >>>> mount and use the fs, I can hit an assert or failure just by attempt=
ing
> >>>> to allocate the rest of the space in the fs. If that is the state of=
 the
> >>>> fs on disk, it's only a matter of time we explode due to allocating =
and
> >>>> freeing that range of space or possibly attempting to allocate that
> >>>> space twice.
> >>>
> >>>> Mark mentioned that he didn't see the superblock item in the log with
> >>>> regard to the freeze. I don't see that either... which perhaps sugge=
sts
> >>>> that this all happens during the wake-from-hibernate sequence..? My
> >>>> understanding is that we should freeze on hibernate, thus force
> >>>> everything out to the log, write an unmount record and then dirty the
> >>>> log with a superblock transaction. Therefore, that should be the only
> >>>> item in the log post-freeze. Here, we have various items in the log
> >>>> including several logged buffers that correspond to the cntbt block =
that
> >>>> ends up corrupted (daddr 0xf427c08).
> >>
> >> What freeze?  look at hibernate(), nothing but a sync:
> >>
> >> /**
> >>  * hibernate - Carry out system hibernation, including saving the imag=
e.
> >>  */
> >> int hibernate(void)
> >> {
> >> ...
> >>         printk(KERN_INFO "PM: Syncing filesystems ... ");
> >>         sys_sync();
> >>         printk("done.\n");
> >>
> >>         error =3D freeze_processes();
> >>         if (error)
> >>                 goto Exit;
> >>
> >>
> >> AFAIK there is no freeze call involved.
> >>
> > =

> > Eep, not sure why I was thinking there was a freeze there.
> =

> because it seems so logical.  :)
> =

> > It appears
> > not. I guess that explains why the log contains what it does. Thanks for
> > pointing that out...
> =

> but as I was saying on IRC, I think in theory it's not necessary; the fs =
state
> on disk + fs state in memory (saved to disk during hibernate) needs to be
> consistent, and it's conceivable that this could be done without freeze
> (or even sync for that matter).

Well, the sync is necessary for hibernate - it needs to shrink the
amount of memory that is saved to disk to as small as possible. If
your memory is full of dirty page cache, why would you save that to
the hibernate image, only to have to load it back off, then write it
to the filesystem after resume? Why wouldn't you write it straight
to disk before hibernation, then remove it from memory so you've
then got free memory to allocate the hibernation image that gets
written to disk?

> A freeze sure sounds nice though, to be sure the fs really is consistent
> on disk, in case resume fails.
> =

> The thing I was wondering about is what makes sure disk caches are flushed
> before disks lose power when hibernate completes.  (I'm just handwaving
> here, though...)

That usually happens in the driver power-down sequence.

> Anyway, Dave's mention of making threads freezable makes the most sense.
> Documentation/power/freezing-of-tasks.txt
> makes it pretty clear that any thread which might change fs state
> needs to be freezable:
> =

> > We therefore freeze tasks that might
> > cause the on-disk filesystems' data and metadata to be modified after t=
he
> > hibernation image has been created and before the system is finally pow=
ered off.
> > The majority of these are user space processes, but if any of the kerne=
l threads
> > may cause something like this to happen, they have to be freezable.
> =

> jbd/jbd2 explicitly handle this freezing in the kjournald/kjournald2 thre=
ads.

As we do for the xfsaild kernel thread. We used to use kernel
threads for functionality that we now use workqueues for - the
xfssyncd and the xfsbufd  - and those kernel threads used to also
freeze like the xfsaild does. We lost that when moving to
workqueues.

The stupid part about all this is we actually stop periodic
workqueue processing for workqueues that can modify state when the
filesystem freezes. i.e. if the hibernation code froze the
filesystem we wouldn't need to mark workqueues as freezable because
XFS already manages everything in the manner than hibernation
requires....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
