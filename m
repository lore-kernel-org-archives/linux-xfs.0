Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91DDC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 20:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240711AbiCRUx3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 16:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240529AbiCRUx2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 16:53:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D07C114FFB
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 13:52:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CA0EB82504
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 20:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7D0C340E8;
        Fri, 18 Mar 2022 20:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636725;
        bh=otLZVs8PSGwcYGNQPxdd+PggSWGFeV4/RJcgUFhUe2o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yl1uezXwbgzg62hNQmPNxTojorGtnwq7oNf2DXjd31dVTx7AlLR9Jpi0pTeX4Wffx
         4UflVp6WAvsEk7Ia4S4ap1X7y5ja6N74joF6tpzoMo1tN0+KNjtLz3zsNLjQHf8o/i
         7FXi+4zK5UrFsTptQ8kEHF3oOL3JjGK7pLNN6HLYMwhbDapclqrUNJ+DzRM4SaJ3md
         UZo/7uADPiALIwGa/Sj3tie27pUI8lo3oYHrEhj+9AH5B6cjKCaTjVLKoTTIHouXi/
         8lU87Ffak7XtJYgoyAjiI1av0SbaGYlJq4wCVWPR8eQfsCB467ezdppoTyT2LbTT8f
         seRWGYBr9PisQ==
Date:   Fri, 18 Mar 2022 13:52:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/6] xfs: actually set aside enough space to handle a
 bmbt split
Message-ID: <20220318205204.GD8224@magnolia>
References: <164755205517.4194202.16256634362046237564.stgit@magnolia>
 <164755206657.4194202.6609453202119841910.stgit@magnolia>
 <YjR4cZ47tOutXB+e@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjR4cZ47tOutXB+e@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 18, 2022 at 08:17:53AM -0400, Brian Foster wrote:
> On Thu, Mar 17, 2022 at 02:21:06PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The comment for xfs_alloc_set_aside indicates that we want to set aside
> > enough space to handle a bmap btree split.  The code, unfortunately,
> > hardcodes this to 4.
> > 
> > This is incorrect, since file bmap btrees can be taller than that:
> > 
> > xfs_db> btheight bmapbt -n 4294967296 -b 512
> > bmapbt: worst case per 512-byte block: 13 records (leaf) / 13 keyptrs (node)
> > level 0: 4294967296 records, 330382100 blocks
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
> > Fix this by using the actual bmap btree maxlevel value for the
> > set-aside.  We subtract one because the root is always in the inode and
> > hence never splits.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c |    7 +++++--
> >  fs/xfs/libxfs/xfs_sb.c    |    2 --
> >  fs/xfs/xfs_mount.c        |    7 +++++++
> >  3 files changed, 12 insertions(+), 4 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index bed73e8002a5..9336176dc706 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -652,6 +652,13 @@ xfs_mountfs(
> >  
> >  	xfs_agbtree_compute_maxlevels(mp);
> >  
> > +	/*
> > +	 * Compute the amount of space to set aside to handle btree splits now
> > +	 * that we have calculated the btree maxlevels.
> > +	 */
> 
> "... to handle btree splits near -ENOSPC ..." ?

Fixed; thanks for the review!

--D

> Otherwise LGTM:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
> > +	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
> > +
> >  	/*
> >  	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
> >  	 * is NOT aligned turn off m_dalign since allocator alignment is within
> > 
> 
