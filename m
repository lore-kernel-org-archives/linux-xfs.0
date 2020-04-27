Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA03C54EEB
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 18:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0196A2168B
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 18:12:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zUgKVnLi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgD0SM0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 14:12:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51972 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgD0SMY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 14:12:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RIBOBi182995;
        Mon, 27 Apr 2020 18:12:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ACGriODJ7c9lPGB1OQ5Ukaov+prGWxMI8YisvA45f8U=;
 b=zUgKVnLikuahjupWU7ad2oMoSE+djehOkJg5lbTVelapTotrsZPzgWtXbJI3FkKN3uaP
 NIkEMk/9hmgMkcboLbwZf/SaDOhxOZZQtih/QQki8OFUGzmYQtrksv7NPiQC4F4iR2hz
 yZqG7I4IsU6wBB/N+NRrif6co+oZTVgPxPRPL2Nk1PwIP3mUXxmvkG0s8kB/cV9uoPxn
 QzT1zbPdebf/yHr0vHu3r+pwuMsTMUFO6Ex85xymhokRPAYYkAi40ceohX+WMCZqXfOm
 GD9DbkL1N8sPwhzb17yOMhb/B4sV5z/USb5o0oyGdMtCRP19tCpjlEBdKbG55omRjeVU sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30nucfu7ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 18:12:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RI7wjV012091;
        Mon, 27 Apr 2020 18:12:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30mxwwq3tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 18:12:19 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RICIal014322;
        Mon, 27 Apr 2020 18:12:18 GMT
