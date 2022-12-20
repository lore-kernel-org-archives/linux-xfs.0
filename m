Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5101DC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 16:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiLTQKv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 11:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbiLTQK1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 11:10:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC0F17AB2
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 08:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62F50B81193
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 16:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18ED4C433EF;
        Tue, 20 Dec 2022 16:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671552609;
        bh=YfBzsKkXVIBO2a7ym95eqIQa10CA2D+kGGaVCTFk2X4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B5nvd5IxslElz/Id3L7sax+RiCIEaMyojW039DjFqBijoFp394vtZ83ObUMqaZGoo
         yz2MQz4S9XSzAMiFVmaB6RDo3evJMJ7X4EATJR7bP0oDcM/7CXQo9ySeAhDPvv0anV
         MkuT2AQcn66SgCqbmvHqYjeQFxcYa+ZDBzbIcTg7aPK9efXvYjf5ThfgSqyblExkD4
         EZaPsbDaHPs0wrenvcIw8JbX5XCjrhvLvC53uKn9anWClQBjWpHzi6vRgAcej2D9rn
         YgwajRXCI/FwcE/YwvfjBuahOneAKKCNHR1FyNAtxiRnpzNzkgfcA2lMalsfWJmATs
         UwsCitivsRmlQ==
Date:   Tue, 20 Dec 2022 08:10:08 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix off-by-one error in
 xfs_btree_space_to_height
Message-ID: <Y6HeYJXVhamT589A@magnolia>
References: <167149469744.336919.13748690081866673267.stgit@magnolia>
 <167149471987.336919.3277522603824048839.stgit@magnolia>
 <20221220050001.GK1971568@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220050001.GK1971568@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 20, 2022 at 04:00:01PM +1100, Dave Chinner wrote:
> On Mon, Dec 19, 2022 at 04:05:19PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Lately I've been stress-testing extreme-sized rmap btrees by using the
> > (new) xfs_db bmap_inflate command to clone bmbt mappings billions of
> > times and then using xfs_repair to build new rmap and refcount btrees.
> > This of course is /much/ faster than actually FICLONEing a file billions
> > of times.
> > 
> > Unfortunately, xfs_repair fails in xfs_btree_bload_compute_geometry with
> > EOVERFLOW, which indicates that xfs_mount.m_rmap_maxlevels is not
> > sufficiently large for the test scenario.  For a 1TB filesystem (~67
> > million AG blocks, 4 AGs) the btheight command reports:
> > 
> > $ xfs_db -c 'btheight -n 4400801200 -w min rmapbt' /dev/sda
> > rmapbt: worst case per 4096-byte block: 84 records (leaf) / 45 keyptrs (node)
> > level 0: 4400801200 records, 52390491 blocks
> > level 1: 52390491 records, 1164234 blocks
> > level 2: 1164234 records, 25872 blocks
> > level 3: 25872 records, 575 blocks
> > level 4: 575 records, 13 blocks
> > level 5: 13 records, 1 block
> > 6 levels, 53581186 blocks total
> > 
> > The AG is sufficiently large to build this rmap btree.  Unfortunately,
> > m_rmap_maxlevels is 5.  Augmenting the loop in the space->height
> > function to report height, node blocks, and blocks remaining produces
> > this:
> > 
> > ht 1 node_blocks 45 blockleft 67108863
> > ht 2 node_blocks 2025 blockleft 67108818
> > ht 3 node_blocks 91125 blockleft 67106793
> > ht 4 node_blocks 4100625 blockleft 67015668
> > final height: 5
> > 
> > The goal of this function is to compute the maximum height btree that
> > can be stored in the given number of ondisk fsblocks.  Starting with the
> > top level of the tree, each iteration through the loop adds the fanout
> > factor of the next level down until we run out of blocks.  IOWs, maximum
> > height is achieved by using the smallest fanout factor that can apply
> > to that level.
> > 
> > However, the loop setup is not correct.  Top level btree blocks are
> > allowed to contain fewer than minrecs items, so the computation is
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Ah, that's the critical piece of information I was looking for. I
> couldn't work out from the code change below what was wrong with
> limits[1]. So....
> 
> > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > index 4c16c8c31fcb..8d11d3f5e529 100644
> > --- a/fs/xfs/libxfs/xfs_btree.c
> > +++ b/fs/xfs/libxfs/xfs_btree.c
> > @@ -4666,7 +4666,11 @@ xfs_btree_space_to_height(
> >  	const unsigned int	*limits,
> >  	unsigned long long	leaf_blocks)
> >  {
> > -	unsigned long long	node_blocks = limits[1];
> > +	/*
> > +	 * The root btree block can have a fanout between 2 and maxrecs because
> > +	 * the tree might not be big enough to fill it.
> > +	 */
> 
> Can you change this comment to say something like:
> 
> 	/*
> 	 * The root btree block can have less than minrecs pointers
> 	 * in it because the tree might not be big enough to require
> 	 * that amount of fanout. Hence it has a minimum size of
> 	 * 2 pointers, not limits[1].
> 	 */

Done.  Thanks for the reviews! :)

--D

> 
> Otherwise it looks good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> > +	unsigned long long	node_blocks = 2;
> >  	unsigned long long	blocks_left = leaf_blocks - 1;
> >  	unsigned int		height = 1;
> 
> For future consideration, we don't use maxrecs in this calculation
> at all - should we just pass minrecs into the function rather than
> an array of limits?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
