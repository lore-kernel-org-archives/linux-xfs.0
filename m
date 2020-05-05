Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B2EC47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 06:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3E16206E6
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 06:10:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RKK8LgmF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgEEGKI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 02:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgEEGKH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 02:10:07 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3501AC061A0F
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 23:10:07 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t9so577651pjw.0
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 23:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E3He9YGC9dniaVqPG3tioytAqEvkm4VJjOagPAy6k7g=;
        b=RKK8LgmFLqdBrU82JDUs88iktwes18KAahtd8vMPw/6ntXG2r4SzQLmQc2u+Qk9x0y
         0rf6IDKzKKsZBwvXodN08HOHFBEIOOdXetWJkRK287p9iUCmWbd38aUBSD7kUs3XFBHe
         X6q1GjvRLnFHYwyuZaC1xJQOmUaFt1lwoGqZK2NKcvktyV9xpXjCoODDXpCNBJTvGb25
         U1ZwG+h/b/n6sNSjWk1PqwahoiZXHBArcsfqxoJZuZTjR6rpJ/oiexPUn/evqCn6LPrY
         w+0mIIjmbxXfDCjskhrPf7QJaPfAGkKj3mLuQ84EN8mJFPihQGgNCZ3t+2pfg9CdMTn7
         FJ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E3He9YGC9dniaVqPG3tioytAqEvkm4VJjOagPAy6k7g=;
        b=J2u+rv+txV61OlpVB2o2wuiFtfCX6zQqjCcL4uWzAJTX9FdeZNUBBHE/kQZ8vjhcE3
         E4bkMnVXLs7cCOxCnV4DsggsWO5xfnSKQFSEqQbMCuzg8tcQcUZLVHkJ+134/g2hLyLd
         8utwy49GOGesR/sZpX3zyjSCb8Dc6aKxWAc8q/L3Btm2RKi+TtvBo+qo0D1/9v0if8RU
         mGeRGMTYrH5X5OhQ16TDMeIEKjC1aX9NAuy2hgwOIAgSxtB99jox9Gsu6BaJfuClN9aA
         JFz8bLDI1WodEsK8kX6anyQCUgOWhqS8l4Lusmnv3dNscNMEHpvyg20isjhj2scH4366
         hoGg==
X-Gm-Message-State: AGi0PuYW3wSkek8aR6EIcgECctKZxqPrmtWy3V60iNFSn47FJrTQ+2Ac
        jkDMDE7HAj+KRRylquWmkw8=
X-Google-Smtp-Source: APiQypK94OMYSAH5tLorgiSwsg/6HMq3u1Yv+WyeJqVqw0lPivwzh7NbEaTxZ2OYmJUucP/HvkGq2A==
X-Received: by 2002:a17:90a:77c6:: with SMTP id e6mr1101171pjs.84.1588659006687;
        Mon, 04 May 2020 23:10:06 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id w11sm935664pfq.100.2020.05.04.23.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 23:10:04 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/28] xfs: refactor log recovery icreate item dispatch for pass2 commit functions
Date:   Tue, 05 May 2020 11:40:02 +0530
Message-ID: <5444331.afMBSc8hAP@garuda>
In-Reply-To: <158864108288.182683.15587933521563922437.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864108288.182683.15587933521563922437.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:41:22 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the log icreate item pass2 commit code into the per-item source code
> files and use the dispatch function to call it.  We do these one at a
> time because there's a lot of code to move.  No functional changes.
>

