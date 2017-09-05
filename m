Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42566 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751835AbdIEOkI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Sep 2017 10:40:08 -0400
Date: Tue, 5 Sep 2017 10:40:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170905144006.GA48515@bfoster.bfoster>
References: <1504280365-25354-1-git-send-email-amir73il@gmail.com>
 <20170902131955.GB36492@bfoster.bfoster>
 <CAOQ4uxhLTtMV9FSr4um-dYefmpZ0NJseBiQzykxjy15kLqLsww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhLTtMV9FSr4um-dYefmpZ0NJseBiQzykxjy15kLqLsww@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, "stable [v4.9]" <stable@vger.kernel.org>

On Sat, Sep 02, 2017 at 06:47:03PM +0300, Amir Goldstein wrote:
> On Sat, Sep 2, 2017 at 4:19 PM, Brian Foster <bfoster@redhat.com> wrote:
> > On Fri, Sep 01, 2017 at 06:39:25PM +0300, Amir Goldstein wrote:
> >> When calling into _xfs_log_force{,_lsn}() with a pointer
> >> to log_flushed variable, log_flushed will be set to 1 if:
> >> 1. xlog_sync() is called to flush the active log buffer
> >> AND/OR
> >> 2. xlog_wait() is called to wait on a syncing log buffers
> >>
> >> xfs_file_fsync() checks the value of log_flushed after
> >> _xfs_log_force_lsn() call to optimize away an explicit
> >> PREFLUSH request to the data block device after writing
> >> out all the file's pages to disk.
> >>
> >> This optimization is incorrect in the following sequence of events:
> >>
> >>  Task A                    Task B
> >>  -------------------------------------------------------
> >>  xfs_file_fsync()
> >>    _xfs_log_force_lsn()
> >>      xlog_sync()
> >>         [submit PREFLUSH]
> >>                            xfs_file_fsync()
> >>                              file_write_and_wait_range()
> >>                                [submit WRITE X]
> >>                                [endio  WRITE X]
> >>                              _xfs_log_force_lsn()
> >>                                xlog_wait()
> >>         [endio  PREFLUSH]
> >>
> >> The write X is not guarantied to be on persistent storage
> >> when PREFLUSH request in completed, because write A was submitted
> >> after the PREFLUSH request, but xfs_file_fsync() of task A will
> >> be notified of log_flushed=1 and will skip explicit flush.
> >>
> >> If the system crashes after fsync of task A, write X may not be
> >> present on disk after reboot.
> >>
> >> This bug was discovered and demonstrated using Josef Bacik's
> >> dm-log-writes target, which can be used to record block io operations
> >> and then replay a subset of these operations onto the target device.
> >> The test goes something like this:
> >> - Use fsx to execute ops of a file and record ops on log device
> >> - Every now and then fsync the file, store md5 of file and mark
> >
> >>   md5 of file to stored value
> >>
> >> Cc: Christoph Hellwig <hch@lst.de>
> >> Cc: Josef Bacik <jbacik@fb.com>
> >> Cc: <stable@vger.kernel.org>
> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >> ---
> >>
> >> Christoph,
> >>
> >> Here is another, more subtle, version of the fix.
> >> It keeps a lot more use cases optimized (e.g. many threads doing fsync
> >> and setting WANT_SYNC may still be optimized).
> >> It also addresses your concern that xlog_state_release_iclog()
> >> may not actually start the buffer sync.
> >>
> >> I tried to keep the logic as simple as possible:
> >> If we see a buffer who is not yet SYNCING and we later
> >> see that l_last_sync_lsn is >= to the lsn of that buffer,
> >> we can safely say log_flushed.
> >>
> >> I only tested this patch through a few crash test runs, not even full
> >> xfstests cycle, so I am not sure it is correct, just posting to get
> >> your feedback.
> >>
> >> Is it worth something over the simpler v1 patch?
> >> I can't really say.
> >>
> >
> > This looks like it has a couple potential problems on a very quick look
> > (so I could definitely be mistaken). E.g., the lsn could be zero at the
> > time we set log_flushed in _xfs_log_force(). It also looks like waiting
> > on an iclog that is waiting to run callbacks due to out of order
> > completion could be interpreted as a log flush having occurred, but I
> > haven't stared at this long enough to say whether that is actually
> > possible.
> >
> > Stepping back from the details.. this seems like it could be done
> > correctly in general. IIUC what you want to know is whether any iclog
> > went from a pre-SYNCING state to a post-SYNCING state during the log
> > force, right? The drawbacks to this are that the log states do not by
> > design tell us whether devices have been flushed (landmine alert).
> > AFAICS, the last tail lsn isn't necessarily updated on every I/O
> > completion either.
> >
> > I'm really confused by the preoccupation with finding a way to keep this
> > fix localized to xfs_log_force(), as if that provides some inherent
> > advantage over fundamentally more simple code. If anything, the fact
> > that this has been broken for so long suggests that is not the case.
> >
> 
> Brian,
> 
> Don't let my motives confuse you, the localized approach has two reasons:
> 1. I though there may be a low hanging fix, because of already existing
>     lsn counters
> 2. I lack the experience and time to make the 'correct' fix you suggested
> 

Fair enough, but note that the "correct" fix was your idea (based on
hch's patch). :) I just suggested refactoring it out of the logging code
because there's no reason it needs to be buried there.

> > I'll reiterate my previous comment.. if we want to track device flush
> > submits+completes, please just track them directly in the buftarg using
> > the existing buffer flush flag and the common buffer
> > submission/completion paths that we already use for this kind of generic
> > mechanism (e.g., in-flight async I/O accounting, read/write verifiers).
> > I don't really see any benefit to this, at least until/unless we find
> > some reason to rule out the other approach.
> >
> 
> If I wasn't clear, my patch was not meant to object to your comment,
> just to display the alternative. If someone else posts a 'proper' patch
> I will test it with crash simulator. I recon that's not going to be
> for rc1 anyway.
> 

Thanks.. I agree that a rework of the optimization can come later now
that the bug is fixed.

Christoph, are you planning to continue with your flushseq based patch?

Brian

> Cheers,
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
