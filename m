Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE43C32771
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Sep 2022 23:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiIZXx0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Sep 2022 19:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiIZXxZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Sep 2022 19:53:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC3F94120
        for <linux-xfs@vger.kernel.org>; Mon, 26 Sep 2022 16:53:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AB1EB81126
        for <linux-xfs@vger.kernel.org>; Mon, 26 Sep 2022 23:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F74C433D7;
        Mon, 26 Sep 2022 23:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664236400;
        bh=4e7roJOVDVqAb9Bl/On+6mPNmnDXNwvFU6RUtLnKDYA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TelJSIVNVsKkitdyczolHzDySYnWjiPtaM9UXiuDy9W5q8OtS1csb0ulc7SKkn4pj
         MdKydQvv7cpa06aw9NcgXIfywm22pkBR6xPDkMTJJnCF1UW13rePW5ZIVLu8vnX8mj
         Sfr+XPT3zrN9XK1NTTtcxO8oK3dr7Wu8/LweKVqTEnKpfQj16Jp3lpMyIXMvVky3TE
         /bdfezVjxl+ecF6svJW4h2FoH1QRXoSldV1rszVlqDDUr+LwDRAyzAWyaA581SUW62
         NljCHPSPE4brwrATw7AGLP7PjXX6RsFtznPV9u+aulKxL60mzOhQ507B8j8e1Ym1Nv
         zpkQvIa6dNhHw==
Date:   Mon, 26 Sep 2022 16:53:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 13/26] xfs: extend transaction reservations for parent
 attributes
Message-ID: <YzI7cNJC7QE5OBNd@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-14-allison.henderson@oracle.com>
 <Yy4Uc62AbxUAWDXg@magnolia>
 <56e66827346fcc5ba40805a34abffc95f16c740b.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56e66827346fcc5ba40805a34abffc95f16c740b.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 23, 2022 at 11:53:22PM +0000, Allison Henderson wrote:
> On Fri, 2022-09-23 at 13:17 -0700, Darrick J. Wong wrote:
> > On Wed, Sep 21, 2022 at 10:44:45PM -0700,
> > allison.henderson@oracle.com wrote:
> > > From: Allison Henderson <allison.henderson@oracle.com>
> > > 
> > > We need to add, remove or modify parent pointer attributes during
> > > create/link/unlink/rename operations atomically with the dirents in
> > > the
> > > parent directories being modified. This means they need to be
> > > modified
> > > in the same transaction as the parent directories, and so we need
> > > to add
> > > the required space for the attribute modifications to the
> > > transaction
> > > reservations.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_trans_resv.c | 135 ++++++++++++++++++++++++++---
> > > ----
> > >  1 file changed, 106 insertions(+), 29 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c
> > > b/fs/xfs/libxfs/xfs_trans_resv.c
> > > index 2c4ad6e4bb14..f7799800d556 100644
> > > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > > @@ -19,6 +19,7 @@
> > >  #include "xfs_trans.h"
> > >  #include "xfs_qm.h"
> > >  #include "xfs_trans_space.h"
> > > +#include "xfs_attr_item.h"
> > >  
> > >  #define _ALLOC true
> > >  #define _FREE  false
> > > @@ -421,28 +422,45 @@ xfs_calc_itruncate_reservation_minlogsize(
> > >  }
> > >  
> > >  /*
> > > - * In renaming a files we can modify:
> > > - *    the four inodes involved: 4 * inode size
> > > + * In renaming a files we can modify (t1):
> > > + *    the four inodes involved: 5 * inode size
> > 
> > ...the *five* inodes involved...
> > 
> > Also -- even before parent pointers we could have five inodes
> > involved
> > in a rename transaction, so I think this change needs to be a
> > separate
> > bugfix at the start of the series.  Rename isn't experimental, so I
> > can't let this one slide. :/
> I see, ok I will split this one out then
> 
> > 
> > >   *    the two directory btrees: 2 * (max depth + v2) * dir block
> > > size
> > >   *    the two directory bmap btrees: 2 * max depth * block size
> > >   * And the bmap_finish transaction can free dir and bmap blocks
> > > (two sets
> > > - *     of bmap blocks) giving:
> > > + *     of bmap blocks) giving (t2):
> > >   *    the agf for the ags in which the blocks live: 3 * sector
> > > size
> > >   *    the agfl for the ags in which the blocks live: 3 * sector
> > > size
> > >   *    the superblock for the free block count: sector size
> > >   *    the allocation btrees: 3 exts * 2 trees * (2 * max depth -
> > > 1) * block size
> > > + * If parent pointers are enabled (t3), then each transaction in
> > > the chain
> > > + *    must be capable of setting or removing the extended
> > > attribute
> > > + *    containing the parent information.  It must also be able to
> > > handle
> > > + *    the three xattr intent items that track the progress of the
> > > parent
> > > + *    pointer update.
> > >   */
> > >  STATIC uint
> > >  xfs_calc_rename_reservation(
> > >         struct xfs_mount        *mp)
> > >  {
> > > -       return XFS_DQUOT_LOGRES(mp) +
> > > -               max((xfs_calc_inode_res(mp, 4) +
> > > -                    xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
> > > -                                     XFS_FSB_TO_B(mp, 1))),
> > > -                   (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
> > > -                    xfs_calc_buf_res(xfs_allocfree_block_count(mp,
> > > 3),
> > > -                                     XFS_FSB_TO_B(mp, 1))));
> > > +       unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
> > > +       struct xfs_trans_resv   *resp = M_RES(mp);
> > > +       unsigned int            t1, t2, t3 = 0;
> > > +
> > > +       t1 = xfs_calc_inode_res(mp, 5) +
> > > +            xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
> > > +                       XFS_FSB_TO_B(mp, 1));
> > > +
> > > +       t2 = xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
> > > +            xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
> > > +                       XFS_FSB_TO_B(mp, 1));
> > > +
> > > +       if (xfs_has_parent(mp)) {
> > > +               t3 = max(resp->tr_attrsetm.tr_logres,
> > > +                               resp->tr_attrrm.tr_logres);
> > 
> > Ooh I like this refactoring of xfs_calc_rename_reservation. :)
> > 
> > I guess we now tr_attr{setm,rm} before computing the rename
> > reservation
> > so this is ok.
> > 
> > > +               overhead += 3 * (sizeof(struct
> > > xfs_attri_log_item));
> > 
> > Should the size of the name, newname, and value buffers be added into
> > overhead?  They take up log space too.
> That would make sense, but we cant really calculate that ahead of time
> with out just assuming the max size which is up to 64k for the value. 
> Maybe those sizes should be added on after we know what they are?

