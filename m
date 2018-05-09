Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59904 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934693AbeEINzc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 May 2018 09:55:32 -0400
Date: Wed, 9 May 2018 09:55:28 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: WARNING: bad unlock balance in xfs_iunlock
Message-ID: <20180509135528.GE28388@thunk.org>
References: <f403043cbe8414177d0568e81405@google.com>
 <20180403043854.GL1150@dastard>
 <CACT4Y+ZadV0xTqhiGTAHmadAnYaSfPKhUy_TFXMza2o_n8+o9w@mail.gmail.com>
 <CACT4Y+aQZ8KbU1C-sJ2PUKn_788SEKQpYGjoLaRDJrP9vXjs-A@mail.gmail.com>
 <20180501225159.GY23861@dastard>
 <CACT4Y+YZYHG=MyujDdTLxO=cn7Yz34vv6WKVjWr3Jvo1YTk0HA@mail.gmail.com>
 <20180509005011.GP23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509005011.GP23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, syzkaller-bugs <syzkaller-bugs@googlegroups.com>

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

A suggestion --- insteading of forcing human beings --- either
overworked file system developers, or understaffed fuzzing tool teams,
to have to manually pull out the file system image out from the C
repro, if it's too hard to add a link where the file system iamge can
be downloaded from the Syzkaller web application --- how about adding
an option to the C repro template which causes it to dump the image to
a file and then immediately exit?

					- Ted
