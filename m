Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47706 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752924AbdEHUrr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 May 2017 16:47:47 -0400
Date: Mon, 8 May 2017 13:47:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ioctl_getfsmap.2: document the GETFSMAP ioctl
Message-ID: <20170508204738.GL5973@birch.djwong.org>
References: <20170507155855.GD5970@birch.djwong.org>
 <CAG48ez1AWewJRg8gySgihn0y15jRhC6C+5DNwGsDpAhtokB=Lw@mail.gmail.com>
 <20170508184112.GJ5973@birch.djwong.org>
 <CAG48ez3e+2VuvjtEfJuMujEo6PWBO3z8oM-otN2juq96jKdjCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez3e+2VuvjtEfJuMujEo6PWBO3z8oM-otN2juq96jKdjCw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jann Horn <jannh@google.com>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, linux-man@vger.kernel.org

On Mon, May 08, 2017 at 08:47:56PM +0200, Jann Horn wrote:
> On Mon, May 8, 2017 at 8:41 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > On Mon, May 08, 2017 at 12:17:53AM +0200, Jann Horn wrote:
> >> On Sun, May 7, 2017 at 5:58 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >> > Document the new GETFSMAP ioctl that returns the physical layout of a
> >> > (disk-based) filesystem.
> [...]
> >> Also: From a quick glance at the XFS implementation, I don't see any
> >> privilege checks. Am I missing something, or does this API permit an
> >> unprivileged user to determine the number of physical blocks allocated
> >> for any inode, even for inodes the user can't ordinarily see in any
> >> way?
> >
> > Correct.
> 
> What's your reasoning for why this doesn't create any new potential
> security issues? For example, as far as I can tell, this would permit

/Any/ ?  That is a huge request to be dropping on me after the vfs patch
gets merged, after a year-long review cycle, etc.  AFAIK there aren't
any problems, but then that's part of why I let this thing hang out to
dry for such a long time.  Even posessing the inode number, an
unprivileged process still cannot open files they wouldn't otherwise
have access, since that requires the generation number, and only
bulkstat provides that (if you have CAP_SYS_ADMIN).

The whole reason for dropping the CAP_SYS_ADMIN check from GETFSMAP was
(a) so that unpriviledged users could compute free space information and
(b) to allow dedupe tools to make better decisions about which file
donates blocks and which file accepts blocks.

If you have specific complaints, then let's hear and address them.  I'm
not going to try to prove a broad negative theoretical statement.

Moving on...

> an unprivileged user to determine with high probability whether a set
> of large files with known sizes is stored anywhere in the filesystem, even
> across containers or so.

How large?  How high?

Do you have a tool that analyzes a set of st_blocks values and compares
the set to known profiles in order to guess what's on the filesystem?
With what accuracy can it do that, especially without explicit path or
stat data?  The maximum resolution provided by the ioctl is fs block
size, so it's not like you can guess that this 1268432 byte file is
libclangAnalysis.a; all you know is that there are four 310-block files
on this filesystem -- on this system that's the desktop wallpaper, a
file from each of libclang and libgimp, and libc6 from my aarch64 guest.
The logical block map data could be more helpful for fingerprinting, but
only if there are sparse files.

Say our multi-tenant container hosts all the containers on the same fs.
We now have a set of (inode, blockcount) data and a logical block map
for every inode stored on that fs.  We have no path or stat data, so how
do you tell what a 340-block file with a hole at offset 17 is?  You
could try to infer path structure use the (XFS) heuristic that file
inodes are usually created in the same AG as the directory inode they're
created in, but GETFSMAP doesn't distinguish file extents from directory
extents and AGs can host many different directories, so I don't think
this will help much.  Even if you have a reasonably good idea which
inodes are directories, you still don't know which other inodes have an
entry in a particular directory.

Then again once we throw reflink and dedupe between containers into the
mix the extent maps become far more interesting, because dirs could
potentially be identified by the lack of any shared blocks at all, and
other containers with the same library files will tend to share the same
blocks at the same offsets.  But that's still somewhat imprecise --
btrfs directories can share blocks between snapshots, whereas xfs can't,
and the existence of small unshared files with the same block count
introduces a certain amount of noise into the directory inference
process.  So maybe you'd be able to search for a reflinked .so file that
you /can/ stat to infer that there are X containers running the same
software as your container, though you still have to find them to mount
an attack.

FWIW I don't oppose having a CAP_SYS_ADMIN check again (patches gladly
accepted for review!), but I'm not yet convinced that this is a big
enough threat to forbid the use case.

Sure would be nice if we had finer-grained capabilities...

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
