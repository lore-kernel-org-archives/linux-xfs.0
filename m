Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A936C1975A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 10:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDB9720716
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 10:49:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F7V0jxUk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgCLKtn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 06:49:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32031 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727002AbgCLKtn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 06:49:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584010182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VfmeSa2If1dtUMnxyjMPa4J0Fd4UhzMuz4cRI8BtCeY=;
        b=F7V0jxUkelCE7VkhzU74nEMNJiCKov8J/xwb/fjjilVsyZ3eF9NEtHAeZAG4Cr7QTxqhzy
        nbDUlaSCwM9nkttllTXtOeM25ySBQa/KCCqCFBNpaKQbqxr4I0A+1f7eWFPpszs/Or7TU4
        1NEEOrUNWA/drJYtElsuC2d5Aznqi+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-hPdvAblTPDmElOpJibloBA-1; Thu, 12 Mar 2020 06:49:40 -0400
X-MC-Unique: hPdvAblTPDmElOpJibloBA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73DAA800D4E;
        Thu, 12 Mar 2020 10:49:39 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A71085C1C3;
        Thu, 12 Mar 2020 10:49:38 +0000 (UTC)
Date:   Thu, 12 Mar 2020 06:49:36 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 7/7] xfs: make the btree ag cursor private union anonymous
Message-ID: <20200312104936.GG60753@bfoster>
References: <158398468107.1307855.8287106235853942996.stgit@magnolia>
 <158398472694.1307855.12435739558591642821.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158398472694.1307855.12435739558591642821.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 08:45:27PM -0700, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This is much less widely used than the bc_private union was, so this
