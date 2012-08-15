Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7F7WPKm093330 for <xfs@oss.sgi.com>; Wed, 15 Aug 2012 02:32:25 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	2syPzcIcPpAwTzfz for <xfs@oss.sgi.com>;
	Wed, 15 Aug 2012 00:32:23 -0700 (PDT)
Date: Wed, 15 Aug 2012 17:32:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: aborted SCSI commands while discarding/unmapping via mkfs.xfs
Message-ID: <20120815073220.GV2877@dastard>
References: <502AB82D.9090408@profihost.ag> <20120814213535.GK2877@dastard>
	<CAN05THQA8m=diOVodSyq48FVkmeOqz4KbApEP2D=wznWvD-7NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAN05THQA8m=diOVodSyq48FVkmeOqz4KbApEP2D=wznWvD-7NQ@mail.gmail.com>
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
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Christoph Hellwig <hch@lst.de>, dchinner@redhat.com, Stefan Priebe <s.priebe@profihost.ag>

On Wed, Aug 15, 2012 at 07:51:26AM +1000, ronnie sahlberg wrote:
> On Wed, Aug 15, 2012 at 7:35 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Aug 14, 2012 at 10:42:21PM +0200, Stefan Priebe wrote:
> >> Hello list,
> >>
> >> i'm testing KVM with qemu, libiscsi, virtio-scsi-pci and
> >> scsi-general on top of a nexenta storage solution. While doing
> >> mkfs.xfs on an already used LUN / block device i discovered that the
> >> unmapping / discard commands mkfs.xfs sends take a long time which
> >> results in a lot of aborted scsi commands.
> >
> > Sounds like a problem with your storage being really slow at
> > discards.
> >
> >> Would it make sense to let mkfs.xfs send these unmapping commands in
> >> small portations (f.e. 100MB)
> >
> > No, because the underlying implementation (blkdev_issue_discard())
> > already breaks the discard request up into the granularity that is
> > supported by the underlying storage.....
> >
> >> or is there another problem in the
> >> patch to the block device? Any suggestions or ideas?
> >
> > .... which, of course, had bugs in it so is a muchmore likely cause
> > of your problems.
> >
> > That said,the discard granularity is derived from information the
> > storage supplies the kernel in it's SCSI mode page, so if the
> > discard granularity is too large, that's a storage problem, not a
> > linux problem at all, let alone a mkfs.xfs problem.
> 
> Hi Dave,
> That is true.
> 
> But this particular issue seen in the network traces show that on this
> particular storage array,
> when a huge train of discards are sent, to basically discard the entire LUN,
> the storage array may take many minutes to perform these discards,
> during which time the array is unresponsive to any other I/O, on the
> same LUN or on other LUNs.

To be blunt, that's not my problem and I don't really care.

> And this basically means that for these kind of arrays with this
> discard behaviour, running a command that performs
> a huge number of discards to discard the entire device will basically
> act as a full denial-of-service attack,
> since every lun and every host that is attached to the array will
> experience a full outage for minutes.

So report the bug to the array vendor as a remote DOS attack. Or,
seeing as Nexenta is OSS, fix it yourself.

> This is definitely an issue with the array, BUT linux kernel and/or
> userspace utilities can, and very often are,
> implement tweaks to be more firendly towards and avoid triggering
> unfortunate hw behaviour.

Read the mkfs.xfs man page - you might find the -K option....

> For example, linux kernel contains a "fix" for the pentium FDIV bug,
> eventhoug there was never any issue in linux that needed fixing.

Apples and oranges.

> The only other realistic alternative is to provide warnings such as :
> "Some storage arrays may have major performance problems if you run
> mkfs.xfs that can cause a full outage for every single lun on that
> array that lasts for many minutes.  Unless you KNOW that your storage
> arrray does not have such issue for a fact, you should never run
> mkfs.xfs on a production system outside of a full scheduled outage
> window. The full set of storage arrays where this is a potential issue
> is not known".

Sorry, this is not a nanny state - a certain level of competency is
expected of storage administrators. I don't care about the children
or whether mkfs.xfs kills Bambi, either....

It's a storage array problem, and if you haven't tested your array
in a test environment before putting it in production, then you have
only yourself to blame because you haven't followed best practices.

In fact, the OP found this in a test environment trying something
shiny, new and still steaming, so these are exactly the sort of
problems we'd expect an early adopter of new technologies to find.
And, following best practices, I'd expect them to be reported,
too...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
