Return-Path: <SRS0=/boU=7L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8268EC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 29 May 2020 22:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5702F208E4
	for <linux-xfs@archiver.kernel.org>; Fri, 29 May 2020 22:19:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W14Qhbtr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgE2WT6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 May 2020 18:19:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48752 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgE2WT6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 May 2020 18:19:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04TMILQd025150;
        Fri, 29 May 2020 22:19:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iSSBLIa+sDSfoGYiuEEUd4ebZVTkKch+pkRr7b+tXtY=;
 b=W14Qhbtrv24qY4mz9YAxD9WfHBLBC02TrG7phV+pvpWNpN4B3B4qXtY8E1WyBIn/G1yJ
 v7JZRikRWNRptbNIM+OaN/N/o9uG7QmxENCbtkY3VM0wMYDosPogmA18DB0XB0bnYujp
 hp4H6ivIOvQPoiZqh6RmQIY/qvCEZ6TfHuSoFyh7DgZdJEaLL+/0/sx0GXqbNDWdIvBY
 N7RUKvpJvKzXEJ4+fQzQVx1LjLT3XZFZz2uZsH8HLkP46pu834rFnYBXoF4YTTFAbL2v
 LTdpFWgK1FltrjfUfSyHvIvOvSWReel2b/dIQrsgF3rqyq08ysABLB+bRNKUoozM9yBU 5g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 318xe1vptv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 29 May 2020 22:19:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04TMJBGN011459;
        Fri, 29 May 2020 22:19:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 317ddv1mt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 May 2020 22:19:43 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04TMJhtG028844;
        Fri, 29 May 2020 22:19:43 GMT
Received: from localhost (/10.159.144.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 May 2020 15:19:42 -0700
Date:   Fri, 29 May 2020 15:19:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs_repair: track blocks lost during btree
 construction via extents
Message-ID: <20200529221942.GV8230@magnolia>
References: <158993944270.983175.4120094597556662259.stgit@magnolia>
 <158993950078.983175.14943057067035503330.stgit@magnolia>
 <20200528170012.GE17794@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528170012.GE17794@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=5 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 cotscore=-2147483648 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=5 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 28, 2020 at 01:00:12PM -0400, Brian Foster wrote:
> On Tue, May 19, 2020 at 06:51:40PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use extent records (not just raw fsbs) to track blocks that were lost
> > during btree construction.  This makes it somewhat more efficient.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/phase5.c |   61 ++++++++++++++++++++++++++++++++-----------------------
> >  1 file changed, 35 insertions(+), 26 deletions(-)
> > 
> > 
> > diff --git a/repair/phase5.c b/repair/phase5.c
> > index 72c6908a..22007275 100644
> > --- a/repair/phase5.c
> > +++ b/repair/phase5.c
> > @@ -45,6 +45,12 @@ struct bt_rebuild {
> >  	};
> >  };
> >  
> > +struct lost_fsb {
> > +	xfs_fsblock_t		fsbno;
> > +	xfs_extlen_t		len;
> > +};
> > +
> 
> Looks reasonable at a glance, but could we call the above structure an
> extent and rename lost_fsbs to lost_extents or some such?

Ok.  I suspect this ought to be converted to libfrog/bitmap from the
slab cursors and whatnot that it uses now.

--D

