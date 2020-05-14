Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A54C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 19:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BE8C206A5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 19:49:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P1jFt8WQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgENTtI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 15:49:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44724 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727833AbgENTtI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 15:49:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EJlPGC093714;
        Thu, 14 May 2020 19:49:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=05puZ9SZpVEZz7B1ZQDh9QIb/TfxtxU6acGKMEKk2JA=;
 b=P1jFt8WQgXRrAXsR0ApaLpwbdxcMpC16xvDZ0oAjbu1JLygziPOVOV5KjqoECoL0GBz4
 rzqYa5otDF+q6BG8OD9FaHj8YbcZ+m7q4zxkeZQsUHMIhhPP5JqM4G4igC7+VXznqFlS
 6M/s8fo+BEjOfiD7uL6U3nriHGkDFrbxZkl9zxIC+vzET2UXRQV6vhFENI1UkrJ5bPZg
 Cxl+A5/HmLd6ui+MyLtcEy763GMcSH9Ngal2D3TG054JAvGy6Li0qPqG6NfB/KEkllZH
 qb4lS5BX3KUoygyfN3A4Eud6iJWzxKTLa+QySQZYEnD47Jwpbdk8bzGGvjaX9D7a6eS+ 6g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3100xwms57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 19:49:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EJghxL195131;
        Thu, 14 May 2020 19:47:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 310vjtpsv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 19:47:04 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04EJl30E030607;
        Thu, 14 May 2020 19:47:03 GMT
Received: from localhost (/10.159.232.175)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 12:47:02 -0700
Date:   Thu, 14 May 2020 12:47:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs_repair: create a new class of btree rebuild
 cursors
Message-ID: <20200514194701.GG6714@magnolia>
References: <158904190079.984305.707785748675261111.stgit@magnolia>
 <158904191982.984305.12997847094211521747.stgit@magnolia>
 <20200514151107.GC50849@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200514151107.GC50849@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 suspectscore=5 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=5 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 11:11:07AM -0400, Brian Foster wrote:
