Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 22C567FBA
	for <xfs@oss.sgi.com>; Sat, 17 Oct 2015 09:40:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 01FEA8F8040
	for <xfs@oss.sgi.com>; Sat, 17 Oct 2015 07:39:56 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 4GkQ4r7DrBdTfiHn (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 17 Oct 2015 07:39:54 -0700 (PDT)
Date: Sat, 17 Oct 2015 10:39:51 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs: Richacl support
Message-ID: <20151017143951.GA2678@thunk.org>
References: <CAHc6FU5s7-t3+jtKDusVFqc542Ag7pEOTUqp1LSxg8_uCPyF=A@mail.gmail.com>
	<20151016231615.GF15011@thunk.org>
	<CAHc6FU5B35D30Cc0-iSAfKDrCfc29paYe-tg-GGP7KEH08+2rA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU5B35D30Cc0-iSAfKDrCfc29paYe-tg-GGP7KEH08+2rA@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Sat, Oct 17, 2015 at 02:22:25AM +0200, Andreas Gruenbacher wrote:
> > Suppose we mounted a file system with richacl's on a kernel that
> > didn't understand it, and we write to from that non-richacl kernel.
> > What's the worse that could happen?
> 
> Two things are likely to happen. First, richacls will not be enforced;
> this can cause fewer or more permissions to be granted. Second, when
> files are created, permission inheritance will not take place, so when
> the filesystem is later used by a richacl aware kernel, permissions
> will be inconsistent.
> 
> > So why would this result in incompatible file systems?
> 
> The filesystems will not become incompatible in an e2fsck sense, but
> it will generally become unsafe to expose in a multi-user environment.
> So the question is what the different kinds of feature flags are
> supposed to protect from exactly.

Hmm.  So my original conception of the ext2/3/4 feature flags was more
about incompatibility from a e2fsck sense --- what I would call in a
metadata self-consistency sense.  I don't think we ever thought about
the failure of the inheritance to be an "inconsistency".  Perhaps it
would be considered such from a semantic point of view, but it's not
something we could ever check using e2fsck, since it's possible that
the user had intentionally removed the richacl from a file, even
though all of the other files in the directory have a richacl which
matches the default directory inheritance acl.

So the downside of using a feature flag (and it doesn't matter whether
it's an incompat or a read-only flag) is that it requires new versions
of e2fsprogs in order to be able to support the file system --- when
it really doesn't matter from an e2fsprogs support perspective.

One way of dealing with this is would be use a new mount option to
enable richacls (e.g., "richacl"), which older kernels would fail to
recognize and would thus fail the mount.  This works since the most
likely failure case is if the user boots into an older kernel.

This doesn't protect against the case where someone is using richacls
on a USB stick, and moves it over to another system --- but that seems
like a use case that's not very likely.  It also doesn't help against
someone using an old rescue cd-rom, but in that case, it's not clear
that it's hugely problematic, either -- someone using rescue media has
physical access to the machine, so access controls are generally not a
major concern, and they are also not likely to be making wholesale
changes to the file system where acl inheritance is going to be a
primary concern, either.

This is basically how we handled the POSIX acl situation for ext4 ---
we just required a mount option to enable it, originally and
eventually we defaulted the option to always on once it was highly
unlikely someone was going to be trying to install, say, a 2.6 kernel
on an enterprise userspace --- which was not likely to work at all.

What do you think?  If we really want to burn a feature flag, I'd
probably use a RO_INCOMPAT flag rather than an INCOMPAT flag, on the
theory that read-only mounts are much more often used for system
administration.  But it might be using a mount option is a better way
to go here.

Cheers,

							- Ted

P.S.  I can imagine adding new KERNEL_INCOMPAT and KERNEL_ROCOMPAT
feature set flags in the superblock which are ignored by e2fsprogs,
but only used by the kernel.  This might be helpful in the future, but
it won't help us now, since old kernels won't be checking them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
