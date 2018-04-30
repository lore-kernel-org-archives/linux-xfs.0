Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34686 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754363AbeD3PO3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Apr 2018 11:14:29 -0400
Subject: Re: WARNING: bad unlock balance in xfs_iunlock
References: <f403043cbe8414177d0568e81405@google.com>
 <20180403043854.GL1150@dastard>
 <CACT4Y+ZadV0xTqhiGTAHmadAnYaSfPKhUy_TFXMza2o_n8+o9w@mail.gmail.com>
 <20180405213844.GE23861@dastard> <20180406161053.GF7500@magnolia>
 <CACT4Y+aaEOffkFA-B-hMzwzSiQwVpkPrc2udC087a55OTnkS4g@mail.gmail.com>
 <95c1400b-94f2-1af4-2d5d-c61c274c28ff@sandeen.net>
 <CACT4Y+aiwgRg5pk+N7bq9HYpgumTFyqG6-y3EZ8pWkq9-uB1aA@mail.gmail.com>
 <9f8d657c-7f42-7bd9-4477-6c3addf16dee@sandeen.net>
 <CACT4Y+bUx4jw83Ux7w9URL9bCy1ERLaVGTTwvA9Fe_UtLFeqCw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d7c8e0eb-61ed-1aad-6faa-82a0ef8c25b8@sandeen.net>
Date: Mon, 30 Apr 2018 10:14:28 -0500
MIME-Version: 1.0
In-Reply-To: <CACT4Y+bUx4jw83Ux7w9URL9bCy1ERLaVGTTwvA9Fe_UtLFeqCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dmitry Vyukov <dvyukov@google.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Theodore Ts'o <tytso@mit.edu>, syzkaller <syzkaller@googlegroups.com>

On 4/30/18 9:02 AM, Dmitry Vyukov wrote:
> On Mon, Apr 30, 2018 at 3:49 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

...

>>> It just extracted kernel source file name that looked relevant
>>> to this crash and run get_maintainers.pl on it.
>>> Also the image can contain dynamically generated data, which makes it
>>> impossible to have as a file at all.
>>
>> I guess I'm not sure what this means, can you explain?
> 
> Say, a value that we generally pass to close system call is not static
> and can't be dumped to a static file. It's whatever a previous open
> system call has returned. Inside of the program we memorize the return
> value of open in a variable and then pass it to close. This generally
> stands for all system calls. Say, an image can contain an uid, and
> that uid can be obtained from a system call too.

Ok, but that's the syscall side.  You are operating on a static xfs image,
correct?  We're only asking for the actual filesystem you're operating
against.

(When I say "image" I am talking only about the filesystem itself, not any
other syzkaller state)
 
...

>> That was not at all clear to me.  I thought when syzkaller was telling us
>> "on upstream commit XYZ," it meant that it had identified commit XYZ as bad.
>> I'm not sure if anyone else made that mistake, but  perhaps you could also clarify
>> the bug report text in this regard?
> 
> Suggestions are welcome. Currently it says "syzbot hit the following
> crash on upstream commit SHA1", which was supposed to mean just the
> state of the source tree when the crash happened. But I am not a
> native speaker, so perhaps I am saying not what I intend to say.
> 
> There are also suggestions on report format improvement from +Ted
> currently in works:
> https://github.com/google/syzkaller/issues/565#issuecomment-380792942
> Not sure if they make this distinction 100% clear, though.

Maybe I was the only one who misunderstood, but something like

git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
HEAD:		f5c754d63d06 mm/swap_state.c: make bool enable_vma_readahead and swap_vma_readahead()
 
to make it clear that it has not identified that commit as the culprit, it's
just the head of the tree you were testing?  (I think I have the correct git
nomenclature ...)

...

>> If the base image only has one allocation group, it makes it more difficult for
>> some tools to work with the image, because there is no redundancy.  1 AG is
>> not a supported or recommended geometry for any real-life use of xfs.
>>
>> If I am correct that you start with a base image w/ a certain geometry or
>> set of mkfs options, starting with >= 2 AGs would improve the usefulness of the
>> filesystem image.
> 
> syzkaller can generate/mutate images based on structured format
> templates, but for now we don't have any templates and these are just
> opaque blobs.

Ok, backing up more: When you are testing against an xfs filesystem image, where
does that image come from?  How is it generated?  A quick look at the syzkaller
tree didn't make that clear to me.

the xfs.repro file you provided at
https://drive.google.com/file/d/1jzhGGe5SBJcqfsjxCLHoh4Kazke1oTfC/view

is strange, it doesn't even contain AGF blocks; they aren't fuzzed or corrupted,
they are completely zeroed out.  I don't know if that's part of the fuzzing,
or what - what steps led to that image?

Or put another way, how did you arrive at the fs image values in the reproducer,
i.e.:

oid loop()
{
  memcpy((void*)0x20000000, "xfs", 4);
  memcpy((void*)0x20000100, "./file0", 8);
  *(uint64_t*)0x20000200 = 0x20010000;
  memcpy((void*)0x20010000,
         "\x58\x46\x53\x42\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00"
         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x9f\x98"
         "\x99\xff\xcb\xa1\x4e\xe6\xad\x52\x08\x20\x67\x09\xed\x75\x00\x00\x00"
         "\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x35\xe0\x00\x00\x00\x00"
         "\x00\x00\x35\xe1\x00\x00\x00\x00\x00\x00\x35\xe2\x00\x00\x00\x01\x00"
         "\x00\x10\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x03\x55\xb4\xa4"
         "\x02\x00\x01\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
         "\x00\x0c\x09\x08\x04\x0c\x00\x00\x19\x00\x00\x00\x00\x00\x00\x00\x40"
         "\x00\x00\x00\x00\x00\x00\x00\x3d\x00\x00\x00\x00\x00\x00\x0c\xa3\x00"
         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00"
         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x02\x02",
         204);

... 

The in-memory xfs filesystem it constructs is damaged, is that an intentional
part of the fuzzing during the test?

-Eric
