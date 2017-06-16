Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55276 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753524AbdFPNmD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Jun 2017 09:42:03 -0400
Date: Fri, 16 Jun 2017 09:42:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS journal write ordering constraints?
Message-ID: <20170616134201.GA12082@bfoster.bfoster>
References: <CALoZfD4-uqhRSfEh0Y+v8jjSDY2KkAh-hhwdLnRgZopHEETUXA@mail.gmail.com>
 <20170609234408.GE17542@dastard>
 <CALoZfD76r2ohmn=6CpPJ4DKrYVxNkP9LWmzDGm8dZRVZgBcgQA@mail.gmail.com>
 <20170612145523.GC10244@bfoster.bfoster>
 <20170612161813.GA11112@bfoster.bfoster>
 <CALoZfD4q5y_JXreetyriOWH1NN9sheVJtDzhcu3ZxoHxABDvpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALoZfD4q5y_JXreetyriOWH1NN9sheVJtDzhcu3ZxoHxABDvpQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sweet Tea Dorminy <sweettea@permabit.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Thu, Jun 15, 2017 at 06:28:05PM -0400, Sweet Tea Dorminy wrote:
> Apologies for the time required to reproduce, much greater than
> expected. Here is a full metadump pre and post recovery:
>        https://s3.amazonaws.com/permabit-development/20170615-xfsUpload/metadump-post-recovery
>        https://s3.amazonaws.com/permabit-development/20170615-xfsUpload/metadump-pre-recovery
> 

Thanks for the data. The pre/post images do in fact show that some
modification occurs during log recovery. Taking a look at 'xfs_logprint
-d' output from the post image, we can see that the head of the log is
here:

...
 19991 HEADER Cycle 2 tail 1:020377 len   3584 ops 29      
 19999 HEADER Cycle 1 tail 1:020377 len      0 ops 0       
[00031 - 19999] Cycle 0x00000002 New Cycle 0x00000001      
...

... because that is the last cycle 2 write in the physical log. The pre
image shows that sectors 19999 and beyond contained cycle 1 data that
was zapped by log recovery because it was beyond the head.

The start of the tail up through the end of the physical log actually
looks sane:

...
 20377 HEADER Cycle 1 tail 1:007684 len  32256 ops 331
 20441 HEADER Cycle 1 tail 1:007684 len  32256 ops 317

... but as the tail wraps to the beginning of the physical log, we run
into this:

[00000 - 00000] Cycle 0xffffffff New Cycle 0x00000003
[00000 - 00007] Cycle 0x00000003 New Cycle 0x00000002
[00007 - 00014] Cycle 0x00000002 New Cycle 0x00000003
[00014 - 00015] Cycle 0x00000003 New Cycle 0x00000002
[00015 - 00022] Cycle 0x00000002 New Cycle 0x00000003
[00022 - 00023] Cycle 0x00000003 New Cycle 0x00000002
    25 HEADER Cycle 2 tail 1:007684 len  32256 ops 238
[00023 - 00030] Cycle 0x00000002 New Cycle 0x00000003
[00030 - 00031] Cycle 0x00000003 New Cycle 0x00000002
...

... which tells us that this was the beginning of the 3rd cycle in the
log, but obviously this log data is junk. For log recovery from the tail
to the head to work correctly, we need to have the valid cycle 2 data in
place up to the head.

If we consider that you have 8 32k log buffers and the in-core head at
the time was 2:19999, that means the maximum "reach" of those 8 log bufs
is (8 * 64s) = 512 sectors. Walking forward from the head and wrapping
around the max log sector (which bumps the cycle from 2 to 3) gives us
19999 + 512 - 20480 = 31, which corresponds to the end of the garbage
output above.

In summary, I think the problem you are hitting is overwriting part of
the last good tail in the log, as suspected in the previous mail. What
happens at log recovery time is that it correctly identifies the garbage
region of the log, walks the head back to 2:19999 and attempts to
recover from the tail of 1:020377 to the head. Once recovery gets to the
start of cycle 2, however, it runs into the garbage data and falls over.

It's highly likely that this particular data is actually not needed to
recover filesystem consistency, because the fs can only overwrite log
data once that data has been written back to the final location on disk.
The problem here is that log recovery does not know that. It considers
the log corrupted and stops. This prevents recovery from moving on the
subsequent records that may very well need to be recovered to the fs and
thus leaves the fs in an inconsistent state.

