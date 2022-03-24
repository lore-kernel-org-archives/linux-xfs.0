Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889B8C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 05:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346294AbiCXF1r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 01:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiCXF1r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 01:27:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12050939BA
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 22:26:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F30660AC7
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 05:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039FEC340EC;
        Thu, 24 Mar 2022 05:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648099575;
        bh=jR7Yu4ORKGu+3mrD5yX5SnlBgUXoqh0XNdz0IMO11Ms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qba9jhT02IHSEsAxjIFyuQKXMFln0F1H8nbdvUiYRyOETnzOG3iKLU4OSf9OWRJr4
         7HcABmYiI2NgAlOtMAWZ+T8Gy7JpjPztCXoCO3BvjN8SDhgeYK5TSSdvJFLYqtVtCa
         ncpRHmgWfNv/bRAIj3xOvhK2YHZ9qIi2UxBA7RKMqR/7FCDIkbjNmnkeTAOOm8Rrx2
         xKWSuoJWU1XZma7Gkejo1GD8ycLetxir6hEsP8xfsS007vklp6Sd8RMNHS3tlxXYxE
         fnZx1Lv/YVPEt24+mYo935lvhBKYCbQSO8XjMcN4C2+rSufSPeZYURJfiqZW3Qs6gF
         Re6sU3jJp7XZw==
Date:   Wed, 23 Mar 2022 22:26:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: actually set aside enough space to handle a
 bmbt split
Message-ID: <20220324052614.GT8241@magnolia>
References: <164779460699.550479.5112721232994728564.stgit@magnolia>
 <164779461835.550479.15316047141170352189.stgit@magnolia>
 <20220323204856.GV1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323204856.GV1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 24, 2022 at 07:48:56AM +1100, Dave Chinner wrote:
> On Sun, Mar 20, 2022 at 09:43:38AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The comment for xfs_alloc_set_aside indicates that we want to set aside
> > enough space to handle a bmap btree split.  The code, unfortunately,
> > hardcodes this to 4.
> > 
> > This is incorrect, since file bmap btrees can be taller than that:
> > 
> > xfs_db> btheight bmapbt -n 4294967295 -b 512
> > bmapbt: worst case per 512-byte block: 13 records (leaf) / 13 keyptrs (node)
> > level 0: 4294967295 records, 330382100 blocks
> > level 1: 330382100 records, 25414008 blocks
> > level 2: 25414008 records, 1954924 blocks
> > level 3: 1954924 records, 150379 blocks
> > level 4: 150379 records, 11568 blocks
> > level 5: 11568 records, 890 blocks
> > level 6: 890 records, 69 blocks
> > level 7: 69 records, 6 blocks
> > level 8: 6 records, 1 block
> > 9 levels, 357913945 blocks total
> > 
> > Or, for V5 filesystems:
> > 
> > xfs_db> btheight bmapbt -n 4294967295 -b 1024
> > bmapbt: worst case per 1024-byte block: 29 records (leaf) / 29 keyptrs (node)
> > level 0: 4294967295 records, 148102321 blocks
> > level 1: 148102321 records, 5106977 blocks
> > level 2: 5106977 records, 176103 blocks
> > level 3: 176103 records, 6073 blocks
> > level 4: 6073 records, 210 blocks
> > level 5: 210 records, 8 blocks
> > level 6: 8 records, 1 block
> > 7 levels, 153391693 blocks total
> > 
> > Fix this by using the actual bmap btree maxlevel value for the
> > set-aside.  We subtract one because the root is always in the inode and
> > hence never splits.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c |    7 +++++--
> >  fs/xfs/libxfs/xfs_sb.c    |    2 --
> >  fs/xfs/xfs_mount.c        |    7 +++++++
> >  3 files changed, 12 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index b0678e96ce61..747b3e45303f 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -107,13 +107,16 @@ xfs_prealloc_blocks(
> >   * aside a few blocks which will not be reserved in delayed allocation.
> >   *
> >   * For each AG, we need to reserve enough blocks to replenish a totally empty
> > - * AGFL and 4 more to handle a potential split of the file's bmap btree.
> > + * AGFL and enough to handle a potential split of a file's bmap btree.
> >   */
> >  unsigned int
> >  xfs_alloc_set_aside(
> >  	struct xfs_mount	*mp)
> >  {
> > -	return mp->m_sb.sb_agcount * (XFS_ALLOCBT_AGFL_RESERVE + 4);
> > +	unsigned int		bmbt_splits;
> > +
> > +	bmbt_splits = max(mp->m_bm_maxlevels[0], mp->m_bm_maxlevels[1]) - 1;
> > +	return mp->m_sb.sb_agcount * (XFS_ALLOCBT_AGFL_RESERVE + bmbt_splits);
> >  }
> 
> So right now I'm trying to understand why this global space set
> aside ever needed to take into account the space used by a single
> BMBT split. ISTR it was done back in 2006 because the ag selection
> code, alloc args and/or xfs_alloc_space_available() didn't take into
> account the BMBT space via args->minleft correctly to ensure that
> the AGF we select had enough space in it for both the data extent
> and the followup BMBT split. Hence the original SET ASIDE (which
> wasn't per AG) was just 8 blocks - 4 for the AGFL, 4 for the BMBT.
> 
> The transaction reservation takes into account the space needed by
> BMBT splits so we don't over-commit global space on user allocation
> anymore, args->minleft takes it into account so we don't overcommit
> AG space on extent allocation, and we have the reserved block pool
> to handle situations were delalloc extents are fragmented more than
> the initial indirect block reservation that is taken with the
> delalloc extent reservation.
> 
> So where/why is this needed anymore?

Beats me.  I started by reading the comment and thought "Gee, that's not
true of bmbts!" :(

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
