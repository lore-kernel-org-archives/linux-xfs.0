Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46017C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 20:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA3252225E
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 20:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbhADU2v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 15:28:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725840AbhADU2v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 15:28:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609792045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JGwDtlV7tPH+Q2wgA6vAGbI2BojB6ZkCWJMkGaMOziI=;
        b=Yjo5YMZ6SPcCZiznjiPzNKmrRkp6Xl+ZGx/q18cwijBtP/GhcI2mF+EpYBrT6gH5bB4YBR
        XAYRCznXptZHgl7puLMl7NtpVvSyVv1FL5TwiO+N7Dsme7e5SqiLVrA6g5mwETPDH1iOnw
        bQbfAkg7phCEZZ+u+dxBRJK1oxmYLv0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-GrhpHtUjMW-s9GzotF2F-g-1; Mon, 04 Jan 2021 15:27:21 -0500
X-MC-Unique: GrhpHtUjMW-s9GzotF2F-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30DCC801817;
        Mon,  4 Jan 2021 20:27:20 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A67E71C8F;
        Mon,  4 Jan 2021 20:27:19 +0000 (UTC)
Date:   Mon, 4 Jan 2021 15:27:14 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     wenli xie <wlxie7296@gmail.com>, xfs <linux-xfs@vger.kernel.org>,
        chiluk@ubuntu.com
Subject: Re: [PATCH] xfs: fix an ABBA deadlock in xfs_rename
Message-ID: <20210104202714.GE254939@bfoster>
References: <20210104194437.GJ38809@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104194437.GJ38809@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 04, 2021 at 11:44:37AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When overlayfs is running on top of xfs and the user unlinks a file in
> the overlay, overlayfs will create a whiteout inode and ask xfs to
> "rename" the whiteout file atop the one being unlinked.  If the file
> being unlinked loses its one nlink, we then have to put the inode on the
> unlinked list.
> 
> This requires us to grab the AGI buffer of the whiteout inode to take it
> off the unlinked list (which is where whiteouts are created) and to grab
> the AGI buffer of the file being deleted.  If the whiteout was created
> in a higher numbered AG than the file being deleted, we'll lock the AGIs
> in the wrong order and deadlock.
> 
> Therefore, grab all the AGI locks we think we'll need ahead of time, and
> in the correct order.
> 
> Reported-by: wenli xie <wlxie7296@gmail.com>
> Tested-by: wenli xie <wlxie7296@gmail.com>
> Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b7352bc4c815..dd419a1bc6ba 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3000,6 +3000,48 @@ xfs_rename_alloc_whiteout(
>  	return 0;
>  }
>  
> +/*
> + * For the general case of renaming files, lock all the AGI buffers we need to
> + * handle bumping the nlink of the whiteout inode off the unlinked list and to
> + * handle dropping the nlink of the target inode.  We have to do this in
> + * increasing AG order to avoid deadlocks.
> + */
> +static int
> +xfs_rename_lock_agis(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*wip,
> +	struct xfs_inode	*target_ip)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_buf		*bp;
> +	xfs_agnumber_t		agi_locks[2] = { NULLAGNUMBER, NULLAGNUMBER };
> +	int			error;
> +
> +	if (wip)
> +		agi_locks[0] = XFS_INO_TO_AGNO(mp, wip->i_ino);
> +
> +	if (target_ip && VFS_I(target_ip)->i_nlink == 1)
> +		agi_locks[1] = XFS_INO_TO_AGNO(mp, target_ip->i_ino);
> +
> +	if (agi_locks[0] != NULLAGNUMBER && agi_locks[1] != NULLAGNUMBER &&
> +	    agi_locks[0] > agi_locks[1])
> +		swap(agi_locks[0], agi_locks[1]);
> +
> +	if (agi_locks[0] != NULLAGNUMBER) {
> +		error = xfs_read_agi(mp, tp, agi_locks[0], &bp);
> +		if (error)
> +			return error;
> +	}
> +
> +	if (agi_locks[1] != NULLAGNUMBER) {
> +		error = xfs_read_agi(mp, tp, agi_locks[1], &bp);
> +		if (error)
> +			return error;
> +	}
> +
> +	return 0;
> +}

This all looks reasonable to me, but I wonder if we can simplify
a bit by reusing the sorted inodes array we've already created earlier
in xfs_rename(). E.g., something like:

	for (i = 0; i < num_inodes; i++) {
		if (inodes[i] != wip && inodes[i] != target_ip)
			continue;
		error = xfs_read_agi(...);
		...
	}

IOW, similar to how xfs_lock_inodes() and xfs_qm_vop_rename_dqattach()
work.

Brian

> +
>  /*
>   * xfs_rename
>   */
> @@ -3130,6 +3172,10 @@ xfs_rename(
>  		}
>  	}
>  
> +	error = xfs_rename_lock_agis(tp, wip, target_ip);
> +	if (error)
> +		return error;
> +
>  	/*
>  	 * Directory entry creation below may acquire the AGF. Remove
>  	 * the whiteout from the unlinked list first to preserve correct
> 

