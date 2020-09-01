Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3BC2C433E7
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 16:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1835206FA
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 16:59:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SJHvlM6b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732497AbgIAQ7G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 12:59:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55434 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732531AbgIAQ66 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 12:58:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081GsqDP013960;
        Tue, 1 Sep 2020 16:58:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=y7f5/itH9fIlGqeME/uEJfEVJJJcyuK8w+PsJhsbSVg=;
 b=SJHvlM6bsCnCOXEDDfaPTEdHCX8ImHRxx+JzIQ3sTGymfyZHILaHTsyjFLTkb4TQPzUE
 /9cw5G8xsqvM42dsIHWsJG9855GCtEcIAyH4P5PQGje5PuLIT36WrCOFqSjqJvhUY8f8
 R/alhg1Sra85Q9DtLlwmfYx+dPBIKWlVD5d94i8Z13gjF/0XZly4nuTVQaNRZLkjGmqq
 R4OvGqgwjVsxRvuJGhxgE/LdJ47zAy15tmSZtGAnt5o6+j0NgxVACBSBLJwejUNuv7bN
 eCXat3SQ04j1KnyjCAW9C1Nhrya1/IL/7xEF6q1ZyGrDCmD1P6404udv2iWeP5+1tFok Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 337eeqwqj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Sep 2020 16:58:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081Gtgj3018412;
        Tue, 1 Sep 2020 16:58:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3380xwsvps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Sep 2020 16:58:54 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 081GwrH8021164;
        Tue, 1 Sep 2020 16:58:53 GMT
Received: from localhost (/10.159.133.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 09:58:53 -0700
Date:   Tue, 1 Sep 2020 09:58:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/15] xfs: remove xfs_getsb
Message-ID: <20200901165850.GG6096@magnolia>
References: <20200901155018.2524-1-hch@lst.de>
 <20200901155018.2524-15-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901155018.2524-15-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 01, 2020 at 05:50:17PM +0200, Christoph Hellwig wrote:
> Merge xfs_getsb into its only caller, and clean that one up a little bit
> as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log_recover.c | 26 +++++++++++++-------------
>  fs/xfs/xfs_mount.c       | 17 -----------------
>  fs/xfs/xfs_mount.h       |  1 -
>  3 files changed, 13 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 5449cba657352c..4f5569aab89a08 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3268,14 +3268,14 @@ xlog_do_log_recovery(
>   */
>  STATIC int
>  xlog_do_recover(
> -	struct xlog	*log,
> -	xfs_daddr_t	head_blk,
> -	xfs_daddr_t	tail_blk)
> +	struct xlog		*log,
> +	xfs_daddr_t		head_blk,
> +	xfs_daddr_t		tail_blk)
>  {
> -	struct xfs_mount *mp = log->l_mp;
> -	int		error;
> -	xfs_buf_t	*bp;
> -	xfs_sb_t	*sbp;
> +	struct xfs_mount	*mp = log->l_mp;
> +	struct xfs_buf		*bp = mp->m_sb_bp;
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +	int			error;
>  
>  	trace_xfs_log_recover(log, head_blk, tail_blk);
>  
> @@ -3289,9 +3289,8 @@ xlog_do_recover(
>  	/*
>  	 * If IO errors happened during recovery, bail out.
>  	 */
> -	if (XFS_FORCED_SHUTDOWN(mp)) {
> +	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
> -	}
>  
>  	/*
>  	 * We now update the tail_lsn since much of the recovery has completed
> @@ -3305,10 +3304,12 @@ xlog_do_recover(
>  	xlog_assign_tail_lsn(mp);
>  
>  	/*
> -	 * Now that we've finished replaying all buffer and inode
> -	 * updates, re-read in the superblock and reverify it.
> +	 * Now that we've finished replaying all buffer and inode updates,
> +	 * re-read the superblock and reverify it.
>  	 */
> -	bp = xfs_getsb(mp);
> +	xfs_buf_lock(bp);
> +	xfs_buf_hold(bp);
> +	ASSERT(bp->b_flags & XBF_DONE);
>  	bp->b_flags &= ~(XBF_DONE | XBF_ASYNC);
>  	ASSERT(!(bp->b_flags & XBF_WRITE));
>  	bp->b_flags |= XBF_READ;
> @@ -3325,7 +3326,6 @@ xlog_do_recover(
>  	}
>  
>  	/* Convert superblock from on-disk format */
> -	sbp = &mp->m_sb;
>  	xfs_sb_from_disk(sbp, bp->b_addr);
>  	xfs_buf_relse(bp);
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index c8ae49a1e99c35..09cc7ca91cd398 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1288,23 +1288,6 @@ xfs_mod_frextents(
>  	return ret;
>  }
>  
> -/*
> - * xfs_getsb() is called to obtain the buffer for the superblock.
> - * The buffer is returned locked and read in from disk.
> - * The buffer should be released with a call to xfs_brelse().
> - */
> -struct xfs_buf *
> -xfs_getsb(
> -	struct xfs_mount	*mp)
> -{
> -	struct xfs_buf		*bp = mp->m_sb_bp;
> -
> -	xfs_buf_lock(bp);
> -	xfs_buf_hold(bp);
> -	ASSERT(bp->b_flags & XBF_DONE);
> -	return bp;
> -}
> -
>  /*
>   * Used to free the superblock along various error paths.
>   */
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index a72cfcaa4ad12e..dfa429b77ee285 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -410,7 +410,6 @@ extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
>  				 bool reserved);
>  extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
>  
> -extern struct xfs_buf *xfs_getsb(xfs_mount_t *);
>  extern int	xfs_readsb(xfs_mount_t *, int);
>  extern void	xfs_freesb(xfs_mount_t *);
>  extern bool	xfs_fs_writable(struct xfs_mount *mp, int level);
> -- 
> 2.28.0
> 
