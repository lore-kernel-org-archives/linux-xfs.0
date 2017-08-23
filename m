Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:35659 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751112AbdHWX7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2017 19:59:50 -0400
Date: Thu, 24 Aug 2017 09:59:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Bug Report
Message-ID: <20170823235946.GA21024@dastard>
References: <CAFzqJcahyU7F5CJcYKTPabWBVCnufwSMS4QcJijHVVux-Ndv+Q@mail.gmail.com>
 <ad807068-5de9-3200-68ef-de9e42401a5a@sandeen.net>
 <20170822232831.GY21024@dastard>
 <20170823163543.GX4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170823163543.GX4796@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Ruoxin Jiang <rj2394@columbia.edu>, linux-xfs@vger.kernel.org, Suman Jana <sumanj@gmail.com>

On Wed, Aug 23, 2017 at 09:35:43AM -0700, Darrick J. Wong wrote:
> On Wed, Aug 23, 2017 at 09:28:31AM +1000, Dave Chinner wrote:
> > On Tue, Aug 22, 2017 at 05:33:24PM -0500, Eric Sandeen wrote:
> > > On 8/22/17 4:10 PM, Ruoxin Jiang wrote:
> > > > Hello,
> > > > 
> > > > We are researchers from Columbia University, New York. As part of our
> > > > current research we have run into some issues using xfs filesystem.
> > > > For example, we encountered a case where the setuid bit of a modified
> > > > executable was not removed as desired.
> > > 
> > > Thanks for the reports.
> > > 
> > > For case 1:
> > > 
> > > > * In xfs, function `xfs_file_aio_write_checks` calls `file_remove_privs` which
> > > > removes special file priviledges when the executable is written to or truncated.
> > > > 
> > > > * If an DIO write is not aligned to device logical sector size, the syscall
> > > > fails with  EINVAL` before `xfs_file_aio_write_checks` is called. Thus the setuid
> > > > bit will not be removed from the modified executable.
> > > 
> > > If the write did not happen, why should the setuid bit be removed?
> > > The write failed and the file's contents were not modified.  It seems
> > > like xfs's behavior makes sense; is there a posix specification that
> > > indicates the behavior should be different?
> > > 
> > > Case 2 does look problematic (failed mmap write extending the file EOF)
> > 
> > mmap should not be able to extend the file at all. It should segv
> > if an attempt to write past EOF occurs.

....
> Create a 48k mapping at 0x20000000 to some anonymous memory... with
> PROT_NONE.
> 
>   r[5] = syscall(__NR_write, r[0], 0x2000b000ul, 0x1ul, 0, 0, 0, 0, 0, 0);
>   printf("write()=%ld, errno=%d\n", r[5], errno);
> 
> Then try to write 1 byte to r0 (whose pos is 10) from this anonymous
> region, which bails out with EFAULT because the region is PROT_NONE.
> This is effectively pwrite(r[0], <unreadable>, 1, 10);

My bad - I didn't look at the code for that case, I was just
commenting on Eric's statement about mmap extending the file.

> Therefore, it's not an mmap write that extends the file length, it's the
> write call that moves out EOF in preparation for the write, only to have
> the buffered write fail because the process doesn't have read access to
> the memory buffer.
> 
> Not sure what to do about this corner case, though -- I guess you could
> check that at least the first byte of the write will succeed, and only
> then call xfs_zero_eof.  Could still be a TOCTOU race though.
> 
> Thoughts?

The zeroing succeeded, yes? So there's no stale data exposure at
all?

Given it's such a whacky corner case, do we really care what
happens to the file size on error as long as we don't expose stale
data?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
