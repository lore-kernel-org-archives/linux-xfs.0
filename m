Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DE86C7F37
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 15:18:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5CF7CAC001
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 13:18:08 -0700 (PDT)
Received: from mail-vc0-f174.google.com (mail-vc0-f174.google.com
	[209.85.220.174]) by cuda.sgi.com with ESMTP id
	DI2GZY3nUnEjKREL (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 16 Jul 2013 13:18:06 -0700 (PDT)
Received: by mail-vc0-f174.google.com with SMTP id kw10so799970vcb.19
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 13:18:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130716193332.GB3572@sgi.com>
References: <20130716015305.GB30569@redhat.com>
	<CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
	<20130716023847.GA31481@redhat.com>
	<CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
	<20130716060351.GE11674@dastard> <20130716193332.GB3572@sgi.com>
Date: Tue, 16 Jul 2013 13:18:06 -0700
Message-ID: <CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
Subject: Re: splice vs execve lockdep trace.
From: Linus Torvalds <torvalds@linux-foundation.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>, xfs@oss.sgi.com

On Tue, Jul 16, 2013 at 12:33 PM, Ben Myers <bpm@sgi.com> wrote:
>> >
>> > And looking more at that, I'm actually starting to think this is an
>> > XFS locking problem. XFS really should not call back to splice while
>> > holding the inode lock.

.. that was misleading, normally "inode lock" would be i_lock, but
here I meant the XFS-specific i_iolock.

But you clearly picked up on it:

> CPU0                            CPU1                            CPU2
> ----                            ----                            ----
> lock(&sig->cred_guard_mutex);
>                                 lock(&pipe->mutex/1);
>                                                                 lock(&(&ip->io_lock)->mr_lock);
> lock(&(&ip->io_lock)->mr_lock);
>                                 lock(&sig->cred_guard_mutex);
>                                                                 lock(&pipe->mutex/1);

Yup.

> I agree that fixing this in XFS seems to be the most reasonable plan,
> and Dave's approach looks ok to me.  Seems like patch 1 should go
> through Al's tree, but we'll also need to commit it to the xfs tree
> prerequisite to patch 2.

Btw, is there some reason why XFS couldn't just use
generic_file_splice_read() directly?

I'm not arguing against Dave's patches, since the splice_write case
would seem to want them regardless, but I'm not even seeing why XFS
couldn't just avoid the locking for the splice_read case entirely..And
the generic file-splice read function does all that read-ahead stuff
and should actually be better for performance. And because it does it
from the page cache, it can avoid the locking issues (because it gets
the splice pipe lock later, just holding on to the page references).

And splice has mmap semantics - the whole point of splice is about
moving pages around, after all - so I *think* your current
"xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);" is actually over-serialization.
The pages will be shared by the pipe buffers anyway, so splicing by
definition doesn't imply full data serialization (because the reading
of the data itself will happen much later).

So the per-page serialization done by readpage() should already be
sufficient, no?

I dunno. Maybe there's something I'm missing. XFS does seem to wrap
all the other generic functions in that lock too, but since mmap() etc
clearly have to be able to get things one page at a time (without any
wrapping at higher layers), I'm just wondering whether splice_read
might not be able to avoid it.

                     Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
