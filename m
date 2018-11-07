Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:36251 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbeKGOik (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 09:38:40 -0500
MIME-Version: 1.0
References: <20181103171524.2740-1-amir73il@gmail.com> <CAOQ4uxjTo_8fpasmVtc2j6zRTnBpUvaNQ0edQwtbv79VgrNqXQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxjTo_8fpasmVtc2j6zRTnBpUvaNQ0edQwtbv79VgrNqXQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 7 Nov 2018 07:09:42 +0200
Message-ID: <CAOQ4uxgVFm7CyhseKtNMOcf8ipTJWD+YJSaG6am1xo0F1hcTDQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: truncate transaction does not modify the inobt
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, Sasha Levin <alexander.levin@microsoft.com>

On Mon, Nov 5, 2018 at 7:57 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sat, Nov 3, 2018 at 7:15 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > From: Brian Foster <bfoster@redhat.com>
> >
> > The truncate transaction does not ever modify the inode btree, but
> > includes an associated log reservation. Update
> > xfs_calc_itruncate_reservation() to remove the reservation
> > associated with inobt updates.
> >
> > [Amir:  This commit was merged for kernel v4.16 and a twin commit was
> >         merged for xfsprogs v4.16. As a result, a small xfs filesystem
> >         formatted with features -m rmapbt=1,reflink=1 using mkfs.xfs
> >         version >= v4.16 cannot be mounted with kernel < v4.16.
> >
> >         For example, xfstests generic/17{1,2,3} format a small fs and
> >         when trying to mount it, they fail with an assert on this very
> >         demonic line:
> >
> >  XFS (vdc): Log size 3075 blocks too small, minimum size is 3717 blocks
> >  XFS (vdc): AAIEEE! Log failed size checks. Abort!
> >  XFS: Assertion failed: 0, file: src/linux/fs/xfs/xfs_log.c, line: 666
> >
> >         The simple solution for stable kernels is to apply this patch,
> >         because mkfs.xfs v4.16 is already in the wild, so we have to
> >         assume that xfs filesystems with a "too small" log exist.
> >         Regardless, xfsprogs maintainers should also consider reverting
> >         the twin patch to stop creating those filesystems for the sake
> >         of users with unpatched kernels.]
> >
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Cc: <stable@vger.kernel.org> # v4.9+
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Darrick/Dave,
> >
> > It took me a while to figure out what was going on with my test systems
> > when small test partitions (10G) stopped working with older kernels.
> >
> > Please bless this change for stable and consider the remedie for mkfs.xfs
> > I verified that patch cleanly applies to stable kernels 4.14.y and 4.9.y
> > and that I can mount a filsystem created with new mkfs.xfs.
> >
> > I am now running quick tests on stable 4.14.y with configs 4k, 1k,
> > reflink,reflink+overlay to verify no regressions from this patch.
> >
>
> FYI no regressions detected.
>
> Thoughts?
>

Maybe you'd want to chalk it up to reflink/rmapbt being Experimental
before kernel 4.16? so the change in "minimum log size" is an on-disk format
change prior to removing the Experimental label??

Thanks,
Amir.
