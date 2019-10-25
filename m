Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34C4CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E28C21872
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:37:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hUtnXxgO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633104AbfJYQhh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:37:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59768 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2633105AbfJYQhh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 12:37:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PGXpnK121486;
        Fri, 25 Oct 2019 16:37:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=1ITfYUGmwl/OnpYK8Uv/hfrMO3VapVix2wkpFeTMRL8=;
 b=hUtnXxgO3KnATiBq2CqDw9BEEwzb3oPFvM5wK7Z2z046sbFwTnp6f8sCKp0vcTD3FEqs
 1lAdx4qCP0YD+EorFgKPVZZUsbx92rV+mTHZAsrlRhY1RYdwWgO3Gu1+R270dOM0q7s5
 8AX+n04y5a5MFgF/cOOtNlugAwxfTV/NRMhuj+8kush8WJHOoDA4dQm/Vccsf4j+cPLc
 ka2yhA34LqdHU1Jd/ECS07lKYtIB59C++JKrsykOO29gQiO0lxo/tT+bVUlKoyorBoX2
 yn71ruMBx8hu/sT4qxM/FrEozJKcx0DauHFgputieg0n3rgcO6juD5HUddv2tU0AxqET lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vqu4rc191-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:37:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PGXAq1150659;
        Fri, 25 Oct 2019 16:35:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vug0et0xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:35:19 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9PGZIm1024541;
        Fri, 25 Oct 2019 16:35:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Oct 2019 09:35:18 -0700
Date:   Fri, 25 Oct 2019 09:35:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: implement block reservation accounting for
 btrees we're staging
Message-ID: <20191025163517.GK913374@magnolia>
References: <157063978750.2914891.14339604572380248276.stgit@magnolia>
 <157063979983.2914891.13811468205423934367.stgit@magnolia>
 <20191025142227.GB11837@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025142227.GB11837@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 10:22:27AM -0400, Brian Foster wrote:
> On Wed, Oct 09, 2019 at 09:49:59AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a new xrep_newbt structure to encapsulate a fake root for
> > creating a staged btree cursor as well as to track all the blocks that
> > we need to reserve in order to build that btree.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/repair.c |  260 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/repair.h |   61 +++++++++++
> >  fs/xfs/scrub/trace.h  |   58 +++++++++++
> >  3 files changed, 379 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > index 588bc054db5c..beebd484c5f3 100644
> > --- a/fs/xfs/scrub/repair.c
> > +++ b/fs/xfs/scrub/repair.c
> > @@ -359,6 +359,266 @@ xrep_init_btblock(
> >  	return 0;
> >  }
> >  
> ...
> > +/* Initialize accounting resources for staging a new inode fork btree. */
> > +void
> > +xrep_newbt_init_inode(
> > +	struct xrep_newbt		*xnr,
> > +	struct xfs_scrub		*sc,
> > +	int				whichfork,
> > +	const struct xfs_owner_info	*oinfo)
> > +{
> > +	memset(xnr, 0, sizeof(struct xrep_newbt));
> > +	xnr->sc = sc;
> > +	xnr->oinfo = *oinfo; /* structure copy */
> > +	xnr->alloc_hint = XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino);
> > +	xnr->resv = XFS_AG_RESV_NONE;
> > +	xnr->ifake.if_fork = kmem_zone_zalloc(xfs_ifork_zone, 0);
> > +	xnr->ifake.if_fork_size = XFS_IFORK_SIZE(sc->ip, whichfork);
> > +	INIT_LIST_HEAD(&xnr->reservations);
> 
> Looks like this could reuse the above function for everything outside of
> the fake root bits.

Ok.

> > +}
> > +
> > +/*
> > + * Initialize accounting resources for staging a new btree.  Callers are
> > + * expected to add their own reservations (and clean them up) manually.
> > + */
> > +void
> > +xrep_newbt_init_bare(
> > +	struct xrep_newbt		*xnr,
> > +	struct xfs_scrub		*sc)
> > +{
> > +	xrep_newbt_init_ag(xnr, sc, &XFS_RMAP_OINFO_ANY_OWNER, NULLFSBLOCK,
> > +			XFS_AG_RESV_NONE);
> > +}
> > +
> > +/* Add a space reservation manually. */
> > +int
> > +xrep_newbt_add_reservation(
> > +	struct xrep_newbt		*xnr,
> > +	xfs_fsblock_t			fsbno,
> > +	xfs_extlen_t			len)
> > +{
> 
> FWIW the "reservation" terminology sounds a bit funny to me. Perhaps
> it's just because I've had log reservation on my mind :P, but something
> that "reserves blocks" as opposed to "adds reservation" might be a bit
> more clear from a naming perspective.

xrep_newbt_reserve_space() ?

I feel that's a little awkward since it's not actually reserving
anything; all it's doing is some accounting work for some space that the
caller already allocated.  But it's probably no worse than the current
name. :)

