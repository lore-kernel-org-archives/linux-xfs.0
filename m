Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54354 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbeLADG3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Nov 2018 22:06:29 -0500
Date: Fri, 30 Nov 2018 07:56:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix inverted return from xfs_btree_sblock_verify_crc
Message-ID: <20181130155639.GL8125@magnolia>
References: <28345031-dfa2-1d73-a36c-400e3c2333d1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28345031-dfa2-1d73-a36c-400e3c2333d1@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Nov 29, 2018 at 08:48:25PM -0600, Eric Sandeen wrote:
> xfs_btree_sblock_verify_crc is a bool so should not be returning
> a failaddr_t; worse, if xfs_log_check_lsn fails it returns
> __this_address which looks like a boolean true (i.e. success)
> to the caller.
> 
> (interestingly xfs_btree_lblock_verify_crc doesn't have the issue)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 34c6d7bd4d18..bbdae2b4559f 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -330,7 +330,7 @@ xfs_btree_sblock_verify_crc(
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn)))
> -			return __this_address;
> +			return false;
>  		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
>  	}
>  
> 
