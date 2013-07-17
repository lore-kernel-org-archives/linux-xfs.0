Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D38D57F37
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 23:06:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B1CD68F8039
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 21:06:24 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	V7N0HXty9DapAU6s for <xfs@oss.sgi.com>;
	Tue, 16 Jul 2013 21:06:22 -0700 (PDT)
Date: Wed, 17 Jul 2013 14:06:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130717040616.GI11674@dastard>
References: <20130716015305.GB30569@redhat.com>
	<CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
	<20130716023847.GA31481@redhat.com>
	<CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
	<20130716060351.GE11674@dastard> <20130716193332.GB3572@sgi.com>
	<CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
	<20130716204335.GH11674@dastard>
	<CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Ben Myers <bpm@sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>, xfs@oss.sgi.com

On Tue, Jul 16, 2013 at 02:02:12PM -0700, Linus Torvalds wrote:
> On Tue, Jul 16, 2013 at 1:43 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Yes - IO is serialised based on the ip->i_iolock, not i_mutex. We
> > don't use i_mutex for many things IO related, and so internal
> > locking is needed to serialise against stuff like truncate, hole
> > punching, etc, that are run through non-vfs interfaces.
> 
> Umm. But the page IO isn't serialized by i_mutext *either*. You don't
> hold it across page faults. In fact you don't even take it at all
> across page faults.

Right, and that's one of the biggest problems page based IO has - we
can't serialise it against other IO and other page cache
manipulation functions like hole punching. What happens when a
splice read or mmap page fault races with a hole punch? You get
stale data being left in the page cache because we can't serialise
the page read with the page cache invalidation and underlying extent
removal.

Indeed, why do you think we've been talking about VFS-level IO range
locking for the past year or more, and had a discussion session at
LSF/MM this year on it? i.e. this:

http://lwn.net/Articles/548939/

So forget about this "we don't need no steenkin' IO serialisation"
concept - it's fundamentally broken.

FWIW, hole punching in XFS takes the i_iolock in exclusive
mode, and hence serialises correctly against splice. IOWs, there is
a whole class of splice read data corruption race conditions that
XFS is not susceptible to but....

> *Every* other local filesystem uses generic_file_splice_read() with
> just a single
> 
>      .splice_read = generic_file_splice_read,

... and so they all are broken in a nasty, subtle way....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
