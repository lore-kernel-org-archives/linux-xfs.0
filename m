Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C61C32771
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Sep 2022 00:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiI0ACI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Sep 2022 20:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiI0ACH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Sep 2022 20:02:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584C49F756
        for <linux-xfs@vger.kernel.org>; Mon, 26 Sep 2022 17:02:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB4916116E
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2022 00:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DAFC433D6;
        Tue, 27 Sep 2022 00:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664236925;
        bh=3M0MU0szEJgM3Ju0J4NjhRZ1be4z40szpRYttiBjYsc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L19sLM2v9IVhAv1YLwDuFtrjski+g6iKPT7jjnuF4LuFWP1o5+54nUhrkH7QkzXln
         b2VjBN4EXGNvwUifvbCkoHR//Zi3BVOrolWW1Ogkt5LdN8sNUCz226+prYK1JpghIP
         Gd/qfKCFaCAp8Cp54dPDMkMfll1fHurQRlwKGTFDd00abThtwx0LEvqUryWi1HFG5j
         IUQUy2zMfKf0/I6HVXUGnE0mIZ8gFhxb5zCR8vaIezXmUb17RFFcaK/oHFjJN67F9C
         UaLsrvFrZmJ5qPsEiiAylZLyQCjgnao99OW1GBJ+z9o42E9qXlFoWfKgZ/H1JODTdX
         xHChkVvHjYYFQ==
Date:   Mon, 26 Sep 2022 17:02:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 25/26] xfs: fix unit conversion error in
 xfs_log_calc_max_attrsetm_res
Message-ID: <YzI9fKt3w2uMAWzQ@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-26-allison.henderson@oracle.com>
 <Yy4pZcjowhK+WWNS@magnolia>
 <a0dcc3ad4144641a0cf8674501ae41145a22e392.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a0dcc3ad4144641a0cf8674501ae41145a22e392.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 26, 2022 at 09:50:09PM +0000, Allison Henderson wrote:
> On Fri, 2022-09-23 at 14:47 -0700, Darrick J. Wong wrote:
> > On Wed, Sep 21, 2022 at 10:44:57PM -0700,
> > allison.henderson@oracle.com wrote:
> > > From: Allison Henderson <allison.henderson@oracle.com>
> > 
> > Er, did you change this patch much?
> > 
> > I was really hoping you'd *RVB* tag it and send it back out. :)
> Oh, I didnt change anything, but I assumed if it's unmerged it's
> supposed to have the submitters SOB?  The sob is a sort of legal
> signature that you certify that the contents are clear to be open src
> right? 
> 
> TBH, most of the patches originally came from Dave or Mark, but have
> sort of evolved over the reviews and rebases.  It's not really clear
> who authored what anymore, but the point is that in submitting it, you
> certify that no ones un-sobed code has wandered in.
> 
> At least that was my understanding?

<shrug> My understanding is that if someone sends you a patch and you
add it to your tree unchanged, you're allowed to retain the From: of the
original author and tag if RVB if you like, and since you didn't make
any changes, you don't need to add a SOB.

IOWS I /think/ you only need to add your own SOB if you're /not/ passing
it along unchanged.

<usual IANAL disclaimer>

<<nearly said usual BANANA disclaimer>>

--D

