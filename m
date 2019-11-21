Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F31C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 07:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A60182088F
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 07:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfKUHrU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Nov 2019 02:47:20 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:33298 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726437AbfKUHrU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Nov 2019 02:47:20 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E3440DD1A53B0BFC846E;
        Thu, 21 Nov 2019 15:47:15 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Thu, 21 Nov 2019
 15:47:09 +0800
Subject: Re: [PATCH] xfs: gut error handling in
 xfs_trans_unreserve_and_mod_sb()
To:     Dave Chinner <david@fromorbit.com>, <linux-xfs@vger.kernel.org>,
        "guoyang (C)" <guoyang2@huawei.com>
References: <20191121004437.9633-1-david@fromorbit.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <73eb7efe-2c15-ff10-c0ad-111173ba1886@hisilicon.com>
Date:   Thu, 21 Nov 2019 15:47:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <20191121004437.9633-1-david@fromorbit.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

It has been tested on my 128 cores server and the performance is good.
the cpu usage of __percpu_counter_sum down from 7.74% to 0% andthe directory
creation and directory removal performance increase 10%+, file creation and
removal also increase about 5%, the result as follows:

Without the patch:
Command line used: ./mdtest -b 8 -z 5 -d /mnt/sdk -I 10
SUMMARY: (of 1 iterations)
   Operation                      Max            Min           Mean        Std Dev
   ---------                      ---            ---           ----        -------
   Directory creation:      68968.919      68968.919      68968.919          0.000
   Directory stat    :     310098.612     310098.612     310098.612          0.000
   Directory removal :      65191.902      65191.902      65191.902          0.000
   File creation     :      26131.119      26131.119      26131.119          0.000
   File stat         :     317181.998     317181.998     317181.998          0.000
   File read         :     232764.829     232764.829     232764.829          0.000
   File removal      :      74074.210      74074.210      74074.210          0.000
   Tree creation     :      80398.466      80398.466      80398.466          0.000
   Tree removal      :      33374.964      33374.964      33374.964          0.000

With the patch:
Command line used: ./mdtest -b 8 -z 5 -d /mnt/sdk -I 10
SUMMARY: (of 1 iterations)
   Operation                      Max            Min           Mean        Std Dev
   ---------                      ---            ---           ----        -------
   Directory creation:      81117.635      81117.635      81117.635          0.000
   Directory stat    :     319936.438     319936.438     319936.438          0.000
   Directory removal :      73507.535      73507.535      73507.535          0.000
   File creation     :      27834.931      27834.931      27834.931          0.000
   File stat         :     316691.113     316691.113     316691.113          0.000
   File read         :     231572.548     231572.548     231572.548          0.000
   File removal      :      79854.002      79854.002      79854.002          0.000
   Tree creation     :      93915.849      93915.849      93915.849          0.000
   Tree removal      :      38178.068      38178.068      38178.068          0.000

Thanks,
Shaokun

On 2019/11/21 8:44, Dave Chinner wrote:
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
> incorrect. We still allow the change to proceed and committing
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
> 

