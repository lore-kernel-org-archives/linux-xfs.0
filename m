Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752054AbdFLOz2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jun 2017 10:55:28 -0400
Date: Mon, 12 Jun 2017 10:55:26 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS journal write ordering constraints?
Message-ID: <20170612145523.GC10244@bfoster.bfoster>
References: <CALoZfD4-uqhRSfEh0Y+v8jjSDY2KkAh-hhwdLnRgZopHEETUXA@mail.gmail.com>
 <20170609234408.GE17542@dastard>
 <CALoZfD76r2ohmn=6CpPJ4DKrYVxNkP9LWmzDGm8dZRVZgBcgQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALoZfD76r2ohmn=6CpPJ4DKrYVxNkP9LWmzDGm8dZRVZgBcgQA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sweet Tea Dorminy <sweettea@permabit.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

It looks like you've replied to one mail and copy/pasted the text from
another. FWIW, it's usually best to reply to each mail independently to
preserve threading and whatnot.

On Fri, Jun 09, 2017 at 10:06:26PM -0400, Sweet Tea Dorminy wrote:
> >What is the xfs_info for this filesystem?
>        meta-data=/dev/mapper/tracer-vdo0 isize=256    agcount=4,
>        agsize=5242880 blks
>                 =                       sectsz=512   attr=2, projid32bit=0
>        data     =                       bsize=1024   blocks=20971520,
>        imaxpct=25
>                 =                       sunit=0      swidth=0 blks
>        naming   =version 2              bsize=4096   ascii-ci=0
>        log      =internal               bsize=1024   blocks=10240, version=2
>                 =                       sectsz=512   sunit=0 blks,
>        lazy-count=1
>        realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> > What granularity are these A and B regions (sectors or larger)?
> A is 1k, B is 3k.
> 
> >Are you running on some kind of special block device that reproduces this?
> It's a device we are developing,
> asynchronous, which we believe obeys FLUSH and FUA correctly but may
> have missed some case; we
> encountered this issue when testing an XFS filesystem on it, and other
> filesystems appear to work fine (although obviously we could have
> merely gotten lucky). Currently, when a flush returns from the device,
> we guarantee the data from all bios completed before the flush was
> issued is stably on disk; when a write+FUA bio returns from the
> device, the data in that bio (only) is guaranteed to be stable on disk. The
> device may, however, commit sequentially issued write+fua bios to disk in an
> arbitrary order.
> 
> > Do you have a consistent reproducer and/or have you
> reproduced on an upstream kernel
> Our reproducer fails about 20% of the time. We have not tried on an
> upstream kernel.
> 

Please do try on something upstream if possible. Also, what exactly
triggers the failure that ultimately leads to log recovery on the next
mount? Are you doing an XFS shutdown or shutting down the block device
underneath the fs?

> >Could you provide an xfs_metadump image of the filesystem that fails log recovery with CRC errors?
> I can capture such on Monday.
> For now, just the journal (gathered with xfs_logprint -C fsLog) can be
> found at (10M)
> https://s3.amazonaws.com/permabit-development/20170609-xfsUpload/fsLog
> .

Thanks. This certainly looks a bit strange. Up through sectors 19692 of
the log are populated with a cycle 2 LSN. After that appears to be the
previous cycle 1, which suggests that is the head of the log. The tail
then points to 1:20105, but from that point forward a strange mix of
cycle 1 and cycle 2 LSNs are seen.

It's not totally clear to me from the physical log state whether this
was the in-core state at the time of the crash, but a first guess may be
that at least this is what log recovery thinks and thus complains about
the tail of the log being borked.

> A log of the journal writes can be found at (17M)
> https://s3.amazonaws.com/permabit-development/20170609-xfsUpload/log_writes_only.blkparse.
> It is in a blkparse-like format. For each 512-byte sector of a bio,
> either starting or finishing, the data hash is recorded; the sector is
> recorded; and the index of this sector and the number of sectors
> within the current bio is recorded. Bios recorded as "FAILED" indicate
> that the device has crashed / become disconnected and the bio has
> returned with an error.
> 
> >From there, it searches a previous number of blocks
> based on the maximum log buffer concurrency allowed by the fs to
> determine whether any such "holes" exist in that range. If so, the head
> is walked back to the first instance of such a "hole," effectively
> working around out of order buffer completion at the time of a
> filesystem crash.
> 
> In the case logged and linked above, there are 256k of outstanding log
> write bytes at once; 187k of these fail and 69k succeed. Of the 69k which
> succeed, they are always the first 1k of the 4k block to which they
> belong. Is this within the permitted amount of outstanding log buffers?
> 

Generally, yes. Log recovery uses the maximum in-core log buffer count
(8) and the maximum supported log buffer size (256k) to determine how
far to look back (2M). The default log buffer size is 32k, so I suspect
256k means every log buffer was in-flight at this time.

When you reproduce this and presumably provide a metadump, could you
also collect the /sys/fs/xfs/<dev>/log/* state information at the time
of the crash of that particular metadump? Note that this directory
disappears after unmount so you'll have to collect it before.

Brian

> Thanks!
> 
> Sweet Tea
> 
> On Fri, Jun 9, 2017 at 7:44 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Jun 08, 2017 at 11:42:11AM -0400, Sweet Tea Dorminy wrote:
> >> Greetings;
> >>
> >> When using XFS with a 1k block size atop our device, we regularly get
> >> "log record CRC mismatch"es when mounting XFS after a crash, and we
> >> are attempting to understand why. We are using RHEL7.3 with its kernel
> >> 3.10.0-514.10.2.el7.x86_64, xfsprogs version 4.5.0.
> >>
> >> Tracing indicates the following situation occurs:
> >>        Some pair of consecutive locations contains data A1 and B1, respectively.
> >>        The XFS journal issues new writes to those locations,
> >> containing data A2 and B2.
> >>        The write of B' finishes, but A' is still outstanding at the
> >> time of the crash.
> >>        Crash occurs. The data on disk is A1 and B2, respectively.
> >>        XFS fails to mount, complaining that the checksum mismatches.
> >>
> >> Does XFS expect sequentially issued journal IO to be committed to disk
> >> in the order of issuance due to the use of FUA?
> >
> > Journal IO is not sequentially issued. It's an async process. At
> > runtime, ordering is handled by journal IO completion processing
> > being queued and run in order, so IOs can both be issued and
> > physically complete out of order.
> >
> > Log recovery is supposed to handle this. It searches and finds the
> > latest contiguous journal entry and does not replay past holes that
> > may arise from out of order journal writes.
> >
> > CRC errors like this in recovery imply that journal writes are being
> > torn or not completed fully, which may mean that your storage does
> > not correctly implement flush/FUA ordering semantics....
> >
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
