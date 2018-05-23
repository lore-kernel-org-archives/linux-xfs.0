Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56092 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750771AbeEWSCB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 May 2018 14:02:01 -0400
Subject: Re: INFO: task hung in xlog_grant_head_check
References: <000000000000457b2d056cbb0044@google.com>
 <20180522123107.GC3751@bfoster.bfoster> <20180522222620.GW23861@dastard>
 <20180522225208.GB658@sol.localdomain> <20180523074425.GM14384@magnolia>
 <20180523162015.GA3684@sol.localdomain>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a52266f9-0096-b28c-c01c-046ababcfe3a@sandeen.net>
Date: Wed, 23 May 2018 13:01:59 -0500
MIME-Version: 1.0
In-Reply-To: <20180523162015.GA3684@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, syzbot <syzbot+568245b88fbaedcb1959@syzkaller.appspotmail.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

On 5/23/18 11:20 AM, Eric Biggers wrote:
> Hi Darrick,

...

> Now, if you *really* don't want syzbot to report XFS bugs as you believe XFS
> contains known unfixable bugs or for other reasons, you can formally ask Dmitry
> to remove CONFIG_XFS_FS from the syzbot config.  But of course that doesn't make
> the bugs go away, it just makes the bug reports go away; you'll have to fix them
> eventually anyway, one way or another.

I'd revise that to "have to fix /some/ of them anyway."

What I'm personally hung up on are the bugs where the "exploit" involves merely
mounting a crafted filesystem that in reality would never (until the heat death
of the universe) corrupt itself into that state on its own; it's the "malicious
image" case, which is quite different than exposing fundamental bugs like the
SB_BORN race or or the user-exploitable ext4 flaw you mentioned in your reply.
Those are more insidious and/or things which can be hit by real users in real life.

I don't know if I can win the "malicious images aren't a critical security
threat" battle, but I do think they are at least a different class of flaws,
because as Dave said, mount is supposed to be a privileged operation.
In a perfect world we'd fix them anyway, but I don't know that our resource
pool can keep up with your google-scale bot and still make progress in other
critical areas.

Anyway, the upshot is that we're probably just not going to care much about V4
filesystem oops-or-hang-on-mount bugs.  Those problems are solved (largely) with
V5 filesystem format.  Maybe I /will/ propose a system-wide tunable to disallow
V4 for those who are worried about such things.

To Darrick's points about more collaboration, I still wish that our requests
for more traditional fs fuzzer reporting (i.e. a filesystem image) weren't met
with such resistance.Tailoring your bug reports to the needs of the developer
community you're interacting with seems like a pretty reasonable thing to do.

As an aside, I wonder how much coverage of the V5 format code syzkaller /has/
achieved; that would be another useful datapoint google could provide - if
syzkaller is in fact traversing the V5 codepaths and isn't turning anything
up, that'd be pretty useful to know.

Thanks,
-Eric
