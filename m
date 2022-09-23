Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB320C07E9D
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 20:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbiIWUhw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbiIWUgu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 16:36:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072031296BD
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 13:31:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FD79B80AC7
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 20:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C7BC433C1;
        Fri, 23 Sep 2022 20:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663965064;
        bh=rQVYIW1Euga9rk56r13tEvwjmDWa78Z5y7WkaQ8v3HY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E6lYd9S3VnzneNclGU7owCwAjg95AG3jW1X8Ynk+B45SEPw311optEVQjNesPxcdh
         hbVs2aVQfUSuGwVEyfIUw5bmuPHzMwNdJ8igDViIqtNDAGruB+92Ke38SBXgFK/NYn
         Gm49NWEP2UBjXvEugl/CNbROHlbefhJXrO0duAqf5QRpPcy8drS+CX5mD1e2kjTala
         x4fgi5rhsImJ5fdcYo9cBLQyUPUg1MZGQwDcF9LGGZoeWx/FLFYWCCiwEw/vugGulA
         q6dLHqWSlYMOcgTNzJhon1QPyfLMRnxHsInhd0K79VE7Hm49QhfvS6K9J0z5Iw13vX
         KTuZ3GCDGkNqw==
Date:   Fri, 23 Sep 2022 13:31:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 15/26] xfs: add parent attributes to link
Message-ID: <Yy4XhkdToBRBnfbR@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-16-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922054458.40826-16-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2022 at 10:44:47PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch modifies xfs_link to add a parent pointer to the inode.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 44 +++++++++++++++++++++++++++++++++++---------
>  1 file changed, 35 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 181d6417412e..af3f5edb7319 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1228,14 +1228,16 @@ xfs_create_tmpfile(
>  
>  int
>  xfs_link(
> -	xfs_inode_t		*tdp,
> -	xfs_inode_t		*sip,
> +	struct xfs_inode	*tdp,
> +	struct xfs_inode	*sip,
>  	struct xfs_name		*target_name)
>  {
> -	xfs_mount_t		*mp = tdp->i_mount;
> -	xfs_trans_t		*tp;
> +	struct xfs_mount	*mp = tdp->i_mount;
> +	struct xfs_trans	*tp;
>  	int			error, nospace_error = 0;
>  	int			resblks;
> +	xfs_dir2_dataptr_t	diroffset;
> +	struct xfs_parent_defer	*parent = NULL;
>  
>  	trace_xfs_link(tdp, target_name);
>  
> @@ -1252,11 +1254,17 @@ xfs_link(
>  	if (error)
>  		goto std_return;
>  
> +	if (xfs_has_parent(mp)) {
> +		error = xfs_parent_init(mp, &parent);
> +		if (error)
> +			goto std_return;
> +	}
> +
>  	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);

Forwarding on from the v2 series --

This patch ought to be modifying XFS_LINK_SPACE_RES so that each link()
update reserves enough space to handle an expansion in the tdp directory
(as it does now) *and* an expansion in the xattr structure of the sip
child file.  This is how we avoid dipping into the free space reserve
pool midway through a transaction, and avoid shutdowns when space is
tight.

tr_res == space we reserve in the *log* to record updates.

XFS_LINK_SPACE_RES == block we reserve from the filesystem free space to
handle expansions of metadata structures.

At this point in this version of the patchset, you've increased the log
space reservations in anticipation of logging more information per
transaction.  However, you've not increased the free space reservations
to handle potential node splitting in the ondisk xattr btree.

(The rest of the patchset looks ok.)

--D

>  	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
>  			&tp, &nospace_error);
>  	if (error)
> -		goto std_return;
> +		goto drop_incompat;
>  
>  	/*
>  	 * If we are using project inheritance, we only allow hard link
> @@ -1289,14 +1297,27 @@ xfs_link(
>  	}
>  
>  	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
> -				   resblks, NULL);
> +				   resblks, &diroffset);
>  	if (error)
> -		goto error_return;
> +		goto out_defer_cancel;
>  	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
>  
>  	xfs_bumplink(tp, sip);
>  
> +	/*
> +	 * If we have parent pointers, we now need to add the parent record to
> +	 * the attribute fork of the inode. If this is the initial parent
> +	 * attribute, we need to create it correctly, otherwise we can just add
> +	 * the parent to the inode.
> +	 */
> +	if (parent) {
> +		error = xfs_parent_defer_add(tp, parent, tdp, target_name,
> +					     diroffset, sip);
> +		if (error)
> +			goto out_defer_cancel;
> +	}
> +
>  	/*
>  	 * If this is a synchronous mount, make sure that the
>  	 * link transaction goes to disk before returning to
> @@ -1310,11 +1331,16 @@ xfs_link(
>  	xfs_iunlock(sip, XFS_ILOCK_EXCL);
>  	return error;
>  
> - error_return:
> +out_defer_cancel:
> +	xfs_defer_cancel(tp);
> +error_return:
>  	xfs_trans_cancel(tp);
>  	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
>  	xfs_iunlock(sip, XFS_ILOCK_EXCL);
> - std_return:
> +drop_incompat:
> +	if (parent)
> +		xfs_parent_cancel(mp, parent);
> +std_return:
>  	if (error == -ENOSPC && nospace_error)
>  		error = nospace_error;
>  	return error;
> -- 
> 2.25.1
> 
