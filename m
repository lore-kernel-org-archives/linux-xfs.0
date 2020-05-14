Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD848C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 19:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 748B12065C
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 19:23:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GW00yiPc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgENTXx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 15:23:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52906 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbgENTXw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 15:23:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EJLNJc041168;
        Thu, 14 May 2020 19:23:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=k7nLWNbL6ZvsoDIGrl4lQxuY76JeJEiCmUY8ntziUnY=;
 b=GW00yiPciFA4VV49LWDzfKHJOTzEA4bea5YJogkmEYTUj3DrdiVvqtdr6VqKFgEDZXkF
 FGoz2BiIxpzGka1JMjFHBn1cEhTDPmqX5vdfyciwNAeiLC/yPPlO2jBhRHkXBqJ3O76X
 LCUkdYA2eFiYYUrQcCPZN6SoVvy0UeM+mTpQ3k9QaDHvdmRFpXXtjmUz+7T3WorzSFkG
 AxRCzbSJR9yAxbBlTjEQEJmo0mx/zce+X2dXSK1bNGikTknUWWdnD5GS67+Zh9qVsS5/
 dv6PGs0qtALU4qXwKIh64spjyHaiI9mBCIqiYyugh5ti204K+B0BLYgpse6HCiHJO+6X Aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3100xwmn6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 19:23:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EJI67d138850;
        Thu, 14 May 2020 19:23:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3100yhd80u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 19:23:46 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04EJNjoN015539;
        Thu, 14 May 2020 19:23:45 GMT
Received: from localhost (/10.159.232.175)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 12:23:45 -0700
Date:   Thu, 14 May 2020 12:23:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs_repair: unindent phase 5 function
Message-ID: <20200514192344.GF6714@magnolia>
References: <158904190079.984305.707785748675261111.stgit@magnolia>
 <158904191346.984305.10394364390153692151.stgit@magnolia>
 <20200514150950.GB50849@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514150950.GB50849@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=5 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=5 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 11:09:50AM -0400, Brian Foster wrote:
