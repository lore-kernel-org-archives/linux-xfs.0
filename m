Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36168C4361B
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 17:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F0BD23C44
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 17:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbgLIRKJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:10:09 -0500
Received: from sandeen.net ([63.231.237.45]:52156 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732387AbgLIRJj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Dec 2020 12:09:39 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D228A4C153F;
        Wed,  9 Dec 2020 11:08:11 -0600 (CST)
Subject: Re: [PATCH 1/3] xfs: move kernel-specific superblock validation out
 of libxfs
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, bfoster@redhat.com,
        david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
References: <160729616025.1606994.13590463307385382944.stgit@magnolia>
 <160729616682.1606994.13360186718552701085.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <25aeb16b-74ba-2c7e-abad-f49dbdd02591@sandeen.net>
Date:   Wed, 9 Dec 2020 11:08:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <160729616682.1606994.13360186718552701085.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/6/20 5:09 PM, Darrick J. Wong wrote:
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

Nice, I like this version :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

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
