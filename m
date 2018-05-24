Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:43723 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935197AbeEXAtf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 May 2018 20:49:35 -0400
Date: Thu, 24 May 2018 10:49:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bugs involving maliciously crafted file system
Message-ID: <20180524004931.GB23861@dastard>
References: <000000000000457b2d056cbb0044@google.com>
 <20180522123107.GC3751@bfoster.bfoster>
 <20180522222620.GW23861@dastard>
 <20180522225208.GB658@sol.localdomain>
 <20180523074425.GM14384@magnolia>
 <20180523162015.GA3684@sol.localdomain>
 <a52266f9-0096-b28c-c01c-046ababcfe3a@sandeen.net>
 <20180523234114.GA3434@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180523234114.GA3434@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@sandeen.net>, Eric Biggers <ebiggers3@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

On Wed, May 23, 2018 at 07:41:15PM -0400, Theodore Y. Ts'o wrote:
> On Wed, May 23, 2018 at 01:01:59PM -0500, Eric Sandeen wrote:
> > 
> > What I'm personally hung up on are the bugs where the "exploit" involves merely
> > mounting a crafted filesystem that in reality would never (until the heat death
> > of the universe) corrupt itself into that state on its own; it's the "malicious
> > image" case, which is quite different than exposing fundamental bugs like the
> > SB_BORN race or or the user-exploitable ext4 flaw you mentioned in your reply.
> > Those are more insidious and/or things which can be hit by real users in real life.
> 
> Well, it *can* be hit in real life.  If you have a system which auto
> mounts USB sticks, then an attacker might be able to weaponize that
> bug by creating a USB stick where mounted and the user opens a
> particular file, the buffer overrun causes code to be executed that
> grabs the user's credentials (e.g., ssh-agent keys, OATH creds, etc.)
> and exfiltrates them to a collection server.

We've learnt this lesson the hard way over and over again: don't
parse untrusted input in privileged contexts. How many times do we
have to make the same mistakes before people start to learn from
them?

User automounting of removable storage should be done via a
privilege separation mechanism and hence avoid this whole class of
security problems. We can get this separation by using FUSE in these
situations, right?

> Fedora and Chrome OS might be two such platforms where someone could
> very easily create a weaponized exploit tool where you could insert a
> file system buffer overrun bug, and "hey presto!" it becomes a serious
> zero day vulnerability.

There's little we can do to prevent people from exploiting
flaws in the filesystem's on-disk format. No filesystem has robust,
exhaustive verification of all it's metadata, nor is that
something we can really check at runtime due to the complexity
and overhead of runtime checking.

And then when you consider all the avenues to data exposure and
unprivileged runtime manipulation of on-disk metadata (e.g.
intentionally cross linking critical metadata blocks into user
data files), it's pretty obvious that untrusted filesystem images
are not something that should *ever* be parsed in a privileged
context.

> (I recently suggested to a security researcher who was concerned that
> file system developers weren't taking these sorts of things seriously
> enough could do a service to the community by creating a demonstration
> about how these sorts of bugs can be weaponized.  And I suspect it
> could be about just as easily on Chrome OS as Fedora, and that can be
> one way that an argument could be made to management that more
> resources should be applied to this problem.  :-)

There's "taking it seriously" and then there's "understanding that
we can't stop new exploits from being developed because they
exploit a flaw in the trust model".

i.e. kernel filesystems are built on a directly connected trust
model where the storage "guarantees" it will return exactly what the
filesystem has stored in it.  Hence our filesystems are not built
around tamper-evident/tamper-proof structures and algorithms that
are needed to robustly detect 3rd-party manipulation because their
trust model says they don't need to defend against such attacks.

As such, the most robust way I can see of defending *the kernel*
against malicious/untrusted filesystem images is to move parsing of
those images out of the kernel privilege context altogether. The
parser can then be sandboxed appropriately as you suggested and
we've avoided the problem of kernel level exploits from malicious
filesystem images....

> Of course, not all bugs triggered by a maliciously crafted file system
> are equally weaponizable.  An errors=panic or a NULL derefrence are
> probably not easily exploitable at all.

Bugs don't have to be exploitable to be a "security issue". Detected
filesystem corruptions on a errors=panic mount, or undetected
problems that cause a x/NULL deref are still a user-triggerable
kernel crash (i.e. a DOS) and therefore considered a security
problem.

> A buffer overrun (and I fixed
> two in ext4 in the last two days while being stuck in a T13 standards
> meeting, so I do feel your pain) might be a very different story.

The fact you are currently finding and fixing buffer overuns in ext4
solidly demonstrates my point about existing filesystems being
largely untrustable and unfixable. :/

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com
