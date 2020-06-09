Return-Path: <SRS0=Wnnb=7W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D108AC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 13:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3C5C2074B
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 13:12:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="InO7ydeQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgFINM5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 09:12:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23169 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728404AbgFINMz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jun 2020 09:12:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591708374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VAZN4TpnGXyG8pe22FeVzvfhD/Ysk1x2VDGMVvJaf4Q=;
        b=InO7ydeQ/imTXZC4NtgJjoeNsORWsDrU0c7vFn1adQeXWRS9sRwplLl0g5ANRsE0+xGLN9
        FgnQW09ncN3OAwRFxwuX/HoR63RYXJpQp0IeemQuXkmRyfWA4N3C8huDTCaRKSDQJ8mUmA
        F2h0Ay+Utsq20mYRJQ/iiKJNB7s3n3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-pymzKLVYPImGId18jctJIg-1; Tue, 09 Jun 2020 09:12:52 -0400
X-MC-Unique: pymzKLVYPImGId18jctJIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6220E34772;
        Tue,  9 Jun 2020 13:12:51 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E7FB5100EBA4;
        Tue,  9 Jun 2020 13:12:50 +0000 (UTC)
Date:   Tue, 9 Jun 2020 09:12:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/30] xfs: factor xfs_iflush_done
Message-ID: <20200609131249.GC40899@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-30-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604074606.266213-30-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 05:46:05PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_iflush_done() does 3 distinct operations to the inodes attached
> to the buffer. Separate these operations out into functions so that
> it is easier to modify these operations independently in future.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode_item.c | 154 +++++++++++++++++++++-------------------
>  1 file changed, 81 insertions(+), 73 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index dee7385466f83..3894d190ea5b9 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -640,101 +640,64 @@ xfs_inode_item_destroy(
>  
>  
>  /*
> - * This is the inode flushing I/O completion routine.  It is called
> - * from interrupt level when the buffer containing the inode is
> - * flushed to disk.  It is responsible for removing the inode item
> - * from the AIL if it has not been re-logged, and unlocking the inode's
> - * flush lock.
> - *
> - * To reduce AIL lock traffic as much as possible, we scan the buffer log item
> - * list for other inodes that will run this function. We remove them from the
> - * buffer list so we can process all the inode IO completions in one AIL lock
> - * traversal.
> - *
> - * Note: Now that we attach the log item to the buffer when we first log the
> - * inode in memory, we can have unflushed inodes on the buffer list here. These
> - * inodes will have a zero ili_last_fields, so skip over them here.
> + * We only want to pull the item from the AIL if it is actually there
> + * and its location in the log has not changed since we started the
> + * flush.  Thus, we only bother if the inode's lsn has not changed.
>   */
>  void
> -xfs_iflush_done(
> -	struct xfs_buf		*bp)
> +xfs_iflush_ail_updates(
> +	struct xfs_ail		*ailp,
> +	struct list_head	*list)
>  {
> -	struct xfs_inode_log_item *iip;
> -	struct xfs_log_item	*lip, *n;
> -	struct xfs_ail		*ailp = bp->b_mount->m_ail;
> -	int			need_ail = 0;
> -	LIST_HEAD(tmp);
> +	struct xfs_log_item	*lip;
> +	xfs_lsn_t		tail_lsn = 0;
>  
> -	/*
> -	 * Pull the attached inodes from the buffer one at a time and take the
> -	 * appropriate action on them.
> -	 */
> -	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
> -		iip = INODE_ITEM(lip);
> +	/* this is an opencoded batch version of xfs_trans_ail_delete */
> +	spin_lock(&ailp->ail_lock);
> +	list_for_each_entry(lip, list, li_bio_list) {
> +		xfs_lsn_t	lsn;
>  
> -		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
> -			xfs_iflush_abort(iip->ili_inode);
> +		if (INODE_ITEM(lip)->ili_flush_lsn != lip->li_lsn) {
> +			clear_bit(XFS_LI_FAILED, &lip->li_flags);
>  			continue;
>  		}

That seems like strange logic. Shouldn't we clear LI_FAILED regardless?

>  
> -		if (!iip->ili_last_fields)
> -			continue;
> -
> -		list_move_tail(&lip->li_bio_list, &tmp);
> -
> -		/* Do an unlocked check for needing the AIL lock. */
> -		if (iip->ili_flush_lsn == lip->li_lsn ||
> -		    test_bit(XFS_LI_FAILED, &lip->li_flags))
> -			need_ail++;
> +		lsn = xfs_ail_delete_one(ailp, lip);
> +		if (!tail_lsn && lsn)
> +			tail_lsn = lsn;
>  	}
> +	xfs_ail_update_finish(ailp, tail_lsn);
> +}
>  
...
> @@ -745,6 +708,51 @@ xfs_iflush_done(
>  	}
>  }
>  
> +/*
> + * Inode buffer IO completion routine.  It is responsible for removing inodes
> + * attached to the buffer from the AIL if they have not been re-logged, as well
> + * as completing the flush and unlocking the inode.
> + */
> +void
> +xfs_iflush_done(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_log_item	*lip, *n;
> +	LIST_HEAD(flushed_inodes);
> +	LIST_HEAD(ail_updates);
> +
> +	/*
> +	 * Pull the attached inodes from the buffer one at a time and take the
> +	 * appropriate action on them.
> +	 */
> +	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
> +		struct xfs_inode_log_item *iip = INODE_ITEM(lip);
> +
> +		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
> +			xfs_iflush_abort(iip->ili_inode);
> +			continue;
> +		}
> +		if (!iip->ili_last_fields)
> +			continue;
> +
> +		/* Do an unlocked check for needing the AIL lock. */
> +		if (iip->ili_flush_lsn == lip->li_lsn ||
> +		    test_bit(XFS_LI_FAILED, &lip->li_flags))
> +			list_move_tail(&lip->li_bio_list, &ail_updates);
> +		else
> +			list_move_tail(&lip->li_bio_list, &flushed_inodes);

Not sure I see the point of having two lists here, particularly since
this is all based on lockless logic. At the very least it's a subtle
change in AIL processing logic and I don't think that should be buried
in a refactoring patch.

Brian

> +	}
> +
> +	if (!list_empty(&ail_updates)) {
> +		xfs_iflush_ail_updates(bp->b_mount->m_ail, &ail_updates);
> +		list_splice_tail(&ail_updates, &flushed_inodes);
> +	}
> +
> +	xfs_iflush_finish(bp, &flushed_inodes);
> +	if (!list_empty(&flushed_inodes))
> +		list_splice_tail(&flushed_inodes, &bp->b_li_list);
> +}
> +
>  /*
>   * This is the inode flushing abort routine.  It is called from xfs_iflush when
>   * the filesystem is shutting down to clean up the inode state.  It is
> -- 
> 2.26.2.761.g0e0b3e54be
> 

