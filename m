Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:39951 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752521AbeD3NXy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 09:23:54 -0400
Received: by mail-pf0-f174.google.com with SMTP id f189so6732658pfa.7
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 06:23:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <95c1400b-94f2-1af4-2d5d-c61c274c28ff@sandeen.net>
References: <f403043cbe8414177d0568e81405@google.com> <20180403043854.GL1150@dastard>
 <CACT4Y+ZadV0xTqhiGTAHmadAnYaSfPKhUy_TFXMza2o_n8+o9w@mail.gmail.com>
 <20180405213844.GE23861@dastard> <20180406161053.GF7500@magnolia>
 <CACT4Y+aaEOffkFA-B-hMzwzSiQwVpkPrc2udC087a55OTnkS4g@mail.gmail.com> <95c1400b-94f2-1af4-2d5d-c61c274c28ff@sandeen.net>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 30 Apr 2018 15:23:32 +0200
Message-ID: <CACT4Y+aiwgRg5pk+N7bq9HYpgumTFyqG6-y3EZ8pWkq9-uB1aA@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in xfs_iunlock
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Theodore Ts'o <tytso@mit.edu>, syzkaller <syzkaller@googlegroups.com>

On Mon, Apr 16, 2018 at 9:22 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 4/13/18 5:03 AM, Dmitry Vyukov wrote:
>> On Fri, Apr 6, 2018 at 6:10 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>>> On Fri, Apr 06, 2018 at 07:38:44AM +1000, Dave Chinner wrote:
>>>> On Thu, Apr 05, 2018 at 08:54:50PM +0200, Dmitry Vyukov wrote:
>>>>> On Tue, Apr 3, 2018 at 6:38 AM, Dave Chinner <david@fromorbit.com> wrote:
>>>>>> On Mon, Apr 02, 2018 at 07:01:02PM -0700, syzbot wrote:
>>>>>>> Hello,
>>>>>>>
>>>>>>> syzbot hit the following crash on upstream commit
>>>>>>> 86bbbebac1933e6e95e8234c4f7d220c5ddd38bc (Mon Apr 2 18:47:07 2018 +0000)
>>>>>>> Merge branch 'ras-core-for-linus' of
>>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>>>>>>> syzbot dashboard link:
>>>>>>> https://syzkaller.appspot.com/bug?extid=84a67953651a971809ba
>>>>>>>
>>>>>>> C reproducer: https://syzkaller.appspot.com/x/repro.c?id=5719304272084992
>>>>>>> syzkaller reproducer:
>>>>>>> https://syzkaller.appspot.com/x/repro.syz?id=5767783983874048
>>>>>>
>>>>>> What a mess. A hand built, hopelessly broken filesystem image made
>>>>>> up of hex dumps, written into a mmap()d region of memory, then
>>>>>> copied into a tmpfs file and mounted with the loop device.
>>>>>>
>>>>>> Engineers that can debug broken filesystems don't grow on trees.  If
>>>>>> we are to have any hope of understanding what the hell this test is
>>>>>> doing, the bot needs to supply us with a copy of the built
>>>>>> filesystem image the test uses. We need to be able to point forensic
>>>>>> tools at the image to decode all the structures into human readable
>>>>>> format - if we are forced to do that by hand or jump through hoops
>>>>>> to create our own filesystem image than I'm certainly not going to
>>>>>> waste time looking at these reports...
>>>>>
>>>>> Hi Dave,
>>>>>
>>>>> Here is the image:
>>>>> https://drive.google.com/file/d/1jzhGGe5SBJcqfsjxCLHoh4Kazke1oTfC/view
>>>>> (took me about a minute to extract from test by replacing memfd_create
>>>>> with open and running the program).
>>>>
>>>> Says the expert who knows exactly how it's all put together. It took
>>>> me a couple of hours just to understand WTF the syzbot reproducer
>>>> was actually doing....
>
> *nod* more on this below.
>
>>>>> Then do the following to trigger the bug:
>>>>> losetup /dev/loop0 xfs.repro
>>>>> mkdir xfs
>>>>> mount -t xfs -o nouuid,prjquota,noikeep,quota /dev/loop0 xfs
>>>>>
>>>>> To answer your more general question: syzbot is not a system to test
>>>>> solely file systems, it finds bugs in hundreds of kernel subsystems.
>>>>> Generating image for file systems, media files for sound and
>>>>> FaceDancer programs that crash host when  FaceDancer device is plugged
>>>>> into USB is not feasible. And in the end it's not even clear what
>>>>
>>>> I don't care how syzbot generates the filesystem image it uses.
>>>>
>>>>> kernel subsystem is at fault and even if it somehow figures out that
>>>>> it's a filesystem, it's unclear that it's exactly an image that
>>>>> provokes the bug. syzbot provides C reproducers which is a reasonable
>>>>
>>>> It doesn't matter *what subsystem breaks*. If syzbot is generating a
>>>> filesystem image and then mounting it, it needs to provide that
>>>> filesystem image to to people who end up having to debug the
>>>> problem. It's a basic "corrupt filesystem" bug triage step.
>
> *nod*
>
>>>>> Some bugs are so involved that only an
>>>>> expert in a particular subsystem can figure out what happens there.
>>>>
>>>> And that's clearly the case here, whether you like it or not.
>>>>
>>>> You want us to do things that make syzbot more useful as a tool but
>>>> you don't want to do things that make syzbot a useful tool for us.
>>>> It's a two way street....
>>
>> Hi Dave, Darrick,
>>
>> It's not that we don't want to make the system more useful, it's just
>> that we don't see what reasonably can be done here. The system does
>> not have notion of images, sound files, USB devices. It feeds data
>> into system calls, and that's what it provides as reproducers. Also
>> see the last paragraph.
>
> It sure /seems/ to have a notion of images: what else is syz_mount_image()?
>
> i.e. you are mounting an image to reproduce the problem, correct?
> And the system is "smart" enough to fire off an email to a filesystem list;
> if it does so, add a link to the image itself, as you already have already done
> for the C reproducer.
>
> Filesystem images are common parlance for filesystem engineers.  When
> you engage with them you'll have better results if you  provide them with
> inputs they can use directly instead of requiring them to reverse-engineer
> your custom test harness.


