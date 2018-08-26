Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:35452 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbeHZPNF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Aug 2018 11:13:05 -0400
MIME-Version: 1.0
References: <1535101371-26461-1-git-send-email-amir73il@gmail.com>
 <20180824233901.GA2234@dastard> <CAOQ4uxj=3N28eSX1papQU4n3bt-J7S=_NhtTFq0xV1k0WgH-Ug@mail.gmail.com>
 <CAJfpegtCj=bgVQ5SOD-WfSfU9=auderyYnYboUJtnCr8OcPdMA@mail.gmail.com>
In-Reply-To: <CAJfpegtCj=bgVQ5SOD-WfSfU9=auderyYnYboUJtnCr8OcPdMA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 26 Aug 2018 14:32:33 +0300
Message-ID: <CAOQ4uxiHFmiq98OUJqzALm8hHC9azkXVE_bDdKXZLcq+kaCC3Q@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix GPF in swapfile_activate of file from overlayfs
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>

On Sat, Aug 25, 2018 at 11:04 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Sat, Aug 25, 2018 at 12:47 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > Actually, I believe the intention was that fs developers don't need to worry
> > about using file_inode() at all, because before the change we had:
> >
> > - file passed in to xfs f_op's and a_ops is either overlay file OR xfs file
> > - file_inode() of either overlay/xfs file in xfs context is always xfs inode
> > - file->f_path in xfs context, BTW, was overlay path and therefore,
> >   XFS_IOC_OPEN_BY_HANDLE was slightly broken in overlayfs over xfs,
> >   as were several other fs specific ioctls
> >
> > After stacked file operations change we should have the rules:
> >
> > 1. file passed in to xfs f_op's is always xfs file (*)
> > 2. file passed in to xfs a_ops is always xfs file (**)
> > 3. file_inode() of overlay file is an overlay inode
> >
> > (*) as explicit file argument or on iocb->ki_filp
> > (**) as explicit file argument or on ->vm_file
> >
> > I believe that swapfile leaking an overlay file into xfs was an oversight,
> > that is breaking rule #2.
>
> Correct.
>
> I believe the root cause is this
>
>     /* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
>     file->f_mapping = realfile->f_mapping;
>
> in ovl_open().  So lets start with removing that.  That should fix any
> oopses related to this, but we'll have some other issues:
>
>  1) open(..., O_DIRECT) will return an error
>
> This is easy to fix:  add ovl_file_aops with a dummy ovl_direct_IO()
> function that will never be called.
>

Nice. I pushed a patch to ovl-fixes branch [1].

>  2) swapon() will return an error
>
> First question that comes to mind:  does anybody care?  I wouldn't
> think swapfiles would be an important feature for overlayfs, but we
> did support them up till now, so removing support might cause a
> regression somewhere out there.   Unfortunate...
>

I think we better introduce this "regression" and see if there are any real
world users out there. If there are, I have a WIP patch to make it work,
but it involves cloning an accountable file from real file - not a pretty sight.

3) readahead() will return an error and fadvise() will ignore request

I have patches [1] to fix those by familiarizing vfs with file_real().

4) I am afraid we may end up with more vfs hacks -
    right off the top of my grep f_mapping fs/*.c:
- FIBMAP
- sync_file_range()

But wasn't able to demonstrate a problem with those yet.
I am running [1] through xfstests now and if it looks fine, I'll post
the patches.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-fixes
