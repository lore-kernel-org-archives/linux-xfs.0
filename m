Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F148C04A95
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 21:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbiIWVS3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiIWVS2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 17:18:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F92122062
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 14:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31B7E60CE8
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 21:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75003C433D6;
        Fri, 23 Sep 2022 21:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663967906;
        bh=xDDOl5zlHvvymRj03ZkcYEom0ApYDHGX4rXFCK2uqR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a7N+hLyy2fR/2Cmp06EzPKQGpi9B0v3lo8ab58/hEe+/y2L5JHCMESLDNfL9qm98W
         xtZUPkpllBJd63QqRUZ52ryfIRRlx4M+3nZwx+mzRaEESd9MATGusSRFMUYZnp/6DP
         0E0bh2AlA1i+QVDlqva8oex3/n7vCMMh8sYG54HXmOng1EXrYmb0/ADjS4x4Aih9uK
         L0vO5INn0HNSOLjQunBeFsMQsuile1GwrRlWfQdjHhtGLqKCgO33z/LaVGMn3dL91E
         R7xmc7q1oojEPsphnkl+I3Rt5t9yK/dSJoctlmjY2UMumFmZvRF2B64U6Mg4bEcWjs
         n0q6Obp8mpjCw==
Date:   Fri, 23 Sep 2022 14:18:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 06/26] xfs: Expose init_xattrs in xfs_create_tmpfile
Message-ID: <Yy4ioSD9SiMktxqe@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-7-allison.henderson@oracle.com>
 <Yy4IFZXqpgJbupD2@magnolia>
 <4859b4a707017188da640bc34abea1eac8793f19.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4859b4a707017188da640bc34abea1eac8793f19.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 23, 2022 at 08:45:22PM +0000, Allison Henderson wrote:
> On Fri, 2022-09-23 at 12:25 -0700, Darrick J. Wong wrote:
> > On Wed, Sep 21, 2022 at 10:44:38PM -0700,
> > allison.henderson@oracle.com wrote:
> > > From: Allison Henderson <allison.henderson@oracle.com>
> > > 
> > > Tmp files are used as part of rename operations and will need attr
> > > forks
> > > initialized for parent pointers.  Expose the init_xattrs parameter
> > > to
> > > the calling function to initialize the fork.
> > > 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > ---
> > >  fs/xfs/xfs_inode.c | 8 +++++---
> > >  fs/xfs/xfs_inode.h | 2 +-
> > >  fs/xfs/xfs_iops.c  | 3 ++-
> > >  3 files changed, 8 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index 4bfa4a1579f0..ff680de560d2 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -1108,6 +1108,7 @@ xfs_create_tmpfile(
> > >         struct user_namespace   *mnt_userns,
> > >         struct xfs_inode        *dp,
> > >         umode_t                 mode,
> > > +       bool                    init_xattrs,
> > >         struct xfs_inode        **ipp)
> > >  {
> > >         struct xfs_mount        *mp = dp->i_mount;
> > > @@ -1148,7 +1149,7 @@ xfs_create_tmpfile(
> > >         error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
> > >         if (!error)
> > >                 error = xfs_init_new_inode(mnt_userns, tp, dp, ino,
> > > mode,
> > > -                               0, 0, prid, false, &ip);
> > > +                               0, 0, prid, init_xattrs, &ip);
> > >         if (error)
> > >                 goto out_trans_cancel;
> > >  
> > > @@ -2726,6 +2727,7 @@ xfs_rename_alloc_whiteout(
> > >         struct user_namespace   *mnt_userns,
> > >         struct xfs_name         *src_name,
> > >         struct xfs_inode        *dp,
> > > +       bool                    init_xattrs,
> > >         struct xfs_inode        **wip)
> > >  {
> > >         struct xfs_inode        *tmpfile;
> > > @@ -2733,7 +2735,7 @@ xfs_rename_alloc_whiteout(
> > >         int                     error;
> > >  
> > >         error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR |
> > > WHITEOUT_MODE,
> > > -                                  &tmpfile);
> > > +                                  init_xattrs, &tmpfile);
> > 
> > Whiteouts are created prior to being added to a directory, right?
> > If so, shouldn't this be s/init_xattrs/true/g to save time?
> well, replaced with xfs_has_parent(mp) if we want to retain the non
> parent code functionality.  I dont know that it really saves that much
> time, but we can implement it that way of folks prefer.

I didn't used to think it would make much difference, but the reason why
the init_xattrs thing got added is that Dave benchmarked file creation
on a system that has selinux enabled (and hence sets selinux security
xattrs on every file created) and discovered that it /did/ make a
difference.

--D

> > 
> > Everything else in here looks good though!
> Thanks!
> Allison
> 
> > 
> > --D
> > 
> > >         if (error)
> > >                 return error;
> > >  
> > > @@ -2797,7 +2799,7 @@ xfs_rename(
> > >          */
> > >         if (flags & RENAME_WHITEOUT) {
> > >                 error = xfs_rename_alloc_whiteout(mnt_userns,
> > > src_name,
> > > -                                                 target_dp, &wip);
> > > +                                                 target_dp, false,
> > > &wip);
> > >                 if (error)
> > >                         return error;
> > >  
> > > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > > index 2eaed98af814..5735de32beeb 100644
> > > --- a/fs/xfs/xfs_inode.h
> > > +++ b/fs/xfs/xfs_inode.h
> > > @@ -478,7 +478,7 @@ int         xfs_create(struct user_namespace
> > > *mnt_userns,
> > >                            umode_t mode, dev_t rdev, bool
> > > need_xattr,
> > >                            struct xfs_inode **ipp);
> > >  int            xfs_create_tmpfile(struct user_namespace
> > > *mnt_userns,
> > > -                          struct xfs_inode *dp, umode_t mode,
> > > +                          struct xfs_inode *dp, umode_t mode, bool
> > > init_xattrs,
> > >                            struct xfs_inode **ipp);
> > >  int            xfs_remove(struct xfs_inode *dp, struct xfs_name
> > > *name,
> > >                            struct xfs_inode *ip);
> > > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > > index 5d670c85dcc2..07a26f4f6348 100644
> > > --- a/fs/xfs/xfs_iops.c
> > > +++ b/fs/xfs/xfs_iops.c
> > > @@ -200,7 +200,8 @@ xfs_generic_create(
> > >                                 xfs_create_need_xattr(dir,
> > > default_acl, acl),
> > >                                 &ip);
> > >         } else {
> > > -               error = xfs_create_tmpfile(mnt_userns, XFS_I(dir),
> > > mode, &ip);
> > > +               error = xfs_create_tmpfile(mnt_userns, XFS_I(dir),
> > > mode, false,
> > > +                                          &ip);
> > >         }
> > >         if (unlikely(error))
> > >                 goto out_free_acl;
> > > -- 
> > > 2.25.1
> > > 
> 
