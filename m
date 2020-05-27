Return-Path: <SRS0=YlU2=7J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA821C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 22:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 735A82078C
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 22:09:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NEZvxxhE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725613AbgE0WJn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 May 2020 18:09:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47130 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgE0WJm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 May 2020 18:09:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RM2ueQ119445;
        Wed, 27 May 2020 22:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=84kcLpwOF5XI6lx3lsgS/h1c6AhpbreadGxUqkQ5gEA=;
 b=NEZvxxhEP+HVoxASuumN8/qS6GVk9W3ol191lyjmAj6MRrE01meVZIWk9yF/+Ry9Jnm4
 E3HX9KRRHYEiUFuTg3GyVaVOwUePlNOYIy//eMw6zg+C/nrs5cNz34EvyMvLAE8e1Ds0
 /QLpeGJNWVZmsJgvzHNvcRINFkhcolTwhvmAZUMv1QdNxWc/K727K26apnwfnPzKDk2V
 JKuPbW8MyMWF5t+4xKmtQIUW/rHtWlqJpJvUM/eG6GGbwdPeIKe9I3+OQuBqjBK33EKo
 RhSssc36rc6t+lGb8UDCNAEhdhkID2Wzw2/kiJHlsherbPd0EIwPcPjMwSG+SQumKXLH 1A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 318xe1hyr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 22:09:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RM2tsl080316;
        Wed, 27 May 2020 22:07:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 317ds197nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 22:07:35 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04RM7YPh003569;
        Wed, 27 May 2020 22:07:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 May 2020 15:07:34 -0700
Date:   Wed, 27 May 2020 15:07:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs_repair: create a new class of btree rebuild
 cursors
Message-ID: <20200527220733.GN8230@magnolia>
References: <158993944270.983175.4120094597556662259.stgit@magnolia>
 <158993946213.983175.9823091723787830102.stgit@magnolia>
 <20200527121804.GC12014@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527121804.GC12014@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9634 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=5 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9634 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 cotscore=-2147483648 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=5 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 27, 2020 at 08:18:04AM -0400, Brian Foster wrote:
> On Tue, May 19, 2020 at 06:51:02PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create some new support structures and functions to assist phase5 in
> > using the btree bulk loader to reconstruct metadata btrees.  This is the
> > first step in removing the open-coded rebuilding code.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/phase5.c |  239 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 218 insertions(+), 21 deletions(-)
> > 
> > 
> > diff --git a/repair/phase5.c b/repair/phase5.c
> > index 84c05a13..8f5e5f59 100644
> > --- a/repair/phase5.c
> > +++ b/repair/phase5.c
> > @@ -18,6 +18,7 @@
> >  #include "progress.h"
> >  #include "slab.h"
> >  #include "rmap.h"
> > +#include "bload.h"
> >  
> >  /*
> >   * we maintain the current slice (path from root to leaf)
> ...
> > @@ -306,6 +324,156 @@ _("error - not enough free space in filesystem\n"));
> >  #endif
> >  }
> >  
> ...
> > +static void
> > +consume_freespace(
> > +	xfs_agnumber_t		agno,
> > +	struct extent_tree_node	*ext_ptr,
> > +	uint32_t		len)
> > +{
> > +	struct extent_tree_node	*bno_ext_ptr;
> > +	xfs_agblock_t		new_start = ext_ptr->ex_startblock + len;
> > +	xfs_extlen_t		new_len = ext_ptr->ex_blockcount - len;
> > +
> > +	/* Delete the used-up extent from both extent trees. */
> > +#ifdef XR_BLD_FREE_TRACE
> > +	fprintf(stderr, "releasing extent: %u [%u %u]\n", agno,
> > +			ext_ptr->ex_startblock, ext_ptr->ex_blockcount);
> > +#endif
> > +	bno_ext_ptr = find_bno_extent(agno, ext_ptr->ex_startblock);
> > +	ASSERT(bno_ext_ptr != NULL);
> > +	get_bno_extent(agno, bno_ext_ptr);
> > +	release_extent_tree_node(bno_ext_ptr);
> > +
> > +	ext_ptr = get_bcnt_extent(agno, ext_ptr->ex_startblock,
> > +			ext_ptr->ex_blockcount);
> > +	release_extent_tree_node(ext_ptr);
> > +
> 
> Not having looked too deeply at the in-core extent tracking structures,
> is there any particular reason we unconditionally remove and reinsert
> new records each time around? Is it because we're basically changing the
> extent index in the tree? If so, comment please (an update to the
> comment below is probably fine). :)

