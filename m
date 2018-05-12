Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:42822 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750776AbeELBQR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 21:16:17 -0400
Date: Sat, 12 May 2018 11:16:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: WARNING: bad unlock balance in xfs_iunlock
Message-ID: <20180512011610.GB23861@dastard>
References: <95c1400b-94f2-1af4-2d5d-c61c274c28ff@sandeen.net>
 <CACT4Y+aiwgRg5pk+N7bq9HYpgumTFyqG6-y3EZ8pWkq9-uB1aA@mail.gmail.com>
 <9f8d657c-7f42-7bd9-4477-6c3addf16dee@sandeen.net>
 <CACT4Y+bUx4jw83Ux7w9URL9bCy1ERLaVGTTwvA9Fe_UtLFeqCw@mail.gmail.com>
 <d7c8e0eb-61ed-1aad-6faa-82a0ef8c25b8@sandeen.net>
 <CACT4Y+YNRt5YSrOYKKFUP25jodpK0xeZhysSGoz2UaiGs_Gx=A@mail.gmail.com>
 <9adacfed-0de6-cb94-bf14-3e639678a02a@sandeen.net>
 <CACT4Y+Ya0cSP7eKjzcbfxQHYLJeR8Qnp_f4MwcM_QU91unnD5w@mail.gmail.com>
 <20180509232254.GQ10363@dastard>
 <CACT4Y+ZpyBVD3yhNxV-7fpKbCOm975kHDmxbHwpU6t13kK=FGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZpyBVD3yhNxV-7fpKbCOm975kHDmxbHwpU6t13kK=FGw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Theodore Ts'o <tytso@mit.edu>, syzkaller <syzkaller@googlegroups.com>

On Fri, May 11, 2018 at 10:59:53AM +0200, Dmitry Vyukov wrote:
> On Thu, May 10, 2018 at 1:22 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, May 09, 2018 at 10:43:05AM +0200, Dmitry Vyukov wrote:
> >> Does "xfstests fuzzing infrastructure" use coverage-guidance?
> >
> > It's guided manually to fuzz a substantial proportion of the fields
> > in the on-disk format that are susceptible to fuzzing bqased
> > attacks. It's not complete coverage yet, but it's getting better and
> > better, and we're finding more problems from it that random bit
> > based fuzzing has ever uncovered.
> >
> > Also, the xfstests fuzzing defeats the CRC protection now built into
> > the metadata, which means it can exercise all the new filesystem
> > features that random bit fuzzers cannot exercise. That's the problem
> > with fuzzers like syzbot - they can only usefully fuzz the legacy
> > filesystem format which doesn't have CRC validation, nor many of the
> > other protections that the current filesystem format has to detect
> > corruption. This will also allow us to test things like online
> > repair of fuzzed structures....
> 
> syzkaller has 2 techniques to deal with checksums, if you are
> interested I can go into more detail.

You can if you want, but I'm betting it basically comes down to
teaching syzcaller about parts of the on-disk format, similar to
AFL. And, like AFL, I doubt any XFS developer has the time to
add such support to syzbot.

> > Given the results we're getting from our own fuzzers, I don't see
> > much point in (XFS developers) investing huge amounts of effort to
> > make some other fuzzer equivalent to what we already have. If
> > someone else starts fuzzing the current format (v5) XFS filesystems
> > and finding problems we haven't, then I'm going to be interested in
> > their fuzzing tools.  But (guided) random bit perturbation fuzzing
> > of legacy filesystem formats is really not that useful or
> > interesting to us right now.
> 
> Just asked.
> 
> Note that coverage-guidance does not necessary mean bit flipping.
> syzkaller combines coverage-guidance with grammar-awareness and other
> smartness.

Yup, I assumed that this would be the case - those sorts of
"directed fuzzing" techniques were pioneered by the Samba guys for
reverse engineering the SMB protocol used by MS servers all those
years ago. But at it's most basic level, it's still using bit
flipping techniques to perturb the input and provoke responses.

> Based on our experience with network testing, main advantage of
> syzkaller over just feeding blobs as network packets (even if these
> blobs are built in a very smart way) is the following. syzkaller can
> build complex interactions between syscalls, external inputs and
> blobs.

Yup, nothing new there - that's what every other filesystem fuzzer
infrastructure does, too.  The problem with this is that it doesn't
pin-point the actual operation that tripped over the on-disk
corruption. It's catching downstream symptoms of an unknown,
undetected on-disk format corruption. i.e. it's a poor substitute
for explicit testing of structure bounds and data relationships of a
known format.

That's the fundamental premise of fuzz testing - most software does
not have robust validation of it's inputs and so fuzzing those
inputs finds problems. We've moved on from the old "trust and don't
validate" model of filesystem structure architecture.  The on-disk
format is very well defined, it is constrained in most cases, and we
can validate most individual structures at runtime with relatively
little cost.

Hence the "structure bounds" exploits that fuzzers tend to exercise
are pretty much taken out of the picture, and that leaves us with
"data relationships" between structures as the main vector for
undetected corruptions. These are mostly detectable, and many are
correctable as the current on-disk format has a lot of redundant
information. So the space for fuzzers to detect problems is getting
smaller and smaller all the time.

IOWs, filesystem image fuzzers have their place, but if you want us
to take your fuzzing seriously then your fuzzer needs to understand
all the mechanisms we now use to detect corruptions to show us where
they are deficient. If your fuzzing doesn't expose flaws in our
current validation techniques, then it's really not useful to us.

> For example, handling of external network packets depend on if
> there is an open socket on that port, what setsockopts were called, if
> there is a pending receive, what flags were passed to that receive,
> were some data sent the other way, etc. For filesystems that would be
> various filesystem syscalls executed against the mounted image,
> concurrent umount, rebind, switch to read-only mode, etc.
> But maybe xfstests do this too, I don't know. Do they?

Generally there is no need to do this because we know exactly what
syscalls will trigger access and/or modification to on-disk
structures. Access to the on-disk structures triggers the built in
verifier infrastructure, which then catches the majority of
corruptions before the structure is used by anything in the kernel.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