> I also obtained a different, less common, problem, which may or may
> not have the same origin; I'm hopeful it comes from the same root
> cause and helps diagnose. The symptom is: xfs mount fails with
> "Structure needs cleaning".
> The backtrace in the kernel log is of the form
> 
> Nov 12 02:43:03 localhost kernel: [  112.897334] XFS (dm-4): Internal
> error xlog_valid_rec_header(1) at line 4104 of file
> fs/xfs/xfs_log_recover.c.  Caller xlog_do_recovery_pass
> +0x4fc/0x5a0 [xfs]
...
> 
> The full dump of _this_ failure is at:
>        https://s3.amazonaws.com/permabit-development/20170613-xfsUpload/metadump-pre-recovery
>        https://s3.amazonaws.com/permabit-development/20170613-xfsUpload/metadump-post-recovery
> 

Thanks. This looks to me like the same fundamental problem, just in a
different spot in the log. By the looks of it, the tail is completely
annihilated in this case and doesn't even represent a valid record. I
suppose this could lead to slightly different error behavior at log
recovery time, but the root cause appears the same to me.

> 
> >P.S., I've also been assuming based on the log state that you haven't
> used the logbufs/logbsize mount options to change from the defaults, but
> please do confirm that you aren't changing either of those defaults.
> Thanks.
> 
> Correct. The mkfs invocation is 'mkfs -t xfs -f -q -K -b size=1024
> $device' and the mount invocation is "mount -t xfs -o discard $device
> $mountpoint"
> 

Ah, so the discard mount option could be the source of latency that
causes the log to fill up in the first place. This is a synchronous
operation (no longer the case upstream, actually) and I believe is known
to lead to stalls. My understanding is that running a background fstrim
process on regular intervals is preferred to the discard mount option.

With regard to fixing the problem, it's probably not going to be a
trivial change and the fix is not yet clear to me (though I am planning
to post a fairly reliable reproducer test case shortly). It's also not
clear to me whether this is a production configuration for you or you
are just testing your block device on various configurations. If you
require a workaround, the first option may be to avoid the discard mount
option noted above. That is still non-deterministic because other
latencies could cause the log to fill.

In practice, I think that either increasing the block size or reducing
the log buffer size (or count) should prevent this problem from
occurring at all. For example, cutting log buffer space in half from 32k
log buffers to logbsize=16k (or logbufs=8 to logbufs=4 with 32k bufs)
should be enough to prevent the problem with -bsize=1k. Also, I don't
think this will reproduce with 4k blocks and otherwise default settings.

If you wanted to provide additional verification that this is the
problem, I suspect bumping up to logbsize=256k (with discard enabled)
should be enough to improve the reproducibility of this for any
supported block size (if you do attempt to confirm that, please do post
results).

Brian