> 
> 
> 
> 
> > 
> > --D
> > 
> > > 
> > > Dave and I were discussing some recent test regressions as a result
> > > of
> > > me turning on nrext64=1 on realtime filesystems, when we noticed
> > > that
> > > the minimum log size of a 32M filesystem jumped from 954 blocks to
> > > 4287
> > > blocks.
> > > 
> > > Digging through xfs_log_calc_max_attrsetm_res, Dave noticed that
> > > @size
> > > contains the maximum estimated amount of space needed for a local
> > > format
> > > xattr, in bytes, but we feed this quantity to
> > > XFS_NEXTENTADD_SPACE_RES,
> > > which requires units of blocks.  This has resulted in an
> > > overestimation
> > > of the minimum log size over the years.
> > > 
> > > We should nominally correct this, but there's a backwards
> > > compatibility
> > > problem -- if we enable it now, the minimum log size will
> > > decrease.  If
> > > a corrected mkfs formats a filesystem with this new smaller log
> > > size, a
> > > user will encounter mount failures on an uncorrected kernel due to
> > > the
> > > larger minimum log size computations there.
> > > 
> > > However, the large extent counters feature is still EXPERIMENTAL,
> > > so we
> > > can gate the correction on that feature (or any features that get
> > > added
> > > after that) being enabled.  Any filesystem with nrext64 or any of
> > > the
> > > as-yet-undefined feature bits turned on will be rejected by old
> > > uncorrected kernels, so this should be safe even in the upgrade
> > > case.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_log_rlimit.c | 43
> > > ++++++++++++++++++++++++++++++++++
> > >  1 file changed, 43 insertions(+)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c
> > > b/fs/xfs/libxfs/xfs_log_rlimit.c
> > > index 9975b93a7412..e5c606fb7a6a 100644
> > > --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> > > +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> > > @@ -16,6 +16,39 @@
> > >  #include "xfs_bmap_btree.h"
> > >  #include "xfs_trace.h"
> > >  
> > > +/*
> > > + * Decide if the filesystem has the parent pointer feature or any
> > > feature
> > > + * added after that.
> > > + */
> > > +static inline bool
> > > +xfs_has_parent_or_newer_feature(
> > > +       struct xfs_mount        *mp)
> > > +{
> > > +       if (!xfs_sb_is_v5(&mp->m_sb))
> > > +               return false;
> > > +
> > > +       if (xfs_sb_has_compat_feature(&mp->m_sb, ~0))
> > > +               return true;
> > > +
> > > +       if (xfs_sb_has_ro_compat_feature(&mp->m_sb,
> > > +                               ~(XFS_SB_FEAT_RO_COMPAT_FINOBT |
> > > +                                XFS_SB_FEAT_RO_COMPAT_RMAPBT |
> > > +                                XFS_SB_FEAT_RO_COMPAT_REFLINK |
> > > +                                XFS_SB_FEAT_RO_COMPAT_INOBTCNT)))
> > > +               return true;
> > > +
> > > +       if (xfs_sb_has_incompat_feature(&mp->m_sb,
> > > +                               ~(XFS_SB_FEAT_INCOMPAT_FTYPE |
> > > +                                XFS_SB_FEAT_INCOMPAT_SPINODES |
> > > +                                XFS_SB_FEAT_INCOMPAT_META_UUID |
> > > +                                XFS_SB_FEAT_INCOMPAT_BIGTIME |
> > > +                                XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
> > > +                                XFS_SB_FEAT_INCOMPAT_NREXT64)))
> > > +               return true;
> > > +
> > > +       return false;
> > > +}
> > > +
> > >  /*
> > >   * Calculate the maximum length in bytes that would be required
> > > for a local
> > >   * attribute value as large attributes out of line are not logged.
> > > @@ -31,6 +64,16 @@ xfs_log_calc_max_attrsetm_res(
> > >                MAXNAMELEN - 1;
> > >         nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> > >         nblks += XFS_B_TO_FSB(mp, size);
> > > +
> > > +       /*
> > > +        * Starting with the parent pointer feature, every new fs
> > > feature
> > > +        * corrects a unit conversion error in the xattr
> > > transaction
> > > +        * reservation code that resulted in oversized minimum log
> > > size
> > > +        * computations.
> > > +        */
> > > +       if (xfs_has_parent_or_newer_feature(mp))
> > > +               size = XFS_B_TO_FSB(mp, size);
> > > +
> > >         nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
> > >  
> > >         return  M_RES(mp)->tr_attrsetm.tr_logres +
> > > -- 
> > > 2.25.1
> > > 
> 