> Brian
> 
> > +
> >  /*
> >   * extra metadata for the agi
> >   */
> > @@ -314,21 +320,24 @@ static void
> >  finish_rebuild(
> >  	struct xfs_mount	*mp,
> >  	struct bt_rebuild	*btr,
> > -	struct xfs_slab		*lost_fsb)
> > +	struct xfs_slab		*lost_fsbs)
> >  {
> >  	struct xrep_newbt_resv	*resv, *n;
> >  
> >  	for_each_xrep_newbt_reservation(&btr->newbt, resv, n) {
> > -		while (resv->used < resv->len) {
> > -			xfs_fsblock_t	fsb = resv->fsbno + resv->used;
> > -			int		error;
> > +		struct lost_fsb	lost;
> > +		int		error;
> >  
> > -			error = slab_add(lost_fsb, &fsb);
> > -			if (error)
> > -				do_error(
> > +		if (resv->used == resv->len)
> > +			continue;
> > +
> > +		lost.fsbno = resv->fsbno + resv->used;
> > +		lost.len = resv->len - resv->used;
> > +		error = slab_add(lost_fsbs, &lost);
> > +		if (error)
> > +			do_error(
> >  _("Insufficient memory saving lost blocks.\n"));
> > -			resv->used++;
> > -		}
> > +		resv->used = resv->len;
> >  	}
> >  
> >  	xrep_newbt_destroy(&btr->newbt, 0);
> > @@ -1036,7 +1045,7 @@ build_agf_agfl(
> >  	int			lostblocks,	/* # blocks that will be lost */
> >  	struct bt_rebuild	*btr_rmap,
> >  	struct bt_rebuild	*btr_refc,
> > -	struct xfs_slab		*lost_fsb)
> > +	struct xfs_slab		*lost_fsbs)
> >  {
> >  	struct extent_tree_node	*ext_ptr;
> >  	struct xfs_buf		*agf_buf, *agfl_buf;
> > @@ -1253,7 +1262,7 @@ static void
> >  phase5_func(
> >  	struct xfs_mount	*mp,
> >  	xfs_agnumber_t		agno,
> > -	struct xfs_slab		*lost_fsb)
> > +	struct xfs_slab		*lost_fsbs)
> >  {
> >  	struct repair_ctx	sc = { .mp = mp, };
> >  	struct agi_stat		agi_stat = {0,};
> > @@ -1372,7 +1381,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> >  	 * set up agf and agfl
> >  	 */
> >  	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, freeblks1, extra_blocks,
> > -			&btr_rmap, &btr_refc, lost_fsb);
> > +			&btr_rmap, &btr_refc, lost_fsbs);
> >  
> >  	/*
> >  	 * build inode allocation trees.
> > @@ -1387,15 +1396,15 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> >  	/*
> >  	 * tear down cursors
> >  	 */
> > -	finish_rebuild(mp, &btr_bno, lost_fsb);
> > -	finish_rebuild(mp, &btr_cnt, lost_fsb);
> > -	finish_rebuild(mp, &btr_ino, lost_fsb);
> > +	finish_rebuild(mp, &btr_bno, lost_fsbs);
> > +	finish_rebuild(mp, &btr_cnt, lost_fsbs);
> > +	finish_rebuild(mp, &btr_ino, lost_fsbs);
> >  	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> > -		finish_rebuild(mp, &btr_fino, lost_fsb);
> > +		finish_rebuild(mp, &btr_fino, lost_fsbs);
> >  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> > -		finish_rebuild(mp, &btr_rmap, lost_fsb);
> > +		finish_rebuild(mp, &btr_rmap, lost_fsbs);
> >  	if (xfs_sb_version_hasreflink(&mp->m_sb))
> > -		finish_rebuild(mp, &btr_refc, lost_fsb);
> > +		finish_rebuild(mp, &btr_refc, lost_fsbs);
> >  
> >  	/*
> >  	 * release the incore per-AG bno/bcnt trees so the extent nodes
> > @@ -1414,19 +1423,19 @@ inject_lost_blocks(
> >  {
> >  	struct xfs_trans	*tp = NULL;
> >  	struct xfs_slab_cursor	*cur = NULL;
> > -	xfs_fsblock_t		*fsb;
> > +	struct lost_fsb		*lost;
> >  	int			error;
> >  
> >  	error = init_slab_cursor(lost_fsbs, NULL, &cur);
> >  	if (error)
> >  		return error;
> >  
> > -	while ((fsb = pop_slab_cursor(cur)) != NULL) {
> > +	while ((lost = pop_slab_cursor(cur)) != NULL) {
> >  		error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
> >  		if (error)
> >  			goto out_cancel;
> >  
> > -		error = -libxfs_free_extent(tp, *fsb, 1,
> > +		error = -libxfs_free_extent(tp, lost->fsbno, lost->len,
> >  				&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_NONE);
> >  		if (error)
> >  			goto out_cancel;
> > @@ -1447,7 +1456,7 @@ inject_lost_blocks(
> >  void
> >  phase5(xfs_mount_t *mp)
> >  {
> > -	struct xfs_slab		*lost_fsb;
> > +	struct xfs_slab		*lost_fsbs;
> >  	xfs_agnumber_t		agno;
> >  	int			error;
> >  
> > @@ -1490,12 +1499,12 @@ phase5(xfs_mount_t *mp)
> >  	if (sb_fdblocks_ag == NULL)
> >  		do_error(_("cannot alloc sb_fdblocks_ag buffers\n"));
> >  
> > -	error = init_slab(&lost_fsb, sizeof(xfs_fsblock_t));
> > +	error = init_slab(&lost_fsbs, sizeof(struct lost_fsb));
> >  	if (error)
> >  		do_error(_("cannot alloc lost block slab\n"));
> >  
> >  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
> > -		phase5_func(mp, agno, lost_fsb);
> > +		phase5_func(mp, agno, lost_fsbs);
> >  
> >  	print_final_rpt();
> >  
> > @@ -1538,10 +1547,10 @@ _("unable to add AG %u reverse-mapping data to btree.\n"), agno);
> >  	 * Put blocks that were unnecessarily reserved for btree
> >  	 * reconstruction back into the filesystem free space data.
> >  	 */
> > -	error = inject_lost_blocks(mp, lost_fsb);
> > +	error = inject_lost_blocks(mp, lost_fsbs);
> >  	if (error)
> >  		do_error(_("Unable to reinsert lost blocks into filesystem.\n"));
> > -	free_slab(&lost_fsb);
> > +	free_slab(&lost_fsbs);
> >  
> >  	bad_ino_btree = 0;
> >  
> > 
> 
