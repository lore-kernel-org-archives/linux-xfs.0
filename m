Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:35494 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753286AbdFMOOM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jun 2017 10:14:12 -0400
Received: by mail-ua0-f176.google.com with SMTP id q15so76224581uaa.2
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jun 2017 07:14:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170612235002.GF17542@dastard>
References: <CALoZfD4-uqhRSfEh0Y+v8jjSDY2KkAh-hhwdLnRgZopHEETUXA@mail.gmail.com>
 <20170609234408.GE17542@dastard> <CALoZfD76r2ohmn=6CpPJ4DKrYVxNkP9LWmzDGm8dZRVZgBcgQA@mail.gmail.com>
 <20170612235002.GF17542@dastard>
From: Sweet Tea Dorminy <sweettea@permabit.com>
Date: Tue, 13 Jun 2017 10:14:10 -0400
Message-ID: <CALoZfD4RXJUusr7-r8COsUY+8_D6z68LbCRkp+9VM1E2tUV1UA@mail.gmail.com>
Subject: Re: XFS journal write ordering constraints?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Thank you! I'm glad that we've established it's a mismatch between our
device's implementation and XFS expectations.

>.... XFS issues log writes with REQ_PREFLUSH|REQ_FUA. This means
sequentially issued log writes have clearly specified ordering
constraints. i.e. the preflush completion order requirements means
that the block device must commit preflush+write+fua bios to stable
storage in the exact order they were issued by the filesystem....

That is certainly what REQ_BARRIER did back in the day. But when
REQ_BARRIER was replaced with separate REQ_FUA and REQ_FLUSH
flags, and barrier.txt got replaced with writeback_cache_control.txt,
the documentation seemed to imply the ordering requirement on *issued*
IO had gone away (but maybe I'm missing something).


Quoth writeback_cache_control.txt about REQ_PREFLUSH:
> will make sure the volatile cache of the storage device
>has been flushed before the actual I/O operation is started.
> This explicitly guarantees that previously completed write requests are on non-volatile
> storage before the flagged bio starts.

And about REQ_FUA:
> I/O completion for this request is only
> signaled after the data has been committed to non-volatile storage.

I am perhaps overlooking where REQ_PREFLUSH guarantees all previously
issued write requests with FLUSH|FUA are stable, not just all
previously completed ones. Is this documented somewhere?
Nevertheless, if XFS is expecting this guarantee, that would certainly
be the source of this corruption.

Thanks again!

On Mon, Jun 12, 2017 at 7:50 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Jun 09, 2017 at 10:06:26PM -0400, Sweet Tea Dorminy wrote:
>> >What is the xfs_info for this filesystem?
>>        meta-data=/dev/mapper/tracer-vdo0 isize=256    agcount=4,
>>        agsize=5242880 blks
>>                 =                       sectsz=512   attr=2, projid32bit=0
>>        data     =                       bsize=1024   blocks=20971520,
>>        imaxpct=25
>>                 =                       sunit=0      swidth=0 blks
>>        naming   =version 2              bsize=4096   ascii-ci=0
>>        log      =internal               bsize=1024   blocks=10240, version=2
>>                 =                       sectsz=512   sunit=0 blks,
>>        lazy-count=1
>>        realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>> > What granularity are these A and B regions (sectors or larger)?
>> A is 1k, B is 3k.
>>
>> >Are you running on some kind of special block device that reproduces this?
>> It's a device we are developing,
>> asynchronous, which we believe obeys FLUSH and FUA correctly but may
>> have missed some case;
>
> So Occam's Razor applies here....
>
>> we
>> encountered this issue when testing an XFS filesystem on it, and other
>> filesystems appear to work fine (although obviously we could have
>> merely gotten lucky).
>
> XFS has quite sophisticated async IO dispatch and ordering
> mechanisms compared to other filesystems and so frequently exposes
> problems in the underlying storage layers that other filesystems
> don't exercise.
>
>> Currently, when a flush returns from the device,
>> we guarantee the data from all bios completed before the flush was
>> issued is stably on disk;
>
> Yup, that's according to
> Documentation/block/writeback_cache_control.txt, however....
>
>> when a write+FUA bio returns from the
>> device, the data in that bio (only) is guaranteed to be stable on disk. The
>> device may, however, commit sequentially issued write+fua bios to disk in an
>> arbitrary order.
>
> .... XFS issues log writes with REQ_PREFLUSH|REQ_FUA. This means
> sequentially issued log writes have clearly specified ordering
> constraints. i.e. the preflush completion order requirements means
> that the block device must commit preflush+write+fua bios to stable
> storage in the exact order they were issued by the filesystem....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