> > +	struct xrep_newbt_resv	*resv;
> > +
> > +	resv = kmem_alloc(sizeof(struct xrep_newbt_resv), KM_MAYFAIL);
> > +	if (!resv)
> > +		return -ENOMEM;
> > +
> > +	INIT_LIST_HEAD(&resv->list);
> > +	resv->fsbno = fsbno;
> > +	resv->len = len;
> > +	resv->used = 0;
> 
> Is ->used purely a count or does it also serve as a pointer to the next
> "unused" block?

It's a counter, as documented in the struct declaration.

> > +	list_add_tail(&resv->list, &xnr->reservations);
> > +	return 0;
> > +}
> > +
> > +/* Reserve disk space for our new btree. */
> > +int
> > +xrep_newbt_reserve_space(
> > +	struct xrep_newbt	*xnr,
> > +	uint64_t		nr_blocks)
> > +{
> > +	struct xfs_scrub	*sc = xnr->sc;
> > +	xfs_alloctype_t		type;
> > +	xfs_fsblock_t		alloc_hint = xnr->alloc_hint;
> > +	int			error = 0;
> > +
> > +	type = sc->ip ? XFS_ALLOCTYPE_START_BNO : XFS_ALLOCTYPE_NEAR_BNO;
> > +
> 
> So I take it this distinguishes between reconstruction of a bmapbt
> where we can allocate across AGs vs an AG tree..? If so, a one liner
> comment wouldn't hurt here.

Ok.

> > +	while (nr_blocks > 0 && !error) {
> > +		struct xfs_alloc_arg	args = {
> > +			.tp		= sc->tp,
> > +			.mp		= sc->mp,
> > +			.type		= type,
> > +			.fsbno		= alloc_hint,
> > +			.oinfo		= xnr->oinfo,
> > +			.minlen		= 1,
> > +			.maxlen		= nr_blocks,
> > +			.prod		= nr_blocks,
> 
> Why .prod? Is this relevant if .mod isn't set?

Not sure why that's even in there. :/

> > +			.resv		= xnr->resv,
> > +		};
> > +
> > +		error = xfs_alloc_vextent(&args);
> > +		if (error)
> > +			return error;
> > +		if (args.fsbno == NULLFSBLOCK)
> > +			return -ENOSPC;
> > +
> > +		trace_xrep_newbt_reserve_space(sc->mp,
> > +				XFS_FSB_TO_AGNO(sc->mp, args.fsbno),
> > +				XFS_FSB_TO_AGBNO(sc->mp, args.fsbno),
> > +				args.len, xnr->oinfo.oi_owner);
> > +
> > +		error = xrep_newbt_add_reservation(xnr, args.fsbno, args.len);
> > +		if (error)
> > +			break;
> > +
> > +		nr_blocks -= args.len;
> > +		alloc_hint = args.fsbno + args.len - 1;
> > +
> > +		if (sc->ip)
> > +			error = xfs_trans_roll_inode(&sc->tp, sc->ip);
> > +		else
> > +			error = xrep_roll_ag_trans(sc);
> > +	}
> > +
> > +	return error;
> > +}
> > +
> > +/* Free all the accounting info and disk space we reserved for a new btree. */
> > +void
> > +xrep_newbt_destroy(
> > +	struct xrep_newbt	*xnr,
> > +	int			error)
> > +{
> > +	struct xfs_scrub	*sc = xnr->sc;
> > +	struct xrep_newbt_resv	*resv, *n;
> > +
> > +	if (error)
> > +		goto junkit;
> > +
> > +	list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
> > +		/* Free every block we didn't use. */
> > +		resv->fsbno += resv->used;
> > +		resv->len -= resv->used;
> > +		resv->used = 0;
> 
> That answers my count/pointer question. :)

