Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:48843 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730106AbeLJVlX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Dec 2018 16:41:23 -0500
Date: Tue, 11 Dec 2018 08:41:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Message-ID: <20181210214115.GC6311@dastard>
References: <20181210042842.GA16286@draconx.ca>
 <20181210143345.GB8356@bfoster>
 <CADyTPEw_RZCC2yodbJ6W0e9mwJgQW19UXCHhcw1-tF4b0=hMjg@mail.gmail.com>
 <20181210161121.GC8356@bfoster>
 <20181210165020.GT24487@magnolia>
 <20181210174627.GD8356@bfoster>
 <CADyTPEzcjKO163RehVHtOo0=71=u515oHaeAnzmkfHtatpjhLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADyTPEzcjKO163RehVHtOo0=71=u515oHaeAnzmkfHtatpjhLg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nick Bowler <nbowler@draconx.ca>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Mon, Dec 10, 2018 at 03:54:47PM -0500, Nick Bowler wrote:
> On 2018-12-10, Brian Foster <bfoster@redhat.com> wrote:
> > On Mon, Dec 10, 2018 at 08:50:20AM -0800, Darrick J. Wong wrote:
> >> On Mon, Dec 10, 2018 at 11:11:22AM -0500, Brian Foster wrote:
> >> > 0x6e corresponds to the GROWFSDATA[_32] cmd and I think 0x10 is the
> >> > size, which is 16 bytes as opposed to the 12 bytes expected for
> >> > GROWFSDATA_32 for struct compat_xfs_growfs_data:
> >> >
> >> > typedef struct compat_xfs_growfs_data {
> >> >         __u64           newblocks;      /* new data subvol size,
> >> > fsblocks */
> >> >         __u32           imaxpct;        /* new inode space percentage
> >> > limit */
> >> > } __attribute__((packed)) compat_xfs_growfs_data_t;
> >> >
> >> > On a 64-bit kernel, that packed attribute is the difference between
> >> > expecting a padded 16 byte struct vs. a 12 byte version presumably from
> >> > a 32-bit application. So if you are calling into the ->compat_ioctl()
> >> > path I think the question is why is your xfsprogs sending the 16 byte
> >> > structure?
> >>
> >> ...because the x32 ABI is weird in that pointers are 4 bytes like on
> >> x86, but the registers are 64 bits wide like on x64, and (except for
> >> pointers being 4 bytes wide) the structure alignment rules follow x64.
> [...]
> > Yeah, it seems to me that fundamentally conflicts with the whole
> > BROKEN_X86_ALIGNMENT thing we have now. IIUC, compat_ioctl() on an
> > x86_64 kernel needs to account for x86 userspace via all of the
> > associated _32 ioctl commands as it already does, but at the same time
> > x32 means we could get any of the traditional x86_64 commands through
> > that path as well.
> 
> In the specific case of this one ioctl on this one architecture since the
> only problem is unused padding at the end of the structure, the fix might
> be simple: just accept both ioctl numbers in the compat path.  The packed
> compat struct layout looks like it should match what x32 userspace sends
> just fine.  (I didn't realize x32 syscalls would go through compat_ioctl).
> 
> i.e., perhaps we just do something like this? (TOTALLY UNTESTED)
> 
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index fba115f4103a..b5a02f36d568 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -581,6 +581,9 @@ xfs_file_compat_ioctl(
>         }
>         case XFS_IOC_FSGEOMETRY_V1_32:
>                 return xfs_compat_ioc_fsgeometry_v1(mp, arg);
> +#ifdef CONFIG_X86_X32
> +       case XFS_IOC_FSGROWFSDATA:
> +#endif
>         case XFS_IOC_FSGROWFSDATA_32: {
>                 struct xfs_growfs_data  in;

Ugly, but something like that may be our only option here.

> 
> I can have a go at fixing the FSGEOMETRY ioctl too (and submit it
> properly) if this approach seems reasonable.  Possibly other things
> may be broken too but I haven't hit any other issues yet in my XFS
> adventure.

We really need to audit all the compat ioctls for this same
problem and fix all of them in one go, not just slap a bandaid on
the messenger and ignore the rest....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
