Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:37905 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753578AbeD3NZJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 09:25:09 -0400
Received: by mail-pf0-f193.google.com with SMTP id o76so6736425pfi.5
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 06:25:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACT4Y+ZadV0xTqhiGTAHmadAnYaSfPKhUy_TFXMza2o_n8+o9w@mail.gmail.com>
References: <f403043cbe8414177d0568e81405@google.com> <20180403043854.GL1150@dastard>
 <CACT4Y+ZadV0xTqhiGTAHmadAnYaSfPKhUy_TFXMza2o_n8+o9w@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 30 Apr 2018 15:24:48 +0200
Message-ID: <CACT4Y+aQZ8KbU1C-sJ2PUKn_788SEKQpYGjoLaRDJrP9vXjs-A@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in xfs_iunlock
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, syzkaller-bugs <syzkaller-bugs@googlegroups.com>

On Thu, Apr 5, 2018 at 8:54 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Tue, Apr 3, 2018 at 6:38 AM, Dave Chinner <david@fromorbit.com> wrote:
>> On Mon, Apr 02, 2018 at 07:01:02PM -0700, syzbot wrote:
>>> Hello,
>>>
>>> syzbot hit the following crash on upstream commit
>>> 86bbbebac1933e6e95e8234c4f7d220c5ddd38bc (Mon Apr 2 18:47:07 2018 +0000)
>>> Merge branch 'ras-core-for-linus' of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>>> syzbot dashboard link:
>>> https://syzkaller.appspot.com/bug?extid=84a67953651a971809ba
>>>
>>> C reproducer: https://syzkaller.appspot.com/x/repro.c?id=5719304272084992
>>> syzkaller reproducer:
>>> https://syzkaller.appspot.com/x/repro.syz?id=5767783983874048
>>
>> What a mess. A hand built, hopelessly broken filesystem image made
>> up of hex dumps, written into a mmap()d region of memory, then
>> copied into a tmpfs file and mounted with the loop device.
>>
>> Engineers that can debug broken filesystems don't grow on trees.  If
>> we are to have any hope of understanding what the hell this test is
>> doing, the bot needs to supply us with a copy of the built
>> filesystem image the test uses. We need to be able to point forensic
>> tools at the image to decode all the structures into human readable
>> format - if we are forced to do that by hand or jump through hoops
>> to create our own filesystem image than I'm certainly not going to
>> waste time looking at these reports...
>
> Hi Dave,
>
> Here is the image:
> https://drive.google.com/file/d/1jzhGGe5SBJcqfsjxCLHoh4Kazke1oTfC/view

Have anybody looked at the bug and the image yet?
