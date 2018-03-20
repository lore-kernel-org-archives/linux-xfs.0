Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f173.google.com ([209.85.213.173]:43819 "EHLO
        mail-yb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751768AbeCTG3m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 02:29:42 -0400
MIME-Version: 1.0
In-Reply-To: <20180320014709.GC1150@dastard>
References: <CAOQ4uxhubJhspfj+x7yRkTJ4rUXyhZoF0x3kjuFyv-0=Lxrctw@mail.gmail.com>
 <CAOQ4uxh0H8mbbAZt0MEdLGRY-8Aqg2c9UFM56-KL2b90fLYCFQ@mail.gmail.com>
 <20180317212814.GI7000@dastard> <CAOQ4uxit=nHvd2C080QeM27icSFra+0Anwu8vXqs4sd=8tCCNg@mail.gmail.com>
 <20180318230259.GJ7000@dastard> <CAOQ4uxiHkW41RB4LogWi8+rp_NhoC+SHGNY9_ShdQi7OyJTTVA@mail.gmail.com>
 <20180320014709.GC1150@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 20 Mar 2018 08:29:35 +0200
Message-ID: <CAOQ4uxh+90vyCOqhLXtNi0U+YTsi6nCYuZFJMPhBWUaRwSBDvQ@mail.gmail.com>
Subject: Re: Question about XFS_MAXINUMBER
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Mar 20, 2018 at 3:47 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Mar 19, 2018 at 06:03:30AM +0200, Amir Goldstein wrote:
[...]
>> Well, it is not an assumption if filesystem is inclined to publish
>> s_max_ino_bits, which is not that different in concept from publishing
>> s_maxbytes and s_max_links, which are also limitations in current
>> kernel/sb that could be lifted in the future.
>
> It is different, because you're expecting to be able to publish
> persistent user visible information based on it.
>
> If we change s_max_ino_bits in the underlying filesystem, then
> overlay inode numbers change and that can cause all sorts of problem
> with things like filehandles, backups that use dev/inode number
> tuples to detect identical files, etc.  i.e. there's a heap of
> downstream impacts of changing inode numbers. If we have to
> publish s_max_ino_bits to the VFS, we essentially fix the ABI of the
> user visible inode number the filesysetm publishes. IOWs, we
> effectively can't change it without breaking external users.
>

You are right.

> I suspect you don't realise we already expose the full 64 bit
> inode number space completely to userspace through other ABIs. e.g.
> the bulkstat ioctls. We've already got applications that use the XFS
> inode number as a 64 bit value both to and from the kernel (e.g.
> xfs_dump, file handle encoding, etc), so the idea that we can now
> take bits back from what we've already agreed to expose to userspace
> is fraught with problems.

I'm sorry. There must be something I am missing.
Are users exposed to high ino bits via xfs tools other than NULLFSINO
NULLAGINO? If they are then I did not find where.
And w.r.t to NULLINO (-1), that ino is not exposed via getattr() and readdir(),
so not a problem for overlayfs.

>
> That's the problem I see here - it's not that we /can't/ implement
> s_max_ino_bits, the problem is that once we publish it we can't
> change it because it will cause random breakage of applications
> using it. And because we've already effectively published it to
> userspace applications as s_max_ino_bits = 64, there's no scope for
> movement at all.
>

Agreed. So we can add an explicit compat feature bit to declare that user
would like to limit future use of high ino bits on his fs.
Makes me wonder, how come there is no feature to block "inode64"
mount option, so user can declare he wishes to keep the fs fully
compatible for mounting on 32bit systems?

[...]

> We've done this many times in the past. e.g. we changed the default
> inode allocation policy from inode32 to inode64 back in 2012. That
> means users, on kernel upgrade, silently went from 32 bit inodes to
> 64 bit inodes. We've done this because of the fact that the
> *filesystem owns the entire inode number space* and as long as we
> don't change individual inode numbers that users see for a specific
> inode, we can do whatever we want inside that inode number space.
>

Right. My main point is that, unless I am missing something, never in
xfs history, was a non NULL inode number exposed to user with high
8 bits used, so at least forward/backward compat for "inode56" feature
is not going to be a big challenge.

>> > Given that overlay has a persistent inode numbering problem, why
>> > doesn't overlay just allocate and store it's own inode numbers and
>> > other required persistent state in an xattr?
>> >
>>
>> First, this is not as simple as it sounds.
>
> Sure, just like s_max_ino_bits is not as simple as it sounds.

It never is ;-)

>
> If we want to explicitly reserve part of the inode number space for
> other layers to use for their own purposes, then we need to
> explicitly and persistently support that in the underlying
> filesystem. That means mkfs, repair, db, growfs, etc all need to
> understand that inode numbers have a size limit and do the right
> thing...
>
> That makes it an opt-in configuration that we can test and support
> without having to care about overlay implementations or backwards
> compatibility across applications on existing filesystems.
>

OK. I'll work on a proposal.

>> Second, and this may be a revolutionary argument, I would like to
>> believe that we are all working together for a "greater good".
>
> I don't say no for the fun of saying no. I say no because I think
> something is a bad idea. Just because I say no doesn't mean I don't
> don't want to solve the problem. It just means that I think the
> solution being presented is a bad idea and we need to explore the
> problem space for a more robust solution.
>

And I do appreciate the time you've put into understanding the overlayfs
problem and explaining the problems with my current proposal.

Thanks,
Amir.
