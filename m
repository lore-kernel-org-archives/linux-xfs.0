Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDEAEC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 16:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354065AbiFVQlP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 12:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbiFVQlN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 12:41:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521A837039;
        Wed, 22 Jun 2022 09:41:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1758EB82049;
        Wed, 22 Jun 2022 16:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC559C3411D;
        Wed, 22 Jun 2022 16:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655916069;
        bh=XIP5LRYDkeF98zlbsg4BecFEkOr6+9RUVWECCXixwvw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rCr4sbvvbKm/Lw8W/uaCtuz5g9da445nnzGzOcANlyB9VbtfNBlezadkmG2DCMxth
         pYUP2EMaD2mvD5+5dZOF0Ua+i7UbOMDG+BsU4nBaGJBt8K5iQsJ4b/Zzf/Hupr+S7f
         LKk1Pj8p+jdpq2cr7osvzv6kYuzUwEgKq31mit4Dpg9eStewdYdE6jgfOqV8DbnsQc
         heHV4aO1Lczu4H88x4t+gj0jSEMj4PnQ0A++44tcz9+RRpk4XAH//QeP414UwWPYA4
         DA22k3FzB+TTFyZFebyYfWuwylUWMpwtzTilGlm9YGEeZ8WQV8ihcnusbX+mVIC2Ce
         MHHl5TaLS3LPA==
Date:   Wed, 22 Jun 2022 09:41:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 5.10 CANDIDATE 11/11] xfs: use setattr_copy to set vfs
 inode attributes
Message-ID: <YrNGJXYi2jQtPxs0@magnolia>
References: <20220617100641.1653164-1-amir73il@gmail.com>
 <20220617100641.1653164-12-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617100641.1653164-12-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 17, 2022 at 01:06:41PM +0300, Amir Goldstein wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> commit e014f37db1a2d109afa750042ac4d69cf3e3d88e upstream.
> 
> [remove userns argument of setattr_copy() for backport]
> 
> Filipe Manana pointed out that XFS' behavior w.r.t. setuid/setgid
> revocation isn't consistent with btrfs[1] or ext4.  Those two
> filesystems use the VFS function setattr_copy to convey certain
> attributes from struct iattr into the VFS inode structure.
> 
> Andrey Zhadchenko reported[2] that XFS uses the wrong user namespace to
> decide if it should clear setgid and setuid on a file attribute update.
> This is a second symptom of the problem that Filipe noticed.
> 
> XFS, on the other hand, open-codes setattr_copy in xfs_setattr_mode,
> xfs_setattr_nonsize, and xfs_setattr_time.  Regrettably, setattr_copy is
> /not/ a simple copy function; it contains additional logic to clear the
> setgid bit when setting the mode, and XFS' version no longer matches.
> 
> The VFS implements its own setuid/setgid stripping logic, which
> establishes consistent behavior.  It's a tad unfortunate that it's
> scattered across notify_change, should_remove_suid, and setattr_copy but
> XFS should really follow the Linux VFS.  Adapt XFS to use the VFS
> functions and get rid of the old functions.
> 
> [1] https://lore.kernel.org/fstests/CAL3q7H47iNQ=Wmk83WcGB-KBJVOEtR9+qGczzCeXJ9Y2KCV25Q@mail.gmail.com/
> [2] https://lore.kernel.org/linux-xfs/20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com/
> 
> Fixes: 7fa294c8991c ("userns: Allow chown and setgid preservation")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Same question as I posted to Leah's series -- have all the necessary VFS
fixes and whatnot been backported to 5.10?  Such that all the new sgid
inheritance tests actually pass with this patch applied? :)

--D

> ---
>  fs/xfs/xfs_iops.c | 56 +++--------------------------------------------
>  fs/xfs/xfs_pnfs.c |  3 ++-
>  2 files changed, 5 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index b7f7b31a77d5..5711c8c12625 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -595,37 +595,6 @@ xfs_vn_getattr(
>  	return 0;
>  }
>  
> -static void
> -xfs_setattr_mode(
> -	struct xfs_inode	*ip,
> -	struct iattr		*iattr)
> -{
> -	struct inode		*inode = VFS_I(ip);
> -	umode_t			mode = iattr->ia_mode;
> -
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -
> -	inode->i_mode &= S_IFMT;
> -	inode->i_mode |= mode & ~S_IFMT;
> -}
> -
> -void
> -xfs_setattr_time(
> -	struct xfs_inode	*ip,
> -	struct iattr		*iattr)
> -{
> -	struct inode		*inode = VFS_I(ip);
> -
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -
> -	if (iattr->ia_valid & ATTR_ATIME)
> -		inode->i_atime = iattr->ia_atime;
> -	if (iattr->ia_valid & ATTR_CTIME)
> -		inode->i_ctime = iattr->ia_ctime;
> -	if (iattr->ia_valid & ATTR_MTIME)
> -		inode->i_mtime = iattr->ia_mtime;
> -}
> -
>  static int
>  xfs_vn_change_ok(
>  	struct dentry	*dentry,
> @@ -740,16 +709,6 @@ xfs_setattr_nonsize(
>  				goto out_cancel;
>  		}
>  
> -		/*
> -		 * CAP_FSETID overrides the following restrictions:
> -		 *
> -		 * The set-user-ID and set-group-ID bits of a file will be
> -		 * cleared upon successful return from chown()
> -		 */
> -		if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
> -		    !capable(CAP_FSETID))
> -			inode->i_mode &= ~(S_ISUID|S_ISGID);
> -
>  		/*
>  		 * Change the ownerships and register quota modifications
>  		 * in the transaction.
> @@ -761,7 +720,6 @@ xfs_setattr_nonsize(
>  				olddquot1 = xfs_qm_vop_chown(tp, ip,
>  							&ip->i_udquot, udqp);
>  			}
> -			inode->i_uid = uid;
>  		}
>  		if (!gid_eq(igid, gid)) {
>  			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
> @@ -772,15 +730,10 @@ xfs_setattr_nonsize(
>  				olddquot2 = xfs_qm_vop_chown(tp, ip,
>  							&ip->i_gdquot, gdqp);
>  			}
> -			inode->i_gid = gid;
>  		}
>  	}
>  
> -	if (mask & ATTR_MODE)
> -		xfs_setattr_mode(ip, iattr);
> -	if (mask & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
> -		xfs_setattr_time(ip, iattr);
> -
> +	setattr_copy(inode, iattr);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  	XFS_STATS_INC(mp, xs_ig_attrchg);
> @@ -1025,11 +978,8 @@ xfs_setattr_size(
>  		xfs_inode_clear_eofblocks_tag(ip);
>  	}
>  
> -	if (iattr->ia_valid & ATTR_MODE)
> -		xfs_setattr_mode(ip, iattr);
> -	if (iattr->ia_valid & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
> -		xfs_setattr_time(ip, iattr);
> -
> +	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
> +	setattr_copy(inode, iattr);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  	XFS_STATS_INC(mp, xs_ig_attrchg);
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index f3082a957d5e..ae61094bc9d1 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -283,7 +283,8 @@ xfs_fs_commit_blocks(
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
> -	xfs_setattr_time(ip, iattr);
> +	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
> +	setattr_copy(inode, iattr);
>  	if (update_isize) {
>  		i_size_write(inode, iattr->ia_size);
>  		ip->i_d.di_size = iattr->ia_size;
> -- 
> 2.25.1
> 
