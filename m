Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:52218 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbeGNK1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Jul 2018 06:27:49 -0400
Received: by mail-wm0-f65.google.com with SMTP id s12-v6so10885698wmc.1
        for <linux-xfs@vger.kernel.org>; Sat, 14 Jul 2018 03:09:14 -0700 (PDT)
Date: Sat, 14 Jul 2018 12:09:10 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] libxfs: Fix a couple of sparse complaints
Message-ID: <20180714100910.3t7vs5tqemhnjbqg@odin.usersys.redhat.com>
References: <20180713091831.30250-1-cmaiolino@redhat.com>
 <20180713165450.GN32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180713165450.GN32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 13, 2018 at 09:54:50AM -0700, Darrick J. Wong wrote:
> On Fri, Jul 13, 2018 at 11:18:31AM +0200, Carlos Maiolino wrote:
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
> >  	struct xfs_mount	*mp,
> >  	xfs_agnumber_t		agno)
> >  {
> > -	struct xfs_alloc_arg	args = {0};
> > +	struct xfs_alloc_arg	args = { NULL };
> >  	struct xfs_perag	*pag;
> >  
> >  	args.len = 1;
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index 0d968e8143aa..0680fea1d47d 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -2539,7 +2539,7 @@ xfs_agi_verify(
> >  		return __this_address;
> >  
> >  	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
> > -		if (agi->agi_unlinked[i] == NULLAGINO)
> > +		if (be32_to_cpu(agi->agi_unlinked[i]) == NULLAGINO)
> 
> iirc there's enough macro magic in the kernel that
> be32_to_cpu(NULLAGINO) will get encoded as a constant so we don't have
> to byteswap every bucket in the agi_unlinked array.

Yup, you are right, just looked deeper into the be32_to_cpu() and their
relatives, and yeah, constant values can be swapped at compile time, thanks,
I'll redo it, and send a V2

> 
> --D
> 
> >  			continue;
> >  		if (!xfs_verify_ino(mp, be32_to_cpu(agi->agi_unlinked[i])))
> >  			return __this_address;
> > -- 
> > 2.14.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
