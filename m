Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:28203 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750750AbdKFBQh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Nov 2017 20:16:37 -0500
Date: Mon, 6 Nov 2017 12:16:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Message-ID: <20171106011634.GC5858@dastard>
References: <20171030133117.GA3535@bfoster.bfoster>
 <20171030210941.GA5858@dastard>
 <20171031112432.GA7093@bfoster.bfoster>
 <20171101004513.GK5858@dastard>
 <20171101141720.GB11709@bfoster.bfoster>
 <20171101235300.GT5858@dastard>
 <20171102112533.GA15748@bfoster.bfoster>
 <20171102233017.GX5858@dastard>
 <20171103112626.GA19974@bfoster.bfoster>
 <CAOQ4uxjEUAR1-1ikZSN2e99gK4k_mEMnhGGYvw=2Zj6oLOPVuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjEUAR1-1ikZSN2e99gK4k_mEMnhGGYvw=2Zj6oLOPVuQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Nov 03, 2017 at 02:19:15PM +0200, Amir Goldstein wrote:
> Whether or not we implement physical shirk is not the main issue.
> The main issue is implicitly changing the meaning of an existing API.

I don't intend on changing the existing API.

I said "there are bugs in the RFC code, and I'm addressing them".

> This is how I propose to smooth in the new API with as little pain as
> possible for existing deployments, yet making sure that "usable block"
> is only modified by new programs that intend to modify it:
> 
> ----------------------
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 8f22fc579dbb..922798ebf3e8 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -171,10 +171,25 @@ xfs_growfs_data_private(
>         xfs_rfsblock_t          nfree;
>         xfs_agnumber_t          oagcount;
>         int                     pct;
> +       unsigned                ver;
>         xfs_trans_t             *tp;
> 
>         nb = in->newblocks;
> -       pct = in->imaxpct;
> +       pct = in->imaxpct & 0xff;
> +       ver = in->imaxpct >> 8;
> +       if (ver > 1)
> +               return -EINVAL;
> +
> +       /*
> +        * V0 API is only allowed to grow sb_usable_dblocks along with
> +        * sb_dblocks.  Any other change to sb_usable_dblocks requires
> +        * V1 API to prove that userspace is aware of usable_dblocks.
> +        */
> +       if (ver == 0 && xfs_sb_version_hasthinspace(mp->m_sb) &&
> +           (mp->m_sb.sb_usable_dblocks != mp->m_sb.sb_dblocks ||
> +            nb < mp->m_sb.sb_dblocks))
> +               return -EINVAL;
> +
>         if (nb < mp->m_sb.sb_dblocks || pct < 0 || pct > 100)
>                 return -EINVAL;
> 
> ----------------
> 
> When xfs_grow WANTS to change size of fs known to be thin, it should set
> in->imaxpct |= 1 << 8;
> 
> Dave,
> 
> Is that the complication of implementation you were talking about?
> Really?

No, it's not. Seems like everyone is still yelling over me instead
of listening.

Let's start with a demonstration. I'm going to make a thin
filesystem on a kernel running my current patchset, then I'm going
to use an old xfs_growfs binary (from 4.12) to try to grow and
shrink that filesystem.

So, create, mount:

$ sudo ~/packages/mkfs.xfs -f -dthin,size=1g /dev/pmem0
Default configuration sourced from package build definitions
meta-data=/dev/pmem0             isize=512    agcount=8, agsize=262144 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0, rmapbt=0, reflink=0
data     =                       bsize=4096   blocks=2097152, imaxpct=25, thinblocks=262144
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ sudo mount /dev/pmem0 /mnt/test
$

Let's now use the old growfs to look at the filesystem:

$ sudo xfs_growfs -V
xfs_growfs version 4.12.0
$ sudo xfs_info /mnt/test
meta-data=/dev/pmem0             isize=512    agcount=8, agsize=262144 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=262144, imaxpct=25, thin=0
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$

It reports as a 1GB filesystem, but has 8 AGs of 1GB each. Clearly
a thinspace filesystem, but grwofs doesn't know that. The kernel
reports it's size as:

$ df -h /mnt/test
Filesystem      Size  Used Avail Use% Mounted on
/dev/pmem0     1006M   33M  974M   4% /mnt/test
$

Now, let's grow it:

$ sudo xfs_growfs -D 500000 /mnt/test
meta-data=/dev/pmem0             isize=512    agcount=8, agsize=262144 blks
[...]
data blocks changed from 262144 to 500000
$

And the kernel reported size:
$ df -h /mnt/test
Filesystem      Size  Used Avail Use% Mounted on
/dev/pmem0      1.9G   33M  1.9G   2% /mnt/test
$

And xfs_info for good measure:

$ sudo xfs_info /mnt/test
meta-data=/dev/pmem0             isize=512    agcount=8, agsize=262144 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=500000, imaxpct=25, thin=0
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$

The thinspace grow succeeded exactly as it should - it grew to
500k blocks without changing the physical filesystem. Thinspace is
completely transparent to the grow operation now, and will work with
old growfs binaries and apps just fine.

So, onto shrink with an old grwofs binary:

$ sudo xfs_growfs -D 400000 /mnt/test
meta-data=/dev/pmem0             isize=512    agcount=8, agsize=262144 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=500000, imaxpct=25, thin=0
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data size 400000 too small, old size is 500000
$

Oh, look, the old grwofs binary refused to shrink the filesystem.
It didn't even call into the filesystem, it just assumes that you
can't shrink XFS filesystems and doesn't even try.

So, this means old userspace and new thinspace filesystems are
pretty safe without having to change the interface. And tells us
that the main change the userspace growfs code needs is to allow
shrink to proceed. Hence, the new XFS_IOC_FSGEOMETRY ioctl and this
change:

-               if (!error && dsize < geo.datablocks) {
+               if (dsize < geo.datablocks && !thin_enabled) {
                        fprintf(stderr, _("data size %lld too small,"
                                " old size is %lld\n"),
                                (long long)dsize, (long long)geo.datablocks);

So, now the growfs binary can only shrink filesystems that report
as thinspace filesystems. It will still refuse to shrink filesystems
that cannot be shrunk. With a new binary:

$ sudo xfs_growfs -V
xfs_growfs version 4.13.1
$ sudo xfs_growfs -D 400000 /mnt/test
meta-data=/dev/pmem0             isize=512    agcount=8, agsize=262144 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=500000, imaxpct=25, thin=1
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 500000 to 400000
$ df -h /mnt/test
Filesystem      Size  Used Avail Use% Mounted on
/dev/pmem0      1.6G   33M  1.5G   3% /mnt/test
$

We can see it shrinks a thinspace filesystem just fine. A normal
thick filesystem:

$ sudo ~/packages/mkfs.xfs /dev/pmem1
Default configuration sourced from package build definitions
meta-data=/dev/pmem1             isize=512    agcount=4, agsize=524288 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0, rmapbt=0, reflink=0
data     =                       bsize=4096   blocks=2097152, imaxpct=25, thinblocks=0
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ sudo mount /dev/pmem1 /mnt/scratch
$ sudo xfs_growfs -D 400000 /mnt/scratch
[....]
data size 400000 too small, old size is 2097152
$

Fails in exactly the same way as they did before.

IOWs, the only thing that growfs requires was awareness that it
could shrink a filesystem (a XFS_IOC_FSGEOMETRY change) and then
without any other changes it can operate sanely on thinspace
filesystems. There is no need to change the actual
XFS_IOC_FSGROWDATA ioctl, because it doesn't care what the
underlying implementation does or supports....

----

That's a demonstration that the growfs interface does not need to
change for userspace to retain sane, predicatable, obvious behaviour
across both old and new growfs binaries with the introduction of
thinspace filesystems. People calling the growfs ioctl directly
without adding thinspace awareness will just see some filesystems
succeed when shrinking - they'll need to add checks for the
thinspace flag in the XFS_IOC_FSGEOMETRY results if they want to do
anything smarter, but otherwise thinspace grow and shrink will just
/work as expected/ with existing binaries.

Amir, my previous comments about unnecessary interface complication
is based on these observations. You seem to be making an underlying
assumption that existing binaries can't grow/shrink thinspace
filesystems without modification. This assumption is incorrect.
Indeed, code complexity isn't the issue here - the issue is the
smearing of implementation details into an abstract control command
that is completely independent of the underlying implementations.

Indeed, userspace does not need to be aware of whether the
filesystem is a thinspace filesystem or not - it just needs to know
the current size so that if it doesn't need to change the size (e.g.
imaxpct change) it puts the right value into the growfs control
structure.

That is the bit I got wrong in the RFC code I posted - the
XFS_IOC_FSGEOMETRY ioctl changes put the wrong size in
geo->datablocks for thinspace filesystems. I've said this multiple
times now, but the message doesn't seem to have sunk in - if we put
the right data in XFS_IOC_FSGEOMETRY, then userspace doesn't need to
care about whether it's a thin or a thick filesystem that it is
operating on.

However, if we start changing the growfs ioctl because it
[apparently] needs to be aware of thin/thick filesystems, we
introduce kernel/userspace compatibility issues that currently don't
exist. And, as I've clearly demonstrated, those interface
differences *do not need to exist* for both old and new growfs
binaries to work correctly with thinspace fielsystems.

That's the "complication of implementation" I was refering to -
introducing interface changes that would result in extra changes to
userspace binaries and as such introduce user visible binary
compatibility issues that users do not need to (and should not) be
exposed to. Not to mention other application developers that might
be using the existing geometry and grwofs ioctls - shrink will now
just work on existing binaries without them having to do
anything....

> Don't you see that this is the right thing to do w.r.t. API design?

No, I don't, because you're trying to solve a problem that, quite
simply, doesn't exist.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
