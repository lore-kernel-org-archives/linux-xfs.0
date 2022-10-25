Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F07C38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 21:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbiJYVRe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 17:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiJYVRd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 17:17:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6693F10A7FD
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4F0E61B7A
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 21:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33200C433C1;
        Tue, 25 Oct 2022 21:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666732651;
        bh=AFIs7L1y+F+2DYVX2rjdkswGco3NZRGwbk93W/fCNT0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=te4AVtsBdDEBPAHdyGjXUwDwnE8BJUJoU4YDHOcRTiypQf0gd/jRhjoC36J30eUfS
         kSKcCnhoYiPYtqIjE16PN+jhB1/b+rcCYWGKGf/av5/xwi0CHFcF1Vr4NITbbSBU9b
         hOZ3mfBcOLykkUJOQlN0eXpU9O4+zkR5Cn1razDyOILvZcUkUkPjaDiayWBJF43pmT
         q73e0Csjwz6LxwwoDOJzcup8+v2AwsFmuTgON/NBZsaMaBJ3gwoxksPtqNfDUj4f84
         k0/BHxkaisiTQcTZSZ1RI37xUwONzZ7xlt3egzMeN1FLkOKeuDgVoAjz9VthREGFZp
         5ZFLQEiOLSdCg==
Date:   Tue, 25 Oct 2022 14:17:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "david@fromorbit.com" <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 5/6] xfs: fix memcpy fortify errors in EFI log format
 copying
Message-ID: <Y1hSagZ2SnEyGLsS@magnolia>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
 <166664717980.2688790.14877643421674738495.stgit@magnolia>
 <fca71fe8808ba11e6e96cc5cc4c2da3acb243a7d.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fca71fe8808ba11e6e96cc5cc4c2da3acb243a7d.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 25, 2022 at 08:54:25PM +0000, Allison Henderson wrote:
