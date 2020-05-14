Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37030C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 20:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 054A82065C
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 20:47:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zvKoTNx7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgENUrS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 16:47:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35010 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgENUrS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 16:47:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EKhW0D006672;
        Thu, 14 May 2020 20:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=q/z61LAKpSB4dqW/vYjW++AWzPFgoIlvaQ9KRKSS7xc=;
 b=zvKoTNx7GsyvGh0SVsFC56s5t6vdtNGxAEh83CmkvKYqF6fig+DEKKTcpNQpSEVXFord
 yM6IGYxtX2RxvwdV2XP7DViouRmg9wg9YD5aBcWNP8wTIELsDt4LG4HCOPSEBE4l+HJu
 2wcgrP6Idq5dEUxBIPQpEjNm7IoZTJNTP97jM9fV7NPvE2zTxvjQ5PZB681z1AAIjScp
 fYxkzw+2vjDa2NAP7KiJgUhLMPIh/AQ4yZVl/m0ErYKM07p9t6yz6TuiFhnlrW8zUSn/
 vkG+XhbIHOyyC7M+vy03Yh4ke0OIWG4enx4eG56OlQ2/RD7XimcicZKir/8fd1RKQrDH 2g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3100xwn2j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 20:47:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EKc5bv048651;
        Thu, 14 May 2020 20:45:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3100ydcbmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 20:45:14 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04EKjDPl022780;
        Thu, 14 May 2020 20:45:13 GMT