> On Sat, May 09, 2020 at 09:31:59AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create some new support structures and functions to assist phase5 in
> > using the btree bulk loader to reconstruct metadata btrees.  This is the
> > first step in removing the open-coded rebuilding code.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> FYI, unused variable warnings:
> 
> phase5.c: In function ‘phase5_func’:
> phase5.c:2491:20: warning: unused variable ‘sc’ [-Wunused-variable]
>  2491 |  struct repair_ctx sc = { .mp = mp, };
>       |                    ^~
> At top level:
> phase5.c:509:1: warning: ‘finish_rebuild’ defined but not used [-Wunused-function]
>   509 | finish_rebuild(
>       | ^~~~~~~~~~~~~~
> phase5.c:468:1: warning: ‘rebuild_alloc_block’ defined but not used [-Wunused-function]
>   468 | rebuild_alloc_block(
>       | ^~~~~~~~~~~~~~~~~~~
> phase5.c:381:1: warning: ‘setup_rebuild’ defined but not used [-Wunused-function]
>   381 | setup_rebuild(
>       | ^~~~~~~~~~~~~
> phase5.c:366:1: warning: ‘init_rebuild’ defined but not used [-Wunused-function]
>   366 | init_rebuild(
>       | ^~~~~~~~~~~~

Yeah... these aren't used by anything until the next patch, and I was
trying to keep the "infrastructure you need for X" changes separate from
"X".  Though every time I do that, people complain about me adding code
that isn't used anywhere...

> >  repair/phase5.c |  240 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 219 insertions(+), 21 deletions(-)
> > 
> > 
> > diff --git a/repair/phase5.c b/repair/phase5.c
> > index f3be15de..7eb24519 100644
> > --- a/repair/phase5.c
> > +++ b/repair/phase5.c
> ...
> > @@ -306,6 +324,157 @@ _("error - not enough free space in filesystem\n"));
> ...
> > +/* Reserve blocks for the new btree. */
> > +static void
> > +setup_rebuild(
> > +	struct xfs_mount	*mp,
> > +	xfs_agnumber_t		agno,
> > +	struct bt_rebuild	*btr,
> > +	uint32_t		nr_blocks)
> > +{
> > +	struct extent_tree_node	*ext_ptr;
> > +	struct extent_tree_node	*bno_ext_ptr;
> > +	uint32_t		blocks_allocated = 0;
> > +	int			error;
> > +
> > +	/*
> > +	 * grab the smallest extent and use it up, then get the
> > +	 * next smallest.  This mimics the init_*_cursor code.
> > +	 */
> > +	ext_ptr =  findfirst_bcnt_extent(agno);
> > +
> > +	/*
> > +	 * set up the free block array
> > +	 */
> > +	while (blocks_allocated < nr_blocks)  {
> > +		uint64_t	len;
> > +		xfs_agblock_t	new_start;
> > +		xfs_extlen_t	new_len;
> > +
> > +		if (!ext_ptr)
> > +			do_error(
> > +_("error - not enough free space in filesystem\n"));
> > +
> > +		/* Use up the extent we've got. */
> > +		len = min(ext_ptr->ex_blockcount,
> > +				btr->bload.nr_blocks - blocks_allocated);
> 
> What's the difference between the nr_blocks parameter and this one?

I think that's a bug, and should have been:

	len = min(ext_ptr->ex_blockcount, nr_blocks - blocks_allocated);

> > +		error = xrep_newbt_add_reservation(&btr->newbt,
> > +				XFS_AGB_TO_FSB(mp, agno,
> > +					       ext_ptr->ex_startblock),
> > +				len, NULL);
> > +		if (error)
> > +			do_error(_("could not set up btree reservation: %s\n"),
> > +				strerror(-error));
> > +		blocks_allocated += len;
> > +
> > +		error = rmap_add_ag_rec(mp, agno, ext_ptr->ex_startblock, len,
> > +				btr->newbt.oinfo.oi_owner);
> > +		if (error)
> > +			do_error(_("could not set up btree rmaps: %s\n"),
> > +				strerror(-error));
> > +
> > +		/* Figure out if we're putting anything back. */
> 
> The remaining extent replacement bits of this loop looks like it could
> warrant a little helper and a comment to explain exactly what's
> happening at a high level.

Ok, I'll figure something out.

--D

> Brian
> 
> > +		new_start = ext_ptr->ex_startblock + len;
> > +		new_len = ext_ptr->ex_blockcount - len;
> > +
> > +		/* Delete the used-up extent from both extent trees. */
> > +#ifdef XR_BLD_FREE_TRACE
> > +		fprintf(stderr, "releasing extent: %u [%u %u]\n",
> > +			agno, ext_ptr->ex_startblock, ext_ptr->ex_blockcount);
> > +#endif
> > +		bno_ext_ptr = find_bno_extent(agno, ext_ptr->ex_startblock);
> > +		ASSERT(bno_ext_ptr != NULL);
> > +		get_bno_extent(agno, bno_ext_ptr);
> > +		release_extent_tree_node(bno_ext_ptr);
> > +
> > +		ext_ptr = get_bcnt_extent(agno, ext_ptr->ex_startblock,
> > +				ext_ptr->ex_blockcount);
> > +		ASSERT(ext_ptr != NULL);
> > +		release_extent_tree_node(ext_ptr);
> > +
> > +		/*
> > +		 * If we only used part of this last extent, then we need only
> > +		 * to reinsert the extent in the extent trees and we're done.
> > +		 */
> > +		if (new_len > 0) {
> > +			add_bno_extent(agno, new_start, new_len);
> > +			add_bcnt_extent(agno, new_start, new_len);
> > +			break;
> > +		}
> > +
> > +		/* Otherwise, find the next biggest extent. */
> > +		ext_ptr = findfirst_bcnt_extent(agno);
> > +	}
> > +#ifdef XR_BLD_FREE_TRACE
> > +	fprintf(stderr, "blocks_allocated = %d\n",
> > +		blocks_allocated);
> > +#endif
> > +}
> > +
> > +/* Feed one of the new btree blocks to the bulk loader. */
> > +static int
> > +rebuild_alloc_block(
> > +	struct xfs_btree_cur	*cur,
> > +	union xfs_btree_ptr	*ptr,
> > +	void			*priv)
> > +{
> > +	struct bt_rebuild	*btr = priv;
> > +
> > +	return xrep_newbt_claim_block(cur, &btr->newbt, ptr);
> > +}
> > +
> >  static void
> >  write_cursor(bt_status_t *curs)
> >  {
> > @@ -336,6 +505,34 @@ finish_cursor(bt_status_t *curs)
> >  	free(curs->btree_blocks);
> >  }
> >  
> > +static void
> > +finish_rebuild(
> > +	struct xfs_mount	*mp,
> > +	struct bt_rebuild	*btr)
> > +{
> > +	struct xrep_newbt_resv	*resv, *n;
> > +
> > +	for_each_xrep_newbt_reservation(&btr->newbt, resv, n) {
> > +		xfs_agnumber_t	agno;
> > +		xfs_agblock_t	bno;
> > +		xfs_extlen_t	len;
> > +
> > +		if (resv->used >= resv->len)
> > +			continue;
> > +
> > +		/* XXX: Shouldn't this go on the AGFL? */
> > +		/* Put back everything we didn't use. */
> > +		bno = XFS_FSB_TO_AGBNO(mp, resv->fsbno + resv->used);
> > +		agno = XFS_FSB_TO_AGNO(mp, resv->fsbno + resv->used);
> > +		len = resv->len - resv->used;
> > +
> > +		add_bno_extent(agno, bno, len);
> > +		add_bcnt_extent(agno, bno, len);
> > +	}
> > +
> > +	xrep_newbt_destroy(&btr->newbt, 0);
> > +}
> > +
> >  /*
> >   * We need to leave some free records in the tree for the corner case of
> >   * setting up the AGFL. This may require allocation of blocks, and as
> > @@ -2290,28 +2487,29 @@ keep_fsinos(xfs_mount_t *mp)
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
> > @@ -2533,8 +2731,8 @@ inject_lost_blocks(
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
