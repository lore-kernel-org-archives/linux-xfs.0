Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80405C54E4A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 12:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57238206F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 12:31:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ipbbE6oA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729408AbgELMbm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 08:31:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53155 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729382AbgELMbm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 08:31:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589286700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C7gcaF/J3K8o8rtkocuLSaokzb3rPwMZGI/u565usuU=;
        b=ipbbE6oAIrPQSiM3wRX9lS3j5HnDfQ7WllplV6RR7xenK4/+/VPY3O/TBbadu833pPBaTC
        6QWiqN48nO38R421UUtbgOD0LCM8gVBAThcstdGQNgDDXk9wOP+avPGHwBIghB0mMFIkoT
        eFrF/0pmLBFZCd77Me3K6dwpBbUkSQc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-dcLici9SMDChqHsKdh067w-1; Tue, 12 May 2020 08:31:39 -0400
X-MC-Unique: dcLici9SMDChqHsKdh067w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 276FA107ACF2;
        Tue, 12 May 2020 12:31:38 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D601A5C1BB;
        Tue, 12 May 2020 12:31:37 +0000 (UTC)
Date:   Tue, 12 May 2020 08:31:36 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: convert m_active_trans counter to per-cpu
Message-ID: <20200512123136.GB37029@bfoster>
References: <20200512092811.1846252-1-david@fromorbit.com>
 <20200512092811.1846252-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512092811.1846252-3-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 07:28:08PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's a global atomic counter, and we are hitting it at a rate of
> half a million transactions a second, so it's bouncing the counter
> cacheline all over the place on large machines. Convert it to a
> per-cpu counter.
> 
> And .... oh wow, that was unexpected!
> 
> Concurrent create, 50 million inodes, identical 16p/16GB virtual
> machines on different physical hosts. Machine A has twice the CPU
> cores per socket of machine B:
> 
> 		unpatched	patched
> machine A:	3m45s		2m27s
> machine B:	4m13s		4m14s
> 
> Create rates:
> 		unpatched	patched
> machine A:	246k+/-15k	384k+/-10k
> machine B:	225k+/-13k	223k+/-11k
> 
> Concurrent rm of same 50 million inodes:
> 
> 		unpatched	patched
> machine A:	8m30s		3m09s
> machine B:	5m02s		4m51s
> 
> The transaction rate on the fast machine went from about 250k/sec to
> over 600k/sec, which indicates just how much of a bottleneck this
> atomic counter was.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks fairly straightforward. We're increasing the size of xfs_mount,
but it's already over a 4k page and there's only one per-mount:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_mount.h |  2 +-
>  fs/xfs/xfs_super.c | 12 +++++++++---
>  fs/xfs/xfs_trans.c |  6 +++---
>  3 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 712b3e2583316..af3d8b71e9591 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -84,6 +84,7 @@ typedef struct xfs_mount {
>  	 * extents or anything related to the rt device.
>  	 */
>  	struct percpu_counter	m_delalloc_blks;
> +	struct percpu_counter	m_active_trans;	/* in progress xact counter */
>  
>  	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
>  	char			*m_rtname;	/* realtime device name */
> @@ -164,7 +165,6 @@ typedef struct xfs_mount {
>  	uint64_t		m_resblks;	/* total reserved blocks */
>  	uint64_t		m_resblks_avail;/* available reserved blocks */
>  	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
> -	atomic_t		m_active_trans;	/* number trans frozen */
>  	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
>  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
>  	struct delayed_work	m_eofblocks_work; /* background eof blocks
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e80bd2c4c279e..bc4853525ce18 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -883,7 +883,7 @@ xfs_quiesce_attr(
>  	int	error = 0;
>  
>  	/* wait for all modifications to complete */
> -	while (atomic_read(&mp->m_active_trans) > 0)
> +	while (percpu_counter_sum(&mp->m_active_trans) > 0)
>  		delay(100);
>  
>  	/* force the log to unpin objects from the now complete transactions */
> @@ -902,7 +902,7 @@ xfs_quiesce_attr(
>  	 * Just warn here till VFS can correctly support
>  	 * read-only remount without racing.
>  	 */
> -	WARN_ON(atomic_read(&mp->m_active_trans) != 0);
> +	WARN_ON(percpu_counter_sum(&mp->m_active_trans) != 0);
>  
>  	xfs_log_quiesce(mp);
>  }
> @@ -1027,8 +1027,14 @@ xfs_init_percpu_counters(
>  	if (error)
>  		goto free_fdblocks;
>  
> +	error = percpu_counter_init(&mp->m_active_trans, 0, GFP_KERNEL);
> +	if (error)
> +		goto free_delalloc_blocks;
> +
>  	return 0;
>  
> +free_delalloc_blocks:
> +	percpu_counter_destroy(&mp->m_delalloc_blks);
>  free_fdblocks:
>  	percpu_counter_destroy(&mp->m_fdblocks);
>  free_ifree:
> @@ -1057,6 +1063,7 @@ xfs_destroy_percpu_counters(
>  	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
>  	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
>  	percpu_counter_destroy(&mp->m_delalloc_blks);
> +	percpu_counter_destroy(&mp->m_active_trans);
>  }
>  
>  static void
> @@ -1792,7 +1799,6 @@ static int xfs_init_fs_context(
>  	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
>  	spin_lock_init(&mp->m_perag_lock);
>  	mutex_init(&mp->m_growlock);
> -	atomic_set(&mp->m_active_trans, 0);
>  	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
>  	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
>  	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 28b983ff8b113..636df5017782e 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -68,7 +68,7 @@ xfs_trans_free(
>  	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
>  
>  	trace_xfs_trans_free(tp, _RET_IP_);
> -	atomic_dec(&tp->t_mountp->m_active_trans);
> +	percpu_counter_dec(&tp->t_mountp->m_active_trans);
>  	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
>  		sb_end_intwrite(tp->t_mountp->m_super);
>  	xfs_trans_free_dqinfo(tp);
> @@ -126,7 +126,7 @@ xfs_trans_dup(
>  
>  	xfs_trans_dup_dqinfo(tp, ntp);
>  
> -	atomic_inc(&tp->t_mountp->m_active_trans);
> +	percpu_counter_inc(&tp->t_mountp->m_active_trans);
>  	return ntp;
>  }
>  
> @@ -275,7 +275,7 @@ xfs_trans_alloc(
>  	 */
>  	WARN_ON(resp->tr_logres > 0 &&
>  		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
> -	atomic_inc(&mp->m_active_trans);
> +	percpu_counter_inc(&mp->m_active_trans);
>  
>  	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
>  	tp->t_flags = flags;
> -- 
> 2.26.1.301.g55bc3eb7cb9
> 

