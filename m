Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AE04C7F37
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 16:02:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 52FE5AC003
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 14:02:15 -0700 (PDT)
Received: from mail-vc0-f182.google.com (mail-vc0-f182.google.com
	[209.85.220.182]) by cuda.sgi.com with ESMTP id
	wVkalFYS8A9JPy06 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 16 Jul 2013 14:02:14 -0700 (PDT)
Received: by mail-vc0-f182.google.com with SMTP id id13so825082vcb.41
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 14:02:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130716204335.GH11674@dastard>
References: <20130716015305.GB30569@redhat.com>
	<CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
	<20130716023847.GA31481@redhat.com>
	<CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
	<20130716060351.GE11674@dastard> <20130716193332.GB3572@sgi.com>
	<CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
	<20130716204335.GH11674@dastard>
Date: Tue, 16 Jul 2013 14:02:12 -0700
Message-ID: <CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Ben Myers <bpm@sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>, xfs@oss.sgi.com

On Tue, Jul 16, 2013 at 1:43 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Yes - IO is serialised based on the ip->i_iolock, not i_mutex. We
> don't use i_mutex for many things IO related, and so internal
> locking is needed to serialise against stuff like truncate, hole
> punching, etc, that are run through non-vfs interfaces.

Umm. But the page IO isn't serialized by i_mutext *either*. You don't
hold it across page faults. In fact you don't even take it at all
across page faults.

That's kind of my point. splice is about the page IO, and it's
serialized purely by the page lock. And then "->readpage()" will get
whatever IO mutex in order to do that right, but think about the case
where things are already in the page cache. There's no reason for any
serialization what-so-ever.

So this isn't about i_mutex. At all.

> Read isn't the problem - it's write that's the deadlock issue...

I agree, and I think your patches are needed, as I said in that email
you replied to. But due to this issue, I was looking at the XFS splice
support, and the read-side splice support seems inefficient and overly
complex. I'm not seeing why it needs that i_iolock.

And no, this really has nothing to do with i_mutex. Go look at
generic_file_splice_read(). There's no i_mutex there at all. It's more
like a series of magic page-faults without the actual page table
actions. Which is kind of the whole point of splice - zero-copy
without bothering with page table setup/teardown.

Now, it's perfectly possible that XFS really needs some odd locking
here, but your reply about i_mutex makes me think that you did it
because you were confused about what it actually wants.

*Every* other local filesystem uses generic_file_splice_read() with
just a single

     .splice_read = generic_file_splice_read,

in the file ops initializer.  Sure, nfs and ocfs2 wrap things like xfs
does, but they basically do it to revalidate their caches.

                     Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
