Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:53916 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbeGNKgB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Jul 2018 06:36:01 -0400
Received: by mail-wm0-f67.google.com with SMTP id s9-v6so3535805wmh.3
        for <linux-xfs@vger.kernel.org>; Sat, 14 Jul 2018 03:17:25 -0700 (PDT)
Date: Sat, 14 Jul 2018 12:17:22 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] libxfs: Fix a couple of sparse complaints
Message-ID: <20180714101722.3u2sjlhybfe5b7gl@odin.usersys.redhat.com>
References: <20180713091831.30250-1-cmaiolino@redhat.com>
 <CAOQ4uxjUGAGhPAL6EOZ_SmpfKyTL8Sty2Yd7NdAEBM-PQPP1tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjUGAGhPAL6EOZ_SmpfKyTL8Sty2Yd7NdAEBM-PQPP1tQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Jul 13, 2018 at 01:02:24PM +0300, Amir Goldstein wrote:
> On Fri, Jul 13, 2018 at 12:18 PM, Carlos Maiolino <cmaiolino@redhat.com> wrote:
> > No significant changes, just silence a couple of sparse errors.
> >
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag_resv.h | 2 +-
> >  fs/xfs/libxfs/xfs_ialloc.c  | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
> > index 4619b554ee90..dc953fc84b2f 100644
> > --- a/fs/xfs/libxfs/xfs_ag_resv.h
> > +++ b/fs/xfs/libxfs/xfs_ag_resv.h
> > @@ -28,7 +28,7 @@ xfs_ag_resv_rmapbt_alloc(
> >         struct xfs_mount        *mp,
> >         xfs_agnumber_t          agno)
> >  {
> > -       struct xfs_alloc_arg    args = {0};
> > +       struct xfs_alloc_arg    args = { NULL };
> 
> Could you use args = {} instead.
> 
> There was a bunch of conversions for such initializes with:
> https://lwn.net/Articles/723997/
>

I honestly don't see a reason to use these annotations here.

> But regardless, NULL adds no information for compiler.

args = { NULL }; just looks more clear to me than

args = {};

and anyway, the idea here was just to shut up sparse complains, not to do
anything better than args = {0} or pass any extra information to the compiler.



> 
> Thanks,
> Amir.

-- 
Carlos
