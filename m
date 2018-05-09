Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:43573 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965902AbeEIXW5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 19:22:57 -0400
Date: Thu, 10 May 2018 09:22:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: WARNING: bad unlock balance in xfs_iunlock
Message-ID: <20180509232254.GQ10363@dastard>
References: <20180406161053.GF7500@magnolia>
 <CACT4Y+aaEOffkFA-B-hMzwzSiQwVpkPrc2udC087a55OTnkS4g@mail.gmail.com>
 <95c1400b-94f2-1af4-2d5d-c61c274c28ff@sandeen.net>
 <CACT4Y+aiwgRg5pk+N7bq9HYpgumTFyqG6-y3EZ8pWkq9-uB1aA@mail.gmail.com>
 <9f8d657c-7f42-7bd9-4477-6c3addf16dee@sandeen.net>
 <CACT4Y+bUx4jw83Ux7w9URL9bCy1ERLaVGTTwvA9Fe_UtLFeqCw@mail.gmail.com>
 <d7c8e0eb-61ed-1aad-6faa-82a0ef8c25b8@sandeen.net>
 <CACT4Y+YNRt5YSrOYKKFUP25jodpK0xeZhysSGoz2UaiGs_Gx=A@mail.gmail.com>
 <9adacfed-0de6-cb94-bf14-3e639678a02a@sandeen.net>
 <CACT4Y+Ya0cSP7eKjzcbfxQHYLJeR8Qnp_f4MwcM_QU91unnD5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Ya0cSP7eKjzcbfxQHYLJeR8Qnp_f4MwcM_QU91unnD5w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Theodore Ts'o <tytso@mit.edu>, syzkaller <syzkaller@googlegroups.com>

On Wed, May 09, 2018 at 10:43:05AM +0200, Dmitry Vyukov wrote:
> Does "xfstests fuzzing infrastructure" use coverage-guidance?

It's guided manually to fuzz a substantial proportion of the fields
in the on-disk format that are susceptible to fuzzing bqased
attacks. It's not complete coverage yet, but it's getting better and
better, and we're finding more problems from it that random bit
based fuzzing has ever uncovered.

Also, the xfstests fuzzing defeats the CRC protection now built into
the metadata, which means it can exercise all the new filesystem
features that random bit fuzzers cannot exercise. That's the problem
with fuzzers like syzbot - they can only usefully fuzz the legacy
filesystem format which doesn't have CRC validation, nor many of the
other protections that the current filesystem format has to detect
corruption. This will also allow us to test things like online
repair of fuzzed structures....

Random bit perturbation filesystem image fuzzing was state of the
art ~10 years ago.  They were made redundant by filesystems like
XFS and ext4 adding metadata CRC checking ~5 years ago. The legacy
filesystem formats are essentially unfixable, and it's largely a
waste of time to be trying to make them robust against random bit
fuzzing because such random bit corruptions (like the syzbot images)
do not occur in the real world.

IOWs, we've had to advance the "state of the art" ourselves because
nobody else in the fuzzing world responded to the fact we've
essentially defeated random bit image fuzzing. Not only that, we
have our own infrastructure that produces repeatable, understandable
and debuggable failures, and this is something that many 3rd party
fuzzing efforts do not provide us with.

> If not, it would be useful to add. Among some solutions there are
> LibFuzzer (https://llvm.org/docs/LibFuzzer.html), AFL >
> (http://lcamtuf.coredump.cx/afl/), kernel-fuzzing
> (https://github.com/oracle/kernel-fuzzing).  I don't know how
> xfstests fuzzing works, so I can't say what would be more suitable
> there.

I think only AFL would be a usable infrastructure, but it would
require being taught about the ondisk format so it could perturb the
image in ways that are useful to modern filesystem formats. Lots(!)
of work, and it's not clear it would do any better than what we
already have.

Given the results we're getting from our own fuzzers, I don't see
much point in (XFS developers) investing huge amounts of effort to
make some other fuzzer equivalent to what we already have. If
someone else starts fuzzing the current format (v5) XFS filesystems
and finding problems we haven't, then I'm going to be interested in
their fuzzing tools.  But (guided) random bit perturbation fuzzing
of legacy filesystem formats is really not that useful or
interesting to us right now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
