Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF85CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 16:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16E3820B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 16:56:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S4cgQuNQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbfJVQ4c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 12:56:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59430 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbfJVQ4c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 12:56:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MGsLkR012214;
        Tue, 22 Oct 2019 16:56:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=1yt1Earz6yop/G01Xj3BqWzJsCs6C+Wg1HGZjpM02EA=;
 b=S4cgQuNQtDgVNWPfYfMCnimg+I/8+IOEgSFWaJa0Bmto97yg/C92+DylBo2zoH9ikhgF
 F4582PPeW6S+X/j1Dbs56NQl55Ckwp//Auit10qKnhV9x5wYiOMIkbCsWXApvyIvXlze
 BiN8xPZL69mdcDGKYVM6JLp5rsVYV/5I1pEOF9q94hm/zscNV+BvUvCx7onhD8smzv+0
 7bykHI28TL3nhSbPWo718yVe7nAwi4QzLD5WLEmWP980PLb3VdF0RhSBvgW7s4IWtvkj
 A4hS4SACgSkYekiU81VIxAvEilER6vDRYaTXpEZYPLzK+rg6xpxSA0j4pZZLBNQU7LKT fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vqswtg7cy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 16:56:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MGn3Lg181864;
        Tue, 22 Oct 2019 16:56:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vsx233y45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 16:56:19 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MGuIE5005077;
        Tue, 22 Oct 2019 16:56:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 09:56:17 -0700
Date:   Tue, 22 Oct 2019 09:56:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: remove the for_each_xbitmap_ helpers
Message-ID: <20191022165617.GN913374@magnolia>
References: <157063973592.2913318.8246472567175058111.stgit@magnolia>
 <157063976280.2913318.2140616655357544513.stgit@magnolia>
 <20191022133518.GB51627@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022133518.GB51627@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 22, 2019 at 09:35:18AM -0400, Brian Foster wrote:
> On Wed, Oct 09, 2019 at 09:49:22AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Remove the for_each_xbitmap_ macros in favor of proper iterator
> > functions.  We'll soon be switching this data structure over to an
> > interval tree implementation, which means that we can't allow callers to
> > modify the bitmap during iteration without telling us.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/agheader_repair.c |   73 ++++++++++++++++++++++++----------------
> >  fs/xfs/scrub/bitmap.c          |   59 ++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/bitmap.h          |   22 ++++++++----
> >  fs/xfs/scrub/repair.c          |   60 +++++++++++++++++----------------
> >  4 files changed, 148 insertions(+), 66 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
> > index 900646b72de1..27fde5b4a753 100644
> > --- a/fs/xfs/scrub/bitmap.h
> > +++ b/fs/xfs/scrub/bitmap.h
> ...
> > @@ -34,4 +27,19 @@ int xbitmap_set_btblocks(struct xbitmap *bitmap,
> >  		struct xfs_btree_cur *cur);
> >  uint64_t xbitmap_hweight(struct xbitmap *bitmap);
> >  
> > +/*
> > + * Return codes for the bitmap iterator functions are 0 to continue iterating,
> > + * and non-zero to stop iterating.  Any non-zero value will be passed up to the
> > + * iteration caller.  The special value -ECANCELED can be used to stop
> > + * iteration, because neither bitmap iterator ever generates that error code on
> > + * its own.
> > + */
> > +typedef int (*xbitmap_walk_run_fn)(uint64_t start, uint64_t len, void *priv);
> > +int xbitmap_iter_set(struct xbitmap *bitmap, xbitmap_walk_run_fn fn,
> > +		void *priv);
> > +
> > +typedef int (*xbitmap_walk_bit_fn)(uint64_t bit, void *priv);
> > +int xbitmap_iter_set_bits(struct xbitmap *bitmap, xbitmap_walk_bit_fn fn,
> > +		void *priv);
> > +
> 
> Somewhat of a nit, but I read "set" as a verb in the above function
> names which tends to confuse me over what these functions do (i.e.
> iterate bits, not set bits). Could we call them something a bit more
> neutral, like xbitmap[_bit]_iter() perhaps? That aside the rest of the
> patch looks Ok to me.

Ok, will rename them.

--D