> is done as a single patch. The named union xfs_btree_cur_private
> goes away and is embedded into the struct xfs_btree_cur_ag as an
> anonymous union, and the code is modified via this script:
> 
> $ sed -i 's/priv\.\([abt|refc]\)/\1/g' fs/xfs/*[ch] fs/xfs/*/*[ch]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c          |   14 +++++++-------
>  fs/xfs/libxfs/xfs_alloc_btree.c    |    2 +-
>  fs/xfs/libxfs/xfs_btree.h          |   25 +++++++++++--------------
>  fs/xfs/libxfs/xfs_refcount.c       |   24 ++++++++++++------------
>  fs/xfs/libxfs/xfs_refcount_btree.c |    4 ++--
>  5 files changed, 33 insertions(+), 36 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 10ed68dfef5d..337822115bbc 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -151,7 +151,7 @@ xfs_alloc_lookup_eq(
>  	cur->bc_rec.a.ar_startblock = bno;
>  	cur->bc_rec.a.ar_blockcount = len;
>  	error = xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
> -	cur->bc_ag.priv.abt.active = (*stat == 1);
> +	cur->bc_ag.abt.active = (*stat == 1);
>  	return error;
>  }
>  
> @@ -171,7 +171,7 @@ xfs_alloc_lookup_ge(
>  	cur->bc_rec.a.ar_startblock = bno;
>  	cur->bc_rec.a.ar_blockcount = len;
>  	error = xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
> -	cur->bc_ag.priv.abt.active = (*stat == 1);
> +	cur->bc_ag.abt.active = (*stat == 1);
>  	return error;
>  }
>  
> @@ -190,7 +190,7 @@ xfs_alloc_lookup_le(
>  	cur->bc_rec.a.ar_startblock = bno;
>  	cur->bc_rec.a.ar_blockcount = len;
>  	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
> -	cur->bc_ag.priv.abt.active = (*stat == 1);
> +	cur->bc_ag.abt.active = (*stat == 1);
>  	return error;
>  }
>  
> @@ -198,7 +198,7 @@ static inline bool
>  xfs_alloc_cur_active(
>  	struct xfs_btree_cur	*cur)
>  {
> -	return cur && cur->bc_ag.priv.abt.active;
> +	return cur && cur->bc_ag.abt.active;
>  }
>  
>  /*
> @@ -908,7 +908,7 @@ xfs_alloc_cur_check(
>  		deactivate = true;
>  out:
>  	if (deactivate)
> -		cur->bc_ag.priv.abt.active = false;
> +		cur->bc_ag.abt.active = false;
>  	trace_xfs_alloc_cur_check(args->mp, cur->bc_btnum, bno, len, diff,
>  				  *new);
>  	return 0;
> @@ -1352,7 +1352,7 @@ xfs_alloc_walk_iter(
>  		if (error)
>  			return error;
>  		if (i == 0)
> -			cur->bc_ag.priv.abt.active = false;
> +			cur->bc_ag.abt.active = false;
>  
>  		if (count > 0)
>  			count--;
> @@ -1467,7 +1467,7 @@ xfs_alloc_ag_vextent_locality(
>  		if (error)
>  			return error;
>  		if (i) {
> -			acur->cnt->bc_ag.priv.abt.active = true;
> +			acur->cnt->bc_ag.abt.active = true;
>  			fbcur = acur->cnt;
>  			fbinc = false;
>  		}
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 92d30c19519d..a28041fdf4c0 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -507,7 +507,7 @@ xfs_allocbt_init_cursor(
>  
>  	cur->bc_ag.agbp = agbp;
>  	cur->bc_ag.agno = agno;
> -	cur->bc_ag.priv.abt.active = false;
> +	cur->bc_ag.abt.active = false;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb))
>  		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 9884f543eb51..0d10bbd5223a 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -177,22 +177,19 @@ union xfs_btree_irec {
>  	struct xfs_refcount_irec	rc;
>  };
>  
> -/* Per-AG btree private information. */
> -union xfs_btree_cur_private {
> -	struct {
> -		unsigned long	nr_ops;		/* # record updates */
> -		int		shape_changes;	/* # of extent splits */
> -	} refc;
> -	struct {
> -		bool		active;		/* allocation cursor state */
> -	} abt;
> -};
> -
>  /* Per-AG btree information. */
>  struct xfs_btree_cur_ag {
> -	struct xfs_buf			*agbp;
> -	xfs_agnumber_t			agno;
> -	union xfs_btree_cur_private	priv;
> +	struct xfs_buf		*agbp;
> +	xfs_agnumber_t		agno;
> +	union {
> +		struct {
> +			unsigned long nr_ops;	/* # record updates */
> +			int	shape_changes;	/* # of extent splits */
> +		} refc;
> +		struct {
> +			bool	active;		/* allocation cursor state */
> +		} abt;
> +	};
>  };
>  
>  /* Btree-in-inode cursor information */
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index ef3e706f1d94..2076627243b0 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -883,7 +883,7 @@ xfs_refcount_still_have_space(
>  {
>  	unsigned long			overhead;
>  
> -	overhead = cur->bc_ag.priv.refc.shape_changes *
> +	overhead = cur->bc_ag.refc.shape_changes *
>  			xfs_allocfree_log_count(cur->bc_mp, 1);
>  	overhead *= cur->bc_mp->m_sb.sb_blocksize;
>  
> @@ -891,17 +891,17 @@ xfs_refcount_still_have_space(
>  	 * Only allow 2 refcount extent updates per transaction if the
>  	 * refcount continue update "error" has been injected.
>  	 */
> -	if (cur->bc_ag.priv.refc.nr_ops > 2 &&
> +	if (cur->bc_ag.refc.nr_ops > 2 &&
>  	    XFS_TEST_ERROR(false, cur->bc_mp,
>  			XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE))
>  		return false;
>  
> -	if (cur->bc_ag.priv.refc.nr_ops == 0)
> +	if (cur->bc_ag.refc.nr_ops == 0)
>  		return true;
>  	else if (overhead > cur->bc_tp->t_log_res)
>  		return false;
>  	return  cur->bc_tp->t_log_res - overhead >
> -		cur->bc_ag.priv.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
> +		cur->bc_ag.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
>  }
>  
>  /*
> @@ -968,7 +968,7 @@ xfs_refcount_adjust_extents(
>  					error = -EFSCORRUPTED;
>  					goto out_error;
>  				}
> -				cur->bc_ag.priv.refc.nr_ops++;
> +				cur->bc_ag.refc.nr_ops++;
>  			} else {
>  				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
>  						cur->bc_ag.agno,
> @@ -1003,7 +1003,7 @@ xfs_refcount_adjust_extents(
>  			error = xfs_refcount_update(cur, &ext);
>  			if (error)
>  				goto out_error;
> -			cur->bc_ag.priv.refc.nr_ops++;
> +			cur->bc_ag.refc.nr_ops++;
>  		} else if (ext.rc_refcount == 1) {
>  			error = xfs_refcount_delete(cur, &found_rec);
>  			if (error)
> @@ -1012,7 +1012,7 @@ xfs_refcount_adjust_extents(
>  				error = -EFSCORRUPTED;
>  				goto out_error;
>  			}
> -			cur->bc_ag.priv.refc.nr_ops++;
> +			cur->bc_ag.refc.nr_ops++;
>  			goto advloop;
>  		} else {
>  			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
> @@ -1088,7 +1088,7 @@ xfs_refcount_adjust(
>  	if (shape_changed)
>  		shape_changes++;
>  	if (shape_changes)
> -		cur->bc_ag.priv.refc.shape_changes++;
> +		cur->bc_ag.refc.shape_changes++;
>  
>  	/* Now that we've taken care of the ends, adjust the middle extents */
>  	error = xfs_refcount_adjust_extents(cur, new_agbno, new_aglen,
> @@ -1166,8 +1166,8 @@ xfs_refcount_finish_one(
>  	 */
>  	rcur = *pcur;
>  	if (rcur != NULL && rcur->bc_ag.agno != agno) {
> -		nr_ops = rcur->bc_ag.priv.refc.nr_ops;
> -		shape_changes = rcur->bc_ag.priv.refc.shape_changes;
> +		nr_ops = rcur->bc_ag.refc.nr_ops;
> +		shape_changes = rcur->bc_ag.refc.shape_changes;
>  		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
>  		rcur = NULL;
>  		*pcur = NULL;
> @@ -1183,8 +1183,8 @@ xfs_refcount_finish_one(
>  			error = -ENOMEM;
>  			goto out_cur;
>  		}
> -		rcur->bc_ag.priv.refc.nr_ops = nr_ops;
> -		rcur->bc_ag.priv.refc.shape_changes = shape_changes;
> +		rcur->bc_ag.refc.nr_ops = nr_ops;
> +		rcur->bc_ag.refc.shape_changes = shape_changes;
>  	}
>  	*pcur = rcur;
>  
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index bf1a4cb3c7ac..e07a2c45f8ec 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -340,8 +340,8 @@ xfs_refcountbt_init_cursor(
>  	cur->bc_ag.agno = agno;
>  	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
>  
> -	cur->bc_ag.priv.refc.nr_ops = 0;
> -	cur->bc_ag.priv.refc.shape_changes = 0;
> +	cur->bc_ag.refc.nr_ops = 0;
> +	cur->bc_ag.refc.shape_changes = 0;
>  
>  	return cur;
>  }
> 

