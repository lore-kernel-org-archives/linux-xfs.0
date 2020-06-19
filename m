Return-Path: <SRS0=O+9a=AA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B112C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 21:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D2C821D81
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 21:36:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gh85Rj+X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgFSVgk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 17:36:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41688 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgFSVgk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jun 2020 17:36:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05JLSC50007853;
        Fri, 19 Jun 2020 21:36:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nfVVEAjusF9Z3pilgAbjPzkP3abNSPP3SxOFGOizuvY=;
 b=gh85Rj+XbR8GgF0FKpX0rQ78szMFmc5uhFZ5X29igl/S/IfaqHkSsZq45jtYXsfHZrqI
 AsMSjIvdqgO7PfIz3UCQ+iPwUIG99FJXwJlQsCgwWQjg1bORnU20Agw6j08G39IsJhgL
 ZULjOEf6eWL9S79LfNHnFoJOqoZcxG899CYqXYumfC2JtVbic1dxxLTQSfRVj25oD3Fe
 98x/7W1Ssgf/fR5DBFh4oyMPxvHIN6Ib73SCV6tw6MhkE5QdWS5pniZuUGiBPmceP92h
 DyOZbWUpHgsr69URSpZdGp0LISh9X3wY6DR5DP0yo7xgi1tBwJDt2qH9RGrJNULRLjJb oQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31q6608umu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 19 Jun 2020 21:36:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05JLS9RQ065000;
        Fri, 19 Jun 2020 21:36:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31q663akvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jun 2020 21:36:34 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05JLaXnc026606;
        Fri, 19 Jun 2020 21:36:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jun 2020 14:36:32 -0700
Date:   Fri, 19 Jun 2020 14:36:31 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs_repair: use bitmap to track blocks lost during
 btree construction
Message-ID: <20200619213631.GD11245@magnolia>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
 <159107209039.315004.11590903544086845302.stgit@magnolia>
 <20200619111047.GB36770@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619111047.GB36770@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006190151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 clxscore=1015 mlxlogscore=999 suspectscore=5 impostorscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006190151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 19, 2020 at 07:10:47AM -0400, Brian Foster wrote:
