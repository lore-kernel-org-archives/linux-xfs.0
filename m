Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr013msb.fastweb.it ([85.18.95.104]:43646 "EHLO
        mr013msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbeBZHTE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Feb 2018 02:19:04 -0500
Subject: Re: Reflink (cow) copy of busy files
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Feb 2018 08:19:01 +0100
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20180226002533.GG30854@dastard>
References: <9e69fcd01e1c02ea53e0e1ac66d60d24@assyoma.it>
 <20180224220757.GC30854@dastard>
 <711dd96e3c4b3e92d3fb38a01e77dc64@assyoma.it>
 <20180225024727.GD30854@dastard>
 <25ebcdb42650430d83d283435053efed@assyoma.it>
 <20180225211309.GF30854@dastard>
 <d105d0000652be75774cc1f5f23eae68@assyoma.it>
 <20180226002533.GG30854@dastard>
Message-ID: <6eacd8faae2779b8dfb62fb0d65a9411@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, g.danti@assyoma.it

Full disclaimer: maybe my point of view is influenced by thinking in the 
context of Qemu/KVM + software RAID (where much works was done to be 
sure about proper barrier passing) or BBU/NV hardware RAID.

Il 26-02-2018 01:25 Dave Chinner ha scritto:
> Acknowledged sync writes are not guaranteed to be stable. They may
> still be sitting in volatile caches below the backing file, and so
> until there is a cache flush pushed down through all layers of the
> storage stack (e.g. fsync on the backing file) those acknowledged
> sync writes are not stable. That's one of the things quiescing the
> filesystem guarantees, but running reflink to clone the file does
> not.

Sure, but not-passed-down fsync/write barriers will thwarts even 
"normal" (ie: not CoW/snapshotted/reflinked) sync writes, and will 
inevitably cause problems (ie: a power loss become a big problem). How 
is it different for relinked copy?

> IOWs, "properly written" is easy to say but very hard to guarantee.
> We cannot make such assumptions about random user configs, nor we
> can base recommendations on such assumptions.  If you choose not to
> quiesce the filesystems before snapshotting them, then it's your
> responsibility to guarantee your storage stack will work correctly.

Absolutely, and I *really* appreciate your advices.

> You still have to quiesce the filesystem when it's on top of a LVM
> snapshot volume.

When the LVM volume is passed to a guest VM, the host can not quiesce 
the filesystem. Host/guest communication can be achieved by the mean on 
a guest agent and a private control channel, but this has its own 
problems. I thoroughly tested live, LVM-backed snapshotted VM and every 
time I run them, the guest filesystem replies its log without problem. I 
always double-check that the entire I/O stack (from guest down to the 
physical disks) honors write barriers, though.

Back to the original question: if a reflinked copy is an *atomic* 
operation on all the data extents comprising a file, and in the context 
of properly passed barriers/fsync, I would think that an unquiesced 
snapshot will work for the (reduced) consistency model of a 
crash-consistent snapshot.

If the reflink copy is not atomic (ie: the different extents are CoWed 
at different time, making it only a "faster copy" rather than a 
snapshot) this will *not* work and I will end with binary garbage (ie: 
writes can be reordered from snapshot's view).

I think all can be reduced to a single question: putting aside quiescing 
problems, is a reflinked copy a true *atomic* snapshot or it is "only" a 
faster copy?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
