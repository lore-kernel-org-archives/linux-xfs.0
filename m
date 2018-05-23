Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:13132 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935022AbeEWXfh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 May 2018 19:35:37 -0400
Date: Thu, 24 May 2018 09:35:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: INFO: task hung in xlog_grant_head_check
Message-ID: <20180523233533.GA23861@dastard>
References: <000000000000457b2d056cbb0044@google.com>
 <20180522123107.GC3751@bfoster.bfoster>
 <20180522222620.GW23861@dastard>
 <20180522225208.GB658@sol.localdomain>
 <20180523074425.GM14384@magnolia>
 <20180523162015.GA3684@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180523162015.GA3684@sol.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, syzbot <syzbot+568245b88fbaedcb1959@syzkaller.appspotmail.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

On Wed, May 23, 2018 at 09:20:15AM -0700, Eric Biggers wrote:
> Now, if you *really* don't want syzbot to report XFS bugs as you believe XFS
> contains known unfixable bugs or for other reasons, you can formally ask Dmitry
> to remove CONFIG_XFS_FS from the syzbot config.

We haven't said "we don't want syzbot to run on XFS" - we've been
saying "we want syzbot to run on the new XFS format". i.e. you've
got completely the wrong end of the stick.

> But of course that doesn't make
> the bugs go away, it just makes the bug reports go away; you'll have to fix them
> eventually anyway, one way or another.  I do think you're drastically
> underestimating how useful the syzbot bug reports can be too -- note e.g. that
> the bug Dave fixed by "fs: don't scan the inode cache before SB_BORN is set"
> took only 3 days to be reported by syzbot after it gained support for mounting
> XFS filesystems.  AFAICS that bug was in XFS for 7 years and was causing
> production systems to mysteriously crash (very rarely), yet it took syzbot only
> 3 days to send you a C reproducer.

We got the first ever usable user bug report for this in late
February on a v5 filesystem. Just because a bug has been there for
a long time, it doesn't mean that users or test programs are
tripping over it.  e.g.  trinity has been fuzzing filesystems (as
have many other tools), but they never hit this because of the
unlikely combination of events needed to trigger the failure.

The first proposed fix was mid-march:

https://www.spinics.net/lists/linux-xfs/msg16601.html

IOWs, trying to associate this bug with the on-disk format issues we
want fixed, or even attributing the finding and fixing this bug to
syzbot is stretching the truth somewhat. Yes, syzbot tripped over it
fairly quickly and that is great, but let's no try to rewrite
history....

However, I think this silly desire to get everything syzbot reports
attributed to syzbot regardless of reality has clouded the important
observation that should have been made here.  Everyone seems to have
missed the fact that syzbot uncovered a general class of filesystem
implementation error.  i.e.  Several filesystem implementations have
failed to handle ->fill_super errors correctly and syzbot tripped
over many of them - XFS is just one example.

The common mistake being made is failing to clear sb->s_fs_info when
it was freed on ->fill_super failure, and hence had subsequent
problems when ->kill_super was called and the code assumed
->s_fs_info was still valid. There have been other problems due to
sb->s_fs_info needing to be being assigned before the filesystem is
fully set up, and some of them were fixed by the SB_BORN change the
above patch morphed into after initial review.

IOWs, there is a general class of implementation bug here, and maybe
there's something we can learn from that - is our documentation
lacking, the API too convoluted, etc? Understanding why this
happened and making sure we don't do it again is far more important
than fixing any individual bug. And what other general
programming/API error patterns has syzbot tripped over that nobody
has noticed because there's no-one actually paying attention to the
general scope of bugs that syzbot is discovering?

> This is only at the early stage too --- syzkaller doesn't know how to fuzz the
> XFS-specific ioctls yet, for example, but it could be taught.  It's already been
> finding ext4 bugs that allowed anyone with access to an ext4 directory to
> corrupt the filesystem and crash the kernel.  And note that syzkaller is
> coverage-guided, using CONFIG_KCOV, so it *will* find bugs that you never
> thought to test for in manually written (fuzz) tests.  Non-coverage-guided
> fuzzers are no longer state of the art.  I've been really amazed at the bugs
> syzkaller been able to find in other kernel subsystems, e.g. obscure races that
> no one would have ever thought to test for.

OTOH, knowing how many bugs lurk in our code base, I'm still amazed
that tools like syzbot find so few of them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
