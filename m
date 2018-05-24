Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31543 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935171AbeEXDzg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 May 2018 23:55:36 -0400
Date: Thu, 24 May 2018 13:55:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bugs involving maliciously crafted file system
Message-ID: <20180524035532.GC23861@dastard>
References: <000000000000457b2d056cbb0044@google.com>
 <20180522123107.GC3751@bfoster.bfoster>
 <20180522222620.GW23861@dastard>
 <20180522225208.GB658@sol.localdomain>
 <20180523074425.GM14384@magnolia>
 <20180523162015.GA3684@sol.localdomain>
 <a52266f9-0096-b28c-c01c-046ababcfe3a@sandeen.net>
 <20180523234114.GA3434@thunk.org>
 <20180524004931.GB23861@dastard>
 <20180524005906.GC3434@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180524005906.GC3434@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@sandeen.net>, Eric Biggers <ebiggers3@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

On Wed, May 23, 2018 at 08:59:06PM -0400, Theodore Y. Ts'o wrote:
> On Thu, May 24, 2018 at 10:49:31AM +1000, Dave Chinner wrote:
> > 
> > We've learnt this lesson the hard way over and over again: don't
> > parse untrusted input in privileged contexts. How many times do we
> > have to make the same mistakes before people start to learn from
> > them?
> 
> Good question.  For how many years (or is it decades, now) has Fedora
> auto-mounted USB sticks?  :-) Let me know when you successfully get
> Fedora to turn of a feature which appears to have great user appeal.

They'll do that when we provide them with a safe, easy to use
solution to the problem. This is our problem to solve, not
blame-shift it away.

> And I'll note that Eric Beiderman just posted a patch series allowing
> unprivileged processes to mount file systems in containers.

Yup, that's to make it easy for virtual kernel filesystems to be
mounted inside containers, and to solve some of FUSEs security
issues caused by needing root permissions to mount FUSE filesystems.

Enabling unprivileged mounts requires an opt-in flag in the
filesystem fs-type definition, and we most certainly won't be
setting that flag on XFS. I also doubt it will ever get set on any
other existing block device based filesystem because of the trust
model problems it exposes.

> And remember the mantra which the containner people keep chanting.
> Containers are just as secure as VM's.   Hahahaha.....

So your solution is to have VM guests and container users spin up
sandboxed VMs to access filesystem images safely? That's not really
a practical solution. :/

> > User automounting of removable storage should be done via a
> > privilege separation mechanism and hence avoid this whole class of
> > security problems. We can get this separation by using FUSE in these
> > situations, right?
> 
> FUSE is a pretty terrible security boundary.

That may be true, but it's so much better than using the kernel to
parse untrusted filesystem metadata.

> And not all file systems
> have FUSE support.

Except there is now fusefs-lkl, so all kernel filesystem are fully
accessible through FUSE.

> > Bugs don't have to be exploitable to be a "security issue". Detected
> > filesystem corruptions on a errors=panic mount, or undetected
> > problems that cause a x/NULL deref are still a user-triggerable
> > kernel crash (i.e. a DOS) and therefore considered a security
> > problem.
> 
> I disagree here.  I think it's worth it to disambiguate the two.

Been trying to get security people to understand this for years.
I've given up because there's always some new security person who
follows The Process and simply does not understand that there is a
difference.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
