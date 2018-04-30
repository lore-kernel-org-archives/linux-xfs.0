Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:40775 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753922AbeD3OCk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 10:02:40 -0400
Received: by mail-pf0-f177.google.com with SMTP id f189so6811552pfa.7
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 07:02:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9f8d657c-7f42-7bd9-4477-6c3addf16dee@sandeen.net>
References: <f403043cbe8414177d0568e81405@google.com> <20180403043854.GL1150@dastard>
 <CACT4Y+ZadV0xTqhiGTAHmadAnYaSfPKhUy_TFXMza2o_n8+o9w@mail.gmail.com>
 <20180405213844.GE23861@dastard> <20180406161053.GF7500@magnolia>
 <CACT4Y+aaEOffkFA-B-hMzwzSiQwVpkPrc2udC087a55OTnkS4g@mail.gmail.com>
 <95c1400b-94f2-1af4-2d5d-c61c274c28ff@sandeen.net> <CACT4Y+aiwgRg5pk+N7bq9HYpgumTFyqG6-y3EZ8pWkq9-uB1aA@mail.gmail.com>
 <9f8d657c-7f42-7bd9-4477-6c3addf16dee@sandeen.net>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 30 Apr 2018 16:02:19 +0200
Message-ID: <CACT4Y+bUx4jw83Ux7w9URL9bCy1ERLaVGTTwvA9Fe_UtLFeqCw@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in xfs_iunlock
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Theodore Ts'o <tytso@mit.edu>, syzkaller <syzkaller@googlegroups.com>

On Mon, Apr 30, 2018 at 3:49 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 4/30/18 8:23 AM, Dmitry Vyukov wrote:
>> On Mon, Apr 16, 2018 at 9:22 PM, Eric Sandeen <sandeen@sandeen.net> wrot=
e:
>
> ...
>
>>> It sure /seems/ to have a notion of images: what else is syz_mount_imag=
e()?
>>>
>>> i.e. you are mounting an image to reproduce the problem, correct?
>>> And the system is "smart" enough to fire off an email to a filesystem l=
ist;
>>> if it does so, add a link to the image itself, as you already have alre=
ady done
>>> for the C reproducer.
>>>
>>> Filesystem images are common parlance for filesystem engineers.  When
>>> you engage with them you'll have better results if you  provide them wi=
th
>>> inputs they can use directly instead of requiring them to reverse-engin=
eer
>>> your custom test harness.
>>
>>
>> Well, yes and no.
>> syz_mount_image() is the only part of a large system that knows about
>> images. For the rest of the system it's just a syscall like any other
>> syscall. And the part that sends emails is far away from
>> syz_mount_image().
>> syzbot does not know per se that it sends an email to filesystems
>> list.
>
> I am asking it to learn this trick as an enhancement.  The MAINTAINERS
> file contains big clues about which subsystems are filesystems, for examp=
le:
>
> $ grep FILESYSTEM$ MAINTAINERS
> AFS FILESYSTEM
> CRAMFS FILESYSTEM
> EFI VARIABLE FILESYSTEM
> EFS FILESYSTEM
> FREEVXFS FILESYSTEM
> ...
>
>> It just extracted kernel source file name that looked relevant
>> to this crash and run get_maintainers.pl on it.
>> Also the image can contain dynamically generated data, which makes it
>> impossible to have as a file at all.
>
> I guess I'm not sure what this means, can you explain?

Say, a value that we generally pass to close system call is not static
and can't be dumped to a static file. It's whatever a previous open
system call has returned. Inside of the program we memorize the return
value of open in a variable and then pass it to close. This generally
stands for all system calls. Say, an image can contain an uid, and
that uid can be obtained from a system call too.


