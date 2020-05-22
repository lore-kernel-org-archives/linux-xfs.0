Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B5DC433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D86BF206C3
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:03:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R8rCA3HI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgEVMD0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 08:03:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29792 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728356AbgEVMD0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 08:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590149004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KOvX2cSUc+1aFv0oHTJDwG7Kisk5PMhXoIW5cBCW3+o=;
        b=R8rCA3HIGCtOr+61cdu8LYPTvvXUfIokzJQFBk50UQ5NB+H+pKh1OYE1GKGHnZN5EjO8F/
        4NWv/L17ZNCeBcxnYsZAuZWblvaGIxsr+Nkp4HzpKl55Yv9LGkngKKjdANGxusL0GgzpkI
        Hg8WlvIAFwuPqXhQI+sYjspE/bE25w0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-JU5xexmlPW6fGlATHWlo_g-1; Fri, 22 May 2020 08:03:21 -0400
X-MC-Unique: JU5xexmlPW6fGlATHWlo_g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55C023626D;
        Fri, 22 May 2020 12:03:16 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E31D5D9CC;
        Fri, 22 May 2020 12:03:15 +0000 (UTC)
Date:   Fri, 22 May 2020 08:03:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs: move eofblocks conversion function to
 xfs_ioctl.c
Message-ID: <20200522120313.GB50656@bfoster>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
 <159011601269.77079.3759128420308877436.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011601269.77079.3759128420308877436.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:53:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move xfs_fs_eofblocks_from_user into the only file that actually uses
> it, so that we don't have this function cluttering up the header file.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.h |   35 -----------------------------------
>  fs/xfs/xfs_ioctl.c  |   35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+), 35 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index 48f1fd2bb6ad..c13bc8a3e02f 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -81,41 +81,6 @@ int xfs_inode_ag_iterator_tag(struct xfs_mount *mp,
>  	int (*execute)(struct xfs_inode *ip, int flags, void *args),
>  	int flags, void *args, int tag);
>  
> -static inline int
> -xfs_fs_eofblocks_from_user(
> -	struct xfs_fs_eofblocks		*src,
> -	struct xfs_eofblocks		*dst)
> -{
> -	if (src->eof_version != XFS_EOFBLOCKS_VERSION)
> -		return -EINVAL;
> -
> -	if (src->eof_flags & ~XFS_EOF_FLAGS_VALID)
> -		return -EINVAL;
> -
> -	if (memchr_inv(&src->pad32, 0, sizeof(src->pad32)) ||
> -	    memchr_inv(src->pad64, 0, sizeof(src->pad64)))
> -		return -EINVAL;
> -
> -	dst->eof_flags = src->eof_flags;
> -	dst->eof_prid = src->eof_prid;
> -	dst->eof_min_file_size = src->eof_min_file_size;
> -
> -	dst->eof_uid = INVALID_UID;
> -	if (src->eof_flags & XFS_EOF_FLAGS_UID) {
> -		dst->eof_uid = make_kuid(current_user_ns(), src->eof_uid);
> -		if (!uid_valid(dst->eof_uid))
> -			return -EINVAL;
> -	}
> -
> -	dst->eof_gid = INVALID_GID;
> -	if (src->eof_flags & XFS_EOF_FLAGS_GID) {
> -		dst->eof_gid = make_kgid(current_user_ns(), src->eof_gid);
> -		if (!gid_valid(dst->eof_gid))
> -			return -EINVAL;
> -	}
> -	return 0;
> -}
> -
>  int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
>  				  xfs_ino_t ino, bool *inuse);
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 309958186d33..6a3c675a8aeb 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -2082,6 +2082,41 @@ xfs_ioc_setlabel(
>  	return error;
>  }
>  
> +static inline int
> +xfs_fs_eofblocks_from_user(
> +	struct xfs_fs_eofblocks		*src,
> +	struct xfs_eofblocks		*dst)
> +{
> +	if (src->eof_version != XFS_EOFBLOCKS_VERSION)
> +		return -EINVAL;
> +
> +	if (src->eof_flags & ~XFS_EOF_FLAGS_VALID)
> +		return -EINVAL;
> +
> +	if (memchr_inv(&src->pad32, 0, sizeof(src->pad32)) ||
> +	    memchr_inv(src->pad64, 0, sizeof(src->pad64)))
> +		return -EINVAL;
> +
> +	dst->eof_flags = src->eof_flags;
> +	dst->eof_prid = src->eof_prid;
> +	dst->eof_min_file_size = src->eof_min_file_size;
> +
> +	dst->eof_uid = INVALID_UID;
> +	if (src->eof_flags & XFS_EOF_FLAGS_UID) {
> +		dst->eof_uid = make_kuid(current_user_ns(), src->eof_uid);
> +		if (!uid_valid(dst->eof_uid))
> +			return -EINVAL;
> +	}
> +
> +	dst->eof_gid = INVALID_GID;
> +	if (src->eof_flags & XFS_EOF_FLAGS_GID) {
> +		dst->eof_gid = make_kgid(current_user_ns(), src->eof_gid);
> +		if (!gid_valid(dst->eof_gid))
> +			return -EINVAL;
> +	}
> +	return 0;
> +}
> +
>  /*
>   * Note: some of the ioctl's return positive numbers as a
>   * byte count indicating success, such as readlink_by_handle.
> 