Received: from localhost (/10.159.145.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 11:12:18 -0700
Date:   Mon, 27 Apr 2020 11:12:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: refactor the buffer cancellation table helpers
Message-ID: <20200427181215.GW6742@magnolia>
References: <20200427135229.1480993-1-hch@lst.de>
 <20200427135229.1480993-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427135229.1480993-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=2 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=2 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 03:52:28PM +0200, Christoph Hellwig wrote:
> Replace the somewhat convoluted use of xlog_peek_buffer_cancelled and
> xlog_check_buffer_cancelled with two obvious helpers:
> 
>  xlog_is_buffer_cancelled, which returns true if there is a buffer in
>  the cancellation table, and
>  xlog_put_buffer_cancelled, which also decrements the reference count
>  of the buffer cancellation table.
> 
> Both share a little helper to look up the entry.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, though it took me a while to wrap my head around the
convolution.  Will give all of these a spin.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log_recover.c | 109 ++++++++++++++++++---------------------
>  1 file changed, 50 insertions(+), 59 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 11c3502b07b13..750a81b941ea4 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1972,26 +1972,17 @@ xlog_recover_buffer_pass1(
>  	return 0;
>  }
>  
> -/*
> - * Check to see whether the buffer being recovered has a corresponding
> - * entry in the buffer cancel record table. If it is, return the cancel
> - * buffer structure to the caller.
> - */
> -STATIC struct xfs_buf_cancel *
> -xlog_peek_buffer_cancelled(
> +static struct xfs_buf_cancel *
> +xlog_find_buffer_cancelled(
>  	struct xlog		*log,
>  	xfs_daddr_t		blkno,
> -	uint			len,
> -	unsigned short			flags)
> +	uint			len)
>  {
>  	struct list_head	*bucket;
>  	struct xfs_buf_cancel	*bcp;
>  
> -	if (!log->l_buf_cancel_table) {
> -		/* empty table means no cancelled buffers in the log */
> -		ASSERT(!(flags & XFS_BLF_CANCEL));
> +	if (!log->l_buf_cancel_table)
>  		return NULL;
> -	}
>  
>  	bucket = XLOG_BUF_CANCEL_BUCKET(log, blkno);
>  	list_for_each_entry(bcp, bucket, bc_list) {
> @@ -1999,50 +1990,48 @@ xlog_peek_buffer_cancelled(
>  			return bcp;
>  	}
>  
> -	/*
> -	 * We didn't find a corresponding entry in the table, so return 0 so
> -	 * that the buffer is NOT cancelled.
> -	 */
> -	ASSERT(!(flags & XFS_BLF_CANCEL));
>  	return NULL;
>  }
>  
>  /*
> - * If the buffer is being cancelled then return 1 so that it will be cancelled,
> - * otherwise return 0.  If the buffer is actually a buffer cancel item
> - * (XFS_BLF_CANCEL is set), then decrement the refcount on the entry in the
> - * table and remove it from the table if this is the last reference.
> + * Check if there is and entry for blkno, len in the buffer cancel record table.
> + */
> +static bool
> +xlog_is_buffer_cancelled(
> +	struct xlog		*log,
> +	xfs_daddr_t		blkno,
> +	uint			len)
> +{
> +	return xlog_find_buffer_cancelled(log, blkno, len) != NULL;
> +}
> +
> +/*
> + * Check if there is and entry for blkno, len in the buffer cancel record table,
> + * and decremented the reference count on it if there is one.
>   *
> - * We remove the cancel record from the table when we encounter its last
> - * occurrence in the log so that if the same buffer is re-used again after its
> - * last cancellation we actually replay the changes made at that point.
> + * Remove the cancel record once the refcount hits zero, so that if the same
> + * buffer is re-used again after its last cancellation we actually replay the
> + * changes made at that point.
>   */
> -STATIC int
> -xlog_check_buffer_cancelled(
> +static bool
> +xlog_put_buffer_cancelled(
>  	struct xlog		*log,
>  	xfs_daddr_t		blkno,
> -	uint			len,
> -	unsigned short			flags)
> +	uint			len)
>  {
>  	struct xfs_buf_cancel	*bcp;
>  
> -	bcp = xlog_peek_buffer_cancelled(log, blkno, len, flags);
> -	if (!bcp)
> -		return 0;
> +	bcp = xlog_find_buffer_cancelled(log, blkno, len);
> +	if (!bcp) {
> +		ASSERT(0);
> +		return false;
> +	}
>  
> -	/*
> -	 * We've go a match, so return 1 so that the recovery of this buffer
> -	 * is cancelled.  If this buffer is actually a buffer cancel log
> -	 * item, then decrement the refcount on the one in the table and
> -	 * remove it if this is the last reference.
> -	 */
> -	if (flags & XFS_BLF_CANCEL) {
> -		if (--bcp->bc_refcount == 0) {
> -			list_del(&bcp->bc_list);
> -			kmem_free(bcp);
> -		}
> +	if (--bcp->bc_refcount == 0) {
> +		list_del(&bcp->bc_list);
> +		kmem_free(bcp);
>  	}
> -	return 1;
> +	return true;
>  }
>  
>  /*
> @@ -2733,10 +2722,15 @@ xlog_recover_buffer_pass2(
>  	 * In this pass we only want to recover all the buffers which have
>  	 * not been cancelled and are not cancellation buffers themselves.
>  	 */
> -	if (xlog_check_buffer_cancelled(log, buf_f->blf_blkno,
> -			buf_f->blf_len, buf_f->blf_flags)) {
> -		trace_xfs_log_recover_buf_cancel(log, buf_f);
> -		return 0;
> +	if (buf_f->blf_flags & XFS_BLF_CANCEL) {
> +		if (xlog_put_buffer_cancelled(log, buf_f->blf_blkno,
> +				buf_f->blf_len))
> +			goto cancelled;
> +	} else {
> +
> +		if (xlog_is_buffer_cancelled(log, buf_f->blf_blkno,
> +				buf_f->blf_len))
> +			goto cancelled;
>  	}
>  
>  	trace_xfs_log_recover_buf_recover(log, buf_f);
> @@ -2820,6 +2814,9 @@ xlog_recover_buffer_pass2(
>  out_release:
>  	xfs_buf_relse(bp);
>  	return error;
> +cancelled:
> +	trace_xfs_log_recover_buf_cancel(log, buf_f);
> +	return 0;
>  }
>  
>  /*
> @@ -2937,8 +2934,7 @@ xlog_recover_inode_pass2(
>  	 * Inode buffers can be freed, look out for it,
>  	 * and do not replay the inode.
>  	 */
> -	if (xlog_check_buffer_cancelled(log, in_f->ilf_blkno,
> -					in_f->ilf_len, 0)) {
> +	if (xlog_is_buffer_cancelled(log, in_f->ilf_blkno, in_f->ilf_len)) {
>  		error = 0;
>  		trace_xfs_log_recover_inode_cancel(log, in_f);
>  		goto error;
> @@ -3840,7 +3836,7 @@ xlog_recover_do_icreate_pass2(
>  
>  		daddr = XFS_AGB_TO_DADDR(mp, agno,
>  				agbno + i * igeo->blocks_per_cluster);
> -		if (xlog_check_buffer_cancelled(log, daddr, bb_per_cluster, 0))
> +		if (xlog_is_buffer_cancelled(log, daddr, bb_per_cluster))
>  			cancel_count++;
>  	}
>  
> @@ -3876,11 +3872,8 @@ xlog_recover_buffer_ra_pass2(
>  	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
>  	struct xfs_mount		*mp = log->l_mp;
>  
> -	if (xlog_peek_buffer_cancelled(log, buf_f->blf_blkno,
> -			buf_f->blf_len, buf_f->blf_flags)) {
> +	if (xlog_is_buffer_cancelled(log, buf_f->blf_blkno, buf_f->blf_len))
>  		return;
> -	}
> -
>  	xfs_buf_readahead(mp->m_ddev_targp, buf_f->blf_blkno,
>  				buf_f->blf_len, NULL);
>  }
> @@ -3905,9 +3898,8 @@ xlog_recover_inode_ra_pass2(
>  			return;
>  	}
>  
> -	if (xlog_peek_buffer_cancelled(log, ilfp->ilf_blkno, ilfp->ilf_len, 0))
> +	if (xlog_is_buffer_cancelled(log, ilfp->ilf_blkno, ilfp->ilf_len))
>  		return;
> -
>  	xfs_buf_readahead(mp->m_ddev_targp, ilfp->ilf_blkno,
>  				ilfp->ilf_len, &xfs_inode_buf_ra_ops);
>  }
> @@ -3943,9 +3935,8 @@ xlog_recover_dquot_ra_pass2(
>  	ASSERT(dq_f->qlf_len == 1);
>  
>  	len = XFS_FSB_TO_BB(mp, dq_f->qlf_len);
> -	if (xlog_peek_buffer_cancelled(log, dq_f->qlf_blkno, len, 0))
> +	if (xlog_is_buffer_cancelled(log, dq_f->qlf_blkno, len))
>  		return;
> -
>  	xfs_buf_readahead(mp->m_ddev_targp, dq_f->qlf_blkno, len,
>  			  &xfs_dquot_buf_ra_ops);
>  }
> -- 
> 2.26.1
> 
