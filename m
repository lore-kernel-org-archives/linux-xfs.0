Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BDEC432C0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 02:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 731362075A
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 02:38:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WdDDEdgv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbfKUCix (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 21:38:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49708 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKUCiw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 21:38:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAL2ZRSs174821;
        Thu, 21 Nov 2019 02:38:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=5QmdtcmSW6zZavRCFf8KyBUeVTZsrIN2UP5YuqyoLmw=;
 b=WdDDEdgvgaWUkzLreS1zZoYfa5PpKL8o2vz581SHDfizPx/QDHSkvQ/d33v0HC7NG1hs
 qyZ49i4jD6Kl+PMQEqoE+aQo1cZa+ww2KTfROB0FF0POfifJc49hKxesinGXqkpwiBLY
 Gc28E0G9HHeFSoUg3N1mXqBI02SSZ2+NABpAbg6cdWQEU4EUe18+guFGWpAAXP8ieTiZ
 Kq59Fa3aq4esyHfmoxycUjf1FQic3FeKOgj/dTaebTFKXaP8b7RTtfluUAvjj4frcQO7
 mSszwpCIJ75KCKvZJnaAJjrJT8QHl5Zl1OXofFHTJ9qFgALCHLEcgFDqTAiZIM430Vtu aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wa8hu19mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 02:38:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAL2cTSh150935;
        Thu, 21 Nov 2019 02:38:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2wdfrpnfve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 02:38:41 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAL2ccX1029058;
        Thu, 21 Nov 2019 02:38:39 GMT
Received: from localhost (/10.159.246.236)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 18:38:37 -0800
Date:   Wed, 20 Nov 2019 18:38:36 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, zhangshaokun@hisilicon.com
Subject: Re: [PATCH] xfs: gut error handling in
 xfs_trans_unreserve_and_mod_sb()
Message-ID: <20191121023836.GV6219@magnolia>
References: <20191121004437.9633-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121004437.9633-1-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911210023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911210022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 21, 2019 at 11:44:37AM +1100, Dave Chinner wrote:
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
> Hence this is really just debug code. Hence we don't need to run it
> on production kernels, nor do we need such debug checks to return
> error values just to trigger an assert.
> 
> Further, the error handling in xfs_trans_unreserve_and_mod_sb() is
> largely incorrect - Rolling back the changes in the transaction if
> only one counter underruns makes all the other counters
> incorrect.

Separate change, separate patch...

> We still allow the change to proceed and committing
> the transaction, except now we have multiple incorrect counters
> instead of a single underflow. Hence we should remove all this
> counter unwinding, too.
> 
> Finally, xfs_mod_icount/xfs_mod_ifree are only called from
> xfs_trans_unreserve_and_mod_sb(), so get rid of them and just
> directly call the percpu_counter_add/percpu_counter_compare
> functions. The compare functions are now run only on debug builds as
> they are internal to ASSERT() checks and so only compiled in when
> ASSERTs are active (CONFIG_XFS_DEBUG=y or CONFIG_XFS_WARN=y).
> 
> Difference in binary size for a production kernel:
> 
> Before:
>    text    data     bss     dec     hex filename
>    9486     184       8    9678    25ce fs/xfs/xfs_trans.o
>   10858      89      12   10959    2acf fs/xfs/xfs_mount.o
> 
> After:
>    text    data     bss     dec     hex filename
>    8462     184       8    8654    21ce fs/xfs/xfs_trans.o
>   10510      89      12   10611    2973 fs/xfs/xfs_mount.o
> 
> So not only does this cleanup chop out a lot of source code, it also
> results in a binary size reduction of ~1.3kB in a very frequently
> used fast path of the filesystem.
> 
> Reported-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_mount.c |  33 ----------
>  fs/xfs/xfs_mount.h |   2 -
>  fs/xfs/xfs_trans.c | 153 +++++++++++----------------------------------
>  3 files changed, 37 insertions(+), 151 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index fca65109cf24..205a83f33abc 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1125,39 +1125,6 @@ xfs_log_sbcount(xfs_mount_t *mp)
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
> index 88ab09ed29e7..0c9524660100 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -389,8 +389,6 @@ extern int	xfs_initialize_perag(xfs_mount_t *mp, xfs_agnumber_t agcount,
>  				     xfs_agnumber_t *maxagi);
>  extern void	xfs_unmountfs(xfs_mount_t *);
>  
> -extern int	xfs_mod_icount(struct xfs_mount *mp, int64_t delta);
> -extern int	xfs_mod_ifree(struct xfs_mount *mp, int64_t delta);
>  extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
>  				 bool reserved);
>  extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 3b208f9a865c..93e9a5154cdb 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -527,57 +527,51 @@ xfs_trans_apply_sb_deltas(
>  				  sizeof(sbp->sb_frextents) - 1);
>  }
>  
> -STATIC int
> +static void
>  xfs_sb_mod8(
>  	uint8_t			*field,
>  	int8_t			delta)
>  {
>  	int8_t			counter = *field;
>  
> +	if (!delta)
> +		return;
>  	counter += delta;
> -	if (counter < 0) {
> -		ASSERT(0);
> -		return -EINVAL;
> -	}
> +	ASSERT(counter >= 0);
>  	*field = counter;
> -	return 0;



>  }
>  
> -STATIC int
> +static void
>  xfs_sb_mod32(
>  	uint32_t		*field,
>  	int32_t			delta)
>  {
>  	int32_t			counter = *field;
>  
> +	if (!delta)
> +		return;
>  	counter += delta;
> -	if (counter < 0) {
> -		ASSERT(0);
> -		return -EINVAL;
> -	}
> +	ASSERT(counter >= 0);
>  	*field = counter;
> -	return 0;
>  }
>  
> -STATIC int
> +static void
>  xfs_sb_mod64(
>  	uint64_t		*field,
>  	int64_t			delta)
>  {
>  	int64_t			counter = *field;
>  
> +	if (!delta)
> +		return;
>  	counter += delta;
> -	if (counter < 0) {
> -		ASSERT(0);
> -		return -EINVAL;
> -	}
> +	ASSERT(counter >= 0);
>  	*field = counter;
> -	return 0;
>  }
>  
>  /*
> - * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations
> - * and apply superblock counter changes to the in-core superblock.  The
> + * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations and
> + * apply superblock counter changes to the in-core superblock.  The
>   * t_res_fdblocks_delta and t_res_frextents_delta fields are explicitly NOT
>   * applied to the in-core superblock.  The idea is that that has already been
>   * done.
> @@ -586,7 +580,12 @@ xfs_sb_mod64(
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
> @@ -622,20 +621,21 @@ xfs_trans_unreserve_and_mod_sb(
>  	/* apply the per-cpu counters */
>  	if (blkdelta) {
>  		error = xfs_mod_fdblocks(mp, blkdelta, rsvd);
> -		if (error)
> -			goto out;
> +		ASSERT(!error);
>  	}
>  
>  	if (idelta) {
> -		error = xfs_mod_icount(mp, idelta);
> -		if (error)
> -			goto out_undo_fdblocks;
> +		percpu_counter_add_batch(&mp->m_icount, idelta,
> +					 XFS_ICOUNT_BATCH);
> +		if (idelta < 0)
> +			ASSERT(__percpu_counter_compare(&mp->m_icount, 0,
> +							XFS_ICOUNT_BATCH) >= 0);
>  	}
>  
>  	if (ifreedelta) {
> -		error = xfs_mod_ifree(mp, ifreedelta);
> -		if (error)
> -			goto out_undo_icount;
> +		percpu_counter_add(&mp->m_ifree, ifreedelta);
> +		if (ifreedelta < 0)
> +			ASSERT(percpu_counter_compare(&mp->m_ifree, 0) >= 0);

Since the whole thing is a debug statement, why not shove everything
into a single assert?

ASSERT(ifreedelta >= 0 || percpu_computer_compare() >= 0); ?

Don't really care that much, just wondering... overall this part seems
reasonable.

>  	}
>  
>  	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
> @@ -643,95 +643,16 @@ xfs_trans_unreserve_and_mod_sb(
>  
>  	/* apply remaining deltas */
>  	spin_lock(&mp->m_sb_lock);
> -	if (rtxdelta) {
> -		error = xfs_sb_mod64(&mp->m_sb.sb_frextents, rtxdelta);
> -		if (error)
> -			goto out_undo_ifree;
> -	}
> -
> -	if (tp->t_dblocks_delta != 0) {
> -		error = xfs_sb_mod64(&mp->m_sb.sb_dblocks, tp->t_dblocks_delta);
> -		if (error)
> -			goto out_undo_frextents;
> -	}
> -	if (tp->t_agcount_delta != 0) {
> -		error = xfs_sb_mod32(&mp->m_sb.sb_agcount, tp->t_agcount_delta);
> -		if (error)
> -			goto out_undo_dblocks;
> -	}
> -	if (tp->t_imaxpct_delta != 0) {
> -		error = xfs_sb_mod8(&mp->m_sb.sb_imax_pct, tp->t_imaxpct_delta);
> -		if (error)
> -			goto out_undo_agcount;
> -	}
> -	if (tp->t_rextsize_delta != 0) {
> -		error = xfs_sb_mod32(&mp->m_sb.sb_rextsize,
> -				     tp->t_rextsize_delta);
> -		if (error)
> -			goto out_undo_imaxpct;
> -	}
> -	if (tp->t_rbmblocks_delta != 0) {
> -		error = xfs_sb_mod32(&mp->m_sb.sb_rbmblocks,
> -				     tp->t_rbmblocks_delta);
> -		if (error)
> -			goto out_undo_rextsize;
> -	}
> -	if (tp->t_rblocks_delta != 0) {
> -		error = xfs_sb_mod64(&mp->m_sb.sb_rblocks, tp->t_rblocks_delta);
> -		if (error)
> -			goto out_undo_rbmblocks;
> -	}
> -	if (tp->t_rextents_delta != 0) {
> -		error = xfs_sb_mod64(&mp->m_sb.sb_rextents,
> -				     tp->t_rextents_delta);
> -		if (error)
> -			goto out_undo_rblocks;
> -	}
> -	if (tp->t_rextslog_delta != 0) {
> -		error = xfs_sb_mod8(&mp->m_sb.sb_rextslog,
> -				     tp->t_rextslog_delta);
> -		if (error)
> -			goto out_undo_rextents;
> -	}
> -	spin_unlock(&mp->m_sb_lock);
> -	return;
> -
> -out_undo_rextents:
> -	if (tp->t_rextents_delta)
> -		xfs_sb_mod64(&mp->m_sb.sb_rextents, -tp->t_rextents_delta);
> -out_undo_rblocks:
> -	if (tp->t_rblocks_delta)
> -		xfs_sb_mod64(&mp->m_sb.sb_rblocks, -tp->t_rblocks_delta);
> -out_undo_rbmblocks:
> -	if (tp->t_rbmblocks_delta)
> -		xfs_sb_mod32(&mp->m_sb.sb_rbmblocks, -tp->t_rbmblocks_delta);
> -out_undo_rextsize:
> -	if (tp->t_rextsize_delta)
> -		xfs_sb_mod32(&mp->m_sb.sb_rextsize, -tp->t_rextsize_delta);
> -out_undo_imaxpct:
> -	if (tp->t_rextsize_delta)
> -		xfs_sb_mod8(&mp->m_sb.sb_imax_pct, -tp->t_imaxpct_delta);
> -out_undo_agcount:
> -	if (tp->t_agcount_delta)
> -		xfs_sb_mod32(&mp->m_sb.sb_agcount, -tp->t_agcount_delta);
> -out_undo_dblocks:
> -	if (tp->t_dblocks_delta)
> -		xfs_sb_mod64(&mp->m_sb.sb_dblocks, -tp->t_dblocks_delta);
> -out_undo_frextents:
> -	if (rtxdelta)
> -		xfs_sb_mod64(&mp->m_sb.sb_frextents, -rtxdelta);
> -out_undo_ifree:
> +	xfs_sb_mod64(&mp->m_sb.sb_frextents, rtxdelta);

As for these bits... why even bother with a three line helper?  I think
this is clearer about what's going on:

	mp->m_sb.sb_frextents += rtxdelta;
	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
	...
	ASSERT(!rtxdelta || mp->m_sb.sb_frextents >= 0);
	ASSERT(!tp->t_dblocks_delta || mp->m_sb.sb.dblocks >= 0);

and since we hold m_sb_lock it's not like we're trying to do anything
fancy with memory accesses...?

I also wonder if we should be shutting down the fs here if the counts
go negative, but <shrug> that would be yet a different patch. :)

