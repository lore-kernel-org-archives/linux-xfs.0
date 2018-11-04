Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:64366 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729223AbeKEH1c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Nov 2018 02:27:32 -0500
Date: Mon, 5 Nov 2018 09:11:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] vfs: fix many problems in vfs clone/dedupe
 implementation
Message-ID: <20181104221100.GI19305@dastard>
References: <20181102051459.GS6311@dastard>
 <CAHk-=whrpyMSWM4wxYE+E4fSbpkD3yBATjLnzvvAKBfhGwUaAw@mail.gmail.com>
 <20181102233651.GH19305@dastard>
 <CAHk-=wiJdzKEq2RsQCe5R1X2W0AEiOYOt8womcyTfkD=mgQAug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiJdzKEq2RsQCe5R1X2W0AEiOYOt8womcyTfkD=mgQAug@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: djwong@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Sat, Nov 03, 2018 at 10:13:37AM -0700, Linus Torvalds wrote:
> On Fri, Nov 2, 2018 at 4:36 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Fri, Nov 02, 2018 at 09:35:23AM -0700, Linus Torvalds wrote:
> > >
> > > I don't love the timing of this at the end of the merge window, but pulled,
> >
> > When would have been a better time? It's too big for a late -rc, and
> > it contains stuff that needs fixing pretty urgently. So if the merge
> > window is not appropriate, what should we have done here?
> 
> No, I think that with the timing of the problem finding, it was
> probably the only thing to do, but generally I like these kinds of
> somewhat scary and disruptive patches (just because it touches
> multiple filesystems) _early_ in the merge window if at all possible,
> and showing that the development was done before and not some rushed
> thing..

Fair enough. That was partly my fault - I forgot to add sob's to the
commits when I pulled the final version in for testing in the middle
of the first week of the merge window. I didn't realise that until
after I'd soak and stress tested it and was getting ready to push it
out to linux-next a week later. So I had to rewrite all the commits
and so they would have looked an awful lot more recent than they
really were. I should have mentioned this in the pull request...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