> On Mon, 2022-10-24 at 14:32 -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Starting in 6.1, CONFIG_FORTIFY_SOURCE checks the length parameter of
> > memcpy.  Since we're already fixing problems with BUI item copying,
> > we
> > should fix it everything else.
> > 
> > An extra difficulty here is that the ef[id]_extents arrays are
> > declared
> > as single-element arrays.  This is not the convention for flex arrays
> > in
> > the modern kernel, and it causes all manner of problems with static
> > checking tools, since they often cannot tell the difference between a
> > single element array and a flex array.
> > 
> > So for starters, change those array[1] declarations to array[]
> > declarations to signal that they are proper flex arrays and adjust
> > all
> > the "size-1" expressions to fit the new declaration style.
> > 
> > Next, refactor the xfs_efi_copy_format function to handle the copying
> > of
> > the head and the flex array members separately.  While we're at it,
> > fix
> > a minor validation deficiency in the recovery function.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_log_format.h |   12 ++++++------
> >  fs/xfs/xfs_extfree_item.c      |   31 +++++++++++++++++++++---------
> > -
> >  fs/xfs/xfs_ondisk.h            |   11 +++++++----
> >  fs/xfs/xfs_super.c             |    4 ++--
> >  4 files changed, 36 insertions(+), 22 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_log_format.h
> > b/fs/xfs/libxfs/xfs_log_format.h
> > index b351b9dc6561..2f41fa8477c9 100644
> > --- a/fs/xfs/libxfs/xfs_log_format.h
> > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > @@ -613,7 +613,7 @@ typedef struct xfs_efi_log_format {
> >         uint16_t                efi_size;       /* size of this item
> > */
> >         uint32_t                efi_nextents;   /* # extents to free
> > */
> >         uint64_t                efi_id;         /* efi identifier */
> > -       xfs_extent_t            efi_extents[1]; /* array of extents
> > to free */
> > +       xfs_extent_t            efi_extents[];  /* array of extents
> > to free */
> >  } xfs_efi_log_format_t;
> >  
> >  typedef struct xfs_efi_log_format_32 {
> > @@ -621,7 +621,7 @@ typedef struct xfs_efi_log_format_32 {
> >         uint16_t                efi_size;       /* size of this item
> > */
> >         uint32_t                efi_nextents;   /* # extents to free
> > */
> >         uint64_t                efi_id;         /* efi identifier */
> > -       xfs_extent_32_t         efi_extents[1]; /* array of extents
> > to free */
> > +       xfs_extent_32_t         efi_extents[];  /* array of extents
> > to free */
> >  } __attribute__((packed)) xfs_efi_log_format_32_t;
> >  
> >  typedef struct xfs_efi_log_format_64 {
> > @@ -629,7 +629,7 @@ typedef struct xfs_efi_log_format_64 {
> >         uint16_t                efi_size;       /* size of this item
> > */
> >         uint32_t                efi_nextents;   /* # extents to free
> > */
> >         uint64_t                efi_id;         /* efi identifier */
> > -       xfs_extent_64_t         efi_extents[1]; /* array of extents
> > to free */
> > +       xfs_extent_64_t         efi_extents[];  /* array of extents
> > to free */
> >  } xfs_efi_log_format_64_t;
> >  
> >  /*
> > @@ -642,7 +642,7 @@ typedef struct xfs_efd_log_format {
> >         uint16_t                efd_size;       /* size of this item
> > */
> >         uint32_t                efd_nextents;   /* # of extents freed
> > */
> >         uint64_t                efd_efi_id;     /* id of
> > corresponding efi */
> > -       xfs_extent_t            efd_extents[1]; /* array of extents
> > freed */
> > +       xfs_extent_t            efd_extents[];  /* array of extents
> > freed */
> >  } xfs_efd_log_format_t;
> >  
> >  typedef struct xfs_efd_log_format_32 {
> > @@ -650,7 +650,7 @@ typedef struct xfs_efd_log_format_32 {
> >         uint16_t                efd_size;       /* size of this item
> > */
> >         uint32_t                efd_nextents;   /* # of extents freed
> > */
> >         uint64_t                efd_efi_id;     /* id of
> > corresponding efi */
> > -       xfs_extent_32_t         efd_extents[1]; /* array of extents
> > freed */
> > +       xfs_extent_32_t         efd_extents[];  /* array of extents
> > freed */
> >  } __attribute__((packed)) xfs_efd_log_format_32_t;
> >  
> >  typedef struct xfs_efd_log_format_64 {
> > @@ -658,7 +658,7 @@ typedef struct xfs_efd_log_format_64 {
> >         uint16_t                efd_size;       /* size of this item
> > */
> >         uint32_t                efd_nextents;   /* # of extents freed
> > */
> >         uint64_t                efd_efi_id;     /* id of
> > corresponding efi */
> > -       xfs_extent_64_t         efd_extents[1]; /* array of extents
> > freed */
> > +       xfs_extent_64_t         efd_extents[];  /* array of extents
> > freed */
> >  } xfs_efd_log_format_64_t;
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> > index 27ccfcd82f04..466cc5c5cd33 100644
> > --- a/fs/xfs/xfs_extfree_item.c
> > +++ b/fs/xfs/xfs_extfree_item.c
> > @@ -76,7 +76,7 @@ xfs_efi_item_sizeof(
> >         struct xfs_efi_log_item *efip)
> >  {
> >         return sizeof(struct xfs_efi_log_format) +
> > -              (efip->efi_format.efi_nextents - 1) *
> > sizeof(xfs_extent_t);
> > +              efip->efi_format.efi_nextents * sizeof(xfs_extent_t);
> Did we want to try and avoid using typedefs?  I notice that seems to
> come up a lot in reviews.  Otherwise the rest looks good.

Yes, but I kill off these typedef usages in the next patch by creating
the sizeof helpers.

--D

> Allison
> 
> >  }
> >  
> >  STATIC void
> > @@ -160,7 +160,7 @@ xfs_efi_init(
> >         ASSERT(nextents > 0);
> >         if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
> >                 size = (uint)(sizeof(struct xfs_efi_log_item) +
> > -                       ((nextents - 1) * sizeof(xfs_extent_t)));
> > +                       (nextents * sizeof(xfs_extent_t)));
> >                 efip = kmem_zalloc(size, 0);
> >         } else {
> >                 efip = kmem_cache_zalloc(xfs_efi_cache,
> > @@ -189,14 +189,19 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf,
> > xfs_efi_log_format_t *dst_efi_fmt)
> >         xfs_efi_log_format_t *src_efi_fmt = buf->i_addr;
> >         uint i;
> >         uint len = sizeof(xfs_efi_log_format_t) +
> > -               (src_efi_fmt->efi_nextents - 1) *
> > sizeof(xfs_extent_t);
> > +               src_efi_fmt->efi_nextents * sizeof(xfs_extent_t);
> >         uint len32 = sizeof(xfs_efi_log_format_32_t) +
> > -               (src_efi_fmt->efi_nextents - 1) *
> > sizeof(xfs_extent_32_t);
> > +               src_efi_fmt->efi_nextents * sizeof(xfs_extent_32_t);
> >         uint len64 = sizeof(xfs_efi_log_format_64_t) +
> > -               (src_efi_fmt->efi_nextents - 1) *
> > sizeof(xfs_extent_64_t);
> > +               src_efi_fmt->efi_nextents * sizeof(xfs_extent_64_t);
> >  
> >         if (buf->i_len == len) {
> > -               memcpy((char *)dst_efi_fmt, (char*)src_efi_fmt, len);
> > +               memcpy(dst_efi_fmt, src_efi_fmt,
> > +                      offsetof(struct xfs_efi_log_format,
> > efi_extents));
> > +               for (i = 0; i < src_efi_fmt->efi_nextents; i++)
> > +                       memcpy(&dst_efi_fmt->efi_extents[i],
> > +                              &src_efi_fmt->efi_extents[i],
> > +                              sizeof(struct xfs_extent));
> >                 return 0;
> >         } else if (buf->i_len == len32) {
> >                 xfs_efi_log_format_32_t *src_efi_fmt_32 = buf-
> > >i_addr;
> > @@ -256,7 +261,7 @@ xfs_efd_item_sizeof(
> >         struct xfs_efd_log_item *efdp)
> >  {
> >         return sizeof(xfs_efd_log_format_t) +
> > -              (efdp->efd_format.efd_nextents - 1) *
> > sizeof(xfs_extent_t);
> > +              efdp->efd_format.efd_nextents * sizeof(xfs_extent_t);
> >  }
> >  
> >  STATIC void
> > @@ -341,7 +346,7 @@ xfs_trans_get_efd(
> >  
> >         if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
> >                 efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
> > -                               (nextents - 1) * sizeof(struct
> > xfs_extent),
> > +                               nextents * sizeof(struct xfs_extent),
> >                                 0);
> >         } else {
> >                 efdp = kmem_cache_zalloc(xfs_efd_cache,
> > @@ -733,6 +738,12 @@ xlog_recover_efi_commit_pass2(
> >  
> >         efi_formatp = item->ri_buf[0].i_addr;
> >  
> > +       if (item->ri_buf[0].i_len <
> > +                       offsetof(struct xfs_efi_log_format,
> > efi_extents)) {
> > +               XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log-
> > >l_mp);
> > +               return -EFSCORRUPTED;
> > +       }
> > +
> >         efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
> >         error = xfs_efi_copy_format(&item->ri_buf[0], &efip-
> > >efi_format);
> >         if (error) {
> > @@ -772,9 +783,9 @@ xlog_recover_efd_commit_pass2(
> >  
> >         efd_formatp = item->ri_buf[0].i_addr;
> >         ASSERT((item->ri_buf[0].i_len ==
> > (sizeof(xfs_efd_log_format_32_t) +
> > -               ((efd_formatp->efd_nextents - 1) *
> > sizeof(xfs_extent_32_t)))) ||
> > +               (efd_formatp->efd_nextents *
> > sizeof(xfs_extent_32_t)))) ||
> >                (item->ri_buf[0].i_len ==
> > (sizeof(xfs_efd_log_format_64_t) +
> > -               ((efd_formatp->efd_nextents - 1) *
> > sizeof(xfs_extent_64_t)))));
> > +               (efd_formatp->efd_nextents *
> > sizeof(xfs_extent_64_t)))));
> >  
> >         xlog_recover_release_intent(log, XFS_LI_EFI, efd_formatp-
> > >efd_efi_id);
> >         return 0;
> > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > index 19c1df00b48e..9737b5a9f405 100644
> > --- a/fs/xfs/xfs_ondisk.h
> > +++ b/fs/xfs/xfs_ondisk.h
> > @@ -118,10 +118,10 @@ xfs_check_ondisk_structs(void)
> >         /* log structures */
> >         XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,        88);
> >         XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,          24);
> > -       XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,     28);
> > -       XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,     32);
> > -       XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,     28);
> > -       XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,     32);
> > +       XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,     16);
> > +       XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,     16);
> > +       XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,     16);
> > +       XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,     16);
> >         XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,             12);
> >         XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,             16);
> >         XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,            176);
> > @@ -146,6 +146,9 @@ xfs_check_ondisk_structs(void)
> >         XFS_CHECK_OFFSET(struct xfs_bui_log_format,
> > bui_extents,        16);
> >         XFS_CHECK_OFFSET(struct xfs_cui_log_format,
> > cui_extents,        16);
> >         XFS_CHECK_OFFSET(struct xfs_rui_log_format,
> > rui_extents,        16);
> > +       XFS_CHECK_OFFSET(struct xfs_efi_log_format,
> > efi_extents,        16);
> > +       XFS_CHECK_OFFSET(struct xfs_efi_log_format_32,
> > efi_extents,     16);
> > +       XFS_CHECK_OFFSET(struct xfs_efi_log_format_64,
> > efi_extents,     16);
> >  
> >         /*
> >          * The v5 superblock format extended several v4 header
> > structures with
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index f029c6702dda..8485e3b37ca0 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -2029,7 +2029,7 @@ xfs_init_caches(void)
> >  
> >         xfs_efd_cache = kmem_cache_create("xfs_efd_item",
> >                                         (sizeof(struct
> > xfs_efd_log_item) +
> > -                                       (XFS_EFD_MAX_FAST_EXTENTS -
> > 1) *
> > +                                       XFS_EFD_MAX_FAST_EXTENTS *
> >                                         sizeof(struct xfs_extent)),
> >                                         0, 0, NULL);
> >         if (!xfs_efd_cache)
> > @@ -2037,7 +2037,7 @@ xfs_init_caches(void)
> >  
> >         xfs_efi_cache = kmem_cache_create("xfs_efi_item",
> >                                          (sizeof(struct
> > xfs_efi_log_item) +
> > -                                        (XFS_EFI_MAX_FAST_EXTENTS -
> > 1) *
> > +                                        XFS_EFI_MAX_FAST_EXTENTS *
> >                                          sizeof(struct xfs_extent)),
> >                                          0, 0, NULL);
> >         if (!xfs_efi_cache)
> > 
> 
