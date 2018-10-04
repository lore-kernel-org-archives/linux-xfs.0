Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:11300 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726852AbeJDMaP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 08:30:15 -0400
Date: Thu, 4 Oct 2018 15:38:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: avoid lockdep false positives in xfs_trans_alloc
Message-ID: <20181004053838.GT18567@dastard>
References: <20181001010931.GO31060@dastard>
 <CAOQ4uxjo1nE38q=FL+EofoMz=1=D2eZYo9s3-TVBSEjbHH52kQ@mail.gmail.com>
 <20181001223244.GH18567@dastard>
 <CAOQ4uxhTJcEtUJkwO5UCyF1sCFQ=bPo0ragy5255aM30C9Z1Zw@mail.gmail.com>
 <20181002063952.GN18567@dastard>
 <CAJfpegvcmKiaU-oPfXk0ub6tdBKhDRcUKTkLd5_rAagv05R-EA@mail.gmail.com>
 <20181002231421.GQ18567@dastard>
 <CAOQ4uxhrEm4uMhsw5G+_Bv87-zPenJ9gwvDJvCPSmRkQAWiszQ@mail.gmail.com>
 <20181003225917.GR18567@dastard>
 <CAJfpegsHwm=w8HhqEuYTBE1yFkhiTFB5Su1f2VrAB9XPhWrrbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsHwm=w8HhqEuYTBE1yFkhiTFB5Su1f2VrAB9XPhWrrbg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>, Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

On Thu, Oct 04, 2018 at 01:14:12AM +0200, Miklos Szeredi wrote:
> On Thu, Oct 4, 2018 at 12:59 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Oct 03, 2018 at 06:45:13AM +0300, Amir Goldstein wrote:
> >> On Wed, Oct 3, 2018 at 2:14 AM Dave Chinner <david@fromorbit.com> wrote:
> >> [...]
> >> > > Seems like freezing any of the layers if overlay itself is not frozen
> >> > > is not a good idea.
> >> >
> >> > That's something we can't directly control. e.g. lower filesystem is
> >> > on a DM volume. DM can freeze the lower fileystem through the block
> >> > device when a dm command is run. It may well be that the admins that
> >> > set up the storage and filesystem layer have no idea that there are
> >> > now overlay users on top of the filesystem they originally set up.
> >> > Indeed, the admins may not even know that dm operations freeze
> >> > filesystems because it happens completely transparently to them.
> >> >
> >>
> >> I don't think we should be binding the stacked filesystem issues with
> >> the stacked block over fs issues.
> >
> > It's the same problem.  Hacking a one-off solution to hide a specific
> > overlay symptom does not address the root problem. And, besides, if
> > you stack like this:
> >
> > overlay
> >   lower_fs
> >     loopback dev
> >       loop img fs
> >
> > And freeze the loop img fs, overlay can still get stuck in it's
> > shrinker because the the lower_fs gets stuck doing IO on the frozen
> > loop img fs.
> >
> > i.e. it's the same issue - kswapd will get stuck doing reclaim from
> > the overlay shrinker.
> 
> Is overlay making the situation any worse in this case?  IOW, would

No, it's not. My point is that it's the same layering problem, not
that it is an issue unique to overlay. Fixing one without addressing
the other does not make the problem go away.

> >> If vfs stores a reverse tree of stacked fs dependencies, then individual
> >> sb freeze can be solved.
> >
> > Don't make me mention bind mounts... :/
> 
> How do mounts have anything to do with this?

Bind mounts layer superblocks in unpredictable manners. e.g. the
lowerfs for overlay could be a directory heirachy made up of
multiple bind mounts from different source filesystems. So it's not
just a 1:1 upper/lower superblock relationship it could be 1:many.
Dependency graphs get complx quickly in such configurations.

You can also have the same superblock above overlay through a bind
mount as well as below as the lower fs.  e.g. A user could freeze
the bind mounted heirarchy after checking it's a different device to
the filesystem they are also writing to (e.g. logs to "root" device,
freezes "home" device). IOWs, they could be completely unaware that
the freeze target is the same filesystem that underlies the "root"
device, and so when the freeze the "home" target their root device
also freezes.

That sort of thing registers high up on the user WTF-o-meter, and
it's not at all obvious what went wrong or how to get out of that
mess. It's not clear to me if bind mounts should accept path based
superblock admin commands like freeze because the potentially expose
problems far outside the realm that specific user/mount namespace is
allowed access to.

My point is that it's not obvious that there is a simple, clear
dependency hierarchy between superblocks because there are so many
ways they can be layered by userspace and layered fileystems and
block devices.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
