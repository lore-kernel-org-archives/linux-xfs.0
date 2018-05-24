Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47146 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935196AbeEXA7M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 May 2018 20:59:12 -0400
Date: Wed, 23 May 2018 20:59:06 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: Bugs involving maliciously crafted file system
Message-ID: <20180524005906.GC3434@thunk.org>
References: <000000000000457b2d056cbb0044@google.com>
 <20180522123107.GC3751@bfoster.bfoster>
 <20180522222620.GW23861@dastard>
 <20180522225208.GB658@sol.localdomain>
 <20180523074425.GM14384@magnolia>
 <20180523162015.GA3684@sol.localdomain>
 <a52266f9-0096-b28c-c01c-046ababcfe3a@sandeen.net>
 <20180523234114.GA3434@thunk.org>
 <20180524004931.GB23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180524004931.GB23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eric Biggers <ebiggers3@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

On Thu, May 24, 2018 at 10:49:31AM +1000, Dave Chinner wrote:
> 
> We've learnt this lesson the hard way over and over again: don't
> parse untrusted input in privileged contexts. How many times do we
> have to make the same mistakes before people start to learn from
> them?

Good question.  For how many years (or is it decades, now) has Fedora
auto-mounted USB sticks?  :-) Let me know when you successfully get
Fedora to turn of a feature which appears to have great user appeal.

And I'll note that Eric Beiderman just posted a patch series allowing
unprivileged processes to mount file systems in containers.

And remember the mantra which the containner people keep chanting.
Containers are just as secure as VM's.   Hahahaha.....

> User automounting of removable storage should be done via a
> privilege separation mechanism and hence avoid this whole class of
> security problems. We can get this separation by using FUSE in these
> situations, right?

FUSE is a pretty terrible security boundary.  And not all file systems
have FUSE support.  As I had suggested earlier, probably better to use
9P, and mount the file system in a VM.

> Bugs don't have to be exploitable to be a "security issue". Detected
> filesystem corruptions on a errors=panic mount, or undetected
> problems that cause a x/NULL deref are still a user-triggerable
> kernel crash (i.e. a DOS) and therefore considered a security
> problem.

I disagree here.  I think it's worth it to disambiguate the two.  If
you have physical access to the machine, you can also apply AC mains
voltage to the USB port, which will likely cause the system to crash.
And at least for Chrome OS, it reboots really quickly.  :-)

If someone can gain control of the system so they can exfiltrate data,
or be able to modify files owned as root, that's a much bigger deal
that crashing the machcine in my view.

							- Ted
