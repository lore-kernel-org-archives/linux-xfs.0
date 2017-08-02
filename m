Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48854 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752428AbdHBQJh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2017 12:09:37 -0400
Date: Wed, 2 Aug 2017 09:09:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_metadump: zap stale date in DIR2_LEAF1 dirs
Message-ID: <20170802160927.GO4477@magnolia>
References: <37cd41d1-335f-a3af-d92c-c0b4b6d1356a@redhat.com>
 <20170802135417.GA38674@bfoster.bfoster>
 <da130ccd-cd0b-93d1-7dc1-7a5ab835815e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da130ccd-cd0b-93d1-7dc1-7a5ab835815e@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Stefan Ring <stefanrin@gmail.com>

On Wed, Aug 02, 2017 at 10:16:06AM -0500, Eric Sandeen wrote:
> On 8/2/17 8:54 AM, Brian Foster wrote:
> > On Tue, Aug 01, 2017 at 09:35:27PM -0500, Eric Sandeen wrote:
> >> xfs_metadump attempts to zero out unused regions of metadata
> >> blocks to prevent data leaks when sharing metadata images.
> >>
> >> However, Stefan Ring reported a significant number of leaked
> >> strings when dumping his 1T filesystem.  Based on a reduced
> >> metadata set, I was able to identify "leaf" directories
> >> (with XFS_DIR2_LEAF1_MAGIC magic) as the primary culprit;
> >> the region between the end of the entries array and the start
> >> of the bests array was not getting zeroed out.  This patch
> >> seems to remedy that problem.
> >>
> >> Reported-by: Stefan Ring <stefanrin@gmail.com>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> I may have missed some handy macro to work out some of the
> >> math below, if so I'd be perfectly happy to hear about it ;)
> >>
> > 
> > Looks good to me. A couple nits...
> > 
> >> diff --git a/db/metadump.c b/db/metadump.c
> >> index 96641e0..6d77d61 100644
> >> --- a/db/metadump.c
> >> +++ b/db/metadump.c
> >> @@ -1459,6 +1459,37 @@ process_dir_data_block(
> >>  	int		wantmagic;
> >>  	struct xfs_dir2_data_hdr *datahdr;
> >>  
> >> +	if (offset >= mp->m_dir_geo->freeblk) {
> >> +		/* TODO */
> >> +		return;
> > 
> > TODO what exactly? Zero from the end of the bests array to the end of
> > the block? We could at least add the if (!zero_stale_data) check here
> > too.
> 
> TODO: see if there's any work to do here ;)  Yes, end of bests
> to end of block, I think.
> 
> >> +	} else if (offset >= mp->m_dir_geo->leafblk) {
> >> +		struct xfs_dir2_leaf		*leaf;
> >> +		struct xfs_dir2_leaf_tail	*ltp;
> >> +		struct xfs_dir3_icleaf_hdr 	leafhdr;
> >> +
> >> +		if (!zero_stale_data)
> >> +			return;
> >> +
> >> +		leaf = (struct xfs_dir2_leaf *)block;
> >> +		ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, leaf);
> > 
> > ltp isn't used until the block of code below (which already has locally
> > scoped vars).
> 
> Ok, oops, moved most.  thanks.
> 
> Dave also points out that I should be checking DIR3_LEAF1_MAGIC
> as well.
> 
> Thanks,
> -Eric
> 
> > 
> > Brian
> > 
> >> +		M_DIROPS(mp)->leaf_hdr_from_disk(&leafhdr, leaf);
> >> +
> >> +		/* Zero out space from end of ents[] to bests */
> >> +		if (leafhdr.magic == XFS_DIR2_LEAF1_MAGIC) {
> >> +			struct xfs_dir2_leaf_entry	*ents;
> >> +			__be16				*lbp;
> >> +			char				*start; /* end of ents */
> >> +
> >> +			ents = M_DIROPS(mp)->leaf_ents_p(leaf);
> >> +			start = (char *)&ents[leafhdr.count + leafhdr.stale];
> >> +			lbp = xfs_dir2_leaf_bests_p(ltp);
> >> +			memset(start, 0, (char *)lbp - start);
> >> +			iocur_top->need_crc = 1;
> >> +		}
> >> +		return;
> >> +	}

Ugh, this function is losing cohesion.  Can we give the leaf and free
block handlers a separate function and dispatch them directly from the
case TYP_DIR2 clause below, instead of cluttering up the dir data/block
processing function?

--D

> >> +
> >> +	/* It's a data block. */
> >>  	datahdr = (struct xfs_dir2_data_hdr *)block;
> >>  
> >>  	if (is_block_format) {
> >> @@ -1800,9 +1831,6 @@ process_single_fsb_objects(
> >>  		dp = iocur_top->data;
> >>  		switch (btype) {
> >>  		case TYP_DIR2:
> >> -			if (o >= mp->m_dir_geo->leafblk)
> >> -				break;
> >> -
> >>  			process_dir_data_block(dp, o,
> >>  					 last == mp->m_dir_geo->fsbcount);
> >>  			iocur_top->need_crc = 1;
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
