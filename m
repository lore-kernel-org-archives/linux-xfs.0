Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 038FDC32771
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Sep 2022 23:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiIZXzY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Sep 2022 19:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiIZXzW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Sep 2022 19:55:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D464F66110
        for <linux-xfs@vger.kernel.org>; Mon, 26 Sep 2022 16:55:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42338B8076B
        for <linux-xfs@vger.kernel.org>; Mon, 26 Sep 2022 23:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B0EC433D6;
        Mon, 26 Sep 2022 23:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664236518;
        bh=d/CoQQTb7y71FhAxNmtoduBJ4L0yvJmPiGbL72t5zSk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K7GI3doOiJ5W41dyx6nM3TpA1JLf1Tf0KIWArN3mCZDfPW7FvvfmVOOOKPh7N83d/
         SeCiZtUBujD7L39bXPY9hUeTwaIxWUvs7Vm6KlzR2L/YFWYEHYeFlMAnE6Hhn3sD4M
         mbiQxZ9pa94hWu8o+Li7+rHAO1ReRYZcLXFBXyWlVew2gfb9ofOSiXPH/vdadTPeMK
         cVvB/soD+CuuPwONyjOf+BvViWxk6clydnqr3cE5gt9cETrJAA9QrgjnkcRK1dzIkc
         btNO2Np0EKxmW6+RTmsETH5DDoupTTVU0Fdbuq0zrvbrcieVGntJEa07+bBUWjaSCW
         TN9wUUmjMtV3A==
Date:   Mon, 26 Sep 2022 16:55:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 15/26] xfs: add parent attributes to link
Message-ID: <YzI75aUQR3WwvAW2@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-16-allison.henderson@oracle.com>
 <Yy4XhkdToBRBnfbR@magnolia>
 <f811b8d5ea995f7b86886043cc3dd03666d4fa22.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f811b8d5ea995f7b86886043cc3dd03666d4fa22.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 26, 2022 at 09:49:10PM +0000, Allison Henderson wrote:
