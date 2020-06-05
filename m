Return-Path: <SRS0=6H2z=7S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA4BC433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 16:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDE242086A
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 16:27:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CA6MTUp1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgFEQ1B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 12:27:01 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45834 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728138AbgFEQ0o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jun 2020 12:26:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591374402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LJNAgkIxGJPkUzTdHRfbtjuMNWG4BO4IdS8fNYJ0fAk=;
        b=CA6MTUp14DdsATgtHI6oHP81G63UZBe8MZ1ug6chmdN/QMVKUCiGTjIeQPafAeRjF09Vmv
        8pgcDMcXCCjm/RK6LxEJEgVWI/MpucBw+41TmPeFizxZJpmsZiFT4UfFpGp9un2Polmtnz
        sucK/zm6eBuNe84WFuSa/xCWiaxLRMU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-VSU1ZTIxPcqQRcIqDGmB1A-1; Fri, 05 Jun 2020 12:26:40 -0400
X-MC-Unique: VSU1ZTIxPcqQRcIqDGmB1A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB9C1107ACF2;
        Fri,  5 Jun 2020 16:26:39 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 666555D9DA;
        Fri,  5 Jun 2020 16:26:39 +0000 (UTC)
Date:   Fri, 5 Jun 2020 12:26:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/30] xfs: remove SYNC_WAIT from xfs_reclaim_inodes()
Message-ID: <20200605162637.GF23747@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-23-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604074606.266213-23-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 05:45:58PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Clean up xfs_reclaim_inodes() callers. Most callers want blocking
> behaviour, so just make the existing SYNC_WAIT behaviour the
> default.
> 
> For the xfs_reclaim_worker(), just call xfs_reclaim_inodes_ag()
> directly because we just want optimistic clean inode reclaim to be
> done in the background.
> 
> For xfs_quiesce_attr() we can just remove the inode reclaim calls as
> they are a historic relic that was required to flush dirty inodes
> that contained unlogged changes. We now log all changes to the
> inodes, so the sync AIL push from xfs_log_quiesce() called by
> xfs_quiesce_attr() will do all the required inode writeback for
> freeze.
> 

The above change should probably be a standalone patch, but not worth
changing at this point:

Reviewed-by: Brian Foster <bfoster@redhat.com>

BTW, is there any reason we continue to drain the buffer lru for freeze
as well?

Brian

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_icache.c | 48 ++++++++++++++++++++-------------------------
>  fs/xfs/xfs_icache.h |  2 +-
>  fs/xfs/xfs_mount.c  | 11 +++++------
>  fs/xfs/xfs_super.c  |  3 ---
>  4 files changed, 27 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index ebe55124d6cb8..a27470fc201ff 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -160,24 +160,6 @@ xfs_reclaim_work_queue(
>  	rcu_read_unlock();
>  }
>  
> -/*
> - * This is a fast pass over the inode cache to try to get reclaim moving on as
> - * many inodes as possible in a short period of time. It kicks itself every few
> - * seconds, as well as being kicked by the inode cache shrinker when memory
> - * goes low. It scans as quickly as possible avoiding locked inodes or those
> - * already being flushed, and once done schedules a future pass.
> - */
> -void
> -xfs_reclaim_worker(
> -	struct work_struct *work)
> -{
> -	struct xfs_mount *mp = container_of(to_delayed_work(work),
> -					struct xfs_mount, m_reclaim_work);
> -
> -	xfs_reclaim_inodes(mp, 0);
> -	xfs_reclaim_work_queue(mp);
> -}
> -
>  static void
>  xfs_perag_set_reclaim_tag(
>  	struct xfs_perag	*pag)
> @@ -1298,24 +1280,17 @@ xfs_reclaim_inodes_ag(
>  	return skipped;
>  }
>  
> -int
> +void
>  xfs_reclaim_inodes(
> -	xfs_mount_t	*mp,
> -	int		mode)
> +	struct xfs_mount	*mp)
>  {
>  	int		nr_to_scan = INT_MAX;
>  	int		skipped;
>  
> -	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
> -	if (!(mode & SYNC_WAIT))
> -		return 0;
> -
>  	do {
>  		xfs_ail_push_all_sync(mp->m_ail);
>  		skipped = xfs_reclaim_inodes_ag(mp, &nr_to_scan);
>  	} while (skipped > 0);
> -
> -	return 0;
>  }
>  
>  /*
> @@ -1434,6 +1409,25 @@ xfs_inode_matches_eofb(
>  	return true;
>  }
>  
> +/*
> + * This is a fast pass over the inode cache to try to get reclaim moving on as
> + * many inodes as possible in a short period of time. It kicks itself every few
> + * seconds, as well as being kicked by the inode cache shrinker when memory
> + * goes low. It scans as quickly as possible avoiding locked inodes or those
> + * already being flushed, and once done schedules a future pass.
> + */
> +void
> +xfs_reclaim_worker(
> +	struct work_struct *work)
> +{
> +	struct xfs_mount *mp = container_of(to_delayed_work(work),
> +					struct xfs_mount, m_reclaim_work);
> +	int		nr_to_scan = INT_MAX;
> +
> +	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
> +	xfs_reclaim_work_queue(mp);
> +}
> +
>  STATIC int
>  xfs_inode_free_eofblocks(
>  	struct xfs_inode	*ip,
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index 93b54e7d55f0d..ae92ca53de423 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -51,7 +51,7 @@ void xfs_inode_free(struct xfs_inode *ip);
>  
>  void xfs_reclaim_worker(struct work_struct *work);
>  
> -int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
> +void xfs_reclaim_inodes(struct xfs_mount *mp);
>  int xfs_reclaim_inodes_count(struct xfs_mount *mp);
>  long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 03158b42a1943..c8ae49a1e99c3 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1011,7 +1011,7 @@ xfs_mountfs(
>  	 * quota inodes.
>  	 */
>  	cancel_delayed_work_sync(&mp->m_reclaim_work);
> -	xfs_reclaim_inodes(mp, SYNC_WAIT);
> +	xfs_reclaim_inodes(mp);
>  	xfs_health_unmount(mp);
>   out_log_dealloc:
>  	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
> @@ -1088,13 +1088,12 @@ xfs_unmountfs(
>  	xfs_ail_push_all_sync(mp->m_ail);
>  
>  	/*
> -	 * And reclaim all inodes.  At this point there should be no dirty
> -	 * inodes and none should be pinned or locked, but use synchronous
> -	 * reclaim just to be sure. We can stop background inode reclaim
> -	 * here as well if it is still running.
> +	 * Reclaim all inodes. At this point there should be no dirty inodes and
> +	 * none should be pinned or locked. Stop background inode reclaim here
> +	 * if it is still running.
>  	 */
>  	cancel_delayed_work_sync(&mp->m_reclaim_work);
> -	xfs_reclaim_inodes(mp, SYNC_WAIT);
> +	xfs_reclaim_inodes(mp);
>  	xfs_health_unmount(mp);
>  
>  	xfs_qm_unmount(mp);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index fa58cb07c8fdf..9b03ea43f4fe7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -890,9 +890,6 @@ xfs_quiesce_attr(
>  	/* force the log to unpin objects from the now complete transactions */
>  	xfs_log_force(mp, XFS_LOG_SYNC);
>  
> -	/* reclaim inodes to do any IO before the freeze completes */
> -	xfs_reclaim_inodes(mp, 0);
> -	xfs_reclaim_inodes(mp, SYNC_WAIT);
>  
>  	/* Push the superblock and write an unmount record */
>  	error = xfs_log_sbcount(mp);
> -- 
> 2.26.2.761.g0e0b3e54be
> 

