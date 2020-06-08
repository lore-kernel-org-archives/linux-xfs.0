Return-Path: <SRS0=8d1d=7V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70FBC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 16:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A784F2078C
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 16:45:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K5unNcuz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbgFHQpT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 12:45:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22960 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730490AbgFHQpS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jun 2020 12:45:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591634717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M1qYEHlFiJZvgn3LiOD87B7D5VL/le1bQrAReP/MeRI=;
        b=K5unNcuzfWSCyStRTW0jTMchC7cEYFEQMOHPHBhGsQLDLkSqgx+90yhMETYMZ9m/Ee/fD5
        Fnr5Q15nLgl2UN5iIwDSnsml1BhSRqFE0cJWPkYiYSTQmtkuAancj3QFbmu1w9VAMcRoRU
        07hrY2bGfWUN+U7zWPSMxG9pjiPsFcM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-2QjGrioaODGiGVB2FivwBw-1; Mon, 08 Jun 2020 12:45:06 -0400
X-MC-Unique: 2QjGrioaODGiGVB2FivwBw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A2B8107ACCA;
        Mon,  8 Jun 2020 16:45:05 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 002A87F4F4;
        Mon,  8 Jun 2020 16:45:04 +0000 (UTC)
Date:   Mon, 8 Jun 2020 12:45:03 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/30] xfs: attach inodes to the cluster buffer when
 dirtied
Message-ID: <20200608164503.GC36278@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-26-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604074606.266213-26-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 05:46:01PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Rather than attach inodes to the cluster buffer just when we are
> doing IO, attach the inodes to the cluster buffer when they are
> dirtied. The means the buffer always carries a list of dirty inodes
> that reference it, and we can use that list to make more fundamental
> changes to inode writeback that aren't otherwise possible.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_trans_inode.c |  9 ++++++---
>  fs/xfs/xfs_buf_item.c           |  1 +
>  fs/xfs/xfs_icache.c             |  1 +
>  fs/xfs/xfs_inode.c              | 24 +++++-------------------
>  fs/xfs/xfs_inode_item.c         | 16 ++++++++++++++--
>  5 files changed, 27 insertions(+), 24 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 64bdda72f7b27..697248b7eb2be 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -660,6 +660,10 @@ xfs_inode_item_destroy(
>   * list for other inodes that will run this function. We remove them from the
>   * buffer list so we can process all the inode IO completions in one AIL lock
>   * traversal.
> + *
> + * Note: Now that we attach the log item to the buffer when we first log the
> + * inode in memory, we can have unflushed inodes on the buffer list here. These
> + * inodes will have a zero ili_last_fields, so skip over them here.
>   */
>  void
>  xfs_iflush_done(
> @@ -677,12 +681,15 @@ xfs_iflush_done(
>  	 */
>  	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
>  		iip = INODE_ITEM(lip);
> +
>  		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
> -			list_del_init(&lip->li_bio_list);
>  			xfs_iflush_abort(iip->ili_inode);
>  			continue;
>  		}
>  
> +		if (!iip->ili_last_fields)
> +			continue;
> +

If I follow the comment above this is essentially a proxy for checking
whether the inode is flushed. IOW, could this eventually be replaced
with the state flag check based on the cleanup discussed in the previous
patch, right?

Otherwise LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  		list_move_tail(&lip->li_bio_list, &tmp);
>  
>  		/* Do an unlocked check for needing the AIL lock. */
> @@ -728,12 +735,16 @@ xfs_iflush_done(
>  		/*
>  		 * Remove the reference to the cluster buffer if the inode is
>  		 * clean in memory. Drop the buffer reference once we've dropped
> -		 * the locks we hold.
> +		 * the locks we hold. If the inode is dirty in memory, we need
> +		 * to put the inode item back on the buffer list for another
> +		 * pass through the flush machinery.
>  		 */
>  		ASSERT(iip->ili_item.li_buf == bp);
>  		if (!iip->ili_fields) {
>  			iip->ili_item.li_buf = NULL;
>  			drop_buffer = true;
> +		} else {
> +			list_add(&lip->li_bio_list, &bp->b_li_list);
>  		}
>  		iip->ili_last_fields = 0;
>  		iip->ili_flush_lsn = 0;
> @@ -777,6 +788,7 @@ xfs_iflush_abort(
>  		iip->ili_flush_lsn = 0;
>  		bp = iip->ili_item.li_buf;
>  		iip->ili_item.li_buf = NULL;
> +		list_del_init(&iip->ili_item.li_bio_list);
>  		spin_unlock(&iip->ili_lock);
>  	}
>  	xfs_ifunlock(ip);
> -- 
> 2.26.2.761.g0e0b3e54be
> 