> On Fri, 2022-09-23 at 13:31 -0700, Darrick J. Wong wrote:
> > On Wed, Sep 21, 2022 at 10:44:47PM -0700,
> > allison.henderson@oracle.com wrote:
> > > From: Allison Henderson <allison.henderson@oracle.com>
> > > 
> > > This patch modifies xfs_link to add a parent pointer to the inode.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > ---
> > >  fs/xfs/xfs_inode.c | 44 +++++++++++++++++++++++++++++++++++-------
> > > --
> > >  1 file changed, 35 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index 181d6417412e..af3f5edb7319 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -1228,14 +1228,16 @@ xfs_create_tmpfile(
> > >  
> > >  int
> > >  xfs_link(
> > > -       xfs_inode_t             *tdp,
> > > -       xfs_inode_t             *sip,
> > > +       struct xfs_inode        *tdp,
> > > +       struct xfs_inode        *sip,
> > >         struct xfs_name         *target_name)
> > >  {
> > > -       xfs_mount_t             *mp = tdp->i_mount;
> > > -       xfs_trans_t             *tp;
> > > +       struct xfs_mount        *mp = tdp->i_mount;
> > > +       struct xfs_trans        *tp;
> > >         int                     error, nospace_error = 0;
> > >         int                     resblks;
> > > +       xfs_dir2_dataptr_t      diroffset;
> > > +       struct xfs_parent_defer *parent = NULL;
> > >  
> > >         trace_xfs_link(tdp, target_name);
> > >  
> > > @@ -1252,11 +1254,17 @@ xfs_link(
> > >         if (error)
> > >                 goto std_return;
> > >  
> > > +       if (xfs_has_parent(mp)) {
> > > +               error = xfs_parent_init(mp, &parent);
> > > +               if (error)
> > > +                       goto std_return;
> > > +       }
> > > +
> > >         resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
> > 
> > Forwarding on from the v2 series --
> > 
> > This patch ought to be modifying XFS_LINK_SPACE_RES so that each
> > link()
> > update reserves enough space to handle an expansion in the tdp
> > directory
> > (as it does now) *and* an expansion in the xattr structure of the sip
> > child file.  This is how we avoid dipping into the free space reserve
> > pool midway through a transaction, and avoid shutdowns when space is
> > tight.
> > 
> > tr_res == space we reserve in the *log* to record updates.
> > 
> > XFS_LINK_SPACE_RES == block we reserve from the filesystem free space
> > to
> > handle expansions of metadata structures.
> > 
> > At this point in this version of the patchset, you've increased the
> > log
> > space reservations in anticipation of logging more information per
> > transaction.  However, you've not increased the free space
> > reservations
> > to handle potential node splitting in the ondisk xattr btree.
> > 
> > (The rest of the patchset looks ok.)
> 
> Ok, looking at the later reviews, I'll add a similar helper function
> here to use in place of XFS_LINK_SPACE_RES:
> 
> unsigned int
> xfs_link_space_res(
>          struct xfs_mount        *mp,
>          unsigned int            namelen)
>  {
>          unsigned int            ret;
>  
>          ret = XFS_DIRENTER_SPACE_RES(mp, namelen);
>          if (xfs_has_parent(mp))
>                  ret += xfs_pptr_calc_space_res(mp, namelen);
>  
>          return ret;
>  }

<nod>

--D

> Thanks!
> Allison
> > 
> > --D
> > 
> > >         error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip,
> > > &resblks,
> > >                         &tp, &nospace_error);
> > >         if (error)
> > > -               goto std_return;
> > > +               goto drop_incompat;
> > >  
> > >         /*
> > >          * If we are using project inheritance, we only allow hard
> > > link
> > > @@ -1289,14 +1297,27 @@ xfs_link(
> > >         }
> > >  
> > >         error = xfs_dir_createname(tp, tdp, target_name, sip-
> > > >i_ino,
> > > -                                  resblks, NULL);
> > > +                                  resblks, &diroffset);
> > >         if (error)
> > > -               goto error_return;
> > > +               goto out_defer_cancel;
> > >         xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD |
> > > XFS_ICHGTIME_CHG);
> > >         xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
> > >  
> > >         xfs_bumplink(tp, sip);
> > >  
> > > +       /*
> > > +        * If we have parent pointers, we now need to add the
> > > parent record to
> > > +        * the attribute fork of the inode. If this is the initial
> > > parent
> > > +        * attribute, we need to create it correctly, otherwise we
> > > can just add
> > > +        * the parent to the inode.
> > > +        */
> > > +       if (parent) {
> > > +               error = xfs_parent_defer_add(tp, parent, tdp,
> > > target_name,
> > > +                                            diroffset, sip);
> > > +               if (error)
> > > +                       goto out_defer_cancel;
> > > +       }
> > > +
> > >         /*
> > >          * If this is a synchronous mount, make sure that the
> > >          * link transaction goes to disk before returning to
> > > @@ -1310,11 +1331,16 @@ xfs_link(
> > >         xfs_iunlock(sip, XFS_ILOCK_EXCL);
> > >         return error;
> > >  
> > > - error_return:
> > > +out_defer_cancel:
> > > +       xfs_defer_cancel(tp);
> > > +error_return:
> > >         xfs_trans_cancel(tp);
> > >         xfs_iunlock(tdp, XFS_ILOCK_EXCL);
> > >         xfs_iunlock(sip, XFS_ILOCK_EXCL);
> > > - std_return:
> > > +drop_incompat:
> > > +       if (parent)
> > > +               xfs_parent_cancel(mp, parent);
> > > +std_return:
> > >         if (error == -ENOSPC && nospace_error)
> > >                 error = nospace_error;
> > >         return error;
> > > -- 
> > > 2.25.1
> > > 
> 
