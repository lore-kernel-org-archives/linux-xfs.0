Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 758C47FA5
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 18:45:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E8DF6AC006
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 16:45:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	O77ooXY8HEBXBY4U for <xfs@oss.sgi.com>;
	Fri, 29 Aug 2014 16:45:09 -0700 (PDT)
Date: Sat, 30 Aug 2014 09:45:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mount options question
Message-ID: <20140829234505.GE20518@dastard>
References: <3dc9caf6f9b415f6e4c0ebac1f1626d3@zbfmail.de>
	<20140827230732.GN20518@dastard>
	<CAAxjCEy9UyjDVrTZ4GdRyDy330wUqLGWurzrLAE6-7Q0KdYzvA@mail.gmail.com>
	<20140829083738.GD20518@dastard>
	<6306cfa5-457d-4794-8fc0-1768f7f1deec@email.android.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6306cfa5-457d-4794-8fc0-1768f7f1deec@email.android.com>
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
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Stefan Ring <stefanrin@gmail.com>, weber@zbfmail.de, Xfs <xfs@oss.sgi.com>

On Fri, Aug 29, 2014 at 07:26:59AM -0400, Greg Freemyer wrote:
> =

> =

> On August 29, 2014 4:37:38 AM EDT, Dave Chinner <david@fromorbit.com> wro=
te:
> >On Fri, Aug 29, 2014 at 08:31:43AM +0200, Stefan Ring wrote:
> >> On Thu, Aug 28, 2014 at 1:07 AM, Dave Chinner <david@fromorbit.com>
> >wrote:
> >> > On Wed, Aug 27, 2014 at 12:14:21PM +0200, Marko Weber|8000 wrote:
> >> >>
> >> >> sorry dave and all other,
> >> >>
> >> >> can you guys recommend me the most stable / best mount options for
> >> >> my new server with ssd=B4s and XFS filesystem?
> >> >>
> >> >> at moment i would set: =

> >defaults,nobarrier,discard,logbsize=3D256k,noikeep
> >> >> or is just "default" the best solution and xfs detect itself whats
> >best.
> >> >>
> >> >> can you guide me a bit?
> >> >>
> >> >> as eleavtor i set elevator=3Dnoop
> >> >>
> >> >> i setup disks with linux softraid raid1. On top of the raid is LVM
> >> >> (for some data partations).
> >> >>
> >> >>
> >> >> would be nice to hear some tipps from you
> >> >
> >> > Unless you have specific requirements or have the knowledge to
> >> > understand how the different options affect behaviour, then just
> >use
> >> > the defaults.
> >> =

> >> Mostly agreed, but using "discard" would be a no-brainer for me. I
> >> suppose XFS does not automatically switch it on for non-rotational
> >> storage.
> >
> >Yup, you're not using your brain. :P
> >
> >mount -o discard *sucks* on so many levels it is not funny. I don't
> >recommend that anybody *ever* use it, on XFS, ext4 or btrfs.  Just
> >use fstrim if you ever need to clean up a SSD.
> =


> In particular trim is a synchronous command in many SSDs, I don't
> know about the impact on the kernel block stack.

blkdev_issue_discard() is synchronous as well, which is a big
problem for something that needs to iterate (potentially) thousands
of regions for discard when a journal checkpoint completes....

> For the SSD
> itself that means the SSDs basically flush their write cache on
> every trim call.

Oh, it's worse than that, usually. TRIM is one of the slowest
operations you can run on many drives, so it can take hundreds of
milliseconds to execute....

> I often tell people to do performance testing with and without it
> and report back to me if they see no degradation caused by -o
> discard.  To date no one has ever reported back.  I think -o
> discard should have never been introduced and certainly not 5
> years ago.

It was introduced into XFS as a checkbox feature. We resisted as
long as we could, but too many people were shouting at us that we
needed realtime discard because ext4 and btrfs had it. Of course,
all those people shouting for it realised that we were right in that
it sucked the moment they tried to use it and found that performance
was woeful. Not to mention that SSD trim implementations were so bad
that they caused random data corruption by trimming the wrong
regions, drives would simply hang randomly and in a couple of cases
too many trims too fast would brick them...

So, yeah, it was implement because lots of people demanded it, not
because it was a good idea.

> In theory, SSDs that handle trim as a asynchronous
> command are now available, but I don't know any specifics.

Requires SATA 3.1 for the queued TRIM, and I'm not sure that there
is any hardware out there that uses this end-to-end yet. And the
block layer can't make use of it yet, either...

> In any case, fstrim works for almost all workloads and doesn't
> have the potential continuous negative impact of -o discard.

Precisely my point - you just gave some more detail. :)

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
