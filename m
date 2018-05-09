Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:40792 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934318AbeEIIn0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 04:43:26 -0400
Received: by mail-pg0-f65.google.com with SMTP id l2-v6so22357648pgc.7
        for <linux-xfs@vger.kernel.org>; Wed, 09 May 2018 01:43:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9adacfed-0de6-cb94-bf14-3e639678a02a@sandeen.net>
References: <f403043cbe8414177d0568e81405@google.com> <20180403043854.GL1150@dastard>
 <CACT4Y+ZadV0xTqhiGTAHmadAnYaSfPKhUy_TFXMza2o_n8+o9w@mail.gmail.com>
 <20180405213844.GE23861@dastard> <20180406161053.GF7500@magnolia>
 <CACT4Y+aaEOffkFA-B-hMzwzSiQwVpkPrc2udC087a55OTnkS4g@mail.gmail.com>
 <95c1400b-94f2-1af4-2d5d-c61c274c28ff@sandeen.net> <CACT4Y+aiwgRg5pk+N7bq9HYpgumTFyqG6-y3EZ8pWkq9-uB1aA@mail.gmail.com>
 <9f8d657c-7f42-7bd9-4477-6c3addf16dee@sandeen.net> <CACT4Y+bUx4jw83Ux7w9URL9bCy1ERLaVGTTwvA9Fe_UtLFeqCw@mail.gmail.com>
 <d7c8e0eb-61ed-1aad-6faa-82a0ef8c25b8@sandeen.net> <CACT4Y+YNRt5YSrOYKKFUP25jodpK0xeZhysSGoz2UaiGs_Gx=A@mail.gmail.com>
 <9adacfed-0de6-cb94-bf14-3e639678a02a@sandeen.net>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 9 May 2018 10:43:05 +0200
Message-ID: <CACT4Y+Ya0cSP7eKjzcbfxQHYLJeR8Qnp_f4MwcM_QU91unnD5w@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in xfs_iunlock
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Theodore Ts'o <tytso@mit.edu>, syzkaller <syzkaller@googlegroups.com>

On Wed, May 9, 2018 at 4:48 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>
> On 5/8/18 2:52 AM, Dmitry Vyukov wrote:
>>> Or put another way, how did you arrive at the fs image values in the reproducer,
>>> i.e.:
>> Currently they are completely random, nobody taught syzkaller about AGFs, etc.
>
> So you just combine a few megabytes of purely random bits out of thin air until
> you get something that approximates an xfs filesystem?  Google must have more
> computing power than I was aware of.


syzbot uses very few cores for fuzzing of all of the hundreds of
kernel subsystems. But syzkaller (the underlying fuzzer) uses
coverage-guidance and this makes fuzzing exponentially more efficient
than blind techniques. Coverage-guidance is also combined with
grammar-based generation techniques, which gives additional synergy
(though there are no grammar descriptions for filesystem formats at
the moment).

Does "xfstests fuzzing infrastructure" use coverage-guidance? If not,
it would be useful to add. Among some solutions there are LibFuzzer
(https://llvm.org/docs/LibFuzzer.html), AFL
(http://lcamtuf.coredump.cx/afl/), kernel-fuzzing
(https://github.com/oracle/kernel-fuzzing). I don't know how xfstests
fuzzing works, so I can't say what would be more suitable there.



>>> oid loop()
>>> {
>>>   memcpy((void*)0x20000000, "xfs", 4);
>>>   memcpy((void*)0x20000100, "./file0", 8);
>>>   *(uint64_t*)0x20000200 = 0x20010000;
>>>   memcpy((void*)0x20010000,
>>>          "\x58\x46\x53\x42\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00"
>>>          "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x9f\x98"
>>>          "\x99\xff\xcb\xa1\x4e\xe6\xad\x52\x08\x20\x67\x09\xed\x75\x00\x00\x00"
>>>          "\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x35\xe0\x00\x00\x00\x00"
>>>          "\x00\x00\x35\xe1\x00\x00\x00\x00\x00\x00\x35\xe2\x00\x00\x00\x01\x00"
>>>          "\x00\x10\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x03\x55\xb4\xa4"
>>>          "\x02\x00\x01\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
>>>          "\x00\x0c\x09\x08\x04\x0c\x00\x00\x19\x00\x00\x00\x00\x00\x00\x00\x40"
>>>          "\x00\x00\x00\x00\x00\x00\x00\x3d\x00\x00\x00\x00\x00\x00\x0c\xa3\x00"
>>>          "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
>>>          "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00"
>>>          "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x02\x02",
>>>          204);
>>>
>>> ...
>>>
>>> The in-memory xfs filesystem it constructs is damaged, is that an intentional
>>> part of the fuzzing during the test?
>> Yes, invalid inputs is part of testing.
>
