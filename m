Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D3FF27CA0
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 18:08:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35D2BAC002
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 16:08:48 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	TKo2CquCUFQm0dlH for <xfs@oss.sgi.com>;
	Fri, 08 Apr 2016 16:08:45 -0700 (PDT)
Date: Sat, 9 Apr 2016 09:08:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/19] xfsprogs: disable truncating of files
Message-ID: <20160408230843.GE567@dastard>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-18-git-send-email-jtulak@redhat.com>
	<20160408000910.GB21804@dastard>
	<CACj3i73f_v=70pGrrLkRpHB-6UwiOOM2F9Sbu2aZMaJGmBLeiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACj3i73f_v=70pGrrLkRpHB-6UwiOOM2F9Sbu2aZMaJGmBLeiQ@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Apr 08, 2016 at 12:06:35PM +0200, Jan Tulak wrote:
> On Fri, Apr 8, 2016 at 2:09 AM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Thu, Mar 24, 2016 at 12:15:34PM +0100, jtulak@redhat.com wrote:
> > > From: Jan Tulak <jtulak@redhat.com>
> > >
> > > Unify mkfs.xfs behaviour a bit and never truncate files. If the user
> > > is trying to mkfs an existing file, we don't want to destroy anything
> > > he did with the file before (sparse file, allocations...)
> >
> > Why not? We do that with discard-by-default to block devices,
> > O_TRUNC is exactly the same situation with a file - we completely
> > re-initialise the file from a known state if mkfs has been asked to
> > create the file.
> >
> But AFAIK, we don't zero-out entire spindle devices,

Unless the controller above them supports discard or whatever
implementation the storage protocol uses (e.g. UNMAP or WRITE_SAME).
e.g, the "spindle devices" often are big raid arrays that are using
thin provisioning, compression and dedupe internally, so running
discard on them does make a significant difference to their
behaviour.

> we don't ask if the drive skips some blocks (i.e. because they are bad),

That's irrelevant to the issue at hand.

> and we don't care
> about what an underlaying layer (like LVM) did with the block device.

Actually, we do, because users care about their storage stack doing
sane management operations automatically.

That's why we issued a discard - it tells the underlying devices to
re-initialise the storage on this device *if they care about such
things*. Stuff like thinly provisioned devices rely on mkfs
behaviour like this to recycle used storage efficiently and
transparently. The user expects things to "just work" and this is
one of those things that makes it "just work".

> From
> this point of view, we shouldn't care about the file either.
> 
> I can be missing something, though.

I think you're missing the fact that we don't know what the
*underlying storage* cares about, so we need to tell them in some
way that a device or image file is being re-initialised from
scratch. Whether that is by truncating the image file (so the
filesytem can issue discards on the now unused space) or by issuing
discard ioctls ourselves, it really doesn't matter. The key point is
that we have a mechanism that allows us to notify the underlying
storage of the "this is re-initialised storage" intent of mkfs.

So from that perspective, the O_TRUNC behaviour should remain.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
