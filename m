Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE60C4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08BF22388E
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgLGRTI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:19:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726247AbgLGRTI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 12:19:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607361456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OJJaH2X1b7HPNqQLG91iKKiQ4n1vn/f/KKcJ7buxGHY=;
        b=ChwqxmUZrS+IVeP3+Sb3K5Y2M1Y7cKO4JaQuDl3ER01eHdpK6RIGQ6Bt7mT67K6Lu68kRA
        XLvVtRcMOgN3G4Z1HJadp4iE8m5Abbd2SXkku4CUnsB7ewPQpGYrv/nfHTSbrOijJWDdhs
        rrIZAxkTH+evp+rlE0mpgJGVNS+NQ2s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-zW34LzhsOECkxUlQHxwmMw-1; Mon, 07 Dec 2020 12:17:34 -0500
X-MC-Unique: zW34LzhsOECkxUlQHxwmMw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69BF9800D53;
        Mon,  7 Dec 2020 17:17:32 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B73303CC9;
        Mon,  7 Dec 2020 17:17:31 +0000 (UTC)
Date:   Mon, 7 Dec 2020 12:17:29 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: move kernel-specific superblock validation out
 of libxfs
Message-ID: <20201207171729.GE1585352@bfoster>
References: <160729616025.1606994.13590463307385382944.stgit@magnolia>
 <160729616682.1606994.13360186718552701085.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729616682.1606994.13360186718552701085.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 06, 2020 at 03:09:26PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> A couple of the superblock validation checks apply only to the kernel,
> so move them to xfs_fc_fill_super before we add the needsrepair "feature",
> which will prevent the kernel (but not xfsprogs) from mounting the
> filesystem.  This also reduces the diff between kernel and userspace
> libxfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_sb.c |   27 ---------------------------
>  fs/xfs/xfs_super.c     |   32 ++++++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+), 27 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 5aeafa59ed27..05359690aaed 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -382,17 +382,6 @@ xfs_validate_sb_common(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	/*
> -	 * Until this is fixed only page-sized or smaller data blocks work.
> -	 */
> -	if (unlikely(sbp->sb_blocksize > PAGE_SIZE)) {
> -		xfs_warn(mp,
> -		"File system with blocksize %d bytes. "
> -		"Only pagesize (%ld) or less will currently work.",
> -				sbp->sb_blocksize, PAGE_SIZE);
> -		return -ENOSYS;
> -	}
> -
>  	/*
>  	 * Currently only very few inode sizes are supported.
>  	 */
> @@ -408,22 +397,6 @@ xfs_validate_sb_common(
>  		return -ENOSYS;
>  	}
>  
> -	if (xfs_sb_validate_fsb_count(sbp, sbp->sb_dblocks) ||
> -	    xfs_sb_validate_fsb_count(sbp, sbp->sb_rblocks)) {
> -		xfs_warn(mp,
> -		"file system too large to be mounted on this system.");
> -		return -EFBIG;
> -	}
> -
> -	/*
> -	 * Don't touch the filesystem if a user tool thinks it owns the primary
> -	 * superblock.  mkfs doesn't clear the flag from secondary supers, so
> -	 * we don't check them at all.
> -	 */
> -	if (XFS_BUF_ADDR(bp) == XFS_SB_DADDR && sbp->sb_inprogress) {
> -		xfs_warn(mp, "Offline file system operation in progress!");
> -		return -EFSCORRUPTED;
> -	}
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e3e229e52512..599566c1a3b4 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1467,6 +1467,38 @@ xfs_fc_fill_super(
>  #endif
>  	}
>  
> +	/*
> +	 * Don't touch the filesystem if a user tool thinks it owns the primary
> +	 * superblock.  mkfs doesn't clear the flag from secondary supers, so
> +	 * we don't check them at all.
> +	 */
> +	if (mp->m_sb.sb_inprogress) {
> +		xfs_warn(mp, "Offline file system operation in progress!");
> +		error = -EFSCORRUPTED;
> +		goto out_free_sb;
> +	}
> +
> +	/*
> +	 * Until this is fixed only page-sized or smaller data blocks work.
> +	 */
> +	if (mp->m_sb.sb_blocksize > PAGE_SIZE) {
> +		xfs_warn(mp,
> +		"File system with blocksize %d bytes. "
> +		"Only pagesize (%ld) or less will currently work.",
> +				mp->m_sb.sb_blocksize, PAGE_SIZE);
> +		error = -ENOSYS;
> +		goto out_free_sb;
> +	}
> +
> +	/* Ensure this filesystem fits in the page cache limits */
> +	if (xfs_sb_validate_fsb_count(&mp->m_sb, mp->m_sb.sb_dblocks) ||
> +	    xfs_sb_validate_fsb_count(&mp->m_sb, mp->m_sb.sb_rblocks)) {
> +		xfs_warn(mp,
> +		"file system too large to be mounted on this system.");
> +		error = -EFBIG;
> +		goto out_free_sb;
> +	}
> +
>  	/*
>  	 * XFS block mappings use 54 bits to store the logical block offset.
>  	 * This should suffice to handle the maximum file size that the VFS
> 

