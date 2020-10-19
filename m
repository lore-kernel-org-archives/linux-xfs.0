Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E11C433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 12:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9315222C3
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 12:53:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kZnwKSJi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgJSMxX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 08:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbgJSMxX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 08:53:23 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0604EC0613CE
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 05:53:23 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b26so5969341pff.3
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 05:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e9wHWVm7IYDhdEKRFTegB++WOBk7N+d9Vl1ksreQhTM=;
        b=kZnwKSJiHAQK2LqghvEOwfQC8MJtYp9YgxSA+gdjQ3/ixG2G9490lYD9jhNA4LSoHb
         bBpu/0PBoCZTKoGn/7EPpF4BwPxlstmNqDHVxocOV5Uh8yI2UKGNLV9R5d3p6b5+BzCC
         iIx1EAbSYjctenFBMHIJXC+XXdiLSuZNkvPbmz/ebmNBUKTHG+EKfaK93LB3nrIKT4D5
         NRKdfTp5GgbzUFV90SZfjcAOIgX1gyKXf6D7xv85c7r+qtRoQz0xmrrK+hWuoC0tJvoP
         amWZOSfv4TXyQqNZsNtBMOlPg3at3ZRSJOXRwVhjYrKlu1rz07HiHrno0lhqH26nGMp9
         TYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e9wHWVm7IYDhdEKRFTegB++WOBk7N+d9Vl1ksreQhTM=;
        b=k6m7/9TwKMGAh+o2SSKMV/2Pr3beOCy4uJiIMXJK/iVmV/rOn9r73S2e8enyqRJQFZ
         FEkQO5F9VdyLzhb03stGvMQwMJTKADXVkfsl/5MI/hVYutWy2uNwxVgllr7rX/KrM8vc
         b8qeI1aNXICOjHToTCyTqS8IwXwPoR0TaOxpt+pSRCefFcbOjenjtTq3oYVeA/wRaFi7
         r59nXyljjcBF0o2bUayVlOSA7eYErxxqxJ6yGfh3j0lyLjERzytyrrODW/r0eOsw+WVC
         Jnj8QSE0XRK/S30wa48PsZA4+Xw7Hu3Yh259dMPmyBV8vMJX3QYqgaTEvHFmns0lS6fz
         4ZdQ==
X-Gm-Message-State: AOAM530GdzwuCwT0EJbUFbAvGK0OkRYFDlc4PetgeK5dzKn63DfyGY9A
        wnrtop4pFZPM1VGcF9h8nXGx4RArDVE=
X-Google-Smtp-Source: ABdhPJzbHLDD2WYT0gvaxS6/x4ulmEqx2OlywBWglEwZCB8ZX3kMpbxa9LphuMJr2IzMxEtY4q8pQA==
X-Received: by 2002:a63:ef51:: with SMTP id c17mr13984843pgk.36.1603112002211;
        Mon, 19 Oct 2020 05:53:22 -0700 (PDT)
Received: from garuda.localnet ([122.179.121.224])
        by smtp.gmail.com with ESMTPSA id z26sm13227065pfq.131.2020.10.19.05.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 05:53:21 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: fix fallocate functions when rtextsize is larger than 1