>> Thinking of this, what should be reasonably easy to do and may be a
>> compromise for near future is the following. We could insert code into
>> syz_mount_image() which dump the image if you build a program with a
>> special define (e.g. -DSYZ_DUMP_IMAGE). Will this work for you?
>
> If this is possible, I guess I still don't understand why you can't dump =
the
> image and provide link.  You have fast, efficient robots.  We have slow,
> busy humans.
>
>>>> Please elaborate re commits. It's a basic rule of any good bug report
>>>> -- communicate exact state of source code when the bug was hit, i.e.
>>>> provide the commit hash.
>>>
>>> Further best practice is to provide the /correct/ commit hash.
>
> ....
>
>>> I can't imagine these are right...
>>
>>
>> As I said, bisection is on our plate:
>> https://github.com/google/syzkaller/issues/501
>> Though, we will see how well it works, because it's not trivial (see
>> the issue for details).
>
> Oh I see. I had misunderstood; so:
>
>> syzbot hit the following crash on upstream commit
>> 86bbbebac1933e6e95e8234c4f7d220c5ddd38bc (Mon Apr 2 18:47:07 2018 +0000)
>> Merge branch 'ras-core-for-linus' of git://git.kernel.org/pub/scm/linux/=
kernel/git/tip/tip
>
> doesn't mean you bisected to that commit, or that this was the first bad =
commit,
> it just means you happened to have a tree at this commit when you hit the=
 problem.
>
> That was not at all clear to me.  I thought when syzkaller was telling us
> "on upstream commit XYZ," it meant that it had identified commit XYZ as b=
ad.
> I'm not sure if anyone else made that mistake, but  perhaps you could als=
o clarify
> the bug report text in this regard?

Suggestions are welcome. Currently it says "syzbot hit the following
crash on upstream commit SHA1", which was supposed to mean just the
state of the source tree when the crash happened. But I am not a
native speaker, so perhaps I am saying not what I intend to say.

There are also suggestions on report format improvement from +Ted
currently in works:
https://github.com/google/syzkaller/issues/565#issuecomment-380792942
Not sure if they make this distinction 100% clear, though.


>>> I think that in this case, what we are asking for is a fine tuning of t=
he
>>> testing and reporting so that we can more efficiently address these iss=
ues.
>>> Off the top of my head, and there may be more items:
>>>
>>> 1) Add a human contact to the emails, start an IRC channel, etc, for be=
tter
>>>    two-way communication.  (it wasn't clear that syzkaller@ reached hum=
ans,
>>>    tbh.)
>>
>> There is a human contact at syzkaller@googlegroups.com. Report footer
>> will be improved to make it more clear:
>> https://github.com/google/syzkaller/issues/565#issuecomment-380793620
>>
>>> 2) _Properly_ identify the regressing commit, if any.  If it doesn't lo=
ok like
>>>    a recent regression, you can state that too.
>>
>> Bisection is on our plate.
>>
>>> 3) If you're reporting a filesystem bug that arose from using a filesys=
tem
>>>    image, provide a URL to that filesystem image directly in the report=
.
>>
>> See above. It may not be necessary representable as a static file at all=
.
>
> Can you explain this?  Do you mean that the mounted image is changing whi=
le the
> tool runs, while the filesystem is mounted?
>
>>> 4) Create a filesystem image that can be more easily debugged by the ex=
perts,
>>>    i.e. one with > 1 allocation group, so standard repair & analysis to=
ols can
>>>    be used with it.
>>
>> What is "> 1 allocation group"?
>
> Maybe I should back up; how are the xfs images created?  I had assumed th=
at
> surely you start with a base image of some sort, and start fuzzing it fro=
m there.
> Is this correct?
>
> If so, allocation groups are a fundamental geometry of the filesystem; fr=
om
> man mkfs.xfs.8:
>
>                    agcount=3Dvalue
>                           This is used to specify  the  number  of  alloc=
ation
>                           groups.  The  data  section  of  the  filesyste=
m  is
>                           divided into allocation groups to improve  the =
 per=E2=80=90
>                           formance  of  XFS. More allocation groups imply=
 that
>                           more parallelism can  be  achieved  when  alloc=
ating
>                           blocks and inodes. The minimum allocation group=
 size
>                           is 16 MiB; the maximum size is  just  under  1 =
 TiB.
>                           The  data  section of the filesystem is divided=
 into
>                           value allocation groups  (default  value  is  s=
caled
>                           automatically based on the underlying device si=
ze).
>
> If the base image only has one allocation group, it makes it more difficu=
lt for
> some tools to work with the image, because there is no redundancy.  1 AG =
is
> not a supported or recommended geometry for any real-life use of xfs.
>
> If I am correct that you start with a base image w/ a certain geometry or
> set of mkfs options, starting with >=3D 2 AGs would improve the usefulnes=
s of the
> filesystem image.

syzkaller can generate/mutate images based on structured format
templates, but for now we don't have any templates and these are just
opaque blobs.