They have to be worst case values, but fortunately we know what the
worst case is:

name: sizeof(ondisk parent ptr structure) + iovec overhead
newname: same for rename, and zero everywhere else iiuc?
value: 255 + iovec_overhead

> > 
> > > +       }
> > > +
> > > +       return overhead + max3(t1, t2, t3);
> > >  }
> > >  
> > >  /*
> > > @@ -909,24 +927,59 @@ xfs_calc_sb_reservation(
> > >         return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
> > >  }
> > >  
> > > -void
> > > -xfs_trans_resv_calc(
> > > -       struct xfs_mount        *mp,
> > > -       struct xfs_trans_resv   *resp)
> > > +/*
> > > + * Calculate extra space needed for parent pointer attributes
> > > + */
> > > +STATIC void
> > > +xfs_calc_parent_ptr_reservations(
> > > +       struct xfs_mount     *mp)
> > >  {
> > > -       int                     logcount_adj = 0;
> > > +       struct xfs_trans_resv   *resp = M_RES(mp);
> > >  
> > > -       /*
> > > -        * The following transactions are logged in physical format
> > > and
> > > -        * require a permanent reservation on space.
> > > -        */
> > > -       resp->tr_write.tr_logres = xfs_calc_write_reservation(mp,
> > > false);
> > > -       resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> > > -       resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > > +       if (!xfs_has_parent(mp))
> > > +               return;
> > >  
> > > -       resp->tr_itruncate.tr_logres =
> > > xfs_calc_itruncate_reservation(mp, false);
> > > -       resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> > > -       resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > > +       resp->tr_rename.tr_logres += max(resp-
> > > >tr_attrsetm.tr_logres,
> > > +                                        resp-
> > > >tr_attrrm.tr_logres);
> > > +       resp->tr_rename.tr_logcount += max(resp-
> > > >tr_attrsetm.tr_logcount,
> > > +                                          resp-
> > > >tr_attrrm.tr_logcount);
> > 
> > Doesn't xfs_calc_rename_reservation add this to tr_rename already?
> Oh, I think we can remove the tr_rename.tr_logres update.  But not the
> logcount update right?

Right, though you could update XFS_RENAME_LOG_COUNT (or turn it into a
helper function).

> xfs_calc_rename_reservation just calculates what tr_rename.tr_logres
> should be, but it doesnt make any additions.  It's that's used over in
> xfs_calc_namespace_reservations, but we still need to update
> tr_rename.tr_logcount which is separate field from tr_rename.tr_logres.
> 
> 
> > 
> > > +
> > > +       resp->tr_create.tr_logres += resp->tr_attrsetm.tr_logres;
> > > +       resp->tr_create.tr_logcount += resp-
> > > >tr_attrsetm.tr_logcount;
> > > +
> > > +       resp->tr_mkdir.tr_logres += resp->tr_attrsetm.tr_logres;
> > > +       resp->tr_mkdir.tr_logcount += resp-
> > > >tr_attrsetm.tr_logcount;
> > > +
> > > +       resp->tr_link.tr_logres += resp->tr_attrsetm.tr_logres;
> > > +       resp->tr_link.tr_logcount += resp->tr_attrsetm.tr_logcount;
> > > +
> > > +       resp->tr_symlink.tr_logres += resp->tr_attrsetm.tr_logres;
> > > +       resp->tr_symlink.tr_logcount += resp-
> > > >tr_attrsetm.tr_logcount;
> > > +
> > > +       resp->tr_remove.tr_logres += resp->tr_attrrm.tr_logres;
> > > +       resp->tr_remove.tr_logcount += resp->tr_attrrm.tr_logcount;
> > 
> > Shouldn't each of these += additions be made to
> > xfs_calc_{icreate,mkdir,link,symlink,remove}_reservation,
> > respectively?
> > 
> 
> I suppose we could redo it that way?  But then not all of the "+="
> would disappear if they worked like xfs_calc_rename_reservation.  Just
> the *.tr_logres.  Do we really want separate wrappers for just these
> oneliners though?

Yes, once those macros start acquiring logic, they ought to turn into
static inline helpers.

--D

> Allison
> 
> > --D
> > 
> > > +}
> > > +
> > > +/*
> > > + * Namespace reservations.
> > > + *
> > > + * These get tricky when parent pointers are enabled as we have
> > > attribute
> > > + * modifications occurring from within these transactions. Rather
> > > than confuse
> > > + * each of these reservation calculations with the conditional
> > > attribute
> > > + * reservations, add them here in a clear and concise manner. This
> > > assumes that
> > > + * the attribute reservations have already been calculated.
> > > + *
> > > + * Note that we only include the static attribute reservation
> > > here; the runtime
> > > + * reservation will have to be modified by the size of the
> > > attributes being
> > > + * added/removed/modified. See the comments on the attribute
> > > reservation
> > > + * calculations for more details.
> > > + */
> > > +STATIC void
> > > +xfs_calc_namespace_reservations(
> > > +       struct xfs_mount        *mp,
> > > +       struct xfs_trans_resv   *resp)
> > > +{
> > > +       ASSERT(resp->tr_attrsetm.tr_logres > 0);
> > >  
> > >         resp->tr_rename.tr_logres =
> > > xfs_calc_rename_reservation(mp);
> > >         resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
> > > @@ -948,15 +1001,37 @@ xfs_trans_resv_calc(
> > >         resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
> > >         resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > >  
> > > +       resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
> > > +       resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
> > > +       resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > > +
> > > +       xfs_calc_parent_ptr_reservations(mp);
> > > +}
> > > +
> > > +void
> > > +xfs_trans_resv_calc(
> > > +       struct xfs_mount        *mp,
> > > +       struct xfs_trans_resv   *resp)
> > > +{
> > > +       int                     logcount_adj = 0;
> > > +
> > > +       /*
> > > +        * The following transactions are logged in physical format
> > > and
> > > +        * require a permanent reservation on space.
> > > +        */
> > > +       resp->tr_write.tr_logres = xfs_calc_write_reservation(mp,
> > > false);
> > > +       resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> > > +       resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > > +
> > > +       resp->tr_itruncate.tr_logres =
> > > xfs_calc_itruncate_reservation(mp, false);
> > > +       resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> > > +       resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > > +
> > >         resp->tr_create_tmpfile.tr_logres =
> > >                         xfs_calc_create_tmpfile_reservation(mp);
> > >         resp->tr_create_tmpfile.tr_logcount =
> > > XFS_CREATE_TMPFILE_LOG_COUNT;
> > >         resp->tr_create_tmpfile.tr_logflags |=
> > > XFS_TRANS_PERM_LOG_RES;
> > >  
> > > -       resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
> > > -       resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
> > > -       resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > > -
> > >         resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
> > >         resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
> > >         resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > > @@ -986,6 +1061,8 @@ xfs_trans_resv_calc(
> > >         resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
> > >         resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > >  
> > > +       xfs_calc_namespace_reservations(mp, resp);
> > > +
> > >         /*
> > >          * The following transactions are logged in logical format
> > > with
> > >          * a default log count.
> > > -- 
> > > 2.25.1
> > > 
> 
