Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34513 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750813AbdEIVRu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 May 2017 17:17:50 -0400
Date: Tue, 9 May 2017 14:17:46 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] ioctl_getfsmap.2: document the GETFSMAP ioctl
Message-ID: <20170509211746.GA87747@gmail.com>
References: <20170507155855.GD5970@birch.djwong.org>
 <CAG48ez1AWewJRg8gySgihn0y15jRhC6C+5DNwGsDpAhtokB=Lw@mail.gmail.com>
 <20170508184112.GJ5973@birch.djwong.org>
 <CAG48ez3e+2VuvjtEfJuMujEo6PWBO3z8oM-otN2juq96jKdjCw@mail.gmail.com>
 <20170508204738.GL5973@birch.djwong.org>
 <CAG48ez0iLRazKvXty9CG8ENXvkG6b1xjO0Q75p+16HKNptFnow@mail.gmail.com>
 <20170509015324.GM5973@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170509015324.GM5973@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jann Horn <jannh@google.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, linux-man@vger.kernel.org

On Mon, May 08, 2017 at 06:53:24PM -0700, Darrick J. Wong wrote:
> > >> an unprivileged user to determine with high probability whether a set
> > >> of large files with known sizes is stored anywhere in the filesystem, even
> > >> across containers or so.
> > >
> > > How large?  How high?
> > >
> > > Do you have a tool that analyzes a set of st_blocks values and compares
> > > the set to known profiles in order to guess what's on the filesystem?
> > > With what accuracy can it do that, especially without explicit path or
> > > stat data?  The maximum resolution provided by the ioctl is fs block
> > > size, so it's not like you can guess that this 1268432 byte file is
> > > libclangAnalysis.a; all you know is that there are four 310-block files
> > > on this filesystem -- on this system that's the desktop wallpaper, a
> > > file from each of libclang and libgimp, and libc6 from my aarch64 guest.
> > 
> > This would probably become more realistic for larger files, like
> > conference recordings - with sizes like 200075, 48338, 155870, 134800
> > blocks -, although admittedly I don't have a specific scenario in mind in
> > which someone knowing what conference recordings I have on my disk
> > would be problematic.
> 
> TBH, I /did/ build a (crappy) tool that tries to construct fingerprints
> based on the fsmaps it finds for each inode number.  It works reasonably
> well for identifying the existence (and number) of reflink clones of any
> part of the file tree that you can stat and FIEMAP.  It also works (sort
> of) if you have multiple separate filesystems with roughly the same fs
> trees in them.  Mixing things into one big file produces a lot of noise,
> and data files are harder to pick out unless they're deduped.
> 
> > You're probably right about this not being a particularly important
> > concern, and I recognize that if I had wanted a different API, I should
> > have said so a year ago.
> 
> I don't mind people bringing up specific concerns and making specific
> requests for the rest of the 4.12 cycle since it's relatively easy to
> make small changes to the interface (e.g. adding a capability check).
> 

I was also surprised to see that there is no authorization check.  Using this
ioctl, *anyone* will be able to retrieve the precise list of physical blocks
used by every inode on the filesystem, even ones that are only linked to in
directories the user doesn't have read permission for, or aren't even visible in
their mount namespace.

I am most concerned about:

1.) Privacy implications.  Say the filesystem is being shared between multiple
    users, and one user unpacks foo.tar.gz into their home directory, which
    they've set to mode 700 to hide from other users.  Because of this new
    ioctl, all users will be able to see every (inode number, size in blocks)
    pair that was added to the filesystem, as well as the exact layout of the
    physical block allocations which might hint at how the files were created.
    If there is a known "fingerprint" for the unpacked foo.tar.gz in this
    regard, its presence on the filesystem will be revealed to all users.  And
    if any filesystems happen to prefer allocating blocks near the containing
    directory, the directory the files are in would likely be revealed too.
    
    Also note that by repeatedly executing the ioctl, all users will be able to
    see at what time any arbitrary inode was added to the filesystem, as well as
    exactly when any arbitrary inode was truncated, or otherwise modified in a
    way that changed its extent mappings.  More generally, all users will be
    able to follow the evolution of any arbitrary set of inodes over time.   In
    a shared hosting environment this could allow anyone to determine many of
    the characteristics of other containers being hosted by the kernel, such as
    which software and software versions they're using (or at least, to a higher
    degree of confidence than other side channels that may be available
    currently).

2.) Abusing the ioctl as an information leak in combination with another
    security vulnerability.  For example let's say that there's a vulnerability
    in xfs or ext4 that allows writing (but not reading) to an arbitrary
    physical disk block.  Now obviously there are many ways this could be
    exploited, but let's say you're in a container, so just elevating to root in
    the container isn't enough, and you don't know where the critical system
    files are.  Using the fsmap ioctl to get the extent mappings of *all* files
    on the filesystem, you may still be able to determine with a high degree of
    confidence which physical disk blocks hold the contents of files outside the
    container that could be backdoored, e.g. /etc/shadow, or some binary in /bin
    or /lib, or perhaps a kernel module in /lib/modules.

So given that this ioctl operates on the global filesystem and not on a
particular file, it really seems like more of an administrator-level thing
(capable(CAP_SYS_ADMIN)), not something that any random user should be able to
execute.

- Eric
