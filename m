Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:56588 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753165AbdKGFal (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2017 00:30:41 -0500
Received: by mail-yw0-f194.google.com with SMTP id l32so9894714ywh.13
        for <linux-xfs@vger.kernel.org>; Mon, 06 Nov 2017 21:30:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171106214653.GE5858@dastard>
References: <20171031112432.GA7093@bfoster.bfoster> <20171101004513.GK5858@dastard>
 <20171101141720.GB11709@bfoster.bfoster> <20171101235300.GT5858@dastard>
 <20171102112533.GA15748@bfoster.bfoster> <20171102233017.GX5858@dastard>
 <20171103112626.GA19974@bfoster.bfoster> <CAOQ4uxjEUAR1-1ikZSN2e99gK4k_mEMnhGGYvw=2Zj6oLOPVuQ@mail.gmail.com>
 <20171106011634.GC5858@dastard> <CAOQ4uxjJHyQ4-hUxcmRSP8V3xxZGN3MGm+8hKCRQFf2pRCfFiQ@mail.gmail.com>
 <20171106214653.GE5858@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 7 Nov 2017 07:30:40 +0200
Message-ID: <CAOQ4uxhcU3fZ28wpJ4e1ffxfqW6tXr2GU_9oOBckV5FKRpQ09w@mail.gmail.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Nov 6, 2017 at 11:46 PM, Dave Chinner <david@fromorbit.com> wrote:
[...]
>> commands will resize LVM and then resize2fs to max size.
>> Because "resize2fs to max size" is not an atomic operation and
>> because this is a "for dummies" product, in order to recover from
>> "half-resize", there is a post-mount script that runs resize2fs
>> unconditionally after boot.
>
> Sure, but if you have a product using thinspace filesystems then you
> are going to need to do something different. To think you can just
> plug a thinspace filesystem into an existing stack and have it work
> unmodified is naive at best.
>

I do not expect it to "work" on the contrary - I expect it not to work,
just the same as xfs_repair will refuse to repair an xfs with unknown
feature flags.

[...]
>
>> Now imagine you upgrade such a system to a kernel that supports
>> "thinspace" and new xfsprogs and create thin file systems, and then
>> downgrade the system to a kernel that sill supports "thinspace", but
>> xfsprogs that do not (or even a proprietary system component that
>> uses XFS_IOC_FSGROWDATA ioctl to perform the "auto-grow").
>
> In this case the thinspace filesystems will behave exactly like a
> physical filesystem. i.e. they will physically grow to the size of
> the underlying device. I can't stop this from happening, but I can
> ensure that it doesn't do irreversable damage and that it's
> reversible as soon as userspace is restored to suport thinspace
> administration again. i.e. just shrink it back down to the required
> thin size, and it's like that grow never occurred...
>
> i.e. it's not the end of the world, and you can recover cleanly from
> it without any issues.
>

Very true, not the end of the world. That is why your design is something
I can "live with". But it does have potential to cause pain downstream in
the future and I just don't see any reason why this pain cannot be avoided.
I fail to see the downside of not allowing old xfs_grow to modify thin space.

>> The results will be that all the thin file systems will all "auto-grow"
>> to the thick size of the volume.
>
> Of course it will - the user/app/admin asked the kernel to grow the
> filesystem to the size of the underlying device.  I don't know what
> you expect a thinspace filesystem to do here other than *grow the
> filesystem to the size of the underlying device*.

I expect kernel to tell user EINVAL and warn that user needs to use newer
xfsprogs to auto grow thin space.

Let me re-iterate the requirement we are disagreeing on:
- old xfs_growfs will succeed to grow, *except* for a thin fs that
  was previously shrunk (i.e. dblocks != usable_dblocks)

You explained at length why the exception is not a must.
I do not remember a single argument that explains what's
wrong with keeping the exception.
I claimed that this exception can reduce pain to end users.
In response, you wrote that "user/app/admin asked to grow fs to
maximum size" and in so many words that they can "keep the pieces".

What bad things can happen if the clueless user/app/admin is refused
to grow fs to maximum size?
The practice of "not sure you know what you are doing so please keep
away" has been a very good practice for xfs and file systems for years.
Why not abide by this law in this case?

Cheers,
Amir.