> > +
> > +		if (resv->len > 0) {
> > +			trace_xrep_newbt_unreserve_space(sc->mp,
> > +					XFS_FSB_TO_AGNO(sc->mp, resv->fsbno),
> > +					XFS_FSB_TO_AGBNO(sc->mp, resv->fsbno),
> > +					resv->len, xnr->oinfo.oi_owner);
> > +
> > +			__xfs_bmap_add_free(sc->tp, resv->fsbno, resv->len,
> > +					&xnr->oinfo, true);
> > +		}
> > +
> > +		list_del(&resv->list);
> > +		kmem_free(resv);
> > +	}
> > +
> > +junkit:
> > +	list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
> > +		list_del(&resv->list);
> > +		kmem_free(resv);
> > +	}
> 
> Seems like this could be folded into the above loop by just checking
> error and skipping the free logic appropriately.
> 
> > +
> > +	if (sc->ip) {
> > +		kmem_zone_free(xfs_ifork_zone, xnr->ifake.if_fork);
> > +		xnr->ifake.if_fork = NULL;
> > +	}
> > +}
> > +
> > +/* Feed one of the reserved btree blocks to the bulk loader. */
> > +int
> > +xrep_newbt_alloc_block(
> > +	struct xfs_btree_cur	*cur,
> > +	struct xrep_newbt	*xnr,
> > +	union xfs_btree_ptr	*ptr)
> > +{
> > +	struct xrep_newbt_resv	*resv;
> > +	xfs_fsblock_t		fsb;
> > +
> > +	/*
> > +	 * If last_resv doesn't have a block for us, move forward until we find
> > +	 * one that does (or run out of reservations).
> > +	 */
> > +	if (xnr->last_resv == NULL) {
> > +		list_for_each_entry(resv, &xnr->reservations, list) {
> > +			if (resv->used < resv->len) {
> > +				xnr->last_resv = resv;
> > +				break;
> > +			}
> > +		}
> 
> Not a big deal right now, but it might be worth eventually considering
> something more efficient. For example, perhaps we could rotate depleted
> entries to the end of the list and if we rotate and find nothing in the
> next entry at the head, we know we've run out of space.

Hm, yeah, this part would be much simpler if all we had to do was latch
on to the head element and rotate them to the tail when we're done.

> 
> > +		if (xnr->last_resv == NULL)
> > +			return -ENOSPC;
> > +	} else if (xnr->last_resv->used == xnr->last_resv->len) {
> > +		if (xnr->last_resv->list.next == &xnr->reservations)
> > +			return -ENOSPC;
> > +		xnr->last_resv = list_entry(xnr->last_resv->list.next,
> > +				struct xrep_newbt_resv, list);
> > +	}
> > +
> > +	/* Nab the block. */
> > +	fsb = xnr->last_resv->fsbno + xnr->last_resv->used;
> > +	xnr->last_resv->used++;
> > +
> > +	trace_xrep_newbt_alloc_block(cur->bc_mp,
> > +			XFS_FSB_TO_AGNO(cur->bc_mp, fsb),
> > +			XFS_FSB_TO_AGBNO(cur->bc_mp, fsb),
> > +			xnr->oinfo.oi_owner);
> > +
> > +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> > +		ptr->l = cpu_to_be64(fsb);
> > +	else
> > +		ptr->s = cpu_to_be32(XFS_FSB_TO_AGBNO(cur->bc_mp, fsb));
> > +	return 0;
> > +}
> > +
> ...
> > diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> > index 479cfe38065e..ab6c1199ecc0 100644
> > --- a/fs/xfs/scrub/repair.h
> > +++ b/fs/xfs/scrub/repair.h
> ...
> > @@ -59,6 +63,63 @@ int xrep_agf(struct xfs_scrub *sc);
> >  int xrep_agfl(struct xfs_scrub *sc);
> >  int xrep_agi(struct xfs_scrub *sc);
> >  
> ...
> > +
> > +#define for_each_xrep_newbt_reservation(xnr, resv, n)	\
> > +	list_for_each_entry_safe((resv), (n), &(xnr)->reservations, list)
> 
> This is unused (and seems unnecessary for a simple list).

It's used by the free space rebuilder in the next patch; I suppose I
could move it down.  That said, I've been trying to keep the common code
out of that particular patch so that the repair patches can be merged in
any order.

> ...
> > diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> > index 3362bae28b46..deb177abf652 100644
> > --- a/fs/xfs/scrub/trace.h
> > +++ b/fs/xfs/scrub/trace.h
> > @@ -904,6 +904,64 @@ TRACE_EVENT(xrep_ialloc_insert,
> >  		  __entry->freemask)
> >  )
> >  
> ...
> > +#define DEFINE_NEWBT_EXTENT_EVENT(name) \
> > +DEFINE_EVENT(xrep_newbt_extent_class, name, \
> > +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
> > +		 xfs_agblock_t agbno, xfs_extlen_t len, \
> > +		 int64_t owner), \
> > +	TP_ARGS(mp, agno, agbno, len, owner))
> > +DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_reserve_space);
> > +DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_unreserve_space);
> > +
> > +TRACE_EVENT(xrep_newbt_alloc_block,
> > +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
> > +		 xfs_agblock_t agbno, int64_t owner),
> 
> This could be folded into the above class if we just passed 1 for the
> length, eh?

Er, yes.  Fixed.

--D

> Brian
> 
> > +	TP_ARGS(mp, agno, agbno, owner),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_agnumber_t, agno)
> > +		__field(xfs_agblock_t, agbno)
> > +		__field(int64_t, owner)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = mp->m_super->s_dev;
> > +		__entry->agno = agno;
> > +		__entry->agbno = agbno;
> > +		__entry->owner = owner;
> > +	),
> > +	TP_printk("dev %d:%d agno %u agbno %u owner %lld",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->agno,
> > +		  __entry->agbno,
> > +		  __entry->owner)
> > +);
> > +
> >  #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
> >  
> >  #endif /* _TRACE_XFS_SCRUB_TRACE_H */
> > 
> 