> On Sat, May 09, 2020 at 09:31:53AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Remove the unnecessary indent in phase5_func.  No functional changes.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/phase5.c |  309 +++++++++++++++++++++++++++----------------------------
> >  1 file changed, 154 insertions(+), 155 deletions(-)
> > 
> > 
> > diff --git a/repair/phase5.c b/repair/phase5.c
> > index 17b57448..f3be15de 100644
> > --- a/repair/phase5.c
> > +++ b/repair/phase5.c
> > @@ -2316,201 +2316,200 @@ phase5_func(
> >  	if (verbose)
> >  		do_log(_("        - agno = %d\n"), agno);
> >  
> > -	{
> > -		/*
> > -		 * build up incore bno and bcnt extent btrees
> > -		 */
> > -		num_extents = mk_incore_fstree(mp, agno);
> > +	/*
> > +	 * build up incore bno and bcnt extent btrees
> > +	 */
> > +	num_extents = mk_incore_fstree(mp, agno);
> >  
> >  #ifdef XR_BLD_FREE_TRACE
> > -		fprintf(stderr, "# of bno extents is %d\n",
> > -				count_bno_extents(agno));
> > +	fprintf(stderr, "# of bno extents is %d\n",
> > +			count_bno_extents(agno));
> 
> Some of these multi-line statements (and comments) can be widened to 80
> chars, otherwise looks like a nice cleanup to me.

Yeah.  I think Eric's version of this fixed those things so maybe I'll
just pull his in and rebase...

--D

> Brian
> 
> >  #endif
> >  
> > -		if (num_extents == 0)  {
> > -			/*
> > -			 * XXX - what we probably should do here is pick an
> > -			 * inode for a regular file in the allocation group
> > -			 * that has space allocated and shoot it by traversing
> > -			 * the bmap list and putting all its extents on the
> > -			 * incore freespace trees, clearing the inode,
> > -			 * and clearing the in-use bit in the incore inode
> > -			 * tree.  Then try mk_incore_fstree() again.
> > -			 */
> > -			do_error(_("unable to rebuild AG %u.  "
> > -				  "Not enough free space in on-disk AG.\n"),
> > -				agno);
> > -		}
> > -
> > +	if (num_extents == 0)  {
> >  		/*
> > -		 * ok, now set up the btree cursors for the
> > -		 * on-disk btrees (includs pre-allocating all
> > -		 * required blocks for the trees themselves)
> > +		 * XXX - what we probably should do here is pick an
> > +		 * inode for a regular file in the allocation group
> > +		 * that has space allocated and shoot it by traversing
> > +		 * the bmap list and putting all its extents on the
> > +		 * incore freespace trees, clearing the inode,
> > +		 * and clearing the in-use bit in the incore inode
> > +		 * tree.  Then try mk_incore_fstree() again.
> >  		 */
> > -		init_ino_cursor(mp, agno, &ino_btree_curs, &num_inos,
> > -				&num_free_inos, 0);
> > +		do_error(_("unable to rebuild AG %u.  "
> > +			  "Not enough free space in on-disk AG.\n"),
> > +			agno);
> > +	}
> >  
> > -		if (xfs_sb_version_hasfinobt(&mp->m_sb))
> > -			init_ino_cursor(mp, agno, &fino_btree_curs,
> > -					&finobt_num_inos, &finobt_num_free_inos,
> > -					1);
> > +	/*
> > +	 * ok, now set up the btree cursors for the
> > +	 * on-disk btrees (includs pre-allocating all
> > +	 * required blocks for the trees themselves)
> > +	 */
> > +	init_ino_cursor(mp, agno, &ino_btree_curs, &num_inos,
> > +			&num_free_inos, 0);
> >  
> > -		sb_icount_ag[agno] += num_inos;
> > -		sb_ifree_ag[agno] += num_free_inos;
> > +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> > +		init_ino_cursor(mp, agno, &fino_btree_curs,
> > +				&finobt_num_inos, &finobt_num_free_inos,
> > +				1);
> >  
> > -		/*
> > -		 * Set up the btree cursors for the on-disk rmap btrees,
> > -		 * which includes pre-allocating all required blocks.
> > -		 */
> > -		init_rmapbt_cursor(mp, agno, &rmap_btree_curs);
> > +	sb_icount_ag[agno] += num_inos;
> > +	sb_ifree_ag[agno] += num_free_inos;
> >  
> > -		/*
> > -		 * Set up the btree cursors for the on-disk refcount btrees,
> > -		 * which includes pre-allocating all required blocks.
> > -		 */
> > -		init_refc_cursor(mp, agno, &refcnt_btree_curs);
> > +	/*
> > +	 * Set up the btree cursors for the on-disk rmap btrees,
> > +	 * which includes pre-allocating all required blocks.
> > +	 */
> > +	init_rmapbt_cursor(mp, agno, &rmap_btree_curs);
> >  
> > -		num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
> > +	/*
> > +	 * Set up the btree cursors for the on-disk refcount btrees,
> > +	 * which includes pre-allocating all required blocks.
> > +	 */
> > +	init_refc_cursor(mp, agno, &refcnt_btree_curs);
> > +
> > +	num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
> > +	/*
> > +	 * lose two blocks per AG -- the space tree roots
> > +	 * are counted as allocated since the space trees
> > +	 * always have roots
> > +	 */
> > +	sb_fdblocks_ag[agno] += num_freeblocks - 2;
> > +
> > +	if (num_extents == 0)  {
> >  		/*
> > -		 * lose two blocks per AG -- the space tree roots
> > -		 * are counted as allocated since the space trees
> > -		 * always have roots
> > +		 * XXX - what we probably should do here is pick an
> > +		 * inode for a regular file in the allocation group
> > +		 * that has space allocated and shoot it by traversing
> > +		 * the bmap list and putting all its extents on the
> > +		 * incore freespace trees, clearing the inode,
> > +		 * and clearing the in-use bit in the incore inode
> > +		 * tree.  Then try mk_incore_fstree() again.
> >  		 */
> > -		sb_fdblocks_ag[agno] += num_freeblocks - 2;
> > -
> > -		if (num_extents == 0)  {
> > -			/*
> > -			 * XXX - what we probably should do here is pick an
> > -			 * inode for a regular file in the allocation group
> > -			 * that has space allocated and shoot it by traversing
> > -			 * the bmap list and putting all its extents on the
> > -			 * incore freespace trees, clearing the inode,
> > -			 * and clearing the in-use bit in the incore inode
> > -			 * tree.  Then try mk_incore_fstree() again.
> > -			 */
> > -			do_error(
> > -			_("unable to rebuild AG %u.  No free space.\n"), agno);
> > -		}
> > +		do_error(
> > +		_("unable to rebuild AG %u.  No free space.\n"), agno);
> > +	}
> >  
> >  #ifdef XR_BLD_FREE_TRACE
> > -		fprintf(stderr, "# of bno extents is %d\n", num_extents);
> > +	fprintf(stderr, "# of bno extents is %d\n", num_extents);
> >  #endif
> >  
> > -		/*
> > -		 * track blocks that we might really lose
> > -		 */
> > -		extra_blocks = calculate_freespace_cursor(mp, agno,
> > -					&num_extents, &bno_btree_curs);
> > +	/*
> > +	 * track blocks that we might really lose
> > +	 */
> > +	extra_blocks = calculate_freespace_cursor(mp, agno,
> > +				&num_extents, &bno_btree_curs);
> >  
> > -		/*
> > -		 * freespace btrees live in the "free space" but
> > -		 * the filesystem treats AGFL blocks as allocated
> > -		 * since they aren't described by the freespace trees
> > -		 */
> > +	/*
> > +	 * freespace btrees live in the "free space" but
> > +	 * the filesystem treats AGFL blocks as allocated
> > +	 * since they aren't described by the freespace trees
> > +	 */
> >  
> > -		/*
> > -		 * see if we can fit all the extra blocks into the AGFL
> > -		 */
> > -		extra_blocks = (extra_blocks - libxfs_agfl_size(mp) > 0)
> > -				? extra_blocks - libxfs_agfl_size(mp)
> > -				: 0;
> > +	/*
> > +	 * see if we can fit all the extra blocks into the AGFL
> > +	 */
> > +	extra_blocks = (extra_blocks - libxfs_agfl_size(mp) > 0)
> > +			? extra_blocks - libxfs_agfl_size(mp)
> > +			: 0;
> >  
> > -		if (extra_blocks > 0)
> > -			sb_fdblocks_ag[agno] -= extra_blocks;
> > +	if (extra_blocks > 0)
> > +		sb_fdblocks_ag[agno] -= extra_blocks;
> >  
> > -		bcnt_btree_curs = bno_btree_curs;
> > +	bcnt_btree_curs = bno_btree_curs;
> >  
> > -		bno_btree_curs.owner = XFS_RMAP_OWN_AG;
> > -		bcnt_btree_curs.owner = XFS_RMAP_OWN_AG;
> > -		setup_cursor(mp, agno, &bno_btree_curs);
> > -		setup_cursor(mp, agno, &bcnt_btree_curs);
> > +	bno_btree_curs.owner = XFS_RMAP_OWN_AG;
> > +	bcnt_btree_curs.owner = XFS_RMAP_OWN_AG;
> > +	setup_cursor(mp, agno, &bno_btree_curs);
> > +	setup_cursor(mp, agno, &bcnt_btree_curs);
> >  
> >  #ifdef XR_BLD_FREE_TRACE
> > -		fprintf(stderr, "# of bno extents is %d\n",
> > -				count_bno_extents(agno));
> > -		fprintf(stderr, "# of bcnt extents is %d\n",
> > -				count_bcnt_extents(agno));
> > +	fprintf(stderr, "# of bno extents is %d\n",
> > +			count_bno_extents(agno));
> > +	fprintf(stderr, "# of bcnt extents is %d\n",
> > +			count_bcnt_extents(agno));
> >  #endif
> >  
> > -		/*
> > -		 * now rebuild the freespace trees
> > -		 */
> > -		freeblks1 = build_freespace_tree(mp, agno,
> > -					&bno_btree_curs, XFS_BTNUM_BNO);
> > +	/*
> > +	 * now rebuild the freespace trees
> > +	 */
> > +	freeblks1 = build_freespace_tree(mp, agno,
> > +				&bno_btree_curs, XFS_BTNUM_BNO);
> >  #ifdef XR_BLD_FREE_TRACE
> > -		fprintf(stderr, "# of free blocks == %d\n", freeblks1);
> > +	fprintf(stderr, "# of free blocks == %d\n", freeblks1);
> >  #endif
> > -		write_cursor(&bno_btree_curs);
> > +	write_cursor(&bno_btree_curs);
> >  
> >  #ifdef DEBUG
> > -		freeblks2 = build_freespace_tree(mp, agno,
> > -					&bcnt_btree_curs, XFS_BTNUM_CNT);
> > +	freeblks2 = build_freespace_tree(mp, agno,
> > +				&bcnt_btree_curs, XFS_BTNUM_CNT);
> >  #else
> > -		(void) build_freespace_tree(mp, agno,
> > -					&bcnt_btree_curs, XFS_BTNUM_CNT);
> > +	(void) build_freespace_tree(mp, agno,
> > +				&bcnt_btree_curs, XFS_BTNUM_CNT);
> >  #endif
> > -		write_cursor(&bcnt_btree_curs);
> > +	write_cursor(&bcnt_btree_curs);
> >  
> > -		ASSERT(freeblks1 == freeblks2);
> > +	ASSERT(freeblks1 == freeblks2);
> >  
> > -		if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> > -			build_rmap_tree(mp, agno, &rmap_btree_curs);
> > -			write_cursor(&rmap_btree_curs);
> > -			sb_fdblocks_ag[agno] += (rmap_btree_curs.num_tot_blocks -
> > -					rmap_btree_curs.num_free_blocks) - 1;
> > -		}
> > +	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> > +		build_rmap_tree(mp, agno, &rmap_btree_curs);
> > +		write_cursor(&rmap_btree_curs);
> > +		sb_fdblocks_ag[agno] += (rmap_btree_curs.num_tot_blocks -
> > +				rmap_btree_curs.num_free_blocks) - 1;
> > +	}
> >  
> > -		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> > -			build_refcount_tree(mp, agno, &refcnt_btree_curs);
> > -			write_cursor(&refcnt_btree_curs);
> > -		}
> > +	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> > +		build_refcount_tree(mp, agno, &refcnt_btree_curs);
> > +		write_cursor(&refcnt_btree_curs);
> > +	}
> >  
> > -		/*
> > -		 * set up agf and agfl
> > -		 */
> > -		build_agf_agfl(mp, agno, &bno_btree_curs,
> > -				&bcnt_btree_curs, freeblks1, extra_blocks,
> > -				&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
> > -		/*
> > -		 * build inode allocation tree.
> > -		 */
> > -		build_ino_tree(mp, agno, &ino_btree_curs, XFS_BTNUM_INO,
> > -				&agi_stat);
> > -		write_cursor(&ino_btree_curs);
> > +	/*
> > +	 * set up agf and agfl
> > +	 */
> > +	build_agf_agfl(mp, agno, &bno_btree_curs,
> > +			&bcnt_btree_curs, freeblks1, extra_blocks,
> > +			&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
> > +	/*
> > +	 * build inode allocation tree.
> > +	 */
> > +	build_ino_tree(mp, agno, &ino_btree_curs, XFS_BTNUM_INO,
> > +			&agi_stat);
> > +	write_cursor(&ino_btree_curs);
> >  
> > -		/*
> > -		 * build free inode tree
> > -		 */
> > -		if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
> > -			build_ino_tree(mp, agno, &fino_btree_curs,
> > -					XFS_BTNUM_FINO, NULL);
> > -			write_cursor(&fino_btree_curs);
> > -		}
> > +	/*
> > +	 * build free inode tree
> > +	 */
> > +	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
> > +		build_ino_tree(mp, agno, &fino_btree_curs,
> > +				XFS_BTNUM_FINO, NULL);
> > +		write_cursor(&fino_btree_curs);
> > +	}
> >  
> > -		/* build the agi */
> > -		build_agi(mp, agno, &ino_btree_curs, &fino_btree_curs,
> > -			  &agi_stat);
> > +	/* build the agi */
> > +	build_agi(mp, agno, &ino_btree_curs, &fino_btree_curs,
> > +		  &agi_stat);
> >  
> > -		/*
> > -		 * tear down cursors
> > -		 */
> > -		finish_cursor(&bno_btree_curs);
> > -		finish_cursor(&ino_btree_curs);
> > -		if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> > -			finish_cursor(&rmap_btree_curs);
> > -		if (xfs_sb_version_hasreflink(&mp->m_sb))
> > -			finish_cursor(&refcnt_btree_curs);
> > -		if (xfs_sb_version_hasfinobt(&mp->m_sb))
> > -			finish_cursor(&fino_btree_curs);
> > -		finish_cursor(&bcnt_btree_curs);
> > +	/*
> > +	 * tear down cursors
> > +	 */
> > +	finish_cursor(&bno_btree_curs);
> > +	finish_cursor(&ino_btree_curs);
> > +	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> > +		finish_cursor(&rmap_btree_curs);
> > +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> > +		finish_cursor(&refcnt_btree_curs);
> > +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> > +		finish_cursor(&fino_btree_curs);
> > +	finish_cursor(&bcnt_btree_curs);
> > +
> > +	/*
> > +	 * release the incore per-AG bno/bcnt trees so
> > +	 * the extent nodes can be recycled
> > +	 */
> > +	release_agbno_extent_tree(agno);
> > +	release_agbcnt_extent_tree(agno);
> >  
> > -		/*
> > -		 * release the incore per-AG bno/bcnt trees so
> > -		 * the extent nodes can be recycled
> > -		 */
> > -		release_agbno_extent_tree(agno);
> > -		release_agbcnt_extent_tree(agno);
> > -	}
> >  	PROG_RPT_INC(prog_rpt_done[agno], 1);
> >  }
> >  
> > 
> 