Date:   Mon, 19 Oct 2020 18:23:18 +0530
Message-ID: <7823013.Vx44o5y9Va@garuda>
In-Reply-To: <20201017215011.GG9832@magnolia>
References: <20201017215011.GG9832@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday 18 October 2020 3:20:11 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit fe341eb151ec, I forgot that xfs_free_file_space isn't strictly
> a "remove mapped blocks" function.  It is actually a function to zero
> file space by punching out the middle and writing zeroes to the
> unaligned ends of the specified range.  Therefore, putting a rtextsize
> alignment check in that function is wrong because that breaks unaligned
> ZERO_RANGE on the realtime volume.
> 
> Furthermore, xfs_file_fallocate already has alignment checks for the
> functions require the file range to be aligned to the size of a
> fundamental allocation unit (which is 1 FSB on the data volume and 1 rt
> extent on the realtime volume).  Create a new helper to check fallocate
> arguments against the realtiem allocation unit size, fix the fallocate
> frontend to use it, fix free_file_space to delete the correct range, and
> remove a now redundant check from insert_file_space.
> 
> NOTE: The realtime extent size is not required to be a power of two!
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Fixes: fe341eb151ec ("xfs: ensure that fpunch, fcollapse, and finsert operations are aligned to rt extent size")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: fix this to actually handle rtextsize not being a power of 2, add
> testcase
> ---
>  fs/xfs/xfs_bmap_util.c |   17 ++++-------------
>  fs/xfs/xfs_file.c      |   40 +++++++++++++++++++++++++++++++++++-----
>  2 files changed, 39 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index f2a8a0e75e1f..52cddcfee8a1 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -947,11 +947,10 @@ xfs_free_file_space(
>  	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);
>  
>  	/* We can only free complete realtime extents. */
> -	if (XFS_IS_REALTIME_INODE(ip)) {
> -		xfs_extlen_t	extsz = xfs_get_extsz_hint(ip);
> -
> -		if ((startoffset_fsb | endoffset_fsb) & (extsz - 1))
> -			return -EINVAL;
> +	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 0) {
> +		startoffset_fsb = round_up(startoffset_fsb,
> +					   mp->m_sb.sb_rextsize);
> +		endoffset_fsb = round_down(endoffset_fsb, mp->m_sb.sb_rextsize);
>  	}
>  
>  	/*
> @@ -1147,14 +1146,6 @@ xfs_insert_file_space(
>  
>  	trace_xfs_insert_file_space(ip);
>  
> -	/* We can only insert complete realtime extents. */
> -	if (XFS_IS_REALTIME_INODE(ip)) {
> -		xfs_extlen_t	extsz = xfs_get_extsz_hint(ip);
> -
> -		if ((stop_fsb | shift_fsb) & (extsz - 1))
> -			return -EINVAL;
> -	}
> -
>  	error = xfs_bmap_can_insert_extents(ip, stop_fsb, shift_fsb);
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 3d1b95124744..9e97815887c5 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -785,6 +785,39 @@ xfs_break_layouts(
>  	return error;
>  }
>  
> +/*
> + * Decide if the given file range is aligned to the size of the fundamental
> + * allocation unit for the file.
> + */
> +static bool
> +xfs_is_falloc_aligned(
> +	struct xfs_inode	*ip,
> +	loff_t			pos,
> +	long long int		len)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	uint64_t		mask;
> +
> +	if (XFS_IS_REALTIME_INODE(ip)) {
> +		if (!is_power_of_2(mp->m_sb.sb_rextsize)) {
> +			u64	rextbytes;
> +			u32	mod;
> +
> +			rextbytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
> +			div_u64_rem(pos, rextbytes, &mod);
> +			if (mod)
> +				return false;
> +			div_u64_rem(len, rextbytes, &mod);
> +			return mod == 0;
> +		}
> +		mask = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize) - 1;
> +	} else {
> +		mask = mp->m_sb.sb_blocksize - 1;
> +	}
> +
> +	return !((pos | len) & mask);
> +}
> +
>  #define	XFS_FALLOC_FL_SUPPORTED						\
>  		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
>  		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
> @@ -850,9 +883,7 @@ xfs_file_fallocate(
>  		if (error)
>  			goto out_unlock;
>  	} else if (mode & FALLOC_FL_COLLAPSE_RANGE) {
> -		unsigned int blksize_mask = i_blocksize(inode) - 1;
> -
> -		if (offset & blksize_mask || len & blksize_mask) {
> +		if (!xfs_is_falloc_aligned(ip, offset, len)) {
>  			error = -EINVAL;
>  			goto out_unlock;
>  		}
> @@ -872,10 +903,9 @@ xfs_file_fallocate(
>  		if (error)
>  			goto out_unlock;
>  	} else if (mode & FALLOC_FL_INSERT_RANGE) {
> -		unsigned int	blksize_mask = i_blocksize(inode) - 1;
>  		loff_t		isize = i_size_read(inode);
>  
> -		if (offset & blksize_mask || len & blksize_mask) {
> +		if (!xfs_is_falloc_aligned(ip, offset, len)) {
>  			error = -EINVAL;
>  			goto out_unlock;
>  		}
> 


-- 
chandan



