Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34470 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162264AbdDUTOY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2017 15:14:24 -0400
Received: by mail-oi0-f42.google.com with SMTP id x184so109224275oia.1
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2017 12:14:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170421135634.GB28249@stefanha-x1.localdomain>
References: <20170331084147.32716-1-haozhong.zhang@intel.com>
 <20170406094359.GB21261@stefanha-x1.localdomain> <30db934f-d27e-1d15-6257-84224283dea9@gmail.com>
 <20170411084133.wroqrhn5eczesqam@hz-desktop> <CAPcyv4hmQRTn-KdUVYQjgb16cnprJ9yep+STFd1id4zEgL1rCg@mail.gmail.com>
 <CAPcyv4hV2-ZW8SMCRtD0P_86KgR3DHOvNe+6T5SY2u7wXg3gEg@mail.gmail.com> <20170421135634.GB28249@stefanha-x1.localdomain>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Apr 2017 12:14:23 -0700
Message-ID: <CAPcyv4hu6F+tDDf3x4m=hB8zg4Lfp54zzRQ-V1f7O991vVPELQ@mail.gmail.com>
Subject: Re: [Qemu-devel] [RFC PATCH 0/4] nvdimm: enable flush hint address structure
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Xiao Guangrong <guangrong.xiao@gmail.com>, Eduardo Habkost <ehabkost@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, Igor Mammedov <imammedo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Richard Henderson <rth@twiddle.net>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

[ adding xfs and fsdevel ]

On Fri, Apr 21, 2017 at 6:56 AM, Stefan Hajnoczi <stefanha@gmail.com> wrote:
[..]
>> >>> If the vNVDIMM device is based on the regular file, i think
>> >>> fsync is the bottleneck rather than this mmio-virtualization. :(
>> >>>
>> >>
>> >> Yes, fsync() on the regular file is the bottleneck. We may either
>> >>
>> >> 1/ perform the host-side flush in an asynchronous way which will not
>> >>    block vcpu too long,
>> >>
>> >> or
>> >>
>> >> 2/ not provide strong durability guarantee for non-NVDIMM backend and
>> >>    not emulate flush-hint for guest at all. (I know 1/ does not
>> >>    provide strong durability guarantee either).
>> >
>> > or
>> >
>> > 3/ Use device-dax as a stop-gap until we can get an efficient fsync()
>> > overhead reduction (or bypass) mechanism built and accepted for
>> > filesystem-dax.
>>
>> I didn't realize we have a bigger problem with host filesystem-fsync
>> and that WPQ exits will not save us. Applications that use device-dax
>> in the guest may never trigger a WPQ flush, because userspace flushing
>> with device-dax is expected to be safe. WPQ flush was never meant to
>> be a persistency mechanism the way it is proposed here, it's only
>> meant to minimize the fallout from potential ADR failure. My apologies
>> for insinuating that it was viable.
>>
>> So, until we solve this userspace flushing problem virtualization must
>> not pass through any file except a device-dax instance for any
>> production workload.
>
> Okay.  That's what I've assumed up until now and I think distros will
> document this limitation.
>
>> Also these performance overheads seem prohibitive. We really want to
>> take whatever fsync minimization / bypass mechanism we come up with on
>> the host into a fast para-virtualized interface for the guest. Guests
>> need to be able to avoid hypervisor and host syscall overhead in the
>> fast path.
>
> It's hard to avoid the hypervisor if the host kernel file system needs
> an fsync() to persist everything.  There should be a fast path where the
> host file is preallocated and no fancy file system features are in use
> (e.g. deduplication, copy-on-write snapshots) where host file systems
> don't need fsync().
>

So we've gone around and around on this with XFS folks with various
levels of disagreement about how to achieve synchronous faulting or
disabling metadata updates for a file. I think at some point someone
is going to want some fancy filesystem feature *and* DAX *and* still
want it to be fast.

The current problem is that if you want to checkpoint persistence at a
high rate, think committing updates to a tree data structure, an
fsync() call is going to burn a lot of cycles just to find out that
there is nothing to do in most cases. Especially when you've only
touched a couple pointers in a cache line, calling into the kernel to
sync those writes is a ridiculous proposition.

One of the current ideas to resolve this is instead of trying to
implement synchronous faulting and wrestle with the constraints that
puts on fs-fault paths, is to instead have synchronous notification of
metadata dirtying events to userspace. That notification mechanism
would be associated with something like an fsync2() library call that
knows how to bypass sys_fsync in the common case. Of course, this is
still in the idea phase, so until we can get a proof-of-concept on its
feet this is all subject to further debate.