Well, yes and no.
syz_mount_image() is the only part of a large system that knows about
images. For the rest of the system it's just a syscall like any other
syscall. And the part that sends emails is far away from
syz_mount_image().
syzbot does not know per se that it sends an email to filesystems
list. It just extracted kernel source file name that looked relevant
to this crash and run get_maintainers.pl on it.
Also the image can contain dynamically generated data, which makes it
impossible to have as a file at all.

Thinking of this, what should be reasonably easy to do and may be a
compromise for near future is the following. We could insert code into
syz_mount_image() which dump the image if you build a program with a
special define (e.g. -DSYZ_DUMP_IMAGE). Will this work for you?



>>> ...here's my take on this whole situation:
>>>
>>> So far as I can tell, this syzbot daemon grew the ability to fuzz
>>> filesystems and started emitting bug report after bug report, with
>>> misleading commit ids that have nothing to do with the complaint.
>>
>> Please elaborate re commits. It's a basic rule of any good bug report
>> -- communicate exact state of source code when the bug was hit, i.e.
>> provide the commit hash.
>
> Further best practice is to provide the /correct/ commit hash.
>
> syzbot has identified commits which seem almost certainly incorrect.
>
> For example,
>
> KASAN: use-after-free Read in radix_tree_next_chunk
>
> identified:
>
> 9dd2326890d89a5179967c947dab2bab34d7ddee (Fri Mar 30 17:29:47 2018 +0000)
> Merge tag 'ceph-for-4.16-rc8' of git://github.com/ceph/ceph-client
>
> and:
>
> WARNING: bad unlock balance in xfs_iunlock
>
> identified:
>
> 86bbbebac1933e6e95e8234c4f7d220c5ddd38bc (Mon Apr 2 18:47:07 2018 +0000)
> Merge branch 'ras-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>
> I can't imagine these are right...


As I said, bisection is on our plate:
https://github.com/google/syzkaller/issues/501
Though, we will see how well it works, because it's not trivial (see
the issue for details).