> On Mon, Jun 01, 2020 at 09:28:10PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use the incore bitmap structure to track blocks that were lost
> > during btree construction.  This makes it somewhat more efficient.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/agbtree.c |   21 ++++++++--------
> >  repair/agbtree.h |    2 +-
> >  repair/phase5.c  |   72 ++++++++++++++++++++++--------------------------------
> >  3 files changed, 41 insertions(+), 54 deletions(-)
> > 
> > 
> ...
> > diff --git a/repair/phase5.c b/repair/phase5.c
> > index 439c1065..446f7ec0 100644
> > --- a/repair/phase5.c
> > +++ b/repair/phase5.c
> ...
> > @@ -211,7 +212,7 @@ build_agf_agfl(
> >  	struct bt_rebuild	*btr_cnt,
> >  	struct bt_rebuild	*btr_rmap,
> >  	struct bt_rebuild	*btr_refc,
> > -	struct xfs_slab		*lost_fsb)
> > +	struct bitmap		*lost_blocks)
> >  {
> 
> Looks like another case of an unused parameter here, otherwise looks
> good:

Heh, yep, this could be removed all the way back in "xfs_repair: rebuild
free space btrees with bulk loader" so I'll go do it there.

Thanks for reviewing!

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  	struct extent_tree_node	*ext_ptr;
> >  	struct xfs_buf		*agf_buf, *agfl_buf;
> > @@ -428,7 +429,7 @@ static void
> >  phase5_func(
> >  	struct xfs_mount	*mp,
> >  	xfs_agnumber_t		agno,
> > -	struct xfs_slab		*lost_fsb)
> > +	struct bitmap		*lost_blocks)
> >  {
> >  	struct repair_ctx	sc = { .mp = mp, };
> >  	struct bt_rebuild	btr_bno;
> > @@ -543,7 +544,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> >  	 * set up agf and agfl
> >  	 */
> >  	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &btr_rmap, &btr_refc,
> > -			lost_fsb);
> > +			lost_blocks);
> >  
> >  	build_inode_btrees(&sc, agno, &btr_ino, &btr_fino);
> >  
> > @@ -553,15 +554,15 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> >  	/*
> >  	 * tear down cursors
> >  	 */
> > -	finish_rebuild(mp, &btr_bno, lost_fsb);
> > -	finish_rebuild(mp, &btr_cnt, lost_fsb);
> > -	finish_rebuild(mp, &btr_ino, lost_fsb);
> > +	finish_rebuild(mp, &btr_bno, lost_blocks);
> > +	finish_rebuild(mp, &btr_cnt, lost_blocks);
> > +	finish_rebuild(mp, &btr_ino, lost_blocks);
> >  	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> > -		finish_rebuild(mp, &btr_fino, lost_fsb);
> > +		finish_rebuild(mp, &btr_fino, lost_blocks);
> >  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> > -		finish_rebuild(mp, &btr_rmap, lost_fsb);
> > +		finish_rebuild(mp, &btr_rmap, lost_blocks);
> >  	if (xfs_sb_version_hasreflink(&mp->m_sb))
> > -		finish_rebuild(mp, &btr_refc, lost_fsb);
> > +		finish_rebuild(mp, &btr_refc, lost_blocks);
> >  
> >  	/*
> >  	 * release the incore per-AG bno/bcnt trees so the extent nodes
> > @@ -572,48 +573,33 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> >  	PROG_RPT_INC(prog_rpt_done[agno], 1);
> >  }
> >  
> > -/* Inject lost blocks back into the filesystem. */
> > +/* Inject this unused space back into the filesystem. */
> >  static int
> > -inject_lost_blocks(
> > -	struct xfs_mount	*mp,
> > -	struct xfs_slab		*lost_fsbs)
> > +inject_lost_extent(
> > +	uint64_t		start,
> > +	uint64_t		length,
> > +	void			*arg)
> >  {
> > -	struct xfs_trans	*tp = NULL;
> > -	struct xfs_slab_cursor	*cur = NULL;
> > -	xfs_fsblock_t		*fsb;
> > +	struct xfs_mount	*mp = arg;
> > +	struct xfs_trans	*tp;
> >  	int			error;
> >  
> > -	error = init_slab_cursor(lost_fsbs, NULL, &cur);
> > +	error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
> >  	if (error)
> >  		return error;
> >  
> > -	while ((fsb = pop_slab_cursor(cur)) != NULL) {
> > -		error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
> > -		if (error)
> > -			goto out_cancel;
> > -
> > -		error = -libxfs_free_extent(tp, *fsb, 1,
> > -				&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_NONE);
> > -		if (error)
> > -			goto out_cancel;
> > -
> > -		error = -libxfs_trans_commit(tp);
> > -		if (error)
> > -			goto out_cancel;
> > -		tp = NULL;
> > -	}
> > +	error = -libxfs_free_extent(tp, start, length,
> > +			&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_NONE);
> > +	if (error)
> > +		return error;
> >  
> > -out_cancel:
> > -	if (tp)
> > -		libxfs_trans_cancel(tp);
> > -	free_slab_cursor(&cur);
> > -	return error;
> > +	return -libxfs_trans_commit(tp);
> >  }
> >  
> >  void
> >  phase5(xfs_mount_t *mp)
> >  {
> > -	struct xfs_slab		*lost_fsb;
> > +	struct bitmap		*lost_blocks = NULL;
> >  	xfs_agnumber_t		agno;
> >  	int			error;
> >  
> > @@ -656,12 +642,12 @@ phase5(xfs_mount_t *mp)
> >  	if (sb_fdblocks_ag == NULL)
> >  		do_error(_("cannot alloc sb_fdblocks_ag buffers\n"));
> >  
> > -	error = init_slab(&lost_fsb, sizeof(xfs_fsblock_t));
> > +	error = bitmap_alloc(&lost_blocks);
> >  	if (error)
> > -		do_error(_("cannot alloc lost block slab\n"));
> > +		do_error(_("cannot alloc lost block bitmap\n"));
> >  
> >  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
> > -		phase5_func(mp, agno, lost_fsb);
> > +		phase5_func(mp, agno, lost_blocks);
> >  
> >  	print_final_rpt();
> >  
> > @@ -704,10 +690,10 @@ _("unable to add AG %u reverse-mapping data to btree.\n"), agno);
> >  	 * Put blocks that were unnecessarily reserved for btree
> >  	 * reconstruction back into the filesystem free space data.
> >  	 */
> > -	error = inject_lost_blocks(mp, lost_fsb);
> > +	error = bitmap_iterate(lost_blocks, inject_lost_extent, mp);
> >  	if (error)
> >  		do_error(_("Unable to reinsert lost blocks into filesystem.\n"));
> > -	free_slab(&lost_fsb);
> > +	bitmap_free(&lost_blocks);
> >  
> >  	bad_ino_btree = 0;
> >  
> > 
> 
