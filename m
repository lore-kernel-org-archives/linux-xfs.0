Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800E0C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 15:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 497B320767
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 15:10:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lmm95jSD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgENPKA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 11:10:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46861 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726179AbgENPKA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 11:10:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589468997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DnNrlhQT7QGtDrk29SvD9pelZM2EDa3xttQZwcxMtcA=;
        b=Lmm95jSD08KeQM8/gbM4tbFJAv4Nr2SjweXm7xVY6cd9MVZOjb4un2UDS07zxMJvdJLK+s
        kS7csi27MVBeG4TcZuhIAfSUajCIotxJKLfrOkbxaq+4cizbCSQ8RxzS0RU+FIoRGjVKi0
        AMtr8/RHM1iGgGmj3c5gBVIc6XrkITQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-nxIRpdSuOT2cDmURVXRqvw-1; Thu, 14 May 2020 11:09:54 -0400
X-MC-Unique: nxIRpdSuOT2cDmURVXRqvw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E18BA8018A5;
        Thu, 14 May 2020 15:09:52 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C7E260BF1;
        Thu, 14 May 2020 15:09:52 +0000 (UTC)
Date:   Thu, 14 May 2020 11:09:50 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs_repair: unindent phase 5 function
Message-ID: <20200514150950.GB50849@bfoster>
References: <158904190079.984305.707785748675261111.stgit@magnolia>
 <158904191346.984305.10394364390153692151.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904191346.984305.10394364390153692151.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:31:53AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove the unnecessary indent in phase5_func.  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/phase5.c |  309 +++++++++++++++++++++++++++----------------------------
>  1 file changed, 154 insertions(+), 155 deletions(-)
> 
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 17b57448..f3be15de 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -2316,201 +2316,200 @@ phase5_func(
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
> +	fprintf(stderr, "# of bno extents is %d\n",
> +			count_bno_extents(agno));

Some of these multi-line statements (and comments) can be widened to 80
chars, otherwise looks like a nice cleanup to me.

Brian

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
> +		 * XXX - what we probably should do here is pick an
> +		 * inode for a regular file in the allocation group
> +		 * that has space allocated and shoot it by traversing
> +		 * the bmap list and putting all its extents on the
> +		 * incore freespace trees, clearing the inode,
> +		 * and clearing the in-use bit in the incore inode
> +		 * tree.  Then try mk_incore_fstree() again.
>  		 */
> -		init_ino_cursor(mp, agno, &ino_btree_curs, &num_inos,
> -				&num_free_inos, 0);
> +		do_error(_("unable to rebuild AG %u.  "
> +			  "Not enough free space in on-disk AG.\n"),
> +			agno);
> +	}
>  
> -		if (xfs_sb_version_hasfinobt(&mp->m_sb))
> -			init_ino_cursor(mp, agno, &fino_btree_curs,
> -					&finobt_num_inos, &finobt_num_free_inos,
> -					1);
> +	/*
> +	 * ok, now set up the btree cursors for the
> +	 * on-disk btrees (includs pre-allocating all
> +	 * required blocks for the trees themselves)
> +	 */
> +	init_ino_cursor(mp, agno, &ino_btree_curs, &num_inos,
> +			&num_free_inos, 0);
>  
> -		sb_icount_ag[agno] += num_inos;
> -		sb_ifree_ag[agno] += num_free_inos;
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> +		init_ino_cursor(mp, agno, &fino_btree_curs,
> +				&finobt_num_inos, &finobt_num_free_inos,
> +				1);
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
> +	 * Set up the btree cursors for the on-disk rmap btrees,
> +	 * which includes pre-allocating all required blocks.
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
> +	 * lose two blocks per AG -- the space tree roots
> +	 * are counted as allocated since the space trees
> +	 * always have roots
> +	 */
> +	sb_fdblocks_ag[agno] += num_freeblocks - 2;
> +
> +	if (num_extents == 0)  {
>  		/*
> -		 * lose two blocks per AG -- the space tree roots
> -		 * are counted as allocated since the space trees
> -		 * always have roots
> +		 * XXX - what we probably should do here is pick an
> +		 * inode for a regular file in the allocation group
> +		 * that has space allocated and shoot it by traversing
> +		 * the bmap list and putting all its extents on the
> +		 * incore freespace trees, clearing the inode,
> +		 * and clearing the in-use bit in the incore inode
> +		 * tree.  Then try mk_incore_fstree() again.
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
> +		do_error(
> +		_("unable to rebuild AG %u.  No free space.\n"), agno);
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
> +	 * freespace btrees live in the "free space" but
> +	 * the filesystem treats AGFL blocks as allocated
> +	 * since they aren't described by the freespace trees
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
> +	extra_blocks = (extra_blocks - libxfs_agfl_size(mp) > 0)
> +			? extra_blocks - libxfs_agfl_size(mp)
> +			: 0;
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
> +	fprintf(stderr, "# of bno extents is %d\n",
> +			count_bno_extents(agno));
> +	fprintf(stderr, "# of bcnt extents is %d\n",
> +			count_bcnt_extents(agno));
>  #endif
>  
> -		/*
> -		 * now rebuild the freespace trees
> -		 */
> -		freeblks1 = build_freespace_tree(mp, agno,
> -					&bno_btree_curs, XFS_BTNUM_BNO);
> +	/*
> +	 * now rebuild the freespace trees
> +	 */
> +	freeblks1 = build_freespace_tree(mp, agno,
> +				&bno_btree_curs, XFS_BTNUM_BNO);
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
> +	(void) build_freespace_tree(mp, agno,
> +				&bcnt_btree_curs, XFS_BTNUM_CNT);
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
> +			&bcnt_btree_curs, freeblks1, extra_blocks,
> +			&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
> +	/*
> +	 * build inode allocation tree.
> +	 */
> +	build_ino_tree(mp, agno, &ino_btree_curs, XFS_BTNUM_INO,
> +			&agi_stat);
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
> +	build_agi(mp, agno, &ino_btree_curs, &fino_btree_curs,
> +		  &agi_stat);
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
> +
> +	/*
> +	 * release the incore per-AG bno/bcnt trees so
> +	 * the extent nodes can be recycled
> +	 */
> +	release_agbno_extent_tree(agno);
> +	release_agbcnt_extent_tree(agno);
>  
> -		/*
> -		 * release the incore per-AG bno/bcnt trees so
> -		 * the extent nodes can be recycled
> -		 */
> -		release_agbno_extent_tree(agno);
> -		release_agbcnt_extent_tree(agno);
> -	}
>  	PROG_RPT_INC(prog_rpt_done[agno], 1);
>  }
>  
> 