> Thanks again!
> 
> On Mon, Jun 12, 2017 at 12:18 PM, Brian Foster <bfoster@redhat.com> wrote:
> > On Mon, Jun 12, 2017 at 10:55:26AM -0400, Brian Foster wrote:
> >> It looks like you've replied to one mail and copy/pasted the text from
> >> another. FWIW, it's usually best to reply to each mail independently to
> >> preserve threading and whatnot.
> >>
> >> On Fri, Jun 09, 2017 at 10:06:26PM -0400, Sweet Tea Dorminy wrote:
> >> > >What is the xfs_info for this filesystem?
> >> >        meta-data=/dev/mapper/tracer-vdo0 isize=256    agcount=4,
> >> >        agsize=5242880 blks
> >> >                 =                       sectsz=512   attr=2, projid32bit=0
> >> >        data     =                       bsize=1024   blocks=20971520,
> >> >        imaxpct=25
> >> >                 =                       sunit=0      swidth=0 blks
> >> >        naming   =version 2              bsize=4096   ascii-ci=0
> >> >        log      =internal               bsize=1024   blocks=10240, version=2
> >> >                 =                       sectsz=512   sunit=0 blks,
> >> >        lazy-count=1
> >> >        realtime =none                   extsz=4096   blocks=0, rtextents=0
> >> >
> >> > > What granularity are these A and B regions (sectors or larger)?
> >> > A is 1k, B is 3k.
> >> >
> >> > >Are you running on some kind of special block device that reproduces this?
> >> > It's a device we are developing,
> >> > asynchronous, which we believe obeys FLUSH and FUA correctly but may
> >> > have missed some case; we
> >> > encountered this issue when testing an XFS filesystem on it, and other
> >> > filesystems appear to work fine (although obviously we could have
> >> > merely gotten lucky). Currently, when a flush returns from the device,
> >> > we guarantee the data from all bios completed before the flush was
> >> > issued is stably on disk; when a write+FUA bio returns from the
> >> > device, the data in that bio (only) is guaranteed to be stable on disk. The
> >> > device may, however, commit sequentially issued write+fua bios to disk in an
> >> > arbitrary order.
> >> >
> >> > > Do you have a consistent reproducer and/or have you
> >> > reproduced on an upstream kernel
> >> > Our reproducer fails about 20% of the time. We have not tried on an
> >> > upstream kernel.
> >> >
> >>
> >> Please do try on something upstream if possible. Also, what exactly
> >> triggers the failure that ultimately leads to log recovery on the next
> >> mount? Are you doing an XFS shutdown or shutting down the block device
> >> underneath the fs?
> >>
> >> > >Could you provide an xfs_metadump image of the filesystem that fails log recovery with CRC errors?
> >> > I can capture such on Monday.
> >> > For now, just the journal (gathered with xfs_logprint -C fsLog) can be
> >> > found at (10M)
> >> > https://s3.amazonaws.com/permabit-development/20170609-xfsUpload/fsLog
> >> > .
> >>
> >> Thanks. This certainly looks a bit strange. Up through sectors 19692 of
> >> the log are populated with a cycle 2 LSN. After that appears to be the
> >> previous cycle 1, which suggests that is the head of the log. The tail
> >> then points to 1:20105, but from that point forward a strange mix of
> >> cycle 1 and cycle 2 LSNs are seen.
> >>
> >> It's not totally clear to me from the physical log state whether this
> >> was the in-core state at the time of the crash, but a first guess may be
> >> that at least this is what log recovery thinks and thus complains about
> >> the tail of the log being borked.
> >>
> >
> > Another observation and possible theory... the last two cycle 2 headers
> > in the log are:
> >
> >  20116 HEADER Cycle 2 tail 2:010284 len  32256 ops 288
> >  ...
> >  20180 HEADER Cycle 2 tail 2:010284 len  32256 ops 261
> >
> > ... which appear sanely spaced apart. They are mixed with cycle 1/2
> > changes, which seems to correspond with your observation that parts of
> > the 32k log buffers are succeeding and parts are failing. IOW, these log
> > records are effectively incomplete on disk.
> >
> > That accounts for 2 of 8 log buffers. If we assume these are the "last"
> > two log buffers, each log buffer is full and also spaced 64 sectors
> > apart, then the first log buffer would be targetting log sector (20116 -
> > 6 * 64) = 19732. That refers to the head of the on-disk log noted above:
> >
> >  ...
> >  19628 HEADER Cycle 2 tail 1:020105 len  32256 ops 327
> >  19692 HEADER Cycle 2 tail 1:020105 len  19968 ops 89
> >  19732 HEADER Cycle 1 tail 1:020105 len      0 ops 0
> > [00000 - 19732] Cycle 0x00000002 New Cycle 0x00000001
> >  19733 HEADER Cycle 1 tail 1:020105 len      0 ops 0
> >  ...
> >
> > So I'm wondering whether if it's possible that all of the log buffers
> > were dirty at the time of the crash, the last two were the only ones
> > that made it to disk, and they only made it partially at that. Further,
> > in partially writing those last two bufs at 20116 and beyond, we've
> > begun to overwrite the tail pointed to by the last record on disk before
> > the head (tail 1:020105 -> cycle 1 sector 20105), corrupting that
> > reference as well.
> >
> > There are also a bunch of the len == 0 headers at 19733 and beyond,
> > which I'm not quite clear on. I'm wondering if log recovery might
> > actually do that after it settles on a log head. That could mean there
> > actually was more cycle 2 data from other log bufs in that range but it
> > was all detected as invalid and cleared out during log recovery.
> >
> > When you grab the metadump to provide, can you make sure you do so
> > _before_ you attempt log recovery on the filesystem for the first time?
> > E.g., reproduce crash, umount & create metadump, mount and test for
> > corruption, if reproduce -> send metadump, else toss metadump & repeat.
> > This is because the first attempt at log recovery may modify the
> > physical log and cause some information loss if we take the metadump
> > after you've already attempted recovery.
> >
> > Brian
> >
> > P.S., I've also been assuming based on the log state that you haven't
> > used the logbufs/logbsize mount options to change from the defaults, but
> > please do confirm that you aren't changing either of those defaults.
> > Thanks.
> >
> >> > A log of the journal writes can be found at (17M)
> >> > https://s3.amazonaws.com/permabit-development/20170609-xfsUpload/log_writes_only.blkparse.
> >> > It is in a blkparse-like format. For each 512-byte sector of a bio,
> >> > either starting or finishing, the data hash is recorded; the sector is
> >> > recorded; and the index of this sector and the number of sectors
> >> > within the current bio is recorded. Bios recorded as "FAILED" indicate
> >> > that the device has crashed / become disconnected and the bio has
> >> > returned with an error.
> >> >
> >> > >From there, it searches a previous number of blocks
> >> > based on the maximum log buffer concurrency allowed by the fs to
> >> > determine whether any such "holes" exist in that range. If so, the head
> >> > is walked back to the first instance of such a "hole," effectively
> >> > working around out of order buffer completion at the time of a
> >> > filesystem crash.
> >> >
> >> > In the case logged and linked above, there are 256k of outstanding log
> >> > write bytes at once; 187k of these fail and 69k succeed. Of the 69k which
> >> > succeed, they are always the first 1k of the 4k block to which they
> >> > belong. Is this within the permitted amount of outstanding log buffers?
> >> >
> >>
> >> Generally, yes. Log recovery uses the maximum in-core log buffer count
> >> (8) and the maximum supported log buffer size (256k) to determine how
> >> far to look back (2M). The default log buffer size is 32k, so I suspect
> >> 256k means every log buffer was in-flight at this time.
> >>
> >> When you reproduce this and presumably provide a metadump, could you
> >> also collect the /sys/fs/xfs/<dev>/log/* state information at the time
> >> of the crash of that particular metadump? Note that this directory
> >> disappears after unmount so you'll have to collect it before.
> >>
> >> Brian
> >>
> >> > Thanks!
> >> >
> >> > Sweet Tea
> >> >
> >> > On Fri, Jun 9, 2017 at 7:44 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > > On Thu, Jun 08, 2017 at 11:42:11AM -0400, Sweet Tea Dorminy wrote:
> >> > >> Greetings;
> >> > >>
> >> > >> When using XFS with a 1k block size atop our device, we regularly get
> >> > >> "log record CRC mismatch"es when mounting XFS after a crash, and we
> >> > >> are attempting to understand why. We are using RHEL7.3 with its kernel
> >> > >> 3.10.0-514.10.2.el7.x86_64, xfsprogs version 4.5.0.
> >> > >>
> >> > >> Tracing indicates the following situation occurs:
> >> > >>        Some pair of consecutive locations contains data A1 and B1, respectively.
> >> > >>        The XFS journal issues new writes to those locations,
> >> > >> containing data A2 and B2.
> >> > >>        The write of B' finishes, but A' is still outstanding at the
> >> > >> time of the crash.
> >> > >>        Crash occurs. The data on disk is A1 and B2, respectively.
> >> > >>        XFS fails to mount, complaining that the checksum mismatches.
> >> > >>
> >> > >> Does XFS expect sequentially issued journal IO to be committed to disk
> >> > >> in the order of issuance due to the use of FUA?
> >> > >
> >> > > Journal IO is not sequentially issued. It's an async process. At
> >> > > runtime, ordering is handled by journal IO completion processing
> >> > > being queued and run in order, so IOs can both be issued and
> >> > > physically complete out of order.
> >> > >
> >> > > Log recovery is supposed to handle this. It searches and finds the
> >> > > latest contiguous journal entry and does not replay past holes that
> >> > > may arise from out of order journal writes.
> >> > >
> >> > > CRC errors like this in recovery imply that journal writes are being
> >> > > torn or not completed fully, which may mean that your storage does
> >> > > not correctly implement flush/FUA ordering semantics....
> >> > >
> >> > > Cheers,
> >> > >
> >> > > Dave.
> >> > > --
> >> > > Dave Chinner
> >> > > david@fromorbit.com
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