Received: from localhost (/10.159.232.175)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 13:45:13 -0700
Date:   Thu, 14 May 2020 13:45:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: remove gratuitous code block in phase5
Message-ID: <20200514204512.GI6714@magnolia>
References: <1dc0bb1a-ce6f-5e22-77ff-b8bb408a3e03@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dc0bb1a-ce6f-5e22-77ff-b8bb408a3e03@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=5 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=5 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 11, 2020 at 02:20:56PM -0500, Eric Sandeen wrote:
> A commit back in 2008 removed a "for" loop ahead of this code block, but
> left the indented code block in place. Remove it for clarity and reflow
> comments & lines as needed.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Uh, so you reflowed all the comments and whatnot whereas I didn't, so:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> (Probably easiest to review this by applying it and then doing 
> git show -w $COMMIT to see only the non-whitespace differences)
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 677297fe..84c05a13 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -2313,201 +2313,186 @@ phase5_func(
>  	if (verbose)
>  		do_log(_("        - agno = %d\n"), agno);
>  
> -	{
> -		/*
> -		 * build up incore bno and bcnt extent btrees
> -		 */
> -		num_extents = mk_incore_fstree(mp, agno);
> +	/*
> +	 * build up incore bno and bcnt extent btrees
> +	 */
> +	num_extents = mk_incore_fstree(mp, agno);
>  
>  #ifdef XR_BLD_FREE_TRACE
> -		fprintf(stderr, "# of bno extents is %d\n",
> -				count_bno_extents(agno));
> +	fprintf(stderr, "# of bno extents is %d\n", count_bno_extents(agno));
>  #endif
>  
> -		if (num_extents == 0)  {
> -			/*
> -			 * XXX - what we probably should do here is pick an
> -			 * inode for a regular file in the allocation group
> -			 * that has space allocated and shoot it by traversing
> -			 * the bmap list and putting all its extents on the
> -			 * incore freespace trees, clearing the inode,
> -			 * and clearing the in-use bit in the incore inode
> -			 * tree.  Then try mk_incore_fstree() again.
> -			 */
> -			do_error(_("unable to rebuild AG %u.  "
> -				  "Not enough free space in on-disk AG.\n"),
> -				agno);
> -		}
> -
> +	if (num_extents == 0)  {
>  		/*
> -		 * ok, now set up the btree cursors for the
> -		 * on-disk btrees (includs pre-allocating all
> -		 * required blocks for the trees themselves)
> +		 * XXX - what we probably should do here is pick an inode for
> +		 * a regular file in the allocation group that has space
> +		 * allocated and shoot it by traversing the bmap list and
> +		 * putting all its extents on the incore freespace trees,
> +		 * clearing the inode, and clearing the in-use bit in the
> +		 * incore inode tree.  Then try mk_incore_fstree() again.
>  		 */
> -		init_ino_cursor(mp, agno, &ino_btree_curs, &num_inos,
> -				&num_free_inos, 0);
> +		do_error(
> +_("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
> +			agno);
> +	}
>  
> -		if (xfs_sb_version_hasfinobt(&mp->m_sb))
> -			init_ino_cursor(mp, agno, &fino_btree_curs,
> -					&finobt_num_inos, &finobt_num_free_inos,
> -					1);
> +	/*
> +	 * ok, now set up the btree cursors for the on-disk btrees (includes
> +	 * pre-allocating all required blocks for the trees themselves)
> +	 */
> +	init_ino_cursor(mp, agno, &ino_btree_curs, &num_inos,
> +			&num_free_inos, 0);
>  
> -		sb_icount_ag[agno] += num_inos;
> -		sb_ifree_ag[agno] += num_free_inos;
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> +		init_ino_cursor(mp, agno, &fino_btree_curs, &finobt_num_inos,
> +				&finobt_num_free_inos, 1);
>  
> -		/*
> -		 * Set up the btree cursors for the on-disk rmap btrees,
> -		 * which includes pre-allocating all required blocks.
> -		 */
> -		init_rmapbt_cursor(mp, agno, &rmap_btree_curs);
> +	sb_icount_ag[agno] += num_inos;
> +	sb_ifree_ag[agno] += num_free_inos;
>  
> -		/*
> -		 * Set up the btree cursors for the on-disk refcount btrees,
> -		 * which includes pre-allocating all required blocks.
> -		 */
> -		init_refc_cursor(mp, agno, &refcnt_btree_curs);
> +	/*
> +	 * Set up the btree cursors for the on-disk rmap btrees, which includes
> +	 * pre-allocating all required blocks.
> +	 */
> +	init_rmapbt_cursor(mp, agno, &rmap_btree_curs);
>  
> -		num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
> +	/*
> +	 * Set up the btree cursors for the on-disk refcount btrees,
> +	 * which includes pre-allocating all required blocks.
> +	 */
> +	init_refc_cursor(mp, agno, &refcnt_btree_curs);
> +
> +	num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
> +	/*
> +	 * lose two blocks per AG -- the space tree roots are counted as
> +	 * allocated since the space trees always have roots
> +	 */
> +	sb_fdblocks_ag[agno] += num_freeblocks - 2;
> +
> +	if (num_extents == 0)  {
>  		/*
> -		 * lose two blocks per AG -- the space tree roots
> -		 * are counted as allocated since the space trees
> -		 * always have roots
> +		 * XXX - what we probably should do here is pick an inode for
> +		 * a regular file in the allocation group that has space
> +		 * allocated and shoot it by traversing the bmap list and
> +		 * putting all its extents on the incore freespace trees,
> +		 * clearing the inode, and clearing the in-use bit in the
> +		 * incore inode tree.  Then try mk_incore_fstree() again.
>  		 */
> -		sb_fdblocks_ag[agno] += num_freeblocks - 2;
> -
> -		if (num_extents == 0)  {
> -			/*
> -			 * XXX - what we probably should do here is pick an
> -			 * inode for a regular file in the allocation group
> -			 * that has space allocated and shoot it by traversing
> -			 * the bmap list and putting all its extents on the
> -			 * incore freespace trees, clearing the inode,
> -			 * and clearing the in-use bit in the incore inode
> -			 * tree.  Then try mk_incore_fstree() again.
> -			 */
> -			do_error(
> -			_("unable to rebuild AG %u.  No free space.\n"), agno);
> -		}
> +		do_error(_("unable to rebuild AG %u.  No free space.\n"), agno);
> +	}
>  
>  #ifdef XR_BLD_FREE_TRACE
> -		fprintf(stderr, "# of bno extents is %d\n", num_extents);
> +	fprintf(stderr, "# of bno extents is %d\n", num_extents);
>  #endif
>  
> -		/*
> -		 * track blocks that we might really lose
> -		 */
> -		extra_blocks = calculate_freespace_cursor(mp, agno,
> -					&num_extents, &bno_btree_curs);
> +	/*
> +	 * track blocks that we might really lose
> +	 */
> +	extra_blocks = calculate_freespace_cursor(mp, agno,
> +				&num_extents, &bno_btree_curs);
>  
> -		/*
> -		 * freespace btrees live in the "free space" but
> -		 * the filesystem treats AGFL blocks as allocated
> -		 * since they aren't described by the freespace trees
> -		 */
> +	/*
> +	 * freespace btrees live in the "free space" but the filesystem treats
> +	 * AGFL blocks as allocated since they aren't described by the
> +	 * freespace trees
> +	 */
>  
> -		/*
> -		 * see if we can fit all the extra blocks into the AGFL
> -		 */
> -		extra_blocks = (extra_blocks - libxfs_agfl_size(mp) > 0)
> -				? extra_blocks - libxfs_agfl_size(mp)
> -				: 0;
> +	/*
> +	 * see if we can fit all the extra blocks into the AGFL
> +	 */
> +	extra_blocks = (extra_blocks - libxfs_agfl_size(mp) > 0) ?
> +			extra_blocks - libxfs_agfl_size(mp) : 0;
>  
> -		if (extra_blocks > 0)
> -			sb_fdblocks_ag[agno] -= extra_blocks;
> +	if (extra_blocks > 0)
> +		sb_fdblocks_ag[agno] -= extra_blocks;
>  
> -		bcnt_btree_curs = bno_btree_curs;
> +	bcnt_btree_curs = bno_btree_curs;
>  
> -		bno_btree_curs.owner = XFS_RMAP_OWN_AG;
> -		bcnt_btree_curs.owner = XFS_RMAP_OWN_AG;
> -		setup_cursor(mp, agno, &bno_btree_curs);
> -		setup_cursor(mp, agno, &bcnt_btree_curs);
> +	bno_btree_curs.owner = XFS_RMAP_OWN_AG;
> +	bcnt_btree_curs.owner = XFS_RMAP_OWN_AG;
> +	setup_cursor(mp, agno, &bno_btree_curs);
> +	setup_cursor(mp, agno, &bcnt_btree_curs);
>  
>  #ifdef XR_BLD_FREE_TRACE
> -		fprintf(stderr, "# of bno extents is %d\n",
> -				count_bno_extents(agno));
> -		fprintf(stderr, "# of bcnt extents is %d\n",
> -				count_bcnt_extents(agno));
> +	fprintf(stderr, "# of bno extents is %d\n", count_bno_extents(agno));
> +	fprintf(stderr, "# of bcnt extents is %d\n", count_bcnt_extents(agno));
>  #endif
>  
> -		/*
> -		 * now rebuild the freespace trees
> -		 */
> -		freeblks1 = build_freespace_tree(mp, agno,
> +	/*
> +	 * now rebuild the freespace trees
> +	 */
> +	freeblks1 = build_freespace_tree(mp, agno,
>  					&bno_btree_curs, XFS_BTNUM_BNO);
>  #ifdef XR_BLD_FREE_TRACE
> -		fprintf(stderr, "# of free blocks == %d\n", freeblks1);
> +	fprintf(stderr, "# of free blocks == %d\n", freeblks1);
>  #endif
> -		write_cursor(&bno_btree_curs);
> +	write_cursor(&bno_btree_curs);
>  
>  #ifdef DEBUG
> -		freeblks2 = build_freespace_tree(mp, agno,
> -					&bcnt_btree_curs, XFS_BTNUM_CNT);
> +	freeblks2 = build_freespace_tree(mp, agno,
> +				&bcnt_btree_curs, XFS_BTNUM_CNT);
>  #else
> -		(void) build_freespace_tree(mp, agno,
> -					&bcnt_btree_curs, XFS_BTNUM_CNT);
> +	(void) build_freespace_tree(mp, agno, &bcnt_btree_curs, XFS_BTNUM_CNT);
>  #endif
> -		write_cursor(&bcnt_btree_curs);
> +	write_cursor(&bcnt_btree_curs);
>  
> -		ASSERT(freeblks1 == freeblks2);
> +	ASSERT(freeblks1 == freeblks2);
>  
> -		if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> -			build_rmap_tree(mp, agno, &rmap_btree_curs);
> -			write_cursor(&rmap_btree_curs);
> -			sb_fdblocks_ag[agno] += (rmap_btree_curs.num_tot_blocks -
> -					rmap_btree_curs.num_free_blocks) - 1;
> -		}
> +	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> +		build_rmap_tree(mp, agno, &rmap_btree_curs);
> +		write_cursor(&rmap_btree_curs);
> +		sb_fdblocks_ag[agno] += (rmap_btree_curs.num_tot_blocks -
> +				rmap_btree_curs.num_free_blocks) - 1;
> +	}
>  
> -		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> -			build_refcount_tree(mp, agno, &refcnt_btree_curs);
> -			write_cursor(&refcnt_btree_curs);
> -		}
> +	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> +		build_refcount_tree(mp, agno, &refcnt_btree_curs);
> +		write_cursor(&refcnt_btree_curs);
> +	}
>  
> -		/*
> -		 * set up agf and agfl
> -		 */
> -		build_agf_agfl(mp, agno, &bno_btree_curs,
> -				&bcnt_btree_curs, freeblks1, extra_blocks,
> -				&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
> -		/*
> -		 * build inode allocation tree.
> -		 */
> -		build_ino_tree(mp, agno, &ino_btree_curs, XFS_BTNUM_INO,
> -				&agi_stat);
> -		write_cursor(&ino_btree_curs);
> +	/*
> +	 * set up agf and agfl
> +	 */
> +	build_agf_agfl(mp, agno, &bno_btree_curs,
> +		&bcnt_btree_curs, freeblks1, extra_blocks,
> +		&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
> +	/*
> +	 * build inode allocation tree.
> +	 */
> +	build_ino_tree(mp, agno, &ino_btree_curs, XFS_BTNUM_INO, &agi_stat);
> +	write_cursor(&ino_btree_curs);
>  
> -		/*
> -		 * build free inode tree
> -		 */
> -		if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
> -			build_ino_tree(mp, agno, &fino_btree_curs,
> -					XFS_BTNUM_FINO, NULL);
> -			write_cursor(&fino_btree_curs);
> -		}
> +	/*
> +	 * build free inode tree
> +	 */
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
> +		build_ino_tree(mp, agno, &fino_btree_curs,
> +				XFS_BTNUM_FINO, NULL);
> +		write_cursor(&fino_btree_curs);
> +	}
>  
> -		/* build the agi */
> -		build_agi(mp, agno, &ino_btree_curs, &fino_btree_curs,
> -			  &agi_stat);
> +	/* build the agi */
> +	build_agi(mp, agno, &ino_btree_curs, &fino_btree_curs, &agi_stat);
>  
> -		/*
> -		 * tear down cursors
> -		 */
> -		finish_cursor(&bno_btree_curs);
> -		finish_cursor(&ino_btree_curs);
> -		if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> -			finish_cursor(&rmap_btree_curs);
> -		if (xfs_sb_version_hasreflink(&mp->m_sb))
> -			finish_cursor(&refcnt_btree_curs);
> -		if (xfs_sb_version_hasfinobt(&mp->m_sb))
> -			finish_cursor(&fino_btree_curs);
> -		finish_cursor(&bcnt_btree_curs);
> +	/*
> +	 * tear down cursors
> +	 */
> +	finish_cursor(&bno_btree_curs);
> +	finish_cursor(&ino_btree_curs);
> +	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> +		finish_cursor(&rmap_btree_curs);
> +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> +		finish_cursor(&refcnt_btree_curs);
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> +		finish_cursor(&fino_btree_curs);
> +	finish_cursor(&bcnt_btree_curs);
>  
> -		/*
> -		 * release the incore per-AG bno/bcnt trees so
> -		 * the extent nodes can be recycled
> -		 */
> -		release_agbno_extent_tree(agno);
> -		release_agbcnt_extent_tree(agno);
> -	}
> +	/*
> +	 * release the incore per-AG bno/bcnt trees so the extent nodes
> +	 * can be recycled
> +	 */
> +	release_agbno_extent_tree(agno);
> +	release_agbcnt_extent_tree(agno);
>  	PROG_RPT_INC(prog_rpt_done[agno], 1);
>  }
>  
> 
