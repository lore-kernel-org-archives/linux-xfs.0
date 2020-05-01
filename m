Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D09DC47256
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 14:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD75320757
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 14:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgEAOPX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 10:15:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15540 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728887AbgEAOPW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 10:15:22 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041E2sj8010627;
        Fri, 1 May 2020 10:15:19 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30r7mckdc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 10:15:19 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 041EAEHh020596;
        Fri, 1 May 2020 14:15:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu74vwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 14:15:16 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 041EFECY61735240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 14:15:14 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD98EA405F;
        Fri,  1 May 2020 14:15:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E69D1A4067;
        Fri,  1 May 2020 14:15:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.72.180])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 14:15:13 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/21] xfs: refactor log recovery icreate item dispatch for pass2 commit functions
Date:   Fri, 01 May 2020 19:48:16 +0530
Message-ID: <69061559.EVSPQyX58B@localhost.localdomain>
Organization: IBM
In-Reply-To: <158820770082.467894.7639027771832654915.stgit@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia> <158820770082.467894.7639027771832654915.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_08:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxscore=0 phishscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 impostorscore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday, April 30, 2020 6:18 AM Darrick J. Wong wrote: 
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the log icreate item pass2 commit code into the per-item source code
> files and use the dispatch function to call it.  We do these one at a
> time because there's a lot of code to move.  No functional changes.
>

The changes look good to me.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_icreate_item.c |  132 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_log_recover.c  |  126 -------------------------------------------
>  2 files changed, 132 insertions(+), 126 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 9f38a3c200a3..602a8c91371f 100644
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
> @@ -117,6 +123,132 @@ xlog_icreate_reorder(
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
> +xlog_recover_do_icreate_commit_pass2(
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
>  const struct xlog_recover_item_type xlog_icreate_item_type = {
>  	.reorder_fn		= xlog_icreate_reorder,
> +	.commit_pass2_fn	= xlog_recover_do_icreate_commit_pass2,
>  };
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 58a54d9e6847..6ba3d64d08de 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2489,130 +2489,6 @@ xlog_recover_bud_pass2(
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
> -	xlog_recover_item_t	*item)
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
>  xlog_recover_commit_pass1(
>  	struct xlog			*log,
> @@ -2662,8 +2538,6 @@ xlog_recover_commit_pass2(
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



