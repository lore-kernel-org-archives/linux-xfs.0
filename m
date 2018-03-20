Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:33920 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751718AbeCTBrM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Mar 2018 21:47:12 -0400
Date: Tue, 20 Mar 2018 12:47:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question about XFS_MAXINUMBER
Message-ID: <20180320014709.GC1150@dastard>
References: <CAOQ4uxhubJhspfj+x7yRkTJ4rUXyhZoF0x3kjuFyv-0=Lxrctw@mail.gmail.com>
 <CAOQ4uxh0H8mbbAZt0MEdLGRY-8Aqg2c9UFM56-KL2b90fLYCFQ@mail.gmail.com>
 <20180317212814.GI7000@dastard>
 <CAOQ4uxit=nHvd2C080QeM27icSFra+0Anwu8vXqs4sd=8tCCNg@mail.gmail.com>
 <20180318230259.GJ7000@dastard>
 <CAOQ4uxiHkW41RB4LogWi8+rp_NhoC+SHGNY9_ShdQi7OyJTTVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiHkW41RB4LogWi8+rp_NhoC+SHGNY9_ShdQi7OyJTTVA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Mar 19, 2018 at 06:03:30AM +0200, Amir Goldstein wrote:
> This thread has come to a point where I should have included fsdevel a
> while ago,
> so CCing fsdevel. For those interested in previous episodes:
> https://marc.info/?l=linux-xfs&m=152120912822207&w=2
> 
> On Mon, Mar 19, 2018 at 1:02 AM, Dave Chinner <david@fromorbit.com> wrote:
> > [....]
> >
> >> I should have mentioned that "foo" is a pure upper - a file that was created
> >> as upper and let's suppose the real ino of "foo" in upper fs is 10.
> >> And let's suppose that the real ino of "bar" on lower fs is also 10, which is
> >> possible when lower fs is a different fs than upper fs.
> >
> > Ok, so to close the loop. The problem is that overlay has no inode
> > number space of it's own, nor does it have any persistent inode
> > number mapping scheme. Hence overlay has no way of providing users
> > with a consistent, unique {dev,ino #} tuple to userspace when it's
> > different directories lie on different filesystems.
> >
> 
> Yes.
> 
> [...]
> >> Because real pure upper inode and lower inode can have the same
> >> inode number and we want to multiplex our way our of this collision.
> >>
> >> Note that we do NOT maintain a data structure for looking up used
> >> lower/upper inode numbers, nor do we want to maintain a persistent
> >> data structure for persistent overlay inode numbers that map to
> >> real underlying inodes. AFAIK, aufs can use a small db for it's 'xino'
> >> feature. This is something that we wish to avoid.
> >
> > SO instead of maintaining your own data structure to provide the
> > necessary guarantees, the solution is to steal bits from the
> > underlying filesystem inode numbers on the assumption they they will
> > never user them?
> >
> 
> Well, it is not an assumption if filesystem is inclined to publish
> s_max_ino_bits, which is not that different in concept from publishing
> s_maxbytes and s_max_links, which are also limitations in current
> kernel/sb that could be lifted in the future.

It is different, because you're expecting to be able to publish
persistent user visible information based on it.

If we change s_max_ino_bits in the underlying filesystem, then
overlay inode numbers change and that can cause all sorts of problem
with things like filehandles, backups that use dev/inode number
tuples to detect identical files, etc.  i.e. there's a heap of
downstream impacts of changing inode numbers. If we have to
publish s_max_ino_bits to the VFS, we essentially fix the ABI of the
user visible inode number the filesysetm publishes. IOWs, we
effectively can't change it without breaking external users.

I suspect you don't realise we already expose the full 64 bit
inode number space completely to userspace through other ABIs. e.g.
the bulkstat ioctls. We've already got applications that use the XFS
inode number as a 64 bit value both to and from the kernel (e.g.
xfs_dump, file handle encoding, etc), so the idea that we can now
take bits back from what we've already agreed to expose to userspace
is fraught with problems.

That's the problem I see here - it's not that we /can't/ implement
s_max_ino_bits, the problem is that once we publish it we can't
change it because it will cause random breakage of applications
using it. And because we've already effectively published it to
userspace applications as s_max_ino_bits = 64, there's no scope for
movement at all.

> Do you realize that the majority of those users are settling for things
> like: no directory rename, breaking hardlinks on copy up.
> Those are "features" of overlayfs that have been fixed in recent kernels,
> but only now on their way to distro kernels and not yet enabled
> by container runtimes.
> 
> Container admins already make the choice of underlying fileystem
> concisely to get the best from overlayfs and I would expect that
> they will soon be opting in for xfs+reflink because of that concience
> choice. If ever xfs decides to change inode numbers address space
> on kernel upgrade without users opting in for it,

We've done this many times in the past. e.g. we changed the default
inode allocation policy from inode32 to inode64 back in 2012. That
means users, on kernel upgrade, silently went from 32 bit inodes to
64 bit inodes. We've done this because of the fact that the
*filesystem owns the entire inode number space* and as long as we
don't change individual inode numbers that users see for a specific
inode, we can do whatever we want inside that inode number space.

> > Given that overlay has a persistent inode numbering problem, why
> > doesn't overlay just allocate and store it's own inode numbers and
> > other required persistent state in an xattr?
> >
> 
> First, this is not as simple as it sounds.

Sure, just like s_max_ino_bits is not as simple as it sounds.

If we want to explicitly reserve part of the inode number space for
other layers to use for their own purposes, then we need to
explicitly and persistently support that in the underlying
filesystem. That means mkfs, repair, db, growfs, etc all need to
understand that inode numbers have a size limit and do the right
thing...

That makes it an opt-in configuration that we can test and support
without having to care about overlay implementations or backwards
compatibility across applications on existing filesystems.

> Second, and this may be a revolutionary argument, I would like to
> believe that we are all working together for a "greater good".

I don't say no for the fun of saying no. I say no because I think
something is a bad idea. Just because I say no doesn't mean I don't
don't want to solve the problem. It just means that I think the
solution being presented is a bad idea and we need to explore the
problem space for a more robust solution.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
