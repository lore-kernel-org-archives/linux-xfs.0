Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:37572 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756513AbeEIOOS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 10:14:18 -0400
Received: by mail-pg0-f43.google.com with SMTP id a13-v6so22744916pgu.4
        for <linux-xfs@vger.kernel.org>; Wed, 09 May 2018 07:14:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180509135528.GE28388@thunk.org>
References: <f403043cbe8414177d0568e81405@google.com> <20180403043854.GL1150@dastard>
 <CACT4Y+ZadV0xTqhiGTAHmadAnYaSfPKhUy_TFXMza2o_n8+o9w@mail.gmail.com>
 <CACT4Y+aQZ8KbU1C-sJ2PUKn_788SEKQpYGjoLaRDJrP9vXjs-A@mail.gmail.com>
 <20180501225159.GY23861@dastard> <CACT4Y+YZYHG=MyujDdTLxO=cn7Yz34vv6WKVjWr3Jvo1YTk0HA@mail.gmail.com>
 <20180509005011.GP23861@dastard> <20180509135528.GE28388@thunk.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 9 May 2018 16:13:57 +0200
Message-ID: <CACT4Y+abNg4z24yghDGkwq6h5trumGsm1HDZqyoghe8PJJ-7Uw@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in xfs_iunlock
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Dmitry Vyukov <dvyukov@google.com>, syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, syzkaller-bugs <syzkaller-bugs@googlegroups.com>

On Wed, May 9, 2018 at 3:55 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
>>>> C reproducer: https://syzkaller.appspot.com/x/repro.c?id=5719304272084992
>>>> syzkaller reproducer:
>>>> https://syzkaller.appspot.com/x/repro.syz?id=5767783983874048
>>>
>>> What a mess. A hand built, hopelessly broken filesystem image made
>>> up of hex dumps, written into a mmap()d region of memory, then
>>> copied into a tmpfs file and mounted with the loop device.
>>>
>>> Engineers that can debug broken filesystems don't grow on trees.  If
>>> we are to have any hope of understanding what the hell this test is
>>> doing, the bot needs to supply us with a copy of the built
>>> filesystem image the test uses. We need to be able to point forensic
>>> tools at the image to decode all the structures into human readable
>>> format - if we are forced to do that by hand or jump through hoops
>>> to create our own filesystem image than I'm certainly not going to
>>> waste time looking at these reports...
>>
>> Hi Dave,
>>
>> Here is the image:
>> https://drive.google.com/file/d/1jzhGGe5SBJcqfsjxCLHoh4Kazke1oTfC/view
>
> A suggestion --- insteading of forcing human beings --- either
> overworked file system developers, or understaffed fuzzing tool teams,
> to have to manually pull out the file system image out from the C
> repro, if it's too hard to add a link where the file system iamge can
> be downloaded from the Syzkaller web application --- how about adding
> an option to the C repro template which causes it to dump the image to
> a file and then immediately exit?

Hi Ted,

That's what I proposed above:
https://groups.google.com/d/msg/syzkaller-bugs/KJNNTgTdg_g/NRxarDcYBgAJ
But I did not get response yet.
