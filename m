Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B29C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 13:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59B6F2076A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 13:30:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aMxgL4uH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgCYNaj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 09:30:39 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:32343 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726967AbgCYNai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 09:30:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585143036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KZ3jf/gkWV6fDUlLBZ7p1AIYAvyU65stu2h3oDNIZI4=;
        b=aMxgL4uHT9SOJ2NyaWjdHoWFFHQTeHzLFTJLevCfA5Wr9RlQ9zZkhccTmx3+3cdrhr9cLR
        V79KzUvEJPlXdoe/q75wOxVZL0VZg72fTpjubm2UeJcASyo+IFs3USnZSsjWpqqzsXNQ0N
        KHZyMZugK7s3RwsCRgaJwZfG+YOjlIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-NiBr0WSGM2efV5xnJnWRnQ-1; Wed, 25 Mar 2020 09:30:35 -0400
X-MC-Unique: NiBr0WSGM2efV5xnJnWRnQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D34A107ACC4;
        Wed, 25 Mar 2020 13:30:34 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 13C8194B42;
        Wed, 25 Mar 2020 13:30:34 +0000 (UTC)
Date:   Wed, 25 Mar 2020 09:30:32 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: factor common AIL item deletion code
Message-ID: <20200325133032.GB11912@bfoster>
References: <20200325014205.11843-1-david@fromorbit.com>
 <20200325014205.11843-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325014205.11843-7-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 12:42:03PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Factor the common AIL deletion code that does all the wakeups into a
> helper so we only have one copy of this somewhat tricky code to
> interface with all the wakeups necessary when the LSN of the log
> tail changes.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode_item.c | 12 +----------
>  fs/xfs/xfs_trans_ail.c  | 48 ++++++++++++++++++++++-------------------
>  fs/xfs/xfs_trans_priv.h |  4 +++-
>  3 files changed, 30 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 4a3d13d4a0228..bd8c368098707 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -742,17 +742,7 @@ xfs_iflush_done(
>  				xfs_clear_li_failed(blip);
>  			}
>  		}
> -
> -		if (mlip_changed) {
> -			if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
> -				xlog_assign_tail_lsn_locked(ailp->ail_mount);
> -			if (list_empty(&ailp->ail_head))
> -				wake_up_all(&ailp->ail_empty);
> -		}
> -		spin_unlock(&ailp->ail_lock);
> -
> -		if (mlip_changed)
> -			xfs_log_space_wake(ailp->ail_mount);
> +		xfs_ail_update_finish(ailp, mlip_changed);
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 2ef0dfbfb303d..26d2e7928121c 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -681,6 +681,27 @@ xfs_ail_push_all_sync(
>  	finish_wait(&ailp->ail_empty, &wait);
>  }
>  
> +void
> +xfs_ail_update_finish(
> +	struct xfs_ail		*ailp,
> +	bool			do_tail_update) __releases(ailp->ail_lock)
> +{
> +	struct xfs_mount	*mp = ailp->ail_mount;
> +
> +	if (!do_tail_update) {
> +		spin_unlock(&ailp->ail_lock);
> +		return;
> +	}
> +
> +	if (!XFS_FORCED_SHUTDOWN(mp))
> +		xlog_assign_tail_lsn_locked(mp);
> +
> +	if (list_empty(&ailp->ail_head))
> +		wake_up_all(&ailp->ail_empty);
> +	spin_unlock(&ailp->ail_lock);
> +	xfs_log_space_wake(mp);
> +}
> +
>  /*
>   * xfs_trans_ail_update - bulk AIL insertion operation.
>   *
> @@ -740,15 +761,7 @@ xfs_trans_ail_update_bulk(
>  	if (!list_empty(&tmp))
>  		xfs_ail_splice(ailp, cur, &tmp, lsn);
>  
> -	if (mlip_changed) {
> -		if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
> -			xlog_assign_tail_lsn_locked(ailp->ail_mount);
> -		spin_unlock(&ailp->ail_lock);
> -
> -		xfs_log_space_wake(ailp->ail_mount);
> -	} else {
> -		spin_unlock(&ailp->ail_lock);
> -	}
> +	xfs_ail_update_finish(ailp, mlip_changed);
>  }
>  
>  bool
> @@ -792,10 +805,10 @@ void
>  xfs_trans_ail_delete(
>  	struct xfs_ail		*ailp,
>  	struct xfs_log_item	*lip,
> -	int			shutdown_type) __releases(ailp->ail_lock)
> +	int			shutdown_type)
>  {
>  	struct xfs_mount	*mp = ailp->ail_mount;
> -	bool			mlip_changed;
> +	bool			need_update;
>  
>  	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
>  		spin_unlock(&ailp->ail_lock);
> @@ -808,17 +821,8 @@ xfs_trans_ail_delete(
>  		return;
>  	}
>  
> -	mlip_changed = xfs_ail_delete_one(ailp, lip);
> -	if (mlip_changed) {
> -		if (!XFS_FORCED_SHUTDOWN(mp))
> -			xlog_assign_tail_lsn_locked(mp);
> -		if (list_empty(&ailp->ail_head))
> -			wake_up_all(&ailp->ail_empty);
> -	}
> -
> -	spin_unlock(&ailp->ail_lock);
> -	if (mlip_changed)
> -		xfs_log_space_wake(ailp->ail_mount);
> +	need_update = xfs_ail_delete_one(ailp, lip);
> +	xfs_ail_update_finish(ailp, need_update);
>  }
>  
>  int
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 2e073c1c4614f..64ffa746730e4 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -92,8 +92,10 @@ xfs_trans_ail_update(
>  }
>  
>  bool xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
> +void xfs_ail_update_finish(struct xfs_ail *ailp, bool do_tail_update)
> +			__releases(ailp->ail_lock);
>  void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip,
> -		int shutdown_type) __releases(ailp->ail_lock);
> +		int shutdown_type);
>  
>  static inline void
>  xfs_trans_ail_remove(
> -- 
> 2.26.0.rc2
> 