>>>  Your
>>> maintainers (Dave, Eric, and me) have spent a few hours trying to figure
>>> out what's going on, to some frustration.  The bug reports themselves
>>> miss the public engagement detail of saying something like "Hey XFS
>>> engineers, if you'd like to talk to the syzbot engineers they can be
>>> reached at <googlegroup address>."  Instead it merely says "direct
>>> questions to <addr>" like this is some press release and the only thing
>>> on the other end of the line will be some disinterested bureaucracy.
>>> Or some robot.
>>
>> This is quite subjective and we hear opinions all possible ways. I
>> don't think there is one size fits all. E.g. +Ted argued in exactly
>> the opposite direction: make reports more laconic, formal,
>> table-formatted with dry information. There is also a tradeoff between
>> describing each detail in proper, friendly English and being more
>> laconic. If we increase everything 4x and post a wall of text with
>> each report, lots of people won't read anything of it just because
>> it's a wall of text. I am also not a native English speaker, so
>> providing simple formal text is a safer option than writing something
>> potentially clumsy.
>
> What Darrick is asking for, I think, is a human on the other end to talk
> to if there are any issues or concerns about the reports.  (For example,
> "hey that commit looks wrong, are you sure?)  We are not asking for a
> long narrative with each report.  We're asking for a dialogue about this
> framework and the reporting, so it can improve.
>
>> Having said that, I am collecting proposals for report format
>> improvements. Here is fortunately slightly better wording for footer
>> based on your idea:
>> https://github.com/google/syzkaller/issues/565#issuecomment-380793620

Report footer will be improved to make it more clear:
https://github.com/google/syzkaller/issues/565#issuecomment-380793620


>> Well, I guess nobody has infinite engineering resources. If we would
>> have them we would also fix all these bug ourselves and don't bother
>> you at all. Just as any other company could invest in writing bug
>> detection tools, fuzzers, deploy them and report bugs, which would
>> relief us from this.
>> We have limited resources and do what's possible within these
>> resources. Unfortunately providing individual handling of each of the
>> thousands of bugs is not possible within these resources. I know that
>> what we are doing is useful for kernel overall because lots of
>> hundreds of bugs get fixed due to this effort. If you, as xfs
>> maintainers, think that these reports are net negative for xfs and xfs
>> should not be tested, say so and we will figure out how to make it
>> happen.
>
> We've been inundated lately with results of scripts which generate bug reports
> quickly but do not provide enough information to quickly triage, reproduce, and
> fix those reports.
>
> (For example, another fuzzer is using the same "poc.c" to exercise a fuzzed
> image; it might be the 1st operation or the 50th that causes the issue, but
> the harness doesn't bother to find out or report it, it just sends all 50
> potential operations to us, and assumes we'll take the time to figure it out.
> It's laziness on the script/reporting side, resulting in extra work on the
> human/debugging side.)
>
> I think that in this case, what we are asking for is a fine tuning of the
> testing and reporting so that we can more efficiently address these issues.
> Off the top of my head, and there may be more items:
>
> 1) Add a human contact to the emails, start an IRC channel, etc, for better
>    two-way communication.  (it wasn't clear that syzkaller@ reached humans,
>    tbh.)

There is a human contact at syzkaller@googlegroups.com. Report footer
will be improved to make it more clear:
https://github.com/google/syzkaller/issues/565#issuecomment-380793620

> 2) _Properly_ identify the regressing commit, if any.  If it doesn't look like
>    a recent regression, you can state that too.

Bisection is on our plate.

> 3) If you're reporting a filesystem bug that arose from using a filesystem
>    image, provide a URL to that filesystem image directly in the report.

See above. It may not be necessary representable as a static file at all.

> 4) Create a filesystem image that can be more easily debugged by the experts,
>    i.e. one with > 1 allocation group, so standard repair & analysis tools can
>    be used with it.

What is "> 1 allocation group"?

> Hopefully this sort of feedback will result in better bug reports from you,
> and faster (and more) bugfixes from us.
>
> Personally, I'm certainly not asking you to stop sending reports of bugs you
> find, but I /am/ asking that they be as refined, specific, and useful as possible.
>
> Thanks,
> -Eric
