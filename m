Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f180.google.com ([209.85.213.180]:40005 "EHLO
        mail-yb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750929AbeBZH6K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Feb 2018 02:58:10 -0500
Received: by mail-yb0-f180.google.com with SMTP id o1-v6so689980ybm.7
        for <linux-xfs@vger.kernel.org>; Sun, 25 Feb 2018 23:58:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6eacd8faae2779b8dfb62fb0d65a9411@assyoma.it>
References: <9e69fcd01e1c02ea53e0e1ac66d60d24@assyoma.it> <20180224220757.GC30854@dastard>
 <711dd96e3c4b3e92d3fb38a01e77dc64@assyoma.it> <20180225024727.GD30854@dastard>
 <25ebcdb42650430d83d283435053efed@assyoma.it> <20180225211309.GF30854@dastard>
 <d105d0000652be75774cc1f5f23eae68@assyoma.it> <20180226002533.GG30854@dastard>
 <6eacd8faae2779b8dfb62fb0d65a9411@assyoma.it>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 26 Feb 2018 09:58:09 +0200
Message-ID: <CAOQ4uxixAP6F8f6hT5VENQLD0o_3Bym6pkAJhXva5b99BhE9Eg@mail.gmail.com>
Subject: Re: Reflink (cow) copy of busy files
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Feb 26, 2018 at 9:19 AM, Gionatan Danti <g.danti@assyoma.it> wrote:
> Full disclaimer: maybe my point of view is influenced by thinking in the
> context of Qemu/KVM + software RAID (where much works was done to be sure
> about proper barrier passing) or BBU/NV hardware RAID.
>
> Il 26-02-2018 01:25 Dave Chinner ha scritto:
>>
>> Acknowledged sync writes are not guaranteed to be stable. They may
>> still be sitting in volatile caches below the backing file, and so
>> until there is a cache flush pushed down through all layers of the
>> storage stack (e.g. fsync on the backing file) those acknowledged
>> sync writes are not stable. That's one of the things quiescing the
>> filesystem guarantees, but running reflink to clone the file does
>> not.
>
>
> Sure, but not-passed-down fsync/write barriers will thwarts even "normal"
> (ie: not CoW/snapshotted/reflinked) sync writes, and will inevitably cause
> problems (ie: a power loss become a big problem). How is it different for
> relinked copy?
>
>> IOWs, "properly written" is easy to say but very hard to guarantee.
>> We cannot make such assumptions about random user configs, nor we
>> can base recommendations on such assumptions.  If you choose not to
>> quiesce the filesystems before snapshotting them, then it's your
>> responsibility to guarantee your storage stack will work correctly.
>
>
> Absolutely, and I *really* appreciate your advices.
>
>> You still have to quiesce the filesystem when it's on top of a LVM
>> snapshot volume.
>
>
> When the LVM volume is passed to a guest VM, the host can not quiesce the
> filesystem. Host/guest communication can be achieved by the mean on a guest
> agent and a private control channel, but this has its own problems. I
> thoroughly tested live, LVM-backed snapshotted VM and every time I run them,
> the guest filesystem replies its log without problem. I always double-check
> that the entire I/O stack (from guest down to the physical disks) honors
> write barriers, though.
>
> Back to the original question: if a reflinked copy is an *atomic* operation
> on all the data extents comprising a file, and in the context of properly
> passed barriers/fsync, I would think that an unquiesced snapshot will work
> for the (reduced) consistency model of a crash-consistent snapshot.
>
> If the reflink copy is not atomic (ie: the different extents are CoWed at
> different time, making it only a "faster copy" rather than a snapshot) this
> will *not* work and I will end with binary garbage (ie: writes can be
> reordered from snapshot's view).
>
> I think all can be reduced to a single question: putting aside quiescing
> problems, is a reflinked copy a true *atomic* snapshot or it is "only" a
> faster copy?
>

Gionatan,

First of all, the answer to your question is "just" faster copy.
reflinkning a file is much faster than copy, but it is not O(1).
I believe cp --reflink can result in cloning part of the file if the system
crashes mid operation, so in any case, the operation is not *atomic*
in that sense.

But your questions about quiescence the filesystem and your question
about the *atomic* nature of the clone operation are two very different
questions.

What you seem to *think* xfs reflink does, it does not actually do.
xfs reflink does NOT reflink the file in-memory data.
xfs reflink "only" reflinks the file on-disk data.
Right now, if you write a large file without fsync and clone it, you
might as well get a clone of unallocated or partly fallocated file with
zero or stale data.

Going forward, I think there is an intention to "clone" the file in-memory
data as well by sharing the READONLY cache pages between cloned files,
but I don't think dirty pages are going be shared between clones anyway,
so you are back to square one - need to get the data on-disk before cloning
the file.

Cheers,
Amir.
