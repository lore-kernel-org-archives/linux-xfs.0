Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 00C027F3F
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 23:54:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B7A078F8039
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 21:54:11 -0700 (PDT)
Received: from mail-ve0-f176.google.com (mail-ve0-f176.google.com
	[209.85.128.176]) by cuda.sgi.com with ESMTP id
	A5oau7716Q98EYOg (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 16 Jul 2013 21:54:10 -0700 (PDT)
Received: by mail-ve0-f176.google.com with SMTP id c13so1135280vea.7
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 21:54:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130717040616.GI11674@dastard>
References: <20130716015305.GB30569@redhat.com>
	<CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
	<20130716023847.GA31481@redhat.com>
	<CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
	<20130716060351.GE11674@dastard> <20130716193332.GB3572@sgi.com>
	<CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
	<20130716204335.GH11674@dastard>
	<CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
	<20130717040616.GI11674@dastard>
Date: Tue, 16 Jul 2013 21:54:09 -0700
Message-ID: <CA+55aFz5xw9Qi9Q6mwoCSud5eQh5u-QZ-xrY+TqgZPoKOgn6ew@mail.gmail.com>
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

On Tue, Jul 16, 2013 at 9:06 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Right, and that's one of the biggest problems page based IO has - we
> can't serialise it against other IO and other page cache
> manipulation functions like hole punching. What happens when a
> splice read or mmap page fault races with a hole punch? You get
> stale data being left in the page cache because we can't serialise
> the page read with the page cache invalidation and underlying extent
> removal.

But Dave, that's *good*.

You call it "stale data".

I call it "the data was valid at some point".

This is what "splice()" is fundamentally all about.

Think of it this way: even if you are 100% serialized during the
"splice()" operation, what do you think happens afterwards?

Seriously, think it through.

That data is in a kernel buffer - the pipe. The fact that it was
serialized at the time of the original splice() doesn't make _one_
whit of a difference, because after the splice is over, the data still
sits around in that pipe buffer, and you're no longer serializing it.
Somebody else truncating the file or punching a hole in the file DOES
NOT MATTER. It's too late.

In other words, trying to "protect" against that kind of race is stupid.

You're missing the big picture because you're concentrating on the
details. Look beyond what happens inside XFS, and think about the
higher-level meaning of splice() itself.

So the only guarantee splice *should* give is entirely per-page. If
you think it gives any other serialization, you're fundamentally
wrong, because it *cannot*. See?

                     Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
