Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37634 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932109AbeFKOfJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jun 2018 10:35:09 -0400
Subject: Re: INFO: task hung in xlog_grant_head_check
References: <000000000000457b2d056cbb0044@google.com>
 <20180522123107.GC3751@bfoster.bfoster> <20180522222620.GW23861@dastard>
 <20180522225208.GB658@sol.localdomain> <20180523074425.GM14384@magnolia>
 <20180523162015.GA3684@sol.localdomain>
 <a52266f9-0096-b28c-c01c-046ababcfe3a@sandeen.net>
 <CACT4Y+b4+o86Aud9K3m1HWhqsbNoyvEfW+53R2WV=Redi6Cwew@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <46be4dcc-15e5-1482-042b-a0bcdb0fa56b@sandeen.net>
Date: Mon, 11 Jun 2018 09:35:08 -0500
MIME-Version: 1.0
In-Reply-To: <CACT4Y+b4+o86Aud9K3m1HWhqsbNoyvEfW+53R2WV=Redi6Cwew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers3@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, syzbot <syzbot+568245b88fbaedcb1959@syzkaller.appspotmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>

On 6/11/18 8:20 AM, Dmitry Vyukov wrote:
> On Wed, May 23, 2018 at 8:01 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

...

>> As an aside, I wonder how much coverage of the V5 format code syzkaller
>> /has/
>> achieved; that would be another useful datapoint google could provide - if
>> syzkaller is in fact traversing the V5 codepaths and isn't turning anything
>> up, that'd be pretty useful to know.
> 
> Hi Eric,
> 
> The current syzbot kernel code coverage is available here:
> https://storage.googleapis.com/syzkaller/cover/upstream.html#9c73bb525fc1def86e67f5039ab97d8f48062621

Here is an example of an informative, useful, and efficient presentation of
code coverage:

http://ltp.sourceforge.net/coverage/lcov/output/index.html

Thanks,
-Eric
