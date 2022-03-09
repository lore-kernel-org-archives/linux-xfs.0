Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A86C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 23:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbiCIXh4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 18:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238895AbiCIXhs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 18:37:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A458E106C8D
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 15:36:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31112B8216F
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 23:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFB6C340EF;
        Wed,  9 Mar 2022 23:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646869004;
        bh=BzB8wTd9VqTX/2R6FhQMSmGkVvwqXQoViRCNHK0la+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hOCv1k2lThGQmIGdBouORjCpZ16ZtoKAVILV6Z/GQOkfyoo2kYdzJAd79WrMOlgJj
         NoZRjQwfsHfJR2HC+f8xMk7ZRyPMkoNCkVW+f99p8L1BJQ6fuyMY+o2slId74xoY+/
         8rDBCqqM8XzKwGiTy1tIYXphnu16LkpEFMmq7smnP/10X+03fDVqf/ISyt2Q0C9TqX
         A/rsVXE7iYJO5DnqTxxwDk2zBZiYMDsZBPS90dXxJb7streX7dokhpVr7VBWgXXqMg
         oXspLuvAUl++zRuIU3rHf7Who7ojm9x3tJgTTl9dAfwi1Mw/VhmcHsGUDxn33/8pUx
         h7apGiDpZ2BUA==
Date:   Wed, 9 Mar 2022 15:36:44 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: reserve quota for target dir expansion when
 renaming files
Message-ID: <20220309233644.GF8224@magnolia>
References: <164685374120.495923.2523387358442198692.stgit@magnolia>
 <164685375248.495923.9228795379646460264.stgit@magnolia>
 <20220309220553.GI661808@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309220553.GI661808@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 10, 2022 at 09:05:53AM +1100, Dave Chinner wrote:
> On Wed, Mar 09, 2022 at 11:22:32AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > XFS does not reserve quota for directory expansion when renaming
> > children into a directory.  This means that we don't reject the
> > expansion with EDQUOT when we're at or near a hard limit, which means
> > that unprivileged userspace can use rename() to exceed quota.
> > 
> > Rename operations don't always expand the target directory, and we allow
> > a rename to proceed with no space reservation if we don't need to add a
> > block to the target directory to handle the addition.  Moreover, the
> > unlink operation on the source directory generally does not expand the
> > directory (you'd have to free a block and then cause a btree split) and
> > it's probably of little consequence to leave the corner case that
> > renaming a file out of a directory can increase its size.
> > 
> > As with link and unlink, there is a further bug in that we do not
> > trigger the blockgc workers to try to clear space when we're out of
> > quota.
> > 
> > Because rename is its own special tricky animal, we'll patch xfs_rename
> > directly to reserve quota to the rename transaction.
> 
> Yeah, and this makes it even more tricky - the retry jumps back
> across the RENAME_EXCHANGE callout/exit from xfs_rename. At some
> point we need to clean up the spaghetti that rename has become.

Heh.  I did that as a cleanup to the directory code ahead of the
metadata directory tree patchset.

> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_inode.c |   37 ++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 36 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index a131bbfe74e4..8ff67b7aad53 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3095,7 +3095,8 @@ xfs_rename(
> >  	bool			new_parent = (src_dp != target_dp);
> >  	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
> >  	int			spaceres;
> > -	int			error;
> > +	bool			retried = false;
> > +	int			error, space_error;
> >  
> >  	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
> >  
> > @@ -3119,9 +3120,12 @@ xfs_rename(
> >  	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
> >  				inodes, &num_inodes);
> >  
> > +retry:
> > +	space_error = 0;
> >  	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
> >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0, 0, &tp);
> >  	if (error == -ENOSPC) {
> > +		space_error = error;
> 
> nospace_error.

Fixed.

> >  		spaceres = 0;
> >  		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, 0, 0, 0,
> >  				&tp);
> > @@ -3175,6 +3179,31 @@ xfs_rename(
> >  					target_dp, target_name, target_ip,
> >  					spaceres);
> >  
> > +	/*
> > +	 * Try to reserve quota to handle an expansion of the target directory.
> > +	 * We'll allow the rename to continue in reservationless mode if we hit
> > +	 * a space usage constraint.  If we trigger reservationless mode, save
> > +	 * the errno if there isn't any free space in the target directory.
> > +	 */
> > +	if (spaceres != 0) {
> > +		error = xfs_trans_reserve_quota_nblks(tp, target_dp, spaceres,
> > +				0, false);
> > +		if (error == -EDQUOT || error == -ENOSPC) {
> > +			if (!retried) {
> > +				xfs_trans_cancel(tp);
> > +				xfs_blockgc_free_quota(target_dp, 0);
> > +				retried = true;
> > +				goto retry;
> > +			}
> > +
> > +			space_error = error;
> > +			spaceres = 0;
> > +			error = 0;
> > +		}
> > +		if (error)
> > +			goto out_trans_cancel;
> > +	}
> > +
> >  	/*
> >  	 * Check for expected errors before we dirty the transaction
> >  	 * so we can return an error without a transaction abort.
> > @@ -3215,6 +3244,8 @@ xfs_rename(
> >  		 */
> >  		if (!spaceres) {
> >  			error = xfs_dir_canenter(tp, target_dp, target_name);
> > +			if (error == -ENOSPC && space_error)
> > +				error = space_error;
> 
> And move this error transformation to out_trans_cancel: so it only
> has to be coded once.
> 
> Other than that, it's about as clean as rename allows it to be right
> now.

Fixed.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
