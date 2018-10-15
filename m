Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:38505 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbeJONsL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Oct 2018 09:48:11 -0400
MIME-Version: 1.0
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938919123.8361.13059492965161549195.stgit@magnolia> <20181014171927.GD30673@infradead.org>
In-Reply-To: <20181014171927.GD30673@infradead.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 15 Oct 2018 09:04:13 +0300
Message-ID: <CAOQ4uxiReFJRxKJbsoUgWWNP75_Qsoh1fWC_dLYV_zBU_jaGbA@mail.gmail.com>
Subject: Re: [PATCH 07/25] vfs: combine the clone and dedupe into a single remap_file_range
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

> > +/*
> > + * These flags control the behavior of the remap_file_range function pointer.
> > + *
> > + * RFR_SAME_DATA: only remap if contents identical (i.e. deduplicate)
> > + */
> > +#define RFR_SAME_DATA                (1 << 0)
> > +
> > +#define RFR_VALID_FLAGS              (RFR_SAME_DATA)
>
> RFR?  Why not REMAP_FILE_*  Also why not the well understood
> REMAP_FILE_DEDUP instead of the odd SAME_DATA?
>
> > +
> > +/*
> > + * Filesystem remapping implementations should call this helper on their
> > + * remap flags to filter out flags that the implementation doesn't support.
> > + *
> > + * Returns true if the flags are ok, false otherwise.
> > + */
> > +static inline bool remap_check_flags(unsigned int remap_flags,
> > +                                  unsigned int supported_flags)
> > +{
> > +     return (remap_flags & ~(supported_flags & RFR_VALID_FLAGS)) == 0;
> > +}
>
> Any reason to even bother with a helper for this?  ->fallocate
> seems to be doing fine without the helper, and the resulting code
> seems a lot easier to understand to me.

I supposed you figured out the reason already.
It makes it appearance in patch 16/25 as RFR_VFS_FLAGS.
All those "advisory" flags, we want to pass them in to filesystem as FYI,
but we don't want to explicitly add support for e.g. RFR_CAN_SHORTEN
to every filesystem, when vfs has already taken care of the advice.

The reason a similar helper doesn't make sense for ->fallocate()
is because vfs does not take any action on behalf of filesystem
nor does vfs pass any internal flags to filesystem.

I argued that fiemap_check_flags() should similarly mask out
FIEMAP_FLAG_SYNC before checking supported fs_flags,
because ioctl_fiemap() respects this flag regardless if filesystem
(or generic helper) declares support for FIEMAP_FLAG_SYNC.

Thanks,
Amir.
