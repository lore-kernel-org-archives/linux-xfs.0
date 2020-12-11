Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95ADBC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 17:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6502622257
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 17:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394724AbgLKQSt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Dec 2020 11:18:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393314AbgLKQSk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Dec 2020 11:18:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607703433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V53eU1CfrZryQ8+ME1zfqJJ5Qxpb2/FOC7dkCcjkOgc=;
        b=PbKszqne0lEDU8bw8Juzpkfr/1/Sfs/ZO+KDaiub1C/r9A/UckS5yHD3zw9tf3u0X908bY
        xAPJGuoqm3MOevgKshmUocv/MBu6ZeOzooKwAgzG4kNLva4O5Yo2UZ14L6u0TPEkb6YLh4
        jR0NGeXxiLhaDV4YF+KEJ6NGUod6HAs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-sM0PSBHsMXi7JIlAofIohA-1; Fri, 11 Dec 2020 11:17:12 -0500
X-MC-Unique: sM0PSBHsMXi7JIlAofIohA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 128DF800D53;
        Fri, 11 Dec 2020 16:17:11 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AFDB06F98E;
        Fri, 11 Dec 2020 16:17:10 +0000 (UTC)
Date:   Fri, 11 Dec 2020 11:17:09 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: open code updating i_mode in xfs_set_acl
Message-ID: <20201211161709.GG2032335@bfoster>
References: <20201210054821.2704734-1-hch@lst.de>
 <20201210054821.2704734-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210054821.2704734-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 10, 2020 at 06:48:21AM +0100, Christoph Hellwig wrote:
> Rather than going through the big and hairy xfs_setattr_nonsize function,
> just open code a transactional i_mode and i_ctime update.  This allows
> to mark xfs_setattr_nonsize and remove the flags argument to it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_acl.c  | 40 ++++++++++++++++++++++------------------
>  fs/xfs/xfs_iops.c | 11 +++++------
>  fs/xfs/xfs_iops.h |  7 -------
>  3 files changed, 27 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index c544951a0c07f3..779cb73b3d006f 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
...
> @@ -212,21 +213,28 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  }
>  
>  static int
> -xfs_set_mode(struct inode *inode, umode_t mode)
> +xfs_acl_set_mode(
> +	struct inode		*inode,
> +	umode_t			mode)
>  {
> -	int error = 0;
> -
> -	if (mode != inode->i_mode) {
> -		struct iattr iattr;
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
> +	int			error;
>  
> -		iattr.ia_valid = ATTR_MODE | ATTR_CTIME;
> -		iattr.ia_mode = mode;
> -		iattr.ia_ctime = current_time(inode);
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
> +	if (error)
> +		return error;
>  
> -		error = xfs_setattr_nonsize(XFS_I(inode), &iattr, XFS_ATTR_NOACL);
> -	}
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +	inode->i_mode = mode;

Do we need to care about carrying the S_IFMT protection logic in
xfs_setattr_mode()? It looks like perhaps not from a quick scan through
the acl helper, but want to confirm this change was intentional. If so,
explanation in the commit log would be nice for historical clarity.
Otherwise looks reasonable..

Brian

> +	inode->i_ctime = current_time(inode);
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
> -	return error;
> +	if (mp->m_flags & XFS_MOUNT_WSYNC)
> +		xfs_trans_set_sync(tp);
> +	return xfs_trans_commit(tp);
>  }
>  
>  int
> @@ -251,18 +259,14 @@ xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  	}
>  
>   set_acl:
> -	error =  __xfs_set_acl(inode, acl, type);
> -	if (error)
> -		return error;
> -
>  	/*
>  	 * We set the mode after successfully updating the ACL xattr because the
>  	 * xattr update can fail at ENOSPC and we don't want to change the mode
>  	 * if the ACL update hasn't been applied.
>  	 */
> -	if (set_mode)
> -		error = xfs_set_mode(inode, mode);
> -
> +	error =  __xfs_set_acl(inode, acl, type);
> +	if (!error && set_mode && mode != inode->i_mode)
> +		error = xfs_acl_set_mode(inode, mode);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 54c7c94f82951b..88d6dbeb81e9ca 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -648,11 +648,10 @@ xfs_vn_change_ok(
>   * Caution: The caller of this function is responsible for calling
>   * setattr_prepare() or otherwise verifying the change is fine.
>   */
> -int
> +static int
>  xfs_setattr_nonsize(
>  	struct xfs_inode	*ip,
> -	struct iattr		*iattr,
> -	int			flags)
> +	struct iattr		*iattr)
>  {
>  	xfs_mount_t		*mp = ip->i_mount;
>  	struct inode		*inode = VFS_I(ip);
> @@ -809,7 +808,7 @@ xfs_setattr_nonsize(
>  	 *	     to attr_set.  No previous user of the generic
>  	 * 	     Posix ACL code seems to care about this issue either.
>  	 */
> -	if ((mask & ATTR_MODE) && !(flags & XFS_ATTR_NOACL)) {
> +	if (mask & ATTR_MODE) {
>  		error = posix_acl_chmod(inode, inode->i_mode);
>  		if (error)
>  			return error;
> @@ -865,7 +864,7 @@ xfs_setattr_size(
>  		 * Use the regular setattr path to update the timestamps.
>  		 */
>  		iattr->ia_valid &= ~ATTR_SIZE;
> -		return xfs_setattr_nonsize(ip, iattr, 0);
> +		return xfs_setattr_nonsize(ip, iattr);
>  	}
>  
>  	/*
> @@ -1076,7 +1075,7 @@ xfs_vn_setattr(
>  
>  		error = xfs_vn_change_ok(dentry, iattr);
>  		if (!error)
> -			error = xfs_setattr_nonsize(ip, iattr, 0);
> +			error = xfs_setattr_nonsize(ip, iattr);
>  	}
>  
>  	return error;
> diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
> index a91e2d1b47b45d..99ca745c1071bf 100644
> --- a/fs/xfs/xfs_iops.h
> +++ b/fs/xfs/xfs_iops.h
> @@ -13,14 +13,7 @@ extern const struct file_operations xfs_dir_file_operations;
>  
>  extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
>  
> -/*
> - * Internal setattr interfaces.
> - */
> -#define XFS_ATTR_NOACL		0x01	/* Don't call posix_acl_chmod */
> -
>  extern void xfs_setattr_time(struct xfs_inode *ip, struct iattr *iattr);
> -extern int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap,
> -			       int flags);
>  extern int xfs_vn_setattr_size(struct dentry *dentry, struct iattr *vap);
>  
>  #endif /* __XFS_IOPS_H__ */
> -- 
> 2.29.2
> 

