Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:47640 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751330AbeCMFKl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 01:10:41 -0400
Date: Tue, 13 Mar 2018 16:10:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO writes
Message-ID: <20180313051037.GC18129@dastard>
References: <20180301014144.28892-1-david@fromorbit.com>
 <CAA9_cmebHisbzU9CHVpq77UrtCTev_yT=3_SWhUX5oZNOJZwcw@mail.gmail.com>
 <CY4PR21MB074130B753A5BF81332A5171B8D20@CY4PR21MB0741.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR21MB074130B753A5BF81332A5171B8D20@CY4PR21MB0741.namprd21.prod.outlook.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Robert Dorr <rdorr@microsoft.com>
Cc: Dan Williams <dan.j.williams@intel.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Scott Konersmann <scottkon@microsoft.com>, Slava Oks <slavao@microsoft.com>, Jasraj Dange <jasrajd@microsoft.com>, Michael Nelson <micn@microsoft.com>

On Tue, Mar 13, 2018 at 12:15:28AM +0000, Robert Dorr wrote:
> Hello all.  I have a couple of follow-up questions around this
> effort, thanks you all for all your kind inputs, patience and
> knowledge transfer.
> 
> 1.    How does xfs or ext4 make sure a pattern of WS followed by
> FWS does not allow the write (WS) completion to be visible before
> the flush completes?

I'm not sure what you are asking here. You need to be more precise
about what these IOs are, who dispatched them and what their
dependencies are. Where exactly did that FWS (REQ_FLUSH) come from?

I think, though, you're asking questions about IO ordering at the
wrong level - filesystems serialise and order IO, not the block
layer. Hence what you see at the block layer is not necessary a
reflection of the ordering the filesystem is doing.

(I've already explained this earlier today in a different thread:
https://marc.info/?l=linux-xfs&m=152091489100831&w=2)

That's why I ask about the operation causing a REQ_FLUSH to be
issued to the storage device, as that cannot be directly issued from
userspace. It will occur as a side effect of a data integrity
operation the filesystem is asked to perform, but without knowing
the relationship between the integrity operation and the write in
question an answer cannot be given.

It may would be better to describe your IO ordering and integrity
requirements at a higher level (e.g. the syscall layer), because
then we know what you are trying to acheive rather that trying to
understand your problem from context-less questions about "IO
barriers" that don't actually exist...

> I suspected the write was held in
> iomap_dio_complete_work but with the generic_write_sync change in
> the patch would a O_DSYNC write request to a DpoFua=0 block queue
> allow T2 to see the completion via io_getevents before T1
> completed the actual flush?

Yes, that can happen as concurrent data direct IO are not serialised
against each other and will always race to completion without
providing any ordering guarantees.  IOWs, if you have an IO ordering
dependency in your application, then that ordering dependency needs
to be handled in the application.

> 2.    How will my application be able to dynamically determine if
> xfs and ext4 have the performance enhancement for FUA or I need
> engage alternate methods to use fsync/fdatasync at strategic
> locations?

You don't. The filesystem will provide the same integrity guarantees
in either case - FUA is just a performance optimisation that will
get used if your hardware supports it. Applications should not care
what capabilities the storage hardawre has - the kernel should do
what is fastest and most reliable for the underlying storage....

> 3.    Are there any plans yet to optimize ext4 as well?

Not from me.

> 4.    Before the patched code the xfs_file_write_iter would call
> generic_write_sync and that calls submit_io_wait.  Does this hold
> the thread issuing the io_submit so it is unable to drive more
> async I/O?

No, -EIOCBQUEUED is returned to avoid blocking.
AIO calls generic_write_sync() from the IO completion
path via a worker thread so it's all done asynchronously.


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
