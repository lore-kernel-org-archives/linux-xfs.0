Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49891 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752707AbdBTN0b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Feb 2017 08:26:31 -0500
Date: Mon, 20 Feb 2017 08:25:35 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/5] xfs: quota deadlock fixes
Message-ID: <20170220132535.GA32455@bfoster.bfoster>
References: <1487173247-5965-1-git-send-email-bfoster@redhat.com>
 <20170217065315.GD24562@eguan.usersys.redhat.com>
 <20170217175454.GA20429@bfoster.bfoster>
 <20170220035256.GH24562@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170220035256.GH24562@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On Mon, Feb 20, 2017 at 11:52:56AM +0800, Eryu Guan wrote:
> On Fri, Feb 17, 2017 at 12:54:54PM -0500, Brian Foster wrote:
> > On Fri, Feb 17, 2017 at 02:53:15PM +0800, Eryu Guan wrote:
> > > On Wed, Feb 15, 2017 at 10:40:42AM -0500, Brian Foster wrote:
> > > > Hi all,
> > > > 
> > > > This is a collection of several quota related deadlock fixes for
> > > > problems that have been reported to the list recently.
> > > > 
> > > > Patch 1 fixes the low memory quotacheck problem reported by Martin[1].
> > > > Dave is CC'd as he had comments on this particular thread that started a
> > > > discussion, but I hadn't heard anything back since my last response.
> > > > 
> > > > Patch 2 fixes a separate problem I ran into while attempting to
> > > > reproduce Eryu's xfs/305 hang report[2]. 
> > > > 
> > > > Patches 3-5 fix the actual problem reported by Eryu, which is a quotaoff
> > > > deadlock reproduced by xfs/305.
> > > > 
> > > > Further details are included in the individual commit log descriptions.
> > > > Thoughts, reviews, flames appreciated.
> > > > 
> > > > Eryu,
> > > > 
> > > > I've run several hundred iterations of this on your reproducer system
> > > > without reproducing the hang. I have reproduced a reset overnight but
> > > > still haven't been able to grab a stack trace from that occurrence (I'll
> > > > try again today/tonight with better console logging). I suspect this is
> > > 
> > > I hit a NULL pointer dereference while testing your fix, I was running
> > > xfs/305 for 1000 iterations and host crashed at the 639th run. Not sure
> > > if it's the same issue you've met here. I posted dmesg log at the end of
> > > mail. I haven't tried to see if I can reproduce it on stock linus tree
> > > yet.
> > > 
> > 
> > Interesting, thanks. I don't know for sure because I didn't hit anything
> > on my second overnight run, but I wouldn't be surprised if it's the
> > same, particularly if you hit this again. This does look like an
> > independent problem to me, though. A kdump might be nice, if possible,
> > given the difficulty to reproduce...
> 
> Unfortunately, my second round of 1000 iteration run hit hang too, at
> the 824th loop.  Test configuration is all default, crc enabled XFS with
> 4k block size, no rmapbt no reflink no finobt no sparse inode.
> 
> I attached the dmesg log and sysrq-w output. I also left the host in the
> hang state, you can login and take a look if you have interest.
> 

Hmm, Ok thanks. This one looks more like the original problem.
Everything is waiting on log reservation, the AIL is spinning on the
locked quotaoff start log item, and the quotaoff purge sequence appears
to be spinning on a dquot.

Unfortunately, I can't tell why quotaoff is spinning. stap doesn't seem
to compile anything on this box after a quick try, so I'll probably have
to reinstall some of the debug code on top and (hopefully) reproduce.
I'm guessing it's a similar dquot reference count issue, but it may or
may not be the same since this one appears significantly harder to
reproduce than the original...

Brian

> Thanks,
> Eryu


