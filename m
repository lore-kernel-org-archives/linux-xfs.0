Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6067C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 20:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 995E92084C
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 20:45:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fn1CiOn/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgETUpz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 16:45:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36854 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgETUpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 16:45:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KKfQ1k038423;
        Wed, 20 May 2020 20:45:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3g3Tc9CtLHf7z/8Qt4FDlBsT/oKvgLJhUESUq2ylC+k=;
 b=fn1CiOn/0O8/oT6l8AO68LZZWSpJlDkHZtqED35MDPGCOKzkWaYsagXa7WVy0QUgic/u
 1mZaGdU1AQwPVPncwSO/Q17y+NOBwAZfXr50LNM9eV7+fPq2A2ef7xlfbsAfH2bv8N5j
 6lAkJCtPV5Mnh5hRHWwSCjY0CB7hwQYl7potzEXysTIGj+J1hg+VSrhJQh2xIrCR/keX
 FosjgaajVJyQTsdzEd2NABowg0u9WPAM38Gr0XG3WCvPDSwluwEr/mmox0r0vsd9nO4J
 9ojE1438OPRlMCxLgPcSBE6q37TDhR0iHTqEoHANN9UB5Ol+OihS2MShnc7pRVzaYQtR JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31501rbv0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 20:45:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KKhC36137968;
        Wed, 20 May 2020 20:43:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 312t38rprk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 20:43:51 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04KKhoOR001526;
        Wed, 20 May 2020 20:43:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 13:43:50 -0700
Date:   Wed, 20 May 2020 13:43:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: reduce free inode accounting overhead
Message-ID: <20200520204349.GD17627@magnolia>
References: <20200519214840.2570159-1-david@fromorbit.com>
 <20200519214840.2570159-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519214840.2570159-3-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=5 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 07:48:40AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Shaokun Zhang reported that XFs was using substantial CPU time in
> percpu_count_sum() when running a single threaded benchmark on
> a high CPU count (128p) machine from xfs_mod_ifree(). The issue
> is that the filesystem is empty when the benchmark runs, so inode
> allocation is running with a very low inode free count.
> 
> With the percpu counter batching, this means comparisons when the
> counter is less that 128 * 256 = 32768 use the slow path of adding
> up all the counters across the CPUs, and this is expensive on high
> CPU count machines.
> 
> The summing in xfs_mod_ifree() is only used to fire an assert if an
> underrun occurs. The error is ignored by the higher level code.
> Hence this is really just debug code and we don't need to run it
> on production kernels, nor do we need such debug checks to return
> error values just to trigger an assert.
> 
> Finally, xfs_mod_icount/xfs_mod_ifree are only called from
> xfs_trans_unreserve_and_mod_sb(), so get rid of them and just
> directly call the percpu_counter_add/percpu_counter_compare
> functions. The compare functions are now run only on debug builds as
> they are internal to ASSERT() checks and so only compiled in when
> ASSERTs are active (CONFIG_XFS_DEBUG=y or CONFIG_XFS_WARN=y).
> 
> Reported-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Seems like a reasonable substitution/ASSERT reduction to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_mount.c | 33 ---------------------------------
>  fs/xfs/xfs_mount.h |  2 --
>  fs/xfs/xfs_trans.c | 17 +++++++++++++----
>  3 files changed, 13 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index bb91f04266b9a..d5dcf98698600 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1189,39 +1189,6 @@ xfs_log_sbcount(xfs_mount_t *mp)
>  	return xfs_sync_sb(mp, true);
>  }
>  
> -/*
> - * Deltas for the inode count are +/-64, hence we use a large batch size
> - * of 128 so we don't need to take the counter lock on every update.
> - */
> -#define XFS_ICOUNT_BATCH	128
> -int
> -xfs_mod_icount(
> -	struct xfs_mount	*mp,
> -	int64_t			delta)
> -{
> -	percpu_counter_add_batch(&mp->m_icount, delta, XFS_ICOUNT_BATCH);
> -	if (__percpu_counter_compare(&mp->m_icount, 0, XFS_ICOUNT_BATCH) < 0) {
> -		ASSERT(0);
> -		percpu_counter_add(&mp->m_icount, -delta);
> -		return -EINVAL;
> -	}
> -	return 0;
> -}
> -
> -int
> -xfs_mod_ifree(
> -	struct xfs_mount	*mp,
> -	int64_t			delta)
> -{
> -	percpu_counter_add(&mp->m_ifree, delta);
> -	if (percpu_counter_compare(&mp->m_ifree, 0) < 0) {
> -		ASSERT(0);
> -		percpu_counter_add(&mp->m_ifree, -delta);
> -		return -EINVAL;
> -	}
> -	return 0;
> -}
> -
>  /*
>   * Deltas for the block count can vary from 1 to very large, but lock contention
>   * only occurs on frequent small block count updates such as in the delayed
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index aba5a15792792..4835581f3eb00 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -392,8 +392,6 @@ extern int	xfs_initialize_perag(xfs_mount_t *mp, xfs_agnumber_t agcount,
>  				     xfs_agnumber_t *maxagi);
>  extern void	xfs_unmountfs(xfs_mount_t *);
>  
> -extern int	xfs_mod_icount(struct xfs_mount *mp, int64_t delta);
> -extern int	xfs_mod_ifree(struct xfs_mount *mp, int64_t delta);
>  extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
>  				 bool reserved);
>  extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 4522ceaaf57ba..b055a5ab53465 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -545,7 +545,12 @@ xfs_trans_apply_sb_deltas(
>   * used block counts are not updated in the on disk superblock. In this case,
>   * XFS_TRANS_SB_DIRTY will not be set when the transaction is updated but we
>   * still need to update the incore superblock with the changes.
> + *
> + * Deltas for the inode count are +/-64, hence we use a large batch size of 128
> + * so we don't need to take the counter lock on every update.
>   */
> +#define XFS_ICOUNT_BATCH	128
> +
>  void
>  xfs_trans_unreserve_and_mod_sb(
>  	struct xfs_trans	*tp)
> @@ -585,13 +590,17 @@ xfs_trans_unreserve_and_mod_sb(
>  	}
>  
>  	if (idelta) {
> -		error = xfs_mod_icount(mp, idelta);
> -		ASSERT(!error);
> +		percpu_counter_add_batch(&mp->m_icount, idelta,
> +					 XFS_ICOUNT_BATCH);
> +		if (idelta < 0)
> +			ASSERT(__percpu_counter_compare(&mp->m_icount, 0,
> +							XFS_ICOUNT_BATCH) >= 0);
>  	}
>  
>  	if (ifreedelta) {
> -		error = xfs_mod_ifree(mp, ifreedelta);
> -		ASSERT(!error);
> +		percpu_counter_add(&mp->m_ifree, ifreedelta);
> +		if (ifreedelta < 0)
> +			ASSERT(percpu_counter_compare(&mp->m_ifree, 0) >= 0);
>  	}
>  
>  	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
> -- 
> 2.26.2.761.g0e0b3e54be
> 
