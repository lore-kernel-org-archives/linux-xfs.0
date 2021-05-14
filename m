Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E618C433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 12:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65558613E9
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 12:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbhENMj2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 May 2021 08:39:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33053 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232712AbhENMj2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 May 2021 08:39:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620995896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I65AQ22thdaf3yvNrq47sbO1IvGq+DYjGqQ5+eXzrlU=;
        b=QnWL5gt1XeJrTyDDJXw7CPE7ZX+7m5bzamMqGgE5/UAG6fP/Y3U0cyahHd+3HHsvBTBmqc
        +IeC11p/x2YfYwVk0iz+UkpZoYVnAfS1+7fSbWb2LaeIDr9XSMkWjrwGmB0uHaCnOmOdRg
        5PNKCtTwvPPnZ6I7Ydo+h/86ywClxoU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-mAe2wNgwOw6wDX-LvrBoFQ-1; Fri, 14 May 2021 08:38:15 -0400
X-MC-Unique: mAe2wNgwOw6wDX-LvrBoFQ-1
Received: by mail-qt1-f197.google.com with SMTP id f17-20020ac87f110000b02901e117339ea7so4931674qtk.16
        for <linux-xfs@vger.kernel.org>; Fri, 14 May 2021 05:38:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I65AQ22thdaf3yvNrq47sbO1IvGq+DYjGqQ5+eXzrlU=;
        b=J9DHXUC4Wb3rOlmu6nbajdnH9PtH7mkZVdawpjJW2ntTte5IVIqgTROwYnJ6IoOsTI
         6pr/DWo6svgF0emeESir37BvkridFn3Y+0dpgdL/UtvfQwZAWTjJ04OEcj5kdppYSq31
         wec4DiVnNAw7pAatYcZg7C6SzgUgc18BQrvB/R1JGurAxJzt0DiWybGrtO3QYlH38vFn
         ke9Ye59pycrLWusVQ2vDbFDsa4Ut7mA4kUQePkhrLo6g63qRjBhiTdJ7O5E8p12iS33B
         YLB1TG+NpapQwypZOIm9rLunjaV6iutwNXgFRWB1RQH3ojZOiFT9osnGs9eA84cVFWqg
         xYZg==
X-Gm-Message-State: AOAM531Bqrl5uKChVlUuO4NS4eNpElq5hxU8IqHT+FW7SZEG3m1iOVB1
        sBmZkEKVj3n1m6UzYFOWE7FYfwl/Pv4I1USng1fn/PDvi5/+R/VPJbmzRIJyqXescuWlgTuq4oI
        H1eIFnmnejWkWQHrstjG0
X-Received: by 2002:a05:622a:15c1:: with SMTP id d1mr23587838qty.111.1620995894728;
        Fri, 14 May 2021 05:38:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkc+7N8DWQldEVONT8PiT7KC7UR+b2m5jYx9TgdIKW3Xshtznn/ezYmtcdSliBe62EOTUQ3w==
X-Received: by 2002:a05:622a:15c1:: with SMTP id d1mr23587819qty.111.1620995894440;
        Fri, 14 May 2021 05:38:14 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id r72sm4784255qka.18.2021.05.14.05.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 05:38:14 -0700 (PDT)
Date:   Fri, 14 May 2021 08:38:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: standardize extent size hint validation
Message-ID: <YJ5vNFn/qE97cmgB@bfoster>
References: <162086770193.3685783.14418051698714099173.stgit@magnolia>
 <162086770773.3685783.9402329351753257007.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162086770773.3685783.9402329351753257007.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 06:01:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While chasing a bug involving invalid extent size hints being propagated
> into newly created realtime files, I noticed that the xfs_ioctl_setattr
> checks for the extent size hints weren't the same as the ones now
> encoded in libxfs and used for validation in repair and mkfs.
> 
> Because the checks in libxfs are more stringent than the ones in the
> ioctl, it's possible for a live system to set inode flags that
> immediately result in corruption warnings.  Specifically, it's possible
> to set an extent size hint on an rtinherit directory without checking if
> the hint is aligned to the realtime extent size, which makes no sense
> since that combination is used only to seed new realtime files.
> 
> Replace the open-coded and inadequate checks with the libxfs verifier
> versions.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_ioctl.c |   90 +++++++++++-----------------------------------------
>  1 file changed, 19 insertions(+), 71 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 3925bfcb2365..44d55ebdea09 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1266,108 +1266,56 @@ xfs_ioctl_setattr_get_trans(
>  	return ERR_PTR(error);
>  }
>  
> -/*
> - * extent size hint validation is somewhat cumbersome. Rules are:
> - *
> - * 1. extent size hint is only valid for directories and regular files
> - * 2. FS_XFLAG_EXTSIZE is only valid for regular files
> - * 3. FS_XFLAG_EXTSZINHERIT is only valid for directories.
> - * 4. can only be changed on regular files if no extents are allocated
> - * 5. can be changed on directories at any time
> - * 6. extsize hint of 0 turns off hints, clears inode flags.
> - * 7. Extent size must be a multiple of the appropriate block size.
> - * 8. for non-realtime files, the extent size hint must be limited
> - *    to half the AG size to avoid alignment extending the extent beyond the
> - *    limits of the AG.
> - *
> - * Please keep this function in sync with xfs_scrub_inode_extsize.
> - */

