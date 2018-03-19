Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:43058 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753151AbeCSEDc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Mar 2018 00:03:32 -0400
MIME-Version: 1.0
In-Reply-To: <20180318230259.GJ7000@dastard>
References: <CAOQ4uxhubJhspfj+x7yRkTJ4rUXyhZoF0x3kjuFyv-0=Lxrctw@mail.gmail.com>
 <CAOQ4uxh0H8mbbAZt0MEdLGRY-8Aqg2c9UFM56-KL2b90fLYCFQ@mail.gmail.com>
 <20180317212814.GI7000@dastard> <CAOQ4uxit=nHvd2C080QeM27icSFra+0Anwu8vXqs4sd=8tCCNg@mail.gmail.com>
 <20180318230259.GJ7000@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 19 Mar 2018 06:03:30 +0200
Message-ID: <CAOQ4uxiHkW41RB4LogWi8+rp_NhoC+SHGNY9_ShdQi7OyJTTVA@mail.gmail.com>
Subject: Re: Question about XFS_MAXINUMBER
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

This thread has come to a point where I should have included fsdevel a
while ago,
so CCing fsdevel. For those interested in previous episodes:
https://marc.info/?l=linux-xfs&m=152120912822207&w=2

On Mon, Mar 19, 2018 at 1:02 AM, Dave Chinner <david@fromorbit.com> wrote:
> [....]
>
>> I should have mentioned that "foo" is a pure upper - a file that was created
>> as upper and let's suppose the real ino of "foo" in upper fs is 10.
>> And let's suppose that the real ino of "bar" on lower fs is also 10, which is
>> possible when lower fs is a different fs than upper fs.
>
> Ok, so to close the loop. The problem is that overlay has no inode
> number space of it's own, nor does it have any persistent inode
> number mapping scheme. Hence overlay has no way of providing users
> with a consistent, unique {dev,ino #} tuple to userspace when it's
> different directories lie on different filesystems.
>

Yes.

[...]
>> Because real pure upper inode and lower inode can have the same
>> inode number and we want to multiplex our way our of this collision.
>>
>> Note that we do NOT maintain a data structure for looking up used
>> lower/upper inode numbers, nor do we want to maintain a persistent
>> data structure for persistent overlay inode numbers that map to
>> real underlying inodes. AFAIK, aufs can use a small db for it's 'xino'
>> feature. This is something that we wish to avoid.
>
> SO instead of maintaining your own data structure to provide the
> necessary guarantees, the solution is to steal bits from the
> underlying filesystem inode numbers on the assumption they they will
> never user them?
>

Well, it is not an assumption if filesystem is inclined to publish
s_max_ino_bits, which is not that different in concept from publishing
s_maxbytes and s_max_links, which are also limitations in current
kernel/sb that could be lifted in the future.

> What happens when a user upgrades their kernel, the underlying fs
> changes all it's inode numbers because it's done some virtual
> mapping thing for, say, having different inode number ranges for
> separate mount namespaces? And so instead of having N bits of free
> inode number space before upgrade, it now has zero? How will overlay
> react to this sort of change, given it could expose duplicate inode
> numbers....

After kernel upgrade, filesystem would set s_max_ino_bits to 64 or
not set it at all and then overlayfs will not use high bits and fall back
to what it does today.

But if we want to bring practical arguments from containers
world into the picture, IMO it is far more likely that existing container
solution would benefit from overlayfs inode numbers multiplexing
than they would from inode number mapping by filesystem for
different mount namespace.

>
> Quite frankly, I think this "steal bits from the underlying
> filesystems" mechanism is a recipe for trouble. If you want play
> these games, you get to keep all the broken bits when filesystems
> change the number of available bits.
>

I don't see that as a problem. I would say there are a fair amount of
users out there using containers with overlayfs.

Do you realize that the majority of those users are settling for things
like: no directory rename, breaking hardlinks on copy up.
Those are "features" of overlayfs that have been fixed in recent kernels,
but only now on their way to distro kernels and not yet enabled
by container runtimes.

Container admins already make the choice of underlying fileystem
concisely to get the best from overlayfs and I would expect that
they will soon be opting in for xfs+reflink because of that concience
choice. If ever xfs decides to change inode numbers address space
on kernel upgrade without users opting in for it, I would be surprised,
but I should also hope that xfs would at least leave a choice for users
to opt-out of this behavior and that is what container admins would do.

Heck, for all I care, users could also opt-in for unused inode bits
explicitly (e.g. -o inode56) if you are concerned about letting go
of those upper bits implicitly.
My patch set already provides the capability for users to declare
with overlay -o xino that enough upper bits are available (i.e. because
user knows the underlying fs and its true practical limits). But the
feature will be much more useful if users disn't have to do that.

> Given that overlay has a persistent inode numbering problem, why
> doesn't overlay just allocate and store it's own inode numbers and
> other required persistent state in an xattr?
>

First, this is not as simple as it sounds.
If you have a huge number of readonly files in multiple lower layers,
it makes no sense to scan them all on overlay mount to discover which
inode numbers are free to use and it make no sense either to create
a persistent mapping for every lower file accessed in that case.
And there are other problematic factors with this sort of scheme.

Second, and this may be a revolutionary argument, I would like to
believe that we are all working together for a "greater good".
Sure, xfs developers strive to perfect and enhance xfs and overlayfs
developers strive to perfect and enhance overlayfs.
But when there is an opportunity for synergy between subsystems,
one should consider the best solution as a whole and IMHO,
the solution of filesystem declaring already unused ino bits
is the best solution as a whole. xfs is not required to declare
s_max_ino_bits for all eternity, only for this specific super block
instance, in this specific kernel.

Thanks,
Amir.
