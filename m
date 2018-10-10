Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:41719 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbeJKAzR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 20:55:17 -0400
MIME-Version: 1.0
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913043746.32295.17463515265798256890.stgit@magnolia> <CAOQ4uxivwLR5assf0VwHdp5p06Er4w7urB637Z3wiQ1eZoT9tQ@mail.gmail.com>
 <20181010162948.GT28243@magnolia>
In-Reply-To: <20181010162948.GT28243@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 10 Oct 2018 20:31:55 +0300
Message-ID: <CAOQ4uxhZaWMhEF2UXybHba-XDkUY6pGxhcqhJ1x7jNN2pnKGVw@mail.gmail.com>
Subject: Re: [PATCH 17/25] vfs: make remapping to source file eof more explicit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Wed, Oct 10, 2018 at 7:29 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Wed, Oct 10, 2018 at 03:29:06PM +0300, Amir Goldstein wrote:
> > On Wed, Oct 10, 2018 at 3:14 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> > > Create a RFR_TO_SRC_EOF flag to explicitly declare that the caller wants
> > > the remap implementation to remap to the end of the source file, once
> > > the files are locked.
> > >
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
[...]

> > > + * RFR_TO_SRC_EOF: remap to the end of the source file
> > >   */
> > >  #define RFR_IDENTICAL_DATA     (1 << 0)
> > > +#define RFR_TO_SRC_EOF         (1 << 1)
> > >
> >
> > So what is the best way to make sure that all filesystems can
> > properly handle this flag? and the RFR_CAN_SHORTEN flag?
> >
> > The way that your patches took is to not check for invalid flags
> > at all in filesystems, but I don't think that is a viable option.
>
> The RFR flags are internal APIs, so we don't need to be quite as strict
> as fiemap does...
>

That's true.

> > Another way would be to individually add those flags to invalid
> > flags check in all relevant filesystems.
> >
> > Another way would be to follow a pattern similar to
> > fiemap_check_flags(), except in case filesystem does not declare
> > to support the RFR_ "advisory" flags, it will not fail the operation
> >
> > Comparing to FIEMAP_ flags, no filesystem would have needed to declare
> > support for FIEMAP_FLAG_SYNC, because vfs dealt with it anyway
> > before calling into the filesystem. So de-facto, any filesystem supports
> > FIEMAP_FLAG_SYNC without doing anything, but it is still worth passing
> > the flag into filesystem in case it matter (it does for overlayfs).
>
> ...but I think you have a good point that we could help filesystem
> writers distinguish between advisory flags that are taken care of by the
> VFS but passed to the fs for full disclosure; and mandatory flags that
> the fs for which the fs must advertise support.
>
> IOWs,
>
> int remap_check_flags(unsigned int remap_flags, unsigned int supported_flags)
> {
>         /* VFS already took care of these */
>         remap_flags &= ~(RFR_TO_EOF | RFR_CAN_SHORTEN);
>
>         if (remap_flags & ~supported_flags) {
>                 WARN_ONCE(1, "Internal API misuse at %pS", __return_address);
>                 return -EINVAL;
>         }
>
>         return 0;
> }
>

With that in place, you can add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

on the vfs patches.

Thanks,
Amir.
