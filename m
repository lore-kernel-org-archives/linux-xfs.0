Return-Path: <SRS0=wgma=55=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74503C2BA19
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Apr 2020 12:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BA2820753
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Apr 2020 12:31:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C9biuzNy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgDMMbQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Apr 2020 08:31:16 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24284 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728392AbgDMMbQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Apr 2020 08:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586781074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xCSoZVSCfXip/A/+OFO5W6cO9rZH3AfbKNrSmDtNMCc=;
        b=C9biuzNyleK+4g6aZb9X3Llh6VaqMo+Dq15pIKUrcmUWkkzknh6lpUnJdgOmzDEp52GLRj
        MEaxLhJb6t5JoksAPET2CkYLOl/ALhhKKk+3PC6Vg4Q58XnKuIAKYAdLCTobAxrgzAOcMR
        bYscplXWNbGPWezjFUVHvnxUxbdVdgc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-mf4AuUBMOwi8jIihqUcRJA-1; Mon, 13 Apr 2020 08:31:12 -0400
X-MC-Unique: mf4AuUBMOwi8jIihqUcRJA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDB481B2C98C;
        Mon, 13 Apr 2020 12:31:11 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 92D345DA7C;
        Mon, 13 Apr 2020 12:31:11 +0000 (UTC)
Date:   Mon, 13 Apr 2020 08:31:09 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: move inode flush to a workqueue
Message-ID: <20200413123109.GB57285@bfoster>
References: <158674021112.3253017.16592621806726469169.stgit@magnolia>
 <158674021749.3253017.16036198065081499968.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158674021749.3253017.16036198065081499968.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 12, 2020 at 06:10:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the inode dirty data flushing to a workqueue so that multiple
> threads can take advantage of a single thread's flush work.  The
> ratelimiting technique was not successful, because threads that skipped
> the inode flush scan due to ratelimiting would ENOSPC early and
> apparently now there are complaints about that.  So make everyone wait.
> 
> Fixes: bdd4ee4f8407 ("xfs: ratelimit inode flush on buffered write ENOSPC")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Seems reasonable in general, but do we really want to to dump a longish
running filesystem sync to the system workqueue? It looks like there are
a lot of existing users so I can't really tell if there are major
restrictions or not, but it seems risk of disruption is higher than
necessary if we dump one or more full fs syncs to it..

Brian

>  fs/xfs/xfs_mount.h |    6 +++++-
>  fs/xfs/xfs_super.c |   40 ++++++++++++++++++++++------------------
>  2 files changed, 27 insertions(+), 19 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 50c43422fa17..b2e4598fdf7d 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -167,8 +167,12 @@ typedef struct xfs_mount {
>  	struct xfs_kobj		m_error_meta_kobj;
>  	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
>  	struct xstats		m_stats;	/* per-fs stats */
> -	struct ratelimit_state	m_flush_inodes_ratelimit;
>  
> +	/*
> +	 * Workqueue item so that we can coalesce multiple inode flush attempts
> +	 * into a single flush.
> +	 */
> +	struct work_struct	m_flush_inodes_work;
>  	struct workqueue_struct *m_buf_workqueue;
>  	struct workqueue_struct	*m_unwritten_workqueue;
>  	struct workqueue_struct	*m_cil_workqueue;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index abf06bf9c3f3..dced03a4571d 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -516,6 +516,20 @@ xfs_destroy_mount_workqueues(
>  	destroy_workqueue(mp->m_buf_workqueue);
>  }
>  
> +static void
> +xfs_flush_inodes_worker(
> +	struct work_struct	*work)
> +{
> +	struct xfs_mount	*mp = container_of(work, struct xfs_mount,
> +						   m_flush_inodes_work);
> +	struct super_block	*sb = mp->m_super;
> +
> +	if (down_read_trylock(&sb->s_umount)) {
> +		sync_inodes_sb(sb);
> +		up_read(&sb->s_umount);
> +	}
> +}
> +
>  /*
>   * Flush all dirty data to disk. Must not be called while holding an XFS_ILOCK
>   * or a page lock. We use sync_inodes_sb() here to ensure we block while waiting
> @@ -526,15 +540,15 @@ void
>  xfs_flush_inodes(
>  	struct xfs_mount	*mp)
>  {
> -	struct super_block	*sb = mp->m_super;
> -
> -	if (!__ratelimit(&mp->m_flush_inodes_ratelimit))
> +	/*
> +	 * If flush_work() returns true then that means we waited for a flush
> +	 * which was already in progress.  Don't bother running another scan.
> +	 */
> +	if (flush_work(&mp->m_flush_inodes_work))
>  		return;
>  
> -	if (down_read_trylock(&sb->s_umount)) {
> -		sync_inodes_sb(sb);
> -		up_read(&sb->s_umount);
> -	}
> +	schedule_work(&mp->m_flush_inodes_work);
> +	flush_work(&mp->m_flush_inodes_work);
>  }
>  
>  /* Catch misguided souls that try to use this interface on XFS */
> @@ -1369,17 +1383,6 @@ xfs_fc_fill_super(
>  	if (error)
>  		goto out_free_names;
>  
> -	/*
> -	 * Cap the number of invocations of xfs_flush_inodes to 16 for every
> -	 * quarter of a second.  The magic numbers here were determined by
> -	 * observation neither to cause stalls in writeback when there are a
> -	 * lot of IO threads and the fs is near ENOSPC, nor cause any fstest
> -	 * regressions.  YMMV.
> -	 */
> -	ratelimit_state_init(&mp->m_flush_inodes_ratelimit, HZ / 4, 16);
> -	ratelimit_set_flags(&mp->m_flush_inodes_ratelimit,
> -			RATELIMIT_MSG_ON_RELEASE);
> -
>  	error = xfs_init_mount_workqueues(mp);
>  	if (error)
>  		goto out_close_devices;
> @@ -1752,6 +1755,7 @@ static int xfs_init_fs_context(
>  	spin_lock_init(&mp->m_perag_lock);
>  	mutex_init(&mp->m_growlock);
>  	atomic_set(&mp->m_active_trans, 0);
> +	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
>  	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
>  	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
>  	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
> 