> Brian
> 
> >  #endif	/* __XFS_SCRUB_BITMAP_H__ */
> > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > index d41da4c44f10..588bc054db5c 100644
> > --- a/fs/xfs/scrub/repair.c
> > +++ b/fs/xfs/scrub/repair.c
> > @@ -507,15 +507,21 @@ xrep_reap_invalidate_block(
> >  	xfs_trans_binval(sc->tp, bp);
> >  }
> >  
> > +struct xrep_reap_block {
> > +	struct xfs_scrub		*sc;
> > +	const struct xfs_owner_info	*oinfo;
> > +	enum xfs_ag_resv_type		resv;
> > +	unsigned int			deferred;
> > +};
> > +
> >  /* Dispose of a single block. */
> >  STATIC int
> >  xrep_reap_block(
> > -	struct xfs_scrub		*sc,
> > -	xfs_fsblock_t			fsbno,
> > -	const struct xfs_owner_info	*oinfo,
> > -	enum xfs_ag_resv_type		resv,
> > -	unsigned int			*deferred)
> > +	uint64_t			fsbno,
> > +	void				*priv)
> >  {
> > +	struct xrep_reap_block		*rb = priv;
> > +	struct xfs_scrub		*sc = rb->sc;
> >  	struct xfs_btree_cur		*cur;
> >  	struct xfs_buf			*agf_bp = NULL;
> >  	xfs_agnumber_t			agno;
> > @@ -527,6 +533,10 @@ xrep_reap_block(
> >  	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
> >  	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
> >  
> > +	ASSERT(sc->ip != NULL || agno == sc->sa.agno);
> > +
> > +	trace_xrep_dispose_btree_extent(sc->mp, agno, agbno, 1);
> > +
> >  	/*
> >  	 * If we are repairing per-inode metadata, we need to read in the AGF
> >  	 * buffer.  Otherwise, we're repairing a per-AG structure, so reuse
> > @@ -544,7 +554,8 @@ xrep_reap_block(
> >  	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, agno);
> >  
> >  	/* Can we find any other rmappings? */
> > -	error = xfs_rmap_has_other_keys(cur, agbno, 1, oinfo, &has_other_rmap);
> > +	error = xfs_rmap_has_other_keys(cur, agbno, 1, rb->oinfo,
> > +			&has_other_rmap);
> >  	xfs_btree_del_cursor(cur, error);
> >  	if (error)
> >  		goto out_free;
> > @@ -563,8 +574,9 @@ xrep_reap_block(
> >  	 * to run xfs_repair.
> >  	 */
> >  	if (has_other_rmap) {
> > -		error = xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1, oinfo);
> > -	} else if (resv == XFS_AG_RESV_AGFL) {
> > +		error = xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1,
> > +				rb->oinfo);
> > +	} else if (rb->resv == XFS_AG_RESV_AGFL) {
> >  		xrep_reap_invalidate_block(sc, fsbno);
> >  		error = xrep_put_freelist(sc, agbno);
> >  	} else {
> > @@ -576,16 +588,16 @@ xrep_reap_block(
> >  		 * reservation.
> >  		 */
> >  		xrep_reap_invalidate_block(sc, fsbno);
> > -		__xfs_bmap_add_free(sc->tp, fsbno, 1, oinfo, true);
> > -		(*deferred)++;
> > -		need_roll = *deferred > 100;
> > +		__xfs_bmap_add_free(sc->tp, fsbno, 1, rb->oinfo, true);
> > +		rb->deferred++;
> > +		need_roll = rb->deferred > 100;
> >  	}
> >  	if (agf_bp != sc->sa.agf_bp)
> >  		xfs_trans_brelse(sc->tp, agf_bp);
> >  	if (error || !need_roll)
> >  		return error;
> >  
> > -	*deferred = 0;
> > +	rb->deferred = 0;
> >  	if (sc->ip)
> >  		return xfs_trans_roll_inode(&sc->tp, sc->ip);
> >  	return xrep_roll_ag_trans(sc);
> > @@ -604,27 +616,17 @@ xrep_reap_extents(
> >  	const struct xfs_owner_info	*oinfo,
> >  	enum xfs_ag_resv_type		type)
> >  {
> > -	struct xbitmap_range		*bmr;
> > -	struct xbitmap_range		*n;
> > -	xfs_fsblock_t			fsbno;
> > -	unsigned int			deferred = 0;
> > +	struct xrep_reap_block		rb = {
> > +		.sc			= sc,
> > +		.oinfo			= oinfo,
> > +		.resv			= type,
> > +	};
> >  	int				error = 0;
> >  
> >  	ASSERT(xfs_sb_version_hasrmapbt(&sc->mp->m_sb));
> >  
> > -	for_each_xbitmap_block(fsbno, bmr, n, bitmap) {
> > -		ASSERT(sc->ip != NULL ||
> > -		       XFS_FSB_TO_AGNO(sc->mp, fsbno) == sc->sa.agno);
> > -		trace_xrep_dispose_btree_extent(sc->mp,
> > -				XFS_FSB_TO_AGNO(sc->mp, fsbno),
> > -				XFS_FSB_TO_AGBNO(sc->mp, fsbno), 1);
> > -
> > -		error = xrep_reap_block(sc, fsbno, oinfo, type, &deferred);
> > -		if (error)
> > -			break;
> > -	}
> > -
> > -	if (error || deferred == 0)
> > +	error = xbitmap_iter_set_bits(bitmap, xrep_reap_block, &rb);
> > +	if (error || rb.deferred == 0)
> >  		return error;
> >  
> >  	if (sc->ip)
> > 
> 
