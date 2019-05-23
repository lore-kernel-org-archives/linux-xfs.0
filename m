Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730829AbfEWP1o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 May 2019 11:27:44 -0400
Date: Thu, 23 May 2019 11:27:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] kernel.h: Add generic roundup_64() macro
Message-ID: <20190523112740.7167aba4@gandalf.local.home>
In-Reply-To: <CAHk-=wg5HqJ2Kfgpub+tCWQ2_FiFwEW9H1Rm+an-BLGaGvDDXw@mail.gmail.com>
References: <20190523100013.52a8d2a6@gandalf.local.home>
        <CAHk-=wg5HqJ2Kfgpub+tCWQ2_FiFwEW9H1Rm+an-BLGaGvDDXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, dri-devel <dri-devel@lists.freedesktop.org>, nouveau@lists.freedesktop.org, linux-rdma <linux-rdma@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Thu, 23 May 2019 08:10:44 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, May 23, 2019 at 7:00 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > +# define roundup_64(x, y) (                            \
> > +{                                                      \
> > +       typeof(y) __y = y;                              \
> > +       typeof(x) __x = (x) + (__y - 1);                \
> > +       do_div(__x, __y);                               \
> > +       __x * __y;                                      \
> > +}                                                      \
> 
> The thing about this is that it absolutely sucks for power-of-two arguments.
> 
> The regular roundup() that uses division has the compiler at least
> optimize them to shifts - at least for constant cases. But do_div() is
> meant for "we already know it's not a power of two", and the compiler
> doesn't have any understanding of the internals.
> 
> And it looks to me like the use case you want this for is very much
> probably a power of two. In which case division is all kinds of just
> stupid.
> 
> And we already have a power-of-two round up function that works on
> u64. It's called "round_up()".
> 
> I wish we had a better visual warning about the differences between
> "round_up()" (limited to powers-of-two, but efficient, and works with
> any size) and "roundup()" (generic, potentially horribly slow, and
> doesn't work for 64-bit on 32-bit).
> 
> Side note: "round_up()" has the problem that it uses "x" twice.
> 
> End result: somebody should look at this, but I really don't like the
> "force division" case that is likely horribly slow and nasty.

I haven't yet tested this, but what about something like the following:

# define roundup_64(x, y) (				\
{							\
	typeof(y) __y;					\
	typeof(x) __x;					\
							\
	if (__builtin_constant_p(y) &&			\
	    !(y & (y >> 1))) {				\
		__x = round_up(x, y);			\
	} else {					\
		__y = y;				\
		__x = (x) + (__y - 1);			\
		do_div(__x, __y);			\
		__x = __x * __y;			\
	}						\
	__x;						\
}							\
)

If the compiler knows enough that y is a power of two, it will use the
shift version. Otherwise, it doesn't know enough and would divide
regardless. Or perhaps forget about the constant check, and just force
the power of two check:

# define roundup_64(x, y) (				\
{							\
	typeof(y) __y = y;				\
	typeof(x) __x;					\
							\
	if (!(__y & (__y >> 1))) {			\
		__x = round_up(x, y);			\
	} else {					\
		__x = (x) + (__y - 1);			\
		do_div(__x, __y);			\
		__x = __x * __y;			\
	}						\
	__x;						\
}							\
)

This way even if the compiler doesn't know that this is a power of two,
it will still do the shift if y ends up being one.

-- Steve
