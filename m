Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD270C47253
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 14:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C971206D9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 14:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgEAOLT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 10:11:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30494 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728840AbgEAOLS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 10:11:18 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041Df1sP076901;
        Fri, 1 May 2020 10:11:15 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30r84mjg36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 10:11:15 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 041EALw4013706;
        Fri, 1 May 2020 14:11:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 30mcu53k2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 14:11:13 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 041EBA9U62718292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 14:11:10 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B31D0AE04D;
        Fri,  1 May 2020 14:11:10 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E24D1AE053;
        Fri,  1 May 2020 14:11:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.72.180])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 14:11:09 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/21] xfs: refactor log recovery dquot item dispatch for pass2 commit functions
Date:   Fri, 01 May 2020 19:44:12 +0530
Message-ID: <6281214.nRbVF7eBD2@localhost.localdomain>
Organization: IBM
In-Reply-To: <158820769396.467894.17116807791456540006.stgit@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia> <158820769396.467894.17116807791456540006.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_06:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1015 suspectscore=5
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010103
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday, April 30, 2020 6:18 AM Darrick J. Wong wrote: 
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the log dquot item pass2 commit code into the per-item source code
> files and use the dispatch function to call it.  We do these one at a
> time because there's a lot of code to move.  No functional changes.
>

The changes look good to me.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot_item.c  |  109 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_log_recover.c |  112 ----------------------------------------------
>  2 files changed, 109 insertions(+), 112 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 4d18af49adfe..83bd7ded9185 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -419,8 +419,117 @@ xlog_recover_dquot_ra_pass2(
>  			&xfs_dquot_buf_ra_ops);
>  }
>  
> +/*
> + * Recover a dquot record
> + */
> +STATIC int
> +xlog_recover_dquot_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			current_lsn)
> +{
> +	struct xfs_mount		*mp = log->l_mp;
> +	struct xfs_buf			*bp;
> +	struct xfs_disk_dquot		*ddq, *recddq;
> +	struct xfs_dq_logformat		*dq_f;
> +	xfs_failaddr_t			fa;
> +	int				error;
> +	uint				type;
> +
> +	/*
> +	 * Filesystems are required to send in quota flags at mount time.
> +	 */
> +	if (mp->m_qflags == 0)
> +		return 0;
> +
> +	recddq = item->ri_buf[1].i_addr;
> +	if (recddq == NULL) {
> +		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
> +		return -EFSCORRUPTED;
> +	}
> +	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot)) {
> +		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
> +			item->ri_buf[1].i_len, __func__);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	/*
> +	 * This type of quotas was turned off, so ignore this record.
> +	 */
> +	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
> +	ASSERT(type);
> +	if (log->l_quotaoffs_flag & type)
> +		return 0;
> +
> +	/*
> +	 * At this point we know that quota was _not_ turned off.
> +	 * Since the mount flags are not indicating to us otherwise, this
> +	 * must mean that quota is on, and the dquot needs to be replayed.
> +	 * Remember that we may not have fully recovered the superblock yet,
> +	 * so we can't do the usual trick of looking at the SB quota bits.
> +	 *
> +	 * The other possibility, of course, is that the quota subsystem was
> +	 * removed since the last mount - ENOSYS.
> +	 */
> +	dq_f = item->ri_buf[0].i_addr;
> +	ASSERT(dq_f);
> +	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0);
> +	if (fa) {
> +		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
> +				dq_f->qlf_id, fa);
> +		return -EFSCORRUPTED;
> +	}
> +	ASSERT(dq_f->qlf_len == 1);
> +
> +	/*
> +	 * At this point we are assuming that the dquots have been allocated
> +	 * and hence the buffer has valid dquots stamped in it. It should,
> +	 * therefore, pass verifier validation. If the dquot is bad, then the
> +	 * we'll return an error here, so we don't need to specifically check
> +	 * the dquot in the buffer after the verifier has run.
> +	 */
> +	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dq_f->qlf_blkno,
> +				   XFS_FSB_TO_BB(mp, dq_f->qlf_len), 0, &bp,
> +				   &xfs_dquot_buf_ops);
> +	if (error)
> +		return error;
> +
> +	ASSERT(bp);
> +	ddq = xfs_buf_offset(bp, dq_f->qlf_boffset);
> +
> +	/*
> +	 * If the dquot has an LSN in it, recover the dquot only if it's less
> +	 * than the lsn of the transaction we are replaying.
> +	 */
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddq;
> +		xfs_lsn_t	lsn = be64_to_cpu(dqb->dd_lsn);
> +
> +		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
> +			goto out_release;
> +		}
> +	}
> +
> +	memcpy(ddq, recddq, item->ri_buf[1].i_len);
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		xfs_update_cksum((char *)ddq, sizeof(struct xfs_dqblk),
> +				 XFS_DQUOT_CRC_OFF);
> +	}
> +
> +	ASSERT(dq_f->qlf_size == 2);
> +	ASSERT(bp->b_mount == mp);
> +	bp->b_iodone = xlog_recover_iodone;
> +	xfs_buf_delwri_queue(bp, buffer_list);
> +
> +out_release:
> +	xfs_buf_relse(bp);
> +	return 0;
> +}
> +
>  const struct xlog_recover_item_type xlog_dquot_item_type = {
>  	.ra_pass2_fn		= xlog_recover_dquot_ra_pass2,
> +	.commit_pass2_fn	= xlog_recover_dquot_commit_pass2,
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 57e5dac0f510..58a54d9e6847 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2056,115 +2056,6 @@ xlog_buf_readahead(
>  		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
>  }
>  
> -/*
> - * Recover a dquot record
> - */
> -STATIC int
> -xlog_recover_dquot_pass2(
> -	struct xlog			*log,
> -	struct list_head		*buffer_list,
> -	struct xlog_recover_item	*item,
> -	xfs_lsn_t			current_lsn)
> -{
> -	xfs_mount_t		*mp = log->l_mp;
> -	xfs_buf_t		*bp;
> -	struct xfs_disk_dquot	*ddq, *recddq;
> -	xfs_failaddr_t		fa;
> -	int			error;
> -	xfs_dq_logformat_t	*dq_f;
> -	uint			type;
> -
> -
> -	/*
> -	 * Filesystems are required to send in quota flags at mount time.
> -	 */
> -	if (mp->m_qflags == 0)
> -		return 0;
> -
> -	recddq = item->ri_buf[1].i_addr;
> -	if (recddq == NULL) {
> -		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
> -		return -EFSCORRUPTED;
> -	}
> -	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot)) {
> -		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
> -			item->ri_buf[1].i_len, __func__);
> -		return -EFSCORRUPTED;
> -	}
> -
> -	/*
> -	 * This type of quotas was turned off, so ignore this record.
> -	 */
> -	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
> -	ASSERT(type);
> -	if (log->l_quotaoffs_flag & type)
> -		return 0;
> -
> -	/*
> -	 * At this point we know that quota was _not_ turned off.
> -	 * Since the mount flags are not indicating to us otherwise, this
> -	 * must mean that quota is on, and the dquot needs to be replayed.
> -	 * Remember that we may not have fully recovered the superblock yet,
> -	 * so we can't do the usual trick of looking at the SB quota bits.
> -	 *
> -	 * The other possibility, of course, is that the quota subsystem was
> -	 * removed since the last mount - ENOSYS.
> -	 */
> -	dq_f = item->ri_buf[0].i_addr;
> -	ASSERT(dq_f);
> -	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0);
> -	if (fa) {
> -		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
> -				dq_f->qlf_id, fa);
> -		return -EFSCORRUPTED;
> -	}
> -	ASSERT(dq_f->qlf_len == 1);
> -
> -	/*
> -	 * At this point we are assuming that the dquots have been allocated
> -	 * and hence the buffer has valid dquots stamped in it. It should,
> -	 * therefore, pass verifier validation. If the dquot is bad, then the
> -	 * we'll return an error here, so we don't need to specifically check
> -	 * the dquot in the buffer after the verifier has run.
> -	 */
> -	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dq_f->qlf_blkno,
> -				   XFS_FSB_TO_BB(mp, dq_f->qlf_len), 0, &bp,
> -				   &xfs_dquot_buf_ops);
> -	if (error)
> -		return error;
> -
> -	ASSERT(bp);
> -	ddq = xfs_buf_offset(bp, dq_f->qlf_boffset);
> -
> -	/*
> -	 * If the dquot has an LSN in it, recover the dquot only if it's less
> -	 * than the lsn of the transaction we are replaying.
> -	 */
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddq;
> -		xfs_lsn_t	lsn = be64_to_cpu(dqb->dd_lsn);
> -
> -		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
> -			goto out_release;
> -		}
> -	}
> -
> -	memcpy(ddq, recddq, item->ri_buf[1].i_len);
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -		xfs_update_cksum((char *)ddq, sizeof(struct xfs_dqblk),
> -				 XFS_DQUOT_CRC_OFF);
> -	}
> -
> -	ASSERT(dq_f->qlf_size == 2);
> -	ASSERT(bp->b_mount == mp);
> -	bp->b_iodone = xlog_recover_iodone;
> -	xfs_buf_delwri_queue(bp, buffer_list);
> -
> -out_release:
> -	xfs_buf_relse(bp);
> -	return 0;
> -}
> -
>  /*
>   * This routine is called to create an in-core extent free intent
>   * item from the efi format structure which was logged on disk.
> @@ -2771,9 +2662,6 @@ xlog_recover_commit_pass2(
>  		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
>  	case XFS_LI_BUD:
>  		return xlog_recover_bud_pass2(log, item);
> -	case XFS_LI_DQUOT:
> -		return xlog_recover_dquot_pass2(log, buffer_list, item,
> -						trans->r_lsn);
>  	case XFS_LI_ICREATE:
>  		return xlog_recover_do_icreate_pass2(log, buffer_list, item);
>  	case XFS_LI_QUOTAOFF:
> 
> 


-- 
chandan



