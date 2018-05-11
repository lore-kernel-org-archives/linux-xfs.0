Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f46.google.com ([209.85.160.46]:43244 "EHLO
        mail-pl0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752812AbeEKJAP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 05:00:15 -0400
Received: by mail-pl0-f46.google.com with SMTP id a39-v6so2922907pla.10
        for <linux-xfs@vger.kernel.org>; Fri, 11 May 2018 02:00:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180509232254.GQ10363@dastard>
References: <20180406161053.GF7500@magnolia> <CACT4Y+aaEOffkFA-B-hMzwzSiQwVpkPrc2udC087a55OTnkS4g@mail.gmail.com>
 <95c1400b-94f2-1af4-2d5d-c61c274c28ff@sandeen.net> <CACT4Y+aiwgRg5pk+N7bq9HYpgumTFyqG6-y3EZ8pWkq9-uB1aA@mail.gmail.com>
 <9f8d657c-7f42-7bd9-4477-6c3addf16dee@sandeen.net> <CACT4Y+bUx4jw83Ux7w9URL9bCy1ERLaVGTTwvA9Fe_UtLFeqCw@mail.gmail.com>
 <d7c8e0eb-61ed-1aad-6faa-82a0ef8c25b8@sandeen.net> <CACT4Y+YNRt5YSrOYKKFUP25jodpK0xeZhysSGoz2UaiGs_Gx=A@mail.gmail.com>
 <9adacfed-0de6-cb94-bf14-3e639678a02a@sandeen.net> <CACT4Y+Ya0cSP7eKjzcbfxQHYLJeR8Qnp_f4MwcM_QU91unnD5w@mail.gmail.com>
 <20180509232254.GQ10363@dastard>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 11 May 2018 10:59:53 +0200
Message-ID: <CACT4Y+ZpyBVD3yhNxV-7fpKbCOm975kHDmxbHwpU6t13kK=FGw@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in xfs_iunlock
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Theodore Ts'o <tytso@mit.edu>, syzkaller <syzkaller@googlegroups.com>

On Thu, May 10, 2018 at 1:22 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, May 09, 2018 at 10:43:05AM +0200, Dmitry Vyukov wrote:
>> Does "xfstests fuzzing infrastructure" use coverage-guidance?
>
> It's guided manually to fuzz a substantial proportion of the fields
> in the on-disk format that are susceptible to fuzzing bqased
> attacks. It's not complete coverage yet, but it's getting better and
> better, and we're finding more problems from it that random bit
> based fuzzing has ever uncovered.
>
> Also, the xfstests fuzzing defeats the CRC protection now built into
> the metadata, which means it can exercise all the new filesystem
> features that random bit fuzzers cannot exercise. That's the problem
> with fuzzers like syzbot - they can only usefully fuzz the legacy
> filesystem format which doesn't have CRC validation, nor many of the
> other protections that the current filesystem format has to detect
> corruption. This will also allow us to test things like online
> repair of fuzzed structures....

syzkaller has 2 techniques to deal with checksums, if you are
interested I can go into more detail.

> Random bit perturbation filesystem image fuzzing was state of the
> art ~10 years ago.  They were made redundant by filesystems like
> XFS and ext4 adding metadata CRC checking ~5 years ago. The legacy
> filesystem formats are essentially unfixable, and it's largely a
> waste of time to be trying to make them robust against random bit
> fuzzing because such random bit corruptions (like the syzbot images)
> do not occur in the real world.

Note there are also specifically crafted images that can be
automounted whenever one plugs something into USB.

> IOWs, we've had to advance the "state of the art" ourselves because
> nobody else in the fuzzing world responded to the fact we've
> essentially defeated random bit image fuzzing. Not only that, we
> have our own infrastructure that produces repeatable, understandable
> and debuggable failures, and this is something that many 3rd party
> fuzzing efforts do not provide us with.
>
>> If not, it would be useful to add. Among some solutions there are
>> LibFuzzer (https://llvm.org/docs/LibFuzzer.html), AFL >
>> (http://lcamtuf.coredump.cx/afl/), kernel-fuzzing
>> (https://github.com/oracle/kernel-fuzzing).  I don't know how
>> xfstests fuzzing works, so I can't say what would be more suitable
>> there.
>
> I think only AFL would be a usable infrastructure, but it would
> require being taught about the ondisk format so it could perturb the
> image in ways that are useful to modern filesystem formats. Lots(!)
> of work, and it's not clear it would do any better than what we
> already have.
>
> Given the results we're getting from our own fuzzers, I don't see
> much point in (XFS developers) investing huge amounts of effort to
> make some other fuzzer equivalent to what we already have. If
> someone else starts fuzzing the current format (v5) XFS filesystems
> and finding problems we haven't, then I'm going to be interested in
> their fuzzing tools.  But (guided) random bit perturbation fuzzing
> of legacy filesystem formats is really not that useful or
> interesting to us right now.

Just asked.

Note that coverage-guidance does not necessary mean bit flipping.
syzkaller combines coverage-guidance with grammar-awareness and other
smartness.

Based on our experience with network testing, main advantage of
syzkaller over just feeding blobs as network packets (even if these
blobs are built in a very smart way) is the following. syzkaller can
build complex interactions between syscalls, external inputs and
blobs. For example, handling of external network packets depend on if
there is an open socket on that port, what setsockopts were called, if
there is a pending receive, what flags were passed to that receive,
were some data sent the other way, etc. For filesystems that would be
various filesystem syscalls executed against the mounted image,
concurrent umount, rebind, switch to read-only mode, etc.
But maybe xfstests do this too, I don't know. Do they?
