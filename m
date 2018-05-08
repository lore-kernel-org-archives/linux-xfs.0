Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f43.google.com ([209.85.160.43]:43340 "EHLO
        mail-pl0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754179AbeEHHyv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 03:54:51 -0400
Received: by mail-pl0-f43.google.com with SMTP id a39-v6so1736381pla.10
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 00:54:51 -0700 (PDT)
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
Date: Tue, 8 May 2018 09:54:30 +0200
Message-ID: <CACT4Y+bKL9SWm-_t1SKC6amAGsWUTLkt0b6SpMN22P-O+ofVSA@mail.gmail.com>
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
>
> (When I say "image" I am talking only about the filesystem itself, not any
> other syzkaller state)
>
> ...
>
>>> That was not at all clear to me.  I thought when syzkaller was telling us
>>> "on upstream commit XYZ," it meant that it had identified commit XYZ as bad.
>>> I'm not sure if anyone else made that mistake, but  perhaps you could also clarify
>>> the bug report text in this regard?
>>
>> Suggestions are welcome. Currently it says "syzbot hit the following
>> crash on upstream commit SHA1", which was supposed to mean just the
>> state of the source tree when the crash happened. But I am not a
>> native speaker, so perhaps I am saying not what I intend to say.
>>
>> There are also suggestions on report format improvement from +Ted
>> currently in works:
>> https://github.com/google/syzkaller/issues/565#issuecomment-380792942
>> Not sure if they make this distinction 100% clear, though.
>
> Maybe I was the only one who misunderstood, but something like
>
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> HEAD:           f5c754d63d06 mm/swap_state.c: make bool enable_vma_readahead and swap_vma_readahead()
>
> to make it clear that it has not identified that commit as the culprit, it's
> just the head of the tree you were testing?  (I think I have the correct git
> nomenclature ...)


This is done now, you can see example of new format here:

https://lkml.org/lkml/2018/5/8/36

It says "HEAD commit" and also "syzbot engineers can be reached at <email>".