Yes.  We're changing the free space tree records, and the incore bno and
cnt trees maintain the records in sorted order.  Therefore, if we want
to change a record we have to delete the record from the tree and
reinsert it.

> > +	/*
> > +	 * If we only used part of this last extent, then we must reinsert the
> > +	 * extent in the extent trees.

/*
 * If we only used part of this last extent, then we must reinsert the
 * extent to maintain proper sorting order.
 */

How about that?

> > +	 */
> > +	if (new_len > 0) {
> > +		add_bno_extent(agno, new_start, new_len);
> > +		add_bcnt_extent(agno, new_start, new_len);
> > +	}
> > +}
> > +
> > +/* Reserve blocks for the new btree. */
> > +static void
> > +setup_rebuild(
> > +	struct xfs_mount	*mp,
> > +	xfs_agnumber_t		agno,
> > +	struct bt_rebuild	*btr,
> > +	uint32_t		nr_blocks)
> > +{
> > +	struct extent_tree_node	*ext_ptr;
> > +	uint32_t		blocks_allocated = 0;
> > +	uint32_t		len;
> > +	int			error;
> > +
> > +	while (blocks_allocated < nr_blocks)  {
> > +		/*
> > +		 * Grab the smallest extent and use it up, then get the
> > +		 * next smallest.  This mimics the init_*_cursor code.
> > +		 */
> > +		ext_ptr =  findfirst_bcnt_extent(agno);
> 
> Extra whitespace	  ^
> 
> > +		if (!ext_ptr)
> > +			do_error(
> > +_("error - not enough free space in filesystem\n"));
> > +
> > +		/* Use up the extent we've got. */
> > +		len = min(ext_ptr->ex_blockcount, nr_blocks - blocks_allocated);
> > +		error = xrep_newbt_add_blocks(&btr->newbt,
> > +				XFS_AGB_TO_FSB(mp, agno,
> > +					       ext_ptr->ex_startblock),
> > +				len);
> 
> Alignment.

Will fix both of these.

> > +		if (error)
> > +			do_error(_("could not set up btree reservation: %s\n"),
> > +				strerror(-error));
> > +
> > +		error = rmap_add_ag_rec(mp, agno, ext_ptr->ex_startblock, len,
> > +				btr->newbt.oinfo.oi_owner);
> > +		if (error)
> > +			do_error(_("could not set up btree rmaps: %s\n"),
> > +				strerror(-error));
> > +
> > +		consume_freespace(agno, ext_ptr, len);
> > +		blocks_allocated += len;
> > +	}
> > +#ifdef XR_BLD_FREE_TRACE
> > +	fprintf(stderr, "blocks_allocated = %d\n",
> > +		blocks_allocated);
> > +#endif
> > +}
> > +
> > +/* Feed one of the new btree blocks to the bulk loader. */
> > +static int
> > +rebuild_claim_block(
> > +	struct xfs_btree_cur	*cur,
> > +	union xfs_btree_ptr	*ptr,
> > +	void			*priv)
> > +{
> > +	struct bt_rebuild	*btr = priv;
> > +
> > +	return xrep_newbt_claim_block(cur, &btr->newbt, ptr);
> > +}
> > +
> 
> Seems like an unnecessary helper, unless this grows more code in later
> patches..?

