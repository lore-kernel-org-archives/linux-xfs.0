Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DEC3C433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 17:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83F4661177
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 17:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhENRZs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 May 2021 13:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhENRZs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 May 2021 13:25:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C0A26144C
        for <linux-xfs@vger.kernel.org>; Fri, 14 May 2021 17:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621013076;
        bh=eiEQ36GoDT7nWRDfG/7S6yVl2MtNct06LQzmUZTWbAs=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=eCpOsLDx0RVjMm9LKKtyIhJY3Dy98ekiGxjIL8VL1H5D715C4K0OXiUyozgc8wXRb
         D6nL5qlZC4qSYORzM+eFoitsI+b8+pk45DGVg4u4GQlga+OUVZ848vTVa37nFgvNZ1
         mdBq32ZqnUQX4TGPPgE6cdyo48WgDzzvR3lShs2ggcekldFp6+xBf5/T930Te9gy1A
         zIpnoPN5p+o/dKZGtBSRMSuQ2Yg4oWiLfaMZRTvwXTFlW2FSKhiaxgeCQXHV8pN+4/
         8kGzaw8NdMNeuwPNYg9CQfkkZQIXxtNIskotcRjUr91ulTYpURU7znh+re/vBMQipA
         EimobeI3W+bGw==
Date:   Fri, 14 May 2021 10:24:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: apply rt extent alignment constraints to cow
 extsize hint
Message-ID: <20210514172435.GM9675@magnolia>
References: <162086770193.3685783.14418051698714099173.stgit@magnolia>
 <162086772452.3685783.890036737343315171.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162086772452.3685783.890036737343315171.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 06:02:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Even though reflink and copy-on-write aren't supported on the realtime
> volume, if we ever turn that on, we'd still be constrained to the same
> rt extent alignment requirements because cow involves remapping, and
> we can only allocate and free in rtextsize units on the realtime volume.
> 
> At the moment there aren't any filesystems with rt and reflink in the
> wild, so this is should be a zero-risk change.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Self NAK; one cannot set a nonzero cowextsize hint on a non-reflink
filesystem, and outside of djwong-dev, reflink on realtime isn't
supported either.  I guess I got too enthusiastic when I was
redistributing patches. :(

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 25261dd73290..704faf806e46 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -628,14 +628,21 @@ xfs_inode_validate_cowextsize(
>  	uint16_t			flags,
>  	uint64_t			flags2)
>  {
> -	bool				rt_flag;
> +	bool				rt_flag, rtinherit_flag;
>  	bool				hint_flag;
>  	uint32_t			cowextsize_bytes;
> +	uint32_t			blocksize_bytes;
>  
>  	rt_flag = (flags & XFS_DIFLAG_REALTIME);
> +	rtinherit_flag = (flags & XFS_DIFLAG_RTINHERIT);
>  	hint_flag = (flags2 & XFS_DIFLAG2_COWEXTSIZE);
>  	cowextsize_bytes = XFS_FSB_TO_B(mp, cowextsize);
>  
> +	if (rt_flag || (rtinherit_flag && hint_flag))
> +		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
> +	else
> +		blocksize_bytes = mp->m_sb.sb_blocksize;
> +
>  	if (hint_flag && !xfs_sb_version_hasreflink(&mp->m_sb))
>  		return __this_address;
>  
> @@ -652,13 +659,13 @@ xfs_inode_validate_cowextsize(
>  	if (hint_flag && rt_flag)
>  		return __this_address;
>  
> -	if (cowextsize_bytes % mp->m_sb.sb_blocksize)
> +	if (cowextsize_bytes % blocksize_bytes)
>  		return __this_address;
>  
>  	if (cowextsize > MAXEXTLEN)
>  		return __this_address;
>  
> -	if (cowextsize > mp->m_sb.sb_agblocks / 2)
> +	if (!rt_flag && cowextsize > mp->m_sb.sb_agblocks / 2)
>  		return __this_address;
>  
>  	return NULL;
> 
