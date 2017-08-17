Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:39515 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753324AbdHQXAM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 19:00:12 -0400
Date: Fri, 18 Aug 2017 08:59:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6 v2] mkfs: extend opt_params with a value field
Message-ID: <20170817225952.GV21024@dastard>
References: <20170811123037.15962-1-jtulak@redhat.com>
 <20170815150812.32237-1-jtulak@redhat.com>
 <20170815150812.32237-5-jtulak@redhat.com>
 <4a7d1fe9-8094-78e8-aca9-f7f0156f0aa7@sandeen.net>
 <20170816213812.GC4796@magnolia>
 <CACj3i72+wAWL0ZVBmC8Kk4_B7=du_J_yoDsyeT=G359u-nv+hw@mail.gmail.com>
 <20170817110324.GR21024@dastard>
 <CACj3i73CN_0YE8gEV6+qxq5hcGEu1aXiL8fCO=VLv7qvhqoNpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i73CN_0YE8gEV6+qxq5hcGEu1aXiL8fCO=VLv7qvhqoNpg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Aug 17, 2017 at 04:56:18PM +0200, Jan Tulak wrote:
> On Thu, Aug 17, 2017 at 1:03 PM, Dave Chinner <david@fromorbit.com> wrote:
> > Hi folks,
> >
> > I'm going to put my 2c worth in here in the form of a patch.  The
> > tl;dr of it all is that I think we need to reset and reflect on what
> > I was originally trying to acheive with the table based option
> > parsing: factoring and simplifying mkfs into an easy to understand,
> > maintainable code base....
> >
> > And, while I remember, there's a handful of input validation bugs I
> > found in the code whiel I was doing this (like missing conflict
> > checks).
> >
> > Anyway, have a look, based on the current for-next branch.
> >
> >> >> [1] # mkfs.xfs -dfile,name=fsfile,size=1g,sectsize=4k -lfile,name=logfile,size=512m,sectsize=512
> >> >
> >> > I see -d sectsize is in the --help screen but not the manpage.  Can we
> >> > fix that?
> >>
> >> I made it, but Dave would rather see the -d sectsize option removed.
> >> Which I'm not sure about...
> >> See "[PATCH] xfsprogs: add sectsize/sectlog to the man page"
> >
> > Slash and burn - there is so much useless, redundant crap in the CLI
> > we've been holding onto for 15 years that we should just get rid of
> > it. That's what I was intending to do originally with this rework
> > and I still see no reason why we should be keeping stuff that just
> > causes user confusion and implemention complexity.
> 
> I went through it and I admit that his shot seems to go in a much
> better way than my patches; I focused on the opts structure too much I
> guess. :-)

That's not your fault - if anyone is to blame it's me for not
providing you with better guidance in the first place.

> So, thanks for this restart. I'm going to compare it with
> my changes and check which parts of my set makes sense in this
> direction as well and which do not...

Having slept on it, I suspect that I'll generate an "input
parameters" structure to replace the hacked up "cli geometry",
similar to what Luis first wanted to add. If it works out the way I
think it will, we'll end up with a set of key,value inputs in that
structure that we can trivially generate using a config file rather
than the CLI....

> And this is maybe a bit premature idea now, but should we add some way
> how to tell the user "this option is deprecated, use XXX"? I think
> that it is a good idea if we are removing parts of the CLI, which
> might break some user scripts or workflow. It would be pretty easy to
> do - with something like your *_opts_parser() functions, just a case,
> print the error and return EINVAL.

Depends on how we decide to do the removal. If we go with
deprecation and later removal, then I think this is a good idea.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
