Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:33359 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751131AbeCNMdS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 08:33:18 -0400
Date: Wed, 14 Mar 2018 23:33:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: preserve i_rdev when recycling a reclaimable
 inode
Message-ID: <20180314123314.GG18129@dastard>
References: <CAOQ4uxjE31j7XDpEGnnym7cgD_kqsPnio4KN2gphajsCNMrG1g@mail.gmail.com>
 <20180311162442.GB2013@kroah.com>
 <20180312162744.GB4865@magnolia>
 <CAOQ4uxjn8UN2-Hzr8u404ydKf8s41yVpMA93-n7r6Dr2VBz3dA@mail.gmail.com>
 <CAOQ4uxhdkhZup=ndukKCRtU13YVs8jQxT0zgOT_XN3_-tB8TfQ@mail.gmail.com>
 <CAOQ4uxhCjBA99X_C-GpEBf=jC4S_wSrxMwS6Ovj7BtWLK1GmUA@mail.gmail.com>
 <20180313131109.GB6260@lst.de>
 <CAOQ4uxiDHSC19-fRdZmXM5BJB3-p9_LdPgSmxpjGrdCzhV2W2Q@mail.gmail.com>
 <20180313215028.GE18129@dastard>
 <CAOQ4uxgsMwtQRCkpJTJoVO-mbU1yRz7F0pMOAVcJphEEKq8SHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgsMwtQRCkpJTJoVO-mbU1yRz7F0pMOAVcJphEEKq8SHA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eryu Guan <eguan@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>

On Wed, Mar 14, 2018 at 08:24:30AM +0200, Amir Goldstein wrote:
> On Tue, Mar 13, 2018 at 11:50 PM, Dave Chinner <david@fromorbit.com> wrote:
> > AS I always say: if you want to maintain a stable backport kernel
> > with all the fixes that go into the bleeding edge, you're more than
> > welcome to do it.
> >
> > Everyone else is flat out just keeping up with on going development
> > and fixing bugs in the kernel as it's moving forward. So if you have
> > the need for stable backports, please keep backporting patches you
> > need, testing them and asking the stable maintainers to include
> > them.

[....]

> Dave,
> 
> It is often the case, though maybe not always, that the author of a patch
> has the knowledge of the 'Fixes' commit and/or the stable kernel version
> patch is relevant to or would easily apply to.

In my experience (especially from my time as the maintainer) working
out where a bug was introduced usually takes more time than it
does to notice the bug, fix, test, post and review the patch.

> It is therefore a relatively low effort for a developer to include
> this information

If it were easy, then everyone would just do it and everything would
be magically backported and it would all just work and everyone
would be happy.

Back in reality, however, it takes a *lot* of time and knowledge to
isolate where a bug was introduced and whether the fix is even
something we want to backport to older kernels . If you don't know
the code, a git bisect is the only resort and even then there's a
chance it doesn't isolate the cause because of some other bug or
change. And a bisect is even more time and resource intensive than
examining code history, especially for bugs introduced a long time
ago.

Hence asking developers to do this for every bug the fix ....

> as courtesy to stable maintainers,

.... is an unreasonable burden to place on developers and reviewers,
especially those that don't really know the code they are fixing in
any significant detail.

> whether they are maintaining kernel.org
> stable kernels or distro stable kernels.

I've done my fair share of distro kernel maintenance and 500+ patch
backports in the past. Doing backports requires looking at every
patch that isn't in the older kernel, working out if the change is
necessary and then working out all the dependencies that set of
necessary patches requires. It's time consuming, complex, and easy
to screw up, especially if you just blindly rely on "fixes" or
"stable" comments in commits.

IOWs, if all you're doing is relying on "fixes" tags to determine
what /might/ be needed in a stable kernel.org update, then your
stable backport process is fundamentally broken. You're going to
break things and make stable kernels worse for your users, not
better.

And that's ignoring the elephant in the room. The big difference
between distro backports and upstream stable kernels is the months
of QA and bug fixing spent on the distro backports before any user
gets near them.  "stable" kernels might only get a couple of days of
high level integration testing - it's really only enough to smoke
test everything.

We have never had the time and resources to do properly maintained
stable backports for upstream kernels because they move so fast and
there are so many of them.  It's a full time job in itself, and it's
substantially wasted effort because the upstream process throws most
of that work away every 3 months.

IOWs, if you want to maintain a long term stable upstream kernel
backport for XFS, then go and put the effort into doing it properly.
Don't demand that upstream developers do extra work on every change
they make just so you're not inconvenienced in the future by having
to do a little extra work when a one-off fix needs to be backported
to a stable kernel.org kernel.

> That's just my opinion.

Yup, everyone has one.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
