Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73ACAC4363D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 22:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17BC420872
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 22:13:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FmZi+ys9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgJGWNP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 18:13:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39120 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728742AbgJGWNP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 18:13:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097MAkY8058701;
        Wed, 7 Oct 2020 22:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ohSGjvyX27KnbKWZvr6Kf+I1UMXBW8CTDIaJc6zSGyA=;
 b=FmZi+ys9i5nQltPFCt4eudNLd3c7pfogSReToiC4PTt3IoSTG1oB1IfBzuRGAiNbsXFe
 9tAlhmw7Y1e9V0fzNTnIMz2iXdi6LBp0s5hPd6Ee1SC/zfWXAV4mGTCmece+wmOzaqhs
 S+zraumCBhQSO7o3OcG0yD6hfKlvikp7mcJmfs93jtkMB3KHlnS07kfmH22N6O5YhYne
 tRTq45XJtR3ZiWBOF8hU8EYpUQL29+pbqzC8051ssmw0bcxnhX1+Q/KCdbt5ZmJbGE4i
 V5fjEQYXatbWB6hTm9Mu6/N4uMypTYB/AyvbeLKtfUL/ffMc4xT1wDvHlhecn4zZ/72u 2w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33ym34srec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 22:13:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097MAsLu152318;
        Wed, 7 Oct 2020 22:13:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3410k068cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 22:13:12 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 097MDBcE003751;
        Wed, 7 Oct 2020 22:13:11 GMT
Received: from localhost (/10.159.134.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 15:13:11 -0700
Date:   Wed, 7 Oct 2020 15:13:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: transaction subsystem quiesce mechanism
Message-ID: <20201007221310.GF6540@magnolia>
References: <20201001150310.141467-1-bfoster@redhat.com>
 <20201001150310.141467-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001150310.141467-3-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=5 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=5 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070140
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 01, 2020 at 11:03:09AM -0400, Brian Foster wrote:
> The updated quotaoff logging algorithm depends on a runtime quiesce
> of the transaction subsystem to guarantee all transactions after a
> certain point detect quota subsystem changes. Implement this
> mechanism using an internal lock, similar to the external filesystem
> freeze mechanism. This is also somewhat analogous to the old percpu
> transaction counter mechanism, but we don't actually need a counter.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_aops.c  |  2 ++
>  fs/xfs/xfs_mount.h |  3 +++
>  fs/xfs/xfs_super.c |  8 ++++++++
>  fs/xfs/xfs_trans.c |  4 ++--
>  fs/xfs/xfs_trans.h | 20 ++++++++++++++++++++
>  5 files changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index b35611882ff9..214310c94de5 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -58,6 +58,7 @@ xfs_setfilesize_trans_alloc(
>  	 * we released it.
>  	 */
>  	__sb_writers_release(ioend->io_inode->i_sb, SB_FREEZE_FS);
> +	percpu_rwsem_release(&mp->m_trans_rwsem, true, _THIS_IP_);
>  	/*
>  	 * We hand off the transaction to the completion thread now, so
>  	 * clear the flag here.
> @@ -127,6 +128,7 @@ xfs_setfilesize_ioend(
>  	 */
>  	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
>  	__sb_writers_acquired(VFS_I(ip)->i_sb, SB_FREEZE_FS);
> +	percpu_rwsem_acquire(&ip->i_mount->m_trans_rwsem, true, _THIS_IP_);
>  
>  	/* we abort the update if there was an IO error */
>  	if (error) {
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index dfa429b77ee2..f1083a9ce1f8 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -171,6 +171,9 @@ typedef struct xfs_mount {
>  	 */
>  	struct percpu_counter	m_delalloc_blks;
>  
> +	/* lock for transaction quiesce (used by quotaoff) */
> +	struct percpu_rw_semaphore	m_trans_rwsem;
> +
>  	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
>  	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
>  	uint64_t		m_resblks;	/* total reserved blocks */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index baf5de30eebb..ff3ad5392e21 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1029,8 +1029,15 @@ xfs_init_percpu_counters(
>  	if (error)
>  		goto free_fdblocks;
>  
> +	/* not a counter, but close enough... */
> +	error = percpu_init_rwsem(&mp->m_trans_rwsem);
> +	if (error)
> +		goto free_delalloc;
> +
>  	return 0;
>  
> +free_delalloc:
> +	percpu_counter_destroy(&mp->m_delalloc_blks);
>  free_fdblocks:
>  	percpu_counter_destroy(&mp->m_fdblocks);
>  free_ifree:
> @@ -1053,6 +1060,7 @@ static void
>  xfs_destroy_percpu_counters(
>  	struct xfs_mount	*mp)
>  {
> +	percpu_free_rwsem(&mp->m_trans_rwsem);
>  	percpu_counter_destroy(&mp->m_icount);
>  	percpu_counter_destroy(&mp->m_ifree);
>  	percpu_counter_destroy(&mp->m_fdblocks);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index ca18a040336a..c07fa036549a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -69,7 +69,7 @@ xfs_trans_free(
>  
>  	trace_xfs_trans_free(tp, _RET_IP_);
>  	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
> -		sb_end_intwrite(tp->t_mountp->m_super);
> +		xfs_trans_end(tp->t_mountp);
>  	xfs_trans_free_dqinfo(tp);
>  	kmem_cache_free(xfs_trans_zone, tp);
>  }
> @@ -265,7 +265,7 @@ xfs_trans_alloc(
>  	 */
>  	tp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
>  	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
> -		sb_start_intwrite(mp->m_super);
> +		xfs_trans_start(mp);
>  
>  	/*
>  	 * Zero-reservation ("empty") transactions can't modify anything, so
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index f46534b75236..af54c17a22c0 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -209,6 +209,26 @@ xfs_trans_read_buf(
>  				      flags, bpp, ops);
>  }
>  
> +/*
> + * Context tracking helpers for external (i.e. fs freeze) and internal
> + * transaction quiesce.
> + */
> +static inline void
> +xfs_trans_start(
> +	struct xfs_mount	*mp)
> +{
> +	sb_start_intwrite(mp->m_super);
> +	percpu_down_read(&mp->m_trans_rwsem);

/me wonders, have you noticed any extra cpu overhead with this?

So far it looks ok to me, though I wonder if we could skip all this if
CONFIG_XFS_QUOTA=n...

--D

> +}
> +
> +static inline void
> +xfs_trans_end(
> +	struct xfs_mount	*mp)
> +{
> +	percpu_up_read(&mp->m_trans_rwsem);
> +	sb_end_intwrite(mp->m_super);
> +}
> +
>  struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
>  
>  void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
> -- 
> 2.25.4
> 
