Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29820C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 01:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E95E522D07
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 01:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732275AbhALBjI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:39:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:54772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732269AbhALBjI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 20:39:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D7CB22D07;
        Tue, 12 Jan 2021 01:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610415507;
        bh=hV3ehIBP8VGChzW5hJmNZTw7r+B2WTRyD8Ue2/5eP4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PdYHx1tvGgsfz/XzDkgdh4ubbXbwxU8EheUJ/Nj4WmzRFgiE+3IRyNiwbfdi+hInR
         Uwvdn5cfrbbpUerFslcHbbqtXtHeNsCW5PPTyuixGCA8BFB7SALKKxpPZgsN7YuSmw
         H6O5Cl2rb5VsIpiak8eLYuM6yb9JcjW+EqIoOYF1UpSNJ1KL7hcfVwf4+yxpHcQU9Q
         61rXUSUV+ogdSVYF/c1CrJZdunmmaeXC3KouKpRU0L5dPWteLzh9T0EJ2JMA0lqBVc
         GDAeKpIlhUmEuKHg8pQUfB8o4hqTY/AwmRnis3L20IQGC0ziyaOFcsJOpP+r209JHc
         nGlGNRg7N3wjw==
Date:   Mon, 11 Jan 2021 17:38:26 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com, hch@lst.de,
        allison.henderson@oracle.com
Subject: Re: [PATCH V14 05/16] xfs: Check for extent overflow when removing
 dir entries
Message-ID: <20210112013826.GM1164246@magnolia>
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
 <20210110160720.3922965-6-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210110160720.3922965-6-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 10, 2021 at 09:37:09PM +0530, Chandan Babu R wrote:
> Directory entry removal must always succeed; Hence XFS does the
> following during low disk space scenario:
> 1. Data/Free blocks linger until a future remove operation.
> 2. Dabtree blocks would be swapped with the last block in the leaf space
>    and then the new last block will be unmapped.
> 
> This facility is reused during low inode extent count scenario i.e. this
> commit causes xfs_bmap_del_extent_real() to return -ENOSPC error code so
> that the above mentioned behaviour is exercised causing no change to the
> directory's extent count.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Thanks for the minor tweaks since v12,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 32aeacf6f055..6c8f17a0e247 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5151,6 +5151,24 @@ xfs_bmap_del_extent_real(
>  		/*
>  		 * Deleting the middle of the extent.
>  		 */
> +
> +		/*
> +		 * For directories, -ENOSPC is returned since a directory entry
> +		 * remove operation must not fail due to low extent count
> +		 * availability. -ENOSPC will be handled by higher layers of XFS
> +		 * by letting the corresponding empty Data/Free blocks to linger
> +		 * until a future remove operation. Dabtree blocks would be
> +		 * swapped with the last block in the leaf space and then the
> +		 * new last block will be unmapped.
> +		 */
> +		error = xfs_iext_count_may_overflow(ip, whichfork, 1);
> +		if (error) {
> +			ASSERT(S_ISDIR(VFS_I(ip)->i_mode) &&
> +				whichfork == XFS_DATA_FORK);
> +			error = -ENOSPC;
> +			goto done;
> +		}
> +
>  		old = got;
>  
>  		got.br_blockcount = del->br_startoff - got.br_startoff;
> -- 
> 2.29.2
> 
