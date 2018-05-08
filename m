Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36802 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754263AbeEHHw6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 03:52:58 -0400
Received: by mail-pf0-f176.google.com with SMTP id w129so18139565pfd.3
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 00:52:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d7c8e0eb-61ed-1aad-6faa-82a0ef8c25b8@sandeen.net>
References: <f403043cbe8414177d0568e81405@google.com> <20180403043854.GL1150@dastard>
 <CACT4Y+ZadV0xTqhiGTAHmadAnYaSfPKhUy_TFXMza2o_n8+o9w@mail.gmail.com>
 <20180405213844.GE23861@dastard> <20180406161053.GF7500@magnolia>
 <CACT4Y+aaEOffkFA-B-hMzwzSiQwVpkPrc2udC087a55OTnkS4g@mail.gmail.com>
 <95c1400b-94f2-1af4-2d5d-c61c274c28ff@sandeen.net> <CACT4Y+aiwgRg5pk+N7bq9HYpgumTFyqG6-y3EZ8pWkq9-uB1aA@mail.gmail.com>
 <9f8d657c-7f42-7bd9-4477-6c3addf16dee@sandeen.net> <CACT4Y+bUx4jw83Ux7w9URL9bCy1ERLaVGTTwvA9Fe_UtLFeqCw@mail.gmail.com>
 <d7c8e0eb-61ed-1aad-6faa-82a0ef8c25b8@sandeen.net>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 8 May 2018 09:52:36 +0200
Message-ID: <CACT4Y+YNRt5YSrOYKKFUP25jodpK0xeZhysSGoz2UaiGs_Gx=A@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in xfs_iunlock
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Theodore Ts'o <tytso@mit.edu>, syzkaller <syzkaller@googlegroups.com>

On Mon, Apr 30, 2018 at 5:14 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 4/30/18 9:02 AM, Dmitry Vyukov wrote:
>> On Mon, Apr 30, 2018 at 3:49 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
> ...
>
>>>> It just extracted kernel source file name that looked relevant
>>>> to this crash and run get_maintainers.pl on it.
>>>> Also the image can contain dynamically generated data, which makes it
>>>> impossible to have as a file at all.
>>>
>>> I guess I'm not sure what this means, can you explain?
>>
>> Say, a value that we generally pass to close system call is not static
>> and can't be dumped to a static file. It's whatever a previous open
>> system call has returned. Inside of the program we memorize the return
>> value of open in a variable and then pass it to close. This generally
>> stands for all system calls. Say, an image can contain an uid, and
>> that uid can be obtained from a system call too.
>
> Ok, but that's the syscall side.  You are operating on a static xfs image,
> correct?  We're only asking for the actual filesystem you're operating
> against.

Not necessary. Image can be dynamically generate too, all inputs to
kernel are generally dynamically generated.


> (When I say "image" I am talking only about the filesystem itself, not any
> other syzkaller state)

OK, let's do it this way. For the first 10 bugs, ask me, and I will do
it manually.
I am all for automation. And syzbot is already more automated than
most kernel testing systems. But, as I said, this is really
not-trivial, large amount of work, and is specific to one out of
dozens of kernel subsystems.


> Ok, backing up more: When you are testing against an xfs filesystem image, where
> does that image come from?  How is it generated?  A quick look at the syzkaller
> tree didn't make that clear to me.
>
> the xfs.repro file you provided at
> https://drive.google.com/file/d/1jzhGGe5SBJcqfsjxCLHoh4Kazke1oTfC/view
>
> is strange, it doesn't even contain AGF blocks; they aren't fuzzed or corrupted,
> they are completely zeroed out.  I don't know if that's part of the fuzzing,
> or what - what steps led to that image?
>
> Or put another way, how did you arrive at the fs image values in the reproducer,
> i.e.:

Currently they are completely random, nobody taught syzkaller about AGFs, etc.

> oid loop()
> {
>   memcpy((void*)0x20000000, "xfs", 4);
>   memcpy((void*)0x20000100, "./file0", 8);
>   *(uint64_t*)0x20000200 = 0x20010000;
>   memcpy((void*)0x20010000,
>          "\x58\x46\x53\x42\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00"
>          "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x9f\x98"
>          "\x99\xff\xcb\xa1\x4e\xe6\xad\x52\x08\x20\x67\x09\xed\x75\x00\x00\x00"
>          "\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x35\xe0\x00\x00\x00\x00"
>          "\x00\x00\x35\xe1\x00\x00\x00\x00\x00\x00\x35\xe2\x00\x00\x00\x01\x00"
>          "\x00\x10\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x03\x55\xb4\xa4"
>          "\x02\x00\x01\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
>          "\x00\x0c\x09\x08\x04\x0c\x00\x00\x19\x00\x00\x00\x00\x00\x00\x00\x40"
>          "\x00\x00\x00\x00\x00\x00\x00\x3d\x00\x00\x00\x00\x00\x00\x0c\xa3\x00"
>          "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
>          "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00"
>          "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x02\x02",
>          204);
>
> ...
>
> The in-memory xfs filesystem it constructs is damaged, is that an intentional
> part of the fuzzing during the test?

Yes, invalid inputs is part of testing.
