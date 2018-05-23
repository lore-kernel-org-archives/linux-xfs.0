Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46962 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935015AbeEWXlV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 May 2018 19:41:21 -0400
Date: Wed, 23 May 2018 19:41:15 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Bugs involving maliciously crafted file system
Message-ID: <20180523234114.GA3434@thunk.org>
References: <000000000000457b2d056cbb0044@google.com>
 <20180522123107.GC3751@bfoster.bfoster>
 <20180522222620.GW23861@dastard>
 <20180522225208.GB658@sol.localdomain>
 <20180523074425.GM14384@magnolia>
 <20180523162015.GA3684@sol.localdomain>
 <a52266f9-0096-b28c-c01c-046ababcfe3a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a52266f9-0096-b28c-c01c-046ababcfe3a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Biggers <ebiggers3@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

On Wed, May 23, 2018 at 01:01:59PM -0500, Eric Sandeen wrote:
> 
> What I'm personally hung up on are the bugs where the "exploit" involves merely
> mounting a crafted filesystem that in reality would never (until the heat death
> of the universe) corrupt itself into that state on its own; it's the "malicious
> image" case, which is quite different than exposing fundamental bugs like the
> SB_BORN race or or the user-exploitable ext4 flaw you mentioned in your reply.
> Those are more insidious and/or things which can be hit by real users in real life.

Well, it *can* be hit in real life.  If you have a system which auto
mounts USB sticks, then an attacker might be able to weaponize that
bug by creating a USB stick where mounted and the user opens a
particular file, the buffer overrun causes code to be executed that
grabs the user's credentials (e.g., ssh-agent keys, OATH creds, etc.)
and exfiltrates them to a collection server.

Fedora and Chrome OS might be two such platforms where someone could
very easily create a weaponized exploit tool where you could insert a
file system buffer overrun bug, and "hey presto!" it becomes a serious
zero day vulnerability.

(I recently suggested to a security researcher who was concerned that
file system developers weren't taking these sorts of things seriously
enough could do a service to the community by creating a demonstration
about how these sorts of bugs can be weaponized.  And I suspect it
could be about just as easily on Chrome OS as Fedora, and that can be
one way that an argument could be made to management that more
resources should be applied to this problem.  :-)

Of course, not all bugs triggered by a maliciously crafted file system
are equally weaponizable.  An errors=panic or a NULL derefrence are
probably not easily exploitable at all.  A buffer overrun (and I fixed
two in ext4 in the last two days while being stuck in a T13 standards
meeting, so I do feel your pain) might be a very different story.

Solutions
---------

One of the things I've wanted to get help from the syzbot folks is if
there was some kind of machine learning or expert system evaluation
that could be done so malicious image bugs could be binned into
different categories, based on how easily they can be weaponized.
That way, when there is a resource shortage situation, humans can be
more easily guided into detremining which bugs should be prioritized
and given attention, and which we can defer to when we have more time.
Or maybe it would be useful if there was a way where maintainers could
be able to annotate bugs with priority and severity levels, and maybe
make comments that can be viewed from the Syzbot dashboard UI.


The other thing that perhaps could be done is to set up a system where
the USB stick is automounted in a guest VM (using libvirt in Fedora,
and perhaps Crostini for Chrome OS), and the contents of the file
system would then get exported from the guest OS to the host OS using
either NFS or 9P.  (9P2000.u is the solution that was used in
gVisor[1].)

[1] https://github.com/google/gvisor

It could be that putting this kind of security layer in front to
automounted USB sticks is less work than playing whack-a-mole fixing a
lot of security bugs with maliciously crafted file systems.  

					- Ted