The comments for the corresponding xfs_inode_validate_*() functions
actually refer back to the comments for these functions by name as
documentation for the hint rules. We should probably fix that side up
one way or another if this comment is going away. Otherwise the patch
looks good to me, so with that addressed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  static int
>  xfs_ioctl_setattr_check_extsize(
>  	struct xfs_inode	*ip,
>  	struct fileattr		*fa)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	xfs_extlen_t		size;
> -	xfs_fsblock_t		extsize_fsb;
> +	xfs_failaddr_t		failaddr;
> +	uint16_t		new_diflags;
>  
>  	if (!fa->fsx_valid)
>  		return 0;
>  
>  	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
> -	    ((ip->i_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
> +	    XFS_FSB_TO_B(mp, ip->i_extsize) != fa->fsx_extsize)
>  		return -EINVAL;
>  
> -	if (fa->fsx_extsize == 0)
> -		return 0;
> -
> -	extsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_extsize);
> -	if (extsize_fsb > MAXEXTLEN)
> +	if (fa->fsx_extsize & mp->m_blockmask)
>  		return -EINVAL;
>  
> -	if (XFS_IS_REALTIME_INODE(ip) ||
> -	    (fa->fsx_xflags & FS_XFLAG_REALTIME)) {
> -		size = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
> -	} else {
> -		size = mp->m_sb.sb_blocksize;
> -		if (extsize_fsb > mp->m_sb.sb_agblocks / 2)
> -			return -EINVAL;
> -	}
> -
> -	if (fa->fsx_extsize % size)
> -		return -EINVAL;
> +	new_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
>  
> -	return 0;
> +	failaddr = xfs_inode_validate_extsize(ip->i_mount,
> +			XFS_B_TO_FSB(mp, fa->fsx_extsize),
> +			VFS_I(ip)->i_mode, new_diflags);
> +	return failaddr != NULL ? -EINVAL : 0;
>  }
>  
> -/*
> - * CoW extent size hint validation rules are:
> - *
> - * 1. CoW extent size hint can only be set if reflink is enabled on the fs.
> - *    The inode does not have to have any shared blocks, but it must be a v3.
> - * 2. FS_XFLAG_COWEXTSIZE is only valid for directories and regular files;
> - *    for a directory, the hint is propagated to new files.
> - * 3. Can be changed on files & directories at any time.
> - * 4. CoW extsize hint of 0 turns off hints, clears inode flags.
> - * 5. Extent size must be a multiple of the appropriate block size.
> - * 6. The extent size hint must be limited to half the AG size to avoid
> - *    alignment extending the extent beyond the limits of the AG.
> - *
> - * Please keep this function in sync with xfs_scrub_inode_cowextsize.
> - */
>  static int
>  xfs_ioctl_setattr_check_cowextsize(
>  	struct xfs_inode	*ip,
>  	struct fileattr		*fa)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	xfs_extlen_t		size;
> -	xfs_fsblock_t		cowextsize_fsb;
> +	xfs_failaddr_t		failaddr;
> +	uint64_t		new_diflags2;
> +	uint16_t		new_diflags;
>  
>  	if (!fa->fsx_valid)
>  		return 0;
>  
> -	if (!(fa->fsx_xflags & FS_XFLAG_COWEXTSIZE))
> -		return 0;
> -
> -	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
> -		return -EINVAL;
> -
> -	if (fa->fsx_cowextsize == 0)
> -		return 0;
> -
> -	cowextsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_cowextsize);
> -	if (cowextsize_fsb > MAXEXTLEN)
> +	if (fa->fsx_cowextsize & mp->m_blockmask)
>  		return -EINVAL;
>  
> -	size = mp->m_sb.sb_blocksize;
> -	if (cowextsize_fsb > mp->m_sb.sb_agblocks / 2)
> -		return -EINVAL;
> -
> -	if (fa->fsx_cowextsize % size)
> -		return -EINVAL;
> +	new_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
> +	new_diflags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
>  
> -	return 0;
> +	failaddr = xfs_inode_validate_cowextsize(ip->i_mount,
> +			XFS_B_TO_FSB(mp, fa->fsx_cowextsize),
> +			VFS_I(ip)->i_mode, new_diflags, new_diflags2);
> +	return failaddr != NULL ? -EINVAL : 0;
>  }
>  
>  static int
> 

