Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA945C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 15:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ACB222795
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 15:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbhALPE1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 10:04:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43961 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728681AbhALPE1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 10:04:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610463780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dimqZiGlX9/7v5Q3qlgshw8AJbWwdy0YRmLTR8vpO9Q=;
        b=ZhzUcOeEBwi2b0oIJl8gj+PKvvezVhObT5vKa26QfCrny66HffT/XqRS9dRIfhOb0Cl2jc
        lOsVY50zEyHygeDSYBqnVo2LkeBfoLD5oRbpHUmhuLNWUpAYJNo1GLq0xNVW9oiZGPEQBS
        l8mSbl96aD8iqCkLZp6JjAM85WFI57g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-7Oa433DNNA-A63vwn9G8ag-1; Tue, 12 Jan 2021 10:02:58 -0500
X-MC-Unique: 7Oa433DNNA-A63vwn9G8ag-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5805C8145E3;
        Tue, 12 Jan 2021 15:02:57 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AC35518E4D;
        Tue, 12 Jan 2021 15:02:56 +0000 (UTC)
Date:   Tue, 12 Jan 2021 10:02:54 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     wenli xie <wlxie7296@gmail.com>, xfs <linux-xfs@vger.kernel.org>,
        chiluk@ubuntu.com, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs: fix an ABBA deadlock in xfs_rename
Message-ID: <20210112150254.GA1137163@bfoster>
References: <20210111225053.GE1164246@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111225053.GE1164246@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 02:50:53PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> Subject: [PATCH] xfs: fix an ABBA deadlock in xfs_rename
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
> in order of increasing AG number per the locking rules.
> 
> Reported-by: wenli xie <wlxie7296@gmail.com>
> Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: Make it more obvious that we're grabbing all the AGI locks ahead of
> the AGFs, and hide functions that we don't need to export anymore.
> v3: condense the predicate code even further
> ---

Looks good, thanks for the tweaks:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_dir2.h    |    2 --
>  fs/xfs/libxfs/xfs_dir2_sf.c |    2 +-
>  fs/xfs/xfs_inode.c          |   42 +++++++++++++++++++++++++-----------------
>  3 files changed, 26 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index e55378640b05..d03e6098ded9 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -47,8 +47,6 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
>  extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
>  				struct xfs_name *name, xfs_ino_t ino,
>  				xfs_extlen_t tot);
> -extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
> -				xfs_ino_t inum);
>  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
>  				struct xfs_name *name, xfs_ino_t inum,
>  				xfs_extlen_t tot);
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 2463b5d73447..8c4f76bba88b 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -1018,7 +1018,7 @@ xfs_dir2_sf_removename(
>  /*
>   * Check whether the sf dir replace operation need more blocks.
>   */
> -bool
> +static bool
>  xfs_dir2_sf_replace_needblock(
>  	struct xfs_inode	*dp,
>  	xfs_ino_t		inum)
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b7352bc4c815..e5dc41b10ebb 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3017,7 +3017,7 @@ xfs_rename(
>  	struct xfs_trans	*tp;
>  	struct xfs_inode	*wip = NULL;		/* whiteout inode */
>  	struct xfs_inode	*inodes[__XFS_SORT_INODES];
> -	struct xfs_buf		*agibp;
> +	int			i;
>  	int			num_inodes = __XFS_SORT_INODES;
>  	bool			new_parent = (src_dp != target_dp);
>  	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
> @@ -3130,6 +3130,30 @@ xfs_rename(
>  		}
>  	}
>  
> +	/*
> +	 * Lock the AGI buffers we need to handle bumping the nlink of the
> +	 * whiteout inode off the unlinked list and to handle dropping the
> +	 * nlink of the target inode.  Per locking order rules, do this in
> +	 * increasing AG order and before directory block allocation tries to
> +	 * grab AGFs because we grab AGIs before AGFs.
> +	 *
> +	 * The (vfs) caller must ensure that if src is a directory then
> +	 * target_ip is either null or an empty directory.
> +	 */
> +	for (i = 0; i < num_inodes && inodes[i] != NULL; i++) {
> +		if (inodes[i] == wip ||
> +		    (inodes[i] == target_ip &&
> +		     (VFS_I(target_ip)->i_nlink == 1 || src_is_directory))) {
> +			struct xfs_buf	*bp;
> +			xfs_agnumber_t	agno;
> +
> +			agno = XFS_INO_TO_AGNO(mp, inodes[i]->i_ino);
> +			error = xfs_read_agi(mp, tp, agno, &bp);
> +			if (error)
> +				goto out_trans_cancel;
> +		}
> +	}
> +
>  	/*
>  	 * Directory entry creation below may acquire the AGF. Remove
>  	 * the whiteout from the unlinked list first to preserve correct
> @@ -3182,22 +3206,6 @@ xfs_rename(
>  		 * In case there is already an entry with the same
>  		 * name at the destination directory, remove it first.
>  		 */
> -
> -		/*
> -		 * Check whether the replace operation will need to allocate
> -		 * blocks.  This happens when the shortform directory lacks
> -		 * space and we have to convert it to a block format directory.
> -		 * When more blocks are necessary, we must lock the AGI first
> -		 * to preserve locking order (AGI -> AGF).
> -		 */
> -		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
> -			error = xfs_read_agi(mp, tp,
> -					XFS_INO_TO_AGNO(mp, target_ip->i_ino),
> -					&agibp);
> -			if (error)
> -				goto out_trans_cancel;
> -		}
> -
>  		error = xfs_dir_replace(tp, target_dp, target_name,
>  					src_ip->i_ino, spaceres);
>  		if (error)
> 

