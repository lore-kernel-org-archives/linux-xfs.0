Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE485C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 15:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACC8420679
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 15:02:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HoKd+KuE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgFCPCm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 11:02:42 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42536 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725930AbgFCPCm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 11:02:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591196560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BLE9IEP84fFJdTvbuNFCXtlTTcwE+G/KDQkbWa0YsgI=;
        b=HoKd+KuEypX2mb0/L+iQAtMHxZseyyp5XqMs9uGZh6D6bBl+O1RjD0gJnwNMvKQRNQV3ID
        EcC8HBE0nW1+5hxhBLiLsHwDmvojjJH4KD1DpZYqtMY7mdLzvzOFb0z0tAZtxIg35DaauG
        HMuLgwK4rp1zstfid8cy6NjU1kMZ42g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-UPyfI3I4Njq2QQ5z0rp5BA-1; Wed, 03 Jun 2020 11:02:39 -0400
X-MC-Unique: UPyfI3I4Njq2QQ5z0rp5BA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E425DFD9B;
        Wed,  3 Jun 2020 15:02:25 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 04A6E5C240;
        Wed,  3 Jun 2020 15:02:24 +0000 (UTC)
Date:   Wed, 3 Jun 2020 11:02:23 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/30] xfs: move xfs_clear_li_failed out of
 xfs_ail_delete_one()
Message-ID: <20200603150223.GI12332@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-16-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-16-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:36AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_ail_delete_one() is called directly from dquot and inode IO
> completion, as well as from the generic xfs_trans_ail_delete()
> function. Inodes are about to have their own failure handling, and
> dquots will in future, too. Pull the clearing of the LI_FAILED flag
> up into the callers so we can customise the code appropriately.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_dquot.c      | 6 +-----
>  fs/xfs/xfs_inode_item.c | 3 +--
>  fs/xfs/xfs_trans_ail.c  | 2 +-
>  3 files changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index d5984a926d1d0..76353c9a723ee 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1070,16 +1070,12 @@ xfs_qm_dqflush_done(
>  	     test_bit(XFS_LI_FAILED, &lip->li_flags))) {
>  
>  		spin_lock(&ailp->ail_lock);
> +		xfs_clear_li_failed(lip);
>  		if (lip->li_lsn == qip->qli_flush_lsn) {
>  			/* xfs_ail_update_finish() drops the AIL lock */
>  			tail_lsn = xfs_ail_delete_one(ailp, lip);
>  			xfs_ail_update_finish(ailp, tail_lsn);
>  		} else {
> -			/*
> -			 * Clear the failed state since we are about to drop the
> -			 * flush lock
> -			 */
> -			xfs_clear_li_failed(lip);
>  			spin_unlock(&ailp->ail_lock);
>  		}
>  	}
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 86c783dec2bac..0ba75764a8dc5 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -690,12 +690,11 @@ xfs_iflush_done(
>  		/* this is an opencoded batch version of xfs_trans_ail_delete */
>  		spin_lock(&ailp->ail_lock);
>  		list_for_each_entry(lip, &tmp, li_bio_list) {
> +			xfs_clear_li_failed(lip);
>  			if (lip->li_lsn == INODE_ITEM(lip)->ili_flush_lsn) {
>  				xfs_lsn_t lsn = xfs_ail_delete_one(ailp, lip);
>  				if (!tail_lsn && lsn)
>  					tail_lsn = lsn;
> -			} else {
> -				xfs_clear_li_failed(lip);
>  			}
>  		}
>  		xfs_ail_update_finish(ailp, tail_lsn);
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index ac5019361a139..ac33f6393f99c 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -843,7 +843,6 @@ xfs_ail_delete_one(
>  
>  	trace_xfs_ail_delete(lip, mlip->li_lsn, lip->li_lsn);
>  	xfs_ail_delete(ailp, lip);
> -	xfs_clear_li_failed(lip);
>  	clear_bit(XFS_LI_IN_AIL, &lip->li_flags);
>  	lip->li_lsn = 0;
>  
> @@ -874,6 +873,7 @@ xfs_trans_ail_delete(
>  	}
>  
>  	/* xfs_ail_update_finish() drops the AIL lock */
> +	xfs_clear_li_failed(lip);
>  	tail_lsn = xfs_ail_delete_one(ailp, lip);
>  	xfs_ail_update_finish(ailp, tail_lsn);
>  }
> -- 
> 2.26.2.761.g0e0b3e54be
> 