It doesn't grow any more code, but keep in mind that get_record,
claim_block, and iroot_size are all callbacks of xfs_btree_bload().  The
priv parameter passed to that function are passed unchanged to the three
callbacks.  The bulk load code doesn't know anything about where the
blocks or the records come from, so this is how both repairs will pass
that information to the callbacks.

> >  static void
> >  write_cursor(bt_status_t *curs)
> >  {
> ...
> > @@ -2287,28 +2483,29 @@ keep_fsinos(xfs_mount_t *mp)
> >  
> >  static void
> >  phase5_func(
> > -	xfs_mount_t	*mp,
> > -	xfs_agnumber_t	agno,
> > -	struct xfs_slab	*lost_fsb)
> > +	struct xfs_mount	*mp,
> > +	xfs_agnumber_t		agno,
> > +	struct xfs_slab		*lost_fsb)
> >  {
> > -	uint64_t	num_inos;
> > -	uint64_t	num_free_inos;
> > -	uint64_t	finobt_num_inos;
> > -	uint64_t	finobt_num_free_inos;
> > -	bt_status_t	bno_btree_curs;
> > -	bt_status_t	bcnt_btree_curs;
> > -	bt_status_t	ino_btree_curs;
> > -	bt_status_t	fino_btree_curs;
> > -	bt_status_t	rmap_btree_curs;
> > -	bt_status_t	refcnt_btree_curs;
> > -	int		extra_blocks = 0;
> > -	uint		num_freeblocks;
> > -	xfs_extlen_t	freeblks1;
> > +	struct repair_ctx	sc = { .mp = mp, };
> 
> I don't see any reason to add sc here when it's still unused. It's not
> as if a single variable is saving complexity somewhere else. I guess
> I'll defer to Eric on the approach wrt to the other unused warnings.

<shrug> I'll ask.  It seems dumb to have a prep patch that adds a bunch
of symbols that won't get used until the next patch, but OTOH combining
the two will make for a ~40K patch.

> Also, what's the purpose of the rmap change below? I'm wondering if that
> (along with all of the indentation cleanup) should be its own patch with
> appropriate explanation.

Errk, that one definitely should be separate.

> Brian
> 
> > +	struct agi_stat		agi_stat = {0,};
> > +	uint64_t		num_inos;
> > +	uint64_t		num_free_inos;
> > +	uint64_t		finobt_num_inos;
> > +	uint64_t		finobt_num_free_inos;
> > +	bt_status_t		bno_btree_curs;
> > +	bt_status_t		bcnt_btree_curs;
> > +	bt_status_t		ino_btree_curs;
> > +	bt_status_t		fino_btree_curs;
> > +	bt_status_t		rmap_btree_curs;
> > +	bt_status_t		refcnt_btree_curs;
> > +	int			extra_blocks = 0;
> > +	uint			num_freeblocks;
> > +	xfs_extlen_t		freeblks1;
> >  #ifdef DEBUG
> > -	xfs_extlen_t	freeblks2;
> > +	xfs_extlen_t		freeblks2;
> >  #endif
> > -	xfs_agblock_t	num_extents;
> > -	struct agi_stat	agi_stat = {0,};
> > +	xfs_agblock_t		num_extents;
> >  
> >  	if (verbose)
> >  		do_log(_("        - agno = %d\n"), agno);
> > @@ -2516,8 +2713,8 @@ inject_lost_blocks(
> >  		if (error)
> >  			goto out_cancel;
> >  
> > -		error = -libxfs_free_extent(tp, *fsb, 1, &XFS_RMAP_OINFO_AG,
> > -					    XFS_AG_RESV_NONE);
> > +		error = -libxfs_free_extent(tp, *fsb, 1,
> > +				&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_NONE);
> >  		if (error)
> >  			goto out_cancel;
> >  
> > 
> 