--D

> +	xfs_sb_mod64(&mp->m_sb.sb_dblocks, tp->t_dblocks_delta);
> +	xfs_sb_mod32(&mp->m_sb.sb_agcount, tp->t_agcount_delta);
> +	xfs_sb_mod8(&mp->m_sb.sb_imax_pct, tp->t_imaxpct_delta);
> +	xfs_sb_mod32(&mp->m_sb.sb_rextsize, tp->t_rextsize_delta);
> +	xfs_sb_mod32(&mp->m_sb.sb_rbmblocks, tp->t_rbmblocks_delta);
> +	xfs_sb_mod64(&mp->m_sb.sb_rblocks, tp->t_rblocks_delta);
> +	xfs_sb_mod64(&mp->m_sb.sb_rextents, tp->t_rextents_delta);
> +	xfs_sb_mod8(&mp->m_sb.sb_rextslog, tp->t_rextslog_delta);
>  	spin_unlock(&mp->m_sb_lock);
> -	if (ifreedelta)
> -		xfs_mod_ifree(mp, -ifreedelta);
> -out_undo_icount:
> -	if (idelta)
> -		xfs_mod_icount(mp, -idelta);
> -out_undo_fdblocks:
> -	if (blkdelta)
> -		xfs_mod_fdblocks(mp, -blkdelta, rsvd);
> -out:
> -	ASSERT(error == 0);
>  	return;
>  }
>  
> -- 
> 2.24.0.rc0
> 