icreate item pass2 processing is functionally consistent with what was done
before this patch is applied.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_icreate_item.c |  132 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_log_recover.c  |  126 -------------------------------------------
>  2 files changed, 132 insertions(+), 126 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 366c1e722a29..287a9e5c7d75 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -6,13 +6,19 @@
>  #include "xfs.h"
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
> +#include "xfs_format.h"
>  #include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_icreate_item.h"
>  #include "xfs_log.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
> +#include "xfs_ialloc.h"
> +#include "xfs_trace.h"
>  
>  kmem_zone_t	*xfs_icreate_zone;		/* inode create item zone */
>  
> @@ -123,7 +129,133 @@ xlog_recover_icreate_reorder(
>  	return XLOG_REORDER_BUFFER_LIST;
>  }
>  
> +/*
> + * This routine is called when an inode create format structure is found in a
> + * committed transaction in the log.  It's purpose is to initialise the inodes
> + * being allocated on disk. This requires us to get inode cluster buffers that
> + * match the range to be initialised, stamped with inode templates and written
> + * by delayed write so that subsequent modifications will hit the cached buffer
> + * and only need writing out at the end of recovery.
> + */
> +STATIC int
> +xlog_recover_icreate_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{
> +	struct xfs_mount		*mp = log->l_mp;
> +	struct xfs_icreate_log		*icl;
> +	struct xfs_ino_geometry		*igeo = M_IGEO(mp);
> +	xfs_agnumber_t			agno;
> +	xfs_agblock_t			agbno;
> +	unsigned int			count;
> +	unsigned int			isize;
> +	xfs_agblock_t			length;
> +	int				bb_per_cluster;
> +	int				cancel_count;
> +	int				nbufs;
> +	int				i;
> +
> +	icl = (struct xfs_icreate_log *)item->ri_buf[0].i_addr;
> +	if (icl->icl_type != XFS_LI_ICREATE) {
> +		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad type");
> +		return -EINVAL;
> +	}
> +
> +	if (icl->icl_size != 1) {
> +		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad icl size");
> +		return -EINVAL;
> +	}
> +
> +	agno = be32_to_cpu(icl->icl_ag);
> +	if (agno >= mp->m_sb.sb_agcount) {
> +		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad agno");
> +		return -EINVAL;
> +	}
> +	agbno = be32_to_cpu(icl->icl_agbno);
> +	if (!agbno || agbno == NULLAGBLOCK || agbno >= mp->m_sb.sb_agblocks) {
> +		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad agbno");
> +		return -EINVAL;
> +	}
> +	isize = be32_to_cpu(icl->icl_isize);
> +	if (isize != mp->m_sb.sb_inodesize) {
> +		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad isize");
> +		return -EINVAL;
> +	}
> +	count = be32_to_cpu(icl->icl_count);
> +	if (!count) {
> +		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad count");
> +		return -EINVAL;
> +	}
> +	length = be32_to_cpu(icl->icl_length);
> +	if (!length || length >= mp->m_sb.sb_agblocks) {
> +		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad length");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * The inode chunk is either full or sparse and we only support
> +	 * m_ino_geo.ialloc_min_blks sized sparse allocations at this time.
> +	 */
> +	if (length != igeo->ialloc_blks &&
> +	    length != igeo->ialloc_min_blks) {
> +		xfs_warn(log->l_mp,
> +			 "%s: unsupported chunk length", __FUNCTION__);
> +		return -EINVAL;
> +	}
> +
> +	/* verify inode count is consistent with extent length */
> +	if ((count >> mp->m_sb.sb_inopblog) != length) {
> +		xfs_warn(log->l_mp,
> +			 "%s: inconsistent inode count and chunk length",
> +			 __FUNCTION__);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * The icreate transaction can cover multiple cluster buffers and these
> +	 * buffers could have been freed and reused. Check the individual
> +	 * buffers for cancellation so we don't overwrite anything written after
> +	 * a cancellation.
> +	 */
> +	bb_per_cluster = XFS_FSB_TO_BB(mp, igeo->blocks_per_cluster);
> +	nbufs = length / igeo->blocks_per_cluster;
> +	for (i = 0, cancel_count = 0; i < nbufs; i++) {
> +		xfs_daddr_t	daddr;
> +
> +		daddr = XFS_AGB_TO_DADDR(mp, agno,
> +				agbno + i * igeo->blocks_per_cluster);
> +		if (xlog_is_buffer_cancelled(log, daddr, bb_per_cluster))
> +			cancel_count++;
> +	}
> +
> +	/*
> +	 * We currently only use icreate for a single allocation at a time. This
> +	 * means we should expect either all or none of the buffers to be
> +	 * cancelled. Be conservative and skip replay if at least one buffer is
> +	 * cancelled, but warn the user that something is awry if the buffers
> +	 * are not consistent.
> +	 *
> +	 * XXX: This must be refined to only skip cancelled clusters once we use
> +	 * icreate for multiple chunk allocations.
> +	 */
> +	ASSERT(!cancel_count || cancel_count == nbufs);
> +	if (cancel_count) {
> +		if (cancel_count != nbufs)
> +			xfs_warn(mp,
> +	"WARNING: partial inode chunk cancellation, skipped icreate.");
> +		trace_xfs_log_recover_icreate_cancel(log, icl);
> +		return 0;
> +	}
> +
> +	trace_xfs_log_recover_icreate_recover(log, icl);
> +	return xfs_ialloc_inode_init(mp, NULL, buffer_list, count, agno, agbno,
> +				     length, be32_to_cpu(icl->icl_gen));
> +}
> +
>  const struct xlog_recover_item_ops xlog_icreate_item_ops = {
>  	.item_type		= XFS_LI_ICREATE,
>  	.reorder		= xlog_recover_icreate_reorder,
> +	.commit_pass2		= xlog_recover_icreate_commit_pass2,
>  };
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ea2a53b614c7..86bf2da28dcd 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2467,130 +2467,6 @@ xlog_recover_bud_pass2(
>  	return 0;
>  }
>  
> -/*
> - * This routine is called when an inode create format structure is found in a
> - * committed transaction in the log.  It's purpose is to initialise the inodes
> - * being allocated on disk. This requires us to get inode cluster buffers that
> - * match the range to be initialised, stamped with inode templates and written
> - * by delayed write so that subsequent modifications will hit the cached buffer
> - * and only need writing out at the end of recovery.
> - */
> -STATIC int
> -xlog_recover_do_icreate_pass2(
> -	struct xlog		*log,
> -	struct list_head	*buffer_list,
> -	struct xlog_recover_item *item)
> -{
> -	struct xfs_mount	*mp = log->l_mp;
> -	struct xfs_icreate_log	*icl;
> -	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> -	xfs_agnumber_t		agno;
> -	xfs_agblock_t		agbno;
> -	unsigned int		count;
> -	unsigned int		isize;
> -	xfs_agblock_t		length;
> -	int			bb_per_cluster;
> -	int			cancel_count;
> -	int			nbufs;
> -	int			i;
> -
> -	icl = (struct xfs_icreate_log *)item->ri_buf[0].i_addr;
> -	if (icl->icl_type != XFS_LI_ICREATE) {
> -		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad type");
> -		return -EINVAL;
> -	}
> -
> -	if (icl->icl_size != 1) {
> -		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad icl size");
> -		return -EINVAL;
> -	}
> -
> -	agno = be32_to_cpu(icl->icl_ag);
> -	if (agno >= mp->m_sb.sb_agcount) {
> -		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad agno");
> -		return -EINVAL;
> -	}
> -	agbno = be32_to_cpu(icl->icl_agbno);
> -	if (!agbno || agbno == NULLAGBLOCK || agbno >= mp->m_sb.sb_agblocks) {
> -		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad agbno");
> -		return -EINVAL;
> -	}
> -	isize = be32_to_cpu(icl->icl_isize);
> -	if (isize != mp->m_sb.sb_inodesize) {
> -		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad isize");
> -		return -EINVAL;
> -	}
> -	count = be32_to_cpu(icl->icl_count);
> -	if (!count) {
> -		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad count");
> -		return -EINVAL;
> -	}
> -	length = be32_to_cpu(icl->icl_length);
> -	if (!length || length >= mp->m_sb.sb_agblocks) {
> -		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad length");
> -		return -EINVAL;
> -	}
> -
> -	/*
> -	 * The inode chunk is either full or sparse and we only support
> -	 * m_ino_geo.ialloc_min_blks sized sparse allocations at this time.
> -	 */
> -	if (length != igeo->ialloc_blks &&
> -	    length != igeo->ialloc_min_blks) {
> -		xfs_warn(log->l_mp,
> -			 "%s: unsupported chunk length", __FUNCTION__);
> -		return -EINVAL;
> -	}
> -
> -	/* verify inode count is consistent with extent length */
> -	if ((count >> mp->m_sb.sb_inopblog) != length) {
> -		xfs_warn(log->l_mp,
> -			 "%s: inconsistent inode count and chunk length",
> -			 __FUNCTION__);
> -		return -EINVAL;
> -	}
> -
> -	/*
> -	 * The icreate transaction can cover multiple cluster buffers and these
> -	 * buffers could have been freed and reused. Check the individual
> -	 * buffers for cancellation so we don't overwrite anything written after
> -	 * a cancellation.
> -	 */
> -	bb_per_cluster = XFS_FSB_TO_BB(mp, igeo->blocks_per_cluster);
> -	nbufs = length / igeo->blocks_per_cluster;
> -	for (i = 0, cancel_count = 0; i < nbufs; i++) {
> -		xfs_daddr_t	daddr;
> -
> -		daddr = XFS_AGB_TO_DADDR(mp, agno,
> -				agbno + i * igeo->blocks_per_cluster);
> -		if (xlog_is_buffer_cancelled(log, daddr, bb_per_cluster))
> -			cancel_count++;
> -	}
> -
> -	/*
> -	 * We currently only use icreate for a single allocation at a time. This
> -	 * means we should expect either all or none of the buffers to be
> -	 * cancelled. Be conservative and skip replay if at least one buffer is
> -	 * cancelled, but warn the user that something is awry if the buffers
> -	 * are not consistent.
> -	 *
> -	 * XXX: This must be refined to only skip cancelled clusters once we use
> -	 * icreate for multiple chunk allocations.
> -	 */
> -	ASSERT(!cancel_count || cancel_count == nbufs);
> -	if (cancel_count) {
> -		if (cancel_count != nbufs)
> -			xfs_warn(mp,
> -	"WARNING: partial inode chunk cancellation, skipped icreate.");
> -		trace_xfs_log_recover_icreate_cancel(log, icl);
> -		return 0;
> -	}
> -
> -	trace_xfs_log_recover_icreate_recover(log, icl);
> -	return xfs_ialloc_inode_init(mp, NULL, buffer_list, count, agno, agbno,
> -				     length, be32_to_cpu(icl->icl_gen));
> -}
> -
>  STATIC int
>  xlog_recover_commit_pass2(
>  	struct xlog			*log,
> @@ -2621,8 +2497,6 @@ xlog_recover_commit_pass2(
>  		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
>  	case XFS_LI_BUD:
>  		return xlog_recover_bud_pass2(log, item);
> -	case XFS_LI_ICREATE:
> -		return xlog_recover_do_icreate_pass2(log, buffer_list, item);
>  	case XFS_LI_QUOTAOFF:
>  		/* nothing to do in pass2 */
>  		return 0;
> 
> 


-- 
chandan



