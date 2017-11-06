Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:25993 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751060AbdKFVrP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 16:47:15 -0500
Date: Tue, 7 Nov 2017 08:46:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Message-ID: <20171106214653.GE5858@dastard>
References: <20171031112432.GA7093@bfoster.bfoster>
 <20171101004513.GK5858@dastard>
 <20171101141720.GB11709@bfoster.bfoster>
 <20171101235300.GT5858@dastard>
 <20171102112533.GA15748@bfoster.bfoster>
 <20171102233017.GX5858@dastard>
 <20171103112626.GA19974@bfoster.bfoster>
 <CAOQ4uxjEUAR1-1ikZSN2e99gK4k_mEMnhGGYvw=2Zj6oLOPVuQ@mail.gmail.com>
 <20171106011634.GC5858@dastard>
 <CAOQ4uxjJHyQ4-hUxcmRSP8V3xxZGN3MGm+8hKCRQFf2pRCfFiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjJHyQ4-hUxcmRSP8V3xxZGN3MGm+8hKCRQFf2pRCfFiQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Nov 06, 2017 at 11:48:05AM +0200, Amir Goldstein wrote:
> On Mon, Nov 6, 2017 at 3:16 AM, Dave Chinner <david@fromorbit.com> wrote:
> > just work on existing binaries without them having to do
> > anything....
> >
> >> Don't you see that this is the right thing to do w.r.t. API design?
> >
> > No, I don't, because you're trying to solve a problem that, quite
> > simply, doesn't exist.
> >
> 
> It is *very* possible that you are right, but you have not proven that
> the problem does not exist. You have proven that the problem
> does not exist w.r.t old xfs_grow -D <size> and you correctly
> claimed that the problem with old xfs_grow -m <imaxpct> is an
> implementation bug with RFC patches.
> 
> Let me give an example that will demonstrate my concern.
> 
> One of our older NAS products, still deployed with many customers
> has LVM based volume manager and ext3 file system.
> When user changes the size of a volume via Web UI, lower level
> commands will resize LVM and then resize2fs to max size.
> Because "resize2fs to max size" is not an atomic operation and
> because this is a "for dummies" product, in order to recover from
> "half-resize", there is a post-mount script that runs resize2fs
> unconditionally after boot.

Sure, but if you have a product using thinspace filesystems then you
are going to need to do something different. To think you can just
plug a thinspace filesystem into an existing stack and have it work
unmodified is naive at best.

Indeed, with a thinspace filesystem, the LVM volume *never needs
resizing* because it will be created far larger than ever required
in the first place. And recovering from a crash half way through a
thinspace growfs operation? Well, it's all done through the
filesystem journal because it's all done through transactions.

IOWs, thinspace filesystems solve this "atomic resize" problem
without needing crutches or external constructs to hide non-atomic
operations.

Essentially, if you have a storage product and you plug thinspace
filesystems into it without management modifications, then you get
to keep all the bits that break and don't work correctly.

All I care is that stupid things don't happen if someone has
integrated thinspace filesystems correctly and then a user
does this:

> Now imagine you upgrade such a system to a kernel that supports
> "thinspace" and new xfsprogs and create thin file systems, and then
> downgrade the system to a kernel that sill supports "thinspace", but
> xfsprogs that do not (or even a proprietary system component that
> uses XFS_IOC_FSGROWDATA ioctl to perform the "auto-grow").

In this case the thinspace filesystems will behave exactly like a
physical filesystem. i.e. they will physically grow to the size of
the underlying device. I can't stop this from happening, but I can
ensure that it doesn't do irreversable damage and that it's
reversible as soon as userspace is restored to suport thinspace
administration again. i.e. just shrink it back down to the required
thin size, and it's like that grow never occurred...

i.e. it's not the end of the world, and you can recover cleanly from
it without any issues.

> The results will be that all the thin file systems will all "auto-grow"
> to the thick size of the volume.

Of course it will - the user/app/admin asked the kernel to grow the
filesystem to the size of the underlying device.  I don't know what
you expect a thinspace filesystem to do here other than *grow the
filesystem to the size of the underlying device*.

> So we can agree to disagree on the desired behavior, but for the
> record, this and only this point is the API design flaw I am talking
> about.

What flaw?

You've come up with a scenario where the thinspace filesystem will
behave like physical filesystem because that's what the thinspace
unaware admin program expects it to be. i.e. thinspace is completely
transparent to userspace, and physical grow does not prevent
subsequent shrinks back to the original thinspace size.

None of this indicates that there is an interface problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
