Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:53683 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751752AbdKFJsH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 04:48:07 -0500
Received: by mail-yw0-f194.google.com with SMTP id q126so7284415ywq.10
        for <linux-xfs@vger.kernel.org>; Mon, 06 Nov 2017 01:48:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171106011634.GC5858@dastard>
References: <20171030133117.GA3535@bfoster.bfoster> <20171030210941.GA5858@dastard>
 <20171031112432.GA7093@bfoster.bfoster> <20171101004513.GK5858@dastard>
 <20171101141720.GB11709@bfoster.bfoster> <20171101235300.GT5858@dastard>
 <20171102112533.GA15748@bfoster.bfoster> <20171102233017.GX5858@dastard>
 <20171103112626.GA19974@bfoster.bfoster> <CAOQ4uxjEUAR1-1ikZSN2e99gK4k_mEMnhGGYvw=2Zj6oLOPVuQ@mail.gmail.com>
 <20171106011634.GC5858@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 6 Nov 2017 11:48:05 +0200
Message-ID: <CAOQ4uxjJHyQ4-hUxcmRSP8V3xxZGN3MGm+8hKCRQFf2pRCfFiQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Nov 6, 2017 at 3:16 AM, Dave Chinner <david@fromorbit.com> wrote:
...

> Not to mention other application developers that might
> be using the existing geometry and grwofs ioctls - shrink will now

Acknowledging that those "other application" may exist in the wild
makes it even harder to claim that allowing to change usable_dblocks
with existing API is not going to cause pain for users...

> just work on existing binaries without them having to do
> anything....
>
>> Don't you see that this is the right thing to do w.r.t. API design?
>
> No, I don't, because you're trying to solve a problem that, quite
> simply, doesn't exist.
>

It is *very* possible that you are right, but you have not proven that
the problem does not exist. You have proven that the problem
does not exist w.r.t old xfs_grow -D <size> and you correctly
claimed that the problem with old xfs_grow -m <imaxpct> is an
implementation bug with RFC patches.

Let me give an example that will demonstrate my concern.

One of our older NAS products, still deployed with many customers
has LVM based volume manager and ext3 file system.
When user changes the size of a volume via Web UI, lower level
commands will resize LVM and then resize2fs to max size.
Because "resize2fs to max size" is not an atomic operation and
because this is a "for dummies" product, in order to recover from
"half-resize", there is a post-mount script that runs resize2fs
unconditionally after boot.

So in this product, the LVM volume size is treated as an "intent log"
for file system size grow operation.

I find it hard to believe that this practice is so novel that nobody
else ever used it and for that matter with xfs file system over LVM
and xfs_grow -d.

Now imagine you upgrade such a system to a kernel that supports
"thinspace" and new xfsprogs and create thin file systems, and then
downgrade the system to a kernel that sill supports "thinspace", but
xfsprogs that do not (or even a proprietary system component that
uses XFS_IOC_FSGROWDATA ioctl to perform the "auto-grow").

The results will be that all the thin file systems will all "auto-grow"
to the thick size of the volume.

So the way I see it, my proposal to require explicitly
XFS_IOC_FSGROWDATA API V1 for any change to usable_dblocks
that is not coupled with same change to dblocks is meant to resolve
userspace/kernel compatibility issues.

And I fail to see how that requirement makes it hard to maintain
userspace/kernel compatibility:
- xfs_growfs needs to check for "thinspace" flag and if exists use V1 API
- old kernel can't mount "thinspace" fs, so it can never see V1 API
  unless from a buggy program, that will get -EINVAL
- old xfs_growfs will keep failing to shrink even a thin fs
- old xfs_growfs will succeed to grow, except (*) for a thin fs that
was previously shrunk

(*) That exception is relating to the example I described above,
and we seem to not be in agreement about the desired behavior.

IIUC, you like the fact that old xfs_grow can grow a thin and shrunk fs
where I see troubled lurking in this behavior.

So we can agree to disagree on the desired behavior, but for the
record, this and only this point is the API design flaw I am talking
about.

There may be complexities w.r.t maintaining userspace/kernel compatibility
with the proposed solution. I trust you on this because you have far
more experience than me with maintaining historic baggage of wrongly
designed APIs.

If no one else is concerned about the old xfs_grow -d use case and no one
else shares my opinion about the desired behavior in that use case, then
I withdraw my claims.

Thanks,
Amir.
